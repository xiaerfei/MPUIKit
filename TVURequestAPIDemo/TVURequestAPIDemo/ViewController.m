//
//  ViewController.m
//  TVURequestAPIDemo
//
//  Created by sharexia on 5/6/25.
//

#import "ViewController.h"
#import "TVUPLUidInfoAPI.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TVUPLUidInfoAPI
        .get()
        .parameter(@(123))
        .mainQueue()
        .retry(2,1)
        .name(@"UidInfo")
        .then(^BOOL(TVUTuple *tuple) {
            return NO; // 返回 NO 表示需要 Retry
        });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        TVUTuple *result0 = TVUPLUidInfoAPI.parameter(@(123)).sync();
        TVUTuple *result1 = TVUPLUidInfoAPI.parameter(@(456)).sync();
        TVUTuple *result2 = TVUPLUidInfoAPI.parameter(@(789)).sync();
    });
}


@end
