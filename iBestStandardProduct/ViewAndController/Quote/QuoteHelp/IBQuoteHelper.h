//
//  IBQuoteHelper.h
//  iBestStandard
//
//  Created by bingo on 2018/5/22.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBQuoteHelper : NSObject

#pragma mark - 转IBOptionalStock

+(IBStock *)changeQnOptionStock:(IBOptionalStock *)stock;


@end
