//
//  AJBorrowingDetailsHeader.m
//  SP2P_7
//
//  Created by Ajax on 16/1/22.
//  Copyright © 2016年 EIMS. All rights reserved.
//
#import "AJBorrowingDetailsHeader.h"
#import "LDProgressView.h"

@interface AJBorrowingDetailsHeader ()
@property (nonatomic,strong)UIImageView *typeImg;
@property (nonatomic,strong)UILabel *wayLabel;
@property (nonatomic,strong)UILabel *moneyLabel;
@property (nonatomic,strong)UILabel *rateLabel;
@property (nonatomic,strong)UILabel *deadlineLabel;
@property (nonatomic,strong)UILabel *dateLabel2;
@property (nonatomic,weak)UILabel *titleLabel; //借款标题
@property (nonatomic) NSTimeInterval time;//相差时间
@property (nonatomic,strong)UIImageView *roundimgView;
@property(nonatomic ,strong) UIButton *collectBtn;
@property (nonatomic,weak) UILabel *idLabel; // 编号
@property (nonatomic,strong)LDProgressView *progressView;
@property (nonatomic,strong)UILabel *progressLabel;
@property (nonatomic, weak) UILabel *amoutText;
@property (nonatomic, weak) UILabel *rateText;
@property (nonatomic, weak) UILabel *durationText;
@property (nonatomic, weak) UILabel *repayModeText;
@property (nonatomic, weak) UILabel *oganizationText;
@property (nonatomic,strong) UIImageView *clockImg;
@property (nonatomic,strong) UIView *dateBackView;
@property (nonatomic, weak) UIButton *leftTime;
@end

@implementation AJBorrowingDetailsHeader

- (UILabel *)labelViewWithFont:(CGFloat)size textColor:(UIColor*)color
{
    UILabel *idLabel = [[UILabel alloc] init];
    idLabel.textColor = color;
    idLabel.font = [UIFont systemFontOfSize:size];
    idLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:idLabel];
    idLabel.backgroundColor = [UIColor clearColor];
    return idLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat selfW = self.bounds.size.width;
    CGFloat selfH = self.bounds.size.height;
    // 1.编号
    CGFloat _idLabelX = kLabelBeginX;
     CGFloat _idLabelY = kPadding;
    CGFloat _idLabelW = 60.f;
    self.idLabel.frame = CGRectMake(_idLabelX, _idLabelY, _idLabelW, kidLabelH);
    
    self.titleLabel.frame = CGRectMake(_idLabelW + _idLabelX, _idLabelY, selfW - 120, kidLabelH);
    
    CGFloat typeImgW = 20.f;
    CGFloat typeImgTring = 20.f;
    self.typeImg.frame = CGRectMake(selfW - typeImgW - typeImgTring, _idLabelY, typeImgW, typeImgW);
    
    self.progressView.frame = CGRectMake(_idLabelX, 50, selfW - _idLabelX - 30 - 10, 4);
    
    self.roundimgView.frame = CGRectMake(selfW - 30 -10, 50 + 4/2 - 30/2, 30, 30);
    
    self.progressLabel.frame = CGRectMake(selfW - 30 -10,  50 + 4/2 - 15/2, 30, 15);

    CGFloat amoutTextH = 30.f;
    CGFloat amoutTextW = kAmoutTextW;
    CGFloat amoutTextY = CGRectGetMaxY(self.roundimgView.frame);
    self.amoutText.frame = CGRectMake(_idLabelX, amoutTextY , amoutTextW, amoutTextH);
    
    CGFloat rateTextY = CGRectGetMaxY(self.amoutText.frame);
    self.rateText.frame = CGRectMake(_idLabelX,  rateTextY, amoutTextW, amoutTextH);
    
    CGFloat durationTextY = CGRectGetMaxY(self.amoutText.frame);
    self.durationText.frame = CGRectMake(selfW/2 - 15,  durationTextY, amoutTextW, amoutTextH);
    
    CGFloat repayModeTextY = CGRectGetMaxY(self.rateText.frame);
    self.repayModeText.frame = CGRectMake(_idLabelX,  repayModeTextY, amoutTextW, amoutTextH);
    
