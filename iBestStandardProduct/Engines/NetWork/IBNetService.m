//
//  IBService.m
//  IBEngine
//  这个类谢昆鹏在用, 请不要随意更改
//  Created by manny on 14-9-24.
//  Copyright (c) 2014年 Bacai. All rights reserved.
//


#import "IBNetService.h"
#import <DDLog.h>
#import <DDFileLogger.h>
#import <DDTTYLogger.h>




IBNetService *NetService()
{
    static IBNetService *s_servece = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_servece = [[[IBNetService class] alloc] init];
    });
    return s_servece;
}

IBSocket   *Socket()
{
    return NetService().socketSingleton;
}

IBFXCustomHandleModel *ibFXHandler() {
    return NetService().ibFXHandler;
}

IBSaveDataMemory * SaveDataMemory()
{
    return NetService().saveDataMemory;
}


IBUserHandler * UserHandle()
{
    return NetService().userHandler;
}


@implementation IBNetService


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}


- (id)init
{
    self = [super init];
    if (self) {
        
#ifdef DEBUG
        [self _initLogger];//屏蔽该函数可以大大减轻CPU使用率
#endif
        self.ibFXHandler    = [[IBFXCustomHandleModel alloc] init];

        self.reachability = [Reachability reachabilityForInternetConnection];
        [self.reachability startNotifier];

        [[NSNotificationCenter defaultCenter] addObserver: self
                                                selector: @selector(handleNetWorkChangeNotify:)
                                                     name: kReachabilityChangedNotification
                                                   object: nil];
        
        
        self.bGestValid = NO;

    }
    return self;
}


- (void)_initLogger
{
    [[DDTTYLogger sharedInstance] setColorsEnabled: YES];
    [DDLog addLogger: [DDTTYLogger sharedInstance]];
}


#pragma mark - Public

- (void)successLogin
{
    self.isLogin = YES;
}

- (void)logout
{
    self.isLogin = NO;
}

#pragma mark - NET WORK
- (void)handleNetWorkChangeNotify:(NSNotification *)notify {
    self.networkStatus = [self.reachability currentReachabilityStatus];
}

- (NetworkStatus)networkStatus {
    _networkStatus = [_reachability currentReachabilityStatus];
    return _networkStatus;
}

#pragma mark    getter


- (IBSocket *)socketSingleton {
    if (!_socketSingleton) {
        _socketSingleton = [[IBSocket alloc] init];
        
    }
    return _socketSingleton;
}

-(IBSaveDataMemory *)saveDataMemory
{
    if (!_saveDataMemory) {
        _saveDataMemory = [[IBSaveDataMemory alloc] init];
    }
    return _saveDataMemory;
}


-(IBUserHandler *)userHandler
{
    if (!_userHandler) {
        _userHandler = [[IBUserHandler alloc] init];
    }
    return _userHandler;
}

@end
