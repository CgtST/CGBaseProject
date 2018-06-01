//
//  IBCheckNetWorkViewController.m
//  QNApp
//  检测网络的界面
//  Created by xboker on 2017/5/13.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBCheckNetWorkViewController.h"

@interface IBCheckNetWorkViewController ()
@property (nonatomic, strong) UIButton *m_BTN;
@end

@implementation IBCheckNetWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.m_BTN];
    self.title = CustomLocalizedString(@"FX_BU_JIANCEWANGLUO", nil);
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([IBXHelpers getNetWorkStatus] != 0) {
        if (self.xNavigationcontroller.viewControllers.count > 1) {
            [self.xNavigationcontroller popViewControllerAnimated:YES];
        }else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}



- (void)checkNetWork:(UIButton *)sender {
    [self showRequestActivityProgressToView:self.view];
    
    
    
    
    
    
    
}



#pragma mark    

- (UIButton *)m_BTN {
    if (!_m_BTN) {
        _m_BTN = [UIButton buttonWithType:UIButtonTypeCustom];
        _m_BTN.frame = CGRectMake(0, 0, ScreenWidth - 30, 60);
        _m_BTN.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
        _m_BTN.layer.cornerRadius = 3;
        _m_BTN.layer.masksToBounds = YES;
        _m_BTN.layer.borderColor = [UIColor redColor].CGColor;
        _m_BTN.layer.borderWidth = 1;
        [_m_BTN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_m_BTN setTitle:CustomLocalizedString(@"FX_BU_JIANCEWANGLUO", nil) forState:UIControlStateNormal];
        [_m_BTN addTarget:self action:@selector(checkNetWork:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _m_BTN;
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
