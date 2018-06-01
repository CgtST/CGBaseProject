//
//  IBXRouter.m
//  iBestProduct
//
//  Created by xboker on 2017/10/20.
//  Copyright © 2017年 iBest. All rights reserved.
//

#import "IBXRouter.h"
#import <JLRoutes.h>
#import "IBRootTabBarViewController.h"
#import "QNAppDelegate.h"
#import "IBMineViewController.h"
#import "IBHelpCenterViewController.h"
#import "IBInviteFriendViewController.h"
#import "IBLoginMainViewController.h"
#import "IBMessageCenterViewController.h"
#import "IBMessageContentViewController.h"
#import "HDMessageViewController.h"
#import "IBSettingTableViewController.h"
#import "IBAboutiBestViewController.h"
#import "IBTradeLoginViewController.h"
#import "IBTradeQueryDayDelegateController.h"
#import "IBTradeQueryDayDealController.h"
#import "IBTradeQueryDealRecordController.h"
#import "IBTradeQueryMoneyAccessRecordController.h"
#import "IBTradeQueryNewStockBuyRecordController.h"
#import "IBTradeBusinessStockTransferFatherController.h"
#import "IBTradeBusinessChargeController.h"
#import "IBTradeBusinessWithdrawController.h"
#import "IBTradeQueryStockTransferRecordController.h"
#import "IBTradeBusinessAccountTransferViewController.h"
#import "IBMyPropertyViewController.h"
#import "IBWarrantViewController.h"
#import "IBTradeBusinessNewStockBuyFatherViewController.h"
#import "IBTradeOpenAccountGuideController.h"
#import "IBDBHelper.h"
#import "QNQuoteLineViewController.h"


@implementation IBXRouter


- (void)addRouter {
    ///tabbar  index0
    [self home];
    ///tabbar  index1
    [self market];
    ///tabbar  index2
    [self trade];
    ///tabbar  index3
    [self news];
    ///个人中心
    [self account];
    ///帮助中心
    [self accountHelpCenter];
    ///分享(邀请好友)
    [self inventFriend];
    ///消息中心
    [self messageCenter];
    ///系统消息
    [self systemMessage];
    ///客服消息
    [self serviceMessage];
    ///设置
    [self setting];
    ///关于iBest
    [self aboutIbest];
    ///交易登录
    [self tradeLogin];
    ///iBest登录
    [self ibestLogin];
    ///当日委托
    [self dayDelegate];
    ///当日成交
    [self dayDeal];
    ///成交历史
    [self dealRecord];
    ///资金流水
    [self fundHistory];
    ///新股申购记录
    [self eipoHistory];
    ///股票转仓
    [self stockTransfer];
    ///资金存入
    [self moneyIn];
    ///资金提取
    [self moneyOut];
    ///股票转仓记录
    [self stockTransferHitory];
    ///账户转账
    [self accountTransfer];
    ///我的资产界面
    [self myProperty];
    
    
    [self quoteOptional];//打开行情自选股
    [self quoteHK]; //港股界面
    [self quoteSH]; //沪股界面
    [self quoteSZ]; //深股界面
    [self roundIndexStock]; //环球指数
    [self warrentCenter]; //涡轮中心
    [self newstockSubscribe];//新股申购主页
    [self quoteStockDetail]; //个股详情


}


///首页路由
- (void)home {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"home" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        App().rootTabbarVC.selectedIndex = 0;
                        [ibx.rootViewController.xNavigationcontroller popToRootViewControllerAnimated:YES];
                    });
                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            App().rootTabbarVC.tabBar.hidden = NO;
                            App().rootTabbarVC.selectedIndex = 0;
                        });
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        App().rootTabbarVC.tabBar.hidden = NO;
                        App().rootTabbarVC.selectedIndex = 0;
                    });
                }];
            }
        }
        return YES;
    }];
}


///行情首页路由
- (void)market {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"market" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        App().rootTabbarVC.selectedIndex = 1;
                        [ibx.rootViewController.xNavigationcontroller popToRootViewControllerAnimated:YES];
                    });
                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            App().rootTabbarVC.tabBar.hidden = NO;
                            App().rootTabbarVC.selectedIndex = 1;
                        });
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        App().rootTabbarVC.tabBar.hidden = NO;
                        App().rootTabbarVC.selectedIndex = 1;
                    });
                }];
            }
        }
        return YES;
    }];
}


///交易首页路由
- (void)trade {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"trade" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        App().rootTabbarVC.selectedIndex = 2;
                        [ibx.rootViewController.xNavigationcontroller popToRootViewControllerAnimated:YES];
                    });
                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        App().rootTabbarVC.selectedIndex = 2;
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    App().rootTabbarVC.selectedIndex = 2;
                }];
                
            }
        }
        return YES;
    }];
}




///资讯首页路由
- (void)news {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"news" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        App().rootTabbarVC.selectedIndex = 3;
                        [ibx.rootViewController.xNavigationcontroller popToRootViewControllerAnimated:YES];
                    });
                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        App().rootTabbarVC.selectedIndex = 3;
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    App().rootTabbarVC.selectedIndex = 3;
                }];
                
            }
        }
        return YES;
    }];
}



