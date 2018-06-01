//
//  IBHomeHeadImageView.m
//  QNApp
//
//  Created by iBest on 2017/3/10.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBHomeHeadImageView.h"
#import "UIImageView+WebCache.h"
#import "IBDotButton.h"

@interface IBHomeHeadImageView () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *picList;
@property (nonatomic, strong) UIButton *personButton;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) IBDotButton *messageButton;

@end

@implementation IBHomeHeadImageView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.scrollView.delegate = self;
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.center.x - 100.f/2, self.frame.size.height - 20.f, 100.f, 18.f)];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:155/255 green:168/255 blue:180/255 alpha:0.5];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:self.pageControl];
    
    _personButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _personButton.frame = CGRectMake(14.f, 30.f, 24.f, 24.f);
    [_personButton setImage:[UIImage imageNamed:@"white_user_name"]  forState:UIControlStateNormal];
    _personButton.tag = 100;
    [_personButton addTarget:self action:@selector(HomePageTopButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_personButton];
    
    _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchButton.frame = CGRectMake(ScreenWidth - 70.f, 30.f, 24.f, 24.f);
    [_searchButton setImage:[UIImage imageNamed:@"search_icon"]  forState:UIControlStateNormal];
    _searchButton.tag = 101;
    [_searchButton addTarget:self action:@selector(HomePageTopButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_searchButton];
    
    _messageButton = [IBDotButton buttonWithType:UIButtonTypeCustom];
    _messageButton.frame = CGRectMake(ScreenWidth - 34.f, 30.f, 24.f, 24.f);
    [_messageButton setImage:[UIImage imageNamed:@"home_news"]  forState:UIControlStateNormal];
    _messageButton.tag = 102;
    _messageButton.isShowDot = YES;
    [_messageButton addTarget:self action:@selector(HomePageTopButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_messageButton];
}

-(void)HomePageTopButtonAction:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSLog(@"btn tag =%ld",btn.tag);
    if(_delegate && [_delegate respondsToSelector:@selector(clickHomeTopButtonAction:)])
    {
        [_delegate clickHomeTopButtonAction:btn.tag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (IBHomeHeadImageView *)homeImageView {
    IBHomeHeadImageView *headerView = [[NSBundle mainBundle] loadNibNamed:@"IBHomeHeadImageView" owner:nil options:nil][0];
    
    return headerView;
}

- (void)setImages:(NSArray *)picList {
    if (!picList || picList.count == 0) {
        self.pageControl.hidden = YES;
        return;
    }
    
    self.picList = picList;
    for (NSInteger i = 0; i < picList.count; i++) {
        NSString *url = picList[i];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width * i,0,_scrollView.frame.size.width,_scrollView.frame.size.height)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
        
        //add target
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
//        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
//        [imageView addGestureRecognizer:gesture];
//        
//        [_scrollView addSubview:imageView];
    }
    self.scrollView.contentSize = CGSizeMake(ScreenWidth * picList.count, _scrollView.bounds.size.height);
    self.pageControl.numberOfPages = picList.count;
    self.pageControl.currentPage = 0;
    
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(autoScrollImage:) userInfo:nil repeats:YES];
}

- (void)setLocalImages:(NSArray *)imageName
{
    if (!imageName || imageName.count == 0) {
        self.pageControl.hidden = YES;
        return;
    }
    self.picList = imageName;
    for (NSInteger i = 0; i < imageName.count; i++) {
        NSString *name = imageName[i];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:name]];
        imageView.frame = CGRectMake(ScreenWidth * i,0,ScreenWidth,_scrollView.frame.size.height);
        //[imageView setImage:[UIImage imageNamed:name]];
        
        //add target
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        //        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        //        [imageView addGestureRecognizer:gesture];
        //
        [_scrollView addSubview:imageView];
    }
    self.scrollView.contentSize = CGSizeMake(ScreenWidth * imageName.count, _scrollView.bounds.size.height);
    self.pageControl.numberOfPages = imageName.count;
    self.pageControl.currentPage = 0;
    
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
}
- (void)tap:(UITapGestureRecognizer *)gesture {
    UIView *view = gesture.view;
    if (_delegate && [_delegate respondsToSelector:@selector(homeImageView:didTapImageWithIndex:)]) {
        [_delegate homeImageView:self didTapImageWithIndex:view.tag];
    }
}

- (void)autoScrollImage:(NSTimer *)timer {
    NSInteger count = self.picList.count;
    NSInteger page = self.pageControl.currentPage;
    page++;
    page = page > (count-1) ? 0 : page;
    self.pageControl.currentPage = page;
    
    [self.scrollView scrollRectToVisible:CGRectMake(ScreenWidth * page,0,ScreenWidth,_scrollView.frame.size.height) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    NSInteger index = (NSInteger)offset.x/scrollView.bounds.size.width;
    self.pageControl.currentPage = index;
}

- (void)turnPage
{
    double page = self.pageControl.currentPage; // 获取当前的page
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width * page,0,_scrollView.frame.size.width,_scrollView.frame.size.height) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
}
// 定时器 绑定的方法
- (void)runTimePage
{
    double page = _pageControl.currentPage; // 获取当前的page
    page++;
    page = page > (_pageControl.numberOfPages-1) ? 0 : page ;
    _pageControl.currentPage = page;
    [self turnPage];
}
@end
