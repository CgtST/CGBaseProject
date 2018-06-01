//
//  IBViewHelp.m
//  iBestStandard
//
//  Created by bingo on 2018/5/15.
//  Copyright © 2018年 xboker. All rights reserved.
//

#import "IBViewHelp.h"

@implementation IBViewHelp


#pragma mark - UIBarButtonItem

//返回
+( UIBarButtonItem*)getCustomBackButtonItem:( id)target action:( SEL)action
{
    UIImage * image = [[CDTImageTools modifyImageSize:CGSizeMake(12,22) OfImage:[IBSkinImage getBackImage]]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    return [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
}



+ (UIBarButtonItem*)getButtonItem:( id)target action:( SEL)action Image:( UIImage*)image Title:( NSString*)titleStr font:(UIFont *)font
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat width = [CDTFontTools getFontSizeOfStr:titleStr Font:font].width;
    leftBtn.frame = CGRectMake(0, 0, width, g_viewHeightAtNavBar);
    [leftBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    leftBtn.titleLabel.font = font;
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    if(nil == image && nil != titleStr) //只有文字
    {
        [leftBtn setTitle:titleStr forState:UIControlStateNormal];
    }
    else if(nil != image && nil == titleStr) //只有图片
    {
        [leftBtn setImage:image forState:UIControlStateNormal];
        CGFloat topDist = (leftBtn.bounds.size.height - image.size.height)/2;
        CGFloat rightDist = (leftBtn.bounds.size.width - image.size.width);
        leftBtn.imageEdgeInsets = UIEdgeInsetsMake(topDist, 0, topDist, rightDist);
    }
    else if(nil != image && nil != titleStr) //有图片和文字
    {
        CGSize imageSize = image.size;
        CGFloat titleLength = [CDTFontTools getFontSizeOfStr:titleStr Font:leftBtn.titleLabel.font].width;
        CGFloat imageTextSpace = 0.0;
        CGFloat titleRight = leftBtn.bounds.size.width - titleLength - imageTextSpace - imageSize.width;
        if(titleRight < 0)
        {
            imageTextSpace = titleRight + imageTextSpace;
            imageTextSpace = imageTextSpace < 0 ? 0 : imageTextSpace;
            titleRight = 0;
        }
        CGFloat imageTop = MAX(leftBtn.bounds.size.height - imageSize.height,0)/2;
        leftBtn.imageEdgeInsets = UIEdgeInsetsMake(imageTop, 0, imageTop,leftBtn.bounds.size.width - imageSize.width) ;
        leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        CGFloat offsetx = [leftBtn titleRectForContentRect:leftBtn.frame].origin.x; //获取文字绘制范围，因为在底层使用图片时，还是使用的事图片的原始大小
        leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, offsetx + imageTextSpace, 0, titleRight);
        
        [leftBtn setTitle:titleStr forState:UIControlStateNormal];
        [leftBtn setImage:image forState:UIControlStateNormal];
        [leftBtn setImage:image forState:UIControlStateHighlighted];
    }
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, g_viewHeightAtNavBar)];
    customView.backgroundColor = [UIColor clearColor];
    [customView addSubview:leftBtn];
    return  [[UIBarButtonItem alloc]initWithCustomView:customView];
}

+( UIBarButtonItem*)getButtonItem:( id)target action:( SEL)action Image:( UIImage*)image Title:( NSString*)titleStr
{
    return  [IBViewHelp getButtonItem:target action:action Image:image Title:titleStr font:[UIFont systemFontOfSize:18.0]];
}

+( UIBarButtonItem*)getRightButtonItem:( id)target action:( SEL)action Image:( UIImage*)image Title:( NSString*)titleStr
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, g_viewHeightAtNavBar);
    [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    if(nil == image && nil != titleStr) //只有文字
    {
        [rightBtn setTitle:titleStr forState:UIControlStateNormal];
        rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    else if(nil != image && nil == titleStr) //只有图片
    {
        [rightBtn setImage:image forState:UIControlStateNormal];
        CGFloat topDist = (rightBtn.bounds.size.height - image.size.height)/2;
        CGFloat leftDist = (rightBtn.bounds.size.width - image.size.width);
        rightBtn.imageEdgeInsets = UIEdgeInsetsMake(topDist, leftDist, topDist, 0);
    }
    else if(nil != image && nil != titleStr) //有图片和文字
    {
    }
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, g_viewHeightAtNavBar)];
    customView.backgroundColor = [UIColor clearColor];
    [customView addSubview:rightBtn];
    return  [[UIBarButtonItem alloc]initWithCustomView:customView];
}




+(CGRect)convert2WindowRect:(CGRect)rect fromView:(nonnull UIView*)fromView
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    return [window convertRect:rect fromView:fromView];
}



/**
 创建Button
 */
+(UIButton *)createButtonFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)fontSize
{
    UIButton * button = [[UIButton alloc]initWithFrame :frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    
    return button;
}

/**
 创建label
 */
+(UILabel *)createLabelFrame:(CGRect)frame textcolor:(UIColor *)textcolor textFontSize:(CGFloat)fontsize
{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:fontsize];
    label.textAlignment = NSTextAlignmentCenter; //默认居中
    label.textColor = textcolor;
    label.minimumScaleFactor = 0.5;
    label.text = @"--";
    label.adjustsFontSizeToFitWidth = YES;
    
    return label;
}

/**
 创建分割线
 */
+(UIView *)creatSepLineFrame:(CGRect )rect
{
    UIView * sepView = [[UIView alloc] initWithFrame:rect];
    sepView.backgroundColor = [IBSkinColor getBackgroundColor:IBBgTypeSeprateLine];
    
    return sepView;
}


@end
