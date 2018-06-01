//
//  IBStock.m
//  iBestStandard
//
//  Created by bingo on 2018/5/15.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import "IBStock.h"

@implementation IBStock

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isTradable = YES;
        self.status = IBStockTradeStatusNormal;
        self.listingStatus = IBStockListingStatusListed;
    }
    return self;
}
- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[IBStock class]])
    {
        return [self.ID isEqualToString: ((IBStock *)object).ID];
    }
    return NO;
}

- (NSComparisonResult)compare:(IBStock *)other
{
    return [self.code compare:other.code];
}
#pragma mark - SETTER / GETTER
- (NSUInteger)hash
{
    return (NSUInteger)self.ID;
}
- (NSString *)description
{
    return [self.code stringByAppendingFormat:@" %@ ID:%@", self.name, self.ID];
}

- (void)setPrice:(NSString*)price
{
    if (![_price isEqualToString:price] )
    {
        _price = price;
        [self updatePercent];
    }
}
- (void)setLastClosePrice:(float)lastClosePrice
{
    if (lastClosePrice != _lastClosePrice)
    {
        _lastClosePrice = lastClosePrice;
        [self updatePercent];
    }
}
- (void)setStatus:(IBStockTradeStatus)status
{
    _status = status;
    
    NSString *string = nil;
    if (self.isTradable) {
        switch (status) {
            case IBStockTradeStatusNormal:
                string = nil;
                self.suspended = NO;
                break;
            case IBStockTradeStatusSuspend:
                string = CustomLocalizedString(@"QYITINGPA", nil);
                self.suspended = YES;
                break;
            case IBStockTradeStatusLimitDown:
                string = CustomLocalizedString(@"QDT", nil);
                break;
            case IBStockTradeStatusLimitUp:
                string = CustomLocalizedString(@"QZT", nil);
                break;
            case IBStockTradeStatusDelisted:
                string = CustomLocalizedString(@"QYITUISHI", nil);
                break;
            case IBStockTradeStatusIPO:
                string = CustomLocalizedString(@"QWEISHANGS", nil);
                break;
            default:
                string = CustomLocalizedString(@"QWEIZHI", nil);
                break;
        }
    }
    else {
        string = CustomLocalizedString(@"QZHANBZCJIAOYI", nil);
    }
    _simpleStatusDesc = string;
    string = [NSString stringWithFormat: @"%@ : %@", self.name, string];
    _statusDesc = string;
}
- (void)setSuspended:(BOOL)suspended
{
    if (_suspended != suspended) {
        _suspended = suspended;
        if (suspended) {
            self.status = IBStockTradeStatusSuspend;
        }
    }
}
- (void)setListingStatus:(IBStockListingStatus)listingStatus
{
    if (_listingStatus != listingStatus) {
        _listingStatus = listingStatus;
        if (listingStatus == IBStockListingStatusDelisted) {
            self.status = IBStockTradeStatusDelisted;
        } else if (listingStatus == IBStockListingStatusUnListing) {
            self.status = IBStockTradeStatusIPO;
        }
    }
}
- (void)updatePercent
{
    self.change = [self.price doubleValue] - self.lastClosePrice;
    if (self.lastClosePrice == 0)  {
        self.percent = 0.0f;
    }
    else  {
        self.percent = self.change * 100.0f / self.lastClosePrice;
    }
    if (_price == 0) {
        self.change = [self.price doubleValue] - self.lastClosePrice;
        self.percent = 0.0f;
    }
}

#pragma mark    xkp

- (NSString *)STOCKID {
    NSString *code = [self.ID componentsSeparatedByString: @"."][0];
    if ([self.ID hasSuffix:@".HK"] || [self.ID hasSuffix:@".hk"]) {
        return [NSString stringWithFormat:@"%05ld", [code integerValue]];
    }else {
        return [NSString stringWithFormat:@"%06ld", [code integerValue]];
    }
}


- (NSString *)MarketCode {
    if([self.ID hasSuffix:@"HK"]) {
        return @"XHKG";
    } else if ([self.ID hasSuffix:@"SH"]) {
        return @"XSSC";
    }else if ([self.ID hasSuffix:@"SZ"]) {
        return @"XSEC";
    }else {
        return @"";
    }
    
    
    
    //    if (self.ah == 1 || self.ah == 4) {
    //        return @"XHKG";
    //    }else if (self.ah == 2) {
    //        return @"XSSC";
    //    }else if (self.ah == 3) {
    //        return @"XSEC";
    //    }else {
    //        return @"";
    //    }
    
    
}


- (NSString *)MicCode {
    //    if (self.ah == 1 || self.ah == 4) {
    //        return @"XHKG";
    //    }else if (self.ah == 2) {
    //        return @"XSSC";
    //    }else if (self.ah == 3) {
    //        return @"XSEC";
    //    }else {
    //      return @"";
    //    }
    if([self.ID hasSuffix:@"HK"]) {
        return @"XHKG";
    } else if ([self.ID hasSuffix:@"SH"]) {
        return @"XSSC";
    }else if ([self.ID hasSuffix:@"SZ"]) {
        return @"XSEC";
    }else {
        return @"";
    }
    
}




#pragma mark    xkp


- (NSString *)code
{
    if (_code == nil) {
        _code = [self.ID componentsSeparatedByString: @"."][0];
    }
    return _code;
}
- (NSString *)symbol
{
    return self.code;
}
- (NSString *)name
{
    if ([super name] == nil) {
        self.name = self.cnName;
        return self.cnName;
    }
    return [super name];
}
- (BOOL)enableJoinPortfolio
{
    BOOL enable = (self.isTradable && (
                                       self.status == IBStockTradeStatusNormal));
    return enable;
}

