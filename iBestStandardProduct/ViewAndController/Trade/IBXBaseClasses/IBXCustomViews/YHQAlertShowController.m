//
//  YHQAlertShowController.m
//  Yihaodais
//
//  Created by Money on 16/7/18.
//  Copyright © 2016年 gf. All rights reserved.
//

#import "YHQAlertShowController.h"

@interface YHQAlertShowController ()

@end

@implementation YHQAlertShowController



+ (instancetype)alertShowControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle {
    YHQAlertShowController *alertShowC = [super alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 2.0;
    NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:message attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : [UIFont systemFontOfSize:13.0]}];
    [alertShowC setValue:attributedMessage forKey:@"attributedMessage"];
    
    return alertShowC;
}

+ (instancetype)alertShowControllerWithTitle:(NSString *)title AttributedMessage:(NSAttributedString *)attributedMessage preferredStyle:(UIAlertControllerStyle)preferredStyle {
    YHQAlertShowController *alertShowC = [super alertControllerWithTitle:title message:@"" preferredStyle:preferredStyle];
    [alertShowC setValue:attributedMessage forKey:@"attributedMessage"];
    return alertShowC;
}


- (void)dealloc {
    NSLog(@"[%@ ------ dealloc]", self.class);
}

@end