///个人中心主页路由
- (void)account {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"account" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    if (![ibx.rootViewController isKindOfClass:[IBMineViewController class]]) {
                        IBMineViewController *mianc = [[IBMineViewController alloc] initWithNibName:@"IBMineViewController" bundle:nil];
                        if ([IBGlobalMethod isTradeLogined]) {
                            mianc.loginType =  Mine_loginStatusType_hadTradeLogin;
                        } else if (![IBGlobalMethod isTradeLogined] && [IBGlobalMethod isLogin]) {
                            mianc.loginType =  Mine_loginStatusType_hadNormalLogin;
                        }  else {
                            mianc.loginType =  Mine_loginStatusType_unNormalLogin;
                        }
                        mianc.hidesBottomBarWhenPushed = YES;
                        [ibx.rootViewController.navigationController pushViewController:mianc animated:YES];
                        
                    }

                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        IBMineViewController *mianc = [[IBMineViewController alloc] initWithNibName:@"IBMineViewController" bundle:nil];
                        QNBaseNavController *navc = [[QNBaseNavController alloc] initWithRootViewController:mianc];
                        if ([IBGlobalMethod isTradeLogined]) {
                            mianc.loginType =  Mine_loginStatusType_hadTradeLogin;
                        } else if (![IBGlobalMethod isTradeLogined] && [IBGlobalMethod isLogin]) {
                            mianc.loginType =  Mine_loginStatusType_hadNormalLogin;
                        }  else {
                            mianc.loginType =  Mine_loginStatusType_unNormalLogin;
                        }
                        [ibx.rootViewController presentViewController:navc animated:YES completion:nil];
                    
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    IBMineViewController *mianc = [[IBMineViewController alloc] initWithNibName:@"IBMineViewController" bundle:nil];
                    QNBaseNavController *navc = [[QNBaseNavController alloc] initWithRootViewController:mianc];
                    if ([IBGlobalMethod isTradeLogined]) {
                        mianc.loginType =  Mine_loginStatusType_hadTradeLogin;
                    } else if (![IBGlobalMethod isTradeLogined] && [IBGlobalMethod isLogin]) {
                        mianc.loginType =  Mine_loginStatusType_hadNormalLogin;
                    }  else {
                        mianc.loginType =  Mine_loginStatusType_unNormalLogin;
                    }
                    [c presentViewController:navc animated:YES completion:nil];
                }];
                
            }
        }
        return YES;
    }];
}

///帮助中心路由
- (void)accountHelpCenter {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"account/help-center" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    if (![ibx.rootViewController isKindOfClass:[IBMineViewController class]]) {
                        IBHelpCenterViewController *mianc = [[IBHelpCenterViewController alloc] initWithNibName:@"IBHelpCenterViewController" bundle:nil];
                        mianc.hidesBottomBarWhenPushed = YES;
                        [ibx.rootViewController.navigationController pushViewController:mianc animated:YES];
                    }
                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        IBHelpCenterViewController *mianc = [[IBHelpCenterViewController alloc] initWithNibName:@"IBHelpCenterViewController" bundle:nil];
                        QNBaseNavController *navc = [[QNBaseNavController alloc] initWithRootViewController:mianc];
                        [ibx.rootViewController presentViewController:navc animated:YES completion:nil];
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    IBHelpCenterViewController *mianc = [[IBHelpCenterViewController alloc] initWithNibName:@"IBHelpCenterViewController" bundle:nil];
                    QNBaseNavController *navc = [[QNBaseNavController alloc] initWithRootViewController:mianc];
                    [c presentViewController:navc animated:YES completion:nil];
                }];
            }
        }
        return YES;
    }];
}




///邀请好友
- (void)inventFriend {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"share" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    if (![ibx.rootViewController isKindOfClass:[IBMineViewController class]]) {
                        IBInviteFriendViewController *inventC = [[IBInviteFriendViewController alloc] initWithNibName:@"IBInviteFriendViewController" bundle:nil];
                        
                        inventC.hidesBottomBarWhenPushed = YES;
                        [ibx.rootViewController.navigationController pushViewController:inventC animated:YES];
                    }
                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        IBInviteFriendViewController *inventC = [[IBInviteFriendViewController alloc] initWithNibName:@"IBInviteFriendViewController" bundle:nil];
                        QNBaseNavController *navc = [[QNBaseNavController alloc] initWithRootViewController:inventC];
                        [ibx.rootViewController presentViewController:navc animated:YES completion:nil];
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    IBInviteFriendViewController *inventC = [[IBInviteFriendViewController alloc] initWithNibName:@"IBInviteFriendViewController" bundle:nil];
                    QNBaseNavController *navc = [[QNBaseNavController alloc] initWithRootViewController:inventC];
                    [c presentViewController:navc animated:YES completion:nil];
                }];
            }
        }
        return YES;
    }];
}




