//
//  IBUserData.m
//  iBestStandard
//
//  Created by bingo on 2018/5/16.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import "IBUserData.h"

@implementation IBUserData


-(instancetype)init
{
    self = [super init];
    if(self){
        
    }
    return self;
    
}



- (void)decodeUserDataWithWebDic:(NSDictionary *)dic
{

    if (dic[@"mfTradeAccount"]) { //外汇交易账号
        self.mfTradeAccount = dic[@"mfTradeAccount"];
    }else{
        self.mfTradeAccount = @"";
    }
    if (dic[@"pmTradeAccount"]) { //贵金属交易账号
        self.pmTradeAccount = dic[@"pmTradeAccount"];
    }else{
        self.pmTradeAccount = @"";
    }
    
    if (dic[@"userFlag"]) {
        self.userFlag = [IBGlobalMethod changeStringWithId: dic[@"userFlag"]] ;
    }
    
    self.phoneNumber = [IBModeDecoder decodeKeyString:@"phoneNum" FromDictonary:dic];
   

    if(dic[@"isLv2Vip"])
    {
        self.isLevelTwo = [dic[@"isLv2Vip"] stringValue];
    }
    
    if(dic[@"inviteCode"])
    {
        self.inviteCode = dic[@"inviteCode"] ;
    }
    
  
    self.imId = [IBModeDecoder decodeKeyString:@"imId" FromDictonary:dic];
    self.imPassword = [IBModeDecoder decodeKeyString:@"imPwd" FromDictonary:dic];
    

}


@end
