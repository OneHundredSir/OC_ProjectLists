//
//  AskBorrowerCell.m
//  SP2P_7
//
//  Created by Jerry on 14-9-26.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "AskBorrowerCell.h"

@implementation AskBorrowerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 5, self.frame.size.width-50, 35)];
        _questionLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _questionLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _questionLabel.numberOfLines = 0;
        _questionLabel.adjustsFontSizeToFitWidth = YES;
        _questionLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_questionLabel];
        
        
        UILabel *linelabel = [[UILabel alloc] initWithFrame:CGRectMake(15,36, self.frame.size.width-30,0.2)];
        linelabel.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:linelabel];
        
        
        UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 38,25,15)];
        textlabel.text = @"答:";
        textlabel.font = [UIFont boldSystemFontOfSize:12.0f];
        textlabel.textColor = [UIColor grayColor];
        [self addSubview:textlabel];
        
        
        _answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(31,38, self.frame.size.width-50, 40)];
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

@end