///消息中心
- (void)messageCenter {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"account/messages" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    if (![ibx.rootViewController isKindOfClass:[IBMineViewController class]]) {
                        IBMessageCenterViewController *controller = [[IBMessageCenterViewController alloc] initWithNibName:@"IBMessageCenterViewController" bundle:nil];
                        controller.hidesBottomBarWhenPushed = YES;
                        if ([IBGlobalMethod isLogin]) {
                            [ibx.rootViewController.navigationController pushViewController:controller animated:YES];
                        }else {
                            IBLoginMainViewController *ibestLgoin = [[IBLoginMainViewController alloc] init];
                            ibestLgoin.popStyle = IBPopStyleRoutPresent;
                            QNBaseNavController *navc = [[QNBaseNavController alloc] initWithRootViewController:ibestLgoin];
                            [ibx.rootViewController presentViewController:navc animated:YES completion:nil];
                            [ibestLgoin ibestLogin:^(BOOL isIbestLogin) {
                                [ibx.rootViewController.navigationController pushViewController:controller animated:YES];
                            }];
                        }
                    }
                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        IBMessageCenterViewController *controller = [[IBMessageCenterViewController alloc] initWithNibName:@"IBMessageCenterViewController" bundle:nil];
                        QNBaseNavController *navC = [[QNBaseNavController alloc] initWithRootViewController:controller];
                        
                        if ([IBGlobalMethod isLogin]) {
                            [ibx.rootViewController presentViewController:navC animated:YES completion:nil];
                        }else {
                            IBLoginMainViewController *ibestLgoin = [[IBLoginMainViewController alloc] init];
                            QNBaseNavController *navc = [[QNBaseNavController alloc] initWithRootViewController:ibestLgoin];
                            [ibx.rootViewController presentViewController:navc animated:YES completion:nil];
                            [ibestLgoin ibestLogin:^(BOOL isIbestLogin) {
                                [ibx.rootViewController presentViewController:navC animated:YES completion:nil];
                            }];
                        }
                        
                        
                        
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    IBMessageCenterViewController *controller = [[IBMessageCenterViewController alloc] initWithNibName:@"IBMessageCenterViewController" bundle:nil];
                    QNBaseNavController *navc = [[QNBaseNavController alloc] initWithRootViewController:controller];
                    [c presentViewController:navc animated:YES completion:nil];
                }];
            }
        }
        return YES;
    }];
}



///系统消息界面路由
- (void)systemMessage {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"account/messages/system" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    if (![ibx.rootViewController isKindOfClass:[IBMineViewController class]]) {
                        IBMessageContentViewController *controller = [[IBMessageContentViewController alloc] initWithNibName:@"IBMessageContentViewController" bundle:nil];
                        controller.m_Type = MessageContentViewTypePUSH;
                        controller.hidesBottomBarWhenPushed = YES;
                        if ([IBGlobalMethod isLogin]) {
                            [ibx.rootViewController.navigationController pushViewController:controller animated:YES];
                        }else {
                            IBLoginMainViewController *ibestLgoin = [[IBLoginMainViewController alloc] init];
                            ibestLgoin.popStyle = IBPopStyleRoutPresent;
                            QNBaseNavController *navc = [[QNBaseNavController alloc] initWithRootViewController:ibestLgoin];
                            [ibx.rootViewController presentViewController:navc animated:YES completion:nil];
                            [ibestLgoin ibestLogin:^(BOOL isIbestLogin) {
                                if (isIbestLogin) {
                                    [ibx.rootViewController.navigationController pushViewController:controller animated:YES];
                                }
                            }];
                        }
                    }
                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        IBMessageContentViewController *controller = [[IBMessageContentViewController alloc] initWithNibName:@"IBMessageContentViewController" bundle:nil];
                        controller.m_Type = MessageContentViewTypePresent;
                        QNBaseNavController *navC = [[QNBaseNavController alloc] initWithRootViewController:controller];
                        if ([IBGlobalMethod isLogin]) {
                            [ibx.rootViewController presentViewController:navC animated:YES completion:nil];
                        }else {
                            IBLoginMainViewController *ibestLgoin = [[IBLoginMainViewController alloc] init];
                            QNBaseNavController *navc = [[QNBaseNavController alloc] initWithRootViewController:ibestLgoin];
                            [ibx.rootViewController presentViewController:navc animated:YES completion:nil];
                            [ibestLgoin ibestLogin:^(BOOL isIbestLogin) {
                                if (isIbestLogin) {
                                    [ibx.rootViewController presentViewController:navC animated:YES completion:nil];
                                }
                            }];
                        }
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    IBMessageContentViewController *controller = [[IBMessageContentViewController alloc] initWithNibName:@"IBMessageContentViewController" bundle:nil];
                    controller.m_Type = MessageContentViewTypePresent;
                    QNBaseNavController *navc = [[QNBaseNavController alloc] initWithRootViewController:controller];
                    [c presentViewController:navc animated:YES completion:nil];
                }];
            }
        }
        return YES;
    }];
}



