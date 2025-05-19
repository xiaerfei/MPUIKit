//
//  TVUPartylineRequest.h
//  MyStreamDemo
//
//  Created by sharexia on 4/16/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TVUPartylineRequest : NSObject
+ (NSURLSessionDataTask *)requestWithUrl:(NSString *)urlString
                           andHTTPMethod:(NSString *)HTTPMethod
                                andParam:(id)param
                       completionHandler:(void (^)(NSData * _Nullable data,
                                                   NSURLResponse * _Nullable response,
                                                   NSError * _Nullable error))completionHandler;

+ (NSURLSessionDataTask *)request:(NSURLRequest *)request
                completionHandler:(void (^)(NSData * _Nullable data,
                                            NSURLResponse * _Nullable
                                            response, NSError * _Nullable error))completionHandler;
+ (NSString *)domainString;
@end

NS_ASSUME_NONNULL_END
