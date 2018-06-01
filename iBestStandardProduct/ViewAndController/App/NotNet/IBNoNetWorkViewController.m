//
//  IBNoNetWorkViewController.m
//  iBestProduct
//
//  Created by zscftwo on 2018/1/2.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import "IBNoNetWorkViewController.h"


@interface IBNoNetWorkViewController ()
- (IBAction)netCheckClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@property (weak, nonatomic) IBOutlet UIButton *fCheckBtn;
- (IBAction)fCheckClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *fLoadBtn;
- (IBAction)fLoadClick:(UIButton *)sender;

@end


@implementation IBNoNetWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.checkBtn.hidden = NO;
    self.fCheckBtn.hidden = YES;
    self.fLoadBtn.hidden = YES;
    self.title = CustomLocalizedString(@"CWUWANGLUOTISHI", nil);

    if (self.isFirst) {
        [self firstLaunchUI];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)firstLaunchUI
{
    self.checkBtn.hidden = YES;
    self.fCheckBtn.hidden = NO;
    self.fLoadBtn.hidden = NO;
}

- (IBAction)netCheckClick:(UIButton *)sender {

    //跳转到“About”(关于本机)页面
//    NSURL *url = [NSURL URLWithString:@"prefs:root=General&path=About"];
    //    if ([[UIApplication sharedApplication] canOpenURL:url])
    //    {
    //        [[UIApplication sharedApplication] openURL:url];
    //    }else{
    //        NSLog(@"can not open");
    //    }

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];


}
- (IBAction)fCheckClick:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)fLoadClick:(UIButton *)sender {

    if (self.delegate && [self.delegate respondsToSelector:@selector(loadAgain)]) {
        [self.delegate loadAgain];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
