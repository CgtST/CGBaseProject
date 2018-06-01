//
//  UIView+ScreenShot.m
//  PTravel
//
//  Created by Mannay on 14-6-29.
//  Copyright (c) 2014年 Mannay. All rights reserved.
//

#import "UIView+ScreenShot.h"

@implementation UIView (ScreenShot)

- (UIImage *)screenShot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *baseImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return baseImage;
}

@end
