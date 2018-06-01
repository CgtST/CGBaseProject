//
//  NSString+Size.m
//  QNView
//
//  Created by manny on 14/12/28.
//  Copyright (c) 2014年 Bacai. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGFloat)heightWithFont:(UIFont *)font forWidth:(CGFloat)width
{
    CGSize size = [self sizeWithFont: font];
    CGFloat rowHeight = size.height + 2;
    CGFloat row = ceil((size.width + 1) / width);
    return row * rowHeight;
}

@end
