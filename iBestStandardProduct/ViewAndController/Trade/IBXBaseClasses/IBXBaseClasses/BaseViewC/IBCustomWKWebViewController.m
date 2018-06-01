//
//  IBCustomWKWebViewController.m
//  QNApp
//
//  Created by xboker on 2017/4/22.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBCustomWKWebViewController.h"
#import <WebKit/WebKit.h>
#import "IBXCache.h"
#import "IBTradeSingleTon.h"
#import <JLRoutes.h>


@interface IBCustomWKWebViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, UIScrollViewDelegate>

@property (nonatomic, strong) WKWebView             *m_WebView;
@property (nonatomic, strong) UIProgressView        *m_Progress;
@property (nonatomic, strong) UIButton              *m_ShareBtn;




@end

@implementation IBCustomWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.m_WebView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.m_WebView.scrollView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    //// Date from
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    //// Execute
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        // Done
    }];
    switch (self.m_LoadType) {
        case CustomWKWebViewTypeHomeTurnType: {
#if IS_H5_TEST_ENVIRONMENT == 1
            self.m_LoadUrl = @"http://10.200.6.13:8080";
            self.navigationController.navigationBar.hidden = YES;            
#else
            self.title = self.m_TitleStr;
            ///添加分享按钮
            UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            shareBtn.frame = CGRectMake(0, 0, 40, 40);
            [shareBtn setImage:[UIImage imageNamed:@"fenxiang_zixun"] forState:UIControlStateNormal];
            [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
#endif
            break;
        }
        case CustomWKWebViewTypeCaiFuZiXun: {
        self.title = CustomLocalizedString(@"FX_BU_CAIFUZIXUN", nil);
#if IS_H5_TEST_ENVIRONMENT == 1
            self.m_LoadUrl = @"http://10.200.6.13:8080";
            [self.navigationController setNavigationBarHidden:YES];
            self.m_WebView.frame  = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
#else
            [[IBTradeSingleTon shareTradeSingleTon].m_ReadedNewsArr addObject: self.m_LoadUrl];
            if ([self.m_LoadUrl containsString:@" "]) {
                self.m_LoadUrl = [self.m_LoadUrl componentsSeparatedByString:@" "].firstObject;
            }
            if ([self.m_LoadUrl containsString:@"\n"]) {
                self.m_LoadUrl = [self.m_LoadUrl componentsSeparatedByString:@"\n"].firstObject;
            }
#endif
            break;
        }
        case CustomWKWebViewTypeChoicenessInformation: {
            self.title = CustomLocalizedString(@"FX_BU_REMENZIXUN", nil);
            self.m_LoadUrl  = [IBXHelpers getStringWithDictionary:self.m_MessageDic andForKey:@"url"];
            UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            shareBtn.frame = CGRectMake(0, 0, 40, 40);
            [shareBtn setImage:[UIImage imageNamed:@"fenxiang_zixun"] forState:UIControlStateNormal];
            [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
            [[IBTradeSingleTon shareTradeSingleTon].m_ReadedNewsArr addObject: self.m_LoadUrl];
            if ([self.m_LoadUrl containsString:@" "]) {
                self.m_LoadUrl = [self.m_LoadUrl componentsSeparatedByString:@" "].firstObject;
            }
            if ([self.m_LoadUrl containsString:@"\n"]) {
                self.m_LoadUrl = [self.m_LoadUrl componentsSeparatedByString:@"\n"].firstObject;
            }
            break;
        }
        case CustomWKWebViewTypeMZSM: {
            self.title = CustomLocalizedString(@"FX_BU_MIANZESHENGMING", nil);
            break;
        }
        case CustomWKWebViewTypeOther: {
            //self.m_LoadUrl = @"http://119.23.77.115:888/help/views/help.html";
            break   ;
        
        }
        case CustomWKWebViewTypeOpenTradeAccount: {
            [self.navigationController setNavigationBarHidden:YES];
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
 
            break;
        }
        case CustomWKWebViewTypeCKBGSTZ: {
            self.m_LoadUrl = @"http://www.htisec.com/sites/all/themes/hitong/files/what-is-news/20170324_Deposit_sc.pdf";
            self.title = CustomLocalizedString(@"FX_BU_TONGZHI", nil);
            break;
        }
        case CustomWKWebViewTypeCKZZ: {
            self.m_LoadUrl = @"http://www.htisec.com/sites/all/themes/hitong/files/20161107_what-is-news-tc.pdf";
            self.title = CustomLocalizedString(@"FX_BU_CUNKUANZHUANZHANGPINGZHENG", nil);
        }
            break;
        case CustomWKWebViewTypeNDKHWD: {
       
            self.title = CustomLocalizedString(@"TRADE_NEIDIKAIHUWANGDIAN", nil);
        }
            break;
        case CustomWKWebViewTypeNDJZKHWD:    {
    
            self.title = CustomLocalizedString(@"TRADE_NEIDIJIANZHENGKAIHUWANGDIAN", nil);
        }
            break;
        case CustomWKWebViewTypeSQZN:  {
      
            self.title = CustomLocalizedString(@"TRADE_ShenQingZhiNan", nil);
        }
            break;
        case CustomWKWebViewTypeCZZN:   {
      
            self.title = CustomLocalizedString(@"TRADE_CaoZuoZhiNan", nil);
        }
            break;
        case CustomWKWebViewTypeFWSFB:    {
     
            self.title = CustomLocalizedString(@"TRADE_FUWUSHOUFEIBIAO", nil);
        }
            break;
        case CustomWKWebViewTypeTradeTypeInfor : {
            [self.navigationController setNavigationBarHidden:YES];
            self.m_WebView.frame = CGRectMake(0, -20, ScreenWidth, ScreenHeight + 20);
            self.m_LoadUrl = @"https://ib-app-static.oss-cn-shenzhen.aliyuncs.com/trade/index.html";
            break   ;
        }
        case CustomWKWebViewTypeLV2Protocol:  {
            self.title = CustomLocalizedString(@"FX_BU_HUOQUHANGQINGYONGHUXIEYI", nil);
        }
            break;
        case CustomWKWebViewTypeCompanyIntroduce:    {
            self.title = CustomLocalizedString(@"MINEGONGSIJIANJIE", nil);
        }
            break;
        case CustomWKWebViewTypeMyInfo:   {
            self.title = CustomLocalizedString(@"FX_BU_GERENZILIAO", nil);
        }
            break;
        case CustomWKWebViewTypeJHZHJJ: {
           self.title = CustomLocalizedString(@"TRADE_LUGANGTONGLONGKA", nil);
        }
            break;
        case  CustomWKWebViewTypeZHZHJJ:   {
            self.title = CustomLocalizedString(@"TRADE_YIKATONG", nil);
        }
            break;
        case  CustomWKWebViewTypeGHZHJJ:    {
            self.title = CustomLocalizedString(@"TRADE_ZONGHEZHANGHU349", nil);
        }
            break;
        case CustomWKWebViewTypeSaftyNeed: {
            self.title = CustomLocalizedString(@"MINEANQUANXUZHI", nil);
        }
            break;
        case CustomWKWebViewTypeCLBJJJ: {
            self.title = CustomLocalizedString(@"FX_BU_GANGGUHANGQINGFUWUJIANJIE", nil);
            break;
        }
        case CustomWKWebViewTypeFXPL: {
            self.m_LoadUrl = @"https://ib-app-static.oss-cn-shenzhen.aliyuncs.com/protocol/risk/riskStatement.html";
            self.title = CustomLocalizedString(@"FX_BU_FENGXIANPILU", nil);
            break;
        }
        case CustomWKWebViewTypeJDFWBG: {
            self.m_LoadUrl = @"http://www.htisec.com/zh-hk/form-download/1782#node-1782";
            self.title = CustomLocalizedString(@"TRADE_FUWUBIAOGE", nil);
        }
            break;
        default:
            break;
    }
    [self.m_WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.m_LoadUrl]]];
    [self.view addSubview:self.m_WebView];
    [self.view addSubview:self.m_Progress];
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backbtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backbtn setImage:[UIImage imageNamed:@"gray_back"] forState:UIControlStateNormal];
    backbtn.frame =CGRectMake(0, 0, 12, 22);
    
    UIButton *closebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closebtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [closebtn setTitle:CustomLocalizedString(@"MINEGUANBI", nil) forState:UIControlStateNormal];
    [closebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    closebtn.titleLabel.font = [UIFont systemFontOfSize:17];
    closebtn.frame =CGRectMake(0, 0, 60, 20);
    
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc]initWithCustomView:backbtn];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:closebtn];
    
    self.navigationItem.leftBarButtonItems = @[item0,item1];
    
    // Do any additional setup after loading the view.
}


