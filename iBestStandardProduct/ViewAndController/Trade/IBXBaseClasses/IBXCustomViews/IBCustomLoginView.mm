//
//  IBCustomLoginView.m
//  QNApp
//  通用的弹出登录的自定义View

//  Created by xboker on 2017/4/10.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBCustomLoginView.h"
#import "IBTradeHandle.h"
#import "IBTradeTimer.h"
#import "YHNetworkRequestView.h"
#import <pthread.h>

#import "IBCustomChangeAccoountView.h"
#import "IBXMenuChooseView.h"
#import "IBCustomField.h"
#import "IBTradeChangePSWViewController.h"
#import "IBTradeSingleTon.h"



#import "QNAppDelegate.h"
#import "MBProgressHUD+Add.h"
#import "UIView+Extension.h"




@interface IBCustomLoginView()
@property (weak, nonatomic) IBOutlet UIView         *m_BackView;
@property (weak, nonatomic) IBOutlet UILabel        *m_Des;
@property (weak, nonatomic) IBOutlet IBCustomField    *m_PSW;
@property (weak, nonatomic) IBOutlet UIButton       *m_Cancle;
@property (weak, nonatomic) IBOutlet UIButton       *m_Confirm;

@property (nonatomic, copy) SuccessBlock            successBlock;
@property (nonatomic, copy) FaildBlock              failedBlock;
@property (nonatomic, strong) IBTradeHandle         *myRequest;
/** 请求数据的一个友好交互提示动画 */
@property (nonatomic, strong) YHNetworkRequestView  *requestView;

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, assign) CustomLoginViewType   m_Type;


///默认150, 使用后恢复原位
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_TopDistance;

///输入框距顶部高度---默认  120
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_PSWTFTopDistance;
///背后View的高度 ---默认   250
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_ViewHeight;



@end

@implementation IBCustomLoginView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardApper:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];



}



#pragma mark    监听方法

