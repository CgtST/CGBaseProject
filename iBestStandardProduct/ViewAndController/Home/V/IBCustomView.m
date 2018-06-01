//
//  IBCustomView.m
//  IBSliderView
//
//  Created by xboker on 2017/3/18.
//  Copyright © 2017年 xboker. All rights reserved.
//

#import "IBCustomView.h"
#import "IBDotButton.h"
#import "IBSearchField.h"




@interface IBCustomView()<UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView   *m_IndexTableView;
@property (nonatomic, assign) CGFloat       m_LastOffset;
@property (nonatomic, strong) IBSearchField   *m_SearchTF;


@property (nonatomic, strong) UIButton *m_LeftBTN;
@property (nonatomic, strong) UIButton *m_RightBTN;

@property (nonatomic, strong) UIView   *m_RedView;



@end


@implementation IBCustomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ibestcancellogin:) name:@"ibestcancellogin" object:nil];
        ///个人中心
        self.m_LeftBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        self.m_LeftBTN.tag = 500;
        [self.m_LeftBTN addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        if (IS_iPhoneX) {
            self.m_LeftBTN.frame = CGRectMake(15, 46.5, 30, 30);
        }else {
            self.m_LeftBTN.frame = CGRectMake(15, 26.5, 30, 30);
        }
        [self.m_LeftBTN setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

        ///站内新闻
        self.m_RightBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        self.m_RightBTN.tag = 502;
//        btn3.isShowDot = YES;
        [self.m_RightBTN addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        if (IS_iPhoneX) {
            self.m_RightBTN.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 45, 46.5, 30, 30);
        }else {
            self.m_RightBTN.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 45, 26.5, 30, 30);
        }
        [self.m_RightBTN setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
       

        if (IS_iPhoneX) {
            self.m_SearchTF = [[IBSearchField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.m_LeftBTN.frame) + 16, 45, CGRectGetMinX(self.m_RightBTN.frame) - CGRectGetMaxX(self.m_LeftBTN.frame) - 32, 33)];
        }else {
            self.m_SearchTF = [[IBSearchField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.m_LeftBTN.frame) + 16, 25, CGRectGetMinX(self.m_RightBTN.frame) - CGRectGetMaxX(self.m_LeftBTN.frame) - 32, 33)];
        }
        
        self.m_SearchTF.placeholder = CustomLocalizedString(@"HOME_SOUSUOFUPIAODAIMAHUOJIANCHENG", nil);
        self.m_SearchTF.delegate = self;
        self.m_SearchTF.layer.cornerRadius = 16 ;

        
        self.m_RedView = [[UIView alloc] initWithFrame:CGRectMake(22, 3, 8, 8)];
        self.m_RedView.layer.cornerRadius = 4;
        self.m_RedView.backgroundColor = [UIColor redColor];
        [self.m_RightBTN addSubview: self.m_RedView];
        self.m_RedView.hidden = YES;
        
                
        ///设置图片
        [self.m_LeftBTN setImage:[UIImage imageNamed:@"weidenglu"] forState:UIControlStateNormal];
        [self.m_RightBTN setImage:[UIImage imageNamed:@"shouye_xiaoxi"] forState:UIControlStateNormal];
        [self addSubview:self.m_LeftBTN];
        [self addSubview:self.m_SearchTF];
        [self addSubview:self.m_RightBTN];
        
        
        self.m_LastOffset = 0;
    }
    return self;
}



+ (IBCustomView *)shareFadeView {
    IBCustomView *v ;
    if (IS_iPhoneX) {
        v =     [[IBCustomView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 84)];
    }else {
       v = [[IBCustomView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    v.backgroundColor = [UIColor colorWithWhite:1 alpha:0.01];
    return v;

}


- (void)ibestcancellogin:(NSNotification *)sender {
    [self.m_LeftBTN setImage:[UIImage imageNamed:@"weidenglu"] forState:UIControlStateNormal];

}




- (void)tapAction:(UIButton *)sender {
    [self.delegate ibTapedIBCustomWithtype:sender.tag - 500];
}


#pragma mark    UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.delegate ibTapedIBCustomWithtype:1];
    return NO;
}




- (void)layoutTheImagesWithCount:(NSInteger )count {
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([IBGlobalMethod isLogin]) {
            [weakSelf.m_LeftBTN setImage:[UIImage imageNamed:@"yidenglu"] forState:UIControlStateNormal];
        }else {
            [weakSelf.m_LeftBTN setImage:[UIImage imageNamed:@"weidenglu"] forState:UIControlStateNormal];
        }
        if (count > 0) {
            weakSelf.m_RedView.hidden = NO;
        }else {
            weakSelf.m_RedView.hidden = YES;
        }
    
    }) ;
    
}




- (void)ibLastOffset:(CGFloat)offset {
    self.m_LastOffset = offset;
}
//
//- (void)ibTransferOffset:(CGFloat)offset {
//    if (offset < self.m_LastOffset) {//向下拖动
//        if (offset <= -100 && offset > -190) {
//            self.backgroundColor = [UIColor colorWithRed:46 / 255.0 green:46 / 255.0 blue:46 / 255.0  alpha:(offset + 190)/ 100.0];
//        }else if (offset <= -190) {
//            self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.01];
//        }else {
//            self.backgroundColor = [UIColor colorWithRed:46 / 255.0 green:46 / 255.0 blue:46 / 255.0  alpha:1];
//        }
//    }else {//向上拖动
//        if (offset <= -100 && offset >= -190) {
//            self.backgroundColor = [UIColor colorWithRed:46 / 255.0 green:46 / 255.0 blue:46 / 255.0  alpha:(offset + 190)/ 100.0];
//        }else if (offset <= -190) {
//            self.backgroundColor = [UIColor colorWithRed:46 / 255.0 green:46 / 255.0 blue:46 / 255.0  alpha:0.01];
//        } else {
//            self.backgroundColor = [UIColor colorWithRed:46 / 255.0 green:46 / 255.0 blue:46 / 255.0  alpha:1];
//            
//        }
//    }
//}


- (void)ibTransferOffset:(CGFloat)offset {
    WEAKSELF
    if (offset < self.m_LastOffset) {//向下拖动
        if (offset <= 100 && offset > 0) {
            self.backgroundColor = [UIColor colorWithRed:46 / 255.0 green:46 / 255.0 blue:46 / 255.0  alpha:offset/ 100.0];
    
        }else if (offset <= 0) {
            self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.000001];
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.m_SearchTF.layer.cornerRadius = 16 ;
            }];

        } else {
            self.backgroundColor = [UIColor colorWithRed:46 / 255.0 green:46 / 255.0 blue:46 / 255.0  alpha:1];
            }
    }else {//向上拖动
        if (offset <= 80) {
            self.backgroundColor = [UIColor colorWithRed:46 / 255.0 green:46 / 255.0 blue:46 / 255.0  alpha:offset/ 100.0];

        }else {
            self.backgroundColor = [UIColor colorWithRed:46 / 255.0 green:46 / 255.0 blue:46 / 255.0  alpha:1];
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.m_SearchTF.layer.cornerRadius = 8;
            }];
        }
    }
}



- (void)dealloc {
//  [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"ibestcancellogin"];
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
