//
//  IBXMenuChooseView.m
//  QNApp
//
//  Created by xboker on 2017/3/31.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBXMenuChooseView.h"
#import "IBXMenuChooseViewCell.h"



static NSString *const s_MenuView   = @"IBXMenuChooseView";

@interface IBXMenuChooseView()<UITableViewDelegate, UITableViewDataSource, CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet UIView                 *m_BackView;
@property (strong, nonatomic)  UILabel                      *m_Title;
@property (weak, nonatomic) IBOutlet UITableView            *m_TableView;
@property (nonatomic, strong) NSMutableArray                *m_DataArr;
@property (nonatomic, copy)   ShowBlcok                     showBlock;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *m_TableHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *m_TableLeftConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *m_TableRightConstant;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_TableBottomConstant;



@property (nonatomic, assign) CustomShowType                m_Type;

@end

@implementation IBXMenuChooseView


- (void)awakeFromNib {
    [super awakeFromNib];
    [self.m_TableView registerClass:[IBXMenuChooseViewCell class] forCellReuseIdentifier:@"IBXMenuChooseViewCell"];
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];
}

+ (IBXMenuChooseView *)shareMenuView {
    return [[NSBundle mainBundle] loadNibNamed:s_MenuView owner:nil options:nil].lastObject;
}


- (void)layoutSubviews {
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
}


#pragma makr    UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.m_DataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IBXMenuChooseViewCell *cell = [IBXMenuChooseViewCell shareCellWithTableView:tableView];
    [cell displayCellWithData:self.m_DataArr withIndexPath:indexPath withType:self.m_Type];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IBXMenuChooseViewCell *cell = [self.m_TableView cellForRowAtIndexPath:indexPath];
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.m_Type == CustomShowTypeStockTransfer) {
            weakSelf.showBlock(indexPath, weakSelf.m_DataArr[indexPath.row]);
        }else {
            weakSelf.showBlock(indexPath, cell.textLabel.text.length > 0 ? cell.textLabel.text : @"");
        }
        [weakSelf hideAction];
    });
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 50;
//}



- (IBAction)hideAction:(UIButton *)sender {
    [self hideAction];
}


#pragma mark    CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim {
    
}

/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    NSLog(@"%@______", anim);

    
}

#pragma mark    show And Hide

+ (void)showMenuWithTitle:(NSString *)title withData:(NSArray *)data withBlock:(ShowBlcok)block {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    IBXMenuChooseView *v = [IBXMenuChooseView shareMenuView];
    BOOL have = NO;
    for (id obj in [window subviews]) {
        if ([obj isKindOfClass:[IBXMenuChooseView class]]  ) {
            have = YES;
            break;
        }
    }
    if (have == NO) {
        v.m_DataArr = [data mutableCopy];
        if (data.count == 0) {
            return;
        }else {
            v.m_Title.text = title;
        }
        v.showBlock = block;
        
        CGFloat caculateHeight = 50 * data.count + 53;
        if (caculateHeight > ScreenHeight - 100) {
            caculateHeight = ScreenHeight - 100;
        }
        v.m_TableHeight.constant = caculateHeight + 10;
        [v.m_TableView reloadData];
        v.frame = window.bounds;
        [window addSubview:v];
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.repeatCount = 1;
        animation.duration = 0.2;
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = YES;
        animation.values = @[ @(0.99), @(1)];
        [v.layer addAnimation:animation forKey:@"beginaniamtion"];
        if (data.count == 0) {
            WEAKSELF
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf hideAction];
            });
        }
    }
}



