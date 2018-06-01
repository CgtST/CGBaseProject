//
//  IBBaseManager.h
//  Created by ibest on 14-9-25.
//  Copyright (c) 2014年 ibest All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 * 1.请求数据
 * 2.分发数据
 * 3.保存数据
 * 4.线程同步
 */
@interface IBBaseManager : NSObject


- (void)postNotificationInOpearationMainQueueWithName:(NSString *)notifyName
                                               object:(id)object
                                             userInfo:(NSDictionary *)userInfo;
- (void)postNotificationInGCDMainQueueWithName:(NSString *)notifyname
                                        object:(id)object
                                      userInfo:(NSDictionary *)userInfo;
- (void)performBlockInMainThread:(dispatch_block_t)block;
- (void)performBlockInMainQueue:(dispatch_block_t)block;


@property (nonatomic, strong) NSString *name;

@end












