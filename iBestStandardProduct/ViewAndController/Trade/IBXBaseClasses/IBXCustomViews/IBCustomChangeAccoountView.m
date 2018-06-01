//
//  IBCustomChangeAccoountView.m
//  QNApp
//
//  Created by xboker on 2017/4/14.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBCustomChangeAccoountView.h"
#import "IBCustomChangeAccoountViewCell.h"
//#import "IBXHelpers.h"
#import "IBTradeSingleTon.h"


#define k_CellHeight    55

@interface IBCustomChangeAccoountView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton              *m_BackBtn;
@property (nonatomic, strong) UITableView           *m_TableView;
@property (nonatomic, strong) NSMutableArray        *m_Data;
@property (nonatomic, copy) CallBackBlock           m_Blcok;
@property (nonatomic, copy) HideCallBack            m_Hide;




@end

@implementation IBCustomChangeAccoountView

- (instancetype)initWithFrame:(CGRect)frame  withData:(NSMutableArray *)data withType:(ChangeAccountType)type{
    self = [super initWithFrame:frame];
    if (self) {

//        [self.m_Data addObjectsFromArray:[IBTradeSingleTon shareTradeSingleTon].m_TradeAccounts];
        self.m_Data = data;
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];

        double count = (ScreenHeight - 49.0 - NavBarHeight) / k_CellHeight;
        if (count < data.count) {
            if (type == ChangeAccountTypeNotFromNavBar) {
                self.m_TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight - 50) style:UITableViewStylePlain];
            }else {
                self.m_TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight  - NavBarHeight) style:UITableViewStylePlain];
            }
        }else {
            self.m_TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.m_Data.count * k_CellHeight) style:UITableViewStylePlain];
        }
        
        self.m_TableView.delegate = self;
        self.m_TableView.dataSource = self;
        self.m_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.m_TableView  registerNib:[UINib nibWithNibName:@"IBCustomChangeAccoountViewCell" bundle:nil] forCellReuseIdentifier:@"IBCustomChangeAccoountViewCell"];
        self.m_BackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.m_BackBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        self.m_BackBtn.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight);
        [self.m_BackBtn addTarget:self action:@selector(hideAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.m_BackBtn];
        [self addSubview:self.m_TableView];
        
    }
    
    
    return self;
    
}

- (void)hideAction:(UIButton *)sender {
    if (self.m_Hide) {
        self.m_Hide();
    }
    [self hideAction];
}


#pragma makr    UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.m_Data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IBCustomChangeAccoountViewCell *cell = [IBCustomChangeAccoountViewCell shareCellWithTableView:tableView ];
    [cell displayCellWithData:self.m_Data withIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dic = self.m_Data[indexPath.row];
    for (NSMutableDictionary *account in self.m_Data) {
        [account setObject:@"NO" forKey:@"choose"];
    }
    [dic setObject:@"YES" forKey:@"choose"];
    [self.m_TableView reloadData];
//    [[NSUserDefaults standardUserDefaults] setObject:self.m_Data forKey:TradeSonAccounts];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    IBCustomChangeAccoountViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *content = cell.m_Account.text;
//    [IBTradeSingleTon shareTradeSingleTon].m_TradeAccounts = self.m_Data;
//    [IBTradeSingleTon shareTradeSingleTon].m_NowTradeAccount = [content componentsSeparatedByString:@"  "].lastObject;
    
    
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.m_Blcok(content, indexPath.row, [content componentsSeparatedByString:@"  "].lastObject);
        [weakSelf hideAction];
    });
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}


+ (void)hideCustomChangeAccoountViewWithBlock:(CallBackBlock)block {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (id obj  in window.subviews) {
        if ([obj isKindOfClass:[IBCustomChangeAccoountView class]]) {
            IBCustomChangeAccoountView *v = (IBCustomChangeAccoountView *)obj;
            [UIView animateWithDuration:0.2 animations:^{
                v.alpha = 0;
            } completion:^(BOOL finished) {
                [v removeFromSuperview];
            }];
            break;
        }
    }

}



+ (void)showCustomChangeAccoountViewWithBlock:(CallBackBlock)block withOffet:(BOOL)offset  withData:(NSMutableArray *)data withHideCallBack:(HideCallBack)hide withType:(ChangeAccountType)type{
    if (data.count == 0) {
        return;
    }
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    BOOL haveShow = NO;
    for (id obj  in window.subviews) {
        if ([obj isKindOfClass:[IBCustomChangeAccoountView class]]) {
            haveShow = YES;
            break;
        }
    }
    if (!haveShow) {
        CGFloat yOffset;
        if (offset) {
            yOffset = NavBarHeight + 50;
        }else {
            yOffset = NavBarHeight;
        }
        double yHeight ;
        if (type == ChangeAccountTypeNotFromNavBar) {
            yHeight = ScreenHeight - NavBarHeight - 50;
        }else {
            yHeight = ScreenHeight - NavBarHeight ;
        }

        IBCustomChangeAccoountView *v = [[IBCustomChangeAccoountView alloc] initWithFrame:CGRectMake(0, yOffset, ScreenWidth, yHeight) withData:data withType:type];
        [window addSubview:v];
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.repeatCount = 1;
        animation.duration = 0.15;
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = YES;
        animation.values = @[@(0.99), @(1)];
        [v.layer addAnimation:animation forKey:@"beginaniamtion"];
        [v.m_TableView reloadData];
        if (block) {
            v.m_Blcok = block;
        }
        if (hide) {
            v.m_Hide = hide;
        }
    }
}



- (void)hideAction {
    WEAKSELF
    [UIView animateWithDuration:0.2 animations:^{
//        weakSelf.frame = CGRectMake(0, - ScreenHeight, ScreenWidth, ScreenHeight);
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}




#pragma mark    Case
//- (NSMutableArray *)m_Data {
//    if (!_m_Data) {
//        _m_Data = [NSMutableArray arrayWithCapacity:0];
//    }
//    return _m_Data;
//}

- (void)dealloc {
    NSLog(@"[%@---------dealloc]", self.class);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