- (void)keyboardApper:(NSNotification *)sender {
    WEAKSELF
    if (IS_IPAD ) {
        [self layoutIfNeeded];
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
            weakSelf.m_TopDistance.constant = 60;
            [weakSelf layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }else {
        if (IS_320_WIDTH) {
            [self layoutIfNeeded];
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
                weakSelf.m_TopDistance.constant = 60;
                [weakSelf layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
        }
        if (IS_375_WIDTH) {

            [self layoutIfNeeded];
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
                weakSelf.m_TopDistance.constant = 80;
                [weakSelf layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
        }
    }
}

- (void)keyboardHide:(NSNotification *)sender {
    WEAKSELF
    if (self.m_TopDistance.constant != 150) {
        [self layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.m_TopDistance.constant = 150;
            [weakSelf layoutIfNeeded];
        }];
    }

}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

+ (IBCustomLoginView *)shareView {
    @synchronized (self) {
        IBCustomLoginView *v =  [[NSBundle mainBundle] loadNibNamed:@"IBCustomLoginView" owner:nil options:nil].lastObject;
        v.m_Type = CustomLoginViewTypeObligate;
        return v;
    }

}

#pragma mark    普通登录时调用时弹出的方法

+ (void)showCustomViewWithBlock:(SuccessBlock)successBlock withBlock:(FaildBlock)failBlock {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    BOOL haveShow = NO;
    for (id obj  in window.subviews) {
        if ([obj isKindOfClass:[IBCustomLoginView class]]) {
            haveShow = YES;
            break;
        }
    }
    if (!haveShow) {
        IBCustomLoginView *v = [IBCustomLoginView shareView];
        v.frame = window.bounds;
        [window addSubview:v];
        v.m_Des.hidden = YES;
        v.m_PSWTFTopDistance.constant = 80;
        v.m_ViewHeight.constant = 200;
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.repeatCount = 1;
        animation.duration = 0.2;
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = YES;
        animation.values = @[@(1.01), @(1.02), @(1.03), @(1.04), @(1.03),@(1.02), @(1.01), @(1), @(1.01), @(1)];
        [v.layer addAnimation:animation forKey:@"beginaniamtion"];
        v.successBlock = successBlock;
        v.failedBlock = failBlock;
    }
}

#pragma mark    撤回新股申购时调用的方法
+ (void)showCustomViewWithBlock:(SuccessBlock)successBlock withBlock:(FaildBlock)failBlock withType:(CustomLoginViewType)type withInfor:(NSString *)infor {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    BOOL haveShow = NO;
    for (id obj  in window.subviews) {
        if ([obj isKindOfClass:[IBCustomLoginView class]]) {
            haveShow = YES;
            break;
        }
    }
    if (!haveShow) {
        IBCustomLoginView *v = [IBCustomLoginView shareView];
        if (type == CustomLoginViewTypeResignNewBuyStock && infor.length ) {
            v.m_Des.text = infor;
        }else if (type == CustomLoginViewTypeNewBuyStockLogin) {
            v.m_Des.text = infor;
        }
        v.m_Type = type;

        if (type == CustomLoginViewTypeResignNewBuyStock || type == CustomLoginViewTypeNewBuyStockLogin) {
            v.m_Des.adjustsFontSizeToFitWidth = YES;
            v.m_Des.minimumScaleFactor = 0.5;
            v.m_Des.hidden = YES;
            v.m_PSWTFTopDistance.constant = 100;

        }

        v.frame = window.bounds;
        [window addSubview:v];
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.repeatCount = 1;
        animation.duration = 0.2;
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = YES;
        animation.values = @[@(1.01), @(1.02), @(1.03), @(1.04), @(1.03),@(1.02), @(1.01), @(1), @(1.01), @(1)];
        [v.layer addAnimation:animation forKey:@"beginaniamtion"];
        v.successBlock = successBlock;
        v.failedBlock = failBlock;
    }
}





- (void)hideAction {
    [[IBTradeSingleTon shareTradeSingleTon].m_TradeAccounts removeAllObjects];
    [IBTradeSingleTon shareTradeSingleTon].m_TradeAccounts = nil;
    if ([self.m_PSW isFirstResponder]) {
        [self.m_PSW resignFirstResponder];
    }
    WEAKSELF
    [UIView animateWithDuration:0.2 animations:^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        NSArray *arr = [window subviews];
        for (id obj in arr) {
            if ([obj isKindOfClass:[IBCustomChangeAccoountView class]]) {
                [IBCustomChangeAccoountView hideCustomChangeAccoountViewWithBlock:nil];
            }
            if ([obj isKindOfClass:[IBXMenuChooseView class]]) {
                [((IBXMenuChooseView *)obj) removeFromSuperview];
            }
        }
        weakSelf.m_BackView.transform = CGAffineTransformScale(weakSelf.m_BackView.transform, 0.0001, 0.0001);
        weakSelf.m_BackView.alpha = 0.1;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        [weakSelf endEditing:YES];
        [weakSelf resignFirstResponder];
    }];
}





- (IBAction)dismiss:(UIButton *)sender {
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TradeLogin];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TradeSonAccounts];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [iBestCache() clearTradeLoginOut];

    if (self.m_Type == CustomLoginViewTypeObligate) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TradeLoginCancled object:nil userInfo:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:TradeBaseLoginCancled object:nil userInfo:nil];
    }else {

    }

    if (self.m_Type == CustomLoginViewTypeResignNewBuyStock || self.m_Type ==  CustomLoginViewTypeNewBuyStockLogin) {
        ///不显示提示语
    }else {
        [self showTipInfoToView:self tipInfoString:CustomLocalizedString(@"FX_BU_NINQUXIAOLEDENGLU", nil) animation:YES withOffsetY:0];
        [iBestCache() clearTradeLoginOut];

    }
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf hideAction];
    });
}




