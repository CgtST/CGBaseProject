//
//  IBHomeMainViewController.m
//  QNApp
//
//  Created by xboker on 2017/4/20.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBHomeMainViewController.h"
#import "CDTImageTools.h"
#import <JLRoutes.h>


#import "QNBaseNavController.h"
#import "IBT_FSuperSliderViewController.h"
#import "IBRootTabBarViewController.h"
#import "IBMineViewController.h"
#import "IBSearchStockViewController.h"
#import "IBMessageCenterViewController.h"
//#import "IBFastRegistViewController.h"
#import "QNQuoteLineViewController.h"
#import "IBCustomWKWebViewController.h"
#import "IBQNewsDetailViewController.h"
#import "IBTradeBusinessNewStockBuyFatherViewController.h"
#import "IBTradeOpenAccountGuideController.h"
#import "IBInformationDetailViewController.h"
#import "IBMyPropertyViewController.h"


#import "IBOptionPlistSingleton.h"
#import "IBSaveOptionalStockIdData.h"
#import "QNAppDelegate.h"
#import "IBHomeMainModel.h"
#import "QNOptionalStock.h"



#import "IBHomeMainHeader.h"
#import "IBCustomView.h"
#import "IBHomeTurnHeader.h"

//#import "IBTradeHomeSectionView.h"
#import "QNOptionalTableViewCell.h"
#import "IBNonOptionalTableViewCell.h"
#import "IBMarkeActiveTableViewCell.h"
#import "IBOptionalTitleTableViewCell.h"
#import "IBFundDetailTableViewCell.h"
#import "IBInfoContentTableViewCell.h"
#import "IBHomeMainAddStockCell.h"
#import "IBTopLabel.h"

#import "IBXHelpers.h"
#import <MJRefresh.h>
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
//#import "UIViewController+IBXNavigationExtension.h"

#import "IBTradeDealDetailViewController.h"
#import "IBTradeLoginViewController.h"
#import "IBBusinessViewController.h"

#import "IBInformationDetailViewController.h"
#import "IBCustomLoginView.h"
#import "IBTradeLoginModle.h"
#import "LeftGuideHaveArrow.h"
#import "QNAppDelegate.h"
#import "IBRootTabBarViewController.h"
#import "IBFXOpenAccountController.h"


#import "RightGuideHaveArrow.h"
#import "IBHomeBtnLogoReq.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "IBNoNetView.h"
#import "IBNoNetWorkViewController.h"
#import "IBParaWebViewController.h"




#define KAssertIds  @[@"00665.HK",@"06837.HK",@"HSI.IDX.HK"] //海通证券 海通国际 恒生指数，

static void *TableViewScroll                            = &TableViewScroll;
static NSString *const s_DisAddSelfChooseStock          = @"QNOptionalTableViewCell";///展示三个自选股
static NSString *const s_AddSelfChooseStock             = @"IBNonOptionalTableViewCell";///展示添加自选股
//static NSString *const s_MarketActivity                 = @"IBMarkeActiveTableViewCell";///市场动态
static NSString *const s_SelfChooseStockTitle           = @"IBOptionalTitleTableViewCell";///展示三个自选股上面的title
static NSString *const s_MarketActivity                 = @"IBInfoContentTableViewCell";///市场动态的cell


typedef NS_ENUM(NSUInteger , IBGotoType)
{
    IBGotoTypeTradeVC,  //把价格带到交易里面
    IBGotoTypeNewStockSub  //去新股申购
};


//#define k_TurnHeaderHeight      190
#define k_TurnHeaderHeight      ScreenWidth * 0.5 


@interface IBHomeMainViewController ()<UITableViewDelegate, UITableViewDataSource, IBHomeMainHeaderDelegate, IBCustomViewDelegate, UIScrollViewDelegate, IBHomeTurnHeaderDelegate,  IBHomeMainModelDelegate, IBOptionalTitleTableViewCellDelegate,QNOptionalTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView            *m_TableView;
@property (weak, nonatomic) IBOutlet IBHomeMainHeader       *m_Header;
@property (nonatomic, strong) IBCustomView                  *m_FadeView;
@property (weak, nonatomic) IBOutlet IBHomeTurnHeader       *m_TurnHeader;
@property (nonatomic,strong) IBHomeBtnLogoReq * btnLogReq;
@property (nonatomic, strong) IBHomeMainModel               *m_MyRequest;
@property (nonatomic, strong) NSMutableArray                *optionalStocks;
@property (nonatomic, assign) BOOL                          fromBackground;
@property (nonatomic, strong) UIImageView                   *m_BigImage;
@property (nonatomic, strong) IBCustomWKWebViewController   *m_WebView;
@property (nonatomic, assign) CGFloat                       m_LastOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *m_HeaderDistance;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTopOffset;

@property (nonatomic,strong)QNStock * tradeUserStock;
@property (nonatomic) BOOL bshowFirst;

@property (nonatomic,strong) IBNoNetView * noNetView;
@property (nonatomic) IBGotoType gotoType;

///是否是此界面创建时刻
@property (nonatomic, assign) BOOL                          m_FirstLaunch;
///自选股变化, 增,删,调整顺序
@property (nonatomic, assign) BOOL                          m_OptionalStockChange;


#pragma mark    资讯三合一以下预废弃
@property (nonatomic, assign)  NSInteger                    m_SelectIndex;
//@property (nonatomic, strong) IBTradeHomeSectionView        *m_QueryHeader;

@end



