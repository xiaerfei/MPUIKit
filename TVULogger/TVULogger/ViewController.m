//
//  ViewController.m
//  TVULogger
//
//  Created by erfeixia on 2025/8/2.
//

#import "ViewController.h"
#import "TVULogger.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)addLogAction:(id)sender {
    static int cnt = 0;
    NSString *log = [NSString stringWithFormat:@"第%d条日志", cnt];
    [TVULogger logWithLevel:LogLevelError
                     format:@"%@", log];
    [TVULogger flush];
    NSLog(@"%@", log);
    cnt++;
}

@end
