//
//  AJInterstductionCell.m
//  SP2P_7
//
//  Created by Ajax on 16/1/21.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJInterstductionCell.h"

@interface AJInterstductionCell ()
// 金额
@property (nonatomic, weak) UILabel *titleL;
// 描述
@property (nonatomic, weak) UILabel *describ;
@end
@implementation AJInterstductionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = self.backgroundColor = self.backgroundView.backgroundColor = [UIColor clearColor];
        // 金额
        UILabel *titleL=  [[UILabel alloc] init];
        titleL.font = [UIFont boldSystemFontOfSize:18];
        titleL.textColor = [ColorTools colorWithHexString:@"#646464"];
        titleL.backgroundColor = [UIColor clearColor];
        titleL.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:titleL];
        titleL.numberOfLines = 0;
        self.titleL = titleL;
//        self.title.text = @"特点";
        // 描述
        UILabel *describ=  [[UILabel alloc] init];
        describ.font = [UIFont boldSystemFontOfSize:15];
        describ.textColor = [ColorTools colorWithHexString:@"#969696"];
        describ.backgroundColor = [UIColor clearColor];
        describ.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:describ];
        describ.numberOfLines = 0;
        self.describ = describ;
//        self.describ.text = @"每日生息，T+1 返息";
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat selfW = self.bounds.size.width;
    CGFloat selfH = self.bounds.size.height;
    // 金额
    CGFloat padding = 20.f/2;
    self.titleL.frame = CGRectMake(padding, padding, selfW/2, 40.f/2);
    CGFloat describY = CGRectGetMaxY(self.titleL.frame) + padding;
     self.describ.frame = CGRectMake(padding, describY, selfW - 2 *padding, selfH - describY - padding);
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AJInterstductionCell";
    AJInterstductionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[AJInterstductionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setContent:(NSString *)content
{
    _content = content;
    
    self.describ.text = content;
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleL.text = title;
}
@end
