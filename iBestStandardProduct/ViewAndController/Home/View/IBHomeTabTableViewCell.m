//
//  IBHomeTabTableViewCell.m
//  QNApp
//
//  Created by iBest on 2017/3/8.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBHomeTabTableViewCell.h"
#import "DZNSegmentedControl.h"
@interface IBHomeTabTableViewCell ()<DZNSegmentedControlDelegate>

@end
/*
 "HOME_MARKET_ACTIVE" = "市場動態";
 "HOME_TREASURE" = "財富資訊";
 "HOME_HOT_PRODUCT" = "熱銷產品";
 */
@implementation IBHomeTabTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _menuItems = @[CustomLocalizedString(@"HOME_MARKET_ACTIVE", nil), CustomLocalizedString(@"HOME_TREASURE", nil), CustomLocalizedString(@"HOME_HOT_PRODUCT", nil)];
    _control = [[DZNSegmentedControl alloc] initWithItems:self.menuItems];
    //_control.delegate = self;
    _control.bouncySelectionIndicator = NO;
    _control.frame = CGRectMake(0, 0, ScreenWidth, 45);
    [_control setFont:[UIFont systemFontOfSize:17]];
    _control.tintColor = [UIColor colorWithHexString:@"#ee5835"];
    _control.showsCount = NO;
    _control.autoAdjustSelectionIndicatorWidth = NO;
    _control.selectionIndicatorHeight = 1.0;
    [_control setAnimationDuration:0.25];
    [_control addTarget:self action:@selector(didChangeSegment:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_control];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)didChangeSegment:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSeletedTabWithIndex:)])
    {
        [self.delegate didSeletedTabWithIndex:_control.selectedSegmentIndex];
    }
}
@end
