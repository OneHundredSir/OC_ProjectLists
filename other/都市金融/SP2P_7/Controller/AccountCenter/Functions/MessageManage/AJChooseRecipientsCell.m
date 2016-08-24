//
//  AJChooseRecipientsCell.m
//  SP2P_7
//
//  Created by Ajax on 16/1/30.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJChooseRecipientsCell.h"
#import "AJChooseRecipients.h"

@interface AJChooseRecipientsCell ()
@property (nonatomic, weak) UIImageView *portrait;
@property (nonatomic, weak) UILabel *name;

@end

@implementation AJChooseRecipientsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *portrait = [[UIImageView alloc] init];
        [self.contentView addSubview:portrait];
        self.portrait = portrait;
        
        UILabel *name = [[UILabel alloc] init];
        name.textAlignment = NSTextAlignmentLeft;
        name.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:name];
        self.name = name;
        name.textColor = [ColorTools colorWithHexString:@"#646464"];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat selfW = self.bounds.size.width;
    CGFloat selfH = self.bounds.size.height;
    CGFloat portraitW = 30;
    self.portrait.frame = CGRectMake(15, (selfH - portraitW)/2, portraitW, portraitW);
    
    CGFloat nameX =CGRectGetMaxX(self.portrait.frame)+10;
    self.name.frame = CGRectMake(nameX, 0, selfW - nameX - 50, selfH);
}


- (void)setAAJChooseRecipients:(AJChooseRecipients *)aAJChooseRecipients
{
    _aAJChooseRecipients = aAJChooseRecipients;

    if ([aAJChooseRecipients.attention_user_photo hasPrefix:@"http"]) {
        
        [self.portrait sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",aAJChooseRecipients.attention_user_photo]]];
    }else{
        [self.portrait sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Baseurl,aAJChooseRecipients.attention_user_photo]]];
        }

    self.name.text = aAJChooseRecipients.attention_user_name;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AJChooseRecipientsCell";
    AJChooseRecipientsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[AJChooseRecipientsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    }
    return cell;
}
@end
