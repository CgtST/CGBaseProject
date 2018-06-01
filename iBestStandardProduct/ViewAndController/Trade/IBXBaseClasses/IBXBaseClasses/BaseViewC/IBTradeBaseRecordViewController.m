//
//  IBTradeBaseRecordViewController.m
//  iBestProduct
//
//  Created by xboker on 2017/7/6.
//  Copyright © 2017年 iBest. All rights reserved.
//

#import "IBTradeBaseRecordViewController.h"
#import "IBTradeLoginModle.h"
#import "IBCustomOrderView.h"



@interface IBTradeBaseRecordViewController ()
@property (nonatomic, strong) IBTradeLoginModle         *m_LoginModel;

@end

@implementation IBTradeBaseRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.m_LoginModel = [[IBTradeLoginModle alloc] init];
    self.m_GetDateRequest = [[IBTradeBaseRecordModel alloc] init];
//    self.m_GetDateRequest.delegate = self;
//    [self getSystemDateAction];

    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)getSystemDateAction {
    [self. m_GetDateRequest getSystemDateActionWithView:self.view withLoginModel:self.m_LoginModel];
}


#pragma mark    IBTradeBaseRecordModeldelegate
- (void)ibGetSystemDateSuccessWithDate:(NSDate *)date withDateStr:(NSString *)dateStr {
    self.m_SystemDate = date ;
    self.m_SystemDateStr = dateStr;
}

- (void)ibGetSystemDateFailedWithInfor:(NSString *)infor shouldPop:(BOOL)shouldPop{
    if (infor.length) {
        [self showToastWithText:infor style:QNBaseViewControllerToastStyleNormal];
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
