//
//  YHNetworkRequestView.h
//  Yihaoqianbao
//  网络请求的友好交互提示
//  Created by Money on 15/12/24.
//  Copyright © 2015年 yhqz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHNetworkRequestView : UIView

/** 背景颜色 */
@property (nonatomic, strong) UIColor *bgViewColor;
/** 提示文字 */
@property (nonatomic, copy) NSString *tipText;
/** 判断是否是动画的属性 */
@property (nonatomic, assign) BOOL isAnimating;

/** 开始动画 */
- (void)startTipNetwork;

/** 停止动画 */
- (void)stopTipNetwork;

/** 类方法创建实例 */
+ (instancetype)networkRequestView;

/** 判断是否是动画的方法  */
- (BOOL)isTipNetworkAnimation;

/** getter */
- (BOOL)isAnimating;

@end