///客服消息界面路由
- (void)serviceMessage {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"account/messages/cs" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    if (![ibx.rootViewController isKindOfClass:[IBMineViewController class]]) {
                        HDMessageViewController *controller = [[HDMessageViewController alloc] initWithConversationChatter:HXKF_IM_SERVER_NUM]; // 获取地址：kefu.easemob.com，“管理员模式 > 渠道管理 > 手机APP”页面
                        //HConversation *conversation = [[HChatClient sharedClient].chat getConversation:HXKF_IM_SERVER_NUM];                        controller.hidesBottomBarWhenPushed = YES;
                        if ([IBGlobalMethod isLogin]) {
                            [ibx.rootViewController.navigationController pushViewController:controller animated:YES];
                        }else {
                            IBLoginMainViewController *ibestLgoin = [[IBLoginMainViewController alloc] init];
                            ibestLgoin.popStyle = IBPopStyleRoutPresent;
                            QNBaseNavController *navc = [[QNBaseNavController alloc] initWithRootViewController:ibestLgoin];
                            [ibx.rootViewController presentViewController:navc animated:YES completion:nil];
                            [ibestLgoin ibestLogin:^(BOOL isIbestLogin) {
                                if (isIbestLogin) {
                                    [ibx.rootViewController.navigationController pushViewController:controller animated:YES];
                                }
                            }];
                        }
                    }
                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        HDMessageViewController *controller = [[HDMessageViewController alloc] initWithConversationChatter:HXKF_IM_SERVER_NUM]; // 获取地址：kefu.easemob.com，“管理员模式 > 渠道管理 > 手机APP”页面
                        //HConversation *conversation = [[HChatClient sharedClient].chat getConversation:HXKF_IM_SERVER_NUM];
                        QNBaseNavController *navC = [[QNBaseNavController alloc] initWithRootViewController:controller];
                        if ([IBGlobalMethod isLogin]) {
                            [ibx.rootViewController presentViewController:navC animated:YES completion:nil];
                        }else {
                            IBLoginMainViewController *ibestLgoin = [[IBLoginMainViewController alloc] init];
                            QNBaseNavController *navc = [[QNBaseNavController alloc] initWithRootViewController:ibestLgoin];
                            [ibx.rootViewController presentViewController:navc animated:YES completion:nil];
                            [ibestLgoin ibestLogin:^(BOOL isIbestLogin) {
                                if (isIbestLogin) {
                                    [ibx.rootViewController presentViewController:navC animated:YES completion:nil];
                                }
                            }];
                        }
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    HDMessageViewController *controller = [[HDMessageViewController alloc] initWithConversationChatter:HXKF_IM_SERVER_NUM]; // 获取地址：kefu.easemob.com，“管理员模式 > 渠道管理 > 手机APP”页面
//                    HConversation *conversation = [[HChatClient sharedClient].chat getConversation:HXKF_IM_SERVER_NUM];
                    QNBaseNavController *navc = [[QNBaseNavController alloc] initWithRootViewController:controller];
                    [c presentViewController:navc animated:YES completion:nil];
                }];
            }
        }
        return YES;
    }];
}



///ibest设置界面
- (void)setting {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"account/settings" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    if (![ibx.rootViewController isKindOfClass:[IBMineViewController class]]) {
                        IBSettingTableViewController *controller = [[IBSettingTableViewController alloc] init];
                        controller.hidesBottomBarWhenPushed = YES;
                        [ibx.rootViewController.navigationController pushViewController:controller animated:YES];
                    }
                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        IBSettingTableViewController *controller = [[IBSettingTableViewController alloc] init];
                        QNBaseNavController *navc = [[QNBaseNavController alloc] initWithRootViewController:controller];
                        [ibx.rootViewController presentViewController:navc animated:YES completion:nil];
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    IBSettingTableViewController *controller = [[IBSettingTableViewController alloc] init];
                    QNBaseNavController *navc = [[QNBaseNavController alloc] initWithRootViewController:controller];
                    [c presentViewController:navc animated:YES completion:nil];
                }];
            }
        }
        return YES;
    }];
}

///关于ibest路由
- (void)aboutIbest {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"about" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    if (![ibx.rootViewController isKindOfClass:[IBMineViewController class]]) {
                        IBAboutiBestViewController *controller = [[IBAboutiBestViewController alloc] init];
                        controller.hidesBottomBarWhenPushed = YES;
                        [ibx.rootViewController.navigationController pushViewController:controller animated:YES];
                    }
                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        IBAboutiBestViewController *controller = [[IBAboutiBestViewController alloc] init];
                        QNBaseNavController *navc = [[QNBaseNavController alloc] initWithRootViewController:controller];
                        [ibx.rootViewController presentViewController:navc animated:YES completion:nil];
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    IBAboutiBestViewController *controller = [[IBAboutiBestViewController alloc] init];
                    QNBaseNavController *navc = [[QNBaseNavController alloc] initWithRootViewController:controller];
                    [c presentViewController:navc animated:YES completion:nil];
                }];
            }
        }
        return YES;
    }];
}


///交易登录界面路由
- (void)tradeLogin {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"login-trade" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            IBTradeLoginViewController *controller = [[IBTradeLoginViewController alloc] initWithNibName:@"IBTradeLoginViewController" bundle:nil];
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    if (![ibx.rootViewController isKindOfClass:[IBMineViewController class]]) {
                        controller.hidesBottomBarWhenPushed = YES;
                        if ([IBGlobalMethod isLogin]) {
                            if (![IBGlobalMethod isTradeLogined]) {
                                [ibx.rootViewController presentViewController:controller animated:YES completion:nil];
                            }
                        }else {
                            IBLoginMainViewController *ibestLgoin = [[IBLoginMainViewController alloc] init];
                            ibestLgoin.popStyle = IBPopStyleRoutPresent;
                            QNBaseNavController *navc = [[QNBaseNavController alloc] initWithRootViewController:ibestLgoin];
                            [ibx.rootViewController presentViewController:navc animated:YES completion:nil];
                            [ibestLgoin ibestLogin:^(BOOL isIbestLogin) {
                                [ibx.rootViewController presentViewController:controller animated:YES completion:nil];
                            }];
                        }
                    }
                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        if ([IBGlobalMethod isLogin]) {
                            if (![IBGlobalMethod isTradeLogined]) {
                                [ibx.rootViewController presentViewController:controller animated:YES completion:nil];
                            }
                        }else {
                            IBLoginMainViewController *ibestLgoin = [[IBLoginMainViewController alloc] init];
                            QNBaseNavController *navc = [[QNBaseNavController alloc] initWithRootViewController:ibestLgoin];
                            [ibx.rootViewController presentViewController:navc animated:YES completion:nil];
                            [ibestLgoin ibestLogin:^(BOOL isIbestLogin) {
                                [ibx.rootViewController presentViewController:controller animated:YES completion:nil];
                            }];
                        }
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    if (![IBGlobalMethod isTradeLogined]) {
                        [c presentViewController:controller animated:YES completion:nil];
                    }
                }];
            }
        }
        return YES;
    }];
}








