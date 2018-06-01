//
//  YHNetworkRequestView.m
//  Yihaoqianbao
//
//  Created by Money on 15/12/24.
//  Copyright © 2015年 yhqz. All rights reserved.
//

#import "YHNetworkRequestView.h"

@interface YHNetworkRequestView ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *tipNetwork;
@property (weak, nonatomic) IBOutlet UILabel *tipContentLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation YHNetworkRequestView

- (void)setBgView:(UIView *)bgView
{
    _bgView = bgView;
    _bgView.layer.cornerRadius = 5.0;
    _bgView.layer.masksToBounds = YES;
}

/** getter */
- (BOOL)isAnimating
{
    if (self.tipNetwork.isAnimating) {
        return YES;
    }else{
        return NO;
    }
}

/** 类方法创建实例 */
+ (instancetype)networkRequestView
{
    @synchronized (self) {
        return [[[NSBundle mainBundle] loadNibNamed:@"YHNetworkRequestView" owner:nil options:nil] lastObject];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.bgViewColor) {
        self.bgView.backgroundColor = self.bgViewColor;
    }
    
    if (self.tipText.length > 0) {
        self.tipContentLabel.text = self.tipText;
    }
}

/** 开始动画 */
- (void)startTipNetwork
{
    if (!self.tipNetwork.isAnimating) {
        [self.tipNetwork startAnimating];
    }
    self.hidden = NO;
}

/** 停止动画 */
- (void)stopTipNetwork
{
    if (self.tipNetwork.isAnimating) {
        [self.tipNetwork stopAnimating];
    }
    self.hidden = YES;
}

/** 判断是否是动画的方法  */
- (BOOL)isTipNetworkAnimation
{
    if (self.tipNetwork.isAnimating) {
        return YES;
    }else{
        return NO;
    }
}

- (void)dealloc
{
    NSLog(@"[%@ ------ dealloc]", self.class);
}

@end
