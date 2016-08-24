//
//  WHDSeletedcities.m
//  xiaorizi
//
//  Created by HUN on 16/6/2.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDSeletedcities.h"
#import "AppDelegate.h"
@interface WHDSeletedcities()

//取最后一次的btn，用指针指向
@property(nonatomic,strong)UIButton *TmpBtn;
@property(nonatomic,strong)UIScrollView *scroll;

@end

@implementation WHDSeletedcities


+(instancetype)shareSeleted
{
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    WHDSeletedcities *viewController=[delegate seletedController];
    if (viewController==nil) {
        viewController=[[WHDSeletedcities alloc]init];
        delegate.seletedController=viewController;
    }
    return viewController;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self setUpView];
}

-(void)setUpView
{
    CGFloat statusH=20;
    CGFloat titleH=50;
    //导航栏
    UIView *titleView=[[UIView alloc]initWithFrame:(CGRect){0,statusH,VIEWW,titleH}];
    titleView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:titleView];
    //导航栏左边取消按钮
    UIButton *deleBtn=[[UIButton alloc]initWithFrame:(CGRect){0,0,VIEWW/6.0,titleH}];
    [deleBtn setTitle:@"取消" forState:UIControlStateNormal];
    deleBtn.titleLabel.font=myFontNum;
    [deleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deleBtn addTarget:self action:@selector(deleteWay:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:deleBtn];
    
    //设置title的文件
    CGRect titleLabel=(CGRect){(VIEWW-VIEWW/3.0)/2.0,0,VIEWW/3.0,titleH};
    UILabel *label=[[UILabel alloc]initWithFrame:titleLabel];
    label.textColor=[UIColor blackColor];
    label.text=@"选择城市";
    label.font=myFontTitle;
    label.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:label];
    
    
    
    
    self.scroll=[[UIScrollView alloc]initWithFrame:(CGRect){0,titleH+statusH,VIEWW,VIEWH-titleH}];
    self.scroll.backgroundColor=[UIColor clearColor];
    self.scroll.contentSize=(CGSize){VIEWW,VIEWH};
    [self.view addSubview:self.scroll];
    NSArray *chinaArr=@[@"北京",@"上海",@"成都",@"广州",@"杭州",@"西安",@"重庆",@"厦门",@"台北"];
    NSArray *globalArr=@[@"罗马",@"迪拜",@"里斯本",@"巴黎",@"柏林",@"伦敦"];
    CGFloat magin=10;
    CGRect rect=(CGRect){0,0,VIEWW,150};
    
    [self.scroll addSubview:[self makeCitiesBtnWithArr:chinaArr AndRect:rect AndTitle:@"国内城市"]];
    CGRect rect2=(CGRect){0,rect.origin.y+rect.size.height+magin,VIEWW,rect.size.height};
    [self.scroll addSubview:[self makeCitiesBtnWithArr:globalArr AndRect:rect2 AndTitle:@"国外城市"]];
    
    CGRect rectLabel=(CGRect){0,rect2.origin.y+rect2.size.height-magin*4,VIEWW,50};

    UILabel *buttomLabel=[[UILabel alloc]initWithFrame:rectLabel];
    buttomLabel.backgroundColor=[UIColor clearColor];
    buttomLabel.textColor=[UIColor lightGrayColor];
    buttomLabel.text=@"更多城市，敬请期待...";
    buttomLabel.font=myFontNum;
    buttomLabel.textAlignment=NSTextAlignmentCenter;
    [self.scroll addSubview:buttomLabel];
}
//取消
-(void)deleteWay:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 设置button的东西
-(UIView *)makeCitiesBtnWithArr:(NSArray *)arr AndRect:(CGRect)rect AndTitle:(NSString *)labelTitle
{
    UIView *citiesView=[[UIView alloc]initWithFrame:rect];
    citiesView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:citiesView];
    CGFloat titleLX=0;
    CGFloat titleLY=0;
    CGFloat titleLW=rect.size.width;
    CGFloat titleLH=40;
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:(CGRect){titleLX,titleLY,titleLW,titleLH}];
    titleLabel.font=myFontTitle;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.text=labelTitle;
    [citiesView addSubview:titleLabel];
    NSLog(@"%@",NSStringFromCGRect(titleLabel.frame));
    
    NSInteger row=3;
    CGFloat magin=2;
    CGFloat btnX=0;
    CGFloat btnY=titleLY+titleLH+magin;
    CGFloat btnW=(titleLW-(row-1)*magin)/row;
    CGFloat btnH=(rect.size.height-titleLH-(row-1)*magin)/row;
    NSInteger rowB=0;//列号
    NSInteger rawB=0;//行号
    for (int i=0; i<arr.count; i++) {
        rowB=i%row;
        rawB=i/row;
        UIButton *btn=[[UIButton alloc]
                       initWithFrame:(CGRect){btnX+(btnW+magin)*rowB,btnY+(btnH+magin)*rawB,btnW,btnH}];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn addTarget:self action:@selector(btnSeletedWay:) forControlEvents:UIControlEventTouchUpInside];

        [citiesView addSubview:btn];
    }
    return citiesView;
}

-(void)btnSeletedWay:(UIButton *)btn
{
    if (_TmpBtn) {
        _TmpBtn.selected=NO;
    }
    _TmpBtn=btn;
    _curCityName = [btn titleForState:UIControlStateNormal];
    btn.selected=YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
