//
//  AJHomeCell.m
//  SP2P_7
//
//  Created by Ajax on 16/1/15.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJHomeCell.h"
#import "Investment.h"
#define kRateTextColor @"#63caff"
#define kProgressTextColor @"#c8c8c8"
#define kRepayModeTextColor @"#8da2b8"
#define kGuaranteeTextColor @"#365776"
#define kbidColorTextColor @"#ef5a50"
@interface AJHomeCell ()
@property (nonatomic, weak) UIView *bgV;
@property (nonatomic, weak) UIView *bidInfo;
@property (nonatomic, weak) UIView *separatorL;
@property (nonatomic, weak) UIView *separatorR;
@property (nonatomic, weak) UIImageView *fresher;
@property (nonatomic, weak) UIImageView *leftCircle;
@property (nonatomic, weak) UIImageView *rightCircle;
@property (nonatomic, weak) UIImageView *circleLine;
@property (nonatomic, weak) UILabel *bidTitle;
@property (nonatomic, weak) UILabel *rate;
@property (nonatomic, weak) UILabel *PercentSign;
@property (nonatomic, weak) UILabel *progress;
@property (nonatomic, weak) UILabel *amount;
@property (nonatomic, weak) UILabel *duration;
@property (nonatomic, weak) UIButton *repayMode;
@property (nonatomic, weak) UIButton *bidBtn;
@property (nonatomic, weak) UIButton *guarantee;
@end
@implementation AJHomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = self.backgroundColor = self.backgroundView.backgroundColor = [UIColor clearColor];
        // 背景视图
        UIView *bgV = [[UIView alloc] init];
        bgV.layer.cornerRadius = 10.0f;
        bgV.layer.masksToBounds = YES;
        bgV.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgV];
        self.bgV = bgV;
        // 新手视图
        UIImageView *freher = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_fresher_blue"]];
        self.fresher = freher;
        [self.contentView addSubview:freher];
        // 标的标题
        UILabel *bidTitle=  [[UILabel alloc] init];
        bidTitle.font = [UIFont boldSystemFontOfSize:18];
        bidTitle.textColor = [UIColor blackColor];
        bidTitle.backgroundColor = [UIColor clearColor];
        bidTitle.textAlignment = NSTextAlignmentCenter;
        [self.bgV addSubview:bidTitle];
        self.bidTitle = bidTitle;
        self.bidTitle.text = @"[新手表：】I47128954";
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
        // 还款方式
        UIButton *repayMode = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *repayModeBG = [[UIImage imageNamed:@"home_repayMode"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 10, 1, 10)];
        [repayMode setBackgroundImage:repayModeBG forState:UIControlStateDisabled];
        [repayMode setTitleColor:[ColorTools colorWithHexString:kRepayModeTextColor] forState:UIControlStateNormal];
        [repayMode setTitle:@"按月付息，到期滑嫩吧" forState:UIControlStateNormal];
        repayMode.enabled = NO;
        repayMode.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.bgV addSubview:repayMode];
        self.repayMode = repayMode;
        // 标的利率
        UILabel *rate=  [[UILabel alloc] init];
        rate.font = [UIFont systemFontOfSize:50];
        rate.textColor = [ColorTools colorWithHexString:kRateTextColor];
        rate.backgroundColor = [UIColor clearColor];
        rate.textAlignment = NSTextAlignmentRight;
        [self.bgV addSubview:rate];
        self.rate = rate;
        self.rate.text = @"25";
        // 百分号
        UILabel *PercentSign=  [[UILabel alloc] init];
        PercentSign.font = [UIFont boldSystemFontOfSize:18];
        PercentSign.textColor = [ColorTools colorWithHexString:kRateTextColor];
        PercentSign.backgroundColor = [UIColor clearColor];
        PercentSign.textAlignment = NSTextAlignmentLeft;
        [self.bgV addSubview:PercentSign];
        self.PercentSign = PercentSign;
        self.PercentSign.text = @"%";
        // 标信息
        [self initbidInfo];
        // 投标按钮
        UIButton *bidBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [bidBtn setBackgroundColor:[ColorTools colorWithHexString:kbidColorTextColor]];
        [bidBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bidBtn setTitle:@"立即投标" forState:UIControlStateNormal];
        bidBtn.titleLabel.font = [UIFont systemFontOfSize:22];
        bidBtn.layer.cornerRadius = 10.0f;
        bidBtn.layer.masksToBounds = YES;
        [self.bgV addSubview:bidBtn];
        [bidBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.bidBtn = bidBtn;
        // 保证
        UIButton *guarantee = [UIButton buttonWithType:UIButtonTypeCustom];
        guarantee.backgroundColor = [UIColor clearColor];
        [guarantee setImage:[UIImage imageNamed:@"home_ guarantee"] forState:UIControlStateDisabled];
        [guarantee setTitleColor:[ColorTools colorWithHexString:kGuaranteeTextColor] forState:UIControlStateNormal];
        [guarantee setTitle:@"资金交易由平安保险提供安全保障" forState:UIControlStateNormal];
        guarantee.titleLabel.font = [UIFont systemFontOfSize:14];
        guarantee.enabled = NO;
        [self.bgV addSubview:guarantee];
        self.guarantee = guarantee;
    }
    return self;
}


