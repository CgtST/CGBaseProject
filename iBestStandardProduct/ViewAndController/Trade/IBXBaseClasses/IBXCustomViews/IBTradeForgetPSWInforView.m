//
//  IBTradeForgetPSWInforView.m
//  iBestProduct
//  激活账户时, 弹窗提示账户激活的view
//  Created by xboker on 2017/8/30.
//  Copyright © 2017年 iBest. All rights reserved.
//

#import "IBTradeForgetPSWInforView.h"
#import <CCHLinkTextView.h>
#import <CCHLinkTextViewDelegate.h>



@interface IBTradeForgetPSWInforView()<CCHLinkTextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel                *m_Title;
@property (weak, nonatomic) IBOutlet CCHLinkTextView        *m_Des;
@property (weak, nonatomic) IBOutlet UIButton               *m_Cancel;
@property (weak, nonatomic) IBOutlet UIButton               *m_ActiveAccount;
@property (weak, nonatomic) IBOutlet UIView                 *m_BigV;
@property (nonatomic, copy) DiaNum                          dialNum;
@property (nonatomic, copy) ActiveAccount                   activeAccount;
@property (nonatomic, assign) InforViewType                 m_Type;
@property (weak, nonatomic) IBOutlet UIView                 *m_VerticalIndex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *m_IndexOffsetX;
///默认220
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *m_BigVHeight;
@property (weak, nonatomic) IBOutlet UIButton               *m_BigBtn;

@end


@implementation IBTradeForgetPSWInforView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/**
 账户激活, 密码找回时的一种弹窗
 
 @param diaNum 点击拨打电话号码的回调
 @param activeAccount 点击"确定"的回调
 @param type 弹出框的类型
 @param inforDic 传入展示信息内容
 */
