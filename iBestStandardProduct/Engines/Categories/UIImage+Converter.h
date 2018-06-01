//
//  UIImage+Converter.h
//  QNEngine
//
//  Created by MAC_iOS on 15/6/3.
//  Copyright (c) 2015年 Bacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (Converter)

+ (UIImage *)suitableImageWithName:(NSString *)imageName;
+ (UIImage *)suitablePNGImageWithName:(NSString *)imageName;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end
