//
//  ViewController.m
//  MacOSDemo
//
//  Created by erfeixia on 2025/5/30.
//

#import "ViewController.h"
#import "TVUPLSlider.h"
#import "Masonry.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TVUPLSlider *slider = [[TVUPLSlider alloc] initWithFrame:NSZeroRect];
    [self.view addSubview:slider];
    
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view).multipliedBy(0.6);
        make.height.equalTo(@30);
    }];
    
    [slider setValueChangedHandler:^(CGFloat newValue) {
        NSLog(@"value=%f", newValue);
    }];
    
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
