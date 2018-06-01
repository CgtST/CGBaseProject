//
//  IBNewStockRuleViewController.m
//  QNApp
//
//  Created by iBest on 2017/5/24.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBNewStockRuleViewController.h"

@interface IBNewStockRuleViewController ()<UIWebViewDelegate>

@property(weak, nonatomic) IBOutlet UIWebView *myWebView;

@property (nonatomic,copy) NSString * url;
@end

@implementation IBNewStockRuleViewController

-(instancetype)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = self.mtitle;
    if(self.type == RulerType_TradeloginRisk)
    {
        self.title = CustomLocalizedString(@"MINEDIANZIJIAOYIFENGXIAN", nil);
    }
    else if (self.type == RulerType_YHTK)
    {
        self.title = CustomLocalizedString(@"CYONGHUTIAOKUAN", nil);
    }
    else if (self.type == RulerType_AQXZ)
    {
        self.title = CustomLocalizedString(@"MINEANQUANXUZHI", nil);
    }
    self.myWebView.backgroundColor = [UIColor whiteColor];
    self.myWebView.scrollView.backgroundColor = [UIColor blackColor];
    
//    NSString *strUrl = @"";
//    if(self.type == RulerType_HTNewStock)
//    {
//        strUrl = @"http://119.23.77.115:888/Public/ipo/ipo_rules.html";
//    }
//    else if(self.type == RulerType_NewStockRisk)
//    {
//        strUrl = @"http://119.23.77.115:888/Public/ipo/ipo_risk.html";
//    }
//    else
//    {
//        strUrl = @"http://119.23.77.115:888/Public/ipo/ipo_protocol.html";
//    }
    
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
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

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showRequestActivityProgressToView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hiddenRequestActivityProgressViewWithView:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hiddenRequestActivityProgressViewWithView:self.view];
}
@end