@implementation IBHomeMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    if (IS_iPhoneX) {
        self.tableTopOffset.constant = -44;
    }else {
        self.tableTopOffset.constant = -20;
    }
    
    self.m_FirstLaunch = YES;
    self.m_OptionalStockChange = YES;

    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BackBottemColor);
    self.m_Header.dk_backgroundColorPicker = DKColorPickerWithKey(QContentColor);
    self.m_TableView.dk_backgroundColorPicker = DKColorPickerWithKey(BackBottemColor);
    
    self.m_TableView.delaysContentTouches = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view bringSubviewToFront:self.m_FadeView];
    self.m_LastOffset = 0;
    [self.view addSubview:self.m_BigImage];
    [self.view addSubview:self.m_FadeView];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.translucent = YES;
    [self.m_TableView registerNib:[UINib nibWithNibName:@"IBMarkeActiveTableViewCell" bundle:nil] forCellReuseIdentifier:@"IBMarkeActiveTableViewCell"];
    [self.m_TableView registerNib:[UINib nibWithNibName:@"IBInfoContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"IBInfoContentTableViewCell"];

    WEAKSELF
    [self showRequestActivityProgressToView:self.view];
    [self.m_MyRequest getSelfChooseStockAction];
    [self.m_MyRequest getTurnImageActionWithView:self.view];
    [self.m_MyRequest getChoicenessInformationWithView:self.view withType:HomeMainModelGetDataTypeDefault];
    self.m_TableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf showRequestActivityProgressToView:weakSelf.view];
        [weakSelf.m_MyRequest getChoicenessInformationWithView:weakSelf.view withType:HomeMainModelGetDataTypeRefresh];
        [weakSelf.m_MyRequest getTurnImageActionWithView:weakSelf.view];
//        if (weakSelf.m_MyRequest.m_TurnImageArr.count < 1) {
//            [weakSelf.m_MyRequest getTurnImageActionWithView:weakSelf.view];
//        }else {
//            if ([weakSelf.m_MyRequest.m_TurnImageArr.firstObject isKindOfClass:[UIImage class]]) {
//                [weakSelf.m_MyRequest getTurnImageActionWithView:weakSelf.view];
//            }
//        }
    }];
    self.m_TableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf showRequestActivityProgressToView:weakSelf.view];
        [weakSelf.m_MyRequest getChoicenessInformationWithView:weakSelf.view withType:HomeMainModelGetDataTypeLoadMore];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(realTimeStocksUpdate:) name:kOptional_Stock_Real_Time_Quotes object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketConnectHost:) name:kSocket_Reconnect object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quoteLoginAction:) name:kIBNotify_Login_Success object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemMessageComing:) name:RemoteMessageComing object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(optionalStockChanged:) name:OptionalStockChanged object:nil];
    [self reqBtnLogoData];

    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleNetWorkChangeNotify:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguageNoty) name:KIBNotify_ChangLanguage_Success object:nil];
}


- (void)changeLanguageNoty{
    if (self.isViewLoaded && !self.view.window) {
        //这里置为nil，当视图再次显示的时候会重新走viewDidLoad方法
//        self.view = nil;
        self.m_Header = nil;
        self.m_TurnHeader = nil;
        self.view = nil;
//        [self.m_TableView reloadData];
    }
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    if (@available(iOS 11.0, *)) {
        self.m_TableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - 展示新手操作指引
-(void)appIsFirstRun {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:OperationGuide_Home1] == NO && [[NSUserDefaults standardUserDefaults] boolForKey:OperationGuide_Home2] == YES) {
        [LeftGuideHaveArrow showViewWithFrame:CGRectMake(0, 30, 60, 60)withType:ShowTypeHome withBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [RightGuideHaveArrow showViewWithFrame:CGRectMake(ScreenWidth - 60, 0, 60, 60) withType:RightShowTypeHomeMessage withBlock:nil];
            });
        }];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:OperationGuide_Home1];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}

#pragma mark    自选股进行了编辑
- (void)optionalStockChanged:(NSNotification *)sender {
    self.m_OptionalStockChange = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    // Dispose of any resources that can be recreated.
}


#pragma mark    obbserMethod
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context {
    WEAKSELF
    if (context == TableViewScroll) {
        CGPoint point = self.m_TableView.contentOffset;
        if (point.y >= 0 && point.y <= k_TurnHeaderHeight) {
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.m_BigImage.frame =  CGRectMake(0, 0, ScreenWidth, k_TurnHeaderHeight);
            } completion:^(BOOL finished) {
                weakSelf.m_BigImage.hidden = YES;
            }];
        }else if (point.y > k_TurnHeaderHeight ) {
            self.m_BigImage.hidden = YES;
        }else {
            self.m_BigImage.hidden = NO;
                if (self.m_MyRequest.m_TurnImageArr.count) {
                    id turnImage = self.m_MyRequest.m_TurnImageArr[self.m_TurnHeader.offsetX];
                    if ([turnImage isKindOfClass:[NSDictionary class]]) {
                        NSString *image = turnImage[@"headimg"];
                        if (image.length) {
                            [self.m_BigImage setImageWithURL:[NSURL URLWithString:turnImage[@"headimg"]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                        }
                    }else {
                        self.m_BigImage.image = turnImage;
                    }
                }
            self.m_BigImage.frame = CGRectMake(0, 0, ScreenWidth, k_TurnHeaderHeight - point.y);
        }
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    WEAKSELF
    self.hidesBottomBarWhenPushed = NO;
    HConversation *conversation = [[HChatClient sharedClient].chat getConversation:HXKF_IM_SERVER_NUM];
    NSUInteger count = conversation.unreadMessagesCount + ibMsgHandler().systemUnReadMessageCount;
    [self.m_FadeView layoutTheImagesWithCount:count];
    
    [self.m_TurnHeader activeTheTimer];
    dispatch_async(dispatch_get_main_queue(), ^{
//        weakSelf.m_HeaderDistance.constant = -weakSelf.m_LastOffset - 20;
        weakSelf.m_HeaderDistance.constant = -weakSelf.m_LastOffset - 0;
    });
    
    if (self.m_FirstLaunch) {
        self.m_FirstLaunch = NO;
    }else {
        ///如果自选股进行了编辑, 则重新获取自选股及盘口数据, 否则直接走订阅逻辑
        if (self.m_OptionalStockChange) {
            ///从单例里面获取自选股数据
            [self.m_MyRequest getSelfChooseStockViewWillAppear];
            self.m_OptionalStockChange = NO;
        }else {
//            ///订阅推送
//            [self subscribeCurrentStocks];
            ///每次界面出现重新获取盘口数据
            [self fetchOptionalStockMtkInfo];
            
            
        }
    }
    
    ///获取系统未读消息和客服未读消息
    [self.m_MyRequest getUnreadMessageActionWithView:self.view];
    //app是否是第一次启动
    [self appIsFirstRun];
    NSLog(@"界面出现了,获取盘口数据, 然后根据levlel2推送..............");
     [self.m_TableView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.m_TurnHeader invalidateTheTimer];
    self.m_LastOffset = self.m_TableView.contentOffset.y;
// 取消所有订阅
    if (self.optionalStocks.count) {
        [self unsubcribePushWithAssetIds:self.optionalStocks all:YES];
        NSLog(@"界面即将消失,取消所有推送..............");
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.m_TableView addObserver:self forKeyPath:@"contentOffset" options:0x01 | 0x02 context:TableViewScroll];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.m_TableView removeObserver:self forKeyPath:@"contentOffset"];
}


#pragma mark   tableView代理 UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0  ) {
        if (self.optionalStocks.count) {
            return 1 + (self.optionalStocks.count>3?3:self.optionalStocks.count);
        }else {
            return 2;
        }
    }else {
        return self.m_MyRequest.m_InformationArr.count;
//        if (self.m_SelectIndex == 0) {
//            return self.m_MyRequest.m_MarketActivityArr.count;
//        }else if (self.m_SelectIndex == 1) {
//            return self.m_MyRequest.m_PropertyMessageArr.count ;
//        }else {
//            return self.m_MyRequest.m_StockLevelArr.count;
//        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//----section1
        if(indexPath.row == 0) {///添加自选股cell上的titlecell
            IBOptionalTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:s_SelfChooseStockTitle];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"IBOptionalTitleTableViewCell" owner:nil options:nil].lastObject;//此处会crash add by chargo
            }
            cell.delegate = self;
