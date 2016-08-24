//
//  MainTableViewCell.h
//  Flower
//
//  Created by HUN on 16/7/9.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@class  MainTableModel;
@interface MainTableViewCell : UITableViewCell


@property(nonatomic,copy)void (^mediaBtnBlock)(UIButton *btn);

@property(nonatomic,strong)MainTableModel *model;

@property(nonatomic,strong)MPMoviePlayerController *moviePlayer;

@end
