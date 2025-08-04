//
//  TVULogger.m
//  TVULogger
//
//  Created by erfeixia on 2025/8/2.
//

#import "TVULogger.h"
#import <pthread.h>
#import <sys/stat.h>

@interface TVULogger ()
@property (nonatomic, copy) NSString *logDirectory;
@property (nonatomic, assign) uint64_t maxFileSize;
@property (nonatomic, copy) NSString *currentFilePath;
@property (nonatomic, strong) dispatch_queue_t logQueue;
@property (nonatomic, strong) NSMutableData *logBuffer;
@property (nonatomic, assign) dispatch_once_t initOnce;
@end

@implementation TVULogger

+ (instancetype)sharedInstance {
    static TVULogger *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TVULogger alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _logQueue = dispatch_queue_create("com.simplelogger.queue",
                                          DISPATCH_QUEUE_SERIAL);
        _logBuffer = [NSMutableData data];
        _maxFileSize = 1024 * 1024 * 5; // 默认5MB
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDirectory =
        [NSString stringWithFormat:@"%@/TVULogger",
         [paths firstObject]];
        [self initializeWithDirectory:cachesDirectory
                          maxFileSize:_maxFileSize];
        NSLog(@"path=%@", cachesDirectory);
    }
    return self;
}

- (void)initializeWithDirectory:(NSString *)directory
                    maxFileSize:(uint64_t)maxFileSize {
    dispatch_sync(_logQueue, ^{
        _logDirectory = directory;
        _maxFileSize = maxFileSize;
        
        // 创建目录
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:directory]) {
            [fm createDirectoryAtPath:directory
          withIntermediateDirectories:YES
                           attributes:nil
                                error:NULL];
        }
        // 初始化当前日志文件
        [self updateCurrentFilePath];
    });
}
/**
 写入日志
 
 @param level 日志级别
 @param format 日志格式字符串
 */
+ (void)logWithLevel:(LogLevel)level format:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *logContent = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    [[self sharedInstance] writeLog:logContent level:level];
}

- (void)logWithLevel:(LogLevel)level format:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *logContent = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    [self writeLog:logContent level:level];
}

- (void)writeLog:(NSString *)content level:(LogLevel)level {
    if (!self.logDirectory) {
        NSLog(@"Logger not initialized");
        return;
    }
    
    dispatch_async(_logQueue, ^{
        // 1. 构建日志内容
        NSString *levelStr   = [self levelToString:level];
        NSString *timestamp  = [self currentTimestamp];
        NSString *threadInfo = [self currentThreadInfo];
        
        NSString *logLine =
        [NSString stringWithFormat:@"[%@] [%@] %@: %@\n",
         timestamp, levelStr, threadInfo, content];
        
        // 2. 转换为数据并添加到缓冲区
        NSData *logData = [logLine dataUsingEncoding:NSUTF8StringEncoding];
        [self.logBuffer appendData:logData];
        
        // 3. 当缓冲区超过1KB或30秒未刷新时写入文件
        if (self.logBuffer.length > 1024) {
            [self flushBufferToFile];
        }
    });
}

- (void)flush {
    dispatch_sync(_logQueue, ^{
        [self flushBufferToFile];
    });
}
/**
 立即刷新缓存到文件
 */
+ (void)flush {
    [[TVULogger sharedInstance] flush];
}

- (void)clearAllLogs {
    dispatch_async(_logQueue, ^{
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *files = [fm contentsOfDirectoryAtPath:self.logDirectory
                                                 error:NULL];
        
        for (NSString *file in files) {
            NSString *path = [self.logDirectory stringByAppendingPathComponent:file];
            [fm removeItemAtPath:path error:NULL];
        }
        
        [self updateCurrentFilePath];
        self.logBuffer = [NSMutableData data];
    });
}

#pragma mark - 私有方法

- (void)updateCurrentFilePath {
    NSString *dateStr = [self currentDateString];
    self.currentFilePath = [self.logDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"log_%@.txt", dateStr]];
}

- (BOOL)shouldCreateNewFile {
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.currentFilePath]) {
        return NO;
    }
    
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:self.currentFilePath error:NULL];
    uint64_t fileSize = [attrs fileSize];
    return fileSize >= self.maxFileSize;
}

- (void)flushBufferToFile {
    if (self.logBuffer.length == 0) return;
    
    // 检查是否需要创建新文件
    if ([self shouldCreateNewFile]) {
        NSString *dateStr = [self currentDateString];
        NSString *newFilePath = [self.logDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"log_%@_1.txt", dateStr]];
        self.currentFilePath = newFilePath;
    }
    
    // 写入文件
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.currentFilePath];
    if (!fileHandle) {
        // 文件不存在时创建
        [self.logBuffer writeToFile:self.currentFilePath atomically:YES];
    } else {
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:self.logBuffer];
        [fileHandle closeFile];
    }
    // 清空缓冲区
    self.logBuffer = [NSMutableData data];
}

#pragma mark - 辅助方法

- (NSString *)levelToString:(LogLevel)level {
    switch (level) {
        case LogLevelDebug: return @"DEBUG";
        case LogLevelInfo:  return @"INFO";
        case LogLevelWarn:  return @"WARN";
        case LogLevelError: return @"ERROR";
        default: return @"UNKNOWN";
    }
}

- (NSString *)currentTimestamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    return [formatter stringFromDate:[NSDate date]];
}

- (NSString *)currentDateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:[NSDate date]];
}

- (NSString *)currentThreadInfo {
    if ([NSThread isMainThread]) {
        return @"MainThread";
    } else {
        return [NSString stringWithFormat:@"Thread-%lu",
                (unsigned long)pthread_self()];
    }
}

@end