//            tableView.rowHeight = 45;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else {
            if (self.optionalStocks.count) {///有自选股, 显示自选股
                QNOptionalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:s_DisAddSelfChooseStock];
                if(nil == cell){
                    cell = [[QNOptionalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:s_DisAddSelfChooseStock cellHeight:55 showIcon:YES];

                }
                if (self.optionalStocks.count>0) {
                    QNOptionalStock *optionalStock = self.optionalStocks[indexPath.row-1];
                    cell.stock = optionalStock;
                     cell.delegate = self;
                  cell.balwaysShowPercent = YES;
                }
//                tableView.rowHeight = 55;
                return cell;
            }else {///没有自选股, 显示添加自选股cell
                IBHomeMainAddStockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IBHomeMainAddStockCell" forIndexPath:indexPath];
//                tableView.rowHeight = 120;
                return cell;
            }
        }
    }else {//-----section2
//        tableView.rowHeight = 100;
        IBMarkeActiveTableViewCell *cell= [IBMarkeActiveTableViewCell shareCellWithTableView:tableView];
        [cell displayChoicenessInformationCellWithData :self.m_MyRequest.m_InformationArr withIndexPath:indexPath withIsReadedArr:self.m_MyRequest.m_ReadedNewsArr];
        return cell;
//        if (self.m_SelectIndex == 0) {///市场动态
//            IBMarkeActiveTableViewCell *cell= [IBMarkeActiveTableViewCell shareCellWithTableView:tableView];
//            [cell displayMarketActitvityCellWithData:self.m_MyRequest.m_MarketActivityArr withIndexPath:indexPath withIsReadedArr:self.m_MyRequest.m_ReadedNewsArr];
//            return cell;
//        }else if (self.m_SelectIndex == 1) {///财富百科
//            IBMarkeActiveTableViewCell *cell= [IBMarkeActiveTableViewCell shareCellWithTableView:tableView];
//            [cell displayPropertyCellWithData:self.m_MyRequest.m_PropertyMessageArr withIndexPath:indexPath withIsReadedArr:self.m_MyRequest.m_ReadedNewsArr];
//            return cell;
//        }else {///股票评级
//            IBInfoContentTableViewCell *cell = [IBInfoContentTableViewCell shareCellWithTableView:tableView withType:InformationChangeThemeChange];
//            [cell displayCellWithData:self.m_MyRequest.m_StockLevelArr withIndexpath:indexPath withIsReadArr:self.m_MyRequest.m_ReadedNewsArr];
//            return cell;
//        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if(indexPath.row == 0) {
            return 45;
        }
        if (self.optionalStocks.count) {
            return 55;
        }else {
            return 120;
        }
    }else {
        return 100;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
//        return self.m_QueryHeader;
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(31, 0, ScreenWidth - 15, 45)];
        UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(15, 15, 6, 15)];
        leftV.layer.masksToBounds = YES;
        leftV.layer.cornerRadius  = 3;
        leftV.backgroundColor = [UIColor colorWithHexString:@"#FF5F5F"];
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(ScreenWidth - 12 - 30, 0, 30, 45);
        [rightBtn setImage:[UIImage imageNamed:@"ib_more"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(goToMessageTab:) forControlEvents:UIControlEventAllEvents];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, 1)];
        lineView.dk_backgroundColorPicker = DKColorPickerWithKey(SeperateLine);
        
        
        v.dk_backgroundColorPicker = DKColorPickerWithKey(QContentColor);
        lb.textColor = [UIColor colorWithHexString:@"#666666"];
        lb.font = [UIFont systemFontOfSize:15];
        lb.textAlignment = NSTextAlignmentLeft;
        lb.text = CustomLocalizedString(@"FX_BU_REMENZIXUN", nil);
        [v addSubview:leftV];
        [v addSubview:lb];
        [v addSubview:rightBtn];
        [v addSubview:lineView];
        return v;
    }else {
        UIView *v = [[UIView alloc] init];
        v.dk_backgroundColorPicker = DKColorPickerWithKey(BackBottemColor);
        return v;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0? 7 : 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *v = [[UIView alloc] init];
        v.dk_backgroundColorPicker = DKColorPickerWithKey(BackBottemColor);

        return v;
    }else {
        return [[UIView alloc] init];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 7;
    }
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([IBXHelpers getNetWorkStatus] == 0) {
        [IBXHelpers checkTheNetWorkStatus];
        return;
    }
    if (indexPath.section == 0) {
        if (self.optionalStocks.count<1) {
            if (indexPath.row == 0) {
                return;
            }
            IBSearchStockViewController * searchVC = [[IBSearchStockViewController alloc] init];
//            QNBaseNavController * nav = [[QNBaseNavController alloc] initWithRootViewController:searchVC];
//            [self.navigationController presentViewController:nav animated:YES completion:nil];
            searchVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:searchVC animated:YES];
    
        }else {
            if (indexPath.row == 0) {
                return;
            }
             NSMutableArray * mutArr = [NSMutableArray array];
            for (int i=0; i<self.optionalStocks.count; i++)
            {
                QNOptionalStock * optionalStock =  self.optionalStocks[i];
                QNStock *stock = [[QNStock alloc] init];
                stock.ID = optionalStock.assetId;
                stock.name = optionalStock.name;
                stock.stype = optionalStock.sType;
                 [mutArr addObject:stock];
            }
            QNQuoteLineViewController *lineVC = [[QNQuoteLineViewController alloc] initWithGroupName:nil  stocks:[mutArr copy] currentPage:indexPath.row-1];
            lineVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:lineVC animated:YES];
        }
    }else {
        NSDictionary *dic = self.m_MyRequest.m_InformationArr[indexPath.row];
        NSString *url = [IBXHelpers getStringWithDictionary:dic andForKey:@"url"];
        if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {///webview加载
            IBCustomWKWebViewController *webC = [[IBCustomWKWebViewController alloc] init];
//            webC.m_LoadUrl = url;
            webC.m_MessageDic = dic;
            webC.m_LoadType = CustomWKWebViewTypeChoicenessInformation;
            webC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webC animated:YES];
        }else {///详情页加载
            IBInformationDetailViewController *detailVC = [[IBInformationDetailViewController alloc] init];
            detailVC.m_Type = InformationDetailType_ZiXun_XinWen;
            NSDictionary *dic = self.m_MyRequest.m_InformationArr[indexPath.row];
            detailVC.m_Para = dic;
            detailVC.m_TypeStr = @"8";
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
//        IBMarkeActiveTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//         cell.m_Des.textColor = [UIColor colorWithHexString:@"#999999"];


        
//        if (self.m_SelectIndex == 1) {///财富百科
//            NSDictionary *dic = self.m_MyRequest.m_PropertyMessageArr[indexPath.row];
//            NSString *url = [IBXHelpers getStringWithDictionary:dic andForKey:@"url"];
//            IBCustomWKWebViewController *webC = [[IBCustomWKWebViewController alloc] init];
//            webC.m_LoadUrl = url;
//            webC.m_LoadType = CustomWKWebViewTypeCaiFuZiXun;
//            webC.hidesBottomBarWhenPushed = YES;
//
//            [self.navigationController pushViewController:webC animated:YES];
//        }else if (self.m_SelectIndex == 0) {///市场动态
//            IBMarkeActiveTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            cell.m_Des.textColor = [UIColor colorWithHexString:@"#999999"];
//            IBInformationDetailViewController *detailVC = [[IBInformationDetailViewController alloc] init];
//            detailVC.m_Type = InformationDetailTypeMessage;
//            NSDictionary *dic = self.m_MyRequest.m_MarketActivityArr[indexPath.row];
//            detailVC.m_Para = dic;
//            detailVC.m_TypeStr = @"9";
//            detailVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:detailVC animated:YES];
//        }else {///股票评级
////          IBMarkeActiveTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
////          cell.m_Des.textColor = [UIColor colorWithHexString:@"#999999"];
//            IBInformationDetailViewController *detailVC = [[IBInformationDetailViewController alloc] init];
//            detailVC.m_Type = InformationDetailTypeMessage;
//            NSDictionary *dic = self.m_MyRequest.m_StockLevelArr[indexPath.row];
//            detailVC.m_Para = dic;
//            detailVC.m_TypeStr = @"8";
//            detailVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:detailVC animated:YES];
//        }
    }
}


