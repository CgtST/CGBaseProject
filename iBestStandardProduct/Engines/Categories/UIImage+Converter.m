//
//  UIImage+Converter.m
//  QNEngine
//
//  Created by MAC_iOS on 15/6/3.
//  Copyright (c) 2015年 Bacai. All rights reserved.
//

#import "UIImage+Converter.h"

@implementation UIImage (Converter)

+ (UIImage *)suitableImageWithName:(NSString *)imageName {
    if (![imageName length]) {
        return nil;
    }
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat screenWidth = CGRectGetWidth(screenBounds);
    CGFloat screenHeight = CGRectGetHeight(screenBounds);

    NSString *suitableImageName = nil;
    if (screenWidth == 320 && screenHeight == 480) {
        suitableImageName = [imageName stringByAppendingString:@"@2x.jpg"];
    }else if (screenWidth == 320 && screenHeight == 568) {
        suitableImageName = [imageName stringByAppendingString:@"-568h@2x.jpg"];
    }else if (screenWidth == 375 && screenHeight == 667) {
        suitableImageName = [imageName stringByAppendingString:@"-667h@2x.jpg"];
    }else if (screenWidth == 414 && screenHeight == 736) {
        suitableImageName = [imageName stringByAppendingString:@"-736h@3x.jpg"];
    }
    
    if ([suitableImageName length]) {
        return [UIImage imageNamed:suitableImageName];
    }else {
        return nil;
    }
}

+ (UIImage *)suitablePNGImageWithName:(NSString *)imageName {
    if (![imageName length]) {
        return nil;
    }
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat screenWidth = CGRectGetWidth(screenBounds);
    CGFloat screenHeight = CGRectGetHeight(screenBounds);
    
    NSString *suitableImageName = nil;
    if (screenWidth == 320 && screenHeight == 480) {
        suitableImageName = [imageName stringByAppendingString:@"@2x.png"];
    }else if (screenWidth == 320 && screenHeight == 568) {
        suitableImageName = [imageName stringByAppendingString:@"-568h@2x.png"];
    }else if (screenWidth == 375 && screenHeight == 667) {
        suitableImageName = [imageName stringByAppendingString:@"-667h@2x.png"];
    }else if (screenWidth == 414 && screenHeight == 736) {
        suitableImageName = [imageName stringByAppendingString:@"-736h@3x.png"];
    }
    
    if ([suitableImageName length]) {
        return [UIImage imageNamed:suitableImageName];
    }else {
        return nil;
    }
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *pureColorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pureColorImage;
}
@end
