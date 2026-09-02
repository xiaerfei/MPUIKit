//
//  TVURSmetamacros.h
//  Pods
//
//  Created by erfeixia on 2024/2/24.
//

#ifndef TVURSmetamacros_h
#define TVURSmetamacros_h

#if DEBUG
#define rs_keywordify autoreleasepool {}
#else
#define rs_keywordify try {} @catch (...) {}
#endif

#ifndef weakify
    #if __has_feature(objc_arc)
        #define weakify(object) rs_keywordify __weak __typeof__(object) object##_##weak_ = object;
    #else
        #define weakify(object) rs_keywordify __block __typeof__(object) object##_##block_ = object;
    #endif
#endif

#ifndef strongify
    #if __has_feature(objc_arc)
        #define strongify(object) \
            rs_keywordify \
            _Pragma("clang diagnostic push") \
            _Pragma("clang diagnostic ignored \"-Wshadow\"") \
            __strong __typeof__(object) object = object##_##weak_; \
            _Pragma("clang diagnostic pop")
    #else
        #define strongify(object) \
            rs_keywordify \
            _Pragma("clang diagnostic push") \
            _Pragma("clang diagnostic ignored \"-Wshadow\"") \
            __strong __typeof__(object) object = object##_##block_; \
            _Pragma("clang diagnostic pop")
    #endif
#endif


#ifdef DEBUG
#define TVURSLog(fmt, ...) NSLog((fmt), ##__VA_ARGS__);
#else
#define TVURSLog(...);
#endif

#endif /* TVURSmetamacros_h */
