//
//  IBXCache.h
//  QNApp
//  本地化存储用的类, 用于存储一些数据,防止
//  Created by xboker on 2017/5/12.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBXCache : NSObject<NSCoding>


#pragma mark    缓存一些可有可无的数据--YYCache缓存机制
///根据key值取出原先缓存的字典
- (NSDictionary *)getCacheDictionaryWithKey:(NSString *)cacheKey;
///根据key值取出原先缓存的数组
- (NSArray *)getCacheArrayWithKey:(NSString *)cacheKey;
///传入key值缓存字典
- (void)setCacheWithDictionary:(NSDictionary *)dataDic withKey:(NSString *)cacheKey;
///传入key值缓存数组
- (void)setCacheWithArray:(NSArray *)dataArr withKey:(NSString *)cacheKey;
///根据key值清除某个缓存
- (void)clearCacheWithKey:(NSString *)cacheKey;
///将读过的新闻ID缓存起来<有可能是一个H5的链接>
- (void)setCacheTheReadedNewsWithArr:(NSMutableArray *)newsArr;
///将读取过的新闻缓存ID取出
- (NSArray *)getCacheReadedNews;

///清除所有根据YYCache缓存的数据
- (void)clearAllCache;
#pragma mark    缓存一些可有可无的数据--YYCache缓存机制








#pragma mark    缓存一些相对重要的数据--用户登录的信息包---归档(必要时加盐处理)

///取出用户交易登录的信息包
- (NSDictionary *)getTradeLoginDic;
///获取交易登录后可切换的子账号列表
- (NSArray *)getTradeSonAccounts;




///iBEST登录时调用的存储方法
- (void)iBSETLoginCacheWithDictionary:(NSDictionary *)ibestUser;
///iBEST退出时调用的存储方法
- (void)iBSETLoginOut;


///交易退出登录时清除相关信息调用的方法
- (void)clearTradeLoginOut;
///交易时调用的方法---存储用户登录的信息包
- (void)tradeLoginCacheWithDictionary:(NSDictionary *)user;
///交易登录调用缓存子账户的缓存方法
- (void)tradeLoginCacheSonAccountsWithArr:(NSArray *)account;




#pragma mark    缓存一些相对重要的数据--用户登录的信息包---归档(必要时加盐处理)









#pragma mark    快速获取一些信息的属性


















#pragma mark    快速获取一些信息的属性


@end
