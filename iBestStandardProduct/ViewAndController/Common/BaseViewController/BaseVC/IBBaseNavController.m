//
//  QNBaseNavController.m
//  QNPhoneNiuNiu
//
//  Created by 米饭 on 13-5-15.
//  Copyright (c) 2013年 Manny_at_futu.cn. All rights reserved.
//

#import "IBBaseNavController.h"
#import "UIColor+HexString.h"
#import <DKNightVersion/DKNightVersion.h>

#import "UIViewController+IBXNavigationExtension.h"




#pragma mark    IBXPackageNavigationViewController
@interface IBXPackageNavigationViewController : UINavigationController
@end
@implementation IBXPackageNavigationViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBar.dk_barTintColorPicker = DKColorPickerWithKey(QBar);
    self.navigationBar.translucent = NO;
    self.xFullScreenPopEnable = YES;
    [UIView setAnimationsEnabled:YES];
}





- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}



- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    return [self.navigationController popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    return [self.navigationController popToRootViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    IBBaseNavController *navC = viewController.xNavigationcontroller;
    NSInteger index = [navC.xViewControllers indexOfObject:viewController];
    return [self.navigationController popToViewController:navC.viewControllers[index] animated:animated];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.xNavigationcontroller = (IBBaseNavController *)self.navigationController;
    viewController.xFullScreenPopEnable = viewController.xNavigationcontroller.xFullScreenPopEnable;
    [self.navigationController pushViewController:[IBXViewController packageViewControllerWithViewCOntroller:viewController] animated:animated];
    
    
}


- (void)didTapBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [self.navigationController dismissViewControllerAnimated:flag completion:completion];
    self.viewControllers.firstObject.xNavigationcontroller = nil;
}

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:DKNightVersionThemeChangingNotification object:nil];
    NSLog(@"[%@-----------dealloc]",self.class);
}



@end



#pragma mark    IBXViewController

static NSValue  *xTabBarRectValue;

@implementation IBXViewController

+ (IBXViewController *)packageViewControllerWithViewCOntroller:(UIViewController *)viewController {
    IBXPackageNavigationViewController *packageC = [[IBXPackageNavigationViewController alloc] init];
    packageC.viewControllers = @[viewController];
//    [packageC.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#2E2E2E"]];

    IBXViewController *viewC = [[IBXViewController alloc] init];
    [viewC.view addSubview:packageC.view];
    [viewC addChildViewController:packageC];
    return viewC;
    
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.tabBarController && !xTabBarRectValue) {
        xTabBarRectValue = [NSValue valueWithCGRect:self.tabBarController.tabBar.frame];
    } 
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.tabBarController && [self rootViewController].hidesBottomBarWhenPushed) {
        self.tabBarController.tabBar.frame = CGRectZero;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.translucent = YES;
    if (self.tabBarController && !self.tabBarController.tabBar.hidden && xTabBarRectValue) {
        self.tabBarController.tabBar.frame = xTabBarRectValue.CGRectValue;
    }
}


- (BOOL)xFullScreenPopEnable {
    return [self rootViewController].xFullScreenPopEnable;
}

- (BOOL)hidesBottomBarWhenPushed {
    return [self rootViewController].hidesBottomBarWhenPushed;
}

- (UITabBarItem *)tabBarItem {
    return [self rootViewController].tabBarItem;
}

- (NSString *)title {
    return [self rootViewController].title;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return [self rootViewController];
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return [self rootViewController];
}

- (UIViewController *)rootViewController {
    IBXPackageNavigationViewController *pakgageC = self.childViewControllers.firstObject;
    return pakgageC.viewControllers.firstObject;
}


@end




#pragma mark    QNBaseNavController

@interface IBBaseNavController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property(nonatomic,strong) UIView * navBarView;  //自定义导航栏

//@property (nonatomic, strong) UIPanGestureRecognizer    *popPanGesture;

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer   *popPanGesture;


@property (nonatomic, strong) id                        popGestureDelegate;



@end

@implementation IBBaseNavController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self applyTheme];
        self.xFullScreenPopEnable = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.viewControllers.firstObject.xNavigationcontroller = self;
        self.viewControllers = @[[IBXViewController packageViewControllerWithViewCOntroller:self.viewControllers.firstObject]];
        [self applyTheme];
        self.xFullScreenPopEnable = YES;
    }
    return self;
}


- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController: rootViewController];
    if (self) {
        rootViewController.xNavigationcontroller = self;
        self.viewControllers = @[[IBXViewController packageViewControllerWithViewCOntroller:rootViewController]];
        [self applyTheme];
        self.xFullScreenPopEnable = YES;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.shouldShowTradeLogin = NO;
    
    [self setNavigationBarHidden:YES];    
    self.popGestureDelegate = self.interactivePopGestureRecognizer.delegate;
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
//    self.popPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.popGestureDelegate action:action];
//    self.popPanGesture.maximumNumberOfTouches = 1;
    
    
    self.popPanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self.popGestureDelegate action:action];
    self.popPanGesture.edges = UIRectEdgeLeft;

    [self applyTheme];
    self.delegate = self;
 

}




- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


- (void)applyTheme {
    

    UIColor *bgColor = [UIColor colorWithHexString:@"#2e2e2e"];
    UIImage *bgImage = [self imageWithColor:bgColor size:CGSizeMake(1, 64)];
    //    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationBar setBarTintColor:bgColor];
    
    _barBgColor = bgColor;
    [self.navigationBar setBarStyle: UIBarStyleDefault];
  
    self.navigationBar.translucent = NO;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationBar.titleTextAttributes = dict;
    

    

}

- (BOOL)shouldAutorotate {
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;//UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

//FIXME:在创建组合成功后的push操作不会触发didShowViewController方法。导致方法判断失效。暂时屏蔽
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if (!self.shouldIgnorePushingViewControllers)
//    {
//        [super pushViewController:viewController animated:animated];
//    }
//    
//    self.shouldIgnorePushingViewControllers = YES;
//}




//- (void)didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    self.shouldIgnorePushingViewControllers = NO;
//}
//
//- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated {
//    UIViewController *popedController = [super popViewControllerAnimated:animated];
//    if ([popedController isKindOfClass:NSClassFromString(@"UVPayInputViewController")]) {
//        [self applyTheme];
//    }
//    return popedController;
//}
//
//- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if ([viewController isKindOfClass:NSClassFromString(@"UVPayInputViewController")]) {
//        [self applyTheme];
//    }
//    return [super popToViewController:viewController animated:animated];
//}
//
//- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
//    if (self.viewControllers.count) {
//        UIViewController *rootViewController = [self.viewControllers firstObject];
//        if ([rootViewController isKindOfClass:NSClassFromString(@"UVPayInputViewController")]) {
//            [self applyTheme];
//        }
//    }
//    return [super popToRootViewControllerAnimated:animated];
//}
//
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if ([viewController isKindOfClass:NSClassFromString(@"UVPayInputViewController")]) {
//        viewController.hidesBottomBarWhenPushed = YES;
//    }
//    //如果不需要现实登录界面则执行父类方法，否则不执行push操作并弹出登录界面.
//    if (![QNViewControllerHelper showLoginControllerIfNeed:viewController]) {
//        
//        //第三方sdk不兼容  导致不走didShowViewController:(UIViewController *)viewController animated:(BOOL)animated方法
//        
////        if (!self.shouldIgnorePushingViewControllers)
////        {
////            self.shouldIgnorePushingViewControllers = YES;
//            [super pushViewController:viewController animated:animated];
////        }
//    }
//}


#pragma mark - Private method

//设置状态栏的背影色
-(void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView * statusBarView = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"]valueForKey:@"statusBar"];
    if ([statusBarView respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBarView.backgroundColor = color;
    }
}


#pragma mark    UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isRootVC = viewController == navigationController.viewControllers.firstObject;
    if (viewController.xFullScreenPopEnable) {
        if (isRootVC) {
            [self.view removeGestureRecognizer:self.popPanGesture];
        }else {
            [self.view addGestureRecognizer:self.popPanGesture];
        }
        self.interactivePopGestureRecognizer.delegate = self.popGestureDelegate;
        self.interactivePopGestureRecognizer.enabled = NO;
        
    }else {
        [self.view removeGestureRecognizer:self.popPanGesture];
        self.interactivePopGestureRecognizer.delegate = self;
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
}



#pragma mark - UIGestureRecognizerDelegate

//修复有水平方向滚动的ScrollView时边缘返回手势失效的问题
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}


#pragma mark    Case

- (NSArray *)xViewControllers {
        NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:0];
        for (IBXViewController *viewcontroller in self.viewControllers) {
            [viewControllers addObject:viewcontroller.rootViewController];
        }
        return viewControllers;
}


-(UIView *)navBarView {
    if(nil == _navBarView)
    {
        _navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
        _navBarView.backgroundColor = [UIColor grayColor];
    }

    return _navBarView;
}

@end
