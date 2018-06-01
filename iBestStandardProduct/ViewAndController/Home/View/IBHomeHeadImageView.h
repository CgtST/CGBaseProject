//
//  IBHomeHeadImageView.h
//  QNApp
//
//  Created by iBest on 2017/3/10.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IBHomeHeadImageView;

@protocol IBHomeHeadImageViewDelegate <NSObject>
@optional
- (void)homeImageView:(IBHomeHeadImageView *)homeImageView didTapImageWithIndex:(NSInteger)index;

-(void)clickHomeTopButtonAction:(NSInteger)tag;

@end

@interface IBHomeHeadImageView : UITableViewCell

+ (IBHomeHeadImageView *)homeImageView;

@property(nonatomic, weak) id<IBHomeHeadImageViewDelegate> delegate;

- (void)setImages:(NSArray *)picList;
- (void)setLocalImages:(NSArray *)imageName;


@end
