//
//  NSPathEx.h
//  Stock
//  这个类谢昆鹏在用, 请不要随意更改
//  Created by manny on 13-5-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSPathEx : NSObject 
{

}

+ (NSString *)homePath;
+ (NSString *)tempPath;
+ (NSString *)docPath;
+ (NSString *)appPath;
@end
