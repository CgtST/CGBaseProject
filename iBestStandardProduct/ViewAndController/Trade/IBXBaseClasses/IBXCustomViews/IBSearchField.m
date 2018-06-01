//
//  IBSearchField.m
//  QNApp
//
//  Created by xboker on 2017/6/1.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBSearchField.h"

@interface IBSearchField()

@end

@implementation IBSearchField


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *v =  [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.height + 15 , 5, self.frame.size.height , self.frame.size.height - 10)];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:v.bounds];
        imageV.image = [UIImage imageNamed:@"ico_search"];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        [v addSubview:imageV];
        self.leftView = v;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.font = [UIFont systemFontOfSize:16];
        self.textColor = [UIColor colorWithHexString:@"#999999"];
        [self setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    }
    return self;
}




///此方式没用
- (instancetype)init {
    self = [super init];
    if (self) {
        UIView *v =  [[UIView alloc] initWithFrame:CGRectMake(20, 0, 33, 33)];
        self.leftView = v;
        self.leftView.backgroundColor = [UIColor redColor];
        self.leftViewMode = UITextFieldViewModeAlways;
        
        
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
