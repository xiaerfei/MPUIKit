//
//  Common.h
//  TVUList
//
//  Created by erfeixia on 2025/8/4.
//

#ifndef Common_h
#define Common_h

#define UIColorFromHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif /* Common_h */
