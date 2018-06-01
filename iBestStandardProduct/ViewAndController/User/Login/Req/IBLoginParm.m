//
//  QNLoginParm.m
//  QNApp
//
//  Created by tj on 11/11/15.
//  Copyright © 2015 Bacai. All rights reserved.
//

#import "IBLoginParm.h"

@interface IBLoginParm ()

@end

@implementation IBLoginParm


- (instancetype)initWithCertType:(IBCertType)certType
                        certCode:(NSString *)certCode
                        password:(NSString *)password
                           token:(NSString *)token
                           appID:(NSString *)appID
                        areaType:(IBAreaType) areaType
               hasCheckNewDevice:(BOOL)hasCheckNewDevice
                    tradeAccount:(NSString *)tradeAccount
{
    self = [super init];
    if (self) {
        self.certType = certType;
        self.certCode = certCode;
        self.pwd = password;
        self.token = token;
        self.appID = appID;
        self.areaType = areaType;
        self.hasCheckNewDevice = hasCheckNewDevice;
        self.tradeAccount = tradeAccount;
    }
    return self;
}

@end