///ibest登录界面
- (void)ibestLogin {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"login-app" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    if (![ibx.rootViewController isKindOfClass:[IBMineViewController class]]) {
                        IBLoginMainViewController *controller = [[IBLoginMainViewController alloc] init];
                        if (![IBGlobalMethod isLogin]) {
                            [ibx.rootViewController presentViewController:controller animated:YES completion:nil];
                        }
                    }
                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        IBLoginMainViewController *controller = [[IBLoginMainViewController alloc] init];
                        if (![IBGlobalMethod isLogin]) {
                            [ibx.rootViewController presentViewController:controller animated:YES completion:nil];
                        }
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    IBLoginMainViewController *controller = [[IBLoginMainViewController alloc] init];
                    if (![IBGlobalMethod isLogin]) {
                        [c presentViewController:controller animated:YES completion:nil];
                    }
                }];
            }
        }
        return YES;
    }];
}










///当日委托界面
- (void)dayDelegate {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"trade/stock/orders" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            IBTradeQueryDayDelegateController *dayDelegate = [[IBTradeQueryDayDelegateController alloc] init];
            dayDelegate.hidesBottomBarWhenPushed = YES;
            
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    if (![ibx.rootViewController isKindOfClass:[IBMineViewController class]]) {
                        [weakSelf fetchControllerFrom:ibx.rootViewController To:dayDelegate type:0];
                    }
                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        [weakSelf fetchControllerFrom:ibx.rootViewController To:dayDelegate type:1];
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    [weakSelf fetchControllerFrom:c To:dayDelegate type:1];
                }];
            }
        }
        return YES;
    }];
}



///当日当日成交界面
- (void)dayDeal {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"trade/stock/filled-orders" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            IBTradeQueryDayDealController *toC = [[IBTradeQueryDayDealController alloc] init];
            toC.hidesBottomBarWhenPushed = YES;
            
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    if (![ibx.rootViewController isKindOfClass:[IBMineViewController class]]) {
                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:0];
                    }
                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:1];
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    [weakSelf fetchControllerFrom:c To:toC type:1];
                }];
            }
        }
        return YES;
    }];
}





///成交历史界面
- (void)dealRecord {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"trade/stock/trades" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            IBTradeQueryDealRecordController *toC = [[IBTradeQueryDealRecordController alloc] init];
            toC.hidesBottomBarWhenPushed = YES;
            
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    if (![ibx.rootViewController isKindOfClass:[IBMineViewController class]]) {
                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:0];
                    }
                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:1];
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    [weakSelf fetchControllerFrom:c To:toC type:1];
                }];
            }
        }
        return YES;
    }];
}



///资金流水
- (void)fundHistory {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"trade/stock/fund-history" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            IBTradeQueryMoneyAccessRecordController *toC = [[IBTradeQueryMoneyAccessRecordController alloc] init];
            toC.hidesBottomBarWhenPushed = YES;
            
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    if (![ibx.rootViewController isKindOfClass:[IBMineViewController class]]) {
                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:0];
                    }
                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:1];
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    [weakSelf fetchControllerFrom:c To:toC type:1];
                }];
            }
        }
        return YES;
    }];
}





///新股申购记录
- (void)eipoHistory {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"trade/stock/eipo-history" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            IBTradeQueryNewStockBuyRecordController *toC = [[IBTradeQueryNewStockBuyRecordController alloc] init];
            toC.hidesBottomBarWhenPushed = YES;
            
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    if (![ibx.rootViewController isKindOfClass:[IBMineViewController class]]) {
                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:0];
                    }
                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:1];
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    [weakSelf fetchControllerFrom:c To:toC type:1];
                }];
            }
        }
        return YES;
    }];
}






///股票转仓
- (void)stockTransfer {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"trade/stock/settlement-instruction" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            IBTradeBusinessStockTransferFatherController *toC = [[IBTradeBusinessStockTransferFatherController alloc] init];
            toC.hidesBottomBarWhenPushed = YES;
            
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    if (![ibx.rootViewController isKindOfClass:[IBMineViewController class]]) {
                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:0];
                    }
                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:1];
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    [weakSelf fetchControllerFrom:c To:toC type:1];
                }];
            }
        }
        return YES;
    }];
}



///资金存入
- (void)moneyIn {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"trade/stock/fund-deposit" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            IBTradeBusinessChargeController *toC = [[IBTradeBusinessChargeController alloc] init];
            toC.hidesBottomBarWhenPushed = YES;
            
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    if (![ibx.rootViewController isKindOfClass:[IBMineViewController class]]) {
                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:0];
                    }
                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:1];
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    [weakSelf fetchControllerFrom:c To:toC type:1];
                }];
            }
        }
        return YES;
    }];
}



