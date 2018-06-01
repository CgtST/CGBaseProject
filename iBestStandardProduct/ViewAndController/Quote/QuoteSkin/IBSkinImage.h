//
//  SkinImage.h
//  QNApp
//
//  Created by zscftwo on 2017/1/22.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

/************************************************
 *     说明：如果换肤要改变的图片，不要写在这个文件中
 ************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//App图片
typedef NS_ENUM(NSUInteger,IBAppSKinImagesType)
{
    IBAppSKinImagesTypeOfTabBarTrade,  //交易
    IBAppSKinImagesTypeOfTabBarSelectedTrade,  //交易(选中时)
    IBAppSKinImagesTypeOfTabBarTracking,//交易轨迹
    IBAppSKinImagesTypeOfTabBarSelectedTracking,//交易轨迹(选中时)
    IBAppSKinImagesTypeOfTabBarRule,//规则
    IBAppSKinImagesTypeOfTabBarSelectedRule,//规则(选中时)
    IBAppSKinImagesTypeOfTabBarUser,//我
    IBAppSKinImagesTypeOfTabBarSelectedUser,//我(选中时)
};


//行情图片


@interface IBSkinImage : NSObject


//app图片
+(nonnull UIImage*)getAppSkinImage:(IBAppSKinImagesType)imageType;


//获取导航栏返回的图片
+( UIImage *)getBackImage;


@end
