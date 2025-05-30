//
//  TVUPLUsersAPI.m
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/5/30.
//

#import "TVUPLUsersAPI.h"

@implementation TVUPLUsersAPI
- (void)dealloc {
    NSLog(@"TVUPLUsersAPI: release...");
}

- (NSString *)customRequestURLString {
    return [NSString stringWithFormat:@"users/%@", [self requestParameter]];
}
@end
