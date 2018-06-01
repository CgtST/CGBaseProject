//
//  IBParaWebViewController.m
//  iBestProduct
//
//  Created by xboker on 2018/3/9.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import "IBParaWebViewController.h"
#import <WebKit/WebKit.h>
#import "IBXCache.h"
#import "IBTradeSingleTon.h"
#import <JLRoutes.h>
#import "IBGTARequest.h"
#import "IBComWKWebViewLinkController.h"


@interface IBParaWebViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView             *m_WebView;
@property (nonatomic, strong) UIProgressView        *m_Progress;
@property (nonatomic, assign) ParaWebViewType       webViewType;
@property (nonatomic, assign) NSString              *m_ParaStr;
@property (nonatomic, strong) IBGTARequest          *m_PassportReq;



@end

@implementation IBParaWebViewController

- (instancetype)initWithType:(ParaWebViewType)type withParaStr:(NSString *)paraStr {
    self = [super init];
    if (self) {
        self.webViewType = type;
        self.m_ParaStr = paraStr;
    }
    return self;
}






- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    //// Date from
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    //// Execute
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        // Done
    }];
    [self.view addSubview:self.m_WebView];
    [self.view addSubview:self.m_Progress];
    WEAKSELF
    switch (self.webViewType) {
        case ParaWebViewTypeBannerOthers:
        case ParaWebViewTypeBannerAction1: {
            [self.m_PassportReq getGTARequestShowErrorInView:self.view withServiceName:self.m_ParaStr needShowError:NO ignoreCode:nil resultBlock:^(id responseObject, NSError *error) {
                [weakSelf hiddenRequestActivityProgressViewWithView:weakSelf.view];
                if(!error) {
                    if (![responseObject isKindOfClass:[NSDictionary class]])  {
                        return ;
                    }
                    NSString *passport = [IBXHelpers getStringWithDictionary:responseObject andForKey:@"token"];
                    NSString *getUrl = [IBXHelpers getStringWithDictionary:responseObject andForKey:@"url"];
                    NSString *theUrl = [NSString stringWithFormat:@"%@?sessionId=%@&passport=%@", getUrl, [IBGlobalMethod getAppLoginSession], passport];
                    NSURL *nURL = [[NSURL alloc] initWithString:theUrl];
                    NSURLRequest *URLRequest = [NSURLRequest  requestWithURL:nURL];//设置请求提交的相关URL
                    [weakSelf.m_WebView loadRequest:URLRequest];//提交请求
                } else  {
                    [weakSelf showToastWithText:CustomLocalizedString(@"MINEQINGQIUYICHANG", nil) style:QNBaseViewControllerToastStyleNormal];
                }
            }];
            break;
        }
        default:
            break;
    }
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [self.m_WebView.configuration.userContentController removeScriptMessageHandlerForName:@"CloseWeb"];
    [self.m_WebView.configuration.userContentController removeScriptMessageHandlerForName:@"viewProtocol"];
    [self.m_WebView.configuration.userContentController removeScriptMessageHandlerForName:@"goAppHomePage"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [IBXHelpers setStatusBarBackgroundColor:[UIColor clearColor]];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.m_WebView.configuration.userContentController addScriptMessageHandler:self name:@"CloseWeb"];
    [self.m_WebView.configuration.userContentController addScriptMessageHandler:self name:@"viewProtocol"];
    [self.m_WebView.configuration.userContentController addScriptMessageHandler:self name:@"goAppHomePage"];
    switch (self.webViewType) {
        case ParaWebViewTypeBannerAction1: {
            self.navigationController.navigationBar.hidden = YES;
            [IBXHelpers setStatusBarBackgroundColor:[UIColor colorWithHexString:@"#2e2e2e"]];
            break;
        }
        case ParaWebViewTypeBannerOthers: {
            break;
        }
        default:
            break;
    }
}


#pragma makr    WKScriptMessageHandler
///调用原生方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"CloseWeb"]) {
        [self.xNavigationcontroller popViewControllerAnimated:YES];
    }
    if ([message.name  isEqualToString:@"viewProtocol"])   {  //条款细则
        IBComWKWebViewLinkController * web = [[IBComWKWebViewLinkController alloc] initWithWebLink:[self URLEncodeString:message.body]];
        [self.navigationController pushViewController:web animated:YES];
    }
    if ([message.name isEqualToString:@"goAppHomePage"]) {
        [self.xNavigationcontroller popToRootViewControllerAnimated:YES];
    }
}



- (NSString *)URLEncodeString:(NSString *)string {
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodedString = [string stringByAddingPercentEncodingWithAllowedCharacters:set];
    return encodedString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark    WKNavigationDelegate
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



#pragma mark    Getter
- (WKWebView *)m_WebView {
    if (!_m_WebView) {
        _m_WebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) configuration:[[WKWebViewConfiguration alloc]init]];
        _m_WebView.UIDelegate = self;
        _m_WebView.navigationDelegate = self;
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

- (IBGTARequest *)m_PassportReq {
    if (!_m_PassportReq) {
        _m_PassportReq = [[IBGTARequest alloc] init];
    }
    return _m_PassportReq;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
