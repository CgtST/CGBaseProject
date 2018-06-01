//
//  IBUserSystemManager.h
//  iBestStandard
//
//  Created by bingo on 2018/5/17.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import "IBBaseManager.h"

@class IBUserData;

@interface IBUserSystemManager : IBBaseManager


//用户会话ID
@property (nonatomic, strong) NSString *sessionID;
//当前用户基本信息
@property (nonatomic, strong) IBUserData *user;

@property (nonatomic,assign) int32_t userCode;


//自动登陆
- (void)IBAutoLogin:(void(^)(BOOL loginResult))resultBlock;


//当前用户初始化动作
//- (void) initForUser:(int64_t) userID;

- (void)IBRegisterGuest:(void(^)(BOOL loginResult))resultBlock ;
//退出登陆
- (void) logout;

/*
//持久化操作，待分离
///从数据库读取环信用户的用户信息
- (void)friendInfoFromDBImId:(NSArray *)imIds
                      result:(void(^)(NSArray *otherGuys))result;


//  标记系统读消息为已读
//  @param messageId 消息ID
- (void)markSystemMessageAsReadWithMessageID:(int64_t)messageId;

// 读取系统消息未读数量
- (void)fetchUnreadMessageCount;

- (void)markUnreadNewFriendMsgIsRead;

- (void)markAllSystemMessageAsRead;
 
 */


__BEGIN_DECLS
IBUserSystemManager* sharedIBUserSystemManager(void);
IBUserData *User(void);
__END_DECLS
@end


