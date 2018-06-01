//
//  YHQBaseViewController.m
//  Yihaoqianbao
// QNBaseViewController下层的C基类
//  Created by Money on 16/3/15.
//  Copyright © 2016年 Money. All rights reserved.
//

#import "YHQBaseViewController.h"
#import "YHNetworkRequestView.h"
#import "UIScrollView+IBScrollViewTouch.h"
#import "IBTradeTimer.h"
#import "IBCustomLoginView.h"

#import <MBProgressHUD.h>



@interface YHQBaseViewController ()<UIScrollViewDelegate>

/** 请求数据的一个友好交互提示动画 */
@property (nonatomic, strong) YHNetworkRequestView *requestView;
/** 没有数据的提示 */
@property (nonatomic, strong) UILabel *noDataLabel;
/** 请求错误数据的提示 */
@property (nonatomic, strong) UILabel *errorLabel;
/** 跟请求无关的提示的提示 */
@property (nonatomic, strong) UILabel *tipLabel;



@end

@implementation YHQBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
//    backItem.title = @"返回";
//    self.navigationItem.backBarButtonItem = backItem;
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    

    
    
}



//#pragma makr    UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [[IBTradeTimer shareTimer] startCaculateTime];
//
//}// any offset changes
//
//
//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [[IBTradeTimer shareTimer] startCaculateTime];
//
//    NSLog(@"交易相关的界面点击............");
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [[IBTradeTimer shareTimer] startCaculateTime];
//
//    NSLog(@"交易相关的界面滑动............");
//
//}



#pragma mark    强制更新操作
- (void)forceUpdateVersionToVersion:(NSString *)version {
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (![currentVersion isEqualToString:version]) {
        UIAlertController *altC = [UIAlertController alertControllerWithTitle:CustomLocalizedString(@"FX_BU_FAXIANXINBANBEN", nil) message:CustomLocalizedString(@"FX_BU_QUANXINBANBENSHANGXIAN", nil)  preferredStyle:1];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"FX_BU_LIJITIYAN", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *  action) {
            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/1hao-qian-bao/id1081718607?mt=8"];
            [[UIApplication sharedApplication] openURL:url];
        }];
        [altC addAction:confirmAction];
        [self presentViewController:altC animated:1 completion:nil];
    }
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}










#pragma mark - public method

/**
 *  数据请求交互提示方法
 *
 *  @param view 添加到父视图中的父view
 */
- (void)showRequestActivityProgressToView:(UIView *)view {
    
//    BOOL have = NO;
//    for (id obj in view.subviews) {
//        if ([obj isKindOfClass:[MBProgressHUD class]]) {
//            [view bringSubviewToFront:obj];
//            have = YES;
//            break;
//        }
//    }
//    if (have) {
//        return;
//    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    });
    
    
    
    
    
    
}


/**
 *  隐藏数据请求交互提示
 */
- (void)hiddenRequestActivityProgressView {
//    if ([self.requestView isTipNetworkAnimation]) {
//        if (self.requestView.superview) {
//            [self.requestView stopTipNetwork];
//            [self.requestView removeFromSuperview];
//            self.requestView = nil;
//        }
//        
//        if (self.noDataLabel.superview) {
//            [self.noDataLabel removeFromSuperview];
//            self.noDataLabel = nil;
//        }
//    }else {
//        return;
//    }

}

/**
 *  隐藏数据请求交互提示
 */
- (void)hiddenRequestActivityProgressViewWithView:(UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
//        [MBProgressHUD hideHUDForView:view animated:YES];
//        [MBProgressHUD hideHUDForView:view animated:YES];
        [MBProgressHUD hideAllHUDsForView:view animated:YES];

    });
    
    //    if ([self.requestView isTipNetworkAnimation]) {
    //        if (self.requestView.superview) {
    //            [self.requestView stopTipNetwork];
    //            [self.requestView removeFromSuperview];
    //            self.requestView = nil;
    //        }
    //
    //        if (self.noDataLabel.superview) {
    //            [self.noDataLabel removeFromSuperview];
    //            self.noDataLabel = nil;
    //        }
    //    }else {
    //        return;
    //    }
    
}





