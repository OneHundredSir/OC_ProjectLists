//
//  AJTransferCell.m
//  SP2P_7
//
//  Created by Ajax on 16/1/16.
//  Copyright © 2016年 EIMS. All rights reserved.
//
#define kRateTextColor @"#63caff"
#define kdueInTextColor @"#646464"
#import "AJTransferCell.h"
#import "CreditorTransfer.h"

@interface AJTransferCell ()
@property (nonatomic, weak) UIView *bgV;
@property (nonatomic, weak) UIImageView *leftCircle;
@property (nonatomic, weak) UIImageView *rightCircle;
@property (nonatomic, weak) UIImageView *circleLine;
@property (nonatomic, weak) UILabel *bidTitle;
@property (nonatomic, weak) UILabel *dueIn;
@property (nonatomic, weak) UILabel *dueInText;
@property (nonatomic, weak) UILabel *leftTimeText;
@property (nonatomic, weak) UILabel *leftTime;
@property (nonatomic, weak) UIView *separator;
@property (nonatomic, weak) UILabel *basePrice;
@property (nonatomic, weak) UILabel *currentPrice;
@property (nonatomic, assign) NSTimeInterval time;//相差时间
@property (nonatomic, strong) NSTimer *timer;
@end
@implementation AJTransferCell
{
    
}

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
        // 转让标的标题
        UILabel *bidTitle=  [[UILabel alloc] init];
        bidTitle.font = [UIFont boldSystemFontOfSize:18];
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
        // 待收金额文字
        UILabel *dueInText=  [[UILabel alloc] init];
        dueInText.font = [UIFont systemFontOfSize:12];
        dueInText.textColor = [ColorTools colorWithHexString:kdueInTextColor];
        dueInText.backgroundColor = [UIColor clearColor];
        dueInText.textAlignment = NSTextAlignmentLeft;
        [self.bgV addSubview:dueInText];
        self.dueInText = dueInText;
        self.dueInText.text = @"待收本金";
        // 待收金额
        UILabel *dueIn=  [[UILabel alloc] init];
        dueIn.font = [UIFont systemFontOfSize:21];
        dueIn.textColor = [ColorTools colorWithHexString:kRateTextColor];
        dueIn.backgroundColor = [UIColor clearColor];
        dueIn.textAlignment = NSTextAlignmentLeft;
        [self.bgV addSubview:dueIn];
        self.dueIn = dueIn;
        self.dueIn.text = @"1944.33";
        // 剩余时间文字
        UILabel *leftTimeText=  [[UILabel alloc] init];
        leftTimeText.font = dueInText.font;
        leftTimeText.textColor = dueInText.textColor;
        leftTimeText.backgroundColor = [UIColor clearColor];
        leftTimeText.textAlignment = NSTextAlignmentLeft;
        [self.bgV addSubview:leftTimeText];
        self.leftTimeText = leftTimeText;
        self.leftTimeText.text = @"剩余时间";
        // 剩余时间
        UILabel *leftTime=  [[UILabel alloc] init];
        leftTime.font = dueInText.font;
        leftTime.textColor = dueInText.textColor;
        leftTime.backgroundColor = [UIColor clearColor];
        leftTime.textAlignment = NSTextAlignmentLeft;
        [self.bgV addSubview:leftTime];
        self.leftTime = leftTime;
        self.leftTime.adjustsFontSizeToFitWidth = YES;
