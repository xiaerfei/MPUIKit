//
//  TVUPLBaseRow.m
//  TVURequestAPIDemo
//
//  Created by erfeixia on 2025/7/19.
//

#import "TVUPLBaseRow.h"
#import "TVUPLListView.h"
@interface TVUPLRow ()
@property (nonatomic, strong) UIView *backView;
@end


@implementation TVUPLBaseRow
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.row.backView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    NSLog(@"touch began");
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.row.backView.backgroundColor = [UIColor clearColor];
    if (self.row.didSelectedBlock) {
        self.row.didSelectedBlock(self.row, nil);
    }
    NSLog(@"touch end");
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.row.backView.backgroundColor = [UIColor clearColor];
    NSLog(@"touch cancelled");
}

@end