- (IBAction)confirmAction:(UIButton *)sender {
    //WEAKSELF
    [self showRequestView:self];
    if (self.m_PSW.text.length < 1) {
        [self hiddenRequestView];
        [self showTipInfoToView:self tipInfoString:CustomLocalizedString(@"MINEQINGSHURUZHENGQUEDEMIMA", nil) animation:YES withOffsetY:0];
    }else {
//      NSString *account = User().trdAccount;
        NSString *account;
#if IS_665_TEST_ENVIRONMENT == 1
        account = [[NSUserDefaults standardUserDefaults] objectForKey:TradeLoginAccount];
#else
        if ([[IBGlobalMethod getTradeAccountId]containsString:@"-"]) {
            account = [[IBGlobalMethod getTradeAccountId] componentsSeparatedByString:@"-"][1];
        }else {
            account = [IBGlobalMethod getTradeAccountId];
        }


#endif
        if (self.m_Type == CustomLoginViewTypeResignNewBuyStock) {  //撤回新股申购逻辑修改 20171018
            self.successBlock(self.m_PSW.text, YES);
              [self hiddenRequestView];
              [self hideAction];
              return;
        }

//
//        [self.myRequest requestTradeLogin:account password:self.m_PSW.text  clv:@"BG25"  showErrorInView:self needShowError:YES ignoreCode:nil withAccountType:nil  withLoginType:TradeLoginTypeCustomLogin  resultBlock:^(NSString *infor, BOOL isLogined) {
//            if (isLogined) {
//                [weakSelf hiddenRequestView];
////              [weakSelf showTipInfoToView:weakSelf tipInfoString:infor animation:YES withOffsetY:0];
//
//                if (self.m_Type ==  CustomLoginViewTypeNewBuyStockLogin || self.m_Type ==  CustomLoginViewTypeResignNewBuyStock) {
//                    self.successBlock(self.m_PSW.text, YES);
//                }else {
//                    self.successBlock(infor, YES);
//                }
//
//                NSString *inforStr = [IBXHelpers getTradeLoginStatusWithString:infor];
//                if ([infor isEqualToString:@"NORMAL"]) {
//                    [weakSelf showTipInfoToView:weakSelf tipInfoString:inforStr animation:YES withOffsetY:0];
//                } else if ([infor isEqualToString:@"ISSUED"] || [infor isEqualToString:@"GRACECNT"]) {///强迫修改密码
//#warning 这里有崩溃风险
//                    [weakSelf showTipInfoToView:weakSelf tipInfoString:inforStr animation:YES withOffsetY:0];
//                    [weakSelf hideAction];
//
//                    UIViewController * xxvc =  [IBViewControllerHelp visibleViewController:MainController()];
//                    UIAlertController *altC = [UIAlertController alertControllerWithTitle:@"提示" message:inforStr preferredStyle:UIAlertControllerStyleAlert];
//                    [altC addAction:[UIAlertAction actionWithTitle:@"请修改密码" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//                        IBTradeChangePSWViewController *changeC =   [[UIStoryboard storyboardWithName:@"TradeMain" bundle:nil] instantiateViewControllerWithIdentifier:@"IBTradeChangePSWViewController"];
//                        changeC.type = ChangePSWTypeTradeChange;
//                       QNBaseNavController *nav = [[QNBaseNavController alloc] initWithRootViewController:changeC];
//                        [xxvc presentViewController:nav animated:YES completion:nil];
//
//                    }]];
//                    [xxvc presentViewController:altC animated:YES completion:nil];
//
//                }
//                else {///这里面也有需要修改密码的情况, 暂时没有处理
//                    [weakSelf showTipInfoToView:weakSelf tipInfoString:inforStr animation:YES withOffsetY:0];
//                }
//
//
//                [[NSNotificationCenter defaultCenter] postNotificationName:TradeLoginSuccess object:nil userInfo:nil];
//                [weakSelf hideAction];
//
//            }else {
//                //登录失败, 因为没有信息包返回
//                [weakSelf hiddenRequestView];
//            }
//        } fialedBlock:^(NSString *infor, id remaind) {
//            //登录失败, 因为没有信息包返回
//            [weakSelf hiddenRequestView];
//            [weakSelf showTipInfoToView:weakSelf tipInfoString:infor animation:YES withOffsetY:0];
//        }];
    }

}


- (IBAction)cancleAction:(UIButton *)sender {



    if (self.m_Type == CustomLoginViewTypeObligate) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TradeLoginCancled object:nil userInfo:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:TradeBaseLoginCancled object:nil userInfo:nil];
    }else {

    }//    self.failedBlock(@"您取消了登录..", YES);
    WEAKSELF
    if (self.m_Type == CustomLoginViewTypeResignNewBuyStock || self.m_Type ==  CustomLoginViewTypeNewBuyStockLogin) {
        ///不显示提示语
    }else {
        [self showTipInfoToView:self tipInfoString:CustomLocalizedString(@"FX_BU_NINQUXIAOLEDENGLU", nil) animation:YES withOffsetY:0];
        [iBestCache() clearTradeLoginOut];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf hideAction];
    });
