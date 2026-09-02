//
//  TVURSignalObjc.h
//  TestPrj
//
//  Created by sharexia on 2/21/24.
//

#ifndef TVURSignalObjc_h
#define TVURSignalObjc_h

#import <Foundation/Foundation.h>
#import "TVURSmetamacros.h"

#import "TVURSignal.h"

#import "NSNotificationCenter+TVUSignalSupport.h"

#if TARGET_OS_IOS
    #import "UIControl+TVURSignal.h"
#elif TARGET_OS_MAC
    #import "NSControl+TVUSignalSupport.h"
#endif

#endif /* TVURSignalObjc_h */
