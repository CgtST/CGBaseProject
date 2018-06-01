//
//  GuideViewController.m
//  startBase
//
//  Created by Mac on 16/3/9.
//  Copyright © 2016年 st. All rights reserved.
//

/*
 *  滑动到最后一张图时用block 
 *
*/

#import "IBGuideViewController.h"
#import <Masonry.h>

//#import "IBNewStockRuleViewController.h"

#import "IBAccount.h"


#define ShowCount 4
#define BottomBtnH 40

@interface IBGuideViewController ()<UIScrollViewDelegate> {
    UIScrollView * m_guideScrollView;
    scrollFinishBlock finishBlock;
    scrollFinishBlock jumpBlock;

}

@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIView * bottomView;

///引导页展示星星的view, 前三个显示星星, 最后一个显示button
@property (nonatomic, strong) UIView *starView;
///跳过按钮, 点击后直接跳转到首页
@property (nonatomic, strong) UIButton *jumpBtn;



@end

@implementation IBGuideViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    // Do any additional setup after loading the view.

    m_guideScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    m_guideScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*(ShowCount), 0);
    
    for (int i = 0 ; i<ShowCount; i++) {
        UIImageView * backView = [[UIImageView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        backView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guidance_image_%d",i+1]];
        [m_guideScrollView addSubview:backView];
    }
    m_guideScrollView.bounces = NO;
    m_guideScrollView.delegate = self;
    m_guideScrollView.pagingEnabled = YES;
    m_guideScrollView.showsVerticalScrollIndicator = NO;
    m_guideScrollView.showsHorizontalScrollIndicator = NO;
    
    if (@available(iOS 11.0, *)) {
        m_guideScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:m_guideScrollView];
    
//    [self.view insertSubview:self.pageControl aboveSubview:m_guideScrollView];
    [self.view insertSubview:self.bottomView aboveSubview:m_guideScrollView];
    [self.view insertSubview:self.starView aboveSubview:m_guideScrollView];
//    [self.view insertSubview:self.jumpBtn atIndex:m_guideScrollView];
    self.bottomView.hidden = YES;
    
    
    
    //初始化语言显示种类
   /* [IBTheme() initIBLanguageShowType];
    
    //下单确认标识默认开启
    [IBTheme() initOrderInputCommand];
    
    //初始化锁屏时间5分钟
    [IBTheme() initLockScreenTime];
    
    //初始化指纹
    [IBTheme() initFinegerprintLogin];
    
    //通知消息的设置
    [IBTheme() initNewsMessageTips];
    [IBTheme() initTradeMessageTips];
    [IBTheme() initCustomerServiceMessageTips];
    
    //初始化启动页面设置
    [IBTheme() initLaunchingViewTag];
    
    //点击价格进入交易设置，默认关闭
    [IBTheme() initOptitionToTradeFlag];
    
    //新版本更新提示
    [IBTheme() setNewVersionUpdateTipsFlag:NO];//提示有新的版本了
    
    //默认皮肤风格
    [IBTheme() initSkinColorTag];
    self.dk_manager.themeVersion =  @"NORMAL";
    
    //默认游客登录
    //游客登录
    IBAccount *account = [QNAccount currentAccount];
    account.session =  INVALID_SESSION;
    [sharedQNUserSystemManager()  IBRegisterGuest:^(BOOL loginResult) {
        if (loginResult) {
            NSLog(@"游客登录成功");
        }else{
            NSLog(@"游客登录失败");
        }
    } ];*/

}




-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int index = fabs(scrollView.contentOffset.x)/scrollView.frame.size.width;
    

    [self layoutStarViewWithOffet:index];
    if (index == ShowCount-1) {
        self.bottomView.hidden = NO;
        self.starView.hidden = YES;
       
    }else{
    
        self.starView.hidden = NO;
        self.bottomView.hidden = YES;
    }
    
}
#pragma mark - Click
-(void)protocalRule:(UIButton *)sender
{
  /*  NSString *strUrl = @"https://ib-app-static.oss-cn-shenzhen.aliyuncs.com/protocol/user/ibest-user-agreementHK.html";
    if ([IBTheme() getIBLanguageShowType] == IBLanguageShowTypeSimpleChinese) {
        strUrl = @"https://ib-app-static.oss-cn-shenzhen.aliyuncs.com/protocol/user/ibest-user-agreementCN.html";
    }
    IBNewStockRuleViewController * ruleVC = [[IBNewStockRuleViewController alloc] initWithUrl:strUrl];
    ruleVC.mtitle = CustomLocalizedString(@"CYONGHUTIAOKUAN", nil);
    [self.navigationController pushViewController:ruleVC animated:YES];*/
}

//立即体验
-(void)agreeClick:(UIButton *)sender
{
//    [MobClick event:@"mashangzhuche"];

    if ([NetService().reachability currentReachabilityStatus] == NotReachable) {
        if (finishBlock != nil) {
            finishBlock();
        }
    }else {
        if (finishBlock != nil) {
            jumpBlock = nil;
            finishBlock();
        }
    }



}




-(void)setFinishBlock:(scrollFinishBlock)block {
    finishBlock = block;
}

- (void)setJumpBlock:(scrollFinishBlock)block {
    jumpBlock = block;
}



