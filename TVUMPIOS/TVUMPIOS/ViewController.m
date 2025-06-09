//
//  ViewController.m
//  TVUMPIOS
//
//  Created by erfeixia on 2025/3/13.
//

#import "ViewController.h"
#import "TVUMPView.h"
#import "HTStack.h"
#import <sys/types.h>
#import <arpa/inet.h>
#import <netdb.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TVUMPView *view = [[TVUMPView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    
    HStack(@[view])
        .padding(10)
        .bind(self.view);
    
}


@end