///资金提取
- (void)moneyOut {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"trade/stock/fund-withdraw" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            IBTradeBusinessWithdrawController *toC = [[IBTradeBusinessWithdrawController alloc] init];
            toC.hidesBottomBarWhenPushed = YES;
            
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    if (![ibx.rootViewController isKindOfClass:[IBMineViewController class]]) {
                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:0];
                    }
                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:1];
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    [weakSelf fetchControllerFrom:c To:toC type:1];
                }];
            }
        }
        return YES;
    }];
}


///股票转仓记录
- (void)stockTransferHitory {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"trade/stock/stock-movement-history" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            IBTradeQueryStockTransferRecordController *toC = [[IBTradeQueryStockTransferRecordController alloc] init];
            toC.hidesBottomBarWhenPushed = YES;
            
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    if (![ibx.rootViewController isKindOfClass:[IBMineViewController class]]) {
                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:0];
                    }
                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:1];
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    [weakSelf fetchControllerFrom:c To:toC type:1];
                }];
            }
        }
        return YES;
    }];
}




///账户转账
- (void)accountTransfer {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"trade/stock/fund-transfer" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            IBTradeBusinessAccountTransferViewController *toC = [[IBTradeBusinessAccountTransferViewController alloc] init];
            toC.hidesBottomBarWhenPushed = YES;
            
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    if (![ibx.rootViewController isKindOfClass:[IBMineViewController class]]) {
                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:0];
                    }
                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:1];
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    [weakSelf fetchControllerFrom:c To:toC type:1];
                }];
            }
        }
        return YES;
    }];
}


///我的资产
- (void)myProperty {
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"account/summary" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            IBMyPropertyViewController *toC = [[UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"IBMyPropertyViewController"];
            toC.hidesBottomBarWhenPushed = YES;
            
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    if (![ibx.rootViewController isKindOfClass:[IBMineViewController class]]) {
                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:0];
                    }
                }
                ///当前界面是present出来的
                else {
                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:1];
                    }];
                }
            }else {
                [c dismissViewControllerAnimated:YES completion:^{
                    [weakSelf fetchControllerFrom:c To:toC type:1];
                }];
            }
        }
        return YES;
    }];
}




#pragma mark 行情
-(void)quoteOptional
{
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"market/sec/watch-list" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    [ibx.rootViewController.xNavigationcontroller popToRootViewControllerAnimated:YES];
                    App().rootTabbarVC.selectedIndex = 1;
                    App().rootTabbarVC.subVcIndex = 0;
                    
                }
                ///当前界面是present出来的
                else {
//                    [ibx.rootViewController dismisszViewControllerAnimated:YES completion:^{
//                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:1];
//                    }];
                }
            }else {
//                [c dismissViewControllerAnimated:YES completion:^{
//                    [weakSelf fetchControllerFrom:c To:toC type:1];
//                }];
            }
        }
        return YES;
    }];
}



-(void)quoteStockDetail //个股详情
{
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"market/sec/:assetId" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {

        NSString * assetId = parameters[@"assetId"];
        NSLog(@"%@",assetId);
        [IBDBHelper searchStockDbQueryWithAssetId:assetId ResultBlock:^(NSArray *stocks, NSError *error) {
            if (stocks.count>0) {
//                QNStock * stock =stocks.firstObject;

                dispatch_async(dispatch_get_main_queue(), ^{
                    ///不是从kill状态启动app 的话,这里要处理跳转
                    if (App().firstLaunchApp == NO) {
                        UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
                        if ([c isKindOfClass:[IBXViewController class]]) {
                            IBXViewController *ibx = (IBXViewController *)c;
                            ///当前界面是push进来的
                            if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                                [ibx.rootViewController.xNavigationcontroller popToRootViewControllerAnimated:YES];
                                App().rootTabbarVC.selectedIndex = 1;
                                App().rootTabbarVC.subVcIndex = 0;

                                QNBaseNavController * navc = App().rootTabbarVC.viewControllers[1];

                                IBXViewController * rootvc =(IBXViewController *) navc.viewControllers.lastObject ;

                                QNQuoteLineViewController *lineVC = [[QNQuoteLineViewController alloc] initWithGroupName:nil  stocks:stocks currentPage:0];
                                lineVC.hidesBottomBarWhenPushed = YES;
                                [rootvc.rootViewController.navigationController pushViewController:lineVC animated:YES];

                            }
                            ///当前界面是present出来的
                            else {
                            }
                        }else {

                        }
                    }
                });


            }else{
                NSLog(@"码表中无该股票");
            }
        }];


        return YES;
    }];
}


//涡轮中心
-(void)warrentCenter
{
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"market/sec/warrants" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            IBWarrantViewController * wc = [[IBWarrantViewController alloc] init];
            wc.hidesBottomBarWhenPushed = YES;
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
            
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
 
                    [ibx.rootViewController.navigationController pushViewController:wc animated:YES ];
                    
                }
                ///当前界面是present出来的
                else {
//                    [ibx.rootViewController dismissViewControllerAnimated:YES completion:^{
//                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:1];
//                    }];
                }
            }else {
//                [c dismissViewControllerAnimated:YES completion:^{
//                    [weakSelf fetchControllerFrom:c To:toC type:1];
//                }];
            }
        }
        return YES;
    }];
}

//去环球指数
-(void)roundIndexStock
{
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"market/sec/global-indexes" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    [ibx.rootViewController.xNavigationcontroller popToRootViewControllerAnimated:YES];
                    App().rootTabbarVC.selectedIndex = 1;
                    
                    App().rootTabbarVC.subVcIndex = 4;
          
                    
                }
                ///当前界面是present出来的
                else {
                    //                    [ibx.rootViewController dismisszViewControllerAnimated:YES completion:^{
                    //                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:1];
                    //                    }];
                }
            }else {
                //                [c dismissViewControllerAnimated:YES completion:^{
                //                    [weakSelf fetchControllerFrom:c To:toC type:1];
                //                }];
            }
        }
        return YES;
    }];
}

