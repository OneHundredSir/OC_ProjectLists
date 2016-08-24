//
//  AJTransferCell.m
//  SP2P_7
//
//  Created by Ajax on 16/1/19.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJTransferCellDailyEarning.h"
#define krateColor @"#646464"
#define kusableColor @"#ef5a50"
#define kTipsTextColor @"#c8c8c8"

@interface AJTransferCellDailyEarning ()
// 上面父view
@property (nonatomic, weak) UIView *firstView;
// 金额
@property (nonatomic, weak) UILabel *cash;
// 下面父View
@property (nonatomic, weak) UIView *secondView;
@property (nonatomic, weak) UILabel *usableText;
@property (nonatomic, weak) UILabel *usable;
@property (nonatomic, weak) UIButton *commit;
@property (nonatomic, weak) UILabel *tipTitle;
@property (nonatomic, weak) UILabel *tipText;
@end
@implementation AJTransferCellDailyEarning

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = KblackgroundColor;
        //第一个父视图
        UIView *firstView = [[UIView alloc]init];
        [self.contentView addSubview:firstView];
        firstView.backgroundColor = [UIColor whiteColor];
        self.firstView = firstView;
        // 金额
        UILabel *cash=  [[UILabel alloc] init];
        cash.font = [UIFont boldSystemFontOfSize:18];
        cash.textColor = [ColorTools colorWithHexString:krateColor];
        cash.backgroundColor = [UIColor clearColor];
        cash.textAlignment = NSTextAlignmentLeft;
        [firstView addSubview:cash];
        self.cash = cash;
        self.cash.text = @"金额";
        // field
        UITextField *cashField = [[UITextField alloc] init];
        [firstView addSubview:cashField];
        _cashField = cashField;
        _cashField.textAlignment = NSTextAlignmentRight;
        cashField.placeholder = @"请输入金额";
        cashField.borderStyle = UITextBorderStyleNone;
        cashField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;

        //第二个父视图
        UIView *secondView = [[UIView alloc]init];
        [self.contentView addSubview:secondView];
        secondView.backgroundColor = [UIColor whiteColor];
        self.secondView = secondView;
        // 可用余额
        UILabel *usableText=  [[UILabel alloc] init];
        usableText.font = [UIFont boldSystemFontOfSize:16];
        usableText.textColor = cash.textColor;
        usableText.backgroundColor = [UIColor clearColor];
        usableText.textAlignment = NSTextAlignmentLeft;
        [secondView addSubview:usableText];
        self.usableText = usableText;
        self.usableText.text = @"可用余额";
        // 可用余额数目
        UILabel *usable=  [[UILabel alloc] init];
        usable.font = usableText.font;
        usable.textColor = [ColorTools colorWithHexString:kusableColor];
        usable.backgroundColor = [UIColor clearColor];
        usable.textAlignment = NSTextAlignmentLeft;
        [secondView addSubview:usable];
        self.usable = usable;
