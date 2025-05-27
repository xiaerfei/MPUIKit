//
//  TVUPLUidInfoAPI.m
//  MyStreamDemo
//
//  Created by sharexia on 4/16/25.
//

#import "TVUPLUidInfoAPI.h"
@interface TVUPLUidInfoAPI ()

@end

@implementation TVUPLUidInfoAPI
- (void)dealloc {
    NSLog(@"TVUPLUidInfoAPI: release...");
}

- (NSString *)customRequestURLString {
    return @"intercomPro/noLogin/queryByRtilCode";
}

///< 解析响应数据，返回
///< 0: API Class (eg: tuple[1] )
///< 1: data (eg: tuple[1] )
///< 2: error(eg: tuple[2] )
///< 3 ~ ... : 自定义数据
- (TVUTuple *)customWithResponse:(NSURLResponse *)response
                            data:(NSData *)data
                           error:(NSError *)error {
    TVUTuple *tuple = [TVUTuple new];
    tuple[0] = self;
    tuple[1] = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    tuple[2] = error;
    return tuple;
}

@end
