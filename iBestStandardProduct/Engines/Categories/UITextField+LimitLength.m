//
//  UITextField+LimitLength.m
//  APlan
//
//  Created by he15his on 14-9-15.
//  Copyright (c) 2014年 jingling. All rights reserved.
//

#import "UITextField+LimitLength.h"
#import <objc/runtime.h>

@implementation UITextField (LimitLength)
static NSString *kLimitTextLengthKey = @"kLimitTextLengthKey";
static NSString *kChageBlockKey = @"kChageBlockKey";
static NSString *kChineseCharNumberKey = @"kChineseCharNumberKey";

- (void)limitTextLength:(NSInteger)length numberOfChineseChar:(NSInteger)number {
    objc_setAssociatedObject(self, (__bridge const void *)(kLimitTextLengthKey), [NSNumber numberWithInteger:length], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, (__bridge const void *)(kChineseCharNumberKey), [NSNumber numberWithInteger:number], OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self addTarget:self action:@selector(textFieldTextLengthLimit:) forControlEvents:UIControlEventEditingChanged];
}

- (void)limitTextLength:(NSInteger)length textFieldChangeBlock:(void(^)(void))changeBlock numberOfChineseChar:(NSInteger)number {
    [self limitTextLength:length numberOfChineseChar:number];

    objc_setAssociatedObject(self, (__bridge const void *)(kChageBlockKey), changeBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)textFieldTextLengthLimit:(id)sender {
    NSNumber *lengthNumber = objc_getAssociatedObject(self, (__bridge const void *)(kLimitTextLengthKey));
    int length = [lengthNumber intValue];
    //下面是修改部分
    bool isChinese;//判断当前输入法是否是中文
    NSArray *currentar = [UITextInputMode activeInputModes];
    UITextInputMode *current = [currentar firstObject];
    //[[UITextInputMode currentInputMode] primaryLanguage]，废弃的方法
    if ([current.primaryLanguage isEqualToString: @"en-US"]) {
        isChinese = false;
    }
    else
    {
        isChinese = true;
    }
    
    if(sender == self) {
        // length是自己设置的位数
        NSString *str = [[self text] stringByReplacingOccurrencesOfString:@"?" withString:@""];
        if (isChinese) { //中文输入法下
            UITextRange *selectedRange = [self markedTextRange];
            //获取高亮部分
            UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if ([self numberOfchar:str] > length) {

                    [self deleteBackwardWithMaxLenth:length];
                }
            }
            else
            {
                // NSLog(@"输入的");
                
            }
        }else{
            if ([self numberOfchar:str] > length) {

                [self deleteBackwardWithMaxLenth:length];
            }
        }
        
        //回调
        void(^chageBlock)(void) = objc_getAssociatedObject(self, (__bridge const void *)(kChageBlockKey));
        if (chageBlock) {
            chageBlock();
        }
    }
}

- (void)shake {
    CAKeyframeAnimation *keyAn = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [keyAn setDuration:0.5f];
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      nil];
    [keyAn setValues:array];
    
    NSArray *times = [[NSArray alloc] initWithObjects:
                      [NSNumber numberWithFloat:0.1f],
                      [NSNumber numberWithFloat:0.2f],
                      [NSNumber numberWithFloat:0.3f],
                      [NSNumber numberWithFloat:0.4f],
                      [NSNumber numberWithFloat:0.5f],
                      [NSNumber numberWithFloat:0.6f],
                      [NSNumber numberWithFloat:0.7f],
                      [NSNumber numberWithFloat:0.8f],
                      [NSNumber numberWithFloat:0.9f],
                      [NSNumber numberWithFloat:1.0f],
                      nil];
    [keyAn setKeyTimes:times];
    
    [self.layer addAnimation:keyAn forKey:@"TextAnim"];
}

/**
 *  算string有多少个字符(中文算2个字符)
 *
 *  @param string 文本
 *
 *  @return 字条数
 */
- (NSInteger)numberOfchar:(NSString *)string {
    NSNumber *lengthNumber = objc_getAssociatedObject(self, (__bridge const void *)(kChineseCharNumberKey));
    //中文相当于的字符数
    NSInteger number = 1;
    if (lengthNumber && [lengthNumber integerValue] > 0) {
        number = [lengthNumber integerValue];
    }
    int strLength =0;
    for (NSInteger i = 0; i < string.length; i++) {
        unichar c = [string characterAtIndex:i];
        
        if ((c >=0x4E00 && c <=0x9FFF) || (c >= 0x2E80 && c <= 0xFE4F) || (c >=0xff01 && c <= 0xff5e)){
            //中文算几个字符
            strLength += number;
        }else{
            strLength ++;
        }
    }
    return strLength;
}

- (void)deleteBackwardWithMaxLenth:(NSInteger)maxLength {
    while ([self numberOfchar:self.text] > maxLength) {
            [self deleteBackward];
    }
}

@end
