//
//  UITextView+LimitLength.h
//  APlan
//
//  Created by he15his on 14-9-17.
//  Copyright (c) 2014年 jingling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (LimitLength)
/**
 *  使用时只要调用此方法，加上一个长度(int)，就可以实现了字数限制
 *
 *  @param length
 */
- (void)limitTextLength:(NSInteger)length numberOfChineseChar:(NSInteger)number;;

/**
 *  限制文字字数
 *
 *  @param length      字数
 *  @param changeBlock 文本改变时的回调方法
 */
- (void)limitTextLength:(NSInteger)length textViewChangeBlock:(void(^)(void))changeBlock numberOfChineseChar:(NSInteger)number;
@end
