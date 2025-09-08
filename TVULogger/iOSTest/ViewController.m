//
//  ViewController.m
//  iOSTest
//
//  Created by TVUM4Pro on 2025/8/22.
//

#import "ViewController.h"
#import "TVULogger.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)testLoggerAction:(id)sender {
    static int cnt = 0;
    NSString *log = [NSString stringWithFormat:@"第%d条日志", cnt];
    [TVULogger logWithLevel:LogLevelError
                     format:@"%@", log];
    [TVULogger flush];
    NSLog(@"%@", log);
    cnt++;
}


@end
