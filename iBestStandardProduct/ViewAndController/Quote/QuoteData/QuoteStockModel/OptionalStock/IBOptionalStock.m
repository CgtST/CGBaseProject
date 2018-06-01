//
//  IBOptionalStock.m
//  iBestStandard
//
//  Created by bingo on 2018/5/15.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import "IBOptionalStock.h"

@implementation IBOptionalStock

@synthesize assetId = _assetId, statusIdentifier = _statusIdentifier;

- (void)nextDisplayType
{
    if (self.displayType == IBOptionalStockDisplayTypeTotalValue)
    {
        self.displayType = IBOptionalStockDisplayTypeChangePercent;
    }
    else
    {
        self.displayType ++;
    }
}

- (void)markAsUploaded {
    self.uploaded = YES;
}

- (BOOL)isEqual:(id)other
{
    if (![other isMemberOfClass:[IBOptionalStock class]]) {
        return NO;
    }else {
        return [_assetId isEqualToString:((IBOptionalStock *)other).assetId];
        
    }
}

- (NSUInteger)hash
{
    return [_assetId hash];
}

- (instancetype)initWithParams:(NSArray *)params bDelay:(BOOL) bdelay{
    self = [super init];
    if (self) {
        [self setupWithParams:params bDelay:bdelay];
    }
    return self;
}

//其它的模型转自选股
-(instancetype)initwithOtherModel:(NSArray *)array
{
    IBOptionalStock * stock = [[IBOptionalStock alloc] init];
    return stock;
}

+ (instancetype)UndefinedStockWithAssetId:(NSString *)assetId name:(NSString *)name {
    IBOptionalStock *undefinedStock = [[IBOptionalStock alloc] init];
    undefinedStock.statusIdentifier = @"-1";
    undefinedStock.assetId = assetId;
    undefinedStock.name = name;
    undefinedStock.uploaded = NO;
    undefinedStock.createdTs = [[NSDate date] timeIntervalSince1970];
    return undefinedStock;
}





- (void)setupWithParams:(NSArray *)params  bDelay:(BOOL) bdelay {
    [params enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        switch (idx) {
            case 0:
                self.assetId = obj;
                break;
                
            case 1:
                self.name = obj;
                break;
                
            case 2:
                self.price = obj;
                break;
                
            case 3:
                self.change = obj;
                break;
                
            case 4:
                self.changePercent = obj;
                break;
                
            case 5:
                self.totalValue = obj;
                break;
                
            case 6:
                self.sType = obj;
                break;
                
            case 7:
                self.statusIdentifier = obj;
                break;
            case 8:
                if (bdelay == YES) {
                    self.bDelay = [obj intValue]>0?YES:NO;  //0 实时， 1延时；
                }else{
                    self.lotSize = obj; //add by chargo
                }
                break;
            default:
                break;
        }
    }];
}

- (void)setupStock {
    //    NSArray *assetIdComponents = [_assetId componentsSeparatedByString:@"."];
    //    NSMutableString *assetCode = [[NSMutableString alloc] initWithString:@""];
    //    if ([assetIdComponents count] >= 2) {
    //        [assetCode appendString:[assetIdComponents lastObject]];
    //        [assetCode appendString:@" "];
    //    }
    //    if ([assetIdComponents count]) {
    //        [assetCode appendString:assetIdComponents[0]];
    //    }
    self.assetCode = _assetId;
}

- (void)setupStatusWithStatus:(NSString *)status {
    self.status = (IBStockTradeStatus)[status integerValue];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", self.name];
}

#pragma mark - Setter
- (void)setAssetId:(NSString *)assetId {
    if (![_assetId isEqualToString:assetId]) {
        _assetId = assetId;
        [self setupStock];
    }
}

- (void)setStatusIdentifier:(NSString *)statusIdentifier {
    if (![_statusIdentifier isEqualToString:statusIdentifier]) {
        _statusIdentifier = statusIdentifier;
        [self setupStatusWithStatus:statusIdentifier];
    }
}

#pragma mark - Getter
+ (NSString *)Fields {
    return @"0|1|2|9|10|38|36|42|999";
}
- (NSString *)assetId {
    if (!_assetId) {
        _assetId = @"";
    }
    return _assetId;
}
- (NSString *)assetCode {
    if (!_assetCode) {
        _assetCode = @"";
    }
    return _assetCode;
}
- (NSString *)name {
    if (!_name) {
        _name = @"";
    }
    return _name;
}
- (NSString *)price {
    if (!_price) {
        _price = @"";
    }
    return _price;
}
- (NSString *)change {
    if (!_change) {
        _change = @"";
    }
    return _change;
}
- (NSString *)changePercent {
    if (!_changePercent) {
        _changePercent = @"";
    }
    return _changePercent;
}
- (NSString *)totalValue {
    if (!_totalValue) {
        _totalValue = @"";
    }
    return _totalValue;
}
- (NSString *)sType {
    if (!_sType) {
        _sType = @"0";
    }
    return _sType;
}
- (NSString *)statusIdentifier {
    if (!_statusIdentifier) {
        _statusIdentifier = @"-1";
    }
    return _statusIdentifier;
}

- (NSString *)lotSize {
    if (_lotSize) {
        return _lotSize;
    }else {
        return @"";
    }
}


@end
