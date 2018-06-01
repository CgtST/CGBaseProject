//
//  IBBaseViewController.h
//  IBPhoneNiuNiu
//
//  Created by 米饭 on 13-5-15.
//  Copyright (c) 2013年 Manny_at_futu.cn. All rights reserved.
//



#import "UIViewController+IBXNavigationExtension.h"


typedef NS_ENUM(NSUInteger, NavBarSide) {
    navBarSide_left,
    navBarSide_right
};

typedef void (^BackButtonHandle)(void);



@interface IBBaseViewController : UIViewController {

}


/**
 默认情况下, 左上角的返回按钮在stack中的第一个位置是不创建的; 如果这个属性设置YES,则一定会创建, 能pop就pop,不能pop就会dismiss
 */
@property (nonatomic, assign) BOOL creatBackItem;

@property (nonatomic,assign) BOOL forceShowCloseItem;   //强制显示关闭按钮（不用管是从第3层开始）  返回到rootViewcontroller


@property (nonatomic) BOOL viewAppeared;




#pragma mark - 生命周期
/**
 *  配置观察者,会在viewDidLoad后调用
 */
- (void)setupObservers;
/**
 *  卸载观察者,与setupObservers对应,此处释放setupObservers中添加的观察者
 */
- (void)unloadObservers;

/**
 *  配置视图,会在setupObservers后调用，必须调用super
 */
- (void)setupSubviews;

#pragma mark - 自定义
/**
 *  自定义返回按钮
 */
- (void)customBackButtonWithAction:(nonnull SEL)selector;
/**
 *  配置3D Touch Preview,需手动调用
 */
- (void)setupPreview;

- (void)setCustomBarItem:( SEL)action
                  titles:(NSArray * )titles
                   color:(UIColor * )color
                  images:(NSArray * )images
                    side:(NavBarSide)side;
/**
 *   自控制器是否自动调用viewWillAppear和viewWillDisappear方法,默认YES
 */
@property (nonatomic) BOOL childViewControllersAppearanceAutomatically;

@end

typedef NS_ENUM(int8_t, IBBaseViewControllerToastStyle) {
    IBBaseViewControllerToastStyleNormal,
    IBBaseViewControllerToastStyleSuccess,
    IBBaseViewControllerToastStyleError
};

@interface IBBaseViewController (HUD)

- (void)showHubCancelable:(BOOL)cancelable configTitle:(NSString *  (^)())configTitle;

- (void)hideHub;

- (void)showToastWithText:( NSString *)text style:(IBBaseViewControllerToastStyle)style;

- (void)showToastWithText:( NSString *)text;

- (void)showToastWithTextForTrade:( NSString *)text;

-(void)setupForDismissKeyboard;

-(void)showBackClick:(UIButton *)sender;
-(void)showCloseClick:(UIButton *)sender;

#pragma makr    add
- (void)tradeLoginAgainSuccess;
- (void)tradeLoginAgainFailed;


//显示环信客服页面
-(void)showHXCustomVC;




/**
 为一个UIViewController的左侧或者右侧添加navigationItems
 
 @param action 执行的方法
 @param titles 如果是标题, 传入标题数组
 @param color 颜色
 @param images 如果是图片, 传入图片数组
 @param side 0:左侧, 1:右侧
 */
- (void)setCustomBarItem:(SEL   )action  titles:(NSArray *)titles color:(UIColor  *)color images:(NSArray  *)images withSide:(NSInteger)side ;


@end


