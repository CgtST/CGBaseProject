//
//  IBParaWebViewController.h
//  iBestProduct
//  一个webview需要传递一些参数之类的;点击banner之后进入
//  Created by xboker on 2018/3/9.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import "YHQBaseViewController.h"

typedef NS_ENUM(NSInteger, ParaWebViewType) {
    ///首页的banner点击  APP内部展示H5网页内容,并且传入passport参数 
    ParaWebViewTypeBannerAction1 = 0,
    ///暂时把其他的全部放在这里
    ParaWebViewTypeBannerOthers,
};


@interface IBParaWebViewController : YHQBaseViewController

- (instancetype)initWithType:(ParaWebViewType)type withParaStr:(NSString *)paraStr;


@end
