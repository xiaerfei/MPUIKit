//
//  ViewController.m
//  MacOSDemo
//
//  Created by erfeixia on 2025/5/30.
//

#import "ViewController.h"
#import "TVUPLSlider.h"
#import "Masonry.h"

@interface ViewController ()
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (weak) IBOutlet NSTextField *titleLabel;
@property (weak) IBOutlet NSTextField *displayCntLabel;

@property (nonatomic,   copy) NSArray *datasource;
@property (nonatomic, assign) NSInteger index;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
- (IBAction)confirmBtnAction:(id)sender {
    NSString *string = self.textView.string;
    if (string.length == 0) {
        return;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *datas = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    self.datasource = datas;
    [self updateTitle];
}

- (IBAction)preBtnAction:(id)sender {
    self.index -= 1;
    if (self.index < 0) {
        self.index = 0;
    }
    [self updateTitle];
}
- (IBAction)nextBtnAction:(id)sender {
    self.index++;
    if (self.index >= self.datasource.count) {
        self.index = self.datasource.count - 1;
    }
    [self updateTitle];
}
- (IBAction)resetBtnAction:(id)sender {
    self.index = 0;
    [self updateTitle];
}

#pragma mark - Private Methods
- (void)writeToPasteboard:(NSString *)string {
    if (string.length == 0) return;
    // 获取系统剪贴板
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    
    // 清空剪贴板
    [pasteboard clearContents];
    
    // 将字符串写入剪贴板
    BOOL success = [pasteboard writeObjects:@[string]];
}

- (void)updateTitle {
    NSInteger cnt = self.datasource.count;
    if (cnt == 0) {
        self.titleLabel.stringValue = @"";
        self.displayCntLabel.stringValue = @"";
        [self writeToPasteboard:@""];
        return;
    }
    if (self.index >= cnt || self.index < 0) {
        return;
    }
    
    self.titleLabel.stringValue = self.datasource[self.index];
    self.displayCntLabel.stringValue = [NSString stringWithFormat:@"总数:%ld 当前:%ld", cnt, self.index + 1];
    [self writeToPasteboard:self.datasource[self.index]];
}


@end

