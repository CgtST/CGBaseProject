//
//  IBTabBarViewController.m
//  QNApp
//
//  Created by zscftwo on 2017/2/6.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBRootTabBarViewController.h"


//#import "QuoteMainViewController.h"
//
//#import "IBFinancingMainViewController.h"
//#import "IBTradeHomeViewController.h"
//#import "IBT_FSuperSliderViewController.h"
//#import "IBInformationFatherViewController.h"
//
//
//#import "IBCustomActivity.h"
//
//#import "IBHomeMainViewController.h"
//#import "IBHomeBtnLogoReq.h"


#import "IBHomeViewController.h"
#import "IBQuoteViewController.h"
#import "IBTradeViewController.h"
#import "IBNewsViewController.h"



@interface IBRootTabBarViewController ()<UITabBarControllerDelegate>
{
    NSDictionary * m_tabBarIconsDic;
}

@property(nonatomic,readonly,retain,nonnull)UINavigationController * homeMainNavController;
@property(nonatomic,readonly,retain,nonnull)UINavigationController * quoteMainNavController;
@property(nonatomic,readonly,retain,nonnull)UINavigationController * tradeMainNavController;
@property(nonatomic,readonly,retain,nonnull)UINavigationController * inforMainNavController;
//@property(nonatomic,readonly,retain,nonnull)UINavigationController * financingNavController;



//@property (nonatomic,strong)IBHomeBtnLogoReq * tabBarLogoReq;

//@property (nonatomic,strong)QuoteMainViewController * quotemainVC;
//@property (nonatomic,strong)IBFinancingMainViewController *financingMainVC;

@end

@implementation IBRootTabBarViewController



///创建Tabbar时检测未读数量, 并展示
- (instancetype)init{
    self = [super init];
    if (self) {
       /*
        HConversation *conversation = [[HChatClient sharedClient].chat getConversation:HXKF_IM_SERVER_NUM];
        NSUInteger count = ibMsgHandler().systemUnReadMessageCount + conversation.unreadMessagesCount;
        if (count > 0) {
            self.tabBar.items.firstObject.badgeValue = [@(count) stringValue];
        }else {
            self.tabBar.items.firstObject.badgeValue = nil;
        }*/
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.viewControllers = @[self.homeMainNavController,self.quoteMainNavController,self.tradeMainNavController,self.inforMainNavController];
    self.tabBar.dk_barTintColorPicker = DKColorPickerWithKey(QContentColor);
    
    UIView *v = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    v.dk_backgroundColorPicker  = DKColorPickerWithKey(QContentColor);
    [[UITabBar appearance] insertSubview:v atIndex:0];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChange:) name:DKNightVersionThemeChangingNotification object:nil];
    self.tabBar.translucent = NO;

//    [self reqBtnLogoData];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguageNoty) name:KIBNotify_ChangLanguage_Success object:nil];
}


