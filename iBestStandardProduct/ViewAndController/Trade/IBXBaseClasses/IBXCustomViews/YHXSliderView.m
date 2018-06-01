//
//  YHXSliderView.m
//  YHXSliderViewControllers
//  将多个视图控制器放上来起到左右滑动效果的类
//  Created by CPZX010 on 16/7/1.
//  Copyright © 2016年 谢昆鹏. All rights reserved.
//

#import "YHXSliderView.h"
//#import "YHXHelpers.h"


#define VIEW_WIDTH      self.bounds.size.width
#define VIEW_HEIGHT     self.bounds.size.height
#define SCREENWIDTH     [UIScreen mainScreen].bounds.size.width

#define TitleWidth      80
#define TitleHeight     50


@interface YHXSliderView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *controllerScrollView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *controllerArray;
@property (nonatomic, assign) CGFloat inforWidth;
///下端提示红线
@property (nonatomic, strong) UILabel *inforLable;
#pragma mark    创建的是lable
@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) NSMutableArray *lablesArray;
@property (nonatomic, strong) UILabel *indexLable;


@end



@implementation YHXSliderView



#pragma mark    创建Lable
- (instancetype)initSliderViewWith:(CGRect )frame
                        withTitles:(NSArray *)titles
               withViewControllers:(NSArray *)controllersArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.haveAnimated = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.controllerArray = [NSMutableArray arrayWithArray:controllersArray];
        self.titleArray = [NSMutableArray arrayWithArray:titles];
        [self addSubview:self.titleScrollView];
        [self addSubview:self.controllerScrollView];
    
      
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, TitleHeight - g_lineHeight, SCREENWIDTH, g_lineHeight)];
        lineView.backgroundColor = [IBSkinColor getBackgroundColor:IBBgTypeSeprateLine ];
        [self.titleScrollView addSubview:lineView];
          [self.titleScrollView addSubview:self.inforLable];
    }
    return self;
}

- (void)creatLablesOnTheTitleScrollViewWithTitleArray:(NSMutableArray *)titlesArray {
    if (titlesArray.count) {
        for (int i = 0 ; i < titlesArray.count; i++) {
            CGFloat lableWidth;
            if (TitleWidth * self.titleArray.count < SCREENWIDTH) {
            lableWidth = SCREENWIDTH / self.titleArray.count;
            }else {
                lableWidth = TitleWidth;
            }
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(i * lableWidth, 0, lableWidth, TitleHeight)];
            lable.userInteractionEnabled = YES;
            lable.textAlignment = NSTextAlignmentCenter;
            UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [lable addGestureRecognizer:tapG];
//            lable.highlightedTextColor = [IBSkinColor getFontColor:IBFontColorTypeTextOne ];
            lable.highlightedTextColor =  [UIColor colorWithHexString:@"#FB6130"];

            lable.backgroundColor = [UIColor whiteColor];
            lable.highlighted = NO;
            [self.lablesArray addObject:lable];
            lable.tag = 800 + i;
            lable.textColor = [IBSkinColor getFontColor:IBFontColorTypeTextOne];
            lable.text = titlesArray[i];
            if (i == 0) {
                [self tapAction:tapG];
                self.indexLable = lable;
            }

            [self.titleScrollView addSubview:lable];
        }
    }
}


- (void)tapAction:(UITapGestureRecognizer *)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    UILabel *lable = (UILabel *)sender.view;
    NSInteger index = lable.tag - 800;
    [self.controllerScrollView setContentOffset:CGPointMake(index * VIEW_WIDTH , 0) animated:self.haveAnimated];
    [self showViewControllersWithIndex:index];
    [self setLableCenter:lable];
    [self setLableSelect:lable];
}


- (void)setLableSelect:(UILabel *)lable {

#pragma mark    通用处理逻辑
    if (lable.tag == self.indexLable.tag) {
        self.indexLable.highlighted = !self.indexLable.highlighted;
    }else {
        
        //上一个Lable恢复
        self.indexLable.highlighted = NO;
        self.indexLable.textColor = [UIColor darkGrayColor];
        self.indexLable.transform = CGAffineTransformIdentity;
        self.indexLable.layer.borderWidth = 0;
        //新Lable变化
        lable.highlighted = YES;
        lable.textColor =  [UIColor colorWithHexString:@"#FB6130"];
        
        lable.transform = CGAffineTransformMakeScale(1, 1);
        lable.textColor = [UIColor redColor];
        self.indexLable = lable;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(yhxSliderViewSectionTappedWithTag:withButtonStatus:)]) {
        [self.delegate yhxSliderViewSectionTappedWithTag:self.indexLable.tag - 800 withButtonStatus:self.indexLable.highlighted];
    }
}

