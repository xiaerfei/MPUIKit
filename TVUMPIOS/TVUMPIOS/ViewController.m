//
//  ViewController.m
//  TVUMPIOS
//
//  Created by erfeixia on 2025/3/13.
//

#import "ViewController.h"
#import "TVUMPView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TVUMPView *view = [[TVUMPView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIStackView *sview = nil;
    
}


@end

/*
 HStack([
    Button(),
    Label(),
    VStack([
        Button(), Label(),
    ]),
 ])
 .padding(10)
 .height(200)
 .bind(self.view);
 
 
 
 
 */
