//
//  InvestmentTableViewCell.m
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "InvestmentTableViewCell.h"

#import "LDProgressView.h"
#import "ColorTools.h"
#import <QuartzCore/QuartzCore.h>

#import "Investment.h"
//#import "UIImageView+WebCache.h"


@interface InvestmentTableViewCell()

@property (nonatomic , strong) id object;

//@property (nonatomic , strong) UIImageView *showImageView;

@property (nonatomic , strong) UIImageView *showImageView;

@property (nonatomic , strong) UIImageView *highqualityImg;

@property (nonatomic , strong) UIImageView *LevelImageView;

@property (nonatomic , strong) UILabel *titleLabel;

@property (nonatomic , strong) UILabel *amountLabel;
@property (nonatomic , strong) UILabel *timeLabel;
@property (nonatomic , strong) UILabel *rateLabel;

@property (nonatomic , strong) UILabel *lineLabel1;
@property (nonatomic , strong) UILabel *lineLabel2;

@property (nonatomic , strong) UILabel *amountLabelValue;
@property (nonatomic , strong) UILabel *timeLabelValue;
@property (nonatomic , strong) UILabel *rateLabelValue;
@property (nonatomic , strong) UILabel *percentLabel;

@property (nonatomic , strong) UILabel *progressLabel;

//@property (nonatomic , strong) UIButton *calculatorView;

@property (nonatomic , strong) LDProgressView *progressView;

@property (nonatomic , strong) UIView *RoundView;

@property (nonatomic , strong) UIImageView *line;

@end

@implementation InvestmentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        _showImageView.layer.cornerRadius = 30;
        _showImageView.userInteractionEnabled = NO;
        _showImageView.layer.masksToBounds = YES;
        [self addSubview:_showImageView];
        
        
        _highqualityImg  = [[UIImageView alloc] initWithFrame:CGRectMake(54, 5, 15, 15)];
        [self addSubview:_highqualityImg];
        
        _LevelImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _LevelImageView.contentMode = UIViewContentModeScaleAspectFill;
       
        [self addSubview:_LevelImageView];
        
        
    
        _progressView = [[LDProgressView alloc] initWithFrame:CGRectZero];
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
    
        
        _RoundView= [[UIView alloc] init];
        _RoundView.frame = CGRectMake(self.frame.size.width - 40, 14, 28, 28);
        _RoundView.userInteractionEnabled = NO;
        _RoundView.layer.cornerRadius = 14;
        _RoundView.backgroundColor = GreenColor;
        _RoundView.layer.masksToBounds = YES;
        [self addSubview:_RoundView];
        
        
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 40, 20, 30, 15)];
        _progressLabel.font = [UIFont boldSystemFontOfSize:9.0];
        _progressLabel.backgroundColor = [UIColor clearColor];
        _progressLabel.textColor = [UIColor whiteColor];
        _progressLabel.adjustsFontSizeToFitWidth = YES;
        [self insertSubview:_progressLabel aboveSubview:_RoundView];
        
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:13];
        _titleLabel.textColor = [ColorTools colorWithHexString:@"#333333"];
        _titleLabel.backgroundColor = [UIColor clearColor];
        //_titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _timeLabelValue.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
        
        _amountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _amountLabel.font = [UIFont systemFontOfSize:11];
        _amountLabel.textColor = [ColorTools colorWithHexString:@"#808080"];
        _amountLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _amountLabel.backgroundColor = [UIColor clearColor];
        _amountLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_amountLabel];
        
        _lineLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
        _lineLabel1.font = [UIFont systemFontOfSize:11];
        _lineLabel1.backgroundColor = [UIColor lightGrayColor];
        _lineLabel1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lineLabel1];
   
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.textColor = [ColorTools colorWithHexString:@"#808080"];
        _timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_timeLabel];
        
        _lineLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
        _lineLabel2.font = [UIFont systemFontOfSize:11];
        _lineLabel2.backgroundColor = [UIColor lightGrayColor];
        _lineLabel2.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lineLabel2];
        
        _rateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _rateLabel.font = [UIFont systemFontOfSize:11];
        _rateLabel.textColor = [ColorTools colorWithHexString:@"#808080"];
        _rateLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _rateLabel.backgroundColor = [UIColor clearColor];
        _rateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_rateLabel];
        
        _amountLabelValue = [[UILabel alloc] initWithFrame:CGRectZero];
        _amountLabelValue.font = [UIFont systemFontOfSize:11];
        _amountLabelValue.textColor = [ColorTools colorWithHexString:@"#808080"];
        _amountLabelValue.lineBreakMode = NSLineBreakByWordWrapping;
        _amountLabelValue.backgroundColor = [UIColor clearColor];
        _amountLabelValue.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_amountLabelValue];
        
        _timeLabelValue = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabelValue.font = [UIFont systemFontOfSize:11];
        _timeLabelValue.textColor = [ColorTools colorWithHexString:@"#808080"];
        _timeLabelValue.lineBreakMode = NSLineBreakByWordWrapping;
        _timeLabelValue.backgroundColor = [UIColor clearColor];
        _timeLabelValue.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_timeLabelValue];
        
        _rateLabelValue = [[UILabel alloc] initWithFrame:CGRectZero];
        _rateLabelValue.font = [UIFont fontWithName:@"Arial-BoldMT" size:23];
        _rateLabelValue.textColor = PinkColor;
        _rateLabelValue.lineBreakMode = NSLineBreakByWordWrapping;
        _rateLabelValue.backgroundColor = [UIColor clearColor];
        _rateLabelValue.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_rateLabelValue];
        
        
        
       _percentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _percentLabel.font = [UIFont boldSystemFontOfSize:11];
        _percentLabel.textColor = PinkColor;
        _percentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _percentLabel.backgroundColor = [UIColor clearColor];
        _percentLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_percentLabel];
        
        
        
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _progressLabel.font = [UIFont systemFontOfSize:11];
        _progressLabel.textColor = [UIColor lightGrayColor];
        _progressLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _progressLabel.backgroundColor = [UIColor clearColor];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_progressLabel];
        
        _calculatorView = [[UIButton alloc] initWithFrame:CGRectZero];
        _calculatorView.backgroundColor = [UIColor clearColor];
        _calculatorView.tintColor = [UIColor clearColor];
        [_calculatorView setImage:[UIImage imageNamed:@"menu_calculator1"] forState:UIControlStateNormal];
        [_calculatorView setImage:[UIImage imageNamed:@"menu_calculator1"] forState:UIControlStateHighlighted];
        
        [self addSubview:_calculatorView];
        
        [_calculatorView addTarget:self action:@selector(calculatorClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _line =[[UIImageView alloc]initWithFrame:CGRectZero];
        _line.backgroundColor = KlayerBorder;
        [self addSubview:_line];
    }
    return self;
}

