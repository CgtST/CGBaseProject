//
//  FuzzyViewAndLine.m
//  QRCodeDemo1
//  传入一个CGRect获得一个区域,在此区域有一根线上下滑动,再次区域之外会有一个模糊区域
//  Created by CPZX010 on 16/4/15.
//  Copyright © 2016年 谢昆鹏. All rights reserved.
//

#import "FuzzyViewAndLine.h"

@interface FuzzyViewAndLine()
///创建上下跑动的线
@property (nonatomic, strong) UIImageView *lineImageV;
///确定横线是应该向上还是向下跑动
@property (nonatomic, assign) BOOL shouldUp;
///记录向上滑动的最小边界
@property (nonatomic, assign) CGFloat minY;
///记录向上滑动的最大边界
@property (nonatomic, assign) CGFloat maxY;




@end


@implementation FuzzyViewAndLine

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self getCGRect:self.frame];
        self.minY = 0;
        self.maxY = self.bounds.size.height;
        [self scanningAnimationWith:self.frame];
    }
    return self;
}


///根据CGRect创建指定的模糊区域
///获取扫描区域的坐标
- (void)getCGRect:(CGRect)rect {
    CGFloat with = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGFloat x = CGRectGetMinX(rect);
    CGFloat y = CGRectGetMinY(rect);
    CGFloat w = CGRectGetWidth(rect);
    CGFloat h = CGRectGetHeight(rect);
    [self creatFuzzyViewWith:CGRectMake(-x, -y, with, y)];
    [self creatFuzzyViewWith:CGRectMake(-x, 0, x, h)];
    [self creatFuzzyViewWith:CGRectMake(w , 0, with - x - w, h)];
    [self creatFuzzyViewWith:CGRectMake(-x, h , with, height - h - y)];
}
///创建扫描区域之外的模糊效果
- (void)creatFuzzyViewWith :(CGRect)rect {
    UIView *view11 = [[UIView alloc] initWithFrame:rect];
    view11.backgroundColor = [UIColor blackColor];
    view11.alpha = 0.6;
    [self addSubview:view11];
}


///扫描时从上往下跑动的线以及提示语<可以不添加>
- (void)scanningAnimationWith:(CGRect) rect {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat with = rect.size.width;
    CGFloat height = rect.size.height;
    self.lineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, with, 3)];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"scanLine" ofType:@"png"];
    self.lineImageV.image = [UIImage imageWithContentsOfFile:imagePath];
    self.shouldUp = NO;
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(repeatAction) userInfo:nil repeats:YES];
    [self addSubview:self.lineImageV];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(x, y + height, with, 60)];
    lable.text = CustomLocalizedString(@"FX_BU_QINGJIANGSAOMIANQUYUDUIZHUNERWEIMA", nil);
    lable.font = [UIFont systemFontOfSize:13];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.numberOfLines = 0;
    lable.textColor = [UIColor whiteColor];
    [self addSubview:lable];
}



- (void)repeatAction {
    CGFloat num = 1;
    if (self.shouldUp == NO) {
        self.lineImageV.frame = CGRectMake(CGRectGetMinX(self.lineImageV.frame), CGRectGetMinY(self.lineImageV.frame) + num, CGRectGetWidth(self.lineImageV.frame), CGRectGetHeight(self.lineImageV.frame));
        if (CGRectGetMaxY(self.lineImageV.frame) >= self.maxY) {
            self.shouldUp = YES;
        }
    }else {
        self.lineImageV.frame = CGRectMake(CGRectGetMinX(self.lineImageV.frame), CGRectGetMinY(self.lineImageV.frame) - num, CGRectGetWidth(self.lineImageV.frame), CGRectGetHeight(self.lineImageV.frame));
        if (CGRectGetMinY(self.lineImageV.frame) <= self.minY) {
            self.shouldUp = NO;
        }
    }
}

-  (void)dealloc {
    NSLog(@"[%@--------dealloc]", self.class);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
