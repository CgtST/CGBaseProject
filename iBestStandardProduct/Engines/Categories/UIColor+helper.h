//
//  UIColor+helper.h
//  Kline
//
//  Created by zhaomingxi on 14-2-9.
//  Copyright (c) 2014年 zhaomingxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorModel : NSObject
@property (nonatomic,assign) int R;
@property (nonatomic,assign) int G;
@property (nonatomic,assign) int B;
@property (nonatomic,assign) CGFloat alpha;


@end


@interface UIColor (helper)

+ (UIColor *) colorWithHexString: (NSString *)color withAlpha:(CGFloat)alpha;
+ (ColorModel *) RGBWithHexString: (NSString *)color withAlpha:(CGFloat)alpha;

@end
