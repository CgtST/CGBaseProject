//
//  QNBaseNavController.h
//  QNPhoneNiuNiu
//
//  Created by 米饭 on 13-5-15.
//  Copyright (c) 2013年 Manny_at_futu.cn. All rights reserved.
//



@protocol BackItemHandlerDelegate <NSObject>
@optional
- (BOOL)navigationShouldPopViewController;

@end


@interface IBXViewController : UIViewController

@property (nonatomic, strong, readonly) UIViewController *rootViewController;

+ (IBXViewController *)packageViewControllerWithViewCOntroller:(UIViewController *)viewController;

@end






#warning 临时将父类改为原生nav看下效果
@interface IBBaseNavController : UINavigationController <UINavigationBarDelegate>

//- (void)bePresentedAsModalViewControllerBeginFrame:(CGRect)beginFrame toFrame:(CGRect)endFrame;
//- (void)dismissedSelf;

@property (nonatomic, assign) BOOL shouldShowTradeLogin;

@property (nonatomic, strong, readonly) UIColor *barBgColor;
@property (nonatomic, assign) BOOL shouldIgnorePushingViewControllers;



@property (nonatomic, strong) UIImage       *xBackImage;
///是否允许左侧边缘滑动返回
@property (nonatomic, assign) BOOL          xFullScreenPopEnable;
///!!!!如果y用这个navigationController时, 想pop到指定C或者对栈中元素操作时 必须使用这个数组才行~~~~~
@property (nonatomic, copy)   NSArray       *xViewControllers;
//设置状态栏的背影色
-(void)setStatusBarBackgroundColor:(UIColor *)color;



@end
