//
//  IBXMenuChooseViewCell.m
//  QNApp
//  高度-45
//  Created by xboker on 2017/3/31.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBXMenuChooseViewCell.h"
#import "IBFXQuoteConfigJsonModel.h"


#define k_CellWidth     self.bounds.size.width

@implementation IBXMenuChooseViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
    if (selected) {
        self.imageView.image = [UIImage imageNamed:@"trade_hadselected"];
    }
    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.imageView.frame = CGRectMake(k_CellWidth - 37 , 11, 22, 22);
        self.textLabel.frame = CGRectMake(15, 0, k_CellWidth - 60, 45);
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(10, 44, k_CellWidth - 10, 1)];
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.textColor = [UIColor darkGrayColor];
        v.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [self.contentView addSubview:v];
    }
    return self;
}



+ (IBXMenuChooseViewCell *)shareCellWithTableView:(UITableView *)tableView {
    IBXMenuChooseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IBXMenuChooseViewCell"];
    if (!cell) {
        cell = [[IBXMenuChooseViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IBXMenuChooseViewCell"];
    }
    return cell;
}


//不再使用
- (void)displayCellWithData:(NSArray *)data withIndexPath:(NSIndexPath *)path {
    if (data.count > path.row) {
        if ([data[path.row] isKindOfClass:[NSString class]]) {
            self.textLabel.text = data[path.row];
        }else if ([data[path.row] isKindOfClass:[NSDictionary class]]) {///一个个的交易子账户
            NSDictionary *accountDic = data[path.row];
            //NSString *account = [IBXHelpers getStringWithDictionary:accountDic andForKey:@"TRAC"];
            NSString *ACCT = [IBXHelpers getStringWithDictionary:accountDic andForKey:@"ACCT"];
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
                typeStr = CustomLocalizedString(@"FX_BU_GUPIAOQIQUAN", nil);
            }
            
            self.textLabel.text = [NSString stringWithFormat:@"%@   %@", typeStr, accountDic];
        }
    }
}



/**
 资金提取时的账户                    0
 资金提取时的市场                    1
 资金提取时的收款银行                 2
 账户转账时的转出账户                 3
 账户转账时的转出市场                 4
 账户转账时的转入账户                 5
 账户转账时的转入市场                 6
 股票转仓时选择某一支股票              7
 外汇交易下单界面选择合约              8
 外汇交易下单界面选择条件期限           9
 外汇交易下单界面选择订单期限          10
 贵金属交易下单界面选择合约            11
 
 */
- (void)displayCellWithData:(NSArray *)data withIndexPath:(NSIndexPath *)path withType:(NSInteger)type {
    if (data.count > path.row) {
        switch (type) {
            case 0: {//资金提取时的账户
                NSDictionary *accountDic = data[path.row];
                NSString *ACID = [IBXHelpers getStringWithDictionary:accountDic andForKey:@"ACID"];
                NSString *ACTPString = [IBXHelpers getStringWithDictionary:accountDic andForKey:@"ACTP"];
                NSString *ACCT;
                if ([ACTPString containsString:@","]) {
                    ACCT = [ACTPString componentsSeparatedByString:@","].firstObject;
                }else {
                    ACCT = ACTPString;
                }
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
                    typeStr = CustomLocalizedString(@"FX_BU_GUPIAOQIQUAN", nil);
                }
                self.textLabel.text = [NSString stringWithFormat:@"%@   %@", typeStr, ACID];
                break;
            }
            case 1: {// 资金提取时的市场
                
                NSDictionary *marketDic = data[path.row];
                NSString *market = [IBXHelpers getStringWithDictionary:marketDic andForKey:@"market"];
                if ([market isEqualToString:@"HK"]) {
                    self.textLabel.text = CustomLocalizedString(@"XIANGGANGJIAGUSHICHANG", nil);
                }else if ([market isEqualToString:@"GENERAL"]) {
                    self.textLabel.text = CustomLocalizedString(@"TRADE_QITASHICHANG", nil);
                }else if([market isEqualToString:@"US"]) {
                    self.textLabel.text = CustomLocalizedString(@"TRADE_MEIGUOSHICHANG", nil);
                }else if ([market isEqualToString:@"BSHARE"]) {
                    self.textLabel.text = CustomLocalizedString(@"TRADE_ZHONGGUOBGUSHICHANG", nil);
                }
                    break;
            }
            case 2: {//资金提取时的收款银行
                NSDictionary *bankDic = data[path.row];
                NSString *BKNM = [IBXHelpers getStringWithDictionary:bankDic andForKey:@"BKNM"];
                NSString *BAAC = [IBXHelpers getStringWithDictionary:bankDic andForKey:@"BAAC"];
                self.textLabel.text = [NSString stringWithFormat:@"%@  %@", BKNM, BAAC];
                break;
            }
            case 3: {//  账户转账时的转出账户
                NSDictionary *accountDic = data[path.row];
                NSString *ACID = [IBXHelpers getStringWithDictionary:accountDic andForKey:@"ACID"];
                NSString *ACTPString = [IBXHelpers getStringWithDictionary:accountDic andForKey:@"ACTP"];
                NSString *ACCT;
                if ([ACTPString containsString:@","]) {
                    ACCT = [ACTPString componentsSeparatedByString:@","].firstObject;
                }else {
                    ACCT = ACTPString;
                }
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
                    typeStr = CustomLocalizedString(@"FX_BU_GUPIAOQIQUAN", nil);
                }
                self.textLabel.text = [NSString stringWithFormat:@"%@   %@", typeStr, ACID];
                break;
            }
            case 4: {// 账户转账时的转出市场
                NSDictionary *marketDic = data[path.row];
                NSString *market = [IBXHelpers getStringWithDictionary:marketDic andForKey:@"market"];
                NSString *CCY = [IBXHelpers getStringWithDictionary:marketDic andForKey:@"CCY"];
                if ([market isEqualToString:@"HK"]) {
                    self.textLabel.text = [NSString stringWithFormat:@"%@  %@",CustomLocalizedString(@"XIANGGANGJIAGUSHICHANG", nil), CCY];
                }else if ([market isEqualToString:@"GENERAL"]) {
                    self.textLabel.text = [NSString stringWithFormat:@"%@  %@",CustomLocalizedString(@"TRADE_QITASHICHANG", nil), CCY];
                    
                }else if([market isEqualToString:@"US"]) {
                    self.textLabel.text = [NSString stringWithFormat:@"%@  %@",CustomLocalizedString(@"TRADE_MEIGUOSHICHANG", nil), CCY];
                    
                }else if ([market isEqualToString:@"BSHARE"]) {
                    self.textLabel.text = [NSString stringWithFormat:@"%@  %@",CustomLocalizedString(@"TRADE_ZHONGGUOBGUSHICHANG", nil), CCY];
                }
                break;
            }
            case 5: {// 账户转账时的转入账户
                NSDictionary *accountDic = data[path.row];
                NSString *ACID = [IBXHelpers getStringWithDictionary:accountDic andForKey:@"ACID"];
                NSString *ACTPString = [IBXHelpers getStringWithDictionary:accountDic andForKey:@"ACTP"];
                NSString *ACCT;
                if ([ACTPString containsString:@","]) {
                    ACCT = [ACTPString componentsSeparatedByString:@","].firstObject;
                }else {
                    ACCT = ACTPString;
                }
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
                    typeStr = CustomLocalizedString(@"FX_BU_GUPIAOQIQUAN", nil);
                }
                self.textLabel.text = [NSString stringWithFormat:@"%@   %@", typeStr, ACID];
                break;
            }
            case 6: {// 账户转账时的转入市场 
                NSString *market = data[path.row];
                if ([market isEqualToString:@"HK"]) {
                    self.textLabel.text = CustomLocalizedString(@"XIANGGANGJIAGUSHICHANG", nil);
                }else if ([market isEqualToString:@"GENERAL"]) {
                    self.textLabel.text = CustomLocalizedString(@"TRADE_QITASHICHANG", nil);
                    
                }else if([market isEqualToString:@"US"]) {
                    self.textLabel.text = CustomLocalizedString(@"TRADE_MEIGUOSHICHANG", nil);
                }else if ([market isEqualToString:@"BSHARE"]) {
                    self.textLabel.text = CustomLocalizedString(@"TRADE_ZHONGGUOBGUSHICHANG", nil);
                }
                break;
            }
            case 7: {//股票转仓时选择持仓的某一只股票
                IBTradeCustomStock *stock = data[path.row];
                self.textLabel.textAlignment = NSTextAlignmentCenter;
                self.textLabel.text = [NSString stringWithFormat:@"%@  %@  %@:%@", stock.INNA, stock.INCDPLUS,CustomLocalizedString(@"TRADE_POSITION", nil), stock.MSQTPLUS];
                break;
            }
            case 8: {///外汇交易下单界面选择合约
                IBFXQuoteConfigJsonModel *model = data[path.row];
                self.textLabel.textAlignment = NSTextAlignmentCenter;
                self.textLabel.font = [UIFont systemFontOfSize:19];
                self.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
                self.textLabel.text = model.currencyPair;
                NSLog(@"%@________________________", model.targetNameChinese);
                break;
            }
            case 9: {/// 外汇交易下单界面选择条件期限
                self.textLabel.textAlignment = NSTextAlignmentCenter;
                self.textLabel.font = [UIFont systemFontOfSize:19];
                self.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
                NSDictionary *dic = data[path.row];
                self.textLabel.text = [dic allValues].firstObject;
                break;
            }
            case 10: {/// 外汇交易下单界面选择订单期限          
                self.textLabel.textAlignment = NSTextAlignmentCenter;
                self.textLabel.font = [UIFont systemFontOfSize:19];
                self.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
                NSDictionary *dic = data[path.row];
                self.textLabel.text = [dic allValues].firstObject;
                break;
            }
            case 11: {///贵金属交易下单界面选择合约
                IBFXQuoteConfigJsonModel *model = data[path.row];
                self.textLabel.textAlignment = NSTextAlignmentCenter;
                self.textLabel.font = [UIFont systemFontOfSize:19];
                self.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
                self.textLabel.text = model.currencyPair;
                NSLog(@"%@________________________", model.nameChinese);
                break;
            }
            default:
                break;
        }
    }
}










@end