#pragma mark    首页资讯详情界面有分享功能
- (void)shareAction{
    WEAKSELF
    if (self.m_LoadType == CustomWKWebViewTypeChoicenessInformation) {
        [ibUserHandler() shareMessageWithDictionary:self.m_MessageDic withView:self.view withType:ShareType_Home_ZiXun withCallBack:^(NSString *inforStr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showToastWithText:inforStr style:QNBaseViewControllerToastStyleNormal];
            });
        }];
    }
    if (self.m_LoadType == CustomWKWebViewTypeHomeTurnType) {
        [ibUserHandler() shareMessageWithDictionary:self.m_MessageDic withView:self.view withType:ShareType_Banner withCallBack:^(NSString *inforStr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showToastWithText:inforStr style:QNBaseViewControllerToastStyleNormal];
            });
        }];
    }
}






#pragma mark  webview弹出键盘时禁止滚动偏移 UIScrollViewDelegate

-(UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView {
    return nil;
}



#pragma mark    WKUIDelegate

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [self.m_WebView.configuration.userContentController removeScriptMessageHandlerForName:@"CloseWeb"];
    [self.m_WebView.configuration.userContentController removeScriptMessageHandlerForName:@"goAppHomePage"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.m_WebView.configuration.userContentController removeScriptMessageHandlerForName:@"goAppHomePage"];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.m_WebView.configuration.userContentController addScriptMessageHandler:self name:@"CloseWeb"];
    [self.m_WebView.configuration.userContentController addScriptMessageHandler:self name:@"goAppHomePage"];
}



