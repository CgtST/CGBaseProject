//
//  IBCustomOrderView.m
//  QNApp
//  下单时如果时隔夜单, 则需要弹出提示
//  Created by xboker on 2017/5/24.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBCustomOrderView.h"

@interface IBCustomOrderView()
@property (weak, nonatomic) IBOutlet UIView             *m_View;
@property (weak, nonatomic) IBOutlet UIButton           *m_Cancle;
@property (weak, nonatomic) IBOutlet UIButton           *m_Confirm;
@property (weak, nonatomic) IBOutlet UILabel            *m_Des;
@property (weak, nonatomic) IBOutlet UILabel            *m_Title;
///默认440
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_ViewHeight;
///默认65
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_TitleHeight;
@property (nonatomic, assign) ConfirmOrderType          m_Type;
@property (nonatomic, copy) ConfirmOrder                confrimBlock;
@property (nonatomic, copy) CancelOrder                 cancelBlock;

@property (weak, nonatomic) IBOutlet UILabel            *m_IndexLineVertical;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_IndexLineOffsetX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_CancelWidthMultiplier;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_VLeftLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_VRightLeading;


@property (nonatomic, strong)  CAShapeLayer             *masklayer;
@property (weak, nonatomic) IBOutlet UIButton           *m_BigBtn;
@end


@implementation IBCustomOrderView

-(void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
}

