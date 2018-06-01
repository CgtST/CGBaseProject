//
//  QNBaseViewController.m
//  QNPhoneNiuNiu
//
//  Created by 米饭 on 13-5-15.
//  Copyright (c) 2013年 Manny_at_futu.cn. All rights reserved.
//

#import "IBBaseViewController.h"

#import <Masonry/Masonry.h>

#import <MBProgressHUD/MBProgressHUD.h>
#import <SDImageCache.h>
#import <SDWebImageManager.h>
#import "IBViewHelp.h"
#import "IBRemindView.h"

/*
#import "QNQuoteLineViewController.h"
#import "IBHelpCenterViewController.h"
#import "IBTradeTimer.h"
#import "IBCustomLoginView.h"
#import "UIScrollView+IBScrollViewTouch.h"
#import "IBT_FSuperSliderViewController.h"
#import "IBHomeMainViewController.h"
#import "QuoteMainViewController.h"
//#import "IBTradeHomeSlideViewController.h"
#import "IBInformationFatherViewController.h"
#import "IBFinancingMainViewController.h"
#import "IBSearchStockViewController.h"
#import "IBNewStockProtalViewController.h"
#import "IBNewstockSubscribeViewController.h"
#import "IBSubscribeSubmitViewController.h"
#import "IBCustomWKWebViewController.h"
#import "IBMessageContentViewController.h"
#import "IBTradeSearchViewController.h"
#import "IBSubscribeFinishViewController.h"
#import "IBFXMoneyInFinishViewController.h"
#import "IBTradeLoginModle.h"

*/

#import "UIViewController+IBXNavigationExtension.h"







static CGFloat kTipsViewHeight = 36.f;

@interface IBBaseViewController () <UIViewControllerPreviewingDelegate,UINavigationControllerDelegate, UIScrollViewDelegate>

@property (nonatomic) BOOL isKeyboardAppear;

@property (weak, nonatomic) MBProgressHUD *currentHUD;

@property (weak, nonatomic) UIView *hudShowInView;
/**
 *   是否需要显示默认空界面，默认不需要,需要在ViewDidLoad之后调用
 */
@property (nonatomic) BOOL neededEmptyView;




//@property (nonatomic, strong) IBTradeLoginModle  *m_TradeLoginModel;

@end

@implementation IBBaseViewController

#pragma mark - Lifecycle
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initController];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initController];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initController];
    }
    return self;
}

- (void)initController {
    self.childViewControllersAppearanceAutomatically = YES;
}

- (void)setCustomBarItem:(SEL)action
                  titles:(NSArray *)titles
                   color:(UIColor *)color
                  images:(NSArray *)images
                    side:(NavBarSide)side
{
    if (titles && titles.count > 0) {
        NSMutableArray *items = [NSMutableArray array];
        for (int i=0; i < titles.count; i++) {
            NSString *title = titles[i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
            
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:color forState:UIControlStateNormal];
            [btn setTitleColor:color forState:UIControlStateHighlighted];
            btn.titleLabel.font = [UIFont systemFontOfSize:17];
            btn.frame =CGRectMake(0, 0, 60, 45);
            
            UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
            [items addObject:item];
        }
        if (side == navBarSide_left) {
            self.navigationItem.leftBarButtonItems = items;
        } else {
            self.navigationItem.rightBarButtonItems = items;
        }
    }
    
    if (images && images.count > 0) {
        NSMutableArray *items = [NSMutableArray array];
        for (int i=0; i < images.count; i++) {
            UIImage *image = images[i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
            
            [btn setImage:image forState:UIControlStateNormal];
            [btn setImage:image forState:UIControlStateHighlighted];
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            btn.frame = CGRectMake(0, 0, 60, 45);
            
            UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
            [items addObject:item];
        }
        if (side == navBarSide_left) {
            self.navigationItem.leftBarButtonItems = items;
        } else {
            self.navigationItem.rightBarButtonItems = items;
        }
    }
}

#pragma makr    xkp begin

#pragma makr    UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [[IBTradeTimer shareTimer] startCaculateTime];
    
}// any offset changes

#pragma makr    xkp end


- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma makr    xkp begin
    
    for (id obj in [self.view subviews]) {
        if ([obj isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)obj).delegate = self;
        }
    }
#pragma makr    xkp end
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHideKeyboard) name:UIKeyboardDidHideNotification object:nil];
    self.navigationController.delegate = self;
    [self setupObservers];

    [UIView setAnimationsEnabled:YES];

    
   /* if ([self isKindOfClass:[IBHomeMainViewController class]] ||
        [self isKindOfClass:[QuoteMainViewController class]] ||
        [self isKindOfClass:[IBT_FSuperSliderViewController class]] ||
        [self isKindOfClass:[IBInformationFatherViewController class]] ||
        [self isKindOfClass:[IBFinancingMainViewController class]]||
        [self isKindOfClass:[IBSearchStockViewController class]]||
        [self isKindOfClass:[IBNewStockProtalViewController class]]||
        [self isKindOfClass:[IBNewstockSubscribeViewController class]]||
        [self isKindOfClass:[IBSubscribeSubmitViewController class]]
        ||[self isKindOfClass:[IBSubscribeFinishViewController class]]
        ||[self isKindOfClass:[IBFXMoneyInFinishViewController class]]
        )
    {

    }else {
        [self setCustomBarItem:@selector(goBack) titles:nil color:[UIColor whiteColor] images:@[[UIImage imageNamed:@"gray_back"]] side:navBarSide_left];
    }*/

    if (self.creatBackItem) {
        self.navigationItem.leftBarButtonItem = nil;
        [self setCustomBarItem:@selector(getBack) titles:nil color:[UIColor whiteColor] images:@[[UIImage imageNamed:@"gray_back"]] side:navBarSide_left];
    }
}


-(void)showCloseClick:(UIButton *)sender
{
    [self.xNavigationcontroller popToRootViewControllerAnimated:YES];
}

-(void)showBackClick:(UIButton *)sender
{
    [self.xNavigationcontroller popViewControllerAnimated:YES];
}



-(void)goBack {
    [self.xNavigationcontroller popViewControllerAnimated:YES];
//    ///系统消息详情界面, 推送原因, 做另外的检测
//    if ([self isKindOfClass:[IBMessageContentViewController class]]) {
//        [self getBack];
//    }
    
}

- (void)getBack {
    if (self.xNavigationcontroller.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)willShowKeyboard {
    self.isKeyboardAppear = YES;

}

- (void)didHideKeyboard {
    self.isKeyboardAppear = NO;
}

- (void)dealloc
{
#if !DEBUG
    NSLog(@"\nController Dealloc: %@ \n", self);
#endif
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    if (self.isViewLoaded) {
        [self unloadObservers];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
    }];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
    }];
    [[SDImageCache sharedImageCache] clearMemory];
    
    
#if DEBUG
    NSLog(@"\nController didReceiveMemoryWarning: %@ \n", self);
#endif
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
//    [[IBTradeTimer shareTimer] startCaculateTime];
    
#if DEBUG
    NSLog(@"%@ willAppear",NSStringFromClass([self class]));
#endif

    if (self.childViewControllersAppearanceAutomatically) {
        for (UIViewController * VC in self.childViewControllers) {
            [VC beginAppearanceTransition:YES animated:animated];
            [VC endAppearanceTransition];
        }
    }
    
    // 1. 返回手势代理
    /*if ([self isKindOfClass:[IBSubscribeFinishViewController class]]
        || [self isKindOfClass:[IBHelpCenterViewController class]]
        ||[self isKindOfClass:[ IBCustomWKWebViewController class]]
        ||[self isKindOfClass:[IBFXMoneyInFinishViewController class]]) {
       
    }
    else*/
    {
        if (self.xNavigationcontroller.viewControllers.count>2 ) {
            UIButton * closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
            [closeButton setTitleColor:[UIColor colorWithHexString:@"#cccccc" ] forState:UIControlStateNormal];
            [closeButton setTitleColor:[UIColor colorWithHexString:@"#cccccc" ] forState:UIControlStateNormal];
            [closeButton addTarget:self action:@selector(showCloseClick:) forControlEvents:UIControlEventTouchUpInside];
            [closeButton setTitle:CustomLocalizedString(@"MINEGUANBI", nil) forState:UIControlStateNormal];
            [closeButton setTitle:CustomLocalizedString(@"MINEGUANBI", nil) forState:UIControlStateHighlighted];
            UIBarButtonItem *backItem = [IBViewHelp getCustomBackButtonItem:self action:@selector(showBackClick:)];
            UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
            self.navigationItem.leftBarButtonItems = @[backItem,closeItem];
        }
    }

    
}