- (void)goToMessageTab:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:HomeJumpToMarketInfor object:nil];
    IBRootTabBarViewController * rootTabbar = App().rootTabbarVC;
    rootTabbar.selectedIndex = 3;
    
}


#pragma mark       - QNOptionalTableViewCellDelegate
- (void)optionalTableViewCell:(QNOptionalTableViewCell *)cell didChangeOptionStockDisplayTypeWithStock:(QNOptionalStock *)stock {
    for (QNOptionalStock *optionalStock in self.optionalStocks)  {
        if (optionalStock != stock) {
            optionalStock.displayType = stock.displayType;
        }
    }
}


#pragma mark   点击价格时快速交易   - QNOptionalTableViewCellDelegate
-(void)optionalTableViewCellClickPrice:(QNOptionalStock *)stock {
    WEAKSELF
    _tradeUserStock = [IBGlobalMethod changeQnOptionStock:stock];
    
    if([IBTheme() getOptitionToTradeFlag] == NO) {
        NSMutableArray * mutArr = [NSMutableArray array];
        for (int i=0; i<self.optionalStocks.count; i++) {
            QNOptionalStock *optionalStock = self.optionalStocks[i];
            if ([IBGlobalMethod changeStringWithId: optionalStock.sType].length == 0) {
                return;
            }
            QNStock *stock = [[QNStock alloc] init];
            stock.ID = optionalStock.assetId;
            stock.name = optionalStock.name;
            stock.stype = optionalStock.sType;
            [mutArr addObject:stock];
        }
         NSUInteger currentPage = [self.optionalStocks indexOfObject:stock];
        QNQuoteLineViewController *lineVC = [[QNQuoteLineViewController alloc] initWithGroupName:nil  stocks:[mutArr copy] currentPage:currentPage];
        lineVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lineVC animated:YES];
        return;
    }
    
    //如果是指数跳行情
    if ([[NSString stringWithFormat:@"%@", stock.sType] isEqualToString:@"4"]) {
        QNQuoteLineViewController *lineVC = [[QNQuoteLineViewController alloc] initWithGroupName:nil  stocks:@[_tradeUserStock] currentPage:0];
        lineVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lineVC animated:YES];
        return;
    }
    
    
    if ([IBGlobalMethod isLogin] == NO) {
        [IBViewControllerHelp showLoginRegistControllerWithBTradeLogin:IBQTLoginTypeTLoginHandle];
        self.gotoType = IBGotoTypeTradeVC;
        return;
    }
    if([IBGlobalMethod isTradeLogined] == NO)
    {
        if ( [IBGlobalMethod getTradeAccountId].length > 2 ) {///iBEST已经登录, 并且已经绑定了交易账号
            IBTradeLoginViewController * tradeVC = [[IBTradeLoginViewController alloc]initWithNibName:@"IBTradeLoginViewController" bundle:nil];
            [tradeVC loginSuccessWithBlock:^(BOOL success, NSString *inftorType) {
                if (success) {
                    IBTradeDealDetailViewController * buysaleVC = [[UIStoryboard storyboardWithName:@"TradeDeal" bundle:nil] instantiateViewControllerWithIdentifier:@"IBTradeDealDetailViewController"];
                    buysaleVC.m_Stock = _tradeUserStock;
                    buysaleVC.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:buysaleVC animated:YES];
                }
            }];
            [self presentViewController:tradeVC animated:YES completion:nil];
        }else {///iBEST已经登录, 但是没有绑定交易账号
            IBTradeOpenAccountGuideController  *openC = [[UIStoryboard storyboardWithName:@"TradeMain" bundle:nil] instantiateViewControllerWithIdentifier:@"IBTradeOpenAccountGuideController"];
            openC.m_Type = TradeOpenAccountGuideType_StockDeal;
            openC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:openC animated:YES];
        }
        return;
    }
    IBTradeDealDetailViewController * buysaleVC = [[UIStoryboard storyboardWithName:@"TradeDeal" bundle:nil] instantiateViewControllerWithIdentifier:@"IBTradeDealDetailViewController"];
      buysaleVC.m_Stock =_tradeUserStock;
    buysaleVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:buysaleVC animated:YES];
}




#pragma mark  scrollview 的代理   UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    NSLog(@"%lf........",scrollView.contentOffset.y);
    [self.m_FadeView ibTransferOffset:scrollView.contentOffset.y];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.m_LastOffset = scrollView.contentOffset.y;
    [self.m_FadeView ibLastOffset:scrollView.contentOffset.y];
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0) {
    [self.m_FadeView ibLastOffset:scrollView.contentOffset.y];
    
}


#pragma mark   点击切换到添加自选股界面   IBOptionalTitleTableViewCellDelegate
-(void)clickButtonActionGotoOptionStock:(id)sender {
    IBRootTabBarViewController * rootTabbar = App().rootTabbarVC;
    rootTabbar.selectedIndex = 1;
    rootTabbar.subVcIndex = 0;
}

