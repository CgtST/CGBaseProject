////
////  IBXNavigationViewController.m
////  AnimationEffect
////
////  Created by xboker on 2017/5/6.
////  Copyright © 2017年 谢昆鹏. All rights reserved.
////
//
//#import "IBXNavigationViewController.h"
//#import "UIViewController+IBXNavigationExtension.h"
//
//#define k_BackImageName @"backImage"
//
//
//#pragma mark    IBXPackageNavigationViewController
//@interface IBXPackageNavigationViewController : UINavigationController
//
//@end
//
//@implementation IBXPackageNavigationViewController
//
//- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
//    return [self.navigationController popViewControllerAnimated:animated];
//}
//
//- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
//    return [self.navigationController popToRootViewControllerAnimated:animated];
//}
//
//- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    IBXNavigationViewController *navC = viewController.xNavigationcontroller;
//    NSInteger index = [navC.xViewControllers indexOfObject:viewController];
//    return [self.navigationController popToViewController:navC.viewControllers[index] animated:animated];
//}
//
//
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    viewController.xNavigationcontroller = (IBXNavigationViewController *)self.navigationController;
//    viewController.xFullScreenPopEnable = viewController.xNavigationcontroller.xFullScreenPopEnable;
////    UIImage *image  = [UIImage imageNamed:k_BackImageName];
////    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(didTapBackButton)];
//    [self.navigationController pushViewController:[IBXViewController packageViewControllerWithViewCOntroller:viewController] animated:animated];
//    
//    
//}
//
//
//- (void)didTapBackButton {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//
//- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
//    [self.navigationController dismissViewControllerAnimated:flag completion:completion];
//    self.viewControllers.firstObject.xNavigationcontroller = nil;
//}
//
//
//@end
//
//
//
//#pragma mark    IBXViewController
//
//static NSValue  *xTabBarRectValue;
//
//@implementation IBXViewController
//
//+ (IBXViewController *)packageViewControllerWithViewCOntroller:(UIViewController *)viewController {
//    IBXPackageNavigationViewController *packageC = [[IBXPackageNavigationViewController alloc] init];
//    packageC.viewControllers = @[viewController];
//    IBXViewController *viewC = [[IBXViewController alloc] init];
//    [viewC.view addSubview:packageC.view];
//    [viewC addChildViewController:packageC];
//    return viewC;
//
//}
//
//
//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    if (self.tabBarController && !xTabBarRectValue) {
//        xTabBarRectValue = [NSValue valueWithCGRect:self.tabBarController.tabBar.frame];
//    }
//    
//    
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    if (self.tabBarController && [self rootViewController].hidesBottomBarWhenPushed) {
//        self.tabBarController.tabBar.frame = CGRectZero;
//    }
//    
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//
//    self.tabBarController.tabBar.translucent = YES;
//    if (self.tabBarController && !self.tabBarController.tabBar.hidden && xTabBarRectValue) {
//        self.tabBarController.tabBar.frame = xTabBarRectValue.CGRectValue;
//    }
//
//}
//
//
//- (BOOL)xFullScreenPopEnable {
//    return [self rootViewController].xFullScreenPopEnable;
//}
//
//- (BOOL)hidesBottomBarWhenPushed {
//    return [self rootViewController].hidesBottomBarWhenPushed;
//}
//
//- (UITabBarItem *)tabBarItem {
//    return [self rootViewController].tabBarItem;
//}
//
//- (NSString *)title {
//    return [self rootViewController].title;
//}
//
//- (UIViewController *)childViewControllerForStatusBarStyle {
//    return [self rootViewController];
//}
//
//- (UIViewController *)childViewControllerForStatusBarHidden {
//    return [self rootViewController];
//}
//
//- (UIViewController *)rootViewController {
//    IBXPackageNavigationViewController *pakgageC = self.childViewControllers.firstObject;
//    return pakgageC.viewControllers.firstObject;
//}
//
//
//@end
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//#pragma mark    IBXNavigationViewController
//
//@interface IBXNavigationViewController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>
//
//@property (nonatomic, strong) UIPanGestureRecognizer    *popPanGesture;
//@property (nonatomic, strong) id                        popGestureDelegate;
//
//
//@end
//
//@implementation IBXNavigationViewController
//
//
//
//- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
//    if (self = [super init]) {
//        rootViewController.xNavigationcontroller = self;
//        self.viewControllers = @[[IBXViewController packageViewControllerWithViewCOntroller:rootViewController]];
//        [self applyTheme];
//
//        
//    }
//    return self;
//}
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super initWithCoder:aDecoder]) {
//        self.viewControllers.firstObject.xNavigationcontroller = self;
//        self.viewControllers = @[[IBXViewController packageViewControllerWithViewCOntroller:self.viewControllers.firstObject]];
//        [self applyTheme];
//
//
//    }
//    return self;
//}
//
//
//
//- (void)dealloc
//{
////    [[NSNotificationCenter defaultCenter] removeObserver: self];
//}
//
//
//
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self setNavigationBarHidden:YES];
//    self.delegate = self;
//
//    self.popGestureDelegate = self.interactivePopGestureRecognizer.delegate;
//    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
//    self.popPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.popGestureDelegate action:action];
//    self.popPanGesture.maximumNumberOfTouches = 1;
//    [self applyTheme];
////    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(applyTheme) name: kNotifySkinThemeDidChange object: nil];
//    
//    UIColor *bgColor = [UIColor colorWithHexString:@"#2e2e2e"];
//    UIImage *bgImage = [self imageWithColor:bgColor size:CGSizeMake(1, 64)];
//    [self.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
//    //    self.navigationBar.hidden = YES;
//    //    [self.view addSubview:self.navBarView];
//    self.navigationBar.barTintColor = [UIColor whiteColor];
//    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
//    [self.tabBarController.tabBar setBarTintColor:[UIColor whiteColor]];
//    
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    // Do any additional setup after loading the view.
//}
//
//
//
//
//- (void)applyTheme
//{
//    
//    UIColor *bgColor = [UIColor colorWithHexString:@"#2e2e2e"];
//    
//    UIImage *bgImage = [self imageWithColor:bgColor size:CGSizeMake(1, 64)];
//    //    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    [self.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
//    //    [self.navigationBar setBarTintColor:bgColor];
//    
//    _barBgColor = bgColor;
//    [self.navigationBar setBarStyle: UIBarStyleDefault];
//    self.navigationBar.shadowImage = ThemeImage(@"clear");
//    self.navigationBar.translucent = NO;
//    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
//    self.navigationBar.titleTextAttributes = dict;
//    
//    
//}
//
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return NO;//UIInterfaceOrientationIsLandscape(interfaceOrientation);
//}
//
//- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
//{
//    CGRect rect = CGRectMake(0, 0, size.width, size.height);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context,color.CGColor);
//    CGContextFillRect(context, rect);
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return img;
//}
//
//#pragma mark - Private method
//
////设置状态栏的背影色
//-(void)setStatusBarBackgroundColor:(UIColor *)color
//{
//    UIView * statusBarView = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"]valueForKey:@"statusBar"];
//    if ([statusBarView respondsToSelector:@selector(setBackgroundColor:)])
//    {
//        statusBarView.backgroundColor = color;
//    }
//}
//
//
//
//#pragma mark    UINavigationControllerDelegate
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    BOOL isRootVC = viewController == navigationController.viewControllers.firstObject;
//    if (viewController.xFullScreenPopEnable) {
//        if (isRootVC) {
//            [self.view removeGestureRecognizer:self.popPanGesture];
//        }else {
//            [self.view addGestureRecognizer:self.popPanGesture];
//        }
//        self.interactivePopGestureRecognizer.delegate = self.popGestureDelegate;
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }else {
//        [self.view removeGestureRecognizer:self.popPanGesture];
//        self.interactivePopGestureRecognizer.delegate = self;
//        self.interactivePopGestureRecognizer.enabled = !isRootVC;
//    }
//
//}
//
//
//
//
//
//
//#pragma mark - UIGestureRecognizerDelegate
//
////修复有水平方向滚动的ScrollView时边缘返回手势失效的问题
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
//}
//
//
//#pragma mark    Case
//
//- (NSArray *)xViewControllers {
//    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:0];
//    for (IBXViewController *viewcontroller in self.viewControllers) {
//        [viewControllers addObject:viewcontroller.rootViewController];
//    }
//    return [viewControllers copy];
//}
//
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
