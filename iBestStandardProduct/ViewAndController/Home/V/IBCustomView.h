//
//  IBCustomView.h
//  IBSliderView
//
//  Created by xboker on 2017/3/18.
//  Copyright © 2017年 xboker. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CustomViewTapType) {
    CustomViewTapTypeActionPersonCenter = 0,
    CustomViewTapTypeActionSearchStock,
    CustomViewTapTypeActionMessage
};


@protocol IBCustomViewDelegate <NSObject>
@required
- (void)ibTapedIBCustomWithtype:(CustomViewTapType)type;

@end



@interface IBCustomView : UIView
@property (nonatomic, weak) id<IBCustomViewDelegate>delegate;


- (void)ibTransferOffset:(CGFloat)offset;
- (void)ibLastOffset:(CGFloat)offset;

- (void)layoutTheImagesWithCount:(NSInteger )count;


+ (IBCustomView *)shareFadeView;





@end
