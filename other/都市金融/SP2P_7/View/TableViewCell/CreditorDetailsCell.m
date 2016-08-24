//
//  CreditorDetailsCell.m
//  SP2P_7
//
//  Created by Jerry on 14-7-8.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "CreditorDetailsCell.h"
#import "ColorTools.h"


@implementation CreditorDetailsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGFloat leading = 10;
        CGFloat viewSpace = 10;
        CGFloat _HeadimgViewW = 60.f;
        _HeadimgView = [[UIImageView alloc] initWithFrame:CGRectMake(leading, leading, _HeadimgViewW, _HeadimgViewW)];
        _HeadimgView.layer.cornerRadius = 30;
        _HeadimgView.userInteractionEnabled = NO;
        _HeadimgView.layer.masksToBounds = YES;
        [self addSubview:_HeadimgView];
        
        _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _attentionBtn.frame = CGRectMake(leading, 70, _HeadimgViewW, 18);
        _attentionBtn.backgroundColor = kAttentionColor;
        [_attentionBtn setTitle:@"+加关注" forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _attentionBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:11.0];
        [_attentionBtn.layer setMasksToBounds:YES];
        [_attentionBtn.layer setCornerRadius:3.0];
        [self addSubview:_attentionBtn];
        
        
        _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 200, 40)];
        _NameLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:12.0];
        _NameLabel.numberOfLines = 0;
        _NameLabel.adjustsFontSizeToFitWidth = YES;
        _NameLabel.textColor = BluewordColor;
        [self addSubview:_NameLabel];
        
        CGFloat titleLabel1X = CGRectGetMaxX(_HeadimgView.frame) + viewSpace;
        CGFloat titleLabel1W = 60.f;
        CGFloat titleLabel1Top = 35.0f;
        CGFloat titleLabel1H = 30.f;
        UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel1X,titleLabel1Top, titleLabel1W, titleLabel1H)];
        titleLabel1.text = @"贷款记录:";
        titleLabel1.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:titleLabel1];
        
        CGFloat _BorrowsucceedLabelX = CGRectGetMaxX(titleLabel1.frame);
        CGFloat _BorrowsucceedLabelW = 30.f;
        _BorrowsucceedLabel = [[UILabel alloc] initWithFrame:CGRectMake(_BorrowsucceedLabelX,titleLabel1Top, _BorrowsucceedLabelW, titleLabel1H)];
        _BorrowsucceedLabel.font = [UIFont systemFontOfSize:12.0f];
        _BorrowsucceedLabel.textColor = kAttentionColor;
        [self addSubview:_BorrowsucceedLabel];
        
        CGFloat titleLabel2X = CGRectGetMaxX(_BorrowsucceedLabel.frame);
        UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel2X,titleLabel1Top, titleLabel1W, titleLabel1H)];
        titleLabel2.text = @"次正常,";
        titleLabel2.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:titleLabel2];
        
        CGFloat _BorrowfailLabelX = CGRectGetMaxX(titleLabel2.frame) ;
        _BorrowfailLabel = [[UILabel alloc] initWithFrame:CGRectMake(_BorrowfailLabelX,titleLabel1Top, _BorrowsucceedLabelW, titleLabel1H)];
        _BorrowfailLabel.font = [UIFont systemFontOfSize:12.0f];
        _BorrowfailLabel.textColor = kAttentionColor;
        [self addSubview:_BorrowfailLabel];
        
         CGFloat titleLabel3X = CGRectGetMaxX(_BorrowfailLabel.frame);
        UILabel *titleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel3X,titleLabel1Top, titleLabel1W, titleLabel1H)];
        titleLabel3.text = @"次流标";
        titleLabel3.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:titleLabel3];
        
        CGFloat titleLabel4Y = 60.f;
        UILabel *titleLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel1X,titleLabel4Y, titleLabel1W, titleLabel1H)];
        titleLabel4.text = @"还款记录:";
        titleLabel4.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:titleLabel4];
        
        
        _repaymentnormalLabel = [[UILabel alloc] initWithFrame:CGRectMake(_BorrowsucceedLabelX, titleLabel4Y, _BorrowsucceedLabelW, titleLabel1H)];
        _repaymentnormalLabel.textColor = kAttentionColor;
        _repaymentnormalLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_repaymentnormalLabel];
        
        
        UILabel *titleLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel2X,titleLabel4Y, titleLabel1W, titleLabel1H)];
        titleLabel5.text = @"次正常,";
        titleLabel5.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:titleLabel5];
        
        
        _repaymentabnormalLabel = [[UILabel alloc] initWithFrame:CGRectMake(_BorrowfailLabelX, titleLabel4Y, _BorrowsucceedLabelW, titleLabel1H)];
        _repaymentabnormalLabel.font = [UIFont systemFontOfSize:12.0f];
        _repaymentabnormalLabel.textColor = kAttentionColor;
        [self addSubview:_repaymentabnormalLabel];
        
        
        UILabel *titleLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel3X,titleLabel4Y, titleLabel1W, titleLabel1H)];
        titleLabel6.text = @"次逾期";
        titleLabel6.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:titleLabel6];
        
        
//        _vipView = [[UIImageView alloc] initWithFrame:CGRectMake(150, 10, 23, 23)];
        _vipView.image = [UIImage imageNamed:@"member_vip"];
        [self addSubview:_vipView];
        
        
//        _LevelimgView = [[UIImageView alloc] initWithFrame:CGRectMake(180, 10, 20, 20)];
        //_MemberimgView.backgroundColor = [UIColor redColor];
        [self addSubview:_LevelimgView];
        
        
        
//        _ReportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _ReportBtn.frame = CGRectMake(215, 5, 30, 30);
        //_ReportBtn.backgroundColor = [UIColor blueColor];
        [self addSubview:_ReportBtn];
        
        CGFloat _MailBtnH = 30.f;
        _MailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _MailBtn.frame = CGRectMake(MSWIDTH - 30.f - _MailBtnH, 5, _MailBtnH, _MailBtnH);
        //_MailBtn.backgroundColor = [UIColor blueColor];
        [self addSubview:_MailBtn];
        

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
