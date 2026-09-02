//
//  TVURSDisposeBag.h
//  TVUSignal / Rx
//
//  对应 RxSwift 的 DisposeBag：袋子销毁时，里面的订阅一起 dispose。
//  通常不手动创建，直接用 owner.rx.disposeBag（随 owner 一同销毁）。
//

#import <Foundation/Foundation.h>
#import "TVURSDisposable.h"

NS_ASSUME_NONNULL_BEGIN

@interface TVURSDisposeBag : NSObject
- (void)insert:(TVURSDisposable *)disposable;
/// 立刻 dispose 全部并清空，袋子可继续复用
- (void)dispose;
@end

@interface TVURSDisposable (TVURSDisposeBag)
/// 对应 RxSwift 的 .disposed(by:)
- (void (^)(TVURSDisposeBag *bag))disposedBy;
@end

NS_ASSUME_NONNULL_END