- (BOOL) needHiddenBarInViewController:(UIViewController *)viewController
{
    BOOL needHideNaivgaionBar = NO;

  /*  if ([viewController isKindOfClass: [QNQuoteLineViewController class] ]
       ){
        needHideNaivgaionBar = YES;
    }
*/
    return needHideNaivgaionBar;
}

#pragma mark - UINaivgationController Delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

//    [self.navigationController setNavigationBarHidden: [self needHiddenBarInViewController: viewController]
//                                             animated: animated];
}




- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.viewAppeared = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];

#if DEBUG
    NSLog(@"%@ willDisappear",NSStringFromClass([self class]));
#endif
    self.viewAppeared = NO;

    if (self.childViewControllersAppearanceAutomatically) {
        for (UIViewController * VC in self.childViewControllers) {
            [VC beginAppearanceTransition:YES animated:animated];
            [VC endAppearanceTransition];
        }
    }
}

/* Do not use :
 Set the UIViewControllerBasedStatusBarAppearance to YES in the .plist file.
 
 In the viewDidLoad do a [self setNeedsStatusBarAppearanceUpdate];
 
 Add the following method:
 
 -(UIStatusBarStyle)preferredStatusBarStyle{
 return UIStatusBarStyleLightContent;
 }
 
 * Instead with :
 Set UIViewControllerBasedStatusBarAppearance to NO in the .plist file.
 Call [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
 */
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}
#pragma mark - Override
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    //如果不需要显示登录界面则执行父类方法，否则不执行跳转操作并弹出登录界面.
   /* if (![QNViewControllerHelper showLoginControllerIfNeed:viewControllerToPresent]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [super presentViewController:viewControllerToPresent animated:flag completion:completion];
        });
    }*/
}



- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

#pragma mark - 自定义返回按钮

- (void)customBackButtonWithAction:(SEL)selector
{
    
    UIImage *image = [UIImage imageNamed:@"gray_back"];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 20+7,60, 30);
    [backBtn setImage:image forState:0];
    [backBtn setImage:image forState:1];
    [backBtn setTitle:CustomLocalizedString(@"MINEFANHUI", nil) forState:0];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [backBtn setTitleColor:[UIColor whiteColor] forState:0];
    //[backBtn setTitleColor:[UIColor colorWithRed:248/255.0 green:141/255.0 blue:73/255.0 alpha:1.0] forState:1];
    [backBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    //    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:selector];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    //    leftButton.imageInsets=UIEdgeInsetsMake(1, 8, -1, -8);
    //    [leftButton setTitle:@"返回"];
    
    [self addLeftBarButtonItem:leftButton];
}
#pragma mark - Public

