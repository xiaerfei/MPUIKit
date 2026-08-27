//
//  TVUPLState.m
//  StaticViewDemo
//
//  Created by erfeixia on 2026/8/27.
//

#import "TVUPLState.h"
#import "TVUPLRow.h"
#import "TVUStaticView.h"

///< 当前正在求值的 row。getter 靠它知道"是谁在读我"，这是整套机制的支点
static __weak TVUPLRow *_evaluatingRow = nil;

@interface TVUPLState ()
///< 弱引用：row 每次 reload 都换新对象，订阅表不能把旧对象拖住
@property (nonatomic, strong) NSHashTable <TVUPLRow *>*subscribers;
@end

@implementation TVUPLState {
    id _value;
}

+ (instancetype)value:(id)value {
    TVUPLState *state = [[self alloc] init];
    state->_value = value;
    return state;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _subscribers = [NSHashTable weakObjectsHashTable];
    }
    return self;
}
#pragma mark - 依赖收集作用域
+ (void)beginEvaluatingRow:(TVUPLRow *)row {
    NSAssert(_evaluatingRow == nil,
             @"求值不可嵌套，检查是否在 prefetch 中触发了 reload");

    ///< 依赖每次求值都重建：先把这一行从它订阅过的所有 State 里摘掉
    for (TVUPLState *state in row.rstates.allObjects) {
        [state.subscribers removeObject:row];
    }
    [row.rstates removeAllObjects];

    _evaluatingRow = row;
}

+ (void)endEvaluating {
    _evaluatingRow = nil;
}

+ (BOOL)isEvaluating {
    return _evaluatingRow != nil;
}
#pragma mark - Value
- (id)value {
    TVUPLRow *row = _evaluatingRow;
    if (row) {
        ///< 读取动作本身就是依赖的证据。双向登记，反向那条用于下次求值前解绑
        [self.subscribers addObject:row];
        [row.rstates addObject:self];
    }
    return _value;
}

- (void)setValue:(id)value {
    NSAssert([NSThread isMainThread], @"TVUPLState 只能在主线程读写");
    NSAssert(_evaluatingRow == nil,
             @"不要在 prefetch 中写入 State，那会造成无限刷新");
    if (_evaluatingRow) return;

    if (_value == value || [_value isEqual:value]) return;
    _value = value;

    ///< 快照遍历：刷新会重跑 prefetch，进而改动 subscribers
    for (TVUPLRow *row in self.subscribers.allObjects) {
        [row.rstaticView reloadRow:row];
    }
}
@end