//    [self hideAction];
}







/**
 *  数据请求交互提示方法
 *
 *  @param view 添加到父视图中的父view
 */
- (void)showRequestView:(UIView *)view {


    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    });








//    WEAKSELF
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (weakSelf.requestView.superview) {
//            [weakSelf.requestView removeFromSuperview];
//            weakSelf.requestView = nil;
//        }
//        weakSelf.requestView.frame = view.bounds;
//        [view addSubview:weakSelf.requestView];
//        [weakSelf.requestView startTipNetwork];
//    });
//


}


/**
 *  隐藏数据请求交互提示
 */
- (void)hiddenRequestView {



    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self animated:YES];

    });





//    WEAKSELF
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (weakSelf.requestView.superview) {
//            [weakSelf.requestView stopTipNetwork];
//            [weakSelf.requestView removeFromSuperview];
//            weakSelf.requestView = nil;
//        }
//    });

}


/**
 显示提示用户信息的方法

 @param view             添加到父视图中的父view
 @param tipInfoString    提示信息
 @param animation        是否动画显示
 @param offsetY          y方向偏移量
 */
- (void)showTipInfoToView:(UIView *)view tipInfoString:(NSString *)tipInfoString animation:(BOOL)animation withOffsetY:(CGFloat)offsetY {
    WEAKSELF
    CGRect errorRect = [tipInfoString boundingRectWithSize:CGSizeMake(view.bounds.size.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];

    if (self.requestView.superview) {
        [self.requestView stopTipNetwork];
        [self.requestView removeFromSuperview];
        self.requestView = nil;
    }

    if (self.tipLabel.superview)  {
        [self.tipLabel removeFromSuperview];
        self.tipLabel = nil;
    }

    if (errorRect.size.width == view.bounds.size.width - 30)  {
        self.tipLabel.frame = CGRectMake(15,self.centerX - 20 + offsetY, view.bounds.size.width - 30, errorRect.size.height + 20);
        self.tipLabel.center = self.center;
    } else {
        self.tipLabel.frame = CGRectMake((view.bounds.size.width - errorRect.size.width) / 2  - 15 , self.centerX - 20 + offsetY, errorRect.size.width + 30, 50.0);
        self.tipLabel.center = self.center;

    }

    [view addSubview:self.tipLabel];
    [view bringSubviewToFront:self.tipLabel];
    self.tipLabel.text = tipInfoString;

    if (animation) {
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.tipLabel.alpha = 1.0;
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.tipLabel.alpha = 0.0;
                } completion:^(BOOL finished) {
                    [weakSelf.tipLabel removeFromSuperview];
                    weakSelf.tipLabel = nil;
                }];
            });
        }];
    }
    else  {
        self.tipLabel.alpha = 1.0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.tipLabel.alpha = 0.0;
            [weakSelf.tipLabel removeFromSuperview];
            weakSelf.tipLabel = nil;
        });
    }
}



#pragma mark    Case
- (IBTradeHandle *)myRequest {
    if (!_myRequest) {
        _myRequest = [[IBTradeHandle alloc] init];
    }
    return _myRequest;
}

/** 请求数据的一个友好交互提示动画 */
- (YHNetworkRequestView *)requestView
{
    if (!_requestView)
    {
        _requestView = [YHNetworkRequestView networkRequestView];
    }
    return _requestView;
}



- (UILabel *)tipLabel {
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:15.0];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
        _tipLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _tipLabel.alpha = 0.0;
        _tipLabel.numberOfLines = 0;
        _tipLabel.minimumScaleFactor = 12;
        _tipLabel.layer.masksToBounds = YES;
        _tipLabel.layer.cornerRadius = 5.0;
    }
    return _tipLabel;
}







- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    NSLog(@"[%@---------dealloc]", self.class);
}



@end