- (void)setupPreview
{
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if (systemVersion.doubleValue >= 9.0 && self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
    {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
}
- (void)setupObservers {
    
}

- (void)unloadObservers {
    
}


- (void)showTipsWithText:(nullable NSString *)text {
    WEAKSELF
  /*  if (text.length) {
        self.tipsView.textLabel.text = text;
    }else {
        return;
    }
    
    [self.tipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.equalTo(@(kTipsViewHeight));
        make.top.equalTo(weakSelf.view.mas_top).offset(-kTipsViewHeight);
    }];
    [self.view layoutIfNeeded];
    
    [self.view bringSubviewToFront:self.tipsView];
    [NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipsIfNeeded) object:nil];
    self.tipsView.hidden = NO;
    [self.tipsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
    }];
    [UIView animateWithDuration:0.25f animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [weakSelf performSelector:@selector(dismissTipsIfNeeded) withObject:nil afterDelay:2.5f];
        
    }];*/
}

- (void)showTipsWithText:(nullable NSString *)text behindView:(nonnull UIView *)behindView {
   /* WEAKSELF
    if (text.length && behindView) {
        self.tipsView.textLabel.text = text;
    }else {
        return;
    }
    
    [self.tipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.equalTo(@(kTipsViewHeight));
        make.bottom.equalTo(behindView.mas_bottom);
    }];
    [self.view layoutIfNeeded];
    [self.view bringSubviewToFront:self.tipsView];
    [self.view bringSubviewToFront:behindView];
    [NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipsIfNeeded) object:nil];
    self.tipsView.hidden = NO;
    [self.tipsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(behindView.mas_bottom).offset(kTipsViewHeight);
    }];
    [UIView animateWithDuration:0.25f animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [weakSelf performSelector:@selector(dismissTipsIfNeeded) withObject:nil afterDelay:2.5f];
    }];*/

}



- (void)setupSubviews {
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:CustomLocalizedString(@"MINEFANHUI", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:back];
}

#pragma mark - Private

- (void)dismissTipsIfNeeded {
   /* if (!_tipsView || _tipsView.hidden) {
        return;
    }
    WEAKSELF
    [self.tipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.equalTo(@(kTipsViewHeight));
        make.top.equalTo(weakSelf.view.mas_top).offset(-kTipsViewHeight);
    }];
    [UIView animateWithDuration:0.25f animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        weakSelf.tipsView.hidden = YES;
        [weakSelf.view sendSubviewToBack:weakSelf.tipsView];
    }];*/
}

- (void)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -15;
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, leftBarButtonItem,  nil]];
}





@end

@implementation IBBaseViewController(HUD)

