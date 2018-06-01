//
//  IBBaseSuccessViewController.m
//  iBestProduct
//
//  Created by xboker on 2017/9/5.
//  Copyright © 2017年 iBest. All rights reserved.
//

#import "IBBaseSuccessViewController.h"
#import <UMAnalytics/MobClick.h>

@interface IBBaseSuccessViewController ()

@property (weak, nonatomic) IBOutlet UILabel  *m_Title;
@property (weak, nonatomic) IBOutlet UILabel  *m_Infor;
@property (weak, nonatomic) IBOutlet UIButton *m_Confirm;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_TitleLbTop;


@end

@implementation IBBaseSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.m_Type) {
            ///重新设置密码成功
        case BaseSuccessViewTypeResetPSWSuccess: {
            self.m_Title.hidden = YES;
            self.m_TitleLbTop.constant = 0;
            self.m_Infor.text = CustomLocalizedString(@"FX_BU_NINYICHONGXINSHEZHIJIAOYIMIMABINGJIHUO", nil);
            self.m_Infor.textAlignment = NSTextAlignmentCenter;
            [self.m_Confirm setTitle:CustomLocalizedString(@"QWANGCHENG", nil) forState:UIControlStateNormal];
            self.xFullScreenPopEnable = NO;
            [MobClick event:@"activateacct_succeed" label:[IBGlobalMethod getAppLoginSession]];

            break;
        }
            ///股票转仓转入成功
        case BaseSuccessViewTypeStockTransferSuccessIn: {
            self.xFullScreenPopEnable = NO;
            self.m_Title.hidden = YES;
            self.m_Infor.text = CustomLocalizedString(@"FX_BU_NINDEGUPIAOZHUANCANGZHISHIYIJINGTIJIAO", nil);
            break;
        }
            ///股票转仓转出成功
        case BaseSuccessViewTypeStockTransferSuccessOut: {
            self.xFullScreenPopEnable = NO;
            self.m_Title.hidden = YES;
            self.m_Infor.text = CustomLocalizedString(@"FX_BU_NINDEGUPIAOZHUANCANGZHISHIYIJINGTIJIAO", nil);
            break;
        }
           ///找回交易账号最后验证邮箱成功提示
        case BaseSuccessViewTypeTradeForgetAccountFindSuccess: {
            self.title = CustomLocalizedString(@"FX_BU_WANGJIJIAOYIMING", nil);
            self.xFullScreenPopEnable = NO;
            self.m_Title.hidden = YES;
            self.m_Infor.text = [NSString stringWithFormat:@"%@:%@",CustomLocalizedString(@"FX_BU_XITONGYIJINGNINDEJIAOYIDENGLUMINGFADAOYOUXIANG", nil), self.m_Message];
            break;
        }
        default:
            break;
    }
    
    self.navigationController.navigationItem.leftBarButtonItems = nil;    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.m_Type == BaseSuccessViewTypeTradeForgetAccountFindSuccess) {
        [self setCustomBarItem:@selector(tfaBackAction) titles:nil color:[UIColor whiteColor] images:@[[UIImage imageNamed:@"ib_close"]] side:0];
    }
    if (self.m_Type == BaseSuccessViewTypeResetPSWSuccess) {
        self.navigationItem.leftBarButtonItems = nil;
    }
}



///找回交易账户成功, 点击左上角的返回方法
- (void)tfaBackAction {
    [self.xNavigationcontroller popToRootViewControllerAnimated:YES];
    IBXViewController *ibx = self.xNavigationcontroller.viewControllers.firstObject;
    if (ibx.rootViewController.presentingViewController != nil) {
        [ibx.rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)tapAction:(UIButton *)sender {
    switch (self.m_Type) {
        case BaseSuccessViewTypeResetPSWSuccess: {
            [self.xNavigationcontroller popToRootViewControllerAnimated:YES];
            UIViewController *c = self.xNavigationcontroller.xViewControllers.firstObject;
            [c dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case BaseSuccessViewTypeStockTransferSuccessOut:
        case BaseSuccessViewTypeStockTransferSuccessIn: {
            [self.xNavigationcontroller popToRootViewControllerAnimated:YES];
            break;
        }
        case BaseSuccessViewTypeTradeForgetAccountFindSuccess: {
            [self.xNavigationcontroller popToRootViewControllerAnimated:YES];
            IBXViewController *ibx = self.xNavigationcontroller.viewControllers.firstObject;
            if (ibx.rootViewController.presentingViewController != nil) {
                [ibx.rootViewController dismissViewControllerAnimated:YES completion:nil];
            }
            break;
        }
        default:
            break;
    }
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