- (void) calculatorClick:(id) sender
{
  
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.object) {
        if ([self.object isMemberOfClass:[Investment class]]) {
            Investment *object = self.object;
            
            
            _showImageView.frame = CGRectMake(10, 10, 60, 60);

            
            if ([[NSString stringWithFormat:@"%@",object.imgurl] hasPrefix:@"http"]) {
                
                [_showImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",object.imgurl]]placeholderImage:[UIImage imageNamed:@"news_image_default"]];
            }else{
                
                [_showImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Baseurl,object.imgurl]] placeholderImage:[UIImage imageNamed:@"news_image_default"]];
            }
            
           
            _highqualityImg.frame = CGRectMake(54, 8, 15, 15);
            
            if (object.isQuality)
            {
                _highqualityImg.image = [UIImage imageNamed:@"high_hot"];
            }else{
                _highqualityImg.image = nil;
            }
            
            
            _LevelImageView.backgroundColor = [UIColor clearColor];
            _LevelImageView.frame = CGRectMake(CGRectGetMaxX(_showImageView.frame) + 11, CGRectGetMinY(_showImageView.frame)-2,20, 15);
            
            if ([[NSString stringWithFormat:@"%@",object.levelStr] hasPrefix:@"http"]) {
                
                  [_LevelImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",object.levelStr]]];
            }else{
                
                  [_LevelImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Baseurl,object.levelStr]]];
            }

            _titleLabel.text = object.title;
            _titleLabel.frame = CGRectMake(CGRectGetMaxX(_showImageView.frame) + 35, CGRectGetMinY(_showImageView.frame)-5,CGRectGetWidth(self.bounds) - CGRectGetMaxX(_showImageView.frame) - 72, 20);
            
            _calculatorView.frame = CGRectMake(CGRectGetWidth(self.bounds)-40 , CGRectGetHeight(self.bounds) - 35, 30, 30);
            
            _progressView.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame)-25, CGRectGetMaxY(_titleLabel.frame) + 2, self.frame.size.width - 120, 3);
            _progressView.progress = object.progress / 100.0;
            
            
             _RoundView.backgroundColor = GreenColor;
             _RoundView.frame = CGRectMake(self.frame.size.width - 40, 14, 28, 28);
         
            _progressLabel.text = [NSString stringWithFormat:@"%d%%",(int)object.progress];
            _progressLabel.textColor = [UIColor whiteColor];
            _progressLabel.frame = CGRectMake(self.frame.size.width-40, 20, 30, 15);
            
            
            _amountLabel.text = @"借款金额";
            _amountLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame)-35, CGRectGetMaxY(_progressView.frame) + 10, (CGRectGetMinX(_calculatorView.frame) - CGRectGetMinX(_titleLabel.frame) - 10)*0.4, 15);
            
            
            _lineLabel1.frame = CGRectMake(CGRectGetMaxX(_amountLabel.frame)-4, CGRectGetMaxY(_progressView.frame) + 15, 0.2, 25);
            
            _timeLabel.text = @"借款期限";
            _timeLabel.frame = CGRectMake(CGRectGetMaxX(_amountLabel.frame)-2, CGRectGetMaxY(_progressView.frame) + 10, (CGRectGetMinX(_calculatorView.frame) - CGRectGetMinX(_titleLabel.frame) - 10)*0.3, 15);
            
            _lineLabel2.frame = CGRectMake(CGRectGetMaxX(_timeLabel.frame)+1, CGRectGetMaxY(_progressView.frame) + 15, 0.2, 25);

            
            _percentLabel.text = @"%";
            _percentLabel.frame = CGRectMake(self.frame.size.width - 88, CGRectGetMaxY(_progressView.frame) + 20, 15, 15);
            
            _rateLabel.text = @"年利率";
            _rateLabel.frame = CGRectMake(CGRectGetMaxX(_percentLabel.frame) + 3, CGRectGetMaxY(_progressView.frame) + 20, 35, 15);
            
            
            _amountLabelValue.text =[NSString stringWithFormat:@"￥%0.1f",object.amount];
            _amountLabelValue.adjustsFontSizeToFitWidth = YES;
            _amountLabelValue.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame)-35, CGRectGetMaxY(_amountLabel.frame) + 2, (CGRectGetMinX(_calculatorView.frame) - CGRectGetMinX(_titleLabel.frame) - 10)*0.4-3.5, 15);
       
         
            
            if([object.unitstr isEqualToString:@"0"]){
            
            _timeLabelValue.text = [NSString stringWithFormat:@"%@个月",object.time];
           
            }  else if([object.unitstr isEqualToString:@"-1"]){
                 _timeLabelValue.text = [NSString stringWithFormat:@"%@年",object.time];
            }
            else
            _timeLabelValue.text = [NSString stringWithFormat:@"%@天",object.time];
          
            _timeLabelValue.frame = CGRectMake(CGRectGetMaxX(_amountLabel.frame)-2, CGRectGetMaxY(_amountLabel.frame) + 2, (CGRectGetMinX(_calculatorView.frame) - CGRectGetMinX(_titleLabel.frame) - 10)*0.3, 15);

          
            _rateLabelValue.text = [NSString stringWithFormat:@"%0.1f",object.rate];
            _rateLabelValue.frame = CGRectMake(CGRectGetMaxX(_timeLabel.frame)+2, CGRectGetMaxY(_amountLabel.frame)-14, (CGRectGetMinX(_calculatorView.frame) - CGRectGetMinX(_titleLabel.frame) - 10)*0.3, 30);
            
            
            
            _line.frame = CGRectMake(5, self.frame.size.height-1, self.frame.size.width-10, 1);

        }
    }
}

- (void)fillCellWithObject:(id)object
{
    self.object = object;
}

- (NSString *)replyCount:(NSString *)replyCount
{
    int count = [replyCount intValue];
    if (count < 10000) {
        return replyCount;
    }else{
        return [NSString stringWithFormat:@"%.1f万",count / 10000.0];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