- (void)setCorrValue:(int8_t)corrValue
{
    corrValue = MAX(0, MIN(100, corrValue));
    _corrValue = corrValue;
    
    [self willChangeValueForKey: @"corr"];
    if (_corrValue <= 33) {
        _corr = 1;
    }else if (_corrValue > 33 && _corrValue <= 66) {
        _corr = 2;
    }else {
        _corr = 3;
    }
    //    _corr = MAX(1, MIN(3 ,ceil((int8_t)(_corrValue / 33.33))));
    [self didChangeValueForKey: @"corr"];
}

-(void)setHldPrc:(NSString *)hldPrc{
    if (_hldPrc == nil) {
        _hldPrc = hldPrc;
    }
}


+ (IBStockMarketType)stockMarketTypeForMarketID:(uint8_t)marketID
{
    return IBStockMarketTypeChina;
}


- (void)decodeWebDic:(NSDictionary *)dic
{
    if (dic[@"id"]) {
        self.ID = dic[@"id"];
    }
    if (dic[@"c"]) {
        self.code = dic[@"c"];
    }
    if (dic[@"name"]) {
        self.name = dic[@"name"];
    }
    if (dic[@"mid"]) {
        self.marketID = [dic[@"mid"] integerValue];
    }else{
        self.marketID = DEFAULT_INTVALUE;
    }
    
    if (dic[@"zh"]) {
        self.cnName = dic[@"zh"];
    }
    if (dic[@"kws"]) {
        self.keywords = dic[@"kws"];
    }
    //没有此字段时默认为可交易,不设置此默认值当搜索股票时本地数据库没有回显示不可交易。
    if (dic[@"i"]) {
        self.isTradable = [dic[@"i"] integerValue];
    } else {
        self.isTradable = YES;
    }
    
    if (dic[@"type"]) {
        self.type = dic[@"type"];
    }
    
    self.price = decodePriceString(@"price", dic);
    
    if (dic[@"changePct"]) {
        self.percent = [dic[@"changePct"] doubleValue];
    }else{
        self.percent    = DEFAULT_DOUBLEVALUE;
    }
    
    if (dic[@"pe"]) {
        self.peRatio = [dic[@"pe"] doubleValue];
    }else{
        self.peRatio    = DEFAULT_DOUBLEVALUE;
    }
    
    if (dic[@"pb"]) {
        self.pbRatio = [dic[@"pb"] doubleValue];
    }else{
        self.pbRatio    = DEFAULT_DOUBLEVALUE;
    }
    
    
    if (dic[@"corr"]) {
        self.corrValue = [dic[@"corr"] integerValue];
    }else{
        self.corrValue = DEFAULT_INTVALUE;
    }
    
    
    if (dic[@"mktV"]) {
        self.mktValue = [dic[@"mktV"] doubleValue];
    }else{
        self.mktValue   = DEFAULT_DOUBLEVALUE;
    }
    
    
    if (dic[@"fMktV"]) {
        self.fMktValue = [dic[@"fMktV"] doubleValue];
    }else{
        self.fMktValue = DEFAULT_DOUBLEVALUE;
    }
    if (dic[@"eps"]) {
        self.eps = [dic[@"eps"] doubleValue];
    }else{
        self.eps       = DEFAULT_DOUBLEVALUE;
    }
    
    if (dic[@"pes"]) {
        self.pes = [dic[@"pes"] doubleValue];
    }else{
        self.pes       = DEFAULT_DOUBLEVALUE;
    }
    
    self.reportTime = decodePriceString(@"time", dic);
    
    self.relatedConcept = decodePriceString(@"relateCct", dic);
    
    self.profile = decodePriceString(@"pro", dic);
    
    if (dic[@"status"]) {
        self.status = (IBStockTradeStatus)[dic[@"status"] charValue];
    }
    if (dic[@"stype"]) {
        self.stype = dic[@"stype"];
    }
    
    if (dic[@"stkType"]) {
        NSInteger type = [dic[@"stkType"] integerValue];
        self.stype = [@(type) stringValue];
    }
    
    if (dic[@"fav"]) {
        if ([dic[@"fav"] isEqualToString:@"Y"]) {
            self.added = YES;
        }
    }
    
    self.hldPrc = decodePriceString(@"hldPrc", dic);
    
    [IBModeDecoder decodeDefaultDoubleToObj:&_hldYld KeyString:@"hldYld" FromDictonary:dic];
    
    
}
- (void)decodeStockListDic:(NSDictionary *)dic
{
    if (dic[@"id"]) {
        self.ID = dic[@"id"];
    }
    if (dic[@"mid"]) {
        self.marketID = [dic[@"mid"] integerValue];
    }
    if (dic[@"i"]) {
        self.isTradable = [dic[@"i"] integerValue];
    }
    if (dic[@"kws"]) {
        self.keywords = dic[@"kws"];
    }
    
    if (dic[@"c"]) {
        self.code = dic[@"c"];
    }
    
    if (dic[@"s"]) {
        self.suspended = [dic[@"s"] boolValue];
    }
    //若又有停牌又是未上市优先显示未上市
    if (dic[@"l"]) {
        self.uintStockNum = [NSString stringWithFormat:@"%ld", [dic[@"l"] integerValue]];
    }
    if (dic[@"t"]) {
        self.stype = [dic[@"t"] stringValue];
    }
    if (dic[@"e"]) {
        self.delisted = [dic[@"e"] integerValue];
    }
    if (dic[@"zh"]) {
        self.cnName = dic[@"zh"];
    }
    if (dic[@"lts"]) {
        self.listingTime = [[dic[@"lts"] stringValue] longLongValue];
    }
    if (dic[@"ah"]) {
        self.ah = [dic[@"ah"] integerValue];
    }
}

@end