#pragma mark 不同的业务办理区头   IBHomeMainHeaderDelegate
- (void)ibHomeMainHeaderTapWithType:(HomeMainHeaderTapType)type {
    if ([IBXHelpers getNetWorkStatus] == 0) {
        [IBXHelpers checkTheNetWorkStatus];
        return;
    }
    switch (type) {
        case HomeMainHeaderTapTypeZiXuanGu: {///自选股
            IBRootTabBarViewController * rootTabbar = App().rootTabbarVC;
            rootTabbar.selectedIndex = 1;
            rootTabbar.subVcIndex = 0;
            break;
        }
        case HomeMainHeaderTapTypeYeWuBanLi: {///业务办理
            IBBusinessViewController *businessVC = [[IBBusinessViewController alloc]initWithNibName:@"IBBusinessViewController" bundle:nil];
            businessVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:businessVC animated:YES];
            break;
        }
        case HomeMainHeaderTapTypeJiJinMaiMai: {///我的资产
            if ([IBGlobalMethod isLogin]) {
                if ([IBGlobalMethod isTradeLogined]) {
                    IBMyPropertyViewController *propertyVC = [[UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"IBMyPropertyViewController"];
                    propertyVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:propertyVC animated:YES];
                }else {///需要判断是否绑定交易账号, 是否已经交易登录的逻辑
                    if ([IBGlobalMethod getTradeAccountId].length > 1) {//说明已经绑定了交易账号, 弹出登录
                        IBTradeLoginViewController *loginV = [[IBTradeLoginViewController alloc] initWithNibName:@"IBTradeLoginViewController" bundle:nil];
                        [loginV loginSuccessWithBlock:^(BOOL success, NSString *inftorType) {}];
                        [self presentViewController:loginV animated:YES completion:nil];
                    }else {//没有绑定交易账号, 引号绑定账号或者开户
                        IBTradeOpenAccountGuideController  *openC = [[UIStoryboard storyboardWithName:@"TradeMain" bundle:nil] instantiateViewControllerWithIdentifier:@"IBTradeOpenAccountGuideController"];
                        openC.m_Type = TradeOpenAccountGuideType_StockDeal;
                        openC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:openC animated:YES];
                    }
                }
            }else {
                [IBViewControllerHelp showLoginRegistControllerWithBTradeLogin:IBQTLoginTypeTLoginHandle];
            }
            break;
        }
        case HomeMainHeaderTapTypeXinGuShenGou: {///新股申购
            self.gotoType = IBGotoTypeNewStockSub;
            [self juadgeGotoNewStockCal];
            break;
        }
        default:
            break;
    }
}

//判断去新股日历
-(void)juadgeGotoNewStockCal {

     [self gotoNewStockCalWithAccountId:nil];

   /* if ([IBGlobalMethod isLogin] == NO) {   //App登录
        [IBViewControllerHelp showLoginRegistControllerWithBTradeLogin:IBQTLoginTypeTLoginHandle];
        return;
    }
    
    if([IBGlobalMethod getTradeAccountId].length>0) {
        NSString * accountid = [IBGlobalMethod  getNewStockReqAccount].length>0?[IBGlobalMethod  getNewStockReqAccount]:@"";
        if([[IBTradeLoginModle alloc] init].TRAC.length>0) {
            accountid = [[IBTradeLoginModle alloc] init].TRAC;
        }
        
        //跳到申购记录中
        if([IBGlobalMethod isTradeLogined] == YES){
            [self gotoNewStockCalWithAccountId:accountid];
        }else{
            IBTradeLoginViewController * tradeVC = [[IBTradeLoginViewController alloc]initWithNibName:@"IBTradeLoginViewController" bundle:nil];
            [tradeVC loginSuccessWithBlock:^(BOOL success, NSString *inftorType) {
                if (success) {
                     [self gotoNewStockCalWithAccountId:[[IBTradeLoginModle alloc] init].TRAC];
                }
            }];
            [self presentViewController:tradeVC animated:YES completion:nil];
        }
    }
    else  {
        IBTradeOpenAccountGuideController  *openC = [[UIStoryboard storyboardWithName:@"TradeMain" bundle:nil] instantiateViewControllerWithIdentifier:@"IBTradeOpenAccountGuideController"];
        openC.hidesBottomBarWhenPushed = YES;
        openC.m_Type = TradeOpenAccountGuideType_StockDeal;
        [self.navigationController pushViewController:openC animated:YES];

    }

        
    }*/

}

//去新股日历
-(void)gotoNewStockCalWithAccountId:(NSString *)accountId {
    IBTradeBusinessNewStockBuyFatherViewController * newStockVC = [[IBTradeBusinessNewStockBuyFatherViewController alloc] init];
//    newStockVC.accountId = accountId;
    newStockVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController  pushViewController:newStockVC animated:YES];
}


#pragma mark   model的所有代理方法 IBHomeMainModelDelegate

///获取未读消息条数
- (void)ibUnReadMessagesSuccessWithCount:(NSInteger )count {
    [self.m_FadeView layoutTheImagesWithCount:count];
}

- (void)ibHomeCustomGetHomeTurnImageSuccessWithInFor:(NSString *)infor {
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.m_TurnHeader headerViewDisplayWithDataSource:self.m_MyRequest.m_TurnImageArr];
        [weakSelf.m_TableView reloadData];
    });
}


- (void)ibHomeCustomGetDataSuccessWithInfor:(NSString *)infor {
    [self hiddenRequestActivityProgressViewWithView:self.view];
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        if (infor.length) {
            [weakSelf showToastWithText:infor style:QNBaseViewControllerToastStyleNormal];
        }
//      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [weakSelf.m_TableView.mj_header endRefreshing];
        [weakSelf.m_TableView.mj_footer endRefreshing];
        [weakSelf.m_TableView reloadData];
    });
}

- (void)ibHomeCustomGetDataFailedWithInfor:(NSString *)infor {
    [self hiddenRequestActivityProgressViewWithView:self.view];

    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        if (infor.length) {
            [weakSelf showToastWithText:infor style:QNBaseViewControllerToastStyleNormal];
        }
//      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [weakSelf.m_TableView.mj_header endRefreshing];
        [weakSelf.m_TableView.mj_footer endRefreshing];
        [weakSelf.m_TableView reloadData];
    });
}

- (void)ibHomeCustomGetSelfChooseStockSuccessStatus:(BOOL)isGet {
    [self hiddenRequestActivityProgressViewWithView:self.view];
    WEAKSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.m_TableView reloadData];
        });
        [self fetchOptionalStockMtkInfo];
}



#pragma mark  轮播图的代理  IBHomeTurnHeaderDelegate

