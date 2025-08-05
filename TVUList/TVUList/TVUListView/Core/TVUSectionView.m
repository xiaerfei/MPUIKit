//
//  TVUSectionView.m
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/8/5.
//

#import "TVUSectionView.h"
#import "TVUPLListView.h"

@interface TVUPLSection ()
@property (nonatomic, strong) NSMutableArray <TVUPLRow *> *rows;
@property (nonatomic, assign) NSUInteger index;
@end

@interface TVUPLRow ()
@property (nonatomic, assign, readwrite) TVUPLRowType type;
@property (nonatomic,   copy, readwrite) NSString *key;
@property (nonatomic, strong, readwrite) TVUPLBaseRow <TVUPLRowProtocol> *bindView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, weak) TVUPLSection *section;
@end


@interface TVUSectionView ()
@property (nonatomic, strong) TVUPLRow *clickRow;
@end

@implementation TVUSectionView
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    self.clickRow = nil;
    
    if (self.section.hidden) return;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    TVUPLRow *findRow = nil;
    for (TVUPLRow *row in self.section.rows) {
        if (row.hidden == NO &&
            row.unselected == NO &&
            CGRectContainsPoint(row.bindView.frame, point)) {
            findRow = row;
            break;
        }
    }

    if (findRow == nil) return;
    
    self.clickRow = findRow;
    findRow.backView.backgroundColor =
    findRow.unselectedStyle ? [UIColor clearColor] :
                              [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.clickRow) {
        self.clickRow.backView.backgroundColor = [UIColor clearColor];
    }
    self.clickRow = nil;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (self.clickRow.didSelectedBlock) {
        self.clickRow.didSelectedBlock(self.clickRow, nil);
    }
    if (self.clickRow) {
        self.clickRow.backView.backgroundColor = [UIColor clearColor];
    }
    self.clickRow = nil;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    if (self.clickRow) {
        self.clickRow.backView.backgroundColor = [UIColor clearColor];
    }
    self.clickRow = nil;
}
@end
