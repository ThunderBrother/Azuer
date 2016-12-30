//
//  OTSLog.m
//  OneStoreFramework
//
//  Created by Aimy on 14-8-15.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "OTSLog.h"
#import "OTSFileManager.h"

@implementation OTSLog

+ (void)setupLogerStatus {
#ifdef DEBUG
    //set color on
    setenv("XcodeColors", "YES", 0);
    
    //This class provides a logger for Terminal output or Xcode console output
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    //This class provides a logger for the Apple System Log facility
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    
//在硬盘上存储接口数据和tracker
    NSString *logPath = [[OTSFileManager appCachePath] stringByAppendingString:@"/Logs"];
    if ([OTSFileManager isFileExsit:logPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:logPath error:nil];
    }
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 0;
    fileLogger.maximumFileSize = 0;
    [DDLog addLogger:fileLogger withLevel:LOG_FLAG_DATA_TO_FILE];
    
    // And then enable colors
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor lightGrayColor] backgroundColor:nil forFlag:DDLogFlagVerbose];
    
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor cyanColor] backgroundColor:nil forFlag:DDLogFlagDebug];
    
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor magentaColor] backgroundColor:nil forFlag:DDLogFlagInfo];
    
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor brownColor] backgroundColor:nil forFlag:DDLogFlagWarning];
    
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor] backgroundColor:nil forFlag:DDLogFlagError];
#endif
}

+ (NSArray *)getLogPath {
    NSString *libPath = [OTSFileManager appLibPath];
    
    NSString *logPath = [libPath stringByAppendingPathComponent:@"Caches"];
    logPath = [logPath stringByAppendingPathComponent:@"Logs"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:logPath error:&error];
    NSMutableArray * listArray = [NSMutableArray array];
    for (NSString * oneLogPath in fileList)
    {
        if([oneLogPath hasSuffix:@".log"])
        {
            NSString *truePath = [logPath stringByAppendingPathComponent:oneLogPath];
            [listArray addObject:truePath];
        }
    }
    return listArray;
}

@end