- (void)ibDidSelecetImageWithUrl:(NSDictionary *)paraDic withIndexPath:(NSIndexPath *)path {
    
//    IBFXOpenAccountController * openC = [[IBFXOpenAccountController alloc] initWithType:FXOpenAccount_Openaccount withParaStr:@"hswitness"];
//    openC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:openC animated:YES];
//    return;
    
    
    if ([IBXHelpers getNetWorkStatus] == 0) {
        [IBXHelpers checkTheNetWorkStatus];
        return;
    }
    [MobClick event:@"marketname"];
    NSLog(@"%@_______________当前轮播图的字典集合", paraDic);
    NSString *bigType = [IBXHelpers getStringWithDictionary:paraDic andForKey:@"bigType"];
    if ([bigType isEqualToString:@"URL"]) {//safari打开连接
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:paraDic[@"argi"]]];
    }  else {
        NSString *type = [IBXHelpers getStringWithDictionary:paraDic andForKey:@"a"];
        if ([type isEqualToString:@"CHANGE_TAB"]) {//切换tab分区
            IBRootTabBarViewController * rootTabbar = App().rootTabbarVC;
            NSInteger index = [[IBXHelpers getStringWithDictionary:paraDic andForKey:@"argi"] integerValue];
            if (rootTabbar.viewControllers.count > index) {
                rootTabbar.selectedIndex = index;
            }
        }else if ([type isEqualToString:@"OPEN_PAGE"]) {//打开指定页面
            ///跳转到新股申购
            if ([IBXHelpers getStringWithDictionary:paraDic andForKey:@"IBTradeBusinessNewStockBuyFatherViewController"]) {
                self.gotoType = IBGotoTypeNewStockSub;
                [self juadgeGotoNewStockCal];
            }
        }else if ([type isEqualToString:@"OPEN_URL"]) {///app内部加载url连接
            NSString *url = [IBXHelpers getStringWithDictionary:paraDic andForKey:@"argi"];
            if (url.length) {
                IBCustomWKWebViewController *webC = [[IBCustomWKWebViewController alloc] init];
                webC.m_MessageDic = paraDic;
                webC.m_LoadType = CustomWKWebViewTypeHomeTurnType;
                webC.m_LoadUrl = paraDic[@"argi"];
                webC.m_TitleStr = paraDic[@"headtitle"];
                webC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webC animated:YES];
            }
        }else  if ([type isEqualToString:@"DEEPLINK"]) {//deeplink
            NSString *url = [IBXHelpers getStringWithDictionary:paraDic andForKey:@"argi"];
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }else {
                [[JLRoutes routesForScheme:@"ibest"] routeURL:[NSURL URLWithString:url]];
            }
        }else if ([type isEqualToString:@"AUTH_URL"]){//APP内部展示H5网页内容,并且传入passport参数
            NSString *argi = [IBXHelpers getStringWithDictionary:paraDic andForKey:@"argi"];
            if ([argi isEqualToString:@"openaccount"]) {//开户
                IBFXOpenAccountController * openC = [[IBFXOpenAccountController alloc] initWithType:FXOpenAccount_Openaccount withParaStr:argi];
                openC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:openC animated:YES];
            }else  if ([argi isEqualToString:@"hsopenaccount"]){///恒生开户
                IBFXOpenAccountController * openC = [[IBFXOpenAccountController alloc] initWithType:FXOpenAccount_Hsopenaccount withParaStr:argi];
                openC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:openC animated:YES];
            }else {///见证人
                IBFXOpenAccountController * openC = [[IBFXOpenAccountController alloc] initWithType:FXOpenAccount_Hswitness withParaStr:argi];
                openC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:openC animated:YES];
            }
        }
    }
}



#pragma mark    资讯三合一以下预废弃
#pragma mark  切换分区sectionHeader的代理  IBTradeHomeSectionViewDelegate
- (void)ibTradeHomeSectionHeaderTapWithTag:(NSInteger )tag {
    [self showRequestActivityProgressToView:self.view];

    self.m_SelectIndex = tag;
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.m_MyRequest getDataWithView:self.view withGetDataType:HomeMainModelGetDataTypeDefault withSectionTag:self.m_SelectIndex];
    
}
#pragma mark    资讯三合一以上预废弃


#pragma mark  顶部自定义导航条代理  IBCustomViewDelegate
- (void)ibTapedIBCustomWithtype:(CustomViewTapType)type {
    if (type == CustomViewTapTypeActionPersonCenter) {///个人中心
        IBMineViewController *settingVC = [[IBMineViewController alloc] initWithNibName:NSStringFromClass([IBMineViewController class]) bundle:nil];
        settingVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: settingVC animated:YES];
        
    }else if (type == CustomViewTapTypeActionSearchStock) {///搜索
        IBSearchStockViewController * searchVC = [[IBSearchStockViewController alloc] init];
        searchVC.bshowHistory = YES;
//        QNBaseNavController * nav = [[QNBaseNavController alloc] initWithRootViewController:searchVC];
//        [self.navigationController presentViewController:nav animated:YES completion:nil];
        searchVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:searchVC animated:YES];
    }else {///站内信息
//        if ([IBGlobalMethod isLogin] == NO) {   //App登录
//            [IBViewControllerHelp showLoginRegistControllerWithBTradeLogin:IBQTLoginTypeTLoginHandle];
//            return;
//        }
        IBMessageCenterViewController *msgceterVC = [[IBMessageCenterViewController alloc]initWithNibName:@"IBMessageCenterViewController" bundle:nil];
        msgceterVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:msgceterVC animated:YES];
    }
}



#pragma mark - Notify 通知

- (void)systemMessageComing :(NSNotification *)sender {
    if (self.isViewLoaded && self.view.window) {
        [self.m_FadeView layoutTheImagesWithCount:1];
    }
}

//实时更新
- (void)realTimeStocksUpdate:(NSNotification *)notification {
    NSArray *optinalStockParamsArray = [notification object];
    [self updateCurrentStockDataWithParams:optinalStockParamsArray];
}

- (void)updateCurrentStockDataWithParams:(NSArray *)params {
    [IBOptionPlistSingleton shareIntance].isUpdateOption = YES;
    NSLog(@"%@>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n首页HOME界面     推送回来的数据", params.firstObject);
    for (NSArray *optinalStockParams in params) {
        QNOptionalStock *updateOptionalStock = [[QNOptionalStock alloc] initWithParams:optinalStockParams bDelay:YES];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"assetId = %@",updateOptionalStock.assetId];
        NSArray *optionaStocks = [self.optionalStocks filteredArrayUsingPredicate:predicate];
        if ([optionaStocks count]) {
            QNOptionalStock *resultOptionalStock = optionaStocks[0];
            [resultOptionalStock setupWithParams:optinalStockParams bDelay:YES];
        }
    }
    //WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
//        [weakSelf.m_TableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
//        [weakSelf.m_TableView reloadData];
    });
}

