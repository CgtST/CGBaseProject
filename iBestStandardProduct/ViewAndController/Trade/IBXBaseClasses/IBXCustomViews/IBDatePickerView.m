//
//  IBDatePickerView.m
//  iBestProduct
//
//  Created by xboker on 2017/6/30.
//  Copyright © 2017年 iBest. All rights reserved.
//

#import "IBDatePickerView.h"
#import "JTDateHelper.h"
#import "IBFXQuoteConfigJsonModel.h"




@interface IBDatePickerView()

@property (weak, nonatomic) IBOutlet UIDatePicker   *m_PickerView;
@property (weak, nonatomic) IBOutlet UIButton       *m_Cancle;
@property (weak, nonatomic) IBOutlet UIButton       *m_Confirm;
@property (nonatomic, assign)  IBChooseDateType       m_Type;
@property (nonatomic, copy)     CallBackDateBlock       m_CallBack;
@property (weak, nonatomic) IBOutlet UIView *m_View;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_ViewBottomDistace;
@property (nonatomic, strong) NSDateFormatter *m_Formatter;
@property (nonatomic, strong)   JTDateHelper        *m_DateHelper;
@property (nonatomic, strong)   NSString            *m_ChooseDateStr;
@property (nonatomic, strong)   NSDate              *m_ChooseDate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_Height;

@end



@implementation IBDatePickerView


- (void)awakeFromNib  {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
}




/**
 显示选择日期的View
 
 @param type 显示, 以及可选日期的类型
 @param callBack 选择到的日期字符串以及日期
 @param nowDate  时间采用系统时间, 如果获取不到系统时间,采用[NSDate date]
 */
