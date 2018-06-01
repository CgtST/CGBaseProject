//
//  IBBaseManager.m
//  IBEngine
//
//  Created by manny on 14-9-25.
//  Copyright (c) 2014年 Bacai. All rights reserved.
//

#import "IBBaseManager.h"

@implementation IBBaseManager

- (void)postNotificationInOpearationMainQueueWithName:(NSString *)notifyName
                                               object:(id)object
                                             userInfo:(NSDictionary *)userInfo
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName: notifyName
                                                            object: object
                                                          userInfo: userInfo];
    }];
}
- (void)postNotificationInGCDMainQueueWithName:(NSString *)notifyname
                                        object:(id)object
                                      userInfo:(NSDictionary *)userInfo
{
    [self performBlockInMainThread:^{
        [[NSNotificationCenter defaultCenter] postNotificationName: notifyname
                                                            object: object
                                                          userInfo: userInfo];
    }];
}
- (void)performBlockInMainThread:(dispatch_block_t)block
{
    dispatch_async(dispatch_get_main_queue(), block);
}
- (void)performBlockInMainQueue:(dispatch_block_t)block
{
    [[NSOperationQueue mainQueue] addOperationWithBlock: block];
}

@end