///当从后台直接进入活跃时socket需要冲洗连接
- (void)socketConnectHost:(NSNotification *)notification {
    if (self.isViewLoaded && self.view.window) {
        [self subscribeCurrentStocks];
    }
    
}

- (void)didEnterBackground {
// app后台后关闭订阅
    [self unsubcribePushWithAssetIds:self.optionalStocks all:YES];
    NSLog(@"app进入后台, 关闭推送");
    
    
}

- (void)didBecomeActive {
// app变得活跃时也要订阅
        if ([self isViewLoaded] && self.view.window) {
            [self fetchOptionalStockMtkInfo];
            NSLog(@"app进入活跃, 打开推送");
        }
}


#pragma mark    获取盘口数据
- (void)fetchOptionalStockMtkInfo {
    WEAKSELF
//    QNQuoteManager __weak *weakQuoteManager =  QuoteManager();
    NSUInteger isRealQuote =0;
    if([IBGlobalMethod isLevelTwoQuote] == YES)  {
        isRealQuote  = 0;
    }else{
        isRealQuote = 1;  //延时
    }
    if (self.m_MyRequest.m_SelfChooseStockArr.count == 0) {
        return;
    }
    [self showRequestActivityProgressToView:self.view];
    NSLog(@"\n\n\n\n\n开始获取盘口数据\n\n\n\n\n\n");
    
    //拿到盘口数据
    //请求全部的自选股数据
    [ QuoteManager() fetchPanKouDataWithAssetIds:[[IBOptionPlistSingleton shareIntance] allAssertIds] fields:[QNOptionalStock Fields] isRealQuote:isRealQuote showErrorInView:nil needShowError:NO ignoreCode:nil resultBlock:^(NSArray *responseArray, NSError *error) {
        [weakSelf hiddenRequestActivityProgressViewWithView:weakSelf.view];
        if (responseArray.count > 0) {
            [weakSelf.optionalStocks removeAllObjects];
            for (NSArray *dataArray in responseArray) {
                QNOptionalStock *stock = [[QNOptionalStock alloc] initWithParams:dataArray bDelay:YES];
                [weakSelf.optionalStocks addObject:stock];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.m_TableView reloadData];
            });
            if (self.view.window && [self isViewLoaded]) {
                [weakSelf subscribeCurrentStocks];
            }
        }else {
            [weakSelf showToastWithText:KNetWork_Error style:QNBaseViewControllerToastStyleNormal];
        }
        [weakSelf hiddenRequestActivityProgressViewWithView:weakSelf.view];
    }];
}




//订阅
#pragma mark    订阅操作
- (void)subscribeCurrentStocks{
    if ([IBGlobalMethod isLevelTwoQuote] == NO) {
        return;
    }
    [self subscribePushWithAssetIds:self.m_MyRequest.m_SelfChooseStockArr];
}

- (void)subscribePushWithAssetIds:(NSArray *)assetIds {
    if (!assetIds.count) {
        return;
    }
    QNQuoteManager __weak *weakQuoteManager = QuoteManager();
    QNSocketSingleton __weak *weakSocket = Socket();
    
    if (weakSocket.channelId.length&&[weakSocket isConnected]) {
        [weakQuoteManager subscribeWithAssetIds:[assetIds mutableCopy] chnId:Socket().channelId funIds:@"10" showErrorInView:nil needShowError:NO ignoreCode:nil resultBlock:^(NSDictionary *responseDic, NSError *error) {
            
        }];
    }  
}

//取消订阅
- (void)unsubcribePushWithAssetIds:(NSArray *)assetIds all:(BOOL)all
{
//    if([IBGlobalMethod isLevelTwoQuote] == NO)
//    {
//        return;
//    }
    NSMutableArray *unsubcribeAssetIds = [NSMutableArray array];
    if (!all) {
        if (assetIds.count) {
            [unsubcribeAssetIds addObjectsFromArray:assetIds];
        }else {
            return;
        }
    }
    NSLog(@"首页取消订阅操作_____________________数量%ld>>_________", assetIds.count);

    QNQuoteManager __weak *weakQuoteManager = QuoteManager();
    QNSocketSingleton __weak *weakSocket = Socket();
    NSString *unsubcribeType = all ? @"A" : @"P";
    if (weakSocket.channelId.length) {
        [weakQuoteManager unsubscribeWithAssetIds:[unsubcribeAssetIds mutableCopy] chnId:Socket().channelId funIds:@"10" type:unsubcribeType showErrorInView:nil needShowError:NO ignoreCode:nil resultBlock:^(NSDictionary *responseDic, NSError *error) {
        }];
    }
}

#pragma mark - 通知处理
-(void)quoteLoginAction:(NSNotification *)noty {
    if (![self isViewLoaded] || self.view.window == nil ) {
        return;
    }

  NSDictionary * dict = (NSDictionary *)noty.object;
  NSString * typestring = dict[@"quoteLoginAction"];
    
    if ([typestring isEqualToString:@"1" ]||[typestring isEqualToString:@"3" ]||typestring == nil) {
        [self showRequestActivityProgressToView:self.view];
        [self.m_MyRequest getSelfChooseStockAction];
        return;
    }
    
    if (self.gotoType == IBGotoTypeNewStockSub)  {
        if([IBGlobalMethod getTradeAccountId].length>0 && [IBGlobalMethod isTradeLogined]==YES) {
            //跳到申购记录中
            [self gotoNewStockCalWithAccountId:[IBGlobalMethod getTradeAccountId]];
        }
        else {
            IBTradeOpenAccountGuideController  *openC = [[UIStoryboard storyboardWithName:@"TradeMain" bundle:nil] instantiateViewControllerWithIdentifier:@"IBTradeOpenAccountGuideController"];
            openC.hidesBottomBarWhenPushed = YES;
            openC.m_Type = TradeOpenAccountGuideType_StockDeal;
            [self.navigationController pushViewController:openC animated:YES];
        }
    } else {
    
        WEAKSELF
        NSArray * arr = self.navigationController.navigationController.viewControllers;
        if([IBGlobalMethod isTradeLogined] == NO && arr.count == 1)  {
            //        [self tradeLogin];
            if ( [IBGlobalMethod getTradeAccountId].length > 0 ) {///iBEST已经登录, 并且已经绑定了交易账号
                IBTradeLoginViewController * tradeVC = [[IBTradeLoginViewController alloc]initWithNibName:@"IBTradeLoginViewController" bundle:nil];
                [tradeVC loginSuccessWithBlock:^(BOOL success, NSString *inftorType) {
                    if (success) {
                        if (weakSelf.view.window) {
                            IBTradeDealDetailViewController * buysaleVC = [[UIStoryboard storyboardWithName:@"TradeDeal" bundle:nil] instantiateViewControllerWithIdentifier:@"IBTradeDealDetailViewController"];
                            buysaleVC.m_Stock = _tradeUserStock;
                            buysaleVC.hidesBottomBarWhenPushed = YES;
                            [weakSelf.navigationController pushViewController:buysaleVC animated:YES];
                        }
                    }
                }];
                [self presentViewController:tradeVC animated:YES completion:nil];
            }else {///iBEST已经登录, 但是没有绑定交易账号
                IBTradeOpenAccountGuideController  *openC = [[UIStoryboard storyboardWithName:@"TradeMain" bundle:nil] instantiateViewControllerWithIdentifier:@"IBTradeOpenAccountGuideController"];
                openC.m_Type = TradeOpenAccountGuideType_StockDeal;
                openC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:openC animated:YES];
            }
        }
    }
}