//    self.organizationLabel.frame = CGRectMake(_idLabelX,  CGRectGetMaxY(self.repayModeText.frame), amoutTextW, amoutTextH);//
    
    self.dateBackView.frame = CGRectMake(_idLabelX, selfH - 30 - kPadding, selfW - _idLabelX, kLeftBgViewH);
    
    self.leftTime.frame = CGRectMake(0, 0, 110, kLeftBgViewH);
    
    self.dateLabel2.frame = CGRectMake(110 + kPadding, 0, selfW - _idLabelX - kPadding, kLeftBgViewH);
    
    CGFloat _moneyLabelX = CGRectGetMaxX(self.amoutText.frame);
    _moneyLabel.frame = CGRectMake(_moneyLabelX, amoutTextY, selfW - kPadding - _moneyLabelX, amoutTextH);
    
    _rateLabel.frame = CGRectMake(CGRectGetMaxX(self.rateText.frame),  rateTextY, 60, amoutTextH);
    
    CGFloat _wayLabelX = CGRectGetMaxX(self.repayModeText.frame);
    _wayLabel.frame = CGRectMake(_wayLabelX,  repayModeTextY, selfW - _wayLabelX - kPadding, amoutTextH);;
    
    CGFloat _deadlineLabelX = CGRectGetMaxX(self.durationText.frame);
    _deadlineLabel.frame =  CGRectMake(_deadlineLabelX,  durationTextY, selfW - kPadding - _deadlineLabelX, amoutTextH);
}

- (instancetype)initWithHeight:(CGFloat)height
{
    return [self initWithFrame:CGRectMake(0, 0, 0, height)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = KblackgroundColor;
        // 1.编号
        self.idLabel = [self labelViewWithFont:13.f textColor:[UIColor grayColor]];
        self.idLabel.adjustsFontSizeToFitWidth = YES;
        // 借款标题
        self.titleLabel = [self labelViewWithFont:15.f textColor:[ColorTools colorWithHexString:kblackColor]];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        _typeImg = [[UIImageView alloc] init];
        _typeImg.backgroundColor = [UIColor clearColor];
        [self addSubview:_typeImg];
        
        //    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom]; // 20160122--取消收藏
        //        _collectBtn.frame = CGRectMake(MSWIDTH - 30, 10, 20, 20);
        //        [_collectBtn setImage:[UIImage imageNamed:@"no_collection"] forState:UIControlStateNormal];
        //        [_collectBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //        [self addSubview:_collectBtn];
        
        
        _progressView = [[LDProgressView alloc] init];
        _progressView.color = GreenColor;
        _progressView.flat = @YES;// 是否扁平化
        _progressView.borderRadius = @0;
        _progressView.showBackgroundInnerShadow = @NO;
        _progressView.animate = @NO;
        _progressView.progressInset = @0;//内边的边距
        _progressView.showBackground = @YES;
        _progressView.outerStrokeWidth = @0;
        _progressView.showText = @NO;
        _progressView.showStroke = @NO;
        _progressView.background = [UIColor lightGrayColor];
        [self addSubview:_progressView];
        
        _roundimgView = [[UIImageView alloc] init];
        _roundimgView.image = [UIImage imageNamed:@"round_back"];
        [self addSubview:_roundimgView];
        
        _progressLabel = [self labelViewWithFont:10 textColor:[UIColor whiteColor]];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.adjustsFontSizeToFitWidth = YES;
        
        self.amoutText =  [self labelViewWithFont:12.f textColor:self.titleLabel.textColor];
        self.amoutText.text = @"借款金额:";
        
        self.rateText =  [self labelViewWithFont:12.f textColor:self.titleLabel.textColor];
        self.rateText.text = @"年  利  率:";
        
        self.durationText =  [self labelViewWithFont:12.f textColor:self.titleLabel.textColor];
        self.durationText.text = @"借款期限:";
        
        self.repayModeText =  [self labelViewWithFont:12.f textColor:self.titleLabel.textColor];
        self.repayModeText.text = @"还款方式:";
        
        _moneyLabel = [self labelViewWithFont:12.f textColor:PinkColor];
        
        _rateLabel = [self labelViewWithFont:12.f textColor:PinkColor];
        
        _wayLabel = [self labelViewWithFont:12.f textColor:[UIColor darkGrayColor]];
        
        _deadlineLabel = [self labelViewWithFont:12.f textColor:[UIColor darkGrayColor]];
        
        self.dateBackView = [[UIView alloc] init];
        [self addSubview:self.dateBackView];
        self.dateBackView.backgroundColor = [UIColor whiteColor];
        
        UIButton *leftTime = [UIButton buttonWithType:UIButtonTypeCustom];
        leftTime.backgroundColor = SETCOLOR(229, 59, 80, 1);
        [leftTime setTitle:@"剩余时间" forState:UIControlStateNormal];
        [leftTime setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        leftTime.userInteractionEnabled = NO;
        leftTime.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [leftTime setImage:[UIImage imageNamed:@"clock_big"] forState:UIControlStateNormal];
        leftTime.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        self.leftTime = leftTime;
        [self.dateBackView addSubview:leftTime];
        
        _dateLabel2 = [[UILabel alloc] init];
        _dateLabel2.textColor = PinkColor;
        _dateLabel2.font = [UIFont boldSystemFontOfSize:14.0f];
        _dateLabel2.textAlignment = NSTextAlignmentLeft;
        [self.dateBackView addSubview:_dateLabel2];
        _dateLabel2.backgroundColor = [UIColor clearColor];

    }
    return self;
}
@end
