//
//  IBNetService.h
//  Created by ibest on 14-9-24.
//  Copyright (c) 2014年 ibest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Reachability.h>
#import "IBSocket.h"
#import "IBSaveDataMemory.h"
#import "IBUserHandler.h"


#import "IBFXCustomHandleModel.h"


#define kKeyStatus @"kKeyStatus"
#define kKeyMessage @"kKeyMessage"
#define kKeyLoginItem @"kKeyLoginItem"
#define kKeyInvitation @"kKeyInvitation"
#define kKeyUpdateCheckResult @"kKeyUpdateCheckResult"

@class DDFileLogger;
@interface IBNetService : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    Reachability *_reachability;
    DDFileLogger  *_fileLogger;
}


@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, assign) NetworkStatus networkStatus;


/*
 * 网络处理
 */
@property (nonatomic,assign) BOOL bGestValid;

@property (nonatomic, strong) IBFXCustomHandleModel         *ibFXHandler;
@property (nonatomic,strong) IBSaveDataMemory * saveDataMemory;
@property (nonatomic,strong) IBUserHandler * userHandler;
// sockect
@property (nonatomic, strong) IBSocket * socketSingleton;

//网络监测
@property (nonatomic,strong) Reachability * reachability;

- (void)logout;
- (void)successLogin;





@end

__BEGIN_DECLS
IBSocket           *Socket(void);
IBNetService       *NetService(void);
IBFXCustomHandleModel       *ibFXHandler(void);
IBSaveDataMemory *    SaveDataMemory(void);
IBUserHandler * UserHandle(void);

__END_DECLS