-(UIView *)bottomView {
    if (_bottomView == nil) {
        CGFloat ypos = 20;
        CGFloat btnypos = 150;
        if (ScreenHeight < 667.0) {
            ypos = 10;
            btnypos = 130;
        }
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - ypos-btnypos, SCREEN_WIDTH, btnypos)];
        _bottomView.backgroundColor = [UIColor clearColor];
        
        
        UIButton * agreeBtn = [IBViewHelp createButtonFrame:CGRectMake(30, 0, SCREEN_WIDTH-2*30, 50) title:CustomLocalizedString(@"CMASHANGZHUCE", nil) fontSize:17];
        [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        agreeBtn.backgroundColor = [UIColor colorWithHexString:@"#fc6131"];
        agreeBtn.layer.masksToBounds = YES;
        agreeBtn.layer.cornerRadius = 5;
        agreeBtn.layer.borderWidth = 1;
        agreeBtn.layer.borderColor = [UIColor colorWithHexString:@"#fc6131"].CGColor;
        [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [agreeBtn addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:agreeBtn];
        
        UIButton * lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        lookBtn.frame = CGRectMake(30, 50, SCREEN_WIDTH-2*30, 50);
        [lookBtn setTitle:CustomLocalizedString(@"CXIANKANKAN", nil) forState:UIControlStateNormal];
        [lookBtn setTitleColor:[UIColor colorWithHexString:@"#3785e4"] forState:UIControlStateNormal];
        lookBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [lookBtn addTarget:self action:@selector(jumpAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:lookBtn];
        
        
        //NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        //NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
//      NSString * showStr = [NSString stringWithFormat:@"开始使用<%@>即代表您已阅读并同意",app_Name];
        NSString * showStr = CustomLocalizedString(@"CDIANJIANNIUTONGYI", nil);

        CGFloat labW = [CDTFontTools getFontSizeOfStr:showStr Font:[UIFont systemFontOfSize:13]].width+10;
        CGFloat xpos = (SCREEN_WIDTH-labW-60)/2;
        UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(xpos, _bottomView.bounds.size.height-30, labW, 30)];
        titleLab.text = showStr;
        titleLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
        titleLab.font = [UIFont systemFontOfSize:13];
        titleLab.textAlignment = NSTextAlignmentCenter;
    
        titleLab.adjustsFontSizeToFitWidth = YES;
        titleLab.minimumScaleFactor = 0.5;
        [_bottomView addSubview:titleLab];
        UIButton * protalBtn = [IBViewHelp createButtonFrame:CGRectMake(xpos+labW, _bottomView.bounds.size.height-30, 60, 30) title:[NSString stringWithFormat:@"%@   ",CustomLocalizedString(@"CYONGHUTIAOKUAN", nil)] fontSize:13];
        [protalBtn setTitleColor:[UIColor colorWithHexString:@"#3785e4"] forState:UIControlStateNormal];
        [protalBtn setTitleColor:[UIColor colorWithHexString:@"#3785e4"] forState:UIControlStateHighlighted];
        [protalBtn addTarget:self action:@selector(protocalRule:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:protalBtn];
    }
    return _bottomView;
}




- (UIView *)starView {
    if (!_starView) {
        CGFloat ypos = 20;
        CGFloat btnypos = 0;
        if (ScreenHeight < 667.0) {
            ypos = 10;
            btnypos = 5;
        }
        _starView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - ypos-90, SCREEN_WIDTH, 90)];
        UIView *allimgV = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - (ShowCount * 30))/2, btnypos, (ShowCount * 30), 30)];
        allimgV.tag = 999;
        for (int i = 0; i < ShowCount; i ++) {
            UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_white"]];
            imgv.contentMode = UIViewContentModeScaleAspectFit;
            if (i == 0) {
                imgv.image = [UIImage imageNamed:@"star_red"];
            }
            imgv.tag = 500 + i;
            imgv.frame = CGRectMake(20 * i + ( i * 10), 0, 20, 30);
            [allimgV addSubview:imgv];
        }
        [_starView addSubview:allimgV];
    }
    return _starView;
}

///layout星星的状态
- (void)layoutStarViewWithOffet:(NSInteger)offset {
    UIView *v = [self.starView viewWithTag:999];
    for (int i = 0; i < ShowCount; i ++) {
        if (i <= offset) {
            UIImageView *imgv = [v viewWithTag:500 + i];
            imgv.image = [UIImage imageNamed:@"star_red"];
        }else {
            UIImageView *imgv = [v viewWithTag:500 + i];
            imgv.image = [UIImage imageNamed:@"star_white"];
        }
    }
}


- (UIButton *)jumpBtn {
    if (!_jumpBtn) {
        _jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_jumpBtn setTitle:CustomLocalizedString(@"CTIAOGUO", nil) forState:UIControlStateNormal];
        [_jumpBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        _jumpBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _jumpBtn.frame = CGRectMake(ScreenWidth - 75, 24, 60, 40);
        [_jumpBtn addTarget:self action:@selector(jumpAction:) forControlEvents:UIControlEventTouchUpInside];
        _jumpBtn.hidden = YES;
    }
    return _jumpBtn;
}

///跳到首页
- (void)jumpAction:(UIButton *)sender {
//    [MobClick event:@"xiankankan"];

    if ([NetService().reachability currentReachabilityStatus] == NotReachable) {
        if (jumpBlock != nil) {
            jumpBlock();
        }
    }else {
        if (jumpBlock != nil) {
            finishBlock = nil;
            jumpBlock();
        }
    }




    
}




- (UIPageControl *)pageControl {
    if (!_pageControl)  {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.numberOfPages = ShowCount;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#F2F2F2"];
        _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        _pageControl.enabled = NO;
       
//         [self.view insertSubview:_pageControl aboveSubview:m_guideScrollView];
        
        WEAKSELF
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view.mas_bottom);
            make.centerX.equalTo(weakSelf.view.mas_centerX);
        }];
    }
    return _pageControl;
}




@end