/**
 *  数据请求出错时提示用户方法
 *
 *  @param view      添加到父视图中的父view
 *  @param errorStr  错误信息
 *  @param animation 是否动画显示
 */
- (void)showRequestFailureErrorToView:(UIView *)view errorString:(NSString *)errorStr animation:(BOOL)animation
{
    if (self.requestView.superview)
    {
        [self.requestView stopTipNetwork];
        [self.requestView removeFromSuperview];
        self.requestView = nil;
    }
    
    if (self.tipLabel.superview)
    {
        [self.tipLabel removeFromSuperview];
        self.tipLabel = nil;
    }
    
    if (!errorStr.length)
    {
        errorStr = KNetWork_Error;
    }
    else if ([errorStr isEqualToString:@"用户账号未登陆或用户会话已过期"])
    {
        errorStr = CustomLocalizedString(@"FX_BU_WEIBAOZHANGNIDEZHANGHUANQUAN", nil);
    }
    
    CGRect errorRect = [errorStr boundingRectWithSize:CGSizeMake(view.bounds.size.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
    
    if (errorRect.size.width == view.bounds.size.width - 30)
    {
        self.errorLabel.frame = CGRectMake(15, 10, view.bounds.size.width - 30, errorRect.size.height + 20);
    }
    else
    {
        self.errorLabel.frame = CGRectMake((view.bounds.size.width - errorRect.size.width) / 2  - 15 , 10, errorRect.size.width + 30, 50.0);
    }
    
//    if (errorRect.size.height > view.bounds.size.height / 2)
//    {
//        self.errorLabel.frame = CGRectMake(15, view.bounds.size.height * 3 / 4 - (view.bounds.size.height / 3) , view.bounds.size.width - 30, view.bounds.size.height / 3);
//    }
//    else
//    {
//        self.errorLabel.frame = CGRectMake(15, view.bounds.size.height * 3 / 4 - errorRect.size.height , view.bounds.size.width - 30, errorRect.size.height + 20);
//    }
    
    [view addSubview:self.errorLabel];
    [view bringSubviewToFront:self.errorLabel];
    
    
    
    self.errorLabel.text = errorStr;
    
    if (animation)
    {
//      [self showNotSeatViewAnimationWithView:self.errorLabel andIsShow:YES];
        [UIView animateWithDuration:0.25 animations:^{
            self.errorLabel.alpha = 1.0;
        } completion:^(BOOL finished) {
            self.errorLabel.alpha = 1.0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.25 animations:^{
                    self.errorLabel.alpha = 0.0;
                } completion:^(BOOL finished) {
                    [self.errorLabel removeFromSuperview];
                    self.errorLabel = nil;
                }];
            });
        }];
    }
    else
    {
        self.errorLabel.alpha = 1.0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.errorLabel.alpha = 0.0;
                [self.errorLabel removeFromSuperview];
                self.errorLabel = nil;
        });
    }
}

- (void)showNotSeatViewAnimationWithView:(UIView *)view andIsShow:(BOOL)isShow
{
    NSLog(@"showNotSeatViewAnimation...isShow=>%d", isShow);
    CGFloat startValue = isShow ? 0 : 1.0;
    CGFloat endValue = isShow ? 1.0 : 0;
    CGFloat firstDuration = isShow ? 0.3f : 0.1f;
    CGFloat secondDuration = isShow ? 0.1f : 0.3f;
    
    //缩放变化
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:startValue];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.2];
    scaleAnimation.duration = firstDuration;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *scaleAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation2.fromValue = [NSNumber numberWithFloat:1.2];
    scaleAnimation2.toValue = [NSNumber numberWithFloat:endValue];
    scaleAnimation2.beginTime = firstDuration;
    scaleAnimation2.duration = secondDuration;
    scaleAnimation2.removedOnCompletion = NO;
    scaleAnimation2.fillMode = kCAFillModeForwards;
    scaleAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 0.4f;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.autoreverses = NO;
    [animationGroup setAnimations:[NSArray arrayWithObjects:scaleAnimation, scaleAnimation2, nil]];
    
    [view.layer addAnimation:animationGroup forKey:@"animationGroup"];
}

