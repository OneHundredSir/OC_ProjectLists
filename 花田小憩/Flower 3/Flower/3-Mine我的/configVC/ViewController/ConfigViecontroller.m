//
//  ConfigViecontroller.m
//  Flower
//
//  Created by HUN on 16/7/15.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "ConfigViecontroller.h"

@interface ConfigViecontroller ()<UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *mytableView;

@end

@implementation ConfigViecontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setViewTitle:@"设置"];
}

#pragma mark delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"这是%d列%d在点击",indexPath.section,indexPath.row);
    NSInteger row = indexPath.section;
    NSInteger raw = indexPath.row;
    if (row == 0)//第一组
    {
        
    }
}


#pragma mark 初始化函数
static  CGFloat magin = 5;
/** 设置左边的按钮 */
-(void)setLeftBtn:(NSString *)iconStr andTitle:(NSString *)titleStr
{
    UIButton *leftBtn=[[UIButton alloc]init];
    if (iconStr || titleStr) {
        UIImage *imag = [UIImage imageNamed:iconStr];
        CGSize fontSize = [titleStr sizeWithFont:font(13) constrainedToSize:(CGSize){MAXFLOAT,44}];
        [leftBtn setImage:imag forState:UIControlStateNormal];
        leftBtn.frame = CGRectMake(magin, 0, fontSize.width+magin+imag.size.width, 44);
        [leftBtn setTitle:titleStr forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else if (iconStr || !titleStr)
    {
        UIImage *imag = [UIImage imageNamed:iconStr];
        leftBtn.frame = CGRectMake(magin, 0, imag.size.width+magin, 44);
        [leftBtn setImage:imag forState:UIControlStateNormal];
    }else
    {
        CGSize fontSize = [titleStr sizeWithFont:font(13) constrainedToSize:(CGSize){MAXFLOAT,44}];
        leftBtn.frame = CGRectMake(magin, 0, fontSize.width+magin, 44);
        [leftBtn setTitle:titleStr forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [leftBtn addTarget:self action:@selector(leftWay:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=item;
}

-(void)leftWay:(UIButton *)btn
{
    [self popVC];
}

/** 设置顶部 */
-(void)setViewTitle:(NSString *)title
{
    UILabel *titleLB = [[UILabel  alloc]initWithFrame:(CGRect){0,0,100,44}];
    titleLB.text = title;
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.textColor = [UIColor blackColor];
    titleLB.font=font(14);
    self.navigationItem.titleView = titleLB;
}

#pragma mark 出栈//多一个判断
-(void)popVC
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
