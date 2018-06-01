//
//  IBNoNetView.h
//  iBestProduct
//
//  Created by zscftwo on 2017/12/29.
//  Copyright © 2017年 iBest. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^noNetClickBlock)(void);

@interface IBNoNetView : UIView
- (IBAction)noNetClick:(UIButton *)sender;
-(void)returnNoNetBlock:(noNetClickBlock)block;
@end