+ (void)showMenuWithTitle:(NSString *)title withData:(NSArray *)data withBlock:(ShowBlcok)block withType:(CustomShowType)type{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    IBXMenuChooseView *v = [IBXMenuChooseView shareMenuView];
    v.m_Type = type;
    BOOL have = NO;
    for (id obj in [window subviews]) {
        if ([obj isKindOfClass:[IBXMenuChooseView class]]  ) {
            have = YES;
            break;
        }
    }
    if (have == NO) {
        v.m_DataArr = [data mutableCopy];
        if (block) {
            v.showBlock = block;
        }
        ///股票转仓时:贴着底部上去左右全屏
        if (type == CustomShowTypeStockTransfer || type == CustomShowTypeFX_Deal_ChooseType || type == CustomShowTypeFX_Deal_OrderLimit || type == CustomShowTypeFX_Deal_ConditionLimit || type == CustomShowTypePM_Deal_ChooseType) {///没有title
            if (data.count == 0) {
                return;
            }
            v.m_TableLeftConstant.constant = 0;
            v.m_TableRightConstant.constant = 0;
            
            CGFloat caculateHeight = 50 * data.count + 5;
            if (caculateHeight > ScreenHeight / 2.0) {
                caculateHeight = ScreenHeight / 2.0;
            }
            v.m_TableHeight.constant = caculateHeight + 5;
            v.m_TableView.rowHeight = 50;
        }else {///有title
            if (data.count == 0) {
                return;
            }else {
                v.m_Title.text = title;
            }
            v.m_TableView.tableHeaderView = v.m_Title;
            CGFloat caculateHeight = 50 * data.count + 53;
            if (caculateHeight > ScreenHeight - 100) {
                caculateHeight = ScreenHeight - 100;
            }
            v.m_TableHeight.constant = caculateHeight + 10 + 5;
            v.m_TableView.rowHeight = 50;
        }
        [v.m_TableView reloadData];
        v.frame = window.bounds;
        [window addSubview:v];
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.repeatCount = 1;
        animation.duration = 0.2;
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = YES;
        if (type == CustomShowTypeStockTransfer) {
            animation.values = @[ @(0.99), @(1)];
        }else {
            animation.values = @[ @(0.99), @(1), @(1.01), @(1.02), @(1.01), @(1)];
        }
        [v.m_TableView.layer addAnimation:animation forKey:@"beginaniamtion"];
    }
}




- (void)hideAction {
    WEAKSELF
    [self.m_TableView layoutIfNeeded];
    [UIView animateWithDuration:0.1 animations:^{
        [weakSelf.m_TableView layoutIfNeeded];
        weakSelf.m_TableBottomConstant.constant = -weakSelf.m_TableHeight.constant;
        weakSelf.m_TableView.alpha = 0.1;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}


+ (void)hideView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (id obj  in window.subviews) {
        if ([obj isKindOfClass:[IBXMenuChooseView class]]) {
            IBXMenuChooseView *v = (IBXMenuChooseView *)obj;
            [v removeFromSuperview];

            break;
        }
    }
}




#pragma mark    Case
- (void)setM_TableView:(UITableView *)m_TableView {
    _m_TableView = m_TableView;
    _m_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _m_TableView.layer.cornerRadius = 6;
    _m_TableView.delegate = self;
    _m_TableView.dataSource = self;
    _m_TableView.showsVerticalScrollIndicator = NO;
    _m_TableView.showsHorizontalScrollIndicator = NO;
}


- (UILabel *)m_Title {
    if (!_m_Title) {
        _m_Title = [[UILabel alloc] initWithFrame:CGRectMake(-1, -1, ScreenWidth + 2, 50)];
        _m_Title.layer.borderColor = [UIColor colorWithHexString:@"#F5F5F5"].CGColor;
        _m_Title.layer.borderWidth = 1.;
        _m_Title.textColor = [UIColor darkGrayColor];
        _m_Title.backgroundColor = [UIColor whiteColor];
        _m_Title.font = [UIFont systemFontOfSize:16 * ScreenWidth / 414.0];
        _m_Title.textAlignment = NSTextAlignmentCenter;

    }
    return _m_Title;
}

- (void)dealloc {
    [self.layer removeAllAnimations];
    NSLog(@"[%@----------dealloc]", self.class);
}

/*
 
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
