//
//  TVUPLRequestAPI.h
//  MyStreamDemo
//
//  Created by sharexia on 4/15/25.
//
/*
 
 [TVUPLUidInfoAPI new]
     .get()
     .parameter(@"uid")
     .mainQueue()
     .then(^BOOL(TVUPLUidInfoAPI *api, id info, NSError *error) {
         
         return YES;
     });
 
 TVUPLUidInfoAPI
     .get()
     .parameter(@(123))
     .mainQueue()
     .then(^BOOL(TVUPLUidInfoAPI *api, id info, NSError *error) {
         
         return NO;
     });
 
 */
#import <Foundation/Foundation.h>
#import "TVUTuple.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TVUPLRAType) {
    TVUPLRATypeGET,
    TVUPLRATypePOST,
};

@protocol TVUPLRequestAPIProtocol <NSObject>
@optional
- (TVUPLRAType)requestMethod;
///< 在主线程回调
- (BOOL)responseOnMainQueue;
///< 自定义 URLString
- (NSString *)customRequestURLString;
///< 自定义请求参数
- (id)customRequestParameter;
///< 自定义 Request
///< 📢 注意: 自定义 URL、请求方式(GET、POST)和自定义请求参数等方法将不会调用
- (NSURLRequest *)customRequest;
///< 解析响应数据，返回
///< 0: API Class (eg: tuple[1] )
///< 1: data (eg: tuple[1] )
///< 2: error(eg: tuple[2] )
///< 3 ~ ... : 自定义数据
///< note: 当然你可以自定义数据格式
- (TVUTuple *)customWithResponse:(NSURLResponse *)response
                            data:(NSData *)data
                           error:(NSError *)error;
@end

@interface TVUPLRequestAPI : NSObject

+ (TVUPLRequestAPI *(^)(void))get;
+ (TVUPLRequestAPI *(^)(void))post;
///< 请求的参数
+ (TVUPLRequestAPI *(^)(id param))parameter;

- (TVUPLRequestAPI *(^)(void))get;
- (TVUPLRequestAPI *(^)(void))post;
///< 请求的方式：GET 或者 POST
- (TVUPLRequestAPI *(^)(TVUPLRAType type))method;
///< 请求的参数
- (TVUPLRequestAPI *(^)(id param))parameter;
///< 请求的 URL
- (TVUPLRequestAPI *(^)(NSString *urlString))url;
///< 请求结果回调是否在主线程
- (TVUPLRequestAPI *(^)(void))mainQueue;
///< 设置 Retry 参数 retry:最大重试次数 time: 重试间隔时间(填写 0，默认 0.1s)
- (TVUPLRequestAPI *(^)(NSInteger retry, NSTimeInterval time))retry;
///< 禁用 Retry
- (TVUPLRequestAPI *(^)(void))noRetry;
/**
 *  API 名称, 用于调试、log 使用
 */
- (TVUPLRequestAPI *(^)(NSString *name))name;
/**
 *  请求结果回调，如果返回 NO 则会触发 Retry
 *  请将 then 放到点语法的最后如：API.get().xxx.then(^(tuple) {});
 *  tuple[0] : API Class
 *  tuple[1] : 返回结果
 *  tuple[2] : error(默认 NSError *，但是你可以自定义返回类型如: NSString * 类型)
 *  tuple[3 ~ ...] : 自定义类型
 */
- (TVUPLRequestAPI *(^)(BOOL (^then)(TVUTuple *tuple)))then;
/**
 *  同步返回, 请在异步线程使用(具体请看使用例子)
 *  tuple[0] : API Class
 *  tuple[1] : 返回结果
 *  tuple[2] : error(默认 NSError *，但是你可以自定义返回类型如: NSString * 类型)
 *  tuple[3 ~ ...] : 自定义类型
 */
- (TVUTuple *(^)(void))sync;
   
- (TVUPLRAType)requestMethod;
- (NSString *)requestURL;
- (id)requestParameter;
- (NSString *)requestName;

///< 开始请求
- (void)start;
///< 取消本次请求也包括重试
- (void)stop;

///< 重试请求间隔(默认 1s)
@property (nonatomic, assign) NSTimeInterval retryTime;
///< 重试次数(默认 5 次)
@property (nonatomic, assign) NSInteger retryCount;
///< 正在第 n 次重试
@property (nonatomic, assign, readonly) NSInteger doRetryCount;
///< 正在第重试中...
@property (nonatomic, assign, readonly) BOOL doRetrying;
///< 是否正在请求
@property (atomic, assign, readonly) BOOL requesting;
///< 请求标识
@property (nonatomic, assign, readonly) NSInteger requestId;
@end

NS_ASSUME_NONNULL_END
