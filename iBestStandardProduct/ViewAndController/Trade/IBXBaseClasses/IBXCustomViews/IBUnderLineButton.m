//
//  IBUnderLineButton.m
//  iBestProduct
//  一个带有下划线的button 不设置颜色的话默认 "3983E4";
//  Created by xboker on 2017/6/23.
//  Copyright © 2017年 iBest. All rights reserved.
//

#import "IBUnderLineButton.h"

@interface IBUnderLineButton()
@property (nonatomic, strong) UIColor *m_Color;

@end

@implementation IBUnderLineButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.m_Color = [UIColor colorWithHexString:@"#3983E4"];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.m_Color = [UIColor colorWithHexString:@"#3983E4"];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.m_Color = [UIColor colorWithHexString:@"#3983E4"];
}


- (void)setColor:(UIColor *)color {
    self.m_Color = color;
    [self setNeedsDisplay];
}


- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:title];
    NSRange titleRange = {0,[titleStr length]};
    [titleStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    [titleStr addAttribute:NSUnderlineColorAttributeName value:self.m_Color range:titleRange];
    [self setAttributedTitle:titleStr forState:state];
}



@end
