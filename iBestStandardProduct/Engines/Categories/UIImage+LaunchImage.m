//
//  UIImage+LaunchImage.m
//  QNEngine
//
//  Created by tj on 9/23/15.
//  Copyright (c) 2015 Bacai. All rights reserved.
//
#import "UIImage+LaunchImage.h"

@implementation UIImage (LaunchImage)

+ (NSString *)launchImageNameForOrientation:(UIInterfaceOrientation)orientation
{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    
    NSString *viewOrientation = @"Portrait";
    
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        viewSize = CGSizeMake(viewSize.height, viewSize.width);
        viewOrientation = @"Landscape";
    }
    
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    
    for (NSDictionary *dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
            return dict[@"UILaunchImageName"];
    }
    return nil;
}

+ (UIImage*)launchImageForOrientation:(UIInterfaceOrientation)orientation
{
    NSString *imageName = [self launchImageNameForOrientation:orientation];
    UIImage *image = [UIImage imageNamed:imageName];
    return image;
}

+ (UIImage*)launchImage
{
    UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    return [self launchImageForOrientation:statusBarOrientation];
}

@end

