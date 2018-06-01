//
//  UIScrollView+IBScrollViewTouch.m
//  QNApp
//
//  Created by xboker on 2017/4/10.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "UIScrollView+IBScrollViewTouch.h"

@implementation UIScrollView (IBScrollViewTouch)

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}



@end




@interface UIWebView (IBWebViewTouch)

@end

@implementation UIWebView (IBWebViewTouch)

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}

@end