#pragma makr    WKScriptMessageHandler
///调用原生方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([message.name isEqualToString:@"CloseWeb"]) {
        [self.xNavigationcontroller popViewControllerAnimated:YES];
    }
    if ([message.name isEqualToString:@"goAppHomePage"]) {
        [self.xNavigationcontroller popToRootViewControllerAnimated:YES];
    }
    //    NSLog(@"%@_____H5调用方法", message);
    
    if ([message.name isEqualToString:@"goAppHomePage"]) {
        [self.xNavigationcontroller popToRootViewControllerAnimated:YES];
    }
}




#pragma makr    WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
//    [self hiddenRequestActivityProgressView];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
//    [self hiddenRequestActivityProgressView];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"%@收到请求后处理", navigationResponse.response.URL.host.lowercaseString);
    decisionHandler(WKNavigationResponsePolicyAllow);
}


-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"ibest"]) {
        if ([[UIApplication sharedApplication] canOpenURL:URL]) {
            [[UIApplication sharedApplication] openURL:URL];
        }else {
            [[JLRoutes routesForScheme:@"ibest"] routeURL:URL];
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}




//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
//    
//    
//    
//    
//}


#pragma mark    obbserMethod
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context {
    WEAKSELF
    if ([keyPath isEqualToString:@"estimatedProgress"] && object == self.m_WebView) {
        [self.m_Progress setProgress:self.m_WebView.estimatedProgress animated:YES];
        if (self.m_WebView.estimatedProgress >= 1.0) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [weakSelf.m_Progress setAlpha:0.0];
            } completion:^(BOOL finished) {
                [weakSelf.m_Progress setProgress:0.0f animated:NO];
            }];
        }else {
            self.m_Progress.alpha = 1.0;
        }
    }
}


-(void)back:(id)sender {
    if ([self.m_WebView canGoBack]) {
        [self.m_WebView goBack];
    }else{
        if (self.xNavigationcontroller.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

-(void)close:(id)sender {
    if (self.xNavigationcontroller.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/






#pragma mark    Case

- (WKWebView *)m_WebView {
    if (!_m_WebView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        _m_WebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarAndBottomHeight) configuration:configuration];
        _m_WebView.UIDelegate = self;
        _m_WebView.navigationDelegate = self;
        _m_WebView.scrollView.delegate = self;
        [_m_WebView addObserver:self forKeyPath:@"estimatedProgress" options:0x01 context:nil];

        _m_WebView.scrollView.alwaysBounceVertical = YES;
        _m_WebView.scrollView.alwaysBounceHorizontal = YES;
        _m_WebView.scrollView.bounces = NO;
    }
    return _m_WebView;
}




- (UIProgressView *)m_Progress {
    if (!_m_Progress) {
        _m_Progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _m_Progress.frame = CGRectMake(0, 0, ScreenWidth, 1);
        _m_Progress.progressTintColor = [UIColor blueColor];
        _m_Progress.trackTintColor = [UIColor clearColor];
    }
    return _m_Progress;
}


//- (UIButton *)m_ShareBtn {
//    if (!_m_ShareBtn) {
//        _m_ShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _m_ShareBtn.frame = CGRectMake(0, 0, 40, 40);
//        [_m_ShareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
//        [_m_ShareBtn setImage:[UIImage imageNamed:@"fenxiang_zixun"] forState:UIControlStateNormal];
//        //        _m_ShareBtn.backgroundColor = [UIColor orangeColor];
//    }
//    return _m_ShareBtn;
//}




- (void)dealloc {
    [self.m_WebView removeObserver:self forKeyPath:@"estimatedProgress"];
    NSLog(@"[%@---------dealloc]", self.class);
}




@end
