//
//  IBNoPasteField.m
//  QNApp
//  这个textField只能单纯的输入, 不能全选, 粘贴等操作//  Created by xboker on 2017/5/28.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBNoPasteField.h"

@implementation IBNoPasteField




- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
//    if (action == @selector(paste:)) {//禁止粘贴
//        return NO;
//    }
//    if (action == @selector(select:)) {//禁止选择
//        return NO;
//    }
//    if (action == @selector(selectAll:)) {//禁止全选
//        return NO;
//    }
//    return [super canPerformAction:action withSender:sender];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
