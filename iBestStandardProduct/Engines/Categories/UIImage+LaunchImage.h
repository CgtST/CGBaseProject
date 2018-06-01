//
//  UIImage+LaunchImage.h
//  QNEngine
//
//  Created by tj on 9/23/15.
//  Copyright (c) 2015 Bacai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Category on `UIImage` to access the splash image.
 **/
@interface UIImage (LaunchImage)

/**
 * Return the name of the splash image for a given orientation.
 * @param orientation The interface orientation.
 * @return The name of the splash image.
 **/
+ (NSString *)launchImageNameForOrientation:(UIInterfaceOrientation)orientation;

/**
 * Returns the splash image for a given orientation.
 * @param orientation The interface orientation.
 * @return The splash image.
 **/
+ (UIImage*)launchImageForOrientation:(UIInterfaceOrientation)orientation;

/**
 * Returns the splash image.
 * @return The splash image.
 **/
+ (UIImage*)launchImage;
@end
