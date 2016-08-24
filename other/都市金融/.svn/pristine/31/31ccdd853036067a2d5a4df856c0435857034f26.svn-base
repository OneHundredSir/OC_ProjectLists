//
//  AJAccountHeaderView.m
//  SP2P_7
//
//  Created by Ajax on 16/1/14.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJAccountHeaderView.h"
#import "AJAccountHeaderData.h"
#import "ColorTools.h"
#define kbottomBgColor @"#c64037"
#define kRechargeColor @"#63caff"

@interface AJAccountHeaderView ()
// 1消息按钮
@property (nonatomic, weak) UIButton *message;
// 2头像 Account_icon_modify
@property (nonatomic, weak) UIButton *head;
// 2.5 修改头像 Account_icon_modify
@property (nonatomic, weak) UIImageView *headModify;
// 3收益余额View
@property (nonatomic, weak) UIView *bottomV;
//4 昵称
@property (nonatomic, weak) UILabel *nickname;
// 5账户总额amountText
@property (nonatomic, weak) UILabel *accountAmount;
// 6账户总额
@property (nonatomic, weak) UILabel *amountText;
// 7累计收益incometext
@property (nonatomic, weak) UILabel *income;
// 8累计收益(元)
@property (nonatomic, weak) UILabel *incometext;
// 9可用余额
@property (nonatomic, weak) UILabel *left;
// 10可用余额(元)
@property (nonatomic, weak) UILabel *leftText;
// 11分割线
@property (nonatomic, weak) UIView *separator;
// 12充值提现toolView
@property (nonatomic, weak) UIView *toolView;
// 13充值按钮
@property (nonatomic, weak) UIButton *recharge;
// 14提现
@property (nonatomic, weak) UIButton *withdrawal;
// 15明细
@property (nonatomic, weak) UIButton *detail;
// 16toolView分割线左
@property (nonatomic, weak) UIView *separatorL;
// 17toolView分割线右
@property (nonatomic, weak) UIView *separatorR;
@end

