//
//  IBCustomDragView.m
//  iBestProduct
//  一个展示大幅文字, 可以拖动的view, 没有计算高度, 使用时选择枚举值进行区分
//  Created by xboker on 2017/7/8.
//  Copyright © 2017年 iBest. All rights reserved.
//

#import "IBCustomDragView.h"
#import <CCHLinkTextView.h>
#import <CCHLinkTextViewDelegate.h>


@interface IBCustomDragView()

@property (weak, nonatomic) IBOutlet UILabel            *m_Title;
@property (weak, nonatomic) IBOutlet UITextView         *m_TextV;
@property (weak, nonatomic) IBOutlet UIButton           *m_Select;
@property (weak, nonatomic) IBOutlet UIButton           *m_Cancel;
@property (weak, nonatomic) IBOutlet UIButton           *m_Confirm;
@property (weak, nonatomic) IBOutlet UIView             *m_View;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_ViewHeight;



@property (nonatomic, assign)   CustomDragViewType      m_Type;
@property (nonatomic, copy)     ConfrimBlock            m_ConfirmB;
@property (nonatomic, copy)     CancelBlock             m_CancelB;

@property (nonatomic, strong)   NSString                *m_FXLoginInfor;
@property (nonatomic, strong)   NSString                *m_PMLoginInfor;
@end

@implementation IBCustomDragView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.m_Select setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateSelected];
    [self.m_Select setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    self.m_TextV.scrollEnabled = YES;
    
    self.m_FXLoginInfor = CustomLocalizedString(@"FX_BU_BUYAOZAILIUDONGDIANHUAHUOPINGBANDIANNAODES", nil);
       self.m_PMLoginInfor = CustomLocalizedString(@"FX_BU_BUYAOZAIDIANNAOSHANGCUNCHUJIAOYINIMADES", nil);
    
    self.m_Title.text = CustomLocalizedString(@"ANUANXUZHI", nil);
    [self.m_Select setTitle:CustomLocalizedString(@"XIACIBUZAIXIANSHI", nil) forState:UIControlStateNormal];
    [self.m_Confirm setTitle:CustomLocalizedString(@"WOZHIDAOLE", nil) forState:UIControlStateNormal];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



/**
显示一个可以拖动的展示大篇幅View

@param type 枚举区分类型
@param confirm 点击确定回调
@param cancel 点击取消回调
*/
+ (void)showDragViewWithType:(CustomDragViewType)type withConfirm:(ConfrimBlock)confirm withCancel:(CancelBlock)cancel {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (id obj in window.subviews) {
        if ([obj isKindOfClass:[IBCustomDragView class]]) {
            return;
        }
    }
    IBCustomDragView *dragV = [[NSBundle mainBundle] loadNibNamed:@"IBCustomDragView" owner:nil options:nil].lastObject;
    dragV.frame = window.frame;
    ///不通情况不同处理
    dragV.m_Type = type;
    switch (type) {
        case CustomDragViewTypeTradeLogin: {
            ///默认情况
            if (IS_320_WIDTH) {
                dragV.m_ViewHeight.constant = 450;
            }else if (IS_375_WIDTH) {
                dragV.m_ViewHeight.constant = 500;
            }else if (IS_414_WIDTH) {
                dragV.m_ViewHeight.constant = 550;
            }
            break;
        }
        case CustomDragViewTypeFX_Login: {
            if (IS_320_WIDTH) {
                dragV.m_ViewHeight.constant = 450;
            }else if (IS_375_WIDTH) {
                dragV.m_ViewHeight.constant = 500;
            }else if (IS_414_WIDTH) {
                dragV.m_ViewHeight.constant = 550;
            }
            dragV.m_Cancel.userInteractionEnabled = NO;
            dragV.m_TextV.text = dragV.m_FXLoginInfor;
            break;
        }
        case CustomDragViewTypePM_Login: {
            if (IS_320_WIDTH) {
                dragV.m_ViewHeight.constant = 450;
            }else if (IS_375_WIDTH) {
                dragV.m_ViewHeight.constant = 500;
            }else if (IS_414_WIDTH) {
                dragV.m_ViewHeight.constant = 550;
            }
            dragV.m_Cancel.userInteractionEnabled = NO;
            dragV.m_TextV.text = dragV.m_PMLoginInfor;
            break;
        }
            default:
            break;
    }
    
    
    [window addSubview:dragV];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.repeatCount = 1;
    animation.duration = 0.2;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    animation.values = @[ @(0.99), @(1), @(1.01), @(1.02), @(1.01), @(1)];
    [dragV.m_View.layer addAnimation:animation forKey:@"beginaniamtion"];
    dragV.m_ConfirmB = confirm;
    dragV.m_CancelB = cancel;
    
}


/**
 隐藏可拖动View
 */
+ (void)hideCustomDragView {
    [IBCustomDragView hide];
}




#pragma mark    interFaceBuilderMethod

- (IBAction)cancel:(UIButton *)sender {
    if (self.m_CancelB) {
        if (self.m_Select.selected) {
            self.m_CancelB(NO);
        }else {
            self.m_CancelB(YES);
        }
    }
    
    
    WEAKSELF
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.m_View.transform = CGAffineTransformScale(weakSelf.m_View.transform, 0.0001, 0.0001 );
        weakSelf.m_View.alpha = 0.1;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
    
    
    

}



- (IBAction)confirm:(UIButton *)sender {

    if (self.m_ConfirmB) {
        if (self.m_Select.selected) {
            self.m_ConfirmB(NO);
        }else {
            self.m_ConfirmB(YES);
        }
    }
    [IBCustomDragView hide];
}


- (IBAction)selectAction:(UIButton *)sender {
    [sender.imageView.layer addAnimation:[IBXHelpers getBigKeyScaleAnimation] forKey:@"animation"];
    sender.selected = !sender.selected;
//    if (self.m_Type == CustomDragViewTypeTradeLogin) {
//        [[NSUserDefaults standardUserDefaults] setBool:!self.m_Select.selected forKey:TradeLoginInforFlag];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
}




+ (void)hide {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (id obj  in window.subviews) {
        if ([obj isKindOfClass:[IBCustomDragView class]]) {
            IBCustomDragView *v = (IBCustomDragView *)obj;
            [v removeFromSuperview];
            break;
        }
    }
}






- (void)dealloc {
    [self.m_Select.imageView.layer removeAnimationForKey:@"animation"];
    NSLog(@"[%@------------dealloc]", self.class);
}




@end
