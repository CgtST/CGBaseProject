//
//  GuideViewController.h
//  startBase
//
//  Created by Mac on 16/3/9.
//  Copyright © 2016年 st. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef  void (^scrollFinishBlock) (void);

@interface IBGuideViewController : UIViewController

-(void)setFinishBlock:(scrollFinishBlock)block;

-(void)setJumpBlock:(scrollFinishBlock)block;



@end