/**
 *  数据请求没有数据时提示用户方法
 *
 *  @param view      添加到父视图中的父view
 *  @param tipString 提示信息
 */
- (void)showRequestSuccessNoDataToView:(UIView *)view tipInfoString:(NSString *)tipString
{
    if (self.requestView.superview)
    {
        [self.requestView stopTipNetwork];
        [self.requestView removeFromSuperview];
        self.requestView = nil;
    }
    
    [view addSubview:self.noDataLabel];
    [view bringSubviewToFront:self.noDataLabel];
//    self.noDataLabel.frame = CGRectZero;
//    [UIView animateWithDuration:0.25 animations:^{
    self.noDataLabel.frame = CGRectMake(0, view.bounds.size.height / 2 - 15 , view.bounds.size.width, 30);
    self.noDataLabel.alpha = 1.0;
    self.noDataLabel.text = tipString;
    
    [self showNotSeatViewAnimationWithView:self.noDataLabel andIsShow:YES];
    
//    } completion:^(BOOL finished) {
//        self.noDataLabel.alpha = 1.0;
//    }];
}

/**
 *  隐藏提示没有数据的提示方法
 */
- (void)hiddenNoDataTipInfoView
{
    if (self.noDataLabel.superview)
    {
        [self.noDataLabel removeFromSuperview];
        self.noDataLabel = nil;
    }
}

/**
 *  显示提示用户信息的方法
 *
 *  @param view      添加到父视图中的父view
 *  @param errorStr  提示信息
 *  @param animation 是否动画显示
 */
- (void)showTipInfoToView:(UIView *)view tipInfoString:(NSString *)tipInfoString animation:(BOOL)animation
{
    
    
    
    CGRect errorRect = [tipInfoString boundingRectWithSize:CGSizeMake(view.bounds.size.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
    
    if (self.requestView.superview) {
        [self.requestView stopTipNetwork];
        [self.requestView removeFromSuperview];
        self.requestView = nil;
    }
    
    if (self.tipLabel.superview) {
        [self.tipLabel removeFromSuperview];
        self.tipLabel = nil;
    }
    
    if (errorRect.size.width == view.bounds.size.width - 30) {
        self.tipLabel.frame = CGRectMake(15, 10, view.bounds.size.width - 30, errorRect.size.height + 20);
    }
    else
    {
        self.tipLabel.frame = CGRectMake((view.bounds.size.width - errorRect.size.width) / 2  - 15 , 10, errorRect.size.width + 30, 50.0);
    }
    
    [view addSubview:self.tipLabel];
    [view bringSubviewToFront:self.tipLabel];
    self.tipLabel.text = tipInfoString;
    
    if (animation)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.tipLabel.alpha = 1.0;
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.25 animations:^{
                    self.tipLabel.alpha = 0.0;
                } completion:^(BOOL finished) {
                    [self.tipLabel removeFromSuperview];
                    self.tipLabel = nil;
                }];
            });
        }];
    }
    else
    {
        self.tipLabel.alpha = 1.0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tipLabel.alpha = 0.0;
            [self.tipLabel removeFromSuperview];
            self.tipLabel = nil;
        });
    }
}


/**
 显示提示用户信息的方法
 
 @param view             添加到父视图中的父view
 @param tipInfoString    提示信息
 @param animation        是否动画显示
 @param offsetY          y方向偏移量
 */
