//
//  AJAddCell.m
//  SP2P_7
//
//  Created by Ajax on 16/1/19.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJAddCell.h"
#import "AJAddCellData.h"

@interface AJAddCell ()
// 金额
@property (nonatomic, weak) UILabel *amount;
// 序号
@property (nonatomic, weak) UILabel *numericalOrder;
// 描述
@property (nonatomic, weak) UILabel *describ;
@end
@implementation AJAddCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.contentView.backgroundColor = [UIColor redColor];
        // 金额
        UILabel *amount=  [[UILabel alloc] init];
        amount.font = [UIFont boldSystemFontOfSize:15];
        amount.textColor = SETCOLOR(0, 206, 117, 1);
        amount.backgroundColor = [UIColor clearColor];
        amount.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:amount];
        self.amount = amount;
        self.amount.text = @"-100000";
        //序号
        UILabel *numericalOrder=  [[UILabel alloc] init];
        numericalOrder.font = [UIFont boldSystemFontOfSize:14];
        numericalOrder.textColor = [ColorTools colorWithHexString:@"#c8c8c8"];
        numericalOrder.backgroundColor = [UIColor clearColor];
        numericalOrder.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:numericalOrder];
        self.numericalOrder = numericalOrder;
        self.numericalOrder.text = @"序号：00000";
        // 描述
        UILabel *describ=  [[UILabel alloc] init];
        describ.font = amount.font;
        describ.textColor = [ColorTools colorWithHexString:@"#646464"];
        describ.backgroundColor = [UIColor clearColor];
        describ.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:describ];
        self.describ = describ;
        self.describ.text = @"扣除投资金额";
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat selfW = self.bounds.size.width;
//    CGFloat selfH = self.bounds.size.height;
    // 金额
    CGFloat padding = 20.f/2;
    CGFloat amountH = 150.f/2/2;
    self.amount.frame = CGRectMake(padding, 0, selfW/2, amountH);
    //序号
//    CGFloat numericalOrderX =
    self.numericalOrder.frame = CGRectMake(selfW/2, 0, selfW/2 - 16.f/2, amountH);
    // 描述
    self.describ.frame = CGRectMake(padding, amountH, selfW/2, amountH);
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AJAddCell";
    AJAddCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[AJAddCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setAAJAddCellData:(AJAddCellData *)aAJAddCellData
{
    _aAJAddCellData = aAJAddCellData;
    
    self.numericalOrder.text = [NSString stringWithFormat:@"序号：%@", aAJAddCellData.Id];
    if ([aAJAddCellData.Type_id intValue] == 1) {////:操作类型	1转入	2转出
        //文本写死：转入写“转入投资资金”、转出写“转出投资资金”
        self.describ.text = @"转入投资资金";
        self.amount.text = [NSString stringWithFormat:@"+%@",aAJAddCellData.Transfer_amount];
        self.amount.textColor = kAttentionColor;
    }else{
         self.describ.text = @"转出投资资金";
        self.amount.text = [NSString stringWithFormat:@"-%@",aAJAddCellData.Transfer_amount];
        self.amount.textColor = [UIColor redColor];
    }
}

@end
