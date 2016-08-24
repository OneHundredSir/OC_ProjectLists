//
//  WHDRegisterViewController.m
//  xiaorizi
//
//  Created by HUN on 16/6/7.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDRegisterViewController.h"
#import "AppDelegate.h"
@interface WHDRegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txName;
@property (weak, nonatomic) IBOutlet UITextField *tCode;
@property(nonatomic,strong)UITextField *lasttext;
@property (weak, nonatomic) IBOutlet UIView *buttonView;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property(nonatomic,strong)MBProgressHUD* Hub;
@end

@implementation WHDRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    UIView *view=[[UIView alloc]initWithFrame:(CGRect){0,0,10,10}];
//    _txName.leftView=view;
//    _tCode.leftView=view;
//    _tCode.leftViewMode=UITextFieldViewModeAlways;
//    _txName.leftViewMode=UITextFieldViewModeWhileEditing;
    [_txName becomeFirstResponder];
    [self setLayout];
}

-(void)setLayout
{
    //登陆按钮
    _registerBtn.layer.borderColor=[UIColor blackColor].CGColor;
    _registerBtn.layer.borderWidth=2;
    _registerBtn.layer.cornerRadius=_registerBtn.frame.size.height/2.0;
    
    
    //下面控件的外围
    _buttonView.layer.borderColor=[UIColor blackColor].CGColor;
    _buttonView.layer.borderWidth=2;
    _buttonView.layer.cornerRadius=_buttonView.frame.size.height/2.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)register:(UIButton *)sender
{
    if(_txName.text.length==11)
    {
        //初始化进度框，置于当前的View当中
        _Hub = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_Hub];
        //如果设置此属性则当前的view置于后台
        _Hub.dimBackground = YES;
        
        _Hub.mode=MBProgressHUDModeDeterminate;
        
        //设置对话框文字
        _Hub.labelText = @"登陆中";
        
        
        //显示对话框
        [_Hub showAnimated:YES whileExecutingBlock:^{
            //对话框显示时需要执行的操作
            sleep(1);
        } completionBlock:^{
            //操作执行完后取消对话框
            [_Hub removeFromSuperview];
            _Hub = nil;
            
            AppDelegate *delegate= [UIApplication sharedApplication].delegate ;
            delegate.isOn=YES;
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }else if ([_txName.text isEqualToString:@""]||[_tCode.text isEqualToString:@""])
    {
        [self setUpHub:@"账号/密码不为空" andMode:MBProgressHUDModeAnnularDeterminate];
    }else
    {
        [self setUpHub:@"请输入正确的11位手机号" andMode:MBProgressHUDModeAnnularDeterminate];
    }
}

- (IBAction)regist:(UIButton *)sender {
    
    [self setUpHub:@"直接登陆,没有注册..." andMode:MBProgressHUDModeText];
    
}

/**
 *  布置提示框
 */
-(void)setUpHub:(NSString *)show andMode:(MBProgressHUDMode)model
{
    //初始化进度框，置于当前的View当中
    _Hub = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_Hub];
    //如果设置此属性则当前的view置于后台
    _Hub.dimBackground = YES;
    
    _Hub.mode=model;
    
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
    if (_lasttext) {
        [_lasttext becomeFirstResponder];
    }
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self register:_registerBtn];
    _lasttext=textField;
    return YES;
}
//代理方法...
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    _lasttext=textField;
    return YES;
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
