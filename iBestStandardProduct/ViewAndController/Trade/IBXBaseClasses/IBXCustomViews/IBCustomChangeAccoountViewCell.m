//
//  IBCustomChangeAccoountViewCell.m
//  QNApp
//
//  Created by xboker on 2017/4/14.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBCustomChangeAccoountViewCell.h"
//#import "IBXHelpers.h"

@interface IBCustomChangeAccoountViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *m_Default;
@property (weak, nonatomic) IBOutlet UIImageView *m_Choose;

@end
@implementation IBCustomChangeAccoountViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.m_Account.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

+ (IBCustomChangeAccoountViewCell *)shareCellWithTableView:(UITableView *)tableView {
    IBCustomChangeAccoountViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IBCustomChangeAccoountViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"IBCustomChangeAccoountViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}


//
//- (void)displayCellWithData:(NSArray *)data withIndexPath:(NSIndexPath *)path {
//    if (data.count > path.row) {
//        NSDictionary *dic = data[path.row];
//        NSString *ACCT = [IBXHelpers getStringWithDictionary:dic andForKey:@"ACCT"];
//        NSString *TRAC = [IBXHelpers getStringWithDictionary:dic andForKey:@"TRAC"];
//        BOOL defa = [[IBXHelpers getStringWithDictionary:dic andForKey:@"default"] boolValue];
//        BOOL chooose =  [[IBXHelpers getStringWithDictionary:dic andForKey:@"choose"] boolValue];

//        NSString *typeStr;
//        if ([ACCT isEqualToString:@"F"]) {
//            typeStr = @"期货账户";
//        }else if ([ACCT isEqualToString:@"C"]) {
//            typeStr = @"现金账户";
//        }else if ([ACCT isEqualToString:@"M"]) {
//            typeStr = @"孖展账户";
//        }else if ([ACCT isEqualToString:@"S"]) {
//            typeStr = @"沽空账户";
//        }else if ([ACCT isEqualToString:@"I"]) {
//            typeStr = @"IPO账户";
//        }else if ([ACCT isEqualToString:@"O"]) {
//            typeStr = @"Securities Option";
//        }
//        self.m_Account.text = [NSString stringWithFormat:@"%@  %@", typeStr, TRAC];
//        if (defa) {
//            self.m_Default.hidden = NO;
//        }else {
//            self.m_Default.hidden = YES;
//        }
//        if (chooose) {
//            self.m_Choose.hidden = NO;
//            self.m_Account.textColor = [UIColor colorWithHexString:@"#FB6131"];
//        }else {
//            self.m_Account.textColor = [UIColor colorWithHexString:@"#333333"];
//            self.m_Choose.hidden = YES;
//        }
//    }
//}





#pragma mark    新逻辑
- (void)displayCellWithData:(NSArray *)data withIndexPath:(NSIndexPath *)path {
    if (data.count > path.row) {
        NSDictionary *dic = data[path.row];
        NSString *ACCT = [[IBXHelpers getStringWithDictionary:dic andForKey:@"ACTP"] componentsSeparatedByString:@","].firstObject;
        NSString *TRAC = [IBXHelpers getStringWithDictionary:dic andForKey:@"ACID"];
        
        
        BOOL defa = [[IBXHelpers getStringWithDictionary:dic andForKey:@"default"] boolValue];
        BOOL chooose =  [[IBXHelpers getStringWithDictionary:dic andForKey:@"choose"] boolValue];
        
        NSString *typeStr;
        if ([ACCT isEqualToString:@"F"]) {
            typeStr = CustomLocalizedString(@"QIHUOZHANGHU", nil);
        }else if ([ACCT isEqualToString:@"C"]) {
            typeStr = CustomLocalizedString(@"XIANJINZHANGHU", nil);
        }else if ([ACCT isEqualToString:@"M"]) {
            typeStr = CustomLocalizedString(@"MAZHANZHANGHU", nil);
        }else if ([ACCT isEqualToString:@"S"]) {
            typeStr = CustomLocalizedString(@"GUKONGZHANGHU", nil);
        }else if ([ACCT isEqualToString:@"I"]) {
            typeStr = CustomLocalizedString(@"IPOZHANGHU", nil);
        }else if ([ACCT isEqualToString:@"O"]) {
            typeStr = @"Securities Option";
        }
        self.m_Account.text = [NSString stringWithFormat:@"%@  %@", typeStr, TRAC];
        if (defa) {
            self.m_Default.hidden = NO;
        }else {
            self.m_Default.hidden = YES;
        }
        if (chooose) {
            self.m_Choose.hidden = NO;
            self.m_Account.textColor = [UIColor colorWithHexString:@"#FB6131"];
        }else {
            self.m_Account.textColor = [UIColor colorWithHexString:@"#333333"];
            self.m_Choose.hidden = YES;
        }
    }
}










- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    NSLog(@"[%@---------dealloc]", self.class);
}




@end
