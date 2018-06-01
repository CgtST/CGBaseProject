
//
//  QNLaunchingViewController.m
//  QNApp
//
//  Created by manny on 14-11-14.
//  Copyright (c) 2014年 Bacai. All rights reserved.
//

#import "IBLaunchingViewController.h"
#import "IBLaunchingVCViewModel.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCellularData.h>
#import "IBNoNetWorkViewController.h"
#import "IBGuideViewController.h"
#import "UIImage+LaunchImage.h"
#import "IBRootTabBarViewController.h"
#import "IBUserData.h"

/*

#import <WebKit/WebKit.h>

#import "QNLoginViewController.h"

//#import "QNOpenPlatformManager.h"
#import "QNViewControllerHelper.h"
#import "IBDBHelper.h"
#import "IBRootTabBarViewController.h"
#import "IBMessageContentViewController.h"

#import "IBUpdateMarginDbReq.h"
//#import "IBDataBaseManager.h"
#import "IBCustomActivity.h"
#import "IBLoginRegistShowViewController.h"
#import <JLRoutes.h>
#import "IBXRouter.h"
#import "QNLaunchingViewController+IBRouterLaunchVC.h"
#import "IBUnifyRegisterViewController.h"
#import "MBProgressHUD+Add.h"
#import "LEEAlert.h"


*/



@interface IBLaunchingViewController ()<IBNoNetDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBLaunchingVCViewModel *viewModel;
@property (nonatomic) NSUInteger loginfailCount;
@property (nonatomic,strong) IBGuideViewController * guideVC;

/*

@property (nonatomic,strong) IBUpdateMarginDbReq * updateMarginReq;

@property (nonatomic) BOOL bNoNet;*/
@property (nonatomic) IBFuncType funcType;

@end


@implementation IBLaunchingViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [self setupViewModel];
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.translucent = YES;
    self.imageView.image = [UIImage launchImage];
    
   /* self.loginfailCount = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionLoginInvalid:) name:@"IBSessionLoginInvalid" object:nil];
    [self clearWebCacheData];
    
    [ ibFXHandler() ibFXGetSysCfgWithView:nil];





    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleNetWorkChangeNotify:)
                                                 name: kReachabilityChangedNotification
                                               object: nil]; //检测网络状态

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];*/
    
}

