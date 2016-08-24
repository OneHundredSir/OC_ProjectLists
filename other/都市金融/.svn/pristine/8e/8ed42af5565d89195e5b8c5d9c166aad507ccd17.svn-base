//
//  AccountCell.m
//  SP2P_7
//
//  Created by Ajax on 16/1/14.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AccountCell.h"
#import "AJAccountCellData.h"

@interface AccountCell ()
//@property (nonatomic, weak) UIImageView *imgV;
//@property (nonatomic, weak) UILabel *textL;
@end
@implementation AccountCell
{
//    UIView *_separator;
}

- (void)setData:(AJAccountCellData *)data{
    
    self.imageView.image = [UIImage imageNamed:data.img];
    self.textLabel.text = data.text;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        UIView *separator = [[UIView alloc] init];
//        separator.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        [self.contentView addSubview:separator];
//        _separator = separator;
        
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
//    _separator.frame = CGRectMake(110.f/2, self.contentView.bounds.size.height -1.f, self.contentView.bounds.size.width - 110.f/2, 1.0f);
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AccountCell";
    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[AccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]]
        cell.separatorInset = UIEdgeInsetsMake(0, 110.f/2, 0, 0);
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return cell;
}
@end
