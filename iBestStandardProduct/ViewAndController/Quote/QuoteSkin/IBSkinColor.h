//
//  IBSkinColor.h
//  QNApp
//
//  Created by zscftwo on 2017/1/22.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

/************************************************
 *     说明：如果换肤要改变的颜色，不要写在这个文件中
 ************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#pragma mark - UI设计规范

//字体颜色
typedef NS_ENUM(NSUInteger,IBFontColorType)
{
    IBFontColorTypeTextMain,  //文本主颜色
    IBFontColorTypeTextOne,  //一级小标题
    IBFontColorTypeTextLink,  //文本链接
    IBFontColorTypeTextWeak,  //弱化的文本颜色
    IBFontColorTypeTextOrange, //橘色的文本颜色
    IBFontColorTypeKTitleText  //k线标题颜色
};


//背景颜色
typedef NS_ENUM(NSUInteger,IBBgColorType)
{
    IBBgColorTypeNavBar, //导航栏底色
    IBBgTypeWeakColor, //弱化，跳转
    IBBgTypeNoInput,   //未输入前
    IBBgTypeSeprateLine, //分割线
    IBBgTypeBotoomColor, //App底色

    //涨跌
    IBBgColorTypeGreenDown,  //跌
    IBBgColorTypeRedUp,    //涨
    IBBgColorTypeNoChange, //不涨不跌

    IBBgColorTypeStrong, //强调色
    IBBgColorTypePress,  //按压色
    IBBgColorTypeDefaultSkinColor, //背景颜色

    IBBgColorTypeAlterBackgroundColor, //alter的背景色
};


@interface IBSkinColor : NSObject

//字体颜色
+(nonnull UIColor*)getFontColor:(IBFontColorType) colorType;

//背景色
+(nonnull UIColor*)getBackgroundColor:(IBBgColorType) colortype;

@end