//        self.usable.text = @"0.00元";
        // 投标按钮
        UIButton *commit = [UIButton buttonWithType:UIButtonTypeCustom];
        [commit setBackgroundColor:SETCOLOR(244, 50, 62, 1)];
        [commit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [commit setTitle:@"转入" forState:UIControlStateNormal];
        commit.titleLabel.font = [UIFont systemFontOfSize:18];
        commit.layer.cornerRadius = 10.0f;
        commit.layer.masksToBounds = YES;
        commit.adjustsImageWhenHighlighted = YES;
        [secondView addSubview:commit];
        [commit addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.commit = commit;
        // 温馨提示
        UILabel *tipTitle=  [[UILabel alloc] init];
        tipTitle.font = usableText.font;
        tipTitle.textColor = usable.textColor;
        tipTitle.backgroundColor = [UIColor clearColor];
        tipTitle.textAlignment = NSTextAlignmentLeft;
        [secondView addSubview:tipTitle];
        self.tipTitle = tipTitle;
        self.tipTitle.text = @"温馨提示";
        // 温馨提示文本
        UILabel *tipText=  [[UILabel alloc] init];
        tipText.font = usableText.font;
        tipText.textColor = [ColorTools colorWithHexString:kTipsTextColor];
        tipText.backgroundColor = [UIColor clearColor];
        tipText.textAlignment = NSTextAlignmentLeft;
        [secondView addSubview:tipText];
        tipText.numberOfLines = 0;
        self.tipText = tipText;
        self.tipText.text = @"1.dfsajo hefw9aphfe9wpah epwahnrf pwahph wh1.dfsajo hefw9aphfe9wpah epwahnrf pwahph wh/nb1.dfsajo hefw9aphfe9wpah epwahnrf pwahph wh/n1.dfsajo hefw9aphfe9wpah epwahnrf pwahph wh/n1.dfsajo hefw9aphfe9wpah epwahnrf pwahph wh/n";
    }
    return self;
}
- (void)btnClick:(UIButton *)sender
{
    self.block(self.cashField.text);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat selfW = self.bounds.size.width;
    CGFloat selfH = self.bounds.size.height;
    //第一个父视图
    CGFloat firstViewH = 214.f/2;
    self.firstView.frame = CGRectMake(0, 0, selfW, firstViewH);
    // 金额
    CGFloat padding = 50.f/2;
    CGFloat cashH = 48.f/2;
    CGFloat cashY = (firstViewH - cashH)/2;
    self.cash.frame = CGRectMake(padding, cashY, 300.f/2, cashH);
    // field
    CGFloat cashFieldW = 240.f/2;
    CGFloat cashFieldX = selfW - padding - cashFieldW;
    self.cashField.frame = CGRectMake(cashFieldX, cashY, cashFieldW, cashH);
    //第二个父视图
    CGFloat secondViewY = firstViewH + 18.f/2;
    CGFloat secondViewH = selfH - secondViewY;
    self.secondView.frame = CGRectMake(0, firstViewH + 18.f/2, selfW, secondViewH);
    // 可用余额
    CGFloat usableTextY = 42.f/2;
    CGFloat usableTextH = 36.f/2;
    self.usableText.frame = CGRectMake(padding, usableTextY, 135.f/2, usableTextH);
    if (self.usable.hidden == YES) {
         self.usableText.frame = CGRectMake(padding, usableTextY, 300.f, usableTextH);
    }
    // 可用余额数目
    self.usable.frame = CGRectMake(CGRectGetMaxX(self.usableText.frame), usableTextY, 500.f/2, usableTextH);
    // 投标按钮
    CGFloat commitW = 525.f/2;
    CGFloat commitX = (selfW - commitW)/2;
    CGFloat commitY = CGRectGetMaxY(self.usable.frame) + 40.f/2;
    self.commit.frame = CGRectMake(commitX, commitY, commitW, 74.f/2);
    // 温馨提示
    CGFloat tipTitleY = CGRectGetMaxY(self.commit.frame) + 40.f/2;
    self.tipTitle.frame = CGRectMake(padding, tipTitleY, 150, 38.f/2);
    // 温馨提示文本
    CGFloat tipTextY = CGRectGetMaxY(self.tipTitle.frame) + 10.f/2;
    self.tipText.frame = CGRectMake(padding, tipTextY, selfW - 2*padding, secondViewH - tipTextY);
   
}
+ (instancetype)cellWithTableView:(UITableView *)tableView btnClickBlock:(AJTransferCellDailyEarningBlock)block
{
    static NSString *ID = @"AJTransferCellDailyEarning";
    AJTransferCellDailyEarning *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[AJTransferCellDailyEarning alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.block = block;
    }
    return cell;
}
- (void)setAAJTransfer:(AJTransfer *)aAJTransfer
{
    self.cash.text = aAJTransfer.cash;
    self.cashField.placeholder = aAJTransfer.cashFieldHolder;
    if (aAJTransfer.cashFieldText) {
        self.cashField.text = aAJTransfer.cashFieldText;
    }
    self.usableText.text = aAJTransfer.usableText;
    if (aAJTransfer.usable) {// 可用余额是红色：转入
        self.usable.text = aAJTransfer.usable;
    }else{
        self.usable.hidden = YES;
    }
    [self.commit setTitle:aAJTransfer.commitbtnText forState:UIControlStateNormal];
    self.tipText.text = aAJTransfer.tipsText;
}
@end