- (void)changeLanguageNoty{
    _homeMainNavController.tabBarItem.title = CustomLocalizedString(@"TABBAR_HOME_PAGE", nil);
    _quoteMainNavController.tabBarItem.title = CustomLocalizedString(@"TABBAR_QUOTE", nil);
    _tradeMainNavController.tabBarItem.title = CustomLocalizedString(@"TABBAR_TRADE", nil);
    _inforMainNavController.tabBarItem.title = CustomLocalizedString(@"TABBAR_MESSAGE", nil);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark -网络请求
/*
-(IBHomeBtnLogoReq *)tabBarLogoReq
{
    if (_tabBarLogoReq == nil) {
        _tabBarLogoReq = [[IBHomeBtnLogoReq alloc] init];
    }
    return _tabBarLogoReq;
}

-(void)reqBtnLogoData
{
    WEAKSELF
    [self.tabBarLogoReq ibHomeBtnLogoReqWithResultBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSDictionary * dict = (NSDictionary *)responseObject;
            if (dict[@"data"]) {
                NSDictionary * dataDic = responseObject[@"data"];
                if ([dataDic allKeys].count>0) {
                    m_tabBarIconsDic = dataDic;
                    [weakSelf updateTabLogo];
                }
            }
        }
    }];
}


-(void)updateTabLogo
{
    dispatch_async(dispatch_get_main_queue(), ^{

        UINavigationController *nav1 = self.viewControllers.firstObject;
        UINavigationController *nav2 = self.viewControllers[1];
        UINavigationController *nav3 = self.viewControllers[2];
        UINavigationController *nav4 = self.viewControllers[3];
        if (m_tabBarIconsDic[@"homepage"]) {
            NSArray * homeLogos = m_tabBarIconsDic[@"homepage"];
            if (homeLogos.count>1) {
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:homeLogos[0]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {

                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    CGSize imageSize = CGSizeMake( 30*image.size.width/image.size.height,30);
                    UIImage * modifyImage = [CDTImageTools modifyImageSize:imageSize OfImage:image];
                    nav1.tabBarItem.image = [modifyImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

                }];


                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:homeLogos[1]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {

                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    CGSize imageSize = CGSizeMake( 30*image.size.width/image.size.height,30);
                    UIImage * modifyImage = [CDTImageTools modifyImageSize:imageSize OfImage:image];
                    nav1.tabBarItem.selectedImage = [modifyImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                }];
            }
        }
        if (m_tabBarIconsDic[@"market"]) {
            NSArray * quoteLogos = m_tabBarIconsDic[@"market"];
            if (quoteLogos.count>1) {
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:quoteLogos[0]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {

                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                     CGSize imageSize = CGSizeMake( 30*image.size.width/image.size.height,30);
                    UIImage * modifyImage = [CDTImageTools modifyImageSize:imageSize OfImage:image];
                    nav2.tabBarItem.image = [modifyImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

                }];


                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:quoteLogos[1]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {

                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                     CGSize imageSize = CGSizeMake( 30*image.size.width/image.size.height,30);
                    UIImage * modifyImage = [CDTImageTools modifyImageSize:imageSize OfImage:image];
                    nav2.tabBarItem.selectedImage = [modifyImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                }];
            }
        }


        if (m_tabBarIconsDic[@"trade"]) {
            NSArray * tradeLogos = m_tabBarIconsDic[@"trade"];
            if (tradeLogos.count>1) {
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:tradeLogos[0]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {

                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                     CGSize imageSize = CGSizeMake( 30*image.size.width/image.size.height,30);
                    UIImage * modifyImage = [CDTImageTools modifyImageSize:imageSize OfImage:image];
                    nav3.tabBarItem.image = [modifyImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

                }];


                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:tradeLogos[1]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {

                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                     CGSize imageSize = CGSizeMake( 30*image.size.width/image.size.height,30);
                    UIImage * modifyImage = [CDTImageTools modifyImageSize:imageSize OfImage:image];
                    nav3.tabBarItem.selectedImage = [modifyImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                }];
            }
        }

        if (m_tabBarIconsDic[@"news"]) {
            NSArray * newsLogos = m_tabBarIconsDic[@"news"];
            if (newsLogos.count>1) {
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:newsLogos[0]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {

                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                     CGSize imageSize = CGSizeMake( 30*image.size.width/image.size.height,30);
                    UIImage * modifyImage = [CDTImageTools modifyImageSize:imageSize OfImage:image];
                    nav4.tabBarItem.image = [modifyImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

                }];


                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:newsLogos[1]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {

                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                     CGSize imageSize = CGSizeMake( 30*image.size.width/image.size.height,30);
                    UIImage * modifyImage = [CDTImageTools modifyImageSize:imageSize OfImage:image];
                    nav4.tabBarItem.selectedImage = [modifyImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                }];
            }
        }
     });
}

*/


#pragma mark    obbserver
- (void)themeChange:(NSNotification *)sender {
    UINavigationController *nav1 = self.viewControllers.firstObject;
    UINavigationController *nav2 = self.viewControllers[1];
    UINavigationController *nav3 = self.viewControllers[2];
    UINavigationController *nav4 = self.viewControllers[3];

    if ([self.dk_manager.themeVersion isEqualToString:@"NORMAL"] || [self.dk_manager.themeVersion isEqualToString:@""]) {
        nav1.tabBarItem.image = [UIImage imageNamed: @"home_icon"];
        nav2.tabBarItem.image = [UIImage imageNamed:@"quote_icon"];
        nav3.tabBarItem.image = [UIImage imageNamed:@"trade_icon"];
        nav4.tabBarItem.image = [UIImage imageNamed:@"news_icon"];
        [nav1.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#666666"], NSFontAttributeName : [UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
        [nav2.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#666666"], NSFontAttributeName : [UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
        [nav3.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#666666"], NSFontAttributeName : [UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
        [nav4.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#666666"], NSFontAttributeName : [UIFont systemFontOfSize:12]} forState:UIControlStateNormal];

        self.tabBar.backgroundImage = [IBGlobalMethod  imageWithColor:[UIColor colorWithHexString:@"#E0E0E0"] size:CGSizeMake(ScreenWidth, NavBarHeight) ];
        self.tabBar.shadowImage = [IBGlobalMethod  imageWithColor:[UIColor colorWithHexString:@"#E0E0E0"] size:CGSizeMake(ScreenWidth, NavBarHeight) ];

    }else if ([self.dk_manager.themeVersion isEqualToString:@"NIGHT"]) {
        
        nav1.tabBarItem.image = [UIImage imageNamed:@"home_night"];
        nav2.tabBarItem.image = [UIImage imageNamed:@"quote_night"];
        nav3.tabBarItem.image = [UIImage imageNamed:@"trade_night"];
        nav4.tabBarItem.image = [UIImage imageNamed:@"news_night"];
        
        [nav1.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#cccccc"], NSFontAttributeName : [UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
        [nav2.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#cccccc"], NSFontAttributeName : [UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
        [nav3.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#cccccc"], NSFontAttributeName : [UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
        [nav4.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#cccccc"], NSFontAttributeName : [UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
        self.tabBar.backgroundImage = [IBGlobalMethod imageWithColor:[UIColor colorWithHexString:@"#323232"] size:CGSizeMake(ScreenWidth, NavBarHeight)];
        self.tabBar.shadowImage = [IBGlobalMethod imageWithColor:[UIColor colorWithHexString:@"#323232"] size:CGSizeMake(ScreenWidth, NavBarHeight)];
    }else {
        [nav1.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#f0f0f0"], NSFontAttributeName : [UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
        [nav2.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#f0f0f0"], NSFontAttributeName : [UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
        [nav3.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#f0f0f0"], NSFontAttributeName : [UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
        [nav4.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#f0f0f0"], NSFontAttributeName : [UIFont systemFontOfSize:12]} forState:UIControlStateNormal];

        nav1.tabBarItem.image = [UIImage imageNamed:@"home_night"];
        nav2.tabBarItem.image = [UIImage imageNamed:@"quote_night"];
        nav3.tabBarItem.image = [UIImage imageNamed:@"trade_night"];
        nav4.tabBarItem.image = [UIImage imageNamed:@"news_night"];
        self.tabBar.backgroundImage = [IBGlobalMethod imageWithColor:[UIColor colorWithHexString:@"#323232"] size:CGSizeMake(ScreenWidth, NavBarHeight)];
        self.tabBar.shadowImage = [IBGlobalMethod imageWithColor:[UIColor colorWithHexString:@"#323232"] size:CGSizeMake(ScreenWidth, NavBarHeight)];

    }


    if ([m_tabBarIconsDic allKeys].count>0) {
//        [self updateTabLogo];
    }
}








#pragma mark - getter and setter

//首页
@synthesize homeMainNavController = _homeMainNavController;
-(UINavigationController *)homeMainNavController {
    if (nil == _homeMainNavController) {
//        UIViewController * controller = [[UIStoryboard storyboardWithName:@"HomeMain" bundle:nil] instantiateViewControllerWithIdentifier:@"IBHomeMainViewController"];
        IBHomeViewController * controller = [[IBHomeViewController alloc] init];
     _homeMainNavController =   [[IBBaseNavController alloc] initWithRootViewController:controller];
    
        _homeMainNavController.tabBarItem.title = CustomLocalizedString(@"TABBAR_HOME_PAGE", nil);
        
        if ([self.dk_manager.themeVersion isEqualToString:@"NORMAL"] || [self.dk_manager.themeVersion isEqualToString:@""]) {
            [self setImage:[UIImage imageNamed:@"home_icon"]  andSelectedImage:[UIImage imageNamed:@"home_selected"] toNavigationController:_homeMainNavController withTheme:@"NORMAL"];
        }else if ([self.dk_manager.themeVersion isEqualToString:@"NIGHT"]) {
            [self setImage:[UIImage imageNamed:@"home_night"]  andSelectedImage:[UIImage imageNamed:@"home_selected"] toNavigationController:_homeMainNavController withTheme:@"NIGHT"];
        }else {
            [self setImage:[UIImage imageNamed:@"home_icon"]  andSelectedImage:[UIImage imageNamed:@"home_selected"] toNavigationController:_homeMainNavController withTheme:@"NIGHT"];
        }
    }
    return _homeMainNavController;
}


//行情
@synthesize quoteMainNavController = _quoteMainNavController;
-(UINavigationController *)quoteMainNavController
{
    if (nil == _quoteMainNavController)
    {
//       self.quotemainVC = [[QuoteMainViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        IBQuoteViewController * controller = [[IBQuoteViewController alloc] init];
        _quoteMainNavController = [[IBBaseNavController alloc] initWithRootViewController:controller];
        _quoteMainNavController.tabBarItem.title = CustomLocalizedString(@"TABBAR_QUOTE", nil);
        if ([self.dk_manager.themeVersion isEqualToString:@"NORMAL"] || [self.dk_manager.themeVersion isEqualToString:@""]) {
           
            [self setImage:[UIImage imageNamed:@"quote_icon"] andSelectedImage:[UIImage imageNamed:@"quote_selected"] toNavigationController:_quoteMainNavController withTheme:@"NORMAL"];
        }else if ([self.dk_manager.themeVersion isEqualToString:@"NIGHT"]) {
            [self setImage:[UIImage imageNamed:@"quote_night"] andSelectedImage:[UIImage imageNamed:@"quote_selected"] toNavigationController:_quoteMainNavController withTheme:@"NIGHT"];
        }else {
            [self setImage:[UIImage imageNamed:@"quote_icon"] andSelectedImage:[UIImage imageNamed:@"quote_selected"] toNavigationController:_quoteMainNavController withTheme:@"NIGHT"];
        }
        
        
    }
    return _quoteMainNavController;
}

//交易
@synthesize tradeMainNavController = _tradeMainNavController;
-(UINavigationController *)tradeMainNavController
{
    
    if (nil == _tradeMainNavController)
    {
//        IBT_FSuperSliderViewController * controller = [[IBT_FSuperSliderViewController alloc] init];
        IBTradeViewController * controller = [[IBTradeViewController alloc] init];
        _tradeMainNavController = [[IBBaseNavController alloc] initWithRootViewController:controller];
        _tradeMainNavController.tabBarItem.title = CustomLocalizedString(@"TABBAR_TRADE", nil);
       
        if ([self.dk_manager.themeVersion isEqualToString:@"NORMAL"] || [self.dk_manager.themeVersion isEqualToString:@""]) {
            [self setImage:[UIImage imageNamed:@"trade_icon"] andSelectedImage:[UIImage imageNamed:@"trade_selected"] toNavigationController:_tradeMainNavController withTheme:@"NORMAL"];
        }else if ([self.dk_manager.themeVersion isEqualToString:@"NIGHT"]) {
            [self setImage:[UIImage imageNamed:@"trade_night"] andSelectedImage:[UIImage imageNamed:@"trade_selected"] toNavigationController:_tradeMainNavController withTheme:@"NIGHT"];
        }else {
            [self setImage:[UIImage imageNamed:@"trade_icon"] andSelectedImage:[UIImage imageNamed:@"trade_selected"] toNavigationController:_tradeMainNavController withTheme:@"NIGHT"];
        }
        
    }
    return _tradeMainNavController;
}


//资讯
@synthesize inforMainNavController = _inforMainNavController;
-(UINavigationController *)inforMainNavController
{
    if (nil == _inforMainNavController)
    {
//        IBInformationFatherViewController *controller = [[UIStoryboard storyboardWithName:@"Information" bundle:nil] instantiateViewControllerWithIdentifier:@"IBInformationFatherViewController"];
        IBNewsViewController * controller = [[IBNewsViewController alloc] init];
        _inforMainNavController = [[IBBaseNavController alloc] initWithRootViewController:controller];
        _inforMainNavController.tabBarItem.title = CustomLocalizedString(@"TABBAR_MESSAGE", nil);
       
        if ([self.dk_manager.themeVersion isEqualToString:@"NORMAL"] || [self.dk_manager.themeVersion isEqualToString:@""]) {
            [self setImage:[UIImage imageNamed:@"news_icon"] andSelectedImage:[UIImage imageNamed:@"news_selected"] toNavigationController:_inforMainNavController withTheme:@"NORMAL"];
        }else if ([self.dk_manager.themeVersion isEqualToString:@"NIGHT"]) {
            [self setImage:[UIImage imageNamed:@"news_night"] andSelectedImage:[UIImage imageNamed:@"news_selected"] toNavigationController:_inforMainNavController withTheme:@"NIGHT"];
        }else {
            [self setImage:[UIImage imageNamed:@"news_icon"] andSelectedImage:[UIImage imageNamed:@"news_selected"] toNavigationController:_inforMainNavController withTheme:@"NIGHT"];
        }
        
    }
    return _inforMainNavController;
}




//投资理财
//@synthesize financingNavController = _financingNavController;
//-(UINavigationController *)financingNavController
//{
//    if (nil == _financingNavController)
//    {
//         self.financingMainVC = [[IBFinancingMainViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
//        _financingNavController = [[QNBaseNavController alloc] initWithRootViewController:self.financingMainVC];
//        _financingNavController.tabBarItem.title = CustomLocalizedString(@"TABBAR_FINANCING", nil);
//
//        if ([self.dk_manager.themeVersion isEqualToString:@"NORMAL"] || [self.dk_manager.themeVersion isEqualToString:@""]) {
//            [self setImage:[UIImage imageNamed:@"finance_icon"] andSelectedImage:[UIImage imageNamed:@"finance_selected"] toNavigationController:_financingNavController withTheme:@"NORMAL"];
//        }else if ([self.dk_manager.themeVersion isEqualToString:@"NIGHT"]) {
//            [self setImage:[UIImage imageNamed:@"finance_night"] andSelectedImage:[UIImage imageNamed:@"finance_selected"] toNavigationController:_financingNavController withTheme:@"NIGHT"];
//        }else {
//            [self setImage:[UIImage imageNamed:@"finance_icon"] andSelectedImage:[UIImage imageNamed:@"finance_selected"] toNavigationController:_financingNavController withTheme:@"NORMAL"];
//        }
//    }
//    return _financingNavController;
//}

#pragma mark - 导航控制器相关(private)
-(NSDictionary*)navTextAttributesWithState:(UIControlState)state
{
    if(UIControlStateSelected == state)
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName,[UIColor colorWithHexString:@"#fc6131"],NSForegroundColorAttributeName,nil];
    }
    else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName,[UIColor colorWithHexString:@"#666666"],NSForegroundColorAttributeName,nil];
    }
}

-(void)setImage:(nonnull UIImage*)normalImage andSelectedImage:(nonnull UIImage*)selectedImage toNavigationController:(nonnull UINavigationController*)navController withTheme:(NSString *)theme
{
    //设置tabBar标签栏颜色和字体
    [navController.tabBarItem setTitleTextAttributes:[self navTextAttributesWithState:UIControlStateNormal] forState:UIControlStateNormal];
    [navController.tabBarItem setTitleTextAttributes:[self navTextAttributesWithState:UIControlStateSelected]forState:UIControlStateSelected];

    UIOffset offset=navController.tabBarItem.titlePositionAdjustment;
    offset.vertical= 1;
    [navController.tabBarItem setTitlePositionAdjustment:offset];

    //设置导航栏颜色和字体
    
    navController.tabBarItem.image=[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navController.tabBarItem.selectedImage=[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if ([theme isEqualToString:@"NORMAL"]) {
        [navController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#666666"], NSFontAttributeName : [UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
    }else if ([theme isEqualToString:@"NIGHT"]) {
        [navController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#cccccc"], NSFontAttributeName : [UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
     
    }else {
        [navController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#cccccc"], NSFontAttributeName : [UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
    }
    
}

//@dynamic subVcIndex;
//-(void)setSubVcIndex:(CGFloat)subVcIndex
//{
//    self.quotemainVC.vcselectIndex = subVcIndex;
//}
//
//-(void)setFinacingIndex:(NSInteger)finacingIndex {
//    self.financingMainVC.financingselectIndex = finacingIndex;
//}




- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
//    if (self.selectedIndex == 2 ) {
//        if (![IBGlobalMethod isTradeLogined]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"s_PopToTradeHome" object:nil userInfo:@{@"type" : [@(1) stringValue]}];
//        }else {
//            ///发送通知重新获取持仓和首页数据
//            [[NSNotificationCenter defaultCenter] postNotificationName:TouchTabSwitchToTradeHome object:nil];
//        }
//    }
}










@end