//        self.leftTime.text = @"4天4小时78分";
        // 分割
        UIView *separator = [[UIView alloc] init];
        separator.backgroundColor = KblackgroundColor;
        [self.bgV addSubview:separator];
        self.separator = separator;
        // 拍卖底价
        UILabel *basePrice=  [[UILabel alloc] init];
        basePrice.font = dueInText.font;
        basePrice.textColor = dueInText.textColor;
        basePrice.backgroundColor = [UIColor clearColor];
        basePrice.textAlignment = NSTextAlignmentLeft;
        [self.bgV addSubview:basePrice];
        self.basePrice = basePrice;
        self.basePrice.text = @"拍卖底价：234166";
        // 当前最高价
        UILabel *currentPrice=  [[UILabel alloc] init];
        currentPrice.font = dueInText.font;
        currentPrice.textColor = dueInText.textColor;
        currentPrice.backgroundColor = [UIColor clearColor];
        currentPrice.textAlignment = NSTextAlignmentLeft;
        [self.bgV addSubview:currentPrice];
        self.currentPrice = currentPrice;
        self.currentPrice.text = @"当前最高价：2341466";
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat selfW = self.bounds.size.width;
    CGFloat selfH = self.bounds.size.height;
    // 背景视图
    CGFloat leading = 20.f/2;
    CGFloat top = 0.f/2;
    CGFloat bgVW = selfW - 2 *leading;
    self.bgV.frame = CGRectMake(leading, top, bgVW, selfH - top);
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
    // 待收金额文字
    CGFloat dueInTextleading = 30.f/2;
    CGFloat dueInTextH = 30.f/2;
    self.dueInText.frame = CGRectMake(dueInTextleading,CGRectGetMaxY(self.circleLine.frame) + 22.f/2, bgVW/2, dueInTextH);
    // 待收金额
    CGFloat dueInH = 43.f/2;
    CGFloat space = 16.f/2;
    self.dueIn.frame = CGRectMake(dueInTextleading,CGRectGetMaxY(self.dueInText.frame) + space, bgVW/2, dueInH);
    // 剩余时间文字
    CGFloat leftTimeTextLeading = bgVW/2;
   self.leftTimeText.frame = CGRectMake(leftTimeTextLeading,self.dueInText.frame.origin.y, bgVW/2, dueInTextH);
    // 剩余时间
    self.leftTime.frame = CGRectMake(leftTimeTextLeading,self.dueIn.frame.origin.y, bgVW/2, dueInH);
    // 分割
   self.separator.frame = CGRectMake(0,CGRectGetMaxY(self.leftTime.frame) + space, bgVW, 1.f);
    // 拍卖底价
    CGFloat basePriceH = 70.f/2;
    self.basePrice.frame = CGRectMake(dueInTextleading,CGRectGetMaxY(self.separator.frame), bgVW/2, basePriceH);
    // 当前最高价
   self.currentPrice.frame = CGRectMake(leftTimeTextLeading,self.basePrice.frame.origin.y, bgVW/2, basePriceH);
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AJTransferCell";
    AJTransferCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[AJTransferCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)setACreditorTransfer:(CreditorTransfer *)aCreditorTransfer
{
    _aCreditorTransfer = aCreditorTransfer;
    
    self.bidTitle.text = aCreditorTransfer.title;
    self.dueIn.text = [NSString stringWithFormat:@"%.2f",aCreditorTransfer.principal];
    
    [self timeDownWithDate:aCreditorTransfer.leftDate];
    
    self.basePrice.text = [NSString stringWithFormat:@"拍卖底价: %.2f",aCreditorTransfer.minPrincipal];
    self.currentPrice.text = [NSString stringWithFormat:@"当前最高价: %.2f",aCreditorTransfer.currentPrincipal];
}

#pragma mark 倒计时
- (void)timeDownWithDate:(NSDate *)endDate
{
    //剩余时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    NSDate *senderDate=[NSDate date];
    //得到相差秒数
    _time=[endDate timeIntervalSinceDate:senderDate];
    int days = ((int)_time)/(3600*24);
    int hours = ((int)_time)%(3600*24)/3600;
    int minute = ((int)_time)%(3600*24)%3600/60;
    int seconds = ((int)_time)%(3600*24)%3600%60;
    if (days <= 0&&hours <= 0&&minute <= 0&&seconds<=0){
        
        NSDictionary *dayAttribute = @{NSForegroundColorAttributeName: self.dueIn.textColor, NSFontAttributeName: self.dueIn.font};
        //        NSDictionary *dayTextAttribute = @{NSForegroundColorAttributeName: self.dueInText.textColor, NSFontAttributeName: self.dueInText.font};
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", 0] attributes:dayAttribute];
        
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"天"]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", 0] attributes:dayAttribute]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"小时"]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", 0] attributes:dayAttribute]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"分"]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", 0] attributes:dayAttribute]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"秒"]];
        self.leftTime.attributedText = str;

    }else{
        
        if(self.timer) [self removeTimer];// 移除旧的计时器
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

    }
}

// 去除时间控件
- (void)removeTimer{
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)timerFireMethod
{
    _time--;
    int days = ((int)_time)/(3600*24);
    int hours = ((int)_time)%(3600*24)/3600;
    int minute = ((int)_time)%(3600*24)%3600/60;
    int seconds = ((int)_time)%(3600*24)%3600%60;
    
    if (days <= 0&&hours <= 0&&minute <= 0&&seconds<=0){
        
        [self removeTimer];
    }else{
        
         NSDictionary *dayAttribute = @{NSForegroundColorAttributeName: self.dueIn.textColor, NSFontAttributeName: self.dueIn.font};
//        NSDictionary *dayTextAttribute = @{NSForegroundColorAttributeName: self.dueInText.textColor, NSFontAttributeName: self.dueInText.font};
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", days] attributes:dayAttribute];
       
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"天"]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", hours] attributes:dayAttribute]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"小时"]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", minute] attributes:dayAttribute]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"分"]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", seconds] attributes:dayAttribute]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"秒"]];
        self.leftTime.attributedText = str;
    }
}

@end
