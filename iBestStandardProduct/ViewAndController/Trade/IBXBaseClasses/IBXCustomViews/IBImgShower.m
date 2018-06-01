//
//  IBImgShower.m
//  iBestProduct
//
//  Created by xboker on 2018/1/26.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import "IBImgShower.h"
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>



@interface IBImgShower()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView              *m_ScrollView;
@property (nonatomic, strong) UIImageView               *m_ImgView;
@property (nonatomic, strong) UITapGestureRecognizer    *m_TapG;
@property (nonatomic, strong) UIPanGestureRecognizer    *m_PanG;
@property (nonatomic, strong) UIButton                  *m_Btn;
@property (nonatomic, assign) CGPoint                   m_Center;
@property (nonatomic, assign) CGSize                    m_Size;

@end

@implementation IBImgShower

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.m_ScrollView];
        self.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.95];
        [self addGestureRecognizer:self.m_PanG];
    }
    return self;
}

+ (void)showWithImg:(id)img withLoadOver:(void(^)(void))block {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([window viewWithTag:789] != nil) {
        return;
    }
    IBImgShower *v = [[IBImgShower alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    v.tag = 789;
    if ([img isKindOfClass:[UIImage class]]) {
        [v.m_ImgView setImage:img];
        UIImage *image = (UIImage *)img;
        CGFloat width = CGImageGetWidth(image.CGImage);
        CGFloat height = CGImageGetHeight(image.CGImage);
        v.m_Size = CGSizeMake(width, height);
    }
    if ([img isKindOfClass:[NSString class]]) {
        [v.m_ImgView setImageWithURL:[NSURL URLWithString:img] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:img]]];
        CGFloat width = CGImageGetWidth(image.CGImage);
        CGFloat height = CGImageGetHeight(image.CGImage);
        v.m_Size = CGSizeMake(width, height);
    }
    if (block) {
        block();
    }
    [v layoutImgWithSize:v.m_Size];
    [window addSubview:v];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.repeatCount = 1;
    animation.duration = 0.2;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    animation.values = @[ @(0.99), @(1), @(1.01), @(1.02), @(1.01), @(1)];
    [v.m_ImgView.layer addAnimation:animation forKey:@"beginaniamtion"];
}

#pragma mark    UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.m_ImgView;
}   // return a view that will be scaled. if delegate returns nil, nothing happens

- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2) {
    self.m_ImgView.center = [self centerOfScrollViewContent:scrollView];
    self.m_Center = self.m_ImgView.center;
}

- (void)layoutImgWithSize:(CGSize)size {
    self.m_ImgView.frame = CGRectMake(0, 0, ScreenWidth, (size.height / size.width) * ScreenWidth);
    self.m_ImgView.center = self.m_ScrollView.center;
    self.m_Center = self.m_ImgView.center;
    self.m_ScrollView.contentSize = self.m_Size;
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

+ (void)hideImgShower {
    id v = [[UIApplication sharedApplication].keyWindow viewWithTag:789];
    if (v == nil) {
        return;
    }else {
        if ([v isKindOfClass:[IBImgShower class]]) {
            IBImgShower *imgV = (IBImgShower *)v;
            [UIView animateWithDuration:0.5 animations:^{
                imgV.m_ScrollView.frame = CGRectMake(0, 0, ScreenWidth, 0);
                imgV.m_ScrollView.center = CGPointMake(ScreenWidth / 2.0, ScreenHeight / 2.0 - 64);
                imgV.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [imgV removeFromSuperview];
                });
            }];
        }
    }
}

- (void)doHandlePan:(UIPanGestureRecognizer *)sender {
//    CGPoint location = [sender locationInView:self];
    CGPoint offset = [sender translationInView:self];
    switch (sender.state) {
        case UIGestureRecognizerStateChanged: {
            if (offset.y < 100 && offset.y >= 0) {
                double alf = 1- (offset.y / 100.0);
                if (alf < 0.4) {
                    alf = 0.4;
                }
                if (alf > 0.95) {
                    alf = 0.95;
                }
                self.backgroundColor = [UIColor colorWithWhite:0.05 alpha: alf];
            }else if (offset.y < 0) {
                self.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.95];
            }else {
                self.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.4];
            }
            self.m_ImgView.center = CGPointMake(self.m_Center.x + offset.x, self.m_Center.y + offset.y);
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (offset.y < 60. && offset.y >= 0) {
                self.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.95];
                self.m_ImgView.center = self.m_Center;
            }else if (offset.y < 0) {
                self.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.95];
                self.m_ImgView.center = self.m_Center;
            } else {
                self.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.4];
                self.m_ImgView.transform = CGAffineTransformScale(self.m_ImgView.transform, 0.1, 0.1);
                [self removeFromSuperview];
            }
            break;
        }
        default:
            break;
    }
}


#pragma mark    Getter
- (UIScrollView *)m_ScrollView {
    if (!_m_ScrollView) {
        _m_ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _m_ScrollView.delegate = self;
        _m_ScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
        _m_ScrollView.minimumZoomScale = 1;
        _m_ScrollView.maximumZoomScale = 3;
        [_m_ScrollView addSubview:self.m_Btn];
        [_m_ScrollView addSubview:self.m_ImgView];
        [_m_ScrollView addGestureRecognizer:self.m_TapG];

    }
    return _m_ScrollView;
}

- (UIImageView *)m_ImgView {
    if (!_m_ImgView) {
        _m_ImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _m_ImgView.contentMode = UIViewContentModeScaleAspectFit;
        _m_ImgView.userInteractionEnabled = YES;
        [_m_ImgView addGestureRecognizer:self.m_TapG];
    }
    return _m_ImgView;
}

- (UIButton *)m_Btn {
    if (!_m_Btn) {
        _m_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _m_Btn.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [_m_Btn addTarget:self action:@selector(hideAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _m_Btn;
}


- (UITapGestureRecognizer *)m_TapG {
    if (!_m_TapG) {
        _m_TapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide:)];
    }
    return _m_TapG;
}

- (UIPanGestureRecognizer *)m_PanG {
    if (!_m_PanG) {
        _m_PanG = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doHandlePan:)];
    }
    return _m_PanG;
}


- (void)hide:(UITapGestureRecognizer *)sender {
    [IBImgShower hideImgShower];
}

- (void)hideAction:(UIButton *)sender {
    [IBImgShower hideImgShower];
}

- (void)dealloc {
    [self.m_ImgView.layer removeAnimationForKey:@"beginaniamtion"];
    NSLog(@"[%@-----dealloc]", self.class);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
