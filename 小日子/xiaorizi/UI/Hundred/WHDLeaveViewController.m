//
//  WHDLeaveViewController.m
//  xiaorizi
//
//  Created by HUN on 16/6/7.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDLeaveViewController.h"

@interface WHDLeaveViewController ()
@property(nonatomic,strong)MBProgressHUD *Hub;
@property (weak, nonatomic) IBOutlet UITextField *detailText;
@property (weak, nonatomic) IBOutlet UITextField *mailText;

@end

@implementation WHDLeaveViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *view=[[UIView alloc]initWithFrame:(CGRect){0,0,10,10}];
    _detailText.leftView=view;
    _mailText.leftView=view;
    [self setUpbutton];
}
-(void)viewWillAppear:(BOOL)animated
{
//[self setUpbutton];
}
-(void)setUpbutton
{
    UIButton *btn=[[UIButton alloc]initWithFrame:(CGRect){0,0,40,40}];
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.font=[UIFont systemFontOfSize:17];
    [btn addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
//    btn.backgroundColor=[UIColor redColor];
    UIBarButtonItem *bar=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationController.navigationItem.rightBarButtonItem=bar;
    self.navigationItem.rightBarButtonItem=bar;
}

-(void)send:(UIButton *)btn
{
    if ([_detailText.text isEqualToString:@""]) {
        [self setUpHub:@"请输入你的留言"];
    }else if (_mailText.text.length==11)
    {
        [self setUpHub:@"请填写正确的联系方式,以便我们联系你"];
    }else
    {
        [self setUpHub:@"很高兴收到你的来信，我们会尽快采纳你的建议"];
    }
    
}

/**
 *  布置提示框
 */
-(void)setUpHub:(NSString *)show
{
    //初始化进度框，置于当前的View当中
    _Hub = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_Hub];
    //如果设置此属性则当前的view置于后台
    _Hub.dimBackground = YES;
    
    _Hub.mode=MBProgressHUDModeDeterminate;
    
    //设置对话框文字
    _Hub.labelText = show;
    
    
    //显示对话框
    [_Hub showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        sleep(1);
    } completionBlock:^{
        //操作执行完后取消对话框
        [_Hub removeFromSuperview];
        _Hub = nil;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
