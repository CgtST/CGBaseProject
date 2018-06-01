//
//  IBQuoteHelper.m
//  iBestStandard
//
//  Created by bingo on 2018/5/22.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import "IBQuoteHelper.h"

@implementation IBQuoteHelper


#pragma mark - 转qnstock
+(IBStock *)changeQnOptionStock:(IBOptionalStock *)stock
{
    IBStock * substock = [[IBStock alloc] init];
    substock.ID = stock.assetId;
    substock.code = stock.assetCode;
    substock.name = stock.name;
    substock.status = stock.status;
    substock.stype = stock.sType;
    substock.cnName = stock.name;
    
    return substock;
}




@end
