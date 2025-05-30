//
//  TVUPLTimeoutAPI.m
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/5/30.
//

#import "TVUPLTimeoutAPI.h"

@implementation TVUPLTimeoutAPI
- (void)dealloc {
    NSLog(@"TVUPLTimeoutAPI: release...");
}

- (NSString *)customRequestURLString {
    return @"timeout";
}

@end
