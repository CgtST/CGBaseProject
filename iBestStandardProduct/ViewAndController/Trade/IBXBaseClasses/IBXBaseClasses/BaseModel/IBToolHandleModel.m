//
//  IBToolHandleModel.m
//  iBestProduct
//
//  Created by xboker on 2018/4/24.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import "IBToolHandleModel.h"

@implementation IBToolHandleModel




- (NSDateFormatter *)m_DateFormatter {
    if (!_m_DateFormatter) {
        _m_DateFormatter = [[NSDateFormatter alloc] init];
        [_m_DateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [_m_DateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [_m_DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
        [_m_DateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    }
    return _m_DateFormatter;
}



-(NSDateFormatter *)m_Not8Formatter {
    if (!_m_Not8Formatter) {
        _m_Not8Formatter = [[NSDateFormatter alloc] init];
        [_m_Not8Formatter setDateStyle:NSDateFormatterMediumStyle];
        [_m_Not8Formatter setTimeStyle:NSDateFormatterShortStyle];
        [_m_Not8Formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    }
    return _m_Not8Formatter;
}





@end
