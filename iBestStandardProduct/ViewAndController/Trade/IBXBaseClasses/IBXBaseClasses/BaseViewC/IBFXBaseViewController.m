//
//  IBFXBaseViewController.m
//  iBestProduct
//
//  Created by xboker on 2017/12/5.
//  Copyright © 2017年 iBest. All rights reserved.
//

#import "IBFXBaseViewController.h"
#import "IBFXLoginModel.h"
#import "IBFXHomeModel.h"
#import "QNAppDelegate.h"
#import "IBRootTabBarViewController.h"
#import "IBFXLoginViewController.h"
#import "IBFXLoginViewController.h"
#import "IBFXSheetView.h"

@interface IBFXBaseViewController ()
@property (nonatomic, strong) IBFXLoginModel    *m_ReconnectSocket;
@end

@implementation IBFXBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketReconnect:) name:kSocket_Reconnect object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ibestLoginOut:) name:kIBNotify_Logout_Success object:nil];
    if (![self isKindOfClass:[IBFXLoginViewController class]]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reLoginFX_PM:) name:FX_PM_Infor_ReLogin object:nil];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark    ObbserveMethod
- (void)socketReconnect:(NSNotification *)sender {
    [ibFXHandler() fx_pm_SubscribeAllWithView:self.view];
    if (ibFXHandler().m_TradeHomeIndex == 1) {
        if (self.view.window && [self isViewLoaded]) {
            if ([IBGlobalMethod isFXTradeLogined]) {
                [ibFXHandler() ibFXCheckAccountNeedLoginWithView:self.view withController:self withBlock:nil];
            }
        }
    }
    if (ibFXHandler().m_TradeHomeIndex == 2) {
        if (self.view.window && [self isViewLoaded]) {
            if ([IBGlobalMethod isPMTradeLogined]) {
                [ibFXHandler() ibPMCheckAccountNeedLoginWithView:self.view withController:self withBlock:nil];
            }
        }
    }
}

- (void)ibestLoginOut:(NSNotification *)sender {
    [IBFXSheetView hideFXSheetView];
    if (self.xNavigationcontroller != nil ) {
        [self.xNavigationcontroller popToRootViewControllerAnimated:YES];
    }
    if ([IBGlobalMethod isFXTradeLogined] || [IBGlobalMethod isPMTradeLogined]) {
        IBFXHomeModel *model = [[IBFXHomeModel alloc] init];
        [model fxLoginOutWithView:self.view withCallBack:nil];
        [model pmLoginOutWithView:self.view withCallBack:nil];
    }
}

- (void)reLoginFX_PM:(NSNotification *)sender {
    [IBFXSheetView hideFXSheetView];
//    WEAKSELF
    if ([sender.object isEqualToString:@"0"]) {
        if (App().rootTabbarVC.selectedIndex != 2) {
            IBFXData().fxAccount = nil;
            IBFXData().fxTDManager = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:FX_LoginOut object:nil];
        }else {
            if (ibFXHandler().m_TradeHomeIndex == 1) {
                IBFXLoginViewController *loginC = [[IBFXLoginViewController alloc] initWithNibName:@"IBFXLoginViewController" bundle:nil withLoginCallBack:^(BOOL loginSuccess) {
                    if (loginSuccess == NO) {
                        IBFXData().fxAccount = nil;
                        IBFXData().fxTDManager = nil;
                        [[NSNotificationCenter defaultCenter] postNotificationName:FX_LoginOut object:nil];
                    }
                }  withType:FXLoginType_Login_FX];
                if (self.presentingViewController != nil) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self.presentingViewController presentViewController:loginC animated:YES completion:nil];
                }else {
                    [self presentViewController:loginC animated:YES completion:nil];
                }
            }else {
                IBFXData().fxAccount = nil;
                IBFXData().fxTDManager = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:FX_LoginOut object:nil];
            }
        }
    }
    if ([sender.object isEqualToString:@"1"]) {
        if (App().rootTabbarVC.selectedIndex != 2) {
            IBFXData().pmAccount = nil;
            IBFXData().pmTDManager = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:PM_LoginOut object:nil];
        }else {
            if (ibFXHandler().m_TradeHomeIndex == 2) {
                IBFXLoginViewController *loginC = [[IBFXLoginViewController alloc] initWithNibName:@"IBFXLoginViewController" bundle:nil withLoginCallBack:^(BOOL loginSuccess) {
                    if (loginSuccess == NO) {
                        IBFXData().pmAccount = nil;
                        IBFXData().pmTDManager = nil;
                        [[NSNotificationCenter defaultCenter] postNotificationName:PM_LoginOut object:nil];
                    }
                }  withType:FXLoginType_Login_PM];
                if (self.presentingViewController != nil) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self.presentingViewController presentViewController:loginC animated:YES completion:nil];
                }else {
                    [self presentViewController:loginC animated:YES completion:nil];
                }
            }else {
                IBFXData().pmAccount = nil;
                IBFXData().pmTDManager = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:PM_LoginOut object:nil];
            }
        }
    }
}



#pragma mark    Getter
- (IBFXLoginModel *)m_ReconnectSocket {
    if (!_m_ReconnectSocket) {
        _m_ReconnectSocket = [[IBFXLoginModel alloc] init];
    }
    return _m_ReconnectSocket;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSocket_Reconnect object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kIBNotify_Logout_Success object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"[%@--------dealloc]", self.class);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
