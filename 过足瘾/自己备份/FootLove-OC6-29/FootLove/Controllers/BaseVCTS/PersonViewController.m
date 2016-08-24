//
//  PersonViewController.m
//  FootLove
//
//  Created by HUN on 16/6/27.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "PersonViewController.h"

@interface PersonViewController ()
//头像背景view
@property (weak, nonatomic) IBOutlet UIView *iconView;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
//抬头
@property (weak, nonatomic) IBOutlet UILabel *iconTitle;
//点赞数
@property (weak, nonatomic) IBOutlet UILabel *zanCount;
//粉丝数目
@property (weak, nonatomic) IBOutlet UILabel *fansCount;
//礼物数目
@property (weak, nonatomic) IBOutlet UILabel *giftCount;
//关注数目
@property (weak, nonatomic) IBOutlet UILabel *focusCount;

//个人设置
@property (weak, nonatomic) IBOutlet UIButton *userConfig;

//手艺认证
@property (weak, nonatomic) IBOutlet UIButton *artConfig;

//系统设置
@property (weak, nonatomic) IBOutlet UIButton *sysConfig;

@property(nonatomic,strong)UIButton *lastBtn;

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=W_BackColor;
    [self _initBtn];
    [self _initIcon];
    
}
#pragma mark 设置头像
-(void)_initIcon
{
    _iconView.layer.cornerRadius = _iconView.frame.size.width/2.0;
    _iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconView.layer.borderWidth = 2;
    
    _iconImage.layer.cornerRadius = _iconImage.frame.size.width/2.0;
    _iconImage.clipsToBounds = YES;
    _iconImage.image = [UIImage imageNamed:@"me.jpg"];
}

#pragma mark 设置按钮
-(void)_initBtn
{
    
    [self wSetBtn:_userConfig andNomalImg:@"z我的_个人设置灰" andSelImg:@"z我的_个人设置" andTag:10];
    [self wSetBtn:_artConfig andNomalImg:@"z我的_手艺认证灰" andSelImg:@"z我的_手艺认证" andTag:11];
    [self wSetBtn:_sysConfig andNomalImg:@"z我的_系统设置灰" andSelImg:@"z我的_系统设置" andTag:12];
    
}

-(void)wSetBtn:(UIButton *)btn
   andNomalImg:(NSString *)noImgStr
     andSelImg:(NSString *)seImgStr
        andTag:(NSInteger)tagNum
{
    [btn setImage:[UIImage imageNamed:noImgStr] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:seImgStr] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
    btn.tag = tagNum;
}

- (IBAction)configBtn:(UIButton *)sender
{
    if (_lastBtn) {
        NSLog(@"选择前%d",_lastBtn.selected);
        _lastBtn.selected =NO;
        NSLog(@"选择后%d",_lastBtn.selected);
    }
    switch (sender.tag) {
        case 10://个人设置
            
            break;
        case 11://手艺认证
            
            break;
        case 12://系统设置
            
            break;
            
            
        default:
            break;
    }
    _lastBtn = sender;
    _lastBtn.selected=YES;
}

#pragma mark - isON方法重写
-(void)setIsOn:(BOOL)IsOn
{
    _IsOn = IsOn;
    if (_IsOn) {
        self.view.center = (CGPoint){W_width/2 *W_scale,W_height/2};
        self.view.transform = CGAffineTransformMakeScale(W_scale,W_scale );
    }else
    {
        self.view.center = (CGPoint){W_width/2,W_height/2};
        self.view.transform = CGAffineTransformIdentity;
    }
}

#pragma mark - 中间部分的3个按钮
//粉丝按钮
- (IBAction)fansBtn:(UIButton *)sender {
}
//关注按钮
- (IBAction)focusBtn:(UIButton *)sender {
}
//礼物按钮
- (IBAction)giftBtn:(UIButton *)sender {
}
@end