+ (void)showViewWithDial:(DiaNum)diaNum withConfirm:(ActiveAccount)activeAccount withType:(InforViewType)type withInfor:(NSDictionary *)inforDic{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (id obj  in window.subviews) {
        if ([obj isKindOfClass:[self class]]) {
            return;
        }
    }
    IBTradeForgetPSWInforView *v = [[NSBundle mainBundle] loadNibNamed:@"IBTradeForgetPSWInforView" owner:nil options:nil].lastObject;
    v.frame = window.bounds;
    v.tag = 9000;
    v.m_Type = type;
    [window addSubview:v];
    switch (type) {
        case InforViewTypeActiveInfor_ISSUE: {
            [v attbutieTheString];
            break;
        }
        case InforViewType_FX_Bind_HaveNoPhone_Infor: {
            v.m_Des.text = CustomLocalizedString(@"FX_BU_NINDEZHANGHAOSHANGWEIZHUCEDENGLU", nil);
            v.m_IndexOffsetX.constant = - CGRectGetWidth(v.m_BigV.frame) / 2.0;
            [v.m_ActiveAccount setTitle:CustomLocalizedString(@"QOK", nil) forState:UIControlStateNormal];
            [v.m_ActiveAccount setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            v.m_ActiveAccount.backgroundColor = [UIColor whiteColor];
            v.m_VerticalIndex.hidden = YES;
            v.m_Cancel.hidden = YES;
            v.m_BigBtn.userInteractionEnabled = NO;
            v.m_BigVHeight.constant = 180;
            [v attbutieTheString];
            break;
        }

        case InforViewTypeTLVerifyCodeExcessSixTimesAccountLocked: {
            v.m_Des.text = CustomLocalizedString(@"FX_BU_YANZHEGNMACISHUTUCHAOCHUXIANZHI", nil);
            v.m_IndexOffsetX.constant = - CGRectGetWidth(v.m_BigV.frame) / 2.0;
            [v.m_ActiveAccount setTitle:CustomLocalizedString(@"QOK", nil) forState:UIControlStateNormal];
            [v.m_ActiveAccount setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            v.m_ActiveAccount.backgroundColor = [UIColor whiteColor];
            v.m_VerticalIndex.hidden = YES;
            v.m_Cancel.hidden = YES;
            v.m_BigBtn.userInteractionEnabled = NO;
            v.m_BigVHeight.constant = 180;
            [v attbutieTheString];
            break;
        }
        case InforViewTypeActiveInfor_SUSPENDED: {
            v.m_Des.text = CustomLocalizedString(@"FX_BU_NINDEJIAOYICHUYUTESHUZHUANGTAI", nil);
            v.m_IndexOffsetX.constant = - CGRectGetWidth(v.m_BigV.frame) / 2.0;
            [v.m_ActiveAccount setTitle:CustomLocalizedString(@"QOK", nil) forState:UIControlStateNormal];
            [v.m_ActiveAccount setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            v.m_ActiveAccount.backgroundColor = [UIColor whiteColor];
            v.m_VerticalIndex.hidden = YES;
            v.m_Cancel.hidden = YES;
            v.m_BigVHeight.constant = 160;
            [v attbutieTheString];
            break;
        }
        case InforViewTypeCanNotInForgetPSWView: {
            v.m_Title.text = CustomLocalizedString(@"MINEWENXINTISHI", nil);
            v.m_Des.text = CustomLocalizedString(@"FX_BU_RUGUONINWANGJILEJIAOYIMIMA", nil);
            v.m_IndexOffsetX.constant = - CGRectGetWidth(v.m_BigV.frame) / 2.0;
            [v.m_ActiveAccount setTitle:CustomLocalizedString(@"MINEGUANBI", nil) forState:UIControlStateNormal];
            [v.m_ActiveAccount setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            v.m_ActiveAccount.backgroundColor = [UIColor whiteColor];
            v.m_VerticalIndex.hidden = YES;
            v.m_Cancel.hidden = YES;
            v.m_BigVHeight.constant = 160;
            [v attbutieTheString];
            break;
        }
        case InforViewTypeCanNotInForgetAccountView: {
            v.m_Title.text = CustomLocalizedString(@"MINEWENXINTISHI", nil);
            v.m_Des.text = CustomLocalizedString(@"FX_BU_RUGUOWANGJILEJIAOYIDENGLUMING", nil);
            v.m_IndexOffsetX.constant = - CGRectGetWidth(v.m_BigV.frame) / 2.0;
            [v.m_ActiveAccount setTitle:CustomLocalizedString(@"MINEGUANBI", nil) forState:UIControlStateNormal];
            [v.m_ActiveAccount setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            v.m_ActiveAccount.backgroundColor = [UIColor whiteColor];
            v.m_VerticalIndex.hidden = YES;
            v.m_Cancel.hidden = YES;
            v.m_BigVHeight.constant = 160;
            [v attbutieTheString];
            break;
        }
        case InforViewTypeImportantInfor: {
            v.m_Title.text = CustomLocalizedString(@"FX_BU_ZHONGYAOTISHI", nil);
            v.m_Des.textAlignment = NSTextAlignmentLeft;
            NSString *idNum = inforDic[@"id"];
            NSString *birthdayStr = inforDic[@"birthday"];
            NSArray *birthArr = [birthdayStr componentsSeparatedByString:@"-"];
            NSString *birthday = [NSString stringWithFormat:@"%@%@%@%@%@%@", birthArr.firstObject,CustomLocalizedString(@"FX_BU_NIAN", nil), birthArr[1],CustomLocalizedString(@"FX_BU_YUE", nil), birthArr.lastObject,CustomLocalizedString(@"FX_BU_RI", nil)];
            NSString *str = [NSString stringWithFormat:@"%@%@ \n%@%@",CustomLocalizedString(@"FX_BU_RUGUOTIJIAOZILIAOYUXITONGBUFU", nil), birthday, idNum,CustomLocalizedString(@"FX_BU_SHENFENZHENGSHOULIUWEISHUZI", nil)];
            NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:str];
            [mutableStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, str.length)];
            [mutableStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:NSMakeRange(0, str.length)];
            [mutableStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#EC3A3A"] range:[str rangeOfString:CustomLocalizedString(@"FX_BU_DUANXINJIHUOMA", nil)]];
            [mutableStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#EC3A3A"] range:[str rangeOfString:birthday]];
            [mutableStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#EC3A3A"] range:[str rangeOfString:idNum]];
            [mutableStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:[str rangeOfString:CustomLocalizedString(@"FX_BU_CHUSHENGRIQI", nil)]];
            [mutableStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:[str rangeOfString:CustomLocalizedString(@"FX_BU_SHENFENZHENGSHOULIUWEISHUZI", nil)]];
            v.m_Des.attributedText = mutableStr;
            v.m_BigVHeight.constant = [IBOptionPlistSingleton shareIntance].k_FontScale * 220;
            [v.m_Cancel setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            [v.m_ActiveAccount setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            [v.m_ActiveAccount setTitle:CustomLocalizedString(@"DESC_SUBMIT", nil) forState:UIControlStateNormal];
            v.m_ActiveAccount.backgroundColor = [UIColor whiteColor];
            
            break;
        }
        case InforViewType_PM_ForgetPSW_Infor: {
            v.m_Title.text = CustomLocalizedString(@"LOGIN_WANGJIMIMA", nil);
            v.m_Des.text = CustomLocalizedString(@"FX_BU_RUGUOXUYAOZHAOHUIGUIJINSHUJIAOYIMIMA", nil);
            v.m_IndexOffsetX.constant = - CGRectGetWidth(v.m_BigV.frame) / 2.0;
            [v.m_ActiveAccount setTitle:CustomLocalizedString(@"QUEREN", nil) forState:UIControlStateNormal];
            [v.m_ActiveAccount setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            v.m_ActiveAccount.backgroundColor = [UIColor whiteColor];
            v.m_VerticalIndex.hidden = YES;
            v.m_Cancel.hidden = YES;
            v.m_BigVHeight.constant = 190 * [IBOptionPlistSingleton shareIntance].k_FontScale;
            [v attbutieTheString];
            break;
        }
        case InforViewType_FX_ForgetPSW_Infor: {
            v.m_Title.text = CustomLocalizedString(@"LOGIN_WANGJIMIMA", nil);
            v.m_Des.text = CustomLocalizedString(@"FX_BU_RUGUOXUYAOZHAOHIUWAIHUIJIAOYIMIMA", nil);
            v.m_IndexOffsetX.constant = - CGRectGetWidth(v.m_BigV.frame) / 2.0;
            [v.m_ActiveAccount setTitle:CustomLocalizedString(@"QUEREN", nil) forState:UIControlStateNormal];
            [v.m_ActiveAccount setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            v.m_ActiveAccount.backgroundColor = [UIColor whiteColor];
            v.m_VerticalIndex.hidden = YES;
            v.m_Cancel.hidden = YES;
            v.m_BigVHeight.constant = 190 * [IBOptionPlistSingleton shareIntance].k_FontScale;
            [v attbutieTheString];
            break;
        }
        case InforViewType_FX_PM_Binding_Infor:{
            v.m_Title.text = CustomLocalizedString(@"MINEWENXINTISHI", nil);
            NSString * msgText = @"";
            if(inforDic[@"msg"])
            {
                msgText = inforDic[@"msg"];
            }
            msgText = [NSString stringWithFormat:@"%@%@",CustomLocalizedString(@"FX_BU_WEILENINDESHOUJIHAOQINGXIANLIANGXIWOMEN", nil), msgText];
            v.m_Des.text = msgText;
            v.m_IndexOffsetX.constant = - CGRectGetWidth(v.m_BigV.frame) / 2.0;
            [v.m_ActiveAccount setTitle:CustomLocalizedString(@"QUEREN", nil) forState:UIControlStateNormal];
            [v.m_ActiveAccount setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            v.m_ActiveAccount.backgroundColor = [UIColor whiteColor];
            v.m_VerticalIndex.hidden = YES;
            v.m_Cancel.hidden = YES;
            v.m_BigVHeight.constant = 280 * [IBOptionPlistSingleton shareIntance].k_FontScale;
            [v attbutieTheString];
            break;

        }
        case InforViewType_SUSPENDED_CAN_NOT_FINDBACK: {
            v.m_Title.text = CustomLocalizedString(@"MINEWENXINTISHI", nil);
            v.m_Des.text = CustomLocalizedString(@"FX_BU_NINDEDENGLUMINGBUYUXUJINRUXITONGQINGCHOGNSHI", nil);
            v.m_IndexOffsetX.constant = - CGRectGetWidth(v.m_BigV.frame) / 2.0;
            [v.m_ActiveAccount setTitle:CustomLocalizedString(@"QUEREN", nil) forState:UIControlStateNormal];
            [v.m_ActiveAccount setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            v.m_ActiveAccount.backgroundColor = [UIColor whiteColor];
            v.m_VerticalIndex.hidden = YES;
            v.m_Cancel.hidden = YES;
            v.m_BigVHeight.constant = 190 * [IBOptionPlistSingleton shareIntance].k_FontScale;
            [v attbutieTheString];
            break;
        }
        default:
            break;
    }
    
    
    
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.2;
    animation.repeatCount = 1;
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = NO;
    animation.removedOnCompletion = YES;animation.values = @[@(0.9), @(1), @(1.05), @(1.1), @(1.15), @(1.1), @(1.05), @(1), @(0.95), @(1)];
    [v.m_BigV.layer addAnimation:animation forKey:@"animation"];
    if (diaNum) {
        v.dialNum  = diaNum;
    }
    if (activeAccount) {
        v.activeAccount = activeAccount;
    }
    
    
}


- (void)attbutieTheString {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.m_Des.text];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, self.m_Des.text.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:NSMakeRange(0, self.m_Des.text.length)];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:[self.m_Des.text rangeOfString:@"(852)35833388"]];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:[self.m_Des.text rangeOfString:@"(0755)82663232"]];
    [str addAttribute:CCHLinkAttributeName value:@"1" range:[self.m_Des.text rangeOfString:@"(852)35833388"]];
    [str addAttribute:CCHLinkAttributeName value:@"0" range:[self.m_Des.text rangeOfString:@"(0755)82663232"]];
    self.m_Des.attributedText = str;
}




+ (void)hideView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    IBTradeForgetPSWInforView *v = (IBTradeForgetPSWInforView *)[window viewWithTag:9000];
    v.transform = CGAffineTransformScale(v.transform, 0.1, 0.1);
    [v removeFromSuperview];
}


- (IBAction)cancel:(UIButton *)sender {
    [[self class] hideView];
}


- (IBAction)activeAccount:(UIButton *)sender {
    [[self class] hideView];
    if (self.activeAccount) {
        self.activeAccount();
    }
}




- (void)setM_Des:(CCHLinkTextView *)m_Des {
    _m_Des = m_Des;
    _m_Des.linkDelegate = self;
    _m_Des.editable = NO;
    _m_Des.linkTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16], NSForegroundColorAttributeName :[UIColor blueColor]};
    _m_Des.linkTextTouchAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16], NSForegroundColorAttributeName : [UIColor orangeColor]};


//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_m_Des.text];
//    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, _m_Des.text.length)];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:NSMakeRange(0, _m_Des.text.length)];
//    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:[_m_Des.text rangeOfString:@"(852) 35833388"]];
//    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:[_m_Des.text rangeOfString:@"(755) 82663232"]];
//    [str addAttribute:CCHLinkAttributeName value:@"1" range:[_m_Des.text rangeOfString:@"(852) 35833388"]];
//    [str addAttribute:CCHLinkAttributeName value:@"0" range:[_m_Des.text rangeOfString:@"(755) 82663232"]];
//    _m_Des.attributedText = str;
}



#pragma mark    CCHLinkTextViewDelegate
/** The user has tapped on a link. */
- (void)linkTextView:(CCHLinkTextView *)linkTextView didTapLinkWithValue:(id)value {
    if ([value isKindOfClass:[NSString class]]) {
        if ([value isEqualToString:@"1"]) {
            if (self.dialNum) {
                self.dialNum(@"tel:(00852)35833388");
            }
        }else if ([value  isEqualToString:@"0"]) {
            if (self.dialNum) {
                self.dialNum(@"tel:(0755)82663232");
            }
        }else {
            return;
        }
    }
}

/** The user has long pressed a link. */
- (void)linkTextView:(CCHLinkTextView *)linkTextView didLongPressLinkWithValue:(id)value {
    if ([value isKindOfClass:[NSString class]]) {
        if ([value isEqualToString:@"1"]) {
            if (self.dialNum) {
                self.dialNum(@"tel:(00852)35833388");
            }
        }else if ([value  isEqualToString:@"0"]) {
            if (self.dialNum) {
                self.dialNum(@"tel:(0755)82663232");
            }
        }else {
            return;
        }
    }
}














- (void)dealloc {
    NSLog(@"[%@---------dealloc]", self.class);
}






@end
