//
//  NSPathEx.m
//  Stock
//  这个类谢昆鹏在用, 请不要随意更改
//  Created by manny on 13-5-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSPathEx.h"
#import <sys/xattr.h>
static NSString *s_DocPath = nil;

@implementation NSPathEx


+ (NSString *)homePath
{
	return NSHomeDirectory();
}

+ (NSString *)tempPath;
{
	return [NSTemporaryDirectory() stringByStandardizingPath];
}

+ (NSString *)docPath
{
    if (s_DocPath == nil)
    {
        
#if TARGET_OS_IPHONE
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        s_DocPath = [[paths objectAtIndex: 0] stringByAppendingPathComponent:@"Local"];
        
       if (![[NSFileManager defaultManager] fileExistsAtPath:s_DocPath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:s_DocPath withIntermediateDirectories:YES attributes:nil error:nil];
            if (&NSURLIsExcludedFromBackupKey == nil)
            {
                u_int8_t b = 1;
                setxattr([s_DocPath fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
            }
            else
            {
                NSError *error = nil;
                BOOL success = [[NSURL fileURLWithPath:s_DocPath] setResourceValue: [NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
                if (!success)
                {
                    NSLog(@"Fail to excluded from backup");
                }
            }
        }
#else
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        s_DocPath = paths[0];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:s_DocPath] == NO)
        {
            [fileManager createDirectoryAtPath:s_DocPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
#endif
        NSLog(@"DocPath:%@", s_DocPath);
    }
    return s_DocPath;
}

+ (NSString *)appPath
{
	return [[NSBundle mainBundle] bundlePath];
}
@end
