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
///< 0: data (eg: tuple[0] )
///< 1: error(eg: tuple[1] )
- (TVUTuple *)customWithResponse:(NSURLResponse *)response
                            data:(NSData *)data
                           error:(NSError *)error {
    TVUTuple *tuple = [TVUTuple new];
    tuple[0] = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    tuple[1] = error;
    return tuple;
}

@end
