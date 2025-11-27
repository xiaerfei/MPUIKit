//
//  TVUPLListConst.h
//  TVUCollectionView
//
//  Created by erfeixia on 2025/11/15.
//

#ifndef TVUPLListConst_h
#define TVUPLListConst_h

#pragma mark - DefaultRow
extern NSString *const kTVUPLDefaultRow;
/// Data Key
extern NSString *const kTVUPLRowTitle;
extern NSString *const kTVUPLRowTitleFont;
extern NSString *const kTVUPLRowTitleColor;
extern NSString *const kTVUPLRowTitleAlignment;
extern NSString *const kTVUPLRowTitleNumberOfLines;
extern NSString *const kTVUPLRowSubtitle;
extern NSString *const kTVUPLRowSubtitleFont;
extern NSString *const kTVUPLRowSubtitleColor;
extern NSString *const kTVUPLRowIcon;
extern NSString *const kTVUPLRowSystemIcon;
extern NSString *const kTVUPLRowIconSize;
extern NSString *const kTVUPLRowIconTintColor;
#pragma mark - SwitchRow
extern NSString *const kTVUPLSwitchRow;

extern NSString *const kTVUPLRowSwitchOn;
extern NSString *const kTVUPLRowSwitchEnabled;
#pragma mark - LoginRow
extern NSString *const kTVUPLLoginRow;

extern NSString *const kTVUPLRowLoginBigWord;
#pragma mark - RightValueRow
extern NSString *const kTVUPLRightValueRow;

extern NSString *const kTVUPLRowRightValue;
extern NSString *const kTVUPLRightPriority;
///< 范围(0, 1]
extern NSString *const kTVUPLRowRightScale;
#if DEBUG
#define tvu_keywordify autoreleasepool {}
#else
#define tvu_keywordify try {} @catch (...) {}
#endif

#ifndef weakify
    #if __has_feature(objc_arc)
        #define weakify(object) \
            tvu_keywordify  \
            __weak __typeof__(object) weak##_##object = object;
    #else
        #define weakify(object) \
            tvu_keywordify  \
            __block __typeof__(object) block##_##object = object;
    #endif
#endif

#ifndef strongify
    #if __has_feature(objc_arc)
        #define strongify(object) \
            tvu_keywordify  \
            _Pragma("clang diagnostic push") \
            _Pragma("clang diagnostic ignored \"-Wshadow\"") \
            __strong __typeof__(object) object = weak##_##object; \
            _Pragma("clang diagnostic pop")
    #else
        #define strongify(object) \
            tvu_keywordify  \
            _Pragma("clang diagnostic push") \
            _Pragma("clang diagnostic ignored \"-Wshadow\"") \
            __strong __typeof__(object) object = block##_##object; \
            _Pragma("clang diagnostic pop")
    #endif
#endif
#endif /* TVUPLListConst_h */
