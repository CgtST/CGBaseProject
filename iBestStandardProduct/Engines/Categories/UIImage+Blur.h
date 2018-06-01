//
//  UIImage+Blur.h
//  PTravel
//
//  Created by Mannay on 14-6-25.
//  Copyright (c) 2014年 Mannay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Blur)

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius
                       tintColor:(UIColor *)tintColor
           saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       maskImage:(UIImage *)maskImage;


@end












@interface UIImage (GetColor)

- (UIColor *)getColorOfPoint:(CGPoint)point;

@end


