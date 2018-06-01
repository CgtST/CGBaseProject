//
//  IBCustomButton.m
//  QNApp
//
//  Created by xboker on 2017/4/14.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBCustomButton.h"

@implementation IBCustomButton

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self setImageEdgeInsets:UIEdgeInsetsMake(0,  self.titleLabel.bounds.size.width, 0, 0)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -(self.imageView.bounds.size.width), 0, 0)];
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self =  [super initWithCoder:aDecoder];
    if (self) {
        [self setNeedsDisplay];
    }
    return self;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

















@end
