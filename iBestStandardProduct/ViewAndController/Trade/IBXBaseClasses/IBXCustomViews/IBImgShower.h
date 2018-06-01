//
//  IBImgShower.h
//  iBestProduct
//  一个显示img的类, 传入imgUrl或者一个img;
//  Created by xboker on 2018/1/26.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBImgShower : UIView

+ (void)showWithImg:(id)img withLoadOver:(void(^)(void))block;
+ (void)hideImgShower;

@end
