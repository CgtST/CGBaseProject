//
//  IBXCache.m
//  QNApp
//
//  Created by xboker on 2017/5/12.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBXCache.h"
#import "YYCache.h"
#import <pthread.h>
#import "NSPathEx.h"
#import "IBTradeSingleTon.h"



//static NSString *const CahcheDicKey    = @"CahcheDicKey";
//static NSString *const CacheArrKey     = @"CacheArrKey";
//static NSString *const UncacheDicKey   = @"CahcheDicKey";
//static NSString *const UncacheArrKey   = @"CacheArrKey";



@interface IBXCache()
@property (nonatomic, strong) NSString *userDocPath;

@property (nonatomic, strong) NSString *tradeLoginPath;
@property (nonatomic, strong) NSString *tradeSonAccountPath;

@property (nonatomic, strong) NSDictionary *m_TradeUserDic;
@property (nonatomic, strong) NSArray      *m_TradeSonAccountsArr;



@end


@implementation IBXCache



- (void)encodeWithCoder:(NSCoder *)aCoder {
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}





#pragma mark    缓存一些可有可无的数据--YYCache缓存机制

- (void)setCacheWithArray:(NSArray *)dataArr withKey:(NSString *)cacheKey {
    pthread_mutex_t mutext = PTHREAD_MUTEX_INITIALIZER;
    pthread_mutex_lock(&mutext);
    YYCache *cache = [YYCache cacheWithName:cacheKey];
    if ([cache containsObjectForKey:cacheKey]) {
        [cache removeObjectForKey:cacheKey];
        [cache setObject:dataArr forKey:cacheKey];
    }else {
        [cache setObject:dataArr forKey:cacheKey];
    }
    pthread_mutex_unlock(&mutext);
    pthread_mutex_destroy(&mutext);

}



- (void)setCacheWithDictionary:(NSDictionary *)dataDic withKey:(NSString *)cacheKey {
    pthread_mutex_t mutext = PTHREAD_MUTEX_INITIALIZER;
    pthread_mutex_lock(&mutext);
    YYCache *cache = [YYCache cacheWithName:cacheKey];
    if ([cache containsObjectForKey:cacheKey]) {
        [cache removeObjectForKey:cacheKey];
        [cache setObject:dataDic forKey:cacheKey];
    }else {
        [cache setObject:dataDic forKey:cacheKey];
    }
    pthread_mutex_unlock(&mutext);
    pthread_mutex_destroy(&mutext);

}



- (NSArray *)getCacheArrayWithKey:(NSString *)cacheKey {
    @synchronized (self) {
        YYCache *cache  = [YYCache cacheWithName:cacheKey];
        if ([cache containsObjectForKey:cacheKey]) {
            return (NSArray *)[cache objectForKey:cacheKey];
        }else {
            return @[];
        }
    }
}






- (NSDictionary *)getCacheDictionaryWithKey:(NSString *)cacheKey {
    @synchronized (self) {
        YYCache *cache  = [YYCache cacheWithName:cacheKey];
        if ([cache containsObjectForKey:cacheKey]) {
            return (NSDictionary *)[cache objectForKey:cacheKey];
        }else {
            return @{};
        }
    }


}





///将读过的新闻ID缓存起来
- (void)setCacheTheReadedNewsWithArr:(NSMutableArray *)newsArr {
    pthread_mutex_t mutext = PTHREAD_MUTEX_INITIALIZER;
    pthread_mutex_lock(&mutext);
    YYCache *cache = [YYCache cacheWithName:CacheReadedNews];
    if ([cache containsObjectForKey:CacheReadedNews]) {
        [cache removeObjectForKey:CacheReadedNews];
        [cache setObject:newsArr forKey:CacheReadedNews];
    }else {
        [cache setObject:newsArr forKey:CacheReadedNews];
    }
    pthread_mutex_unlock(&mutext);
    pthread_mutex_destroy(&mutext);

}

///将读取过的新闻缓存ID取出
- (NSMutableArray *)getCacheReadedNews {
    @synchronized (self) {
        YYCache *cache  = [YYCache cacheWithName:CacheReadedNews];
        if ([cache containsObjectForKey:CacheReadedNews]) {
            return (NSMutableArray *)[cache objectForKey:CacheReadedNews];
        }else {
            return [NSMutableArray arrayWithCapacity:0];
        }
    }
}


///根据key值清除某个缓存
- (void)clearCacheWithKey:(NSString *)cacheKey {
    YYCache *cache = [YYCache cacheWithName:cacheKey];
    if ([cache containsObjectForKey:cacheKey]) {
        [cache removeObjectForKey:cacheKey];
    }
}

///清除所有根据YYCache缓存的数据
- (void)clearAllCache {
    
    
}

#pragma mark    缓存一些可有可无的数据--YYCache缓存机制






#pragma mark    缓存一些相对重要的数据--用户登录的信息包---归档(必要时加盐处理)

