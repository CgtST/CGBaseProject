//
//  QNLaunchingVCViewModel.m
//  QNApp
//
//  Created by tj on 11/10/15.
//  Copyright © 2015 Bacai. All rights reserved.
//

#import "IBLaunchingVCViewModel.h"

@implementation IBLaunchingVCViewModel

#pragma mark - Public

- (void)IBAutoLoginFromLaunchingView:(void(^)(BOOL loginResult))resultBlock
{
    [sharedIBUserSystemManager() IBAutoLogin:^(BOOL loginResult) {
        dispatch_async(dispatch_get_main_queue(), ^{
            resultBlock(loginResult);
        });
    }];
}

#pragma mark – getter/setter
- (BOOL)neededShowGuidanceViewController {
   return ![[NSUserDefaults standardUserDefaults] boolForKey:kNeededShowGuidanceKey];
}

@end