- (void)initbidInfo
{
    UIView *bidInfo = [[UIView alloc] init];
    [self.bgV addSubview:bidInfo];
    self.bidInfo = bidInfo;
    //进度
    UILabel *progress=  [[UILabel alloc] init];
    progress.font = [UIFont systemFontOfSize:15];
    progress.textColor = [ColorTools colorWithHexString:kProgressTextColor];
    progress.backgroundColor = [UIColor clearColor];
    progress.textAlignment = NSTextAlignmentCenter;
    [self.bidInfo addSubview:progress];
    self.progress = progress;
    self.progress.text = @"进度%324";
    // 分割
    UIView *separatorL = [[UIView alloc] init];
    separatorL.backgroundColor = KblackgroundColor;
    [self.bidInfo addSubview:separatorL];
    self.separatorL = separatorL;
    //金额
    UILabel *amount=  [[UILabel alloc] init];
    amount.font = progress.font;
    amount.textColor = [ColorTools colorWithHexString:kProgressTextColor];
    amount.backgroundColor = [UIColor clearColor];
    amount.textAlignment = NSTextAlignmentCenter;
    [self.bidInfo addSubview:amount];
    self.amount = amount;
    self.amount.text = @"金额%324";
    // 分割
    UIView *separatorR = [[UIView alloc] init];
    separatorR.backgroundColor = KblackgroundColor;
    [self.bidInfo addSubview:separatorR];
    self.separatorR = separatorR;
    // 期限
    UILabel *duration=  [[UILabel alloc] init];
    duration.font = progress.font;
    duration.textColor = [ColorTools colorWithHexString:kProgressTextColor];
    duration.backgroundColor = [UIColor clearColor];
    duration.textAlignment = NSTextAlignmentCenter;
    [self.bidInfo addSubview:duration];
    self.duration = duration;
    self.duration.text = @"期限4个月";

}
- (void)btnClick:(UIButton *)sender
{
    if (self.aInvestment.progress >= 100.0) {
    }else{
         self.bidBtnClick();
    }
   
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
    CGFloat bidTitleH = 96.f/2;
    self.bidTitle.frame = CGRectMake(0, 0, bgVW, bidTitleH);
    // 标题分割视图
    CGFloat leftCircleX = - self.leftCircle.image.size.width/2;
    CGFloat circleLineH = self.circleLine.image.size.height;
    CGFloat leftCircleW = self.leftCircle.image.size.width;
    self.leftCircle.frame = CGRectMake(leftCircleX, bidTitleH + leftCircleX + circleLineH/2, leftCircleW, leftCircleW);
    CGFloat circleLineW = bgVW - leftCircleW;
    self.circleLine.frame = CGRectMake(CGRectGetMaxX(self.leftCircle.frame), bidTitleH, circleLineW, circleLineH);
    self.rightCircle.frame = CGRectMake(CGRectGetMaxX(self.circleLine.frame), self.leftCircle.frame.origin.y, leftCircleW, leftCircleW);
    // 还款方式
    CGFloat repayModeY = CGRectGetMaxY(self.circleLine.frame) + 26.f/2 - circleLineH/2;
    CGFloat repayModeW = MSWIDTH/3 * 1.4;
    CGFloat repayModeH = 25.f;
    CGFloat repayModeX = (bgVW - repayModeW)/2;
    self.repayMode.frame = CGRectMake(repayModeX, repayModeY + 5, repayModeW, repayModeH);
    // 标的利率
    CGFloat rateW = (bgVW/2 + 20.f);
    CGFloat rateY = CGRectGetMaxY(self.repayMode.frame) + 46.f/2;
    CGFloat rateH = 94.f/2;
    self.rate.frame = CGRectMake(0, rateY, rateW, rateH);
    // 百分号
    CGFloat PercentSignY = rateY + 50.f/2;
    self.PercentSign.frame = CGRectMake(rateW, PercentSignY, rateW, rateH - 50.f/2);
    // 标信息
    CGFloat bidInfoH = 30.f/2;
    self.bidInfo.frame = CGRectMake(0, CGRectGetMaxY(self.PercentSign.frame) + 64.f/2, bgVW, bidInfoH);
    //进度
    CGFloat progressW = (bgVW - 2.f)/3;
    self.progress.frame = CGRectMake(0, 0, progressW, bidInfoH);
    // 分割
    self.separatorL.frame = CGRectMake(progressW, 0, 1.f, bidInfoH);
    //金额
    self.amount.frame = CGRectMake(progressW + 1.f, 0, progressW, bidInfoH);
    // 分割
    self.separatorR.frame = CGRectMake(CGRectGetMaxX(self.amount.frame), 0, 1.f, bidInfoH);
    // 期限
    self.duration.frame = CGRectMake(CGRectGetMaxX(self.separatorR.frame), 0, progressW, bidInfoH);
    // 投标按钮
    CGFloat bidBtnleading = 30.f/2;
    self.bidBtn.frame = CGRectMake(bidBtnleading, CGRectGetMaxY(self.bidInfo.frame) + 22.f/2, bgVW - 2*bidBtnleading, 100.f/2);
    //保证文字
    self.guarantee.frame = CGRectMake(0, CGRectGetMaxY(self.bidBtn.frame)+5, bgVW, 50.f/2);
    
}