- (void)setLableCenter:(UILabel *)lable {
    CGFloat offsetX = lable.center.x - VIEW_WIDTH * 0.5;
    if (offsetX < 0) {
        offsetX = 0;
    }
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - VIEW_WIDTH;
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    WEAKSELF
    if (TitleWidth * self.titleArray.count < SCREENWIDTH) {
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.inforLable.frame = CGRectMake(lable.frame.origin.x, TitleHeight - 1, SCREENWIDTH / self.titleArray.count, 1.5);
        }];
    }else {
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.inforLable.frame = CGRectMake(lable.frame.origin.x, TitleHeight - 1, TitleWidth, 1.5);
        }];
    }
}


- (UIScrollView *)titleScrollView {
    if (!_titleScrollView ) {
        if (_titleArray.count) {
            _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, TitleHeight)];
            _titleScrollView.delegate = self;
            _titleScrollView.showsVerticalScrollIndicator = NO;
            _titleScrollView.showsHorizontalScrollIndicator = NO;
            _titleScrollView.bounces = NO;
            _titleScrollView.backgroundColor = [UIColor whiteColor];
            if (TitleWidth * _titleArray.count < SCREENWIDTH) {
                _titleScrollView.contentSize = CGSizeMake(SCREENWIDTH, TitleHeight);
            }else {
                _titleScrollView.contentSize = CGSizeMake(TitleWidth * _titleArray.count, TitleHeight);
            }
            [self creatLablesOnTheTitleScrollViewWithTitleArray:_titleArray];
        }
    }
    return _titleScrollView;
}


#pragma mark    公用

- (void)showViewControllersWithIndex:(NSInteger)index {
    UIViewController *controller = self.controllerArray[index];
    if (controller.isViewLoaded && [self.subviews containsObject:controller.view]) {
        return;
    }
    controller.view.frame = CGRectMake(VIEW_WIDTH * index, 0, VIEW_WIDTH, VIEW_HEIGHT);
    [self.controllerScrollView addSubview:controller.view];
}

#pragma mark    UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.controllerScrollView]) {
        CGFloat offsetX = scrollView.contentOffset.x / scrollView.bounds.size.width;
        [self showViewControllersWithIndex:offsetX];
        UILabel *lable = self.lablesArray[[[NSString stringWithFormat:@"%f", offsetX] integerValue]];
        [self setLableCenter:lable];
        [self setLableSelect:lable];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.controllerScrollView]) {
        //something coding here
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.controllerScrollView]) {
      //something coding here
    }
}

#pragma mark    privateCase

- (UIScrollView *)controllerScrollView {
    if (!_controllerScrollView) {
        _controllerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleScrollView.frame), VIEW_WIDTH, VIEW_HEIGHT - TitleHeight - NavBarAndBottomHeight)];
        _controllerScrollView.delegate = self;
        _controllerScrollView.showsHorizontalScrollIndicator = NO;
        _controllerScrollView.showsVerticalScrollIndicator = NO;
        _controllerScrollView.pagingEnabled = YES;
        _controllerScrollView.bounces = NO;
        _controllerScrollView.contentSize = CGSizeMake(VIEW_WIDTH * _controllerArray.count, VIEW_HEIGHT - TitleHeight - 64);
    }
    return _controllerScrollView;
}



#pragma mark    Case

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (NSMutableArray *)lablesArray {
    if (!_lablesArray) {
        _lablesArray = [NSMutableArray array];
    }
    return _lablesArray;
}

- (NSMutableArray *)controllerArray {
    if (!_controllerArray) {
        _controllerArray = [NSMutableArray array];
    }
    return _controllerArray;
}

- (UILabel *)inforLable {
    if (!_inforLable) {
        _inforLable = [[UILabel alloc] initWithFrame:CGRectMake(0, TitleHeight - 1, TitleWidth, 2)];
        _inforLable.backgroundColor = [UIColor colorWithHexString:@"#FB6130"];
    }
    return _inforLable;
}




- (void)dealloc {
    NSLog(@"[%@--------------dealloc]", self.class);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
