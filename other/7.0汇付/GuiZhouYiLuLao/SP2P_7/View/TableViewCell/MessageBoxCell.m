//
//  MessageBoxCell.m
//  SP2P_7
//
//  Created by kiu on 14-9-29.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "MessageBoxCell.h"

#import "MessageBox.h"

@interface MessageBoxCell()

@property (nonatomic , strong) id object;

@property (nonatomic,strong) UILabel *titleName;                // 标题
@property (nonatomic,strong) UILabel *timeLabel;                 // 发送时间
@property (nonatomic,strong) UILabel *contentLabel;              // 简介
@property (nonatomic,strong) UIImageView *statusImage;           // 状态
@property (nonatomic,strong) UIImageView *selectImage;
@end

@implementation MessageBoxCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        
        _statusImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_statusImage];
        
        _selectImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_selectImage];
        
        _titleName = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleName.font = [UIFont boldSystemFontOfSize:16.0f];
        _titleName.textColor = [UIColor blackColor];
        [self addSubview:_titleName];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.font = [UIFont systemFontOfSize:12.0f];
        _contentLabel.numberOfLines = 0;
        
        _contentLabel.textColor = [UIColor grayColor];
        [self addSubview:_contentLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_timeLabel];
    }
    
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.object) {
        
        if ([self.object isMemberOfClass:[MessageBox class]]) {
            MessageBox *object = self.object;
            _statusImage.frame = CGRectMake(13, 12, 12, 12);
//            _selectImage.frame = CGRectMake(11, 29, 24, 24);
            _selectImage.frame = CGRectMake(11, self.frame.size.height/2-11, 24, 24);
            _contentLabel.frame = CGRectMake(35, 32, self.frame.size.width - 60, 40);
            _titleName.frame = CGRectMake(35, 8, 200, 20);
            _timeLabel.frame = CGRectMake(self.frame.size.width - 70, 8, 50, 20);
            
            _timeLabel.text = object.timeStr;
           
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            UIFont *font = [UIFont boldSystemFontOfSize:12.f];
            NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
            CGSize contentSize = [object.content boundingRectWithSize:CGSizeMake(MSWIDTH-70, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            _contentLabel.frame = CGRectMake(35, 32, MSWIDTH-70, contentSize.height);
             _contentLabel.text = object.content;
            
            _titleName.text = object.titleName;
            if ([object.status isEqualToString:@"未读"]) {
                _statusImage.image = [UIImage imageNamed:@"round_back"];
            }else {
                _statusImage.image = nil;
                
            }
            if ([object.selectall isEqualToString:@"1"]) {
                _selectImage.image = [UIImage imageNamed:@"checkbox2_checked"];
            }else {
                _selectImage.image = nil;
                
            }
            
        }
    }
}

- (void)fillCellWithObject:(id)object
{
    self.object = object;
}

@end
