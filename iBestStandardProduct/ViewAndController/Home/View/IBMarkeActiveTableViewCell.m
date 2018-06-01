//
//  IBMarkeActiveTableViewCell.m
//  QNApp
//
//  Created by iBest on 2017/3/9.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBMarkeActiveTableViewCell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
//#import "IBXHelpers.h"
#import "IBTopLabel.h"

#import "IBXCache.h"
#import "NSDate+Additions.h"
#import "IBTradeSingleTon.h"
//#import "UIView+TouchTransmit.h"

@interface IBMarkeActiveTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *m_Image;
@property (weak, nonatomic) IBOutlet UILabel *m_Code;
@property (weak, nonatomic) IBOutlet UILabel *m_Date;

@property (weak, nonatomic) IBOutlet UILabel *m_StockName;
@property (weak, nonatomic) IBOutlet UILabel *m_StockID;
@property (weak, nonatomic) IBOutlet UIView *m_Index;


//@property (nonatomic, strong) NSArray         *m_ReadedNews;


@end

@implementation IBMarkeActiveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dk_backgroundColorPicker = DKColorPickerWithKey(QContentColor);
    self.m_Des.dk_textColorPicker = DKColorPickerWithKey(TextColor);
    self.m_Index.dk_backgroundColorPicker = DKColorPickerWithKey(SeperateLine);
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.m_Code.userInteractionEnabled = YES;
    self.m_Date.userInteractionEnabled = YES;
    self.m_StockID.userInteractionEnabled = YES;
    self.m_StockName.userInteractionEnabled = YES;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (IBMarkeActiveTableViewCell *)shareCellWithTableView:(UITableView *)tableView {
    IBMarkeActiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IBMarkeActiveTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"IBMarkeActiveTableViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}


- (void)displayPropertyCellWithData:(NSArray *)data withIndexPath:(NSIndexPath *)path  withIsReadedArr:(NSArray *)readedArr {
    WEAKSELF
    if (data.count > path.row) {
        NSDictionary *dic = data[path.row];
        NSString *newID = [IBXHelpers getStringWithDictionary:dic andForKey:@"id"];
        if ([readedArr containsObject:newID]) {
            self.m_Des.textColor = [UIColor colorWithHexString:@"#999999"];
            
        }else {
            self.m_Des.dk_textColorPicker = DKColorPickerWithKey(TextColor);

        }
        self.m_Image.contentMode = UIViewContentModeScaleAspectFill;
        self.m_Image.clipsToBounds = YES;
        [self.m_Image setContentScaleFactor:9.0/7.0];
        self.m_Image.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        
        
        NSString *name = [IBXHelpers getStringWithDictionary:dic andForKey:@"stockName"];
        NSString *code = [IBXHelpers getStringWithDictionary:dic andForKey:@"assetId"];
        
        
        
        NSString *image = [IBXHelpers getStringWithDictionary:dic andForKey:@"headimg"];
        NSString *infor = [IBXHelpers getStringWithDictionary:dic andForKey:@"infoTitle"];
        //NSString *time = [IBXHelpers getStringWithDictionary:dic andForKey:@"infoPublDate"];
        
        //NSTimeInterval interval = [time longLongValue] /1000;
        //NSString * timeStr = [NSDate timerShaftStringWithTimeStamp:interval];
        
        if (image.length) {
//            [self.m_Image setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"zhanwei"] options:SDWebImageContinueInBackground usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [self.m_Image setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"zhanwei"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!error) {
                        weakSelf.m_Image.image = image;
                    }
                });
            } usingActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
            self.m_StockName.text = @"";
            self.m_StockID.text = @"";
        }else {
            self.m_StockName.text = name;
            self.m_StockID.text = code;
        }

        self.m_Des.text = infor;
        ///暂时不现实时间
        self.m_Date.text = @"";
        self.m_Code.hidden = YES;
    }
}




- (void)displayMarketActitvityCellWithData:(NSArray *)data withIndexPath:(NSIndexPath *)path  withIsReadedArr:(NSArray *)readedArr{
    if (data.count > path.row) {
        NSDictionary *dic = data[path.row];
        NSString *newID = [IBXHelpers getStringWithDictionary:dic andForKey:@"id"];
        if ([readedArr containsObject:newID]) {
            self.m_Des.textColor = [UIColor colorWithHexString:@"#999999"];
        }else {
            self.m_Des.dk_textColorPicker = DKColorPickerWithKey(TextColor);
        }
        
        
        NSString *image = [IBXHelpers getStringWithDictionary:dic andForKey:@"headImg"];
        NSString *infor = [IBXHelpers getStringWithDictionary:dic andForKey:@"infoTitle"];
        NSString *time = [IBXHelpers getStringWithDictionary:dic andForKey:@"infoPublDate"];
        NSString *name = [IBXHelpers getStringWithDictionary:dic andForKey:@"stockName"];
        NSString *code = [IBXHelpers getStringWithDictionary:dic andForKey:@"assetId"];
        
        
        
        NSTimeInterval interval = [time longLongValue] /1000;
        NSString * timeStr = [NSDate timerShaftStringWithTimeStamp:interval];
        
        

        WEAKSELF
        if (image.length) {
//            [self.m_Image setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"zhanwei"] options:SDWebImageContinueInBackground usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

            [self.m_Image setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"zhanwei"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!error) {
                        weakSelf.m_Image.image = image;
                    }
                });
            } usingActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
