//
//  IBKeyboardAccessoryView.h
//  iBestProduct
//
//  Created by xboker on 2017/10/10.
//  Copyright © 2017年 iBest. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KeyboardChangeType) {
    ////系统键盘
    KeyboardChangeTypeSystem,
    ///自定义键盘
    KeyboardChangeTypeCustom,
};

typedef void(^ChangeKeboard) (KeyboardChangeType type);







@interface IBKeyboardAccessoryView : UIView

+ (IBKeyboardAccessoryView *)shareAccessViewWithBlock:(ChangeKeboard)changeBlock;

@end
