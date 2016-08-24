//
//  AskBorrowerCell.m
//  SP2P_7
//
//  Created by Jerry on 14-9-26.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "AskBorrowerCell.h"
#import "Questions.h"

@implementation AskBorrowerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 14, 15, 15)];
        _numLabel.layer.cornerRadius = 7.5f;
        _numLabel.layer.masksToBounds = YES;
        _numLabel.font = [UIFont systemFontOfSize:11.0f];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.adjustsFontSizeToFitWidth = YES;
        _numLabel.backgroundColor = PinkColor;
        _numLabel.textColor = [UIColor whiteColor];
        [self addSubview:_numLabel];
        
        
        _questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 5, MSWIDTH-50, 35)];
        _questionLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _questionLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _questionLabel.numberOfLines = 0;
        _questionLabel.adjustsFontSizeToFitWidth = YES;
        _questionLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_questionLabel];
        
        
        _linelabel = [[UILabel alloc] initWithFrame:CGRectMake(15,36, MSWIDTH-30,0.2)];
        _linelabel.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_linelabel];
        
        
        _textlabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 38,25,15)];
        _textlabel.text = @"答:";
        _textlabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _textlabel.textColor = [UIColor grayColor];
        [self addSubview:_textlabel];
        
        
        _answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(31,38, MSWIDTH-50, 40)];
        _answerLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _answerLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _answerLabel.textColor = [UIColor grayColor];
        _answerLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _answerLabel.numberOfLines = 0;
        _answerLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_answerLabel];
        
        
        _questionName = [[UILabel alloc] initWithFrame:CGRectMake(20,75, 130, 20)];
        _questionName.font = [UIFont boldSystemFontOfSize:12.0f];
        _questionName.textColor = [UIColor grayColor];
        [self addSubview:_questionName];
        
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 75, 200, 20)];
        _timeLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _timeLabel.textColor = [UIColor grayColor];
        [self addSubview:_timeLabel];
        
    }
    
    return self;
}




- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.object) {
        
        if ([self.object isMemberOfClass:[Questions class]])
        {
            Questions *model = self.object;
            _questionLabel.text = model.question;
            _answerLabel.text = [NSString stringWithFormat:@"%@",model.answerStr];
            _questionName.text = model.answerName;
            _timeLabel.text = model.answerTime;
            
            
            _numLabel.frame = CGRectMake(9, 5, 15, 15);
            _questionLabel.frame = CGRectMake(28, 5, MSWIDTH-50, model.contentHeight);
            _linelabel.frame = CGRectMake(15,CGRectGetMaxY(_questionLabel.frame)+2, MSWIDTH-30,0.2);
            _textlabel.frame = CGRectMake(14, CGRectGetMaxY(_questionLabel.frame)+5,25,15);
            _answerLabel.frame = CGRectMake(31,CGRectGetMaxY(_questionLabel.frame)+5, MSWIDTH-50, model.answerSize);
            _questionName.frame = CGRectMake(20,CGRectGetMaxY(_answerLabel.frame)+10, 130, 20);
            _timeLabel.frame = CGRectMake(MSWIDTH-140, CGRectGetMaxY(_answerLabel.frame)+10, 200, 20);
            
        }
    }
    
}

- (void)fillCellWithObject:(id)object
{
    self.object = object;
}


@end