- (void)showTipInfoToView:(UIView *)view tipInfoString:(NSString *)tipInfoString animation:(BOOL)animation withOffsetY:(CGFloat)offsetY {
    CGRect errorRect = [tipInfoString boundingRectWithSize:CGSizeMake(view.bounds.size.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
    
    if (self.requestView.superview)
    {
        [self.requestView stopTipNetwork];
        [self.requestView removeFromSuperview];
        self.requestView = nil;
    }
    
    if (self.tipLabel.superview)
    {
        [self.tipLabel removeFromSuperview];
        self.tipLabel = nil;
        
    }
    
    if (errorRect.size.width == view.bounds.size.width - 30)
    {
        self.tipLabel.frame = CGRectMake(15, 10 + offsetY, view.bounds.size.width - 30, errorRect.size.height + 20);
    }
    else
    {
        self.tipLabel.frame = CGRectMake((view.bounds.size.width - errorRect.size.width) / 2  - 15 , 10 + offsetY, errorRect.size.width + 30, 50.0);
    }
    
    [view addSubview:self.tipLabel];
    [view bringSubviewToFront:self.tipLabel];
    self.tipLabel.text = tipInfoString;
    
    if (animation)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.tipLabel.alpha = 1.0;
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.25 animations:^{
                    self.tipLabel.alpha = 0.0;
                } completion:^(BOOL finished) {
                    [self.tipLabel removeFromSuperview];
                    self.tipLabel = nil;
                }];
            });
        }];
    }
    else
    {
        self.tipLabel.alpha = 1.0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tipLabel.alpha = 0.0;
            [self.tipLabel removeFromSuperview];
            self.tipLabel = nil;
        });
    }
}



#pragma mark - private getter

/** 请求数据的一个友好交互提示动画 */
- (YHNetworkRequestView *)requestView{
    if (!_requestView) {
        _requestView = [YHNetworkRequestView networkRequestView];
    }
    return _requestView;
}

- (UILabel *)errorLabel
{
    if (!_errorLabel)
    {
        _errorLabel = [[UILabel alloc] init];
        _errorLabel.font = [UIFont systemFontOfSize:15.0];
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
        _errorLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _errorLabel.alpha = 0.0;
        _errorLabel.numberOfLines = 0;
        _errorLabel.minimumScaleFactor = 12;
        _errorLabel.layer.masksToBounds = YES;
        _errorLabel.layer.cornerRadius = 5.0;
    }
    return _errorLabel;
}

- (UILabel *)noDataLabel
{
    if (!_noDataLabel)
    {
        _noDataLabel = [[UILabel alloc] init];
        _noDataLabel.font = [UIFont systemFontOfSize:15.0];
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        _noDataLabel.textColor = [UIColor colorWithRed:255/255.0 green:95/255.0 blue:95/255.0 alpha:1.0];
        _noDataLabel.alpha = 0.0;
    }
    return _noDataLabel;
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




#pragma mark    Case


//- (BOOL)m_TradeHaveLogin {
//    if ( [[[NSUserDefaults standardUserDefaults] objectForKey:TradeLogin] isKindOfClass:[NSDictionary class]]) {
//        return YES;
//    }else {
//        return NO;
//    }
//}

- (BOOL)m_iBESTHaveLogin {
    return [IBGlobalMethod isLogin];
}



- (void)dealloc {
    NSLog(@"[%@ ------ dealloc]", self.class);

    [self.errorLabel.layer removeAllAnimations];
    [self.noDataLabel.layer removeAllAnimations];
    [self.errorLabel removeFromSuperview];
    [self.noDataLabel removeFromSuperview];
    [self.requestView removeFromSuperview];
    [self.tipLabel removeFromSuperview];
    self.errorLabel = nil;
    self.noDataLabel = nil;
    self.requestView = nil;
    self.tipLabel = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

@end