#pragma mark    Setter
- (void)setM_Header:(IBHomeMainHeader *)m_Header {
    _m_Header = m_Header;
    _m_Header.delegate = self;
}

- (void)setM_TurnHeader:(IBHomeTurnHeader *)m_TurnHeader {
    _m_TurnHeader = m_TurnHeader;
    _m_TurnHeader.delegate = self;
}

//- (IBTradeHomeSectionView *)m_QueryHeader {
//    if (!_m_QueryHeader) {
//        _m_QueryHeader = [IBTradeHomeSectionView shareHeaderWithTtile:@[CustomLocalizedString(@"HOME_MARKET_ACTIVE", nil), CustomLocalizedString(@"HOME_TREASURE", nil), CustomLocalizedString(@"STOCK_LEVEL", nil)] withType:SectionTypeHome];
//        _m_QueryHeader.delegate = self;
//    }
//    return _m_QueryHeader;
//}



- (IBCustomView *)m_FadeView {
    if (!_m_FadeView) {
        _m_FadeView = [IBCustomView shareFadeView];
        _m_FadeView.delegate = self;
    }
    return _m_FadeView;
}


- (IBHomeMainModel *)m_MyRequest {
    if (!_m_MyRequest) {
        _m_MyRequest = [[IBHomeMainModel alloc] init];
        _m_MyRequest.delegate = self;
    }
    return _m_MyRequest;
}


- (NSMutableArray *)optionalStocks {
    if (!_optionalStocks) {
        _optionalStocks = [NSMutableArray arrayWithCapacity:0];
    }
    return _optionalStocks;
}


- (UIImageView *)m_BigImage {
    if (!_m_BigImage) {
        _m_BigImage = [[UIImageView alloc] initWithFrame:self.m_TurnHeader.frame];
        _m_BigImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _m_BigImage;
}


#pragma mark - 4个图片
-(IBHomeBtnLogoReq *)btnLogReq
{
    if (_btnLogReq == nil) {
        _btnLogReq = [[IBHomeBtnLogoReq alloc] init];
    }
    return _btnLogReq;
}

-(void)reqBtnLogoData
{
    WEAKSELF
    [self.btnLogReq ibHomeBtnLogoReqWithResultBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSDictionary * dict = (NSDictionary *)responseObject;
            if (dict[@"data"]) {
                NSDictionary * dataDic = dict[@"data"];
                if (dataDic[@"mid"]) {
                    NSArray * midArray = dataDic[@"mid"];
                    if (midArray.count==4) {
                        [weakSelf updateArray:midArray];
                    }
                }
            }
        }
    }];
}

-(void)updateArray:(NSArray *)logos
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:logos[0]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {

        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            UIImage * modifyImage = [CDTImageTools modifyImageSize:CGSizeMake(50, 50) OfImage:image];
            [self.m_Header.optionalImageBtn setImage:modifyImage forState:UIControlStateNormal];
            [self.m_Header.optionalImageBtn setImage:modifyImage forState:UIControlStateHighlighted];
        }];

        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:logos[1]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {

        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            UIImage * modifyImage = [CDTImageTools modifyImageSize:CGSizeMake(50, 50) OfImage:image];
            [self.m_Header.stockImageBtn setImage:modifyImage forState:UIControlStateNormal];
            [self.m_Header.stockImageBtn setImage:modifyImage forState:UIControlStateHighlighted];

        }];
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:logos[2]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {

        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            UIImage * modifyImage = [CDTImageTools modifyImageSize:CGSizeMake(50, 50) OfImage:image];
            [self.m_Header.moneyImageBtn setImage:modifyImage forState:UIControlStateNormal];
            [self.m_Header.moneyImageBtn setImage:modifyImage forState:UIControlStateHighlighted];


        }];

        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:logos[3]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {

        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            UIImage * modifyImage = [CDTImageTools modifyImageSize:CGSizeMake(50, 50) OfImage:image];
            [self.m_Header.functionImageBtn setImage:modifyImage forState:UIControlStateNormal];
            [self.m_Header.functionImageBtn setImage:modifyImage forState:UIControlStateHighlighted];
        }];

    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kOptional_Stock_Real_Time_Quotes object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSocket_Reconnect object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kIBNotify_Login_Success object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RemoteMessageComing object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OptionalStockChanged object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KIBNotify_ChangLanguage_Success object:nil];
    
    NSLog(@"[%@----------dealloc]",self.class);
}


//- (IBCustomWKWebViewController *)m_WebView {
//    if (!_m_WebView) {
//        _m_WebView = [[IBCustomWKWebViewController alloc] init];
//        _m_WebView.hidesBottomBarWhenPushed = YES;
//    }
//    return _m_WebView;
//}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(IBNoNetView *)noNetView
{
    if (_noNetView == nil) {
        _noNetView = [[NSBundle mainBundle] loadNibNamed:@"IBNoNetView" owner:nil options:nil].lastObject;
        _noNetView.frame = CGRectMake(0, ScreenHeight-self.tabBarController.tabBar.bounds.size.height-37-BottomSafeHeight, ScreenWidth, 37);
        WEAKSELF
        [_noNetView returnNoNetBlock:^{
            IBNoNetWorkViewController * netVC = [[IBNoNetWorkViewController alloc] init];
            netVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:netVC animated:YES];
        }];
    }
    return _noNetView;
}

#pragma mark - 网络变化
-(void)handleNetWorkChangeNotify:(NSNotificationCenter *)notify
{
   NetworkStatus netStatus =  [ NetService().reachability currentReachabilityStatus];
    if (netStatus == NotReachable) {

        if (_noNetView != nil) {
            [_noNetView removeFromSuperview];
            _noNetView = nil;
        }
        if (_noNetView ==nil) {
            [self.view addSubview:self.noNetView];
            [self.view bringSubviewToFront:self.noNetView];
        }
    }else{
        if (_noNetView != nil) {
            [_noNetView removeFromSuperview];
            _noNetView = nil;
        }
    }
}

@end
