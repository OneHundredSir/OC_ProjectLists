//
//  BankCardManageCell.m
//  SP2P_7
//
//  Created by Jerry on 14-8-5.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "BankCardManageCell.h"
#import "ColorTools.h"
#import "BankCard.h"

@interface BankCardManageCell()

@property (nonatomic , strong) id object;

@end

@implementation BankCardManageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _bankCardImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
//        _bankCardImage.layer.cornerRadius = 35.0f;
        _bankCardImage.userInteractionEnabled = NO;
//        _bankCardImage.layer.masksToBounds = YES;
        [self addSubview:_bankCardImage];
        
        _banknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 8, MSWIDTH - 100, 35)];
        _banknameLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        _banknameLabel.textColor = [UIColor blackColor];
//        _banknameLabel.numberOfLines = 0;
        _banknameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _bankNumLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_banknameLabel];
        
        
        _bankNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH - 200, 60, 180, 40)];
        _bankNumLabel.font = [UIFont boldSystemFontOfSize:23.0f];
        _bankNumLabel.textColor = [UIColor blackColor];
        [self addSubview:_bankNumLabel];
        
       
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.object) {
        if ([self.object isMemberOfClass:[BankCard class]]) {
            BankCard *object = self.object;
            
            _banknameLabel.text = object.bankName;
//            _branchbanknameLabel.text = object.branchBankName;
            _bankNumLabel.text = object.account;
           
            
            if([object.bankName rangeOfString:@"中国银行"].location !=NSNotFound)
            {
                 _bankCardImage.image = [UIImage imageNamed:@"BankcardIcon.bundle/BOC"];
            }
            else if([object.bankName rangeOfString:@"工商"].location !=NSNotFound)
            {
                _bankCardImage.image = [UIImage imageNamed:@"BankcardIcon.bundle/ICBC"];
                
            } else if([object.bankName rangeOfString:@"建设"].location !=NSNotFound)
            {
                _bankCardImage.image = [UIImage imageNamed:@"BankcardIcon.bundle/CCB"];
                
            } else if([object.bankName rangeOfString:@"农业银行"].location !=NSNotFound)
            {
                _bankCardImage.image = [UIImage imageNamed:@"BankcardIcon.bundle/ABC"];
                
            } else if([object.bankName rangeOfString:@"交通"].location !=NSNotFound)
            {
                _bankCardImage.image = [UIImage imageNamed:@"BankcardIcon.bundle/COMM"];
                
            } else if([object.bankName rangeOfString:@"招商"].location !=NSNotFound)
            {
                _bankCardImage.image = [UIImage imageNamed:@"BankcardIcon.bundle/CMB"];
                
            } else if([object.bankName rangeOfString:@"光大"].location !=NSNotFound)
            {
                _bankCardImage.image = [UIImage imageNamed:@"BankcardIcon.bundle/CEB"];
                
            } else if([object.bankName rangeOfString:@"平安"].location !=NSNotFound)
            {
                _bankCardImage.image = [UIImage imageNamed:@"BankcardIcon.bundle/SPABANK"];
                
            } else if([object.bankName rangeOfString:@"兴业"].location !=NSNotFound)
            {
                _bankCardImage.image = [UIImage imageNamed:@"BankcardIcon.bundle/CIB"];
                
            } else if([object.bankName rangeOfString:@"浦发"].location !=NSNotFound)
            {
                _bankCardImage.image = [UIImage imageNamed:@"BankcardIcon.bundle/SPDB"];
            } else if([object.bankName rangeOfString:@"中信"].location !=NSNotFound)
            {
                _bankCardImage.image = [UIImage imageNamed:@"BankcardIcon.bundle/CITIC"];
                
            }  else if([object.bankName rangeOfString:@"民生"].location !=NSNotFound)
            {
                _bankCardImage.image = [UIImage imageNamed:@"BankcardIcon.bundle/CMBC"];
            }
            else if([object.bankName rangeOfString:@"广发"].location !=NSNotFound)
            {
                _bankCardImage.image  = [UIImage imageNamed:@"BankcardIcon.bundle/GDB"];
            }
            else if([object.bankName rangeOfString:@"邮政储蓄"].location !=NSNotFound)
            {
                _bankCardImage.image  = [UIImage imageNamed:@"BankcardIcon.bundle/PSBC"];
            }
            else if([object.bankName rangeOfString:@"华夏银行"].location !=NSNotFound)
            {
                _bankCardImage.image = [UIImage imageNamed:@"BankcardIcon.bundle/HXBANK"];
            }
            else
            {
                _bankCardImage.image = [UIImage imageNamed:@"BankcardIcon.bundle/bankDefaultIcon"];
            }
        }
    }
}

- (void)fillCellWithObject:(id)object
{
    self.object = object;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