@implementation AJAccountHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = KColor;
        // 1.消息按钮
        UIButton *message = [UIButton buttonWithType:UIButtonTypeCustom];
        message.backgroundColor = [UIColor clearColor];
        [message setImage:[UIImage imageNamed:@"Account_message"] forState:UIControlStateNormal];
        message.showsTouchWhenHighlighted = YES;
        [self addSubview:message];
        self.message = message;
        [message addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        //2.头像
        UIButton *head = [UIButton buttonWithType:UIButtonTypeCustom];
        head.backgroundColor = KblackgroundColor;
        [head setBackgroundImage:[UIImage imageNamed:@"Account_portrait"] forState:UIControlStateNormal];
        head.adjustsImageWhenHighlighted = NO;
        head.showsTouchWhenHighlighted = YES;
        [self addSubview:head];
        self.head = head;
        [head addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        // 2.5 修改头像
        UIImageView *pencil = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Account_icon_modify"]];
        self.headModify = pencil;
        [self addSubview:pencil];
        
        //3 昵称
        UILabel *nickName = [[UILabel alloc] init];
        nickName.font = [UIFont systemFontOfSize:14];
        nickName.textColor = [UIColor whiteColor];
        nickName.textAlignment = NSTextAlignmentCenter;
        [self addSubview:nickName];
        self.nickname = nickName;
        nickName.text = @"朱家丶大虾";
        //4 账户数额
        UILabel *accountAmount = [[UILabel alloc] init];
        accountAmount.font = [UIFont systemFontOfSize:28];
        accountAmount.textColor = [UIColor whiteColor];
        accountAmount.textAlignment = NSTextAlignmentCenter;
        [self addSubview:accountAmount];
        self.accountAmount = accountAmount;
        self.accountAmount.text = @"0.00";
        //5 账户总额（元）
        UILabel *amountText = [[UILabel alloc] init];
        amountText.font = [UIFont systemFontOfSize:14];
        amountText.textColor = [UIColor whiteColor];
        amountText.textAlignment = NSTextAlignmentCenter;
        amountText.text = @"账户总额（元）";
        [self addSubview:amountText];
        self.amountText = amountText;
        // 收益余额
        [self initBottomV];
        // 提现 明细
        [self initToolView];
    }
    return self;
}
- (void)initToolView
{
    // 充值、提现、明细
    UIView *toolView = [[UIView alloc] init];
    toolView.backgroundColor = [UIColor whiteColor];
    [self addSubview:toolView];
    self.toolView = toolView;
    // 添加按钮充值
    UIButton *recharge = [UIButton buttonWithType:UIButtonTypeCustom];
    //        recharge.backgroundColor = [UIColor clearColor];
    [toolView addSubview:recharge];
    self.recharge = recharge;
    [recharge setTitle:@"充值" forState:UIControlStateNormal];
    recharge.titleLabel.font = [UIFont systemFontOfSize:20];
    [recharge setTitleColor:[ColorTools colorWithHexString:kRechargeColor] forState:UIControlStateNormal];
    [recharge addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    // 添加按钮提现
    UIButton *withdrawal = [UIButton buttonWithType:UIButtonTypeCustom];
    //        recharge.backgroundColor = [UIColor clearColor];
    [toolView addSubview:withdrawal];
    self.withdrawal = withdrawal;
    [withdrawal setTitle:@"提现" forState:UIControlStateNormal];
    withdrawal.titleLabel.font = [UIFont systemFontOfSize:20];
    [withdrawal setTitleColor:[ColorTools colorWithHexString:kRechargeColor] forState:UIControlStateNormal];
    [withdrawal addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    // 添加按钮明细
    UIButton *detail = [UIButton buttonWithType:UIButtonTypeCustom];
    //        recharge.backgroundColor = [UIColor clearColor];
    [toolView addSubview:detail];
    self.detail = detail;
    [detail setTitle:@"明细" forState:UIControlStateNormal];
    detail.titleLabel.font = [UIFont systemFontOfSize:20];
    [detail setTitleColor:[ColorTools colorWithHexString:kRechargeColor] forState:UIControlStateNormal];
    [detail addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    // 分割线左边
    UIView *separatorL = [[UIView alloc] init];
    separatorL.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [toolView addSubview:separatorL];
    self.separatorL = separatorL;
    // 分割线右边
    UIView *separatorR = [[UIView alloc] init];
    separatorR.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [toolView addSubview:separatorR];
    self.separatorR = separatorR;

}
- (void)initBottomV
{
    //6 收益和余额
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    view.backgroundColor = [ColorTools colorWithHexString:kbottomBgColor];
    self.bottomV = view;
    //6.1 收益数额
    UILabel *income = [[UILabel alloc] init];
    income.font = [UIFont systemFontOfSize:15];
    income.textColor = [UIColor whiteColor];
    income.backgroundColor = [UIColor clearColor];
    income.textAlignment = NSTextAlignmentCenter;
    [view addSubview:income];
    self.income = income;
    self.income.text = @"0.00";
    //6.2 收益总额（元）
    UILabel *incometext = [[UILabel alloc] init];
    incometext.font = self.amountText.font;
    incometext.textColor = [UIColor whiteColor];
    incometext.backgroundColor = [UIColor clearColor];
    incometext.textAlignment = NSTextAlignmentCenter;
    incometext.text = @"累计收益（元）";
    [view addSubview:incometext];
    self.incometext = incometext;
    // 分割线
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = KColor;
    [view addSubview:separator];
    self.separator = separator;
    //6.3 可用数额
    UILabel *left = [[UILabel alloc] init];
    left.font = income.font;
    left.textColor = [UIColor whiteColor];
    left.backgroundColor = [UIColor clearColor];
    left.textAlignment = NSTextAlignmentCenter;
    [view addSubview:left];
    left.text = @"0.00";
    self.left = left;
    //6.4 可用总额（元）
    UILabel *leftText = [[UILabel alloc] init];
    leftText.font = self.amountText.font;
    leftText.textColor = [UIColor whiteColor];
    leftText.textAlignment = NSTextAlignmentCenter;
    leftText.backgroundColor = [UIColor clearColor];
    leftText.text = @"可用余额（元）";
    [view addSubview:leftText];
    self.leftText = leftText;

}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat selfW = self.bounds.size.width;
    CGFloat selfH = self.bounds.size.height;
    // 1.消息按钮
    CGSize messageSize = self.message.currentImage.size;
    CGFloat traing = 20.f;
    self.message.frame = CGRectMake(selfW - messageSize.width - traing, 30.f, messageSize.width, messageSize.height);
    //2.头像
//    CGSize headSize = self.head.currentImage.size;
    CGFloat headH = 145.f/2;
    CGFloat headX = (selfW - headH)/2;
    self.head.layer.cornerRadius = headH/2;
    self.head.layer.masksToBounds = YES;
    self.head.frame = CGRectMake(headX, 128.f/2, headH, headH);
    // 2.5 修改头像
    CGFloat headModifyH = 40.f/2;
    self.headModify.layer.cornerRadius = headModifyH/2;
    self.headModify.layer.masksToBounds = YES;
   self.headModify.frame = CGRectMake(selfW/2+26.f/2, 128.f/2, headModifyH, headModifyH);
    //3 昵称
    CGFloat nicknameW = selfW/2 + 100;
    CGFloat nicknameX = (selfW - nicknameW)/2;
    CGFloat nicknameY = CGRectGetMaxY(self.head.frame) + 20.f/2;
    self.nickname.frame = CGRectMake(nicknameX, nicknameY, nicknameW, 24.f/2);
    //4 账户数额
    CGFloat accountAmountY = CGRectGetMaxY(self.nickname.frame) + 32.f/2;
    self.accountAmount.frame = CGRectMake(nicknameX, accountAmountY, nicknameW, 52.f/2);
    //5 账户总额（元）
    CGFloat amountTextY = CGRectGetMaxY(self.accountAmount.frame) + 10.f/2;
    self.amountText.frame = CGRectMake(nicknameX, amountTextY, nicknameW, 20.f/2);
    //6 收益和余额
    CGFloat bottomH = 110.f/2;
    CGFloat toolViewH = 90.f/2;
    self.bottomV.frame = CGRectMake(0, selfH - bottomH - toolViewH, selfW, bottomH);
    //6.1 收益数额
    CGFloat incomeW = selfW/2-1.f;
    CGFloat incomeY = 16.0/2;
    CGFloat incomeH = 32.f/2;
    self.income.frame = CGRectMake(0, incomeY, incomeW, incomeH);
    //6.2 收益总额（元）
    CGFloat incometextY = CGRectGetMaxY(self.income.frame) + 10.f/2;
    CGFloat incometextH = 20.f/2;
    self.incometext.frame = CGRectMake(0, incometextY, incomeW, incometextH);
    // 分割线
    self.separator.frame = CGRectMake(incomeW, incomeY, 1.f, bottomH - 2*incomeY);
    //6.3 可用数额
    CGFloat leftX = selfW/2;
    self.left.frame = CGRectMake(leftX, incomeY, leftX, incomeH);
    //6.4 可用总额（元）
    self.leftText.frame = CGRectMake(leftX, incometextY, leftX, incometextH);
    
    // 充值、提现、明细
    self.toolView.frame = CGRectMake(0, selfH - toolViewH, selfW, toolViewH);
    // 添加按钮充值
    CGFloat rechargeW = (selfW - 2*1.f)/3;
    self.recharge.frame = CGRectMake(0, 0, rechargeW, toolViewH);
    // 分割线左边
    CGFloat separatorLH = 44.f/2;
    CGFloat separatorLY = (toolViewH - separatorLH)/2;
    self.separatorL.frame = CGRectMake(rechargeW, separatorLY, 1.f, separatorLH);
    // 添加按钮提现
    self.withdrawal.frame = CGRectMake(CGRectGetMaxX(self.separatorL.frame), 0, rechargeW, toolViewH);
    // 分割线右边
    self.separatorR.frame = CGRectMake(CGRectGetMaxX(self.withdrawal.frame), separatorLY, 1.f, separatorLH);
    // 添加按钮明细
    self.detail.frame = CGRectMake(CGRectGetMaxX(self.separatorR.frame), 0, rechargeW, toolViewH);
}

- (void)btnClick:(UIButton*)sender
{
    clickBtnTo btnTo = 0;
    if (sender == self.head) {//修改头像
        btnTo = clickBtnToPortrait;
    }else if (sender == self.message){// 邮件
        btnTo = clickBtnToMessage;
    }else if (sender == self.recharge){// 充值
        btnTo = clickBtnToRecharge;
    }else if (sender == self.withdrawal){//提现
        btnTo = clickBtnToWithdrawal;
    }else{//明细
        btnTo = clickBtnToDetail;
    }
    if ([self.delegate respondsToSelector:@selector(AJAccountHeaderViewWithClickBtnTo:)]) {
        [self.delegate AJAccountHeaderViewWithClickBtnTo:btnTo];
    }
}

- (instancetype)initWithDelegate:(id)delegate
{
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}
+ (instancetype)headerViewWithDelegate:(id)delegate
{
    return [[self alloc] initWithDelegate:delegate];
}
- (void)setAAJAccountHeaderData:(AJAccountHeaderData *)aAJAccountHeaderData
{
    _aAJAccountHeaderData = aAJAccountHeaderData;
    
    if(aAJAccountHeaderData.userImg){
        [self.head sd_setBackgroundImageWithURL:[NSURL URLWithString:aAJAccountHeaderData.userImg] forState:UIControlStateNormal];
//      [self.head sd_setImageWithURL:[NSURL URLWithString:aAJAccountHeaderData.userImg] forState:UIControlStateNormal];
    }
    self.nickname.text = aAJAccountHeaderData.userName;

    self.accountAmount.text = aAJAccountHeaderData.accountAmount;
    self.income.text = aAJAccountHeaderData.sum_income;
    self.left.text = aAJAccountHeaderData.availableBalance;
}
@end
