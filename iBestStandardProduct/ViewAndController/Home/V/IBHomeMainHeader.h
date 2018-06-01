//
//  IBHomeMainHeader.h
//  QNApp
//  tableview的header

//  Created by xboker on 2017/4/20.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HomeMainHeaderTapType) {
    HomeMainHeaderTapTypeZiXuanGu = 600,///自选股
    HomeMainHeaderTapTypeXinGuShenGou,///新股申购
    HomeMainHeaderTapTypeJiJinMaiMai,///基金买卖
    HomeMainHeaderTapTypeYeWuBanLi///业务办理
};


@protocol IBHomeMainHeaderDelegate <NSObject>
@required
- (void)ibHomeMainHeaderTapWithType:(HomeMainHeaderTapType)type;

@end


@interface IBHomeMainHeader : UIView

@property (weak, nonatomic) IBOutlet UIButton *m_First;
@property (weak, nonatomic) IBOutlet UIButton *m_Second;
@property (weak, nonatomic) IBOutlet UIButton *m_Third;
@property (weak, nonatomic) IBOutlet UIButton *m_Fouth;

@property (weak, nonatomic) IBOutlet UILabel *firstLab;
@property (weak, nonatomic) IBOutlet UILabel *twoLab;
@property (weak, nonatomic) IBOutlet UILabel *thirdLab;
@property (weak, nonatomic) IBOutlet UILabel *fouthLab;

@property (weak, nonatomic) IBOutlet UIButton *optionalImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *stockImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *moneyImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *functionImageBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMas;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMasTwo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMasThree;


@property (nonatomic, weak) id<IBHomeMainHeaderDelegate>delegate;

@end