///只捕获点击确定的时机
+ (void)showCustomOrderViewWithBlock:(ConfirmOrder)confirmBlock withType:(ConfirmOrderType)type{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    BOOL haveShow = NO;
    for (id obj  in window.subviews) {
        if ([obj isKindOfClass:[IBCustomOrderView class]]) {
            haveShow = YES;
            break;
        }
    }
    if (haveShow) {
        return;
    }
    IBCustomOrderView *v  = [[NSBundle mainBundle] loadNibNamed:@"IBCustomOrderView" owner:nil options:nil].lastObject;
    v.frame = window.bounds;
    v.m_Type = type;
    switch (type) {
        case ConfirmOrderTypeGTN: {
            //不做任何处理
            break;
        }
        case ConfirmOrderTypeTLResendVerifyCodeExcess: {
            v.m_ViewHeight.constant = 160;
            v.m_TitleHeight.constant = 30;
            v.m_Des.font = [UIFont systemFontOfSize:16];
            v.m_Cancle.hidden = YES;
            v.m_BigBtn.userInteractionEnabled = NO;
            v.m_IndexLineOffsetX.constant = - CGRectGetWidth(v.m_View.frame) / 2.0;
            v.m_IndexLineVertical.hidden = YES;
            v.m_Des.textAlignment = NSTextAlignmentCenter;
            v.m_Des.text = CustomLocalizedString(@"FX_BU_YANZHEGNMAFASONGCISHUCHAOGUOXIANZHI", nil);
            v.m_Title.text = CustomLocalizedString(@"MINEWENXINTISHI", nil);
            break;
        }
        case ConfirmOrderTypeTFAIDCardInfor: {
            v.m_ViewHeight.constant = 300;
            v.m_TitleHeight.constant = 30;
            v.m_Des.font = [UIFont systemFontOfSize:16];
            v.m_Cancle.hidden = YES;
            v.m_IndexLineOffsetX.constant = - CGRectGetWidth(v.m_View.frame) / 2.0;
            v.m_IndexLineVertical.hidden = YES;
            v.m_Des.text = CustomLocalizedString(@"FX_BU_SHENFENZHENGGESHISHUOMING", nil);
            v.m_Title.text = CustomLocalizedString(@"FX_BU_ZHENGJIAHAOMAGESHISHUOMING", nil);
            break;
        }
        case ConfirmOrderTypeConfirmStock_A: {
            v.m_ViewHeight.constant = 200;
            v.m_TitleHeight.constant = 30;
            v.m_Des.text = CustomLocalizedString(@"FX_BU_JIAOYILIANGGUODA", nil);
            v.m_Title.text = CustomLocalizedString(@"MINEWENXINTISHI", nil);
            break;
        }
        case ConfirmOrderTypeConfirmStock_HK: {
            v.m_ViewHeight.constant = 200;
            v.m_TitleHeight.constant = 30;
            v.m_Des.text = CustomLocalizedString(@"FX_BU_YINJIAOYILIANGDAYU3000SHOU", nil);
            v.m_Title.text = CustomLocalizedString(@"MINEWENXINTISHI", nil);
            break;
        }
        case ConfirmOrderTypeUseMarginInfor: {
            v.m_ViewHeight.constant = 170;
            v.m_TitleHeight.constant = 30;
            v.m_Des.text = CustomLocalizedString(@"TRADE_XIADANYICHAOGUOZUIDAXIANE", nil);
            v.m_Title.text = CustomLocalizedString(@"MINEWENXINTISHI", nil);
            break;
        }
        case ConfirmOrderTypeMoneyOutInfor: {
            v.m_ViewHeight.constant = 170;
            v.m_TitleHeight.constant = 30;
            v.m_Des.textAlignment = NSTextAlignmentCenter;
            v.m_Des.text = CustomLocalizedString(@"FX_BU_JINRITIJIAOLEXIANGTONGSHUJUZHISHI", nil);
            v.m_Title.text = CustomLocalizedString(@"MINEWENXINTISHI", nil);
            break;
        }
        case ConfirmOrderTypeMoneyExchangeInfor: {
            v.m_ViewHeight.constant = 170;
            v.m_TitleHeight.constant = 30;
            v.m_Des.textAlignment = NSTextAlignmentCenter;
            v.m_Des.text = CustomLocalizedString(@"FX_BU_JINRITIJIAOLEXIANGTONGSHUJUZHISHI", nil);
            v.m_Title.text = CustomLocalizedString(@"MINEWENXINTISHI", nil);
            break;
        }
        case ConfirmOrderTypeConditionOrderInfor: {
            v.m_ViewHeight.constant = 170;
            v.m_TitleHeight.constant = 30;
            v.m_Des.textAlignment = NSTextAlignmentCenter;
            v.m_Des.font = [UIFont systemFontOfSize:16];
            v.m_Des.text = CustomLocalizedString(@"FX_BU_NINDEJIAOYIQINGQIULIJIFASONG", nil);
            v.m_Title.text = CustomLocalizedString(@"MINEWENXINTISHI", nil);
            break;
        }
        case ConfirmOrderTypeGetSystemDateDailed: {
            v.m_ViewHeight.constant = 170;
            v.m_TitleHeight.constant = 30;
            v.m_Des.textAlignment = NSTextAlignmentCenter;
            v.m_Des.font = [UIFont systemFontOfSize:16];
            v.m_Des.text = CustomLocalizedString(@"FX_BU_HUOQUXITONGSHIJIANSHIBAI", nil);
            v.m_Title.text = CustomLocalizedString(@"MINEWENXINTISHI", nil);
            break;
        }
        case ConfirmOrderTypeCanNotAccountTransfer: {
            v.m_ViewHeight.constant = 170;
            v.m_TitleHeight.constant = 30;
            v.m_Des.textAlignment = NSTextAlignmentCenter;
            v.m_Des.font = [UIFont systemFontOfSize:16];
            v.m_Cancle.hidden = YES;
            v.m_IndexLineOffsetX.constant = - CGRectGetWidth(v.m_View.frame) / 2.0;
            v.m_IndexLineVertical.hidden = YES;
            v.m_Des.text = CustomLocalizedString(@"FX_BU_CIGONGNENGBUSHIYONGCIZHANGHU", nil);
            v.m_Title.text = CustomLocalizedString(@"MINEWENXINTISHI", nil);
            break;
        }
        case ConfirmOrderTypeCanNotWithDraw: {
            v.m_ViewHeight.constant = 170;
            v.m_TitleHeight.constant = 30;
            v.m_Des.textAlignment = NSTextAlignmentCenter;
            v.m_Des.font = [UIFont systemFontOfSize:16];
            v.m_Cancle.hidden = YES;
            v.m_IndexLineOffsetX.constant = - CGRectGetWidth(v.m_View.frame) / 2.0;
            v.m_IndexLineVertical.hidden = YES;
            v.m_Des.text = CustomLocalizedString(@"FX_BU_CIGONGNENGBUSHIYONGCIZHANGHU", nil);
            v.m_Title.text = CustomLocalizedString(@"MINEWENXINTISHI", nil);
            break;
        }
        case ConfirmOrderTypeIsNotDealTime: {
            v.m_ViewHeight.constant = 170;
            v.m_TitleHeight.constant = 30;
            v.m_Des.textAlignment = NSTextAlignmentCenter;
            v.m_Des.font = [UIFont systemFontOfSize:16];
            v.m_Cancle.hidden = YES;
            v.m_IndexLineOffsetX.constant = - CGRectGetWidth(v.m_View.frame) / 2.0;
            v.m_IndexLineVertical.hidden = YES;
            v.m_Des.text = CustomLocalizedString(@"FX_BU_FUWUSHIJIANYIGUO", nil);
            v.m_Title.text = CustomLocalizedString(@"MINEWENXINTISHI", nil);
            break;
        }
        case ConfirmOrderTypeCanNotAccountTransfer_Profession: {
            v.m_ViewHeight.constant = 170;
            v.m_TitleHeight.constant = 30;
            v.m_Des.textAlignment = NSTextAlignmentCenter;
            v.m_Des.font = [UIFont systemFontOfSize:16];
            v.m_Cancle.hidden = YES;
            v.m_IndexLineOffsetX.constant = - CGRectGetWidth(v.m_View.frame) / 2.0;
            v.m_IndexLineVertical.hidden = YES;
            v.m_Des.text = CustomLocalizedString(@"FX_BU_ZHUANYETOUZIZHEZHANGHUBUZHICHICAOZUO", nil);
            v.m_Title.text = CustomLocalizedString(@"MINEWENXINTISHI", nil);
            break;
        }
        case ConfirmOrderTypeCanNotWithDraw_Profession: {
            v.m_ViewHeight.constant = 170;
            v.m_TitleHeight.constant = 30;
            v.m_Des.textAlignment = NSTextAlignmentCenter;
            v.m_Des.font = [UIFont systemFontOfSize:16];
            v.m_Cancle.hidden = YES;
            v.m_IndexLineOffsetX.constant = - CGRectGetWidth(v.m_View.frame) / 2.0;
            v.m_IndexLineVertical.hidden = YES;
            v.m_Des.text = CustomLocalizedString(@"FX_BU_ZHUANYETOUZIZHEZHANGHUBUZHICHICAOZUO", nil);
            v.m_Title.text = CustomLocalizedString(@"MINEWENXINTISHI", nil);
            break;
        }
        case ConfirmOrderTypeIs_SBU_Account: {
            v.m_ViewHeight.constant = 180;
            v.m_TitleHeight.constant = 30;
            v.m_Des.textAlignment = NSTextAlignmentCenter;
            v.m_Des.font = [UIFont systemFontOfSize:16];
            v.m_Cancle.hidden = YES;
            v.m_IndexLineOffsetX.constant = - CGRectGetWidth(v.m_View.frame) / 2.0;
            v.m_IndexLineVertical.hidden = YES;
            v.m_Des.text = CustomLocalizedString(@"FX_BU_WEISHEZHIDIANZIJIAOYIHUKOU", nil);
            v.m_Title.text = CustomLocalizedString(@"MINEWENXINTISHI", nil);
            break;
        }
        case ConfirmOrderTypeResetPSWCancleInfor: {
            v.m_ViewHeight.constant = 170;
            v.m_TitleHeight.constant = 30;
            v.m_Des.textAlignment = NSTextAlignmentCenter;
            v.m_Des.font = [UIFont systemFontOfSize:16];
            v.m_Cancle.hidden = YES;
            v.m_IndexLineOffsetX.constant = - CGRectGetWidth(v.m_View.frame) / 2.0;
            v.m_IndexLineVertical.hidden = YES;
            v.m_Des.text = CustomLocalizedString(@"FX_BU_WEISHEZHIJIAOYIMIMASHIFOUTUISHU", nil);
            v.m_Title.text = CustomLocalizedString(@"MINEWENXINTISHI", nil);
            break;
        }
        case ConfirmOrderType_FX_PMOpenAccount_HaveNoLogin: {
            v.m_ViewHeight.constant = 170;
            v.m_TitleHeight.constant = 30;
            v.m_Des.textAlignment = NSTextAlignmentCenter;
            v.m_Des.text = CustomLocalizedString(@"FX_BU_WEIDENGLUAPP", nil);
            v.m_Title.text = CustomLocalizedString(@"FX_BU_KAILIJIAOYIZHANGHU", nil);
            v.m_BigBtn.userInteractionEnabled = NO;
            v.m_VLeftLeading.constant = 35;
            v.m_VRightLeading.constant = 35;
            [v.m_Confirm setTitle:CustomLocalizedString(@"LOGIN_IBEST", nil) forState:UIControlStateNormal];
            [v.m_Confirm setTitleColor:[UIColor colorWithHexString:@"#FB6130"] forState:UIControlStateNormal];
            break;
        }
        case ConfirmOrderType_FX_PMOpenAccount_UpdateInformation: {
            v.m_ViewHeight.constant = 170;
            v.m_TitleHeight.constant = 30;
            v.m_Des.textAlignment = NSTextAlignmentCenter;
            v.m_Des.text = CustomLocalizedString(@"FX_BU_SHANGWEISHEZHISHOUJIHAOHEMIMA", nil);
            v.m_Title.text = CustomLocalizedString(@"FX_BU_KAILIJIAOYIZHANGHU", nil);
            v.m_BigBtn.userInteractionEnabled = NO;
            v.m_VLeftLeading.constant = 35;
            v.m_VRightLeading.constant = 35;
            [v.m_Confirm setTitle:CustomLocalizedString(@"FX_BU_BUCHONGZILIAO", nil) forState:UIControlStateNormal];
            [v.m_Confirm setTitleColor:[UIColor colorWithHexString:@"#FB6130"] forState:UIControlStateNormal];
            break;
        }
        case ConfirmOrderType_CameraLimit: {
            v.m_ViewHeight.constant = 170;
            v.m_TitleHeight.constant = 30;
            v.m_Des.textAlignment = NSTextAlignmentCenter;
            v.m_Des.text = CustomLocalizedString(@"FX_BU_NINMEIYOUFANGWENXIANGJIQUANXIAN", nil);
            v.m_Title.text = CustomLocalizedString(@"MINEWENXINTISHI", nil);
            v.m_BigBtn.userInteractionEnabled = NO;
            v.m_VLeftLeading.constant = 35;
            v.m_VRightLeading.constant = 35;
            [v.m_Confirm setTitle:CustomLocalizedString(@"FX_BU_DAKAIQUANXIAN", nil) forState:UIControlStateNormal];
            [v.m_Confirm setTitleColor:[UIColor colorWithHexString:@"#FB6130"] forState:UIControlStateNormal];
            break;
        }
        case ConfirmOrderType_AlbumLimit: {
            v.m_ViewHeight.constant = 170;
            v.m_TitleHeight.constant = 30;
            v.m_Des.textAlignment = NSTextAlignmentCenter;
            v.m_Des.text = CustomLocalizedString(@"FX_BU_NINMEIYOUFANGWENXIANGJIQUANXIAN", nil);
            v.m_Title.text = CustomLocalizedString(@"MINEWENXINTISHI", nil);
            v.m_BigBtn.userInteractionEnabled = NO;
            v.m_VLeftLeading.constant = 35;
            v.m_VRightLeading.constant = 35;
            [v.m_Confirm setTitle:CustomLocalizedString(@"FX_BU_DAKAIQUANXIAN", nil) forState:UIControlStateNormal];
            [v.m_Confirm setTitleColor:[UIColor colorWithHexString:@"#FB6130"] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
    [window addSubview:v];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.repeatCount = 1;
    animation.duration = 0.2;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    animation.values = @[ @(0.99), @(1), @(1.01), @(1.02), @(1.01), @(1)];
    [v.m_View.layer addAnimation:animation forKey:@"beginaniamtion"];
    v.confrimBlock = confirmBlock;
}




///确定,取消都要捕获
+ (void)showCustomOrderViewWithBlock:(ConfirmOrder)confirmBlock withCancel:(CancelOrder)cancelBlock withType:(ConfirmOrderType)type {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    BOOL haveShow = NO;
    for (id obj  in window.subviews) {
        if ([obj isKindOfClass:[IBCustomOrderView class]]) {
            haveShow = YES;
            break;
        }
    }
    if (haveShow) {
        return;
    }
    IBCustomOrderView *v  = [[NSBundle mainBundle] loadNibNamed:@"IBCustomOrderView" owner:nil options:nil].lastObject;
    v.frame = window.bounds;
    v.m_Type = type;
    switch (type) {
        case ConfirmOrderType_665Login_ISSUED_Status_FastRegistOrBind:
        case ConfirmOrderType_665Login_ISSUED_Status: {
            v.m_ViewHeight.constant = 160;
            v.m_TitleHeight.constant = 30;
            v.m_Des.font = [UIFont systemFontOfSize:16];
            v.m_Cancle.hidden = YES;
            v.m_BigBtn.userInteractionEnabled = NO;
            v.m_IndexLineOffsetX.constant = - CGRectGetWidth(v.m_View.frame) / 2.0;
            v.m_IndexLineVertical.hidden = YES;
            v.m_Des.textAlignment = NSTextAlignmentCenter;
            v.m_Des.text = CustomLocalizedString(@"FX_BU_NINYIZHIMEIYOUXIUGAICHUSHIMIMA", nil);
            v.m_Title.text = CustomLocalizedString(@"MINEWENXINTISHI", nil);
            [v.m_Confirm setTitle:CustomLocalizedString(@"FX_BU_XIANZAIGENGGAIMIMA", nil) forState:UIControlStateNormal];
            v.m_Confirm.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            v.m_Confirm.titleLabel.adjustsFontSizeToFitWidth = YES;
            v.m_BigBtn.userInteractionEnabled = NO;
            break;
        }
        case ConfirmOrderType_665Login_CanKeepPSW_FastRegistOrBind:
        case ConfirmOrderType_665Login_CanKeepPSW: {
            v.m_ViewHeight.constant = 170;
            v.m_TitleHeight.constant = 30;
            v.m_Des.textAlignment = NSTextAlignmentCenter;
            v.m_Des.font = [UIFont systemFontOfSize:16];
            v.m_Des.text = CustomLocalizedString(@"FX_BU_QINGANZHISHIXIUGAIMIMA", nil);
            v.m_Title.text = CustomLocalizedString(@"MINEWENXINTISHI", nil);
            [v.m_Confirm setTitle:CustomLocalizedString(@"FX_BU_BAOLIUXIANYOUMIMA", nil) forState:UIControlStateNormal];
            [v.m_Cancle setTitle:CustomLocalizedString(@"FX_BU_XIANZAIGENGGAIMIMA", nil) forState:UIControlStateNormal];
            v.m_Confirm.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            v.m_Cancle.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            v.m_Confirm.titleLabel.adjustsFontSizeToFitWidth = YES;
            v.m_Cancle.titleLabel.adjustsFontSizeToFitWidth = YES;
            v.m_BigBtn.userInteractionEnabled = NO;
            break;
        }
        case ConfirmOrderType_FX_PMLogin_InvalidPSW: {
            v.m_ViewHeight.constant = 170;
            v.m_TitleHeight.constant = 30;
            v.m_Des.textAlignment = NSTextAlignmentCenter;
            v.m_Des.font = [UIFont systemFontOfSize:16];
            v.m_Des.text = CustomLocalizedString(@"FX_BU_NINSHURUDEJIAOYIMIMABUZHENGQUE", nil);
            v.m_Title.text = CustomLocalizedString(@"LOGIN_DENGLUSHIBAI", nil);
            [v.m_Confirm setTitle:CustomLocalizedString(@"LOGIN_CHONGXINSHURU", nil) forState:UIControlStateNormal];
            [v.m_Cancle setTitle:CustomLocalizedString(@"LOGIN_WANGJIMIMA", nil) forState:UIControlStateNormal];
            v.m_Confirm.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            [v.m_Cancle setTitleColor:[UIColor colorWithHexString:@"#3983E4"] forState:UIControlStateNormal];
            v.m_Confirm.titleLabel.adjustsFontSizeToFitWidth = YES;
            v.m_Cancle.titleLabel.adjustsFontSizeToFitWidth = YES;
            v.m_BigBtn.userInteractionEnabled = NO;
            break;
            break;
        }
        case ConfirmOrderType_665Login_CanNotKeepPSW_FastRegistOrBind:
        case ConfirmOrderType_665Login_CanNotKeepPSW: {
            v.m_ViewHeight.constant = 160;
            v.m_TitleHeight.constant = 30;
            v.m_Des.font = [UIFont systemFontOfSize:16];
            v.m_Cancle.hidden = YES;
            v.m_BigBtn.userInteractionEnabled = NO;
            v.m_IndexLineOffsetX.constant = - CGRectGetWidth(v.m_View.frame) / 2.0;
            v.m_IndexLineVertical.hidden = YES;
            v.m_Des.textAlignment = NSTextAlignmentCenter;
            v.m_Des.text = CustomLocalizedString(@"FX_BU_QINGANZHISHIXIUGAIMIMA", nil);
            v.m_Title.text = CustomLocalizedString(@"MINEWENXINTISHI", nil);
            [v.m_Confirm setTitle:CustomLocalizedString(@"FX_BU_XIANZAIGENGGAIMIMA", nil) forState:UIControlStateNormal];
            v.m_Confirm.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            v.m_Confirm.titleLabel.adjustsFontSizeToFitWidth = YES;
            v.m_BigBtn.userInteractionEnabled = NO;
            break;
        }
        default:
            break;
    }
    [window addSubview:v];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.repeatCount = 1;
    animation.duration = 0.2;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    animation.values = @[ @(0.99), @(1), @(1.01), @(1.02), @(1.01), @(1)];
    [v.m_View.layer addAnimation:animation forKey:@"beginaniamtion"];
    v.confrimBlock = confirmBlock;
    v.cancelBlock  = cancelBlock;
}

+ (void)hideViewAction {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (id obj  in window.subviews) {
        if ([obj isKindOfClass:[IBCustomOrderView class]]) {
            IBCustomOrderView *v = (IBCustomOrderView *)obj;
            [v removeFromSuperview];
            break;
        }
    }
}

- (void)hideAction {
    WEAKSELF
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.m_View.transform = CGAffineTransformScale(weakSelf.m_View.transform, 0.0001, 0.0001);
        weakSelf.m_View.alpha = 0.1;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}


#pragma mark   可视化方法

- (IBAction)dismissAction:(UIButton *)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self hideAction];
}



- (IBAction)bigCancel:(UIButton *)sender {
    [self hideAction];
}


- (IBAction)confrimAction:(UIButton *)sender {
    if (self.confrimBlock) {
        self.confrimBlock();
    }
    [self hideAction];
}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end