- (void)viewDidAppear:(BOOL)animated {

    //目前暂时先这样做，以后需要更改--170303

     [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
//    [self checkIBStocksTableVersion];
//    [self checkMarginDbVersion];   //更新可融资码表
    
    
    //是否需要显示程序过渡页面
    if ([self.viewModel neededShowGuidanceViewController])  {
        [self showGuidanceViewController];
    } else {
//          [self handleNoNetWork]; //当前网络不可用
        [self IBAutoLogin];
        [self gotoAppHome];
    }
}




/*
//更新可融资码表DB
-(void)checkMarginDbVersion
{
    NSString * marginVersion = [IBDBHelper getMarginDBVersion];
//     NSLog(@"marginVersion %@",marginVersion);

    [self.updateMarginReq reqUpdateMarginDbWithVersion:marginVersion resultBlock:^(NSArray *adds, NSArray *expires, NSArray *updates, int64_t lastVersion, NSError *error) {
        
        ///added         需要增加
        ///expired       需要删除的
        ///updated       某个字段变更仅需更新
        if (![adds isKindOfClass:[NSArray class]]) {
            adds = @[];
        }
        if (![expires isKindOfClass:[NSArray class]]) {
            expires = @[];
        }
        if (![updates isKindOfClass:[NSArray class]]) {
            updates = @[];
        }
        if (!error) {
            if (lastVersion >[marginVersion intValue])
            {
                dispatch_group_t group = dispatch_group_create();
                dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSMutableArray * deleteArr = [expires mutableCopy];
                    if ([updates isKindOfClass:[NSArray class]])
                    {
                        [deleteArr addObjectsFromArray:updates];
                    }
                    [NetService().quoteManager deleteIBMarginDbWithStock:deleteArr WithShouldAdd:NO];
                    NSMutableArray * addArr = [adds mutableCopy];
                    [addArr addObjectsFromArray:updates];
                    
                    [NetService().quoteManager addIBMarginDBWithStock:addArr];
                    
                    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                        [NetService().quoteManager updateMarginTableDBVersion:[NSString stringWithFormat:@"%lld" ,lastVersion]];
                    });
                });
            }
        }else{


        }
        
    }];
    
}



#pragma mark - 更新股票码表数据库
-(void)checkIBStocksTableVersion {
    __block  NSString * stockDbVersion = [IBDBHelper getAppdataStockDBVersion];
    [NetService().quoteHandler updateIBStockList:stockDbVersion resultBlock:^(NSArray *added, NSArray *expired, NSArray *updated, int64_t latelyVersion, NSError *err) {
       ///added         需要增加
       ///expired       需要删除的
       ///updated       某个字段变更仅需更新
        if (![added isKindOfClass:[NSArray class]]) {
            added = @[];
        }
        if (![expired isKindOfClass:[NSArray class]]) {
            expired = @[];
        }
        if (![updated isKindOfClass:[NSArray class]]) {
            updated = @[];
        }
        
        
        if (!err) {
            if (latelyVersion >[stockDbVersion intValue]) {
                //更新数据库
                //创建队列组
                dispatch_group_t group = dispatch_group_create();

                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                
                dispatch_group_async(group, queue, ^{
                    NSMutableArray *deleteArr = [expired mutableCopy];
                    if ([updated isKindOfClass:[NSArray class]]) {
                        [deleteArr addObjectsFromArray:updated];
                    }
                    if ([added isKindOfClass:[NSArray class]]) {
                        [deleteArr addObjectsFromArray:added];
                    }
                    [NetService().quoteManager deleteIBStockTableDBWithStock:deleteArr withShouldAdd:NO] ;
                    NSMutableArray *addArr = [added mutableCopy];
                    [addArr addObjectsFromArray:updated];
                    [NetService().quoteManager addIBStockTableDBWithStock:addArr] ;
                });
                
                
                dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                    [NetService().quoteManager updateStocksTableDBVersion:[NSString stringWithFormat:@"%lld", latelyVersion ]];
                });
            }
        }else{
            
        }
    }];
}
*/



#pragma mark - Private

//目前暂时先这样做，以后需要更改--170303
- (void)IBAutoLogin {
    WEAKSELF
    ///不论是正式用户或者游客登录成功回调
    [self.viewModel IBAutoLoginFromLaunchingView:^(BOOL loginResult) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (loginResult) {
                
            } else {
                
            }
        });
       
    }];
   
}




#pragma mark - Alert Delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
//    self.loginfailCount++;
//    if(self.loginfailCount>2){   // 三次失败后，重新登录
//        self.loginfailCount = 0;
////         [IBViewControllerHelp showLoginRegistControllerWithBTradeLogin:IBQTLoginTypeOnlyQLogin];
//    }else{
////        [QNRemindView showMessag:@"正在努力连接网络..." toView:self.view];
////        [self IBAutoLogin]; //重试
//    }
}

