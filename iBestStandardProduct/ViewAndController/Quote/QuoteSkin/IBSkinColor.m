//
//  IBSkinColor.m
//  QNApp
//
//  Created by zscftwo on 2017/1/22.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

/************************************************
 *     说明：如果换肤要改变的颜色，不要写在这个文件中
 ************************************************/


#import "IBSkinColor.h"
#import "UIColor+HexString.h"


@implementation IBSkinColor



//字体颜色
+(nonnull UIColor*)getFontColor:(IBFontColorType) colorType
{
    NSString * string = @"";
    switch (colorType) {
        case IBFontColorTypeTextMain:   //文本主颜色
            string = @"#333333";
            break;
        case  IBFontColorTypeTextOne:  //一级小标题
            string = @"#666666";
            break;
        case IBFontColorTypeTextLink:  //文本链接:
            string = @"#3983e4";
            break;
        case IBFontColorTypeTextWeak:  //弱化的文本颜色:
            string = @"#999999";
            break;
        case IBFontColorTypeTextOrange: //橘色的文本
            string = @"#fc6131";
            break;
        case IBFontColorTypeKTitleText:
            string = @"#cccccc";   
        default:
            string = @"#333333"; //默认
            break;
    }
    return  [UIColor colorWithHexString:string];
}

//背景色
+(nonnull UIColor*)getBackgroundColor:(IBBgColorType) colortype
{
    NSString * string = @"";
    switch (colortype) {
        case IBBgColorTypeNavBar: //导航栏底色
            string = @"#2e2e2e";
            break;
        case  IBBgTypeWeakColor: //弱化，跳转
            string = @"#999999";
            break;
        case   IBBgTypeNoInput:   //未输入前
            string = @"#cccccc";
            break;
        case  IBBgTypeSeprateLine: //分割线
            string = @"#e8e8e8";
            break;
        case   IBBgTypeBotoomColor: //App底色
            string = @"#f5f5f5";
            break;
        case IBBgColorTypeGreenDown:  //跌
            string = @"#00ba57";
            break;
        case IBBgColorTypeRedUp:    //涨
            string = @"#ec3a3a";
            break;
        case IBBgColorTypeNoChange: //不变
            string = @"999999";
            break;
        case   IBBgColorTypeStrong: //强调色
            string = @"#cc996e";
            break;
        case  IBBgColorTypePress:  //按压色
            string = @"#fb6e30";
            break;
        case IBBgColorTypeDefaultSkinColor: //背景颜色
            string = @"#ffffff";
            break;
        case IBBgColorTypeAlterBackgroundColor: //alter的背景色
            return [[UIColor blackColor] colorWithAlphaComponent:0.6];
            break;
        default:
            string = @"#2e2e2e"; //默认
            break;
    }
    return  [UIColor colorWithHexString:string];
}


@end
