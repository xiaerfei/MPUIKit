//
//  TVUPLRequestAPI.m
//  MyStreamDemo
//
//  Created by sharexia on 4/15/25.
//

#import "TVUPLRequestAPI.h"
#import "TVUPartylineRequest.h"
#import "TVUPLAPIManager.h"

@interface TVUPLRequestAPI ()

@property (nonatomic,   copy) NSString *raUrlString;
@property (nonatomic, assign) TVUPLRAType raType;
@property (nonatomic,   copy) id raParameter;
@property (nonatomic,   copy) NSString *raName;
@property (nonatomic,   copy) BOOL(^raThen)(TVUTuple *tuple);
@property (atomic, assign, readwrite) BOOL requesting;
@property (nonatomic, assign) BOOL raMainQueue;
///< 正在第 n 次重试
@property (nonatomic, assign, readwrite) NSInteger doRetryCount;
///< 正在第重试中...
@property (nonatomic, assign, readwrite) BOOL doRetrying;
@property (nonatomic, assign, readwrite) NSInteger requestId;

@property (nonatomic, weak) NSURLSessionDataTask *dataTask;

@property (nonatomic, weak) id <TVUPLRequestAPIProtocol> delegate;
@end

@implementation TVUPLRequestAPI

- (instancetype)init {
    self = [super init];
    if (self) {
        self.retryCount = 0;
        self.retryTime  = 0;
        self.requestId = [[TVUPLAPIManager manager] generateRequestId];
        if ([self conformsToProtocol:@protocol(TVUPLRequestAPIProtocol)]) {
            self.delegate = (id <TVUPLRequestAPIProtocol>) self;
        }
    }
    return self;
}

#pragma mark - Public Methods
+ (TVUPLRequestAPI *(^)(void))get {
    return ^{
        TVUPLRequestAPI *api = [self class].new;
        api.raType = TVUPLRATypeGET;
        return api;
    };
}
+ (TVUPLRequestAPI *(^)(void))post {
    return ^{
        TVUPLRequestAPI *api = [self class].new;
        api.raType = TVUPLRATypePOST;
        return api;
    };
}

- (TVUPLRequestAPI *(^)(void))get {
    return ^{
        self.raType = TVUPLRATypeGET;
        return self;
    };
}
- (TVUPLRequestAPI *(^)(void))post {
    return ^{
        self.raType = TVUPLRATypePOST;
        return self;
    };
}
/// 请求的方式：GET 或者 POST
- (TVUPLRequestAPI *(^)(TVUPLRAType type))method {
    return ^(TVUPLRAType type) {
        self.raType = type;
        return self;
    };
}
///< 请求的参数
+ (TVUPLRequestAPI *(^)(id param))parameter {
    return ^(id param){
        TVUPLRequestAPI *api = [self class].new;
        api.raParameter = param;
        return api;
    };
}
/// 请求的参数
- (TVUPLRequestAPI *(^)(id param))parameter {
    return ^(id param) {
        self.raParameter = param;
        return self;
    };
}
/// 请求的 URL
- (TVUPLRequestAPI *(^)(NSString *urlString))url {
    return ^(NSString *urlString) {
        self.raUrlString = urlString;
        return self;
    };
}
/// 请求结果回调是否在主线程
- (TVUPLRequestAPI *(^)(void))mainQueue {
    return ^{
        self.raMainQueue = YES;
        return self;
    };
}
/**
 *  设置 Retry 策略
 *  retry: 最大重试次数
 *  time: 重试间隔时间(最小间隔 0.1s，如果小于 0.1s，则默认 0.1s)
 */
- (TVUPLRequestAPI *(^)(NSInteger retry, NSTimeInterval time))retry {
    return ^(NSInteger retry, NSTimeInterval time) {
        self.retryCount = retry;
        self.retryTime  = time;
        return self;
    };
}
/**
 *  禁用 Retry，目前默认没有重试(你无需调用)
 */
- (TVUPLRequestAPI *(^)(void))noRetry {
    return ^{
        self.retryCount = 0;
        self.retryTime  = 0;
        return self;
    };
}
/**
 *  API 名称, 用于调试、log 使用
 */
- (TVUPLRequestAPI *(^)(NSString *name))name {
    return ^(NSString *name) {
        self.raName = name;
        return self;
    };
}
/**
 *  请求结果回调
 *  回调参数:
 *      请将 then 放到点语法的最后如：API.get().xxx.then(^(tuple) {});
 *      tuple[0] : API Class
 *      tuple[1] : 返回结果
 *      tuple[2] : error(默认 NSError *，但是你可以自定义返回类型如: NSString * 类型)
 *      tuple[3 ~ 9] : 自定义类型
 *  返回参数:
 *      如果返回 NO 则会触发 Retry
 *  注意:
 *      默认异步线程回调
 */
