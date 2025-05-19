//
//  TVUPartylineRequest.m
//  MyStreamDemo
//
//  Created by sharexia on 4/16/25.
//

#import "TVUPartylineRequest.h"

@implementation TVUPartylineRequest
+ (NSURLSessionDataTask *)requestWithUrl:(NSString *)urlString
         andHTTPMethod:(NSString *)HTTPMethod
              andParam:(id)param
     completionHandler:(void (^)(NSData * _Nullable data,
                                 NSURLResponse * _Nullable response,
                                 NSError * _Nullable error))completionHandler {
    return nil;
}

+ (NSURLSessionDataTask *)request:(NSURLRequest *)request
                completionHandler:(void (^)(NSData * _Nullable data,
                                            NSURLResponse * _Nullable
                                            response, NSError * _Nullable error))completionHandler {
    // 获取session(单例)
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData * _Nullable data,
                                   NSURLResponse * _Nullable response,
                                   NSError * _Nullable error) {
        if (completionHandler) completionHandler(data, response, error);
    }];
    [dataTask resume];
    return dataTask;
}

+ (NSString *)domainString {
    return @"https://api.tvunetworks.com/uniformapi/partyline";
}

@end
