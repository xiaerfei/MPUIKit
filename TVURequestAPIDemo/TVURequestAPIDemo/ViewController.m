//
//  ViewController.m
//  TVURequestAPIDemo
//
//  Created by sharexia on 5/6/25.
//

#import "ViewController.h"
#import "TVUPLUidInfoAPI.h"
#import "TVUPLUsersAPI.h"
#import "TVUPLTimeoutAPI.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}



- (void)testApi {
    TVUPLUsersAPI
        .get()
        .mainQueue()
        .name(@"UidInfo")
        .then(^BOOL(TVUTuple *tuple) {
            
            NSError *error = [tuple[2] toErrorValue];
            if (error) {
                return NO;
            }
            
            NSLog(@"sharexia: info=%@", [tuple[1] toStringValue]);
            return YES; // 返回 NO 表示需要 Retry
        });
}

- (void)testSync {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        TVUTuple *result0 = TVUPLUsersAPI.parameter(@(1)).sync();
        NSError *error0 = [result0[1] toErrorValue];
        if (error0) {
            NSLog(@"error0:%@", error0.localizedDescription);
            return;
        } else {
            NSLog(@"info0=%@", [result0[1] toStringValue]);
        }
        TVUTuple *result1 = TVUPLUsersAPI.parameter(@(2)).sync();
        NSError *error1 = [result0[1] toErrorValue];
        if (error1) {
            NSLog(@"error1:%@", error1.localizedDescription);
            return;
        } else {
            NSLog(@"info1=%@", [result1[1] toStringValue]);
        }
    });
}

- (void)testTimeout {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        TVUTuple *result0 = TVUPLTimeoutAPI.parameter(nil).sync();
        NSError *error0 = [result0[1] toErrorValue];
        if (error0) {
            NSLog(@"error0:%@", error0.localizedDescription);
            return;
        } else {
            NSLog(@"info0=%@", [result0[1] toStringValue]);
        }
    });
}



@end
