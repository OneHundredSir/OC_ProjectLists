//
//  AJInvestCell.m
//  SP2P_7
//
//  Created by Ajax on 16/1/16.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJInvestCell.h"
#define kRepayModeTextColor @"#8da2b8"
#define kRateTextColor @"#63caff"
#define kdueInTextColor @"#646464"
#import "LDProgressView.h"
#import "Investment.h"

@interface AJInvestCell ()
@property (nonatomic, weak) UIView *bgV;
@property (nonatomic, weak) UIImageView *fresher;
@property (nonatomic, weak) UIImageView *leftCircle;
@property (nonatomic, weak) UIImageView *rightCircle;
@property (nonatomic, weak) UIImageView *circleLine;
@property (nonatomic, weak) UILabel *bidTitle;
@property (nonatomic, weak) UILabel *rate;
@property (nonatomic, weak) UILabel *progress;
@property (nonatomic , strong) LDProgressView *progressView;
@property (nonatomic, weak) UILabel *duration;
@property (nonatomic, weak) UIView *bottomseparator;
@property (nonatomic, weak) UIView *separator;
@property (nonatomic, weak) UILabel *amount;
@property (nonatomic, weak) UIButton *repayMode;
@end
@implementation AJInvestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = self.backgroundColor = self.backgroundView.backgroundColor = [UIColor clearColor];
        // 背景视图
        UIView *bgV = [[UIView alloc] init];
        bgV.layer.cornerRadius = 8.0f;
        bgV.layer.masksToBounds = YES;
        bgV.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgV];
        self.bgV = bgV;
        // 新手视图
        UIImageView *freher = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"invest_profit"]];
        self.fresher = freher;
        [self.contentView addSubview:freher];
        // 转让标的标题
        UILabel *bidTitle=  [[UILabel alloc] init];
        bidTitle.font = [UIFont boldSystemFontOfSize:16];
        bidTitle.textColor = [UIColor blackColor];
        bidTitle.backgroundColor = [UIColor clearColor];
        bidTitle.textAlignment = NSTextAlignmentLeft;
        [self.bgV addSubview:bidTitle];
        self.bidTitle = bidTitle;
        self.bidTitle.text = @"消费信贷权益项目";
        // 标题分割视图
        UIImageView *leftCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_circle"]];
        self.leftCircle = leftCircle;
        [self.bgV addSubview:leftCircle];
        UIImageView *rightCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_circle"]];
        self.rightCircle = rightCircle;
        [self.bgV addSubview:rightCircle];
        UIImageView *circleLine = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"home_circledotLine"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
        self.circleLine = circleLine;
        [self.bgV addSubview:circleLine];
        // 利率
        UILabel *rate=  [[UILabel alloc] init];
        rate.font = [UIFont systemFontOfSize:26];
        rate.textColor = [ColorTools colorWithHexString:kRateTextColor];
        rate.backgroundColor = [UIColor clearColor];
        rate.textAlignment = NSTextAlignmentLeft;
        [self.bgV addSubview:rate];
        self.rate = rate;
        self.rate.text = @"16.0%";
        // 进度
        LDProgressView *progressView = [[LDProgressView alloc] init];
        progressView.color = rate.textColor;
        progressView.flat = @YES;// 是否扁平化
        progressView.borderRadius = @4;
        progressView.showBackgroundInnerShadow = @NO;
        progressView.animate = @NO;
        progressView.progressInset = @0;//内边的边距
        progressView.showBackground = @YES;
        progressView.outerStrokeWidth = @0;
        progressView.showText = @NO;
        progressView.showStroke = @NO;
        progressView.background = KblackgroundColor;
        [self addSubview:progressView];
        progressView.progress = 0.81;
        self.progressView = progressView;
        // 进度
        UILabel *progress=  [[UILabel alloc] init];
        progress.font = [UIFont systemFontOfSize:13];
        progress.textColor = [ColorTools colorWithHexString:kdueInTextColor];
        progress.backgroundColor = [UIColor clearColor];
        progress.textAlignment = NSTextAlignmentLeft;
        [self.bgV addSubview:progress];
        self.progress = progress;
        self.progress.text = @"81.0%";
        // 分割
        UIView *separator = [[UIView alloc] init];
        separator.backgroundColor = KblackgroundColor;
        [self.bgV addSubview:separator];
        self.separator = separator;
        // 剩余时间文字
        UILabel *duration=  [[UILabel alloc] init];
        duration.font = [UIFont systemFontOfSize:12];
        duration.textColor = [ColorTools colorWithHexString:kdueInTextColor];
        duration.backgroundColor = [UIColor clearColor];
        duration.textAlignment = NSTextAlignmentCenter;
        [self.bgV addSubview:duration];
        self.duration = duration;
        self.duration.text = @"12个月";
        // 分割
        UIView *bottomseparator = [[UIView alloc] init];
        bottomseparator.backgroundColor = KblackgroundColor;
        [self.bgV addSubview:bottomseparator];
        self.bottomseparator = bottomseparator;
        // 金额
        UILabel *amount=  [[UILabel alloc] init];
        amount.font = duration.font;
        amount.textColor = [ColorTools colorWithHexString:kdueInTextColor];
        amount.backgroundColor = [UIColor clearColor];
        amount.textAlignment = NSTextAlignmentLeft;
        [self.bgV addSubview:amount];
        self.amount = amount;
        self.amount.text = @"融资金额：14321";
        // 还款方式
        UIButton *repayMode = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *repayModeBG = [[UIImage imageNamed:@"home_repayMode"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 10, 1, 10)];
        [repayMode setBackgroundImage:repayModeBG forState:UIControlStateDisabled];
        [repayMode setTitleColor:[ColorTools colorWithHexString:kRepayModeTextColor] forState:UIControlStateNormal];
        [repayMode setTitle:@"按月付息,到期滑嫩" forState:UIControlStateNormal];
        repayMode.enabled = NO;
        repayMode.titleLabel.font = duration.font;
        [self.bgV addSubview:repayMode];
        self.repayMode = repayMode;

    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat selfW = self.bounds.size.width;
    CGFloat selfH = self.bounds.size.height;
    // 背景视图
    CGFloat leading = 20.f/2;
    CGFloat top = 5.f/2;
    CGFloat bgVW = selfW - 2 *leading;
    self.bgV.frame = CGRectMake(leading, top, bgVW, selfH - top);
    // 新手视图
    CGFloat fresherX = selfW - leading - self.fresher.image.size.width;
    self.fresher.frame = CGRectMake(fresherX, 0, self.fresher.image.size.width, self.fresher.image.size.height);
    // 标的标题
    CGFloat bidTitleH = 92.f/2;
    self.bidTitle.frame = CGRectMake(40.f/2, 0, bgVW, bidTitleH);
    // 标题分割视图
    CGFloat leftCircleX = - self.leftCircle.image.size.width/2;
    CGFloat circleLineH = self.circleLine.image.size.height;
    CGFloat leftCircleW = self.leftCircle.image.size.width;
    self.leftCircle.frame = CGRectMake(leftCircleX, bidTitleH + leftCircleX + circleLineH/2, leftCircleW, leftCircleW);
    CGFloat circleLineW = bgVW - leftCircleW;
    self.circleLine.frame = CGRectMake(CGRectGetMaxX(self.leftCircle.frame), bidTitleH, circleLineW, circleLineH);
    self.rightCircle.frame = CGRectMake(CGRectGetMaxX(self.circleLine.frame), self.leftCircle.frame.origin.y, leftCircleW, leftCircleW);
    // 利率
    CGFloat rateY = CGRectGetMaxY(self.circleLine.frame);
    CGFloat rateH = 130.f/2;
    self.rate.frame = CGRectMake(30.f/2, CGRectGetMaxY(self.circleLine.frame), bgVW/2, rateH);
    // 进度
    CGFloat progressViewH = 9.f/2;
    CGFloat progressViewX = bgVW/2 + 60.f/2;
    self.progressView.frame = CGRectMake(progressViewX, rateY + (rateH )/2, 160.f/2, progressViewH);
     // 进度
    CGFloat progressH = 32.f/2;
    self.progress.frame = CGRectMake(CGRectGetMaxX(self.progressView.frame), rateY + (rateH - progressH)/2, 82.f/2, progressH);
    // 分割
    self.separator.frame = CGRectMake(0, CGRectGetMaxY(self.rate.frame), bgVW, 1.f);
    // 剩余时间文字
    CGFloat durationH = 70.f/2;
    CGFloat durationW = 85.f/2;
    CGFloat durationY = CGRectGetMaxY(self.separator.frame);
    self.duration.frame = CGRectMake(20.f/2, durationY, durationW, durationH);
    // 分割
    CGFloat bottomseparatorH = 35.f/2;
    self.bottomseparator.frame = CGRectMake(CGRectGetMaxX(self.duration.frame)+1.f, durationY + (durationH - bottomseparatorH)/2, 1.f, bottomseparatorH);
    // 金额
    CGFloat amountW = 250.f/2;
     self.amount.frame = CGRectMake(CGRectGetMaxX(self.bottomseparator.frame)+1.f, durationY, amountW, durationH);
    // 还款方式
    CGFloat repayModeW = 220.f/2;
    CGFloat repayModeX = bgVW - repayModeW - 20.f/2;
    CGFloat repayModeH = 42.f/2;
    self.repayMode.frame = CGRectMake(repayModeX, durationY + (durationH - repayModeH)/2, repayModeW, repayModeH);
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AJInvestCell";
    AJInvestCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[AJInvestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)setAInvestment:(Investment *)aInvestment
{
    _aInvestment = aInvestment;
    // 图片
    UIImage *img = nil;
    if ([aInvestment.product_id intValue] == 5) {// 产品类型：5==稳赢宝，7==新手表，其他==商理宝
        img = [UIImage imageNamed:@"invest_profit"];
    }else if([aInvestment.product_id intValue] == 7){
        img = [UIImage imageNamed:@"home_fresher_red"];
    }else{
        img = [UIImage imageNamed:@"invest_business"];
    }
    self.fresher.image = img;
    
    self.bidTitle.text = aInvestment.title;
    // 利率
    NSString *rate = [NSString stringWithFormat:@"%.01f%@",aInvestment.rate,@"%"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:rate];
    NSRange Range = [rate rangeOfString:@"%"];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:Range];
    self.rate.attributedText = str;
    // 进度
    self.progressView.progress = aInvestment.progress/100;
    self.progress.text = [NSString stringWithFormat:@"%.f%@", aInvestment.progress, @"%"];
    
    if([aInvestment.unitstr isEqualToString:@"0"]){
        
        self.duration.text = [NSString stringWithFormat:@"%@个月",aInvestment.time];
        
    } else if([aInvestment.unitstr isEqualToString:@"-1"]){
        self.duration.text = [NSString stringWithFormat:@"%@年",aInvestment.time];
    }else{
        self.duration.text= [NSString stringWithFormat:@"%@天",aInvestment.time];
    }

    self.amount.text = [NSString stringWithFormat:@"融资金额：%.2f", aInvestment.amount];
    [self.repayMode setTitle:aInvestment.repayTypeStr forState:UIControlStateNormal];
}
@end
