//
//  TVURSDisposeBag.m
//  TVUSignal / Rx
//

#import "TVURSDisposeBag.h"

@interface TVURSDisposeBag ()
@property (nonatomic, strong) NSMutableArray<TVURSDisposable *> *disposables;
@end

@implementation TVURSDisposeBag
- (instancetype)init {
    if (self = [super init]) {
        _disposables = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    [self dispose];
}

- (void)insert:(TVURSDisposable *)disposable {
    if (disposable) [self.disposables addObject:disposable];
}

- (void)dispose {
    NSArray *snapshot = [self.disposables copy];
    [self.disposables removeAllObjects];
    for (TVURSDisposable *disposable in snapshot) {
        [disposable dispose];
    }
}
@end

@implementation TVURSDisposable (TVURSDisposeBag)
- (void (^)(TVURSDisposeBag *))disposedBy {
    return ^(TVURSDisposeBag *bag) {
        [bag insert:self];
    };
}
@end
