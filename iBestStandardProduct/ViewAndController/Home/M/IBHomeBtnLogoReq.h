//
//  IBHomeBtnLogoReq.h
//  iBestProduct
//
//  Created by zscftwo on 2017/12/18.
//  Copyright © 2017年 iBest. All rights reserved.
//

#import "QNBaseHttpClient.h"

@interface IBHomeBtnLogoReq : QNBaseHttpClient

/**
 home 按钮图片

 @param resultBlock resultBlock description
 */
-(void)ibHomeBtnLogoReqWithResultBlock:(void (^) (id  responseObject, NSError *error))resultBlock;


@end
