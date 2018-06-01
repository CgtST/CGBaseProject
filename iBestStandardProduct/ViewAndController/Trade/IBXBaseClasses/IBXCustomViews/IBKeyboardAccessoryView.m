//
//  IBKeyboardAccessoryView.m
//  iBestProduct
//
//  Created by xboker on 2017/10/10.
//  Copyright © 2017年 iBest. All rights reserved.
//

#import "IBKeyboardAccessoryView.h"

@interface IBKeyboardAccessoryView()
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIImageView *resignImg;
@property (nonatomic, strong) UIButton *resignBtn;

@property (nonatomic, copy) ChangeKeboard  changeBlock;


@end

@implementation IBKeyboardAccessoryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        [self addSubview:self.resignImg];
        [self addSubview:self.resignBtn];
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        v.backgroundColor = [UIColor colorWithHexString:@"#CCC"];
        [self addSubview:v];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

+ (IBKeyboardAccessoryView *)shareAccessViewWithBlock:(ChangeKeboard)changeBlock {
    IBKeyboardAccessoryView *v = [[IBKeyboardAccessoryView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    if (changeBlock) {
        v.changeBlock = changeBlock;
    }
    return v;
}




#pragma mark   BTN  Action


- (void)leftTap:(UIButton *)sender {
    self.rightBtn.selected = NO;
    self.leftBtn.selected = YES;
    if (self.changeBlock) {
        self.changeBlock(KeyboardChangeTypeCustom);
    }
}

- (void)rightTap:(UIButton *)sender {
    self.rightBtn.selected = YES;
    self.leftBtn.selected = NO;
    if (self.changeBlock) {
        self.changeBlock(KeyboardChangeTypeSystem);
    }
}

- (void)hideKBD:(UIButton *)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark    Getter
- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setTitle:CustomLocalizedString(@"FX_BU_JIGNDIANJIANPAN", nil) forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_leftBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateSelected];
        [_leftBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        _leftBtn.frame = CGRectMake(5, 0, 80, 40);
        _leftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_leftBtn addTarget:self action:@selector(leftTap:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.selected = YES;
    }
    return _leftBtn;
}


- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:CustomLocalizedString(@"FX_BU_XITONGJIANPAN", nil) forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_rightBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateSelected];
        [_rightBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        _rightBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _rightBtn.frame = CGRectMake(100, 0, 80, 40);
        [_rightBtn addTarget:self action:@selector(rightTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UIImageView *)resignImg {
    if (!_resignImg) {
        _resignImg = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 60, 5, 50, 30)];
        _resignImg.image = [UIImage imageNamed:@"jianpan"];
        _resignImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _resignImg;
}

- (UIButton *)resignBtn {
    if (!_resignBtn) {
        _resignBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resignBtn.frame = self.resignImg.frame;
        [_resignBtn addTarget:self action:@selector(hideKBD:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resignBtn;
}









@end
