//
//  MainPersonHeaderView.m
//  Flower
//
//  Created by HUN on 16/7/13.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "MainPersonHeaderView.h"
#import "PersonModel.h"
@interface MainPersonHeaderView ()
/**
 *  作者头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *titleIcon;

/**
 *  v头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *VIcon;
/**
 *  作者名称
 */
@property (weak, nonatomic) IBOutlet UILabel *authorName;
/**
 *  作为职位
 */
@property (weak, nonatomic) IBOutlet UILabel *authorWorkLB;

/**
 *  订阅人数
 */
@property (weak, nonatomic) IBOutlet UILabel *bookLB;


/**
 *  第一个默认被选中的按钮
 */


@property (weak, nonatomic) IBOutlet UIButton *introBtn;

@property (weak, nonatomic) IBOutlet UIButton *bookBtn;

@property (weak, nonatomic) IBOutlet UIView *btnBackV;

@end

@implementation MainPersonHeaderView

-(void)awakeFromNib
{
    
   
    
    
//    CGFloat layH = 1;
//    CGFloat layW = [UIScreen mainScreen].bounds.size.width /3.0 * 0.6;
//    CGFloat layX = 0;
//    CGFloat layY = _columBtn.frame.size.height-1;
//    self.btnLayer.frame = (CGRect){layX,layY,layW,layH};
    [self makeLayerWithX:0];
    
    
}



- (void)layoutSubviews
{
    [super layoutSubviews];
   
  
}

-(void)makeLayerWithX:(CGFloat)X
{
    CGFloat layH = 1;
    CGFloat layW = _columBtn.frame.size.width * 0.6;
    CGFloat layX = X + _columBtn.frame.size.width * 0.2;
    CGFloat layY = _columBtn.frame.size.height-layH;
    self.btnLayer.frame = (CGRect){layX,layY,layW,layH};
    NSLog(@"%@",NSStringFromCGRect(self.btnLayer.frame));
    self.btnLayer.borderWidth = layH;
    if (_btnLayer == nil) {
        _btnLayer = [[CALayer alloc]init];
        _btnLayer.backgroundColor = [UIColor blackColor].CGColor;
        [_btnBackV.layer addSublayer:_btnLayer];
    }
    
}

#pragma mark set方法
-(void)setModel:(id)model
{
    _model = model;
    //设置自己的个人图片
    if (_model.headImg.length>0) {
        [_titleIcon sd_setImageWithURL:[NSURL URLWithString:_model.headImg]];
    }else
    {
        _titleIcon.image = [UIImage imageNamed:@"placehodlerX"];
    }
//    _titleIcon.layer.cornerRadius = _titleIcon.frame.size.width/2.0;
    _titleIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    _titleIcon.layer.borderWidth = 1;
    _titleIcon.clipsToBounds = YES;
    //设置点赞颜色,看下要不要判断
    NSString *imgStr = [_model.myAuth integerValue]==1?@"黄色v.png":@"黑色v.png";
    //    NSLog(@"%ld",_model.author.newAuth );
    _VIcon.image = [UIImage imageNamed:imgStr];
    
    /**
     *  作者名称
     */
    _authorName.text = _model.userName;
    /**
     *  作为职位
     */
    _authorWorkLB.text = _model.identity;
    
    /**
     *  订阅人数
     */
    _bookLB.text = [NSString stringWithFormat:@"已有%ld人订阅",(long)_model.subscibeNum];
    
}


#pragma mark 订阅按钮
- (IBAction)bookBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

#pragma mark 刷新按钮，扔出去block
- (IBAction)refleshColloction:(UIButton *)sender {
    
    //全部还原再重新选中
    _columBtn.selected = _introBtn.selected = _bookBtn.selected = NO;
    sender.selected=YES;
    
//    设置layer的滑动
    [self makeLayerWithX:sender.frame.origin.x];
    

    
    if (sender.tag == 10)
    {
        if (_columBlock) {
            _columBlock(sender);
        }
    }else if (sender.tag == 11)
    {
        if (_introduceBlock) {
            _introduceBlock(sender);
        }
    }else if (sender.tag == 12)
    {
        if (_bookBlock) {
            _bookBlock(sender);
        }
    }
    
}


@end