-(void)quoteHK
{
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"market/sec/hkex" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    [ibx.rootViewController.xNavigationcontroller popToRootViewControllerAnimated:YES];
                    App().rootTabbarVC.selectedIndex = 1;
                    
                    App().rootTabbarVC.subVcIndex = 1;
                    
                }
                ///当前界面是present出来的
                else {
                    //                    [ibx.rootViewController dismisszViewControllerAnimated:YES completion:^{
                    //                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:1];
                    //                    }];
                }
            }else {
                //                [c dismissViewControllerAnimated:YES completion:^{
                //                    [weakSelf fetchControllerFrom:c To:toC type:1];
                //                }];
            }
        }
        return YES;
    }];
}

-(void)quoteSH
{
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"market/sec/sh-connect" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    [ibx.rootViewController.xNavigationcontroller popToRootViewControllerAnimated:YES];
                    App().rootTabbarVC.selectedIndex = 1;
                    
                    App().rootTabbarVC.subVcIndex = 2;
                    
                }
                ///当前界面是present出来的
                else {
                    //                    [ibx.rootViewController dismisszViewControllerAnimated:YES completion:^{
                    //                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:1];
                    //                    }];
                }
            }else {
                //                [c dismissViewControllerAnimated:YES completion:^{
                //                    [weakSelf fetchControllerFrom:c To:toC type:1];
                //                }];
            }
        }
        return YES;
    }];
}


-(void)quoteSZ
{
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"market/sec/sz-connect" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController *c = [weakSelf topViewController:App().rootTabbarVC];
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController *ibx = (IBXViewController *)c;
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    [ibx.rootViewController.xNavigationcontroller popToRootViewControllerAnimated:YES];
                    App().rootTabbarVC.selectedIndex = 1;
                    
                    App().rootTabbarVC.subVcIndex = 3;
                    
                }
                ///当前界面是present出来的
                else {
                    //                    [ibx.rootViewController dismisszViewControllerAnimated:YES completion:^{
                    //                        [weakSelf fetchControllerFrom:ibx.rootViewController To:toC type:1];
                    //                    }];
                }
            }else {
                //                [c dismissViewControllerAnimated:YES completion:^{
                //                    [weakSelf fetchControllerFrom:c To:toC type:1];
                //                }];
            }
        }
        return YES;
    }];
}

//新股申购主页
-(void)newstockSubscribe
{
    WEAKSELF
    [[JLRoutes routesForScheme:@"ibest"] addRoute:@"market/sec/eipo" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///不是从kill状态启动app 的话,这里要处理跳转
        if (App().firstLaunchApp == NO) {
            UIViewController * c = [weakSelf topViewController:App().rootTabbarVC];
            
            IBTradeBusinessNewStockBuyFatherViewController *subVc = [[IBTradeBusinessNewStockBuyFatherViewController alloc] init];
            subVc.hidesBottomBarWhenPushed = YES;
            if ([c isKindOfClass:[IBXViewController class]]) {
                IBXViewController * ibx = (IBXViewController *)c;
                
                ///当前界面是push进来的
                if (ibx.rootViewController.xNavigationcontroller && ibx.rootViewController.xNavigationcontroller.viewControllers.count) {
                    
                    if(![ibx.rootViewController isKindOfClass:[IBTradeBusinessNewStockBuyFatherViewController class]]){
                        [weakSelf jumpViewControllerFromVC:ibx.rootViewController to:subVc type:0];
                        
                    }
                }else{ //当前界面是present出来的
                    
                }
            
            }
        }
        
        return YES;
    }];
}
     
