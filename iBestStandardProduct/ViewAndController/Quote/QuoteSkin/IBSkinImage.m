//
//  SkinImage.m
//  QNApp
//
//  Created by zscftwo on 2017/1/22.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

/************************************************
 *     说明：如果换肤要改变的图片，不要写在这个文件中
 ************************************************/

#import "IBSkinImage.h"


#define K_iBestBundle  @"iBest"         //当前模块资源文件
#define K_TabBarImage  @"image_tabBar"  //当前模块名

@implementation IBSkinImage

//app图片
+(nonnull UIImage*)getAppSkinImage:(IBAppSKinImagesType)imageType
{
    NSString *imageName = nil;
    switch (imageType)
    {
        case IBAppSKinImagesTypeOfTabBarTrade:
            imageName = @"transaction_normal";
            break;
        case IBAppSKinImagesTypeOfTabBarSelectedTrade:
            imageName = @"transaction_press";
            break;

        case IBAppSKinImagesTypeOfTabBarTracking:
            imageName = @"Catalog_normal";
            break;
        case IBAppSKinImagesTypeOfTabBarSelectedTracking:
            imageName = @"Catalog_press";
            break;
        case IBAppSKinImagesTypeOfTabBarRule:
            imageName = @"rule_normal";
            break;
        case IBAppSKinImagesTypeOfTabBarSelectedRule:
            imageName = @"rule_pre";
            break;
        case IBAppSKinImagesTypeOfTabBarUser:
            imageName = @"user_normal";
            break;
        case IBAppSKinImagesTypeOfTabBarSelectedUser:
            imageName = @"user_press";
            break;
        default:
            break;
    }
    UIImage *image = nil;
    if(nil != imageName)
    {
        image = [CDTImageTools getImageByName:imageName bundleName:K_iBestBundle inDirectory:K_TabBarImage];
    }
    if(nil == image)
    {
        NSAssert(false, @"找不到对应的图片");
        image = [[UIImage alloc] init];
    }
    return image;
    
}


//获取导航栏返回的图片
+(nonnull UIImage *)getBackImage
{
    return  [UIImage imageNamed: @"gray_back"];
}


@end