+ (instancetype)cellWithTableView:(UITableView *)tableView btnClickBlock:(AJHomeCellbtnClickBlock)block
{
    static NSString *ID = @"AJHomeCell";
    AJHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[AJHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bidBtnClick = block;
    }
    return cell;
}


- (void)setAInvestment:(Investment *)aInvestment
{
    _aInvestment = aInvestment;
    self.bidTitle.text = aInvestment.title;
    [self.repayMode setTitle:aInvestment.repayTypeStr forState:UIControlStateNormal];
    self.rate.text = [NSString stringWithFormat:@"%.1f",aInvestment.rate];
    self.progress.text = [NSString stringWithFormat:@"进度 %.1f%@",aInvestment.progress,@"%"];
    self.amount.text = [NSString stringWithFormat:@"金额 %.1f",aInvestment.amount];
    if([aInvestment.unitstr isEqualToString:@"0"]){
        
        self.duration.text = [NSString stringWithFormat:@"期限%@个月",aInvestment.time];
        
    } else if([aInvestment.unitstr isEqualToString:@"-1"]){
       self.duration.text = [NSString stringWithFormat:@"期限%@年",aInvestment.time];
    }else{
           self.duration.text= [NSString stringWithFormat:@"期限%@天",aInvestment.time];
    }
    if (aInvestment.progress >= 100.0) {
        self.bidBtn.alpha = 0.7;
    }
}

@end
