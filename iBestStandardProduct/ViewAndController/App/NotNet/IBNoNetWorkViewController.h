//
//  IBNoNetWorkViewController.h
//  iBestProduct
//
//  Created by zscftwo on 2018/1/2.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBBaseViewController.h"

@protocol IBNoNetDelegate <NSObject>

-(void)loadAgain;

@end


@interface IBNoNetWorkViewController : IBBaseViewController
@property (nonatomic,weak) id<IBNoNetDelegate> delegate;

@property (nonatomic) BOOL isFirst;


@end
