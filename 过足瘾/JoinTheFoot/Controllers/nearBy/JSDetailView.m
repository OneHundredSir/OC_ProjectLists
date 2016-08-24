//
//  JSDetailView.m
//  JoinTheFoot
//
//  Created by skd on 16/6/28.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import "JSDetailView.h"

@interface JSDetailView ()
@property (weak, nonatomic) IBOutlet UIView *imageArear;
@property (weak, nonatomic) IBOutlet UIButton *vipBtn;
@property (weak, nonatomic) IBOutlet UIButton *gzbtn;
@property (weak, nonatomic) IBOutlet UIButton *lwbtn;
@property (weak, nonatomic) IBOutlet UILabel *footNum;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blackBgConstrant;

@end

@implementation JSDetailView

- (void)setJsModel:(JSModel *)jsModel
{
    _jsModel = jsModel;
    
    [_vipBtn setTitle:[NSString stringWithFormat:@"  %@",jsModel.v_score] forState:UIControlStateNormal];
    [_gzbtn setTitle:[NSString stringWithFormat:@"  %@",jsModel.invite_code] forState:UIControlStateNormal];
    [_lwbtn setTitle:[NSString stringWithFormat:@"  %@",jsModel.v_totle] forState:UIControlStateNormal];
    _footNum.text = [NSString stringWithFormat:@"%@",jsModel.member_id];

    [self getAllImage];
    
    

}

- (void) getAllImage
{
    NSMutableDictionary *pragram1 = [NSMutableDictionary dictionary];
    //    设置相关参数
    [pragram1 setObject:@1 forKey:@"appid"];
    [pragram1 setObject:@22.535868 forKey:@"latitude"];
    [pragram1 setObject:@113.950943 forKey:@"longitude"];
    [pragram1 setObject:@"BCCFFAAB6A7D79D1E6D1478F2B432B83CD451E2660F067BF" forKey:@"memberdes"];
    [pragram1 setObject:self.jsModel.mobile_guid forKey:@"userguid"];

    [WDHttpRequest postWithURL:@"http://gzy.api.kd52.com/photo.aspx?action=getallposi" pragram:pragram1 completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

        
        NSArray *items = dic[@"item"];
        CGFloat row = 0;
        CGFloat col = 0;
        CGFloat image_w = (kScreen_W - 50) / 4.0;
        CGFloat image_H = (kScreen_W - 50) / 4.0;

        if (items.count <= 0) {
//            没有图片的考虑
            self.blackBgConstrant.constant = (kScreen_W - 50) / 4.0 + 20;
             UIImageView *imagev = [[UIImageView alloc]initWithFrame:(CGRect){col * (image_w + 10) + 10, row * (image_H + 10) + 10,image_w,image_H}];
            [imagev sd_setImageWithURL:[NSURL URLWithString:self.jsModel.image_path] placeholderImage:[UIImage imageNamed:@"头像default"]];
            [self.imageArear addSubview:imagev];
            return ;
        }
        
        NSMutableArray *videos = [NSMutableArray array];
            int i = 0;
            for (; i < items.count; i ++) {
            NSDictionary *itemDic = items[i];
            row = i / 4;
            col = i % 4;
            
            NSString *imageURL = itemDic[@"image_path_thumbnail"];
            NSString *videoURL = itemDic[@"video_image_path"];
                
            if (![videoURL isEqualToString:@""]) {
                    [videos addObject:videoURL];
            }
                
            UIImageView *imagev = [[UIImageView alloc]initWithFrame:(CGRect){col * (image_w + 10) + 10, row * (image_H + 10) + 10,image_w,image_H}];
            imagev.layer.cornerRadius = 6;
            imagev.layer.masksToBounds = YES;
            [self.imageArear addSubview:imagev];
            [imagev sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"头像default"]
             ];
        }
        
        
        for (int j = i ; j < videos.count + i ; j ++)
        {
            row = j / 4;
            col = j % 4;
            UIImageView *videoimage = [[UIImageView alloc]initWithFrame:(CGRect){col * (image_w + 10) + 10, row * (image_H + 10) + 10,image_w,image_H}];
            [videoimage sd_setImageWithURL:[NSURL URLWithString:videos[j - i]] placeholderImage:nil];
            UIButton *videoBtn = [[UIButton alloc]initWithFrame:videoimage.frame];
            [videoBtn setImage:[UIImage imageNamed:@"播放按钮80"] forState:UIControlStateNormal];
            videoimage.layer.cornerRadius = 6;
            videoimage.layer.masksToBounds = YES;
            [self.imageArear addSubview:videoimage];
            [self.imageArear addSubview:videoBtn];
            
        }
        
        
         UIImageView *lastObject =  self.imageArear.subviews.lastObject;
        
        CGFloat ty = CGRectGetMaxY(lastObject.frame) + 10;
        
        self.blackBgConstrant.constant = ty;
        
        self.frame = CGRectMake(0, 0, kScreen_W, 100 + ty);
        if (self.getDataFinished) {
            self.getDataFinished();
        }
        
    }];
}

@end