///交易时调用的方法
- (void)tradeLoginCacheWithDictionary:(NSDictionary *)user {
    if (![user isKindOfClass:[NSDictionary class]]) {
        user = @{};
    }
    [self archiverData:user withKey:TradeLogin withPath:self.tradeLoginPath];
    
}

///取出用户交易登录的信息包
- (NSDictionary *)getTradeLoginDic {
    if (self.m_TradeUserDic) {
        return self.m_TradeUserDic;
    }else {
        self.m_TradeUserDic = [self unArchiverWithKey:TradeLogin withPath:self.tradeLoginPath];
        return  self.m_TradeUserDic;
    }
 
}



///获取交易登录后可切换的子账号列表
- (NSArray *)getTradeSonAccounts {
    if (self.m_TradeSonAccountsArr) {
        return self.m_TradeSonAccountsArr;
    }else {
        self.m_TradeSonAccountsArr = [self unArchiverWithKey:TradeSonAccounts withPath:self.tradeSonAccountPath];
        return self.m_TradeSonAccountsArr;
    }
}

///交易登录调用缓存子账户的缓存方法
- (void)tradeLoginCacheSonAccountsWithArr:(NSArray *)account {
    if (![account isKindOfClass:[NSArray class]]) {
        account = @[];
    }
    [self archiverData:account withKey:TradeSonAccounts withPath:self.tradeSonAccountPath];
}






///交易退出登录时清除相关信息调用的方法
- (void)clearTradeLoginOut {
    self.m_TradeSonAccountsArr = nil;
    self.m_TradeUserDic = nil;
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:self.tradeLoginPath]) {
        [manager removeItemAtPath:self.tradeLoginPath error:nil];
        self.tradeLoginPath = nil;
    }
    if ([manager fileExistsAtPath:self.tradeSonAccountPath ]) {
        [manager removeItemAtPath:self.tradeSonAccountPath error:nil];
        self.tradeSonAccountPath = nil;
    }
    if ([manager fileExistsAtPath:self.userDocPath]) {
        [manager removeItemAtPath:self.userDocPath error:nil];
        self.userDocPath = nil;
    }
    
    [[IBTradeSingleTon shareTradeSingleTon].m_TradeAccounts removeAllObjects];
//     [IBGlobalMethod clearTradeUserDefaults];
}




- (void)iBSETLoginOut {
    
}
- (void)iBSETLoginCacheWithDictionary:(NSDictionary *)ibestUser {
    
}






#pragma mark    缓存一些相对重要的数据--用户登录的信息包---归档(必要时加盐处理)















#pragma mark    通用归档方法


- (void)archiverData:(id)data withKey:(NSString *)key withPath:(NSString *)path {
    if ([IBGlobalMethod isLogin] ) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            data = (NSDictionary *)data;
        }else if ([data isKindOfClass:[NSArray class]]) {
            data = (NSArray *)data;
        }else if ([data isKindOfClass:[NSString class]]){
            data = (NSString *)data;
        }else if ([data isKindOfClass:[NSSet class]]) {
            data = (NSSet *)data;
        }else {
            NSLog(@"其他数据结构不存储..");
            return;
        }
        NSFileManager *manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:path]) {
            [manager removeItemAtPath:path error:nil];
        }
        NSMutableData *muData = [NSMutableData data];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:muData];
        [archiver encodeObject:data forKey:key];
        [archiver finishEncoding];
        BOOL writeAction =  [muData writeToFile:path atomically:YES];
        if (writeAction) {
            NSLog(@"Archiver Success");
        }else {
            NSLog(@"Archiver Failed");
        }

    }
}


- (id )unArchiverWithKey:(NSString *)key withPath:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data) {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        id getData = [unarchiver decodeObjectForKey:key];
        [unarchiver finishDecoding];
        if ([getData isKindOfClass:[NSDictionary class]]) {
            return (NSDictionary *)getData;
        }else if ([getData isKindOfClass:[NSArray class]]) {
            return (NSArray *)getData;
        }else if ([getData isKindOfClass:[NSString class ]]){
            return (NSString *)getData;
        }else {
            return nil;
        }
    }else {
        return nil;
    }

}
#pragma mark    通用归档方法


#pragma mark    setter


- (NSString *)userDocPath {
    if (!_userDocPath)  {
        _userDocPath = [NSPathEx docPath];
        _userDocPath = [_userDocPath stringByAppendingPathComponent:@"archiverData"];
    }
    return _userDocPath;
}

- (NSString *)tradeLoginPath {
    if (!_tradeLoginPath) {
        _tradeLoginPath = [self.userDocPath stringByAppendingPathComponent:@"trade.fuck"];
        [[NSFileManager defaultManager] createDirectoryAtPath:_tradeLoginPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"archiver__path___%@", _tradeLoginPath);
    }
    return _tradeLoginPath;
}

- (NSString *)tradeSonAccountPath {
    if (!_tradeSonAccountPath) {
        _tradeSonAccountPath = [self.userDocPath stringByAppendingPathComponent:@"tradeSonAccount.fuck"];
        [[NSFileManager defaultManager] createDirectoryAtPath:_tradeSonAccountPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return _tradeSonAccountPath;
}





@end