- (void)showHubCancelable:(BOOL)cancelable configTitle:(NSString  * _Nullable  (^_Nullable)())configTitle {
    NSString *title = nil;
    if (configTitle) {
        title = configTitle();
    }
    
    self.hudShowInView = self.view;
    if (!cancelable) {
        self.hudShowInView = self.isKeyboardAppear ? [UIApplication sharedApplication].keyWindow : self.navigationController.view;
    }
    
    if (!cancelable && [self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self.view endEditing:YES];
    self.currentHUD = [MBProgressHUD showHUDAddedTo:self.hudShowInView animated:YES];
    
    if ([title length]) {
        self.currentHUD.labelText = title;
    }
    
}

- (void)hideHub {
    [MBProgressHUD hideHUDForView:self.hudShowInView animated:YES];
    [self.currentHUD hide:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
          self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)showToastWithText:(nonnull NSString *)text style:(IBBaseViewControllerToastStyle)style
{
    
   /* if (self.m_TradeLoginModel.TRAC.length < 1 && self.m_TradeLoginModel.JSID.length > 1) {
        if ([text containsString:@"参数为空[accountID]"] ||[text containsString:@"参数为空[accountId]"] || [text containsString:@"参数为空[accountid]"] || [text containsString:@"参数为空[accountiD]"]) {
            return;
        }
    }
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    switch (style) {
        case QNBaseViewControllerToastStyleNormal:
            [QNRemindView showMessag:text toView:keywindow];
            break;
            
        case QNBaseViewControllerToastStyleSuccess:
            [QNRemindView showSuccess:text toView:keywindow];
            break;
            
        case QNBaseViewControllerToastStyleError:
            [QNRemindView showError:text toView:keywindow];
            break;
        default:
            break;
    }*/
}

- (void)showToastWithText:(nonnull NSString *)text {
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    [IBRemindView showMessag:text toView:keywindow];
}

- (void)showToastWithTextForTrade:(nonnull NSString *)text {
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    [IBRemindView showMessagForTrade:text toView:keywindow];
}

- (void)setupForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];

    __weak UIViewController *weakSelf = self;
    
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [weakSelf.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [weakSelf.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

-(void)showHXCustomVC
{
/*
//    HChatClient *client = [HChatClient sharedClient];
//    if (client.isLoggedInBefore != YES) {
//        HError *error = [client loginWithUsername:User().imId password:User().imPassword];
//    }
    HDMessageViewController *chatVC = [[HDMessageViewController alloc] initWithConversationChatter:HXKF_IM_SERVER_NUM]; // 获取地址：kefu.easemob.com，“管理员模式 > 渠道管理 > 手机APP”页面的关联的“IM服务号”
//    chatVC.visitorInfo.nickName = User().nickname;
//    chatVC.visitorInfo.nickName = [User().phoneNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];;
    HConversation *conversation = [[HChatClient sharedClient].chat getConversation:HXKF_IM_SERVER_NUM];
    [self.navigationController pushViewController:chatVC animated:YES];

*/
}





/**
 为一个UIViewController的左侧或者右侧添加navigationItems
 
 @param action 执行的方法
 @param titles 如果是标题, 传入标题数组
 @param color 颜色
 @param images 如果是图片, 传入图片数组
 @param side 0:左侧, 1:右侧
 */
- (void)setCustomBarItem:(SEL  )action  titles:(NSArray *_Nullable)titles color:(UIColor  *_Nullable)color images:(NSArray  *_Nullable)images withSide:(NSInteger)side   {
    if (titles && titles.count > 0) {
        NSMutableArray *items = [NSMutableArray array];
        for (int i=0; i < titles.count; i++) {
            NSString *title = titles[i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
            
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:color forState:UIControlStateNormal];
            [btn setTitleColor:color forState:UIControlStateHighlighted];
            btn.titleLabel.font = [UIFont systemFontOfSize:17];
            btn.frame =CGRectMake(0, 0, 60, 45);
            
            UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
            [items addObject:item];
        }
        if (side == 0) {
            self.navigationItem.leftBarButtonItems = items;
        } else {
            self.navigationItem.rightBarButtonItems = items;
        }
    }
    
    if (images && images.count > 0) {
        NSMutableArray *items = [NSMutableArray array];
        for (int i=0; i < images.count; i++) {
            UIImage *image = images[i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
            
            [btn setImage:image forState:UIControlStateNormal];
            [btn setImage:image forState:UIControlStateHighlighted];
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            btn.frame = CGRectMake(0, 0, 60, 45);
            
            UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
            [items addObject:item];
        }
        if (side == 0) {
            self.navigationItem.leftBarButtonItems = items;
        } else {
            self.navigationItem.rightBarButtonItems = items;
        }
    }
}







#pragma mark    er
- (void)setForceShowCloseItem:(BOOL)forceShowCloseItem {
    _forceShowCloseItem = forceShowCloseItem;
    if (_forceShowCloseItem) {
        UIButton * closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
        [closeButton setTitleColor:[UIColor colorWithHexString:@"#cccccc" ] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithHexString:@"#cccccc" ] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(showCloseClick:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setTitle:CustomLocalizedString(@"MINEGUANBI", nil) forState:UIControlStateNormal];
        [closeButton setTitle:CustomLocalizedString(@"MINEGUANBI", nil) forState:UIControlStateHighlighted];
        UIBarButtonItem *backItem = [IBViewHelp getCustomBackButtonItem:self action:@selector(showBackClick:)];
        UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
        self.navigationItem.leftBarButtonItems = @[backItem,closeItem];

    }else {
        self.navigationItem.leftBarButtonItems = nil;
        UIBarButtonItem *backItem = [IBViewHelp getCustomBackButtonItem:self action:@selector(showBackClick:)];
        self.navigationItem.leftBarButtonItems = @[backItem];
    }
}






- (void)setCreatBackItem:(BOOL)creatBackItem {
    _creatBackItem = creatBackItem;
    if (_creatBackItem) {
        self.navigationItem.leftBarButtonItem = nil;
        [self setCustomBarItem:@selector(getBack) titles:nil color:[UIColor whiteColor] images:@[[UIImage imageNamed:@"gray_back"]] side:navBarSide_left];
    }
}


/*
- (IBTradeLoginModle *)m_TradeLoginModel {
    if (!_m_TradeLoginModel) {
        _m_TradeLoginModel = [[IBTradeLoginModle alloc] init];
    }
    return _m_TradeLoginModel;
}*/





@end
