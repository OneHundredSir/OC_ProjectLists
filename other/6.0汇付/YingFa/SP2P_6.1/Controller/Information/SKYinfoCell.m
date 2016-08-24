//
//  SKYinfoCell.m
//  LX-UI模板
//
//  Created by eims1 on 15/10/31.
//  Copyright (c) 2015年 sky. All rights reserved.
//

#import "SKYinfoCell.h"
//#import "AdvertiseGallery.h"
//#import "UIImageView+WebCache.h"

@implementation SKYinfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _cityImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 90, 90)];
        _cityImgView.userInteractionEnabled = NO;
                [self addSubview:_cityImgView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, 20)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_titleLabel];
        
        _contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 30, self.frame.size.width-20, 60)];
        //        _contentWebView.scalesPageToFit = YES;
        _contentWebView.scrollView.scrollEnabled = NO;
        _contentWebView.userInteractionEnabled = NO;
//        [self addSubview:_contentWebView];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 90, 20)];
        _dateLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _dateLabel.textColor = [UIColor darkGrayColor];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dateLabel];
        
        _readNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-120, 100, 110, 20)];
        _readNumLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _readNumLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_readNumLabel];
        
    }
    return self;
}

/*
- (void)fillCellWithObject:(AdvertiseGallery *)object
{
//    DLOG(@"object = %@",object.date);
    //    if ([object.image isEqualToString:Baseurl]) {
    //        _cityImgView.image = [UIImage imageNamed:@"news_image_default"];
    //    }else
    //    {
    //        [_cityImgView sd_setImageWithURL:[NSURL URLWithString:object.image] placeholderImage:[UIImage imageNamed:@"news_image_default"]];
    //
    //    }
    
 
    _titleLabel.text = object.title;
    if (![object.content isEqual:[NSNull null]]) {
        object.content = [object.content stringByReplacingOccurrencesOfString:@"alt=\"\" " withString:@""];
        
        object.content = [object.content stringByReplacingOccurrencesOfString:@"<img src=\"/" withString:[NSString stringWithFormat:@"<img src=\"%@/", Baseurl]]; //替换相对路径
        
        //            _contentStr = [_contentStr stringByReplacingOccurrencesOfString:@"<img src=\"/" withString:[NSString stringWithFormat:@"<img style=\"width:%f\" src=\"%@/", self.view.frame.size.width - 20, Baseurl]]; //替换相对路径
        
        //        DLOG(@"width: %f", self.view.frame.size.width - 20);
        
        [_contentWebView loadHTMLString:object.content baseURL:nil];
    }
    
    
    _dateLabel.text = object.date;
    _readNumLabel.text = object.read_count;
 
}
*/

@end
