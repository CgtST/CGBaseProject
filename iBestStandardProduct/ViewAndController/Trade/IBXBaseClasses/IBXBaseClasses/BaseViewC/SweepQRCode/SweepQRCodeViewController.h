//
//  SweepQRCodeViewController.h
//  QRCodeDemo1
//
//  Created by CPZX010 on 16/4/15.
//  Copyright © 2016年 谢昆鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GetQRCodeStringSuccess)(NSString *qrCodeString) ;

@interface SweepQRCodeViewController : UIViewController

@property (nonatomic, copy) GetQRCodeStringSuccess qrCodeBlock;

///此Block为选用,也可直接扫描到结果做响应处理
- (void)getBlockFromOutSide:(GetQRCodeStringSuccess)qrCodeBlock;


@end