- (TVUPLRequestAPI *(^)(BOOL(^then)(TVUTuple *tuple)))then {
    return ^(BOOL(^then)(TVUTuple *tuple)){
        self.raThen = then;
        [self start];
        return self;
    };
}
/**
 *  同步返回, 请在异步线程使用(具体请看使用例子)
 *  tuple[0] : API Class
 *  tuple[1] : 返回结果
 *  tuple[2] : error(默认 NSError *，但是你可以自定义返回类型如: NSString * 类型)
 *  tuple[3 ~ ...] : 自定义类型
 */
- (TVUTuple *(^)(void))sync {
    return ^TVUTuple *(void){
        __block id customTuple = nil;
        
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        
        self.then(^BOOL(TVUTuple *tuple) {
            if ([self isRetryMaximumLimit]) {
                customTuple = tuple;
                dispatch_group_leave(group);
            }
            return NO;
        });
        
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        return customTuple;
    };
}

- (TVUPLRAType)requestMethod {
    return self.raType;
}
- (NSString *)requestURL {
    return self.raUrlString;
}
- (id)requestParameter {
    return self.raParameter;
}
- (NSString *)requestName {
    return self.raName;
}
/// 开始请求
- (void)start {
    void(^handler)(NSData *data,
                   NSURLResponse *response,
                   NSError *error) =
    ^(NSData *data,
      NSURLResponse *response,
      NSError *error) {
        [self response:response data:data error:error];
    };
    NSURLRequest *request = [self currentRequest];
    self.requesting = YES;
    NSLog(@"① 开始请求");
    if (request) {
        self.dataTask =
        [TVUPartylineRequest request:request
                   completionHandler:handler];
    } else {
        NSString *url = [self currentURLString];
        if ([self isStringNoNull:url] == NO) {
            NSError *error =
            [NSError errorWithDomain:@"TVUNetworkError"
                                code:-2001
                            userInfo:nil];
            handler(nil, nil, error);
            return;
        }
        id param      = [self currentParameter];
        self.dataTask =
        [TVUPartylineRequest requestWithUrl:url
                              andHTTPMethod:[self httpMethodString]
                                   andParam:param
                          completionHandler:handler];
    }
}
/// 取消本次请求也包括重试
- (void)stop {
    @synchronized (self) {
        [self.dataTask cancel];
        self.raThen = nil;
        [[TVUPLAPIManager manager] removeRetryWithAPI:self];        
    }
}

#pragma mark - Private Methods

- (NSString *)httpMethodString {
    if (self.raType == TVUPLRATypeGET) {
        return @"GET";
    } else {
        return @"POST";
    }
}

- (id)parseDataToObject:(NSData *)data {
    if ([data isKindOfClass:NSData.class] == NO ||
        data.length == 0) return nil;
    return [NSJSONSerialization JSONObjectWithData:data
                                           options:NSJSONReadingMutableContainers
                                             error:nil];
}

- (BOOL)isRetryMaximumLimit {
    @synchronized (self) {
        return self.doRetryCount > self.retryCount;
    }
}

- (NSString *)currentURLString {
    NSString *url = nil;
    if ([self.delegate respondsToSelector:@selector(customRequestURLString)]) {
        url = [self.delegate customRequestURLString];
    } else {
        url = self.raUrlString;
    }
    url = [NSString stringWithFormat:@"%@/%@",
           [TVUPartylineRequest domainString], url];
    return url;
}

- (id)currentParameter {
    if (self.raType == TVUPLRATypeGET) {
        return nil;
    }
    id param = nil;
    if ([self.delegate respondsToSelector:@selector(customRequestParameter)]) {
        param = [self.delegate customRequestParameter];
    } else {
        param = self.raParameter;
    }
    return param;
}

- (NSURLRequest *)currentRequest {
    NSURLRequest *request = nil;
    if ([self.delegate respondsToSelector:@selector(customRequest)]) {
        request = [self.delegate customRequest];
    }
    return nil;
}

- (void)response:(NSURLResponse *)response
            data:(NSData *)data
           error:(NSError *)error {
    NSLog(@"② 请求成功 ~~~");
    self.requesting = NO;
    TVUTuple *customTuple = nil;
    if ([self.delegate respondsToSelector:@selector(customWithResponse:data:error:)]) {
        customTuple =
        [self.delegate customWithResponse:response
                                     data:data
                                    error:error];
    } else {
        customTuple    = [TVUTuple new];
        customTuple[0] = self;
        customTuple[1] = [self parseDataToObject:data];
        customTuple[2] = error;
    }
    void(^block)(void) = ^{
        @synchronized (self) {
            if (self.raThen == nil) return;
            BOOL success = self.raThen(customTuple);
            if (success) return;
            self.doRetryCount ++;
            if ([self isRetryMaximumLimit] == NO) {
                self.doRetrying = YES;
                NSLog(@"③ 正在 Retry cnt=%ld", self.doRetryCount);
                [[TVUPLAPIManager manager] retryWithAPI:self];
            }
        }
    };
    if (self.raMainQueue) {
        dispatch_async(dispatch_get_main_queue(), block);
    } else {
        block();
    }
}

- (BOOL)isStringNoNull:(NSString *)str {
    return ([str isKindOfClass:NSString.class] &&
            str.length != 0);
}


@end
