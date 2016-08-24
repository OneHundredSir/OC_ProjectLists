//
//  MainTableViewCell.m
//  Flower
//
//  Created by HUN on 16/7/9.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "MainTableViewCell.h"
#import "MainTableModel.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>


@interface MainTableViewCell ()



@property (weak, nonatomic) IBOutlet UIView *buttonView;

/**
 *  背景
 */
@property (weak, nonatomic) IBOutlet UIImageView *mainIcon;

/**
 *  按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *mainBtn;

/**
 *  人头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *personIcon;
/**
 *  VIP头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *VIcon;



/**
 *  主题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
/**
 *  主题描述
 */
@property (weak, nonatomic) IBOutlet UILabel *detailLB;
/**
 *  属性
 */
@property (weak, nonatomic) IBOutlet UILabel *propertyLB;
/**
 *  文章头
 */
@property (weak, nonatomic) IBOutlet UILabel *articletitelLB;

/**
 *  文章详情
 */
@property (weak, nonatomic) IBOutlet UILabel *articleDetailtitleLB;
/**
 *  评论数目
 */
@property (weak, nonatomic) IBOutlet UILabel *discussNumLB;
/**
 *  爱心数目
 */
@property (weak, nonatomic) IBOutlet UILabel *likeNumLB;
/**
 *  看的人数
 */
@property (weak, nonatomic) IBOutlet UILabel *viewNumLB;

@end

@implementation MainTableViewCell

-(void)setModel:(MainTableModel *)model
{
    _model = model;
    //设置背景大图
    [_mainIcon sd_setImageWithURL:[NSURL URLWithString:_model.smallIcon]];
    
    /**
     *  按钮
     */
    NSString *videoStr = _model.videoUrl;
    _mainBtn.hidden = videoStr.length>0?NO:YES;
    [_mainBtn addTarget:self action:@selector(vidoeBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.moviePlayer = [[MPMoviePlayerController alloc]init];
    
    [self addSubview:self.moviePlayer.view];
    
    //设置自己的个人图片
    [_personIcon sd_setImageWithURL:[NSURL URLWithString:_model.author.headImg]];
    _personIcon.layer.cornerRadius = _personIcon.frame.size.width/2.0;
    _personIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    _personIcon.layer.borderWidth = 1;
    _personIcon.clipsToBounds = YES;
    //设置点赞颜色,看下要不要判断
    NSString *imgStr = _model.author.newAuth==1?@"黄色v.png":@"黑色v.png";
//    NSLog(@"%d",_model.author.newAuth );
    _VIcon.image = [UIImage imageNamed:imgStr];
    
    /**
     *  主题
     */
    _titleLB.text = _model.author.userName;
    /**
     *  主题描述
     */
    _detailLB.text = _model.author.identity;
    /**
     *  属性
     */
    _propertyLB.text = [NSString stringWithFormat:@"[%@]",_model.category.name];
    /**
     *  文章头
     */
    _articletitelLB.text = _model.title;
    
    /**
     *  文章详情
     */
    _articleDetailtitleLB.text = _model.desc;
    
    /**
     *  评论数目
     */
    _discussNumLB.text = [NSString stringWithFormat:@"%d", _model.favo];
    /**
     *  爱心数目
     */
    _likeNumLB.text = [NSString stringWithFormat:@"%d", _model.fnCommentNum];
    /**
     *  看的人数
     */
    _viewNumLB.text = [NSString stringWithFormat:@"%d",_model.read];

    
}

-(void)vidoeBtn:(UIButton *)btn
{
    if (self.mediaBtnBlock) {
        self.mediaBtnBlock(btn);
    }
    [self createMPPlayerController:self.model.videoUrl];
}



- (void)createMPPlayerController:(NSString *)urlNamePath {
    NSURL *movieURL = [NSURL URLWithString:urlNamePath];
    MPMoviePlayerController *movewController =[[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    [movewController prepareToPlay];
    movewController.shouldAutoplay=YES;
    [movewController setControlStyle:MPMovieControlStyleDefault];
//    [movewController setFullscreen:YES];
    [movewController.view setFrame:_mainIcon.frame];
    [self.buttonView addSubview:movewController.view];//设置写在添加之后   // 这里是addSubView
    
    self.moviePlayer = movewController;
//    这里注册相关操作的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.moviePlayer]; //播放完后的通知
}

-(void)movieFinishedCallback:(NSNotification*)notify{
    // 视频播放完或者在presentMoviePlayerViewControllerAnimated下的Done按钮被点击响应的通知。
    MPMoviePlayerController* theMovie = [notify object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                   name:MPMoviePlayerPlaybackDidFinishNotification
                                                 object:theMovie];
    [theMovie.view removeFromSuperview];
}

@end