//去App首页
-(void)gotoAppHome
{
//    WEAKSELF
    
    IBRootTabBarViewController * controller = App().rootTabbarVC;
    controller.view.frame = [UIScreen mainScreen].bounds;
    [App().window setRootViewController: controller];
    
    [[UIApplication sharedApplication] setStatusBarHidden: NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    controller.selectedIndex = 0;
    
    
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:OperationGuide_Home2];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
//    });
//    [self.viewModel IBAutoLoginFromLaunchingView:^(BOOL loginResult) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
//        });
//        if (loginResult) {
//            ///openInstall定向推广下载上传信息(第一次安装, 然后打开)
//            if (App().ibestKey.length) {
//                [NetService().userHandler saveOpenInstallInforWithIbestKey:App().ibestKey];
//            }
//            IBRootTabBarViewController * controller = [[IBRootTabBarViewController alloc] init];
//            App().rootTabbarVC = controller;
//            controller.view.frame = [UIScreen mainScreen].bounds;
//            [App().window setRootViewController: controller];
//            [[UIApplication sharedApplication] setStatusBarHidden: NO];
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//            controller.selectedIndex = 0;
//        }else{
//            [QNRemindView showMessag:CustomLocalizedString(@"QYOUKEDENGLUSHIBAI", nil) toView:weakSelf.view];
//        }
//    }];
//
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kNeededShowGuidanceKey] == NO) //不显示引导
    {
        [[NSUserDefaults standardUserDefaults]  setBool:YES forKey:kNeededShowGuidanceKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


//马上注册
-(void)gotoRegistNow
{
  /*  WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
    });

    [self.viewModel IBAutoLoginFromLaunchingView:^(BOOL loginResult) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        });
        if (loginResult) {
             [MobClick event:@"guid_regist_now"];
            ///openInstall定向推广下载上传信息(第一次安装, 然后打开)
            if (App().ibestKey.length) {
                [NetService().userHandler saveOpenInstallInforWithIbestKey:App().ibestKey];
            }
            IBRootTabBarViewController * controller = [[IBRootTabBarViewController alloc] init];
            App().rootTabbarVC = controller;
            controller.view.frame = [UIScreen mainScreen].bounds;
            [App().window setRootViewController: controller];
            [[UIApplication sharedApplication] setStatusBarHidden: NO];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            controller.selectedIndex = 0;
            QNBaseNavController *navC = controller.viewControllers.firstObject;
            IBXViewController *ibxVC = navC.viewControllers.firstObject;
            IBUnifyRegisterViewController  * fastVC = [[IBUnifyRegisterViewController alloc] init];
            fastVC.hidesBottomBarWhenPushed = YES;
            [ibxVC.rootViewController.navigationController pushViewController:fastVC animated:YES];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:kNeededShowGuidanceKey] == NO)  {
                [[NSUserDefaults standardUserDefaults]  setBool:YES forKey:kNeededShowGuidanceKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }else{
            [QNRemindView showMessag:CustomLocalizedString(@"QYOUKEDENGLUSHIBAI", nil) toView:weakSelf.view];
        }
    }];*/
}

//引导页
- (void)showGuidanceViewController {
    
    if (![MainController() isKindOfClass:[IBGuideViewController class]]) {
        

        IBBaseNavController * guidNVC = [[IBBaseNavController alloc] initWithRootViewController:self.guideVC];
        [App().window setRootViewController:guidNVC];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];

        WEAKSELF
        ///mark 先看看  跳转到app首页
        [self.guideVC setJumpBlock:^{
            weakSelf.funcType = IBFuncTypeJustLook;
            if ([self limitByCTCellularDataRestrictedState]==kCTCellularDataRestricted) //权限被关闭
            {
                 [weakSelf handleNoNetWork]; //当前网络不可用
            }else{
                 if ([NetService().reachability currentReachabilityStatus]== NotReachable)
                 {
                     [weakSelf handleNoNetWork]; //当前网络不可用
                 }else{
                     [weakSelf gotoAppHome];
                 }
            }
              [weakSelf gotoAppHome];
        }];

        ///mark 这里不允许动！--跳转到,
        [self.guideVC setFinishBlock:^{
            weakSelf.funcType = IBFuncTypeRegistNow;
            if ([self limitByCTCellularDataRestrictedState]==kCTCellularDataRestricted) //权限被关闭
            {
                [weakSelf handleNoNetWork]; //当前网络不可用
            }else{
                if ([NetService().reachability currentReachabilityStatus]== NotReachable)
                {
                    [weakSelf handleNoNetWork]; //当前网络不可用
                }else{
                    [weakSelf gotoRegistNow];
                }
            }
            [weakSelf gotoAppHome];
//             [weakSelf gotoRegistNow];
        }];
    }
}

- (void) setupViewModel {
    IBLaunchingVCViewModel *viewModel = [[IBLaunchingVCViewModel alloc] init];
    self.viewModel = viewModel;
}

-(IBGuideViewController *)guideVC
{
    if (_guideVC == nil) {
        _guideVC =  [[IBGuideViewController alloc] init];
    }
    return _guideVC;
}

/*
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RemotePushLaunchAPP object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IBSessionLoginInvalid" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    NSLog(@"[%@---------------dealloc]", self.class);
}



#pragma mark - 检测无线数据权限



#pragma mark -
-(void)sessionLoginInvalid:(NSNotification *)notify
{
    [self IBAutoLogin]; //再次登录
}

#pragma mark - 检测更新
-(void)checkUpdateApp
{
//    [NetService().commonHandler updateCheckResultBlock:nil
//                                                      needShowError:NO
//                                                         ignoreCode:nil
//                                                        resultBlock:^(QNUpdateCheckResult *result, NSError *err)   {
//                      NSLog(@"update %@",result);
//
//                  }];
}


//清除网页缓存
-(void)clearWebCacheData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[UIDevice currentDevice] systemVersion].floatValue>=9.0) {
            [self clearWebData];
        }else{
            NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]; NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"]; NSError *errors; [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
        }

    });
}



-(void)clearWebData
{
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    
    // Date from
    
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    // Execute
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
    }];
}*/

/*
-(IBUpdateMarginDbReq *)updateMarginReq
{
    if (_updateMarginReq == nil) {
        _updateMarginReq = [[IBUpdateMarginDbReq alloc] init];
    }
    return _updateMarginReq;
}*/


#pragma mark - 网络变化

//ios 应用网络权限
-(CTCellularDataRestrictedState )limitByCTCellularDataRestrictedState
{
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    CTCellularDataRestrictedState state = cellularData.restrictedState;
//    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
//        switch (state) {
//            case kCTCellularDataRestricted: NSLog(@"Restricrted"); break;
//            case kCTCellularDataNotRestricted: NSLog(@"Not Restricted"); break;
//                //未知，第一次请求
//            case kCTCellularDataRestrictedStateUnknown: NSLog(@"Unknown"); break;
//            default: break;
//
//
//        }
//    };
    switch (state) {
        case kCTCellularDataRestricted:
            NSLog(@"Restricrted");
            break;
        case kCTCellularDataNotRestricted:
            NSLog(@"Not Restricted");
            break;
        case kCTCellularDataRestrictedStateUnknown:
            NSLog(@"Unknown");
            break;
        default:
            break;
    }

    return state;
}

-(void)loadAgain
{
    if (self.funcType == IBFuncTypeRegistNow) {
        if ([self limitByCTCellularDataRestrictedState]==kCTCellularDataRestricted) //权限被关闭
        {
            [self handleNoNetWork]; //当前网络不可用
        }else{
            if ([NetService().reachability currentReachabilityStatus]== NotReachable)
            {
                [self handleNoNetWork]; //当前网络不可用
            }else{
                [self gotoRegistNow];
            }
        }

    }else{
        if ([self limitByCTCellularDataRestrictedState]==kCTCellularDataRestricted) //权限被关闭
        {
            [self handleNoNetWork]; //当前网络不可用
        }else{
            if ([NetService().reachability currentReachabilityStatus]== NotReachable)
            {
                [self handleNoNetWork]; //当前网络不可用
            }else{
                [self gotoAppHome];
            }
        }
    }
}

-(void)handleNoNetWork
{
  /*  if ([NetService().reachability currentReachabilityStatus]== NotReachable)
    {
        WEAKSELF
        [LEEAlert alert].config.LeeTitle(CustomLocalizedString(@"MINEWENXINTISHI", nil)).LeeContent(CustomLocalizedString(@"QDQWLBKYQJCNDWLSHEZ", nil)).LeeAction(CustomLocalizedString(@"TRADE_ACTIONSHEET_CANCEL", nil), ^{

        }).LeeCancelAction(CustomLocalizedString(@"QQUSHEZHE", nil), ^{
            if ([self.viewModel neededShowGuidanceViewController]) {
                IBNoNetWorkViewController * netVC = [[IBNoNetWorkViewController alloc] initWithNibName:@"IBNoNetWorkViewController" bundle:nil];
                netVC.isFirst = YES;

                netVC.delegate = weakSelf;
                [self.guideVC presentViewController:netVC animated:YES completion:^{
                }];
            }else{
                IBNoNetWorkViewController * netVC = [[IBNoNetWorkViewController alloc] init];
                netVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:netVC animated:YES];
            }

        }).LeeShow();
    }*/
}
/*
-(void)handleNetWorkChangeNotify:(NSNotificationCenter *)notify
{
    if(!(self.viewLoaded && self.view.window))
    {
        return;
    }

    NetworkStatus netStatus =  [ NetService().reachability currentReachabilityStatus];
    if (netStatus == NotReachable) {
        self.bNoNet = YES;
        [self handleNoNetWork];
    }else{
        NSLog(@"有网络");

            [self IBAutoLogin];

    }
}


-(void)didBecomeActive
{
    if ( [self isViewLoaded]&& self.view.window)
    {
        if ([NetService().reachability currentReachabilityStatus]== NotReachable)
        {
             [self handleNoNetWork];
        }else{
//            [self IBAutoLogin];
        }
    }
}
*/

@end
