//
//  YHXSliderView.h
//  YHXSliderViewControllers
//  将多个视图控制器放上来起到左右滑动效果的类
//  Created by CPZX010 on 16/7/1.
//  Copyright © 2016年 谢昆鹏. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol YHXSliderViewDelegate <NSObject>
@optional
- (void)yhxSliderViewSectionTappedWithTag:(NSInteger)section withButtonStatus:(BOOL)select;

@end

@interface YHXSliderView : UIView

@property (nonatomic, weak) id<YHXSliderViewDelegate>delegate;
///左右切换C时是否有动画,默认是有的
@property (nonatomic, assign) BOOL haveAnimated;

- (instancetype)initSliderViewWith:(CGRect )frame
                        withTitles:(NSArray *)titles
               withViewControllers:(NSArray *)controllersArray;

@end
