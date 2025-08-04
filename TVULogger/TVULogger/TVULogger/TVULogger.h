//
//  TVULogger.h
//  TVULogger
//
//  Created by erfeixia on 2025/8/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LogLevel) {
    LogLevelDebug,
    LogLevelInfo,
    LogLevelWarn,
    LogLevelError
};

@interface TVULogger : NSObject
+ (instancetype)sharedInstance;
/**
 写入日志
 
 @param level 日志级别
 @param format 日志格式字符串
 */
+ (void)logWithLevel:(LogLevel)level format:(NSString *)format, ... NS_FORMAT_FUNCTION(2, 3);
/**
 立即刷新缓存到文件
 */
+ (void)flush;


/**
 初始化日志系统
 
 @param directory 日志存储目录
 @param maxFileSize 单个文件最大尺寸(字节)
 */
- (void)initializeWithDirectory:(NSString *)directory maxFileSize:(uint64_t)maxFileSize;

/**
 写入日志
 
 @param level 日志级别
 @param format 日志格式字符串
 */
- (void)logWithLevel:(LogLevel)level format:(NSString *)format, ... NS_FORMAT_FUNCTION(2, 3);

/**
 立即刷新缓存到文件
 */
- (void)flush;

/**
 清除所有日志
 */
- (void)clearAllLogs;
@end

NS_ASSUME_NONNULL_END