//      [self.m_Image setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"zhanwei"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            self.m_StockName.text = @"";
            self.m_StockID.text = @"";
        }else {
            self.m_StockName.text = name;
            self.m_StockID.text = code;
        }
        
        
        self.m_Des.text = infor;
        self.m_Date.text = timeStr;
        self.m_Code.text = [IBXHelpers getStringWithDictionary:dic andForKey:@"media"];
    }
}


- (void)displayStockLevelCellWithData:(NSArray *)data withIndexPath:(NSIndexPath *)path  withIsReadedArr:(NSArray *)readedArr{
    if (data.count > path.row) {
        WEAKSELF
        NSDictionary *dic = data[path.row];
        NSString *newID = [IBXHelpers getStringWithDictionary:dic andForKey:@"id"];
        if ([readedArr containsObject:newID]) {
            //            self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
            self.m_Des.textColor = [UIColor colorWithHexString:@"#999999"];
        }else {
            self.m_Des.dk_textColorPicker = DKColorPickerWithKey(TextColor);
            //            self.contentView.backgroundColor = [UIColor whiteColor];
        }
        NSString *image = [IBXHelpers getStringWithDictionary:dic andForKey:@"headImg"];
        NSString *infor = [IBXHelpers getStringWithDictionary:dic andForKey:@"infoTitle"];
        NSString *time = [IBXHelpers getStringWithDictionary:dic andForKey:@"infoPublDate"];
        NSString *name = [IBXHelpers getStringWithDictionary:dic andForKey:@"stockName"];
        NSString *code = [IBXHelpers getStringWithDictionary:dic andForKey:@"assetId"];
        
        NSTimeInterval interval = [time longLongValue] /1000;
        NSString * timeStr = [NSDate timerShaftStringWithTimeStamp:interval];
        
        if (image.length) {
//        [self.m_Image setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"zhanwei"] options:SDWebImageContinueInBackground usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [self.m_Image setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"zhanwei"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!error) {
                        weakSelf.m_Image.image = image;
                    }
                });
            } usingActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
            self.m_StockName.text = @"";
            self.m_StockID.text = @"";
        }else {
            self.m_StockName.text = name;
            self.m_StockID.text = code;
        }
        self.m_Des.text = infor;
        self.m_Date.text = timeStr;
        self.m_Code.text = [IBXHelpers getStringWithDictionary:dic andForKey:@"media"];
    }
}



///热门资讯
- (void)displayChoicenessInformationCellWithData:(NSArray *)data withIndexPath:(NSIndexPath *)path withIsReadedArr:(NSArray *)readedArr {
    if (data.count > path.row) {
        WEAKSELF
        NSDictionary *dic = data[path.row];
        NSString *newID = [IBXHelpers getStringWithDictionary:dic andForKey:@"id"];
        if ([readedArr containsObject:newID]) {
            self.m_Des.textColor = [UIColor colorWithHexString:@"#999999"];
        }else {
            self.m_Des.dk_textColorPicker = DKColorPickerWithKey(TextColor);
        }
        NSString *image = [IBXHelpers getStringWithDictionary:dic andForKey:@"headimg"];
        NSString *infor = [IBXHelpers getStringWithDictionary:dic andForKey:@"infoTitle"];
        NSString *time = [IBXHelpers getStringWithDictionary:dic andForKey:@"infoPublDate"];
        NSString *source = [IBXHelpers getStringWithDictionary:dic andForKey:@"tags"];
        
        NSString *name = [IBXHelpers getStringWithDictionary:dic andForKey:@"stockName"];
        NSString *code = [IBXHelpers getStringWithDictionary:dic andForKey:@"assetId"];
        
        
        NSTimeInterval interval = [time longLongValue] /1000;
        NSString * timeStr = [NSDate timerShaftStringWithTimeStamp:interval];
        
        
        if (image.length) {
            [self.m_Image setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"zhanwei"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!error) {
                        weakSelf.m_Image.image = image;
                    }
                });
            } usingActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
            self.m_StockName.text = @"";
            self.m_StockID.text = @"";
        }else {
            self.m_StockName.text = name;
            self.m_StockID.text = code;
        }
        self.m_Des.text = infor;
        self.m_Date.text = timeStr;
        if ([source containsString:@","] ) {
            self.m_Code.text = [source stringByReplacingOccurrencesOfString:@"," withString:@" "];
        }else {
            self.m_Code.text = source;
        }
    }
}


    
- (void)dealloc {
    NSLog(@"[%@---------------dealloc]", self.class);
}






@end