+ (void)showDatePickerViewWithType:(IBChooseDateType)type withCallBack:(CallBackDateBlock)callBack WithNowDate:(NSDate *)nowDate {
    if (nowDate == nil) {
        nowDate = [NSDate date];
    }
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    BOOL haveShow = NO;
    for (id OBJ in window.subviews) {
        if ([OBJ isKindOfClass:[IBDatePickerView class]]) {
            haveShow = YES;
            break;
        }
    }
    if (haveShow ) {
        [IBDatePickerView hideDatePickView];
    }
    IBDatePickerView *v = [[NSBundle mainBundle] loadNibNamed:@"IBDatePickerView" owner:nil options:nil].lastObject;
    v.frame = window.frame;
    [window addSubview:v];
    v.m_ViewBottomDistace.constant = -260;
    v.m_Height.constant = 200  ;
    [v.m_PickerView setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [v.m_PickerView addTarget:v action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    v.tag = 9000;
    v.m_Type = type;
    v.m_CallBack = callBack;
    switch (type) {
        case IBChooseDateTypeAllDate: {
            NSDate *minDate = [v.m_Formatter dateFromString:@"1940-1-1 00:00:00"];
            NSDate *maxDate = [v.m_Formatter dateFromString:@"2099-1-1 00:00:00"];
            v.m_PickerView.minimumDate = minDate;
            v.m_PickerView.maximumDate = maxDate;
            v.m_PickerView.date = [NSDate date];
            v.m_ChooseDate = [NSDate date];
            v.m_ChooseDateStr = [[v.m_Formatter stringFromDate:[NSDate date]] substringToIndex:10];
            break;
        }
      case IBChooseDateTypeTradeForgetAccount: {
          NSDate *minDate = [v.m_Formatter dateFromString:@"1910-1-1 00:00:00"];
          NSDate *maxDate = [NSDate date];
          v.m_PickerView.minimumDate = minDate;
          v.m_PickerView.maximumDate = maxDate;
          v.m_PickerView.date = [NSDate date];
          v.m_ChooseDate = [NSDate date];
          v.m_ChooseDateStr = [[v.m_Formatter stringFromDate:[NSDate date]] substringToIndex:10];
          break;
      }
        case IBChooseDateTypeDealRecord: {
            NSDate *previousYearDate = [v.m_DateHelper addToDate:nowDate months:-12];
            NSDate *previousDay = [v.m_DateHelper addToDate:nowDate days:-1];
            v.m_PickerView.minimumDate = previousYearDate;
            v.m_PickerView.maximumDate = previousDay;
            v.m_PickerView.date = previousDay;
            v.m_ChooseDateStr = [[v.m_Formatter stringFromDate:previousDay] substringToIndex:10];
            v.m_ChooseDate = previousDay;
            break;
        }
        case IBChooseDateTypeMoneyAccessRecord:
        case IBChooseDateTypeStockTransferRecord: {
            NSDate *previousYearDate = [v.m_DateHelper addToDate:nowDate months:-12];
            v.m_PickerView.minimumDate = previousYearDate;
            v.m_PickerView.maximumDate = nowDate;
            v.m_ChooseDateStr = [[v.m_Formatter stringFromDate:nowDate] substringToIndex:10];
            v.m_ChooseDate = nowDate;
            break;
        }
        case IBChooseDateTypeTradeActiveChooseBirthday: {
            
            v.m_PickerView.maximumDate = [NSDate date];
            v.m_PickerView.date = nowDate;
            v.m_ChooseDate = [NSDate date];
            v.m_ChooseDate = nowDate;
            break;
        }
        case IBChooseDateTypeStockTransferIn:  {
            v.m_PickerView.date = nowDate;
            v.m_ChooseDate = nowDate;
            break;
        }
        case IBChooseDateTypeStockTransferOut: {
            v.m_PickerView.date = nowDate;
            v.m_ChooseDate = nowDate;
            break;
        }
        case IBChooseDateTypeFX_WeiTuo_History: {
            v.m_PickerView.date = nowDate;
            v.m_ChooseDate = nowDate;
            //NSDate *minDate = [v.m_DateHelper addToDate:nowDate days:-FXQuoteManager().fxGlobalConfigModel.maxQueryHistoryDuration];
//            v.m_PickerView.minimumDate = minDate;
            v.m_PickerView.maximumDate = nowDate;
            
            break;
        }
        case IBChooseDateTypeFX_PingCang_History: {
            v.m_PickerView.date = nowDate;
            v.m_ChooseDate = nowDate;
            //NSDate *minDate = [v.m_DateHelper addToDate:nowDate days:-FXQuoteManager().fxGlobalConfigModel.maxQueryHistoryDuration];
//            v.m_PickerView.minimumDate = minDate;
            v.m_PickerView.maximumDate = nowDate;
            break;
        }
        default:
            break;
    }
    
    
    [v layoutIfNeeded];
    [UIView animateWithDuration:0.4 animations:^{
        v.m_ViewBottomDistace.constant = 0;
        [v layoutIfNeeded];
    }];
}


/**
 隐藏选择日期View
 */
+ (void)hideDatePickView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    id v = [window viewWithTag:9000];
    if ([v isKindOfClass:[IBDatePickerView class]] ) {
        IBDatePickerView *selfV = (IBDatePickerView *)v;
        [selfV layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            selfV.m_ViewBottomDistace.constant = -260  ;
            [selfV layoutIfNeeded];
        } completion:^(BOOL finished) {
            [v removeFromSuperview];
        }];
    }
}


#pragma mark    每次日期改变
- (void)changeDate:(UIDatePicker *)picker {
    NSDate *date = picker.date;
    self.m_ChooseDate = date;
    NSString *dateStr = [[self.m_Formatter stringFromDate:self.m_ChooseDate] substringToIndex:10];
    self.m_ChooseDateStr = dateStr;
//    self.m_CallBack(dateStr, date);
}



#pragma mark    interFacebuilderMethod

- (IBAction)dimissAction:(UIButton *)sender {
    [IBDatePickerView hideDatePickView];
}


- (IBAction)cancle:(UIButton *)sender {
    [IBDatePickerView hideDatePickView];
}


- (IBAction)confirm:(UIButton *)sender {
    self.m_CallBack([[self.m_Formatter stringFromDate:self.m_ChooseDate] substringToIndex:10], self.m_ChooseDate);
    [IBDatePickerView hideDatePickView];
}



#pragma mark    Case
- (NSDateFormatter *)m_Formatter {
    if (!_m_Formatter) {
        _m_Formatter = [[NSDateFormatter alloc] init];
        [_m_Formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
        [_m_Formatter setDateStyle:NSDateFormatterMediumStyle];
        [_m_Formatter setTimeStyle:NSDateFormatterShortStyle];
        [_m_Formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    }
    return _m_Formatter;
}

- (JTDateHelper *)m_DateHelper {
    if (!_m_DateHelper) {
        _m_DateHelper = [JTDateHelper new];
    }
    return _m_DateHelper;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
