//
//  UIImageView+Corner.m
//  QNView
//
//  Created by manny on 14-12-16.
//  Copyright (c) 2014年 Bacai. All rights reserved.
//

#import "UIImageView+Corner.h"

@implementation UIImageView (Corner)


- (void)applyRadiusCorner
{
    self.layer.cornerRadius = self.frameHeight * 0.5f;
    self.layer.borderWidth = 5.f;
    self.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent: 0.5f].CGColor;
    self.layer.masksToBounds = YES;
}

@end