#pragma mark 行情需要交易登录才能跳的
     
 /**
  行情用

  @param fromC 出发界面
  @param toC 跳转到的界面
  @param type 0:push ; 1:present
  */
 -(void)jumpViewControllerFromVC:(UIViewController *)fromC to:(UIViewController *)toVC type:(NSInteger )type{
     
     if ([IBGlobalMethod isLogin] == NO) {   //是否iBest登录
         IBLoginMainViewController *ibestLgoin = [[IBLoginMainViewController alloc] init];
         ibestLgoin.popStyle = IBPopStyleRoutPresent;
         [fromC presentViewController:ibestLgoin animated:YES completion:nil];
         [ibestLgoin ibestLogin:^(BOOL isIbestLogin) {
             if (isIbestLogin) {
                 IBTradeLoginViewController *controller = [[IBTradeLoginViewController alloc] initWithNibName:@"IBTradeLoginViewController" bundle:nil];
                 [fromC presentViewController:controller animated:YES completion:nil];
                 [controller loginSuccessWithBlock:^(BOOL success, NSString *inftorType) {
                     if (success) {
                         if (type == 0) {
                             [fromC.navigationController pushViewController:toVC animated:YES];
                         }else {
                             [fromC presentViewController:toVC animated:YES completion:nil];
                         }
                     }
                 }];
             }
         }];
         return;
     }
     
     //是否有交易账号
    NSString * accountid = [IBGlobalMethod  getNewStockReqAccount].length>0?[IBGlobalMethod  getNewStockReqAccount]:@"";
     if([[IBTradeLoginModle alloc] init].TRAC.length>0) {
         accountid = [[IBTradeLoginModle alloc] init].TRAC;
     }
      if([IBGlobalMethod getTradeAccountId].length>0) {
          if([IBGlobalMethod isTradeLogined] == YES){
              if(type == 0){
                  [fromC.navigationController  pushViewController:toVC animated:YES];
              }else{
                  [fromC  presentViewController:toVC animated:YES completion:nil];
              }
          }else{
              IBTradeLoginViewController *controller = [[IBTradeLoginViewController alloc] initWithNibName:@"IBTradeLoginViewController" bundle:nil];
              [fromC presentViewController:controller animated:YES completion:nil];
              [controller loginSuccessWithBlock:^(BOOL success, NSString *inftorType) {
                  if (success) {
                      if (type == 0) {
                          [fromC.navigationController pushViewController:toVC animated:YES];
                      }else {
                          [fromC presentViewController:toVC animated:YES completion:nil];
                      }
                  }
              }];
          }
      }else{ //去开户界面
          IBTradeOpenAccountGuideController  *openC = [[UIStoryboard storyboardWithName:@"TradeMain" bundle:nil] instantiateViewControllerWithIdentifier:@"IBTradeOpenAccountGuideController"];
          openC.m_Type = TradeOpenAccountGuideType_StockDeal;
          openC.hidesBottomBarWhenPushed = YES;
          [fromC.navigationController pushViewController:openC animated:YES];
      }
     
 }





#pragma mark    交易相关跳转封装

/**
 ///交易下一级界面判断跳入的逻辑

 @param fromC 出发界面
 @param toC 跳转到的界面
 @param type 0:push ; 1:present
 */
- (void)fetchControllerFrom:(UIViewController *)fromC To:(UIViewController *)toC  type:(NSInteger)type{
    if ([IBGlobalMethod isTradeLogined]) {
        if (type == 0) {
            [fromC.navigationController pushViewController:toC animated:YES];
        }else {
            [fromC presentViewController:toC animated:YES completion:nil];
        }
    }else {
        if ([IBGlobalMethod isLogin]) {
            if ([IBGlobalMethod getTradeAccountId].length > 2) {
                IBTradeLoginViewController *controller = [[IBTradeLoginViewController alloc] initWithNibName:@"IBTradeLoginViewController" bundle:nil];
                [fromC presentViewController:controller animated:YES completion:nil];
                [controller loginSuccessWithBlock:^(BOOL success, NSString *inftorType) {
                    if (success) {
                        if (type == 0) {
                            [fromC.navigationController pushViewController:toC animated:YES];
                        }else {
                            [fromC presentViewController:toC animated:YES completion:nil];
                        }
                    }
                }];
            }else {
                IBTradeOpenAccountGuideController  *openC = [[UIStoryboard storyboardWithName:@"TradeMain" bundle:nil] instantiateViewControllerWithIdentifier:@"IBTradeOpenAccountGuideController"];
                openC.m_Type = TradeOpenAccountGuideType_StockDeal;
                QNBaseNavController *navC = [[QNBaseNavController alloc] initWithRootViewController:openC];
                [fromC presentViewController:navC animated:YES completion:nil];
            }
        }else {
            IBLoginMainViewController *ibestLgoin = [[IBLoginMainViewController alloc] init];
            ibestLgoin.popStyle = IBPopStyleRoutPresent;
            [fromC presentViewController:ibestLgoin animated:YES completion:nil];
            [ibestLgoin ibestLogin:^(BOOL isIbestLogin) {
                if (isIbestLogin) {
                    if ([IBGlobalMethod getTradeAccountId].length > 2) {
                        IBTradeLoginViewController *controller = [[IBTradeLoginViewController alloc] initWithNibName:@"IBTradeLoginViewController" bundle:nil];
                        [fromC presentViewController:controller animated:YES completion:nil];
                        [controller loginSuccessWithBlock:^(BOOL success, NSString *inftorType) {
                            if (success) {
                                if (type == 0) {
                                    [fromC.navigationController pushViewController:toC animated:YES];
                                }else {
                                    [fromC presentViewController:toC animated:YES completion:nil];
                                }
                            }
                        }];
                    }else {
                        IBTradeOpenAccountGuideController  *openC = [[UIStoryboard storyboardWithName:@"TradeMain" bundle:nil] instantiateViewControllerWithIdentifier:@"IBTradeOpenAccountGuideController"];
                        openC.m_Type = TradeOpenAccountGuideType_StockDeal;
                        QNBaseNavController *navC = [[QNBaseNavController alloc] initWithRootViewController:openC];
                        [fromC presentViewController:navC animated:YES completion:nil];
                    }
                }
            }];
        }
    }
}




#pragma mark    获取当前正在显示的界面
- (UIViewController *)topViewController:(UIViewController *)rootViewController {
    UIViewController *topViewController = rootViewController;
    if (topViewController.presentedViewController) {
        return [self topViewController:topViewController.presentedViewController];
    }
    if ([topViewController isKindOfClass:[UINavigationController class]]) {
        return [self topViewController:((UINavigationController *)topViewController).viewControllers.lastObject];
    }
    if ([topViewController isKindOfClass:[UITabBarController class]]) {
        return [self topViewController:((UITabBarController *)topViewController).selectedViewController];
    }
    return topViewController;
}









@end
 
