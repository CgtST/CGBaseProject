//
//  IBTradeBaseViewController.m
//  QNApp
//
//  Created by xboker on 2017/4/19.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBTradeBaseViewController.h"
#import "IBCustomLoginView.h"
#import "IBTradeTimer.h"

#import "IBTradeChangePSWViewController.h"
#import "IBTradeLoginViewController.h"
#import "IBTradeSingleTon.h"




@interface IBTradeBaseViewController ()

@end

@implementation IBTradeBaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tradeLoginTimeOut:) name:TradeLoginHaveTimeOut object:nil];
    if (self.xNavigationcontroller.xViewControllers.count > 1) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToRoot:) name:TradeLoginCancled object:nil];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark    obbser Method

- (void)tradeLoginTimeOut:(NSNotification *)sender {

    if ([self isViewLoaded] && self.view.window) {
        WEAKSELF
        if (![IBGlobalMethod isLogin]) {
            [iBestCache() clearTradeLoginOut];
            return;
        }
        if ([IBTradeSingleTon shareTradeSingleTon].m_TradleLoginViewShowed) {
            return;
        }
        IBTradeLoginViewController *tradeLoginC = [[IBTradeLoginViewController alloc] initWithNibName:@"IBTradeLoginViewController" bundle:nil];
        [self presentViewController:tradeLoginC animated:YES completion:nil];
        [tradeLoginC cancleLoginWithBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showToastWithText:CustomLocalizedString(@"FX_BU_NINQUXIAOLEDENGLU", nil) style:QNBaseViewControllerToastStyleNormal];
                [iBestCache() clearTradeLoginOut];
                [weakSelf.xNavigationcontroller popToRootViewControllerAnimated:YES];
            });
        }];
    }else {
        [iBestCache() clearTradeLoginOut];
    }



}


- (void)popToRoot:(NSNotification *)sender {
    NSLog(@"%@   before POP", self.navigationController.navigationController.viewControllers);
    [iBestCache() clearTradeLoginOut];
    [self.xNavigationcontroller popToRootViewControllerAnimated:YES];
    NSLog(@"%@   after POP", self.navigationController.navigationController.viewControllers);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [[IBTradeTimer shareTimer] startCaculateTime];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TradeLoginHaveTimeOut object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
