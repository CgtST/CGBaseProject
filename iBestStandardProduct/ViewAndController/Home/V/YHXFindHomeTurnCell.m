//
//  YHXFindHomeTurnCell.m
//  Yihaoqianbao
//
//  Created by CPZX010 on 2016/11/8.
//  Copyright © 2016年 Money. All rights reserved.
//

#import "YHXFindHomeTurnCell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
//#import "IBXHelpers.h"

@interface YHXFindHomeTurnCell()

@property (weak, nonatomic) IBOutlet  UIImageView *imageV;

@end

@implementation YHXFindHomeTurnCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageV.contentMode =UIViewContentModeScaleAspectFit & UIViewContentModeBottom;
}


- (void)cellDisplayWithDataSource:(NSMutableArray *)dataSource withIndexPath:(NSIndexPath *)indexPath {
    if (dataSource.count >= indexPath.row && dataSource.count) {
        if (indexPath.row == dataSource.count) {
        id image = dataSource[0];
            if ([image isKindOfClass:[NSDictionary class]]) {
                NSString *imageStr = [IBXHelpers getStringWithDictionary:image andForKey:@"headimg"];
            [self.imageV setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"turn_placehodler"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            }else {
                self.imageV.image = image;
            }
    }else {
         id image = dataSource[indexPath.row];
            if ([image isKindOfClass:[NSDictionary class]]) {
                NSString *imageStr = [IBXHelpers getStringWithDictionary:image andForKey:@"headimg"];
                [self.imageV setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"turn_placehodler"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            }else {
                self.imageV.image = image;
            }
        }
    }
}





@end
