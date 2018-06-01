//
//  QNLaunchingVCViewModel.h
//  QNApp
//
//  Created by tj on 11/10/15.
//  Copyright © 2015 Bacai. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IBLaunchingVCViewModel : NSObject

//是否需要显示程序起始的4张过渡页面
@property (nonatomic, assign, readonly) BOOL neededShowGuidanceViewController;

- (void)IBAutoLoginFromLaunchingView:(void(^)(BOOL loginResult))resultBlock;
@end
