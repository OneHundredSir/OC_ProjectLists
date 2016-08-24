//
//  SetSafeQuestionViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-27.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "SetSafeQuestionViewController.h"

#import "ColorTools.h"
#import "AJComboBox.h"
#import <QuartzCore/QuartzCore.h>
#import "SafeQuestion.h"

static NSString * const DEFAULT_LABEL = @"- 请选择 -";

@interface SetSafeQuestionViewController ()<UITextFieldDelegate,UIAlertViewDelegate,AJComboBoxDelegate, HTTPClientDelegate>
{
    BOOL _isLoading;
    
    NSMutableArray *_questionArrays;
    
    NSMutableArray *_questionArrays1;
    NSMutableArray *_questionArrays2;
    NSMutableArray *_questionArrays3;
    
    NSInteger _requestType;
    NSMutableArray *_questionId;
    NSInteger _questionId1;
    NSInteger _questionId2;
    NSInteger _questionId3;
}

@property(nonatomic ,strong) NetWorkClient *requestClient;

@property (nonatomic,strong)AJComboBox *questionComboBox1;
@property (nonatomic,strong)AJComboBox *questionComboBox2;
@property (nonatomic,strong)AJComboBox *questionComboBox3;

@property (nonatomic,strong)UITextField *textfield1;
@property (nonatomic,strong)UITextField *textfield2;
@property (nonatomic,strong)UITextField *textfield3;

@end

@implementation SetSafeQuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
    
    [self requestData];
    
}

/**
 * 初始化数据
 */
- (void)initData
{
    _questionArrays = [[NSMutableArray alloc] init];
    _questionId = [[NSMutableArray alloc] init];
    
    _questionArrays1 = [[NSMutableArray alloc] init];
    _questionArrays2 = [[NSMutableArray alloc] init];
    _questionArrays3 = [[NSMutableArray alloc] init];
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    
//    CGFloat selfW = self.tableView.frame.size.width;
    self.tableView.backgroundColor = KblackgroundColor;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    UIView *header = [[UIView alloc]initWithFrame:self.tableView.bounds];
    self.tableView.tableHeaderView = header;
    
    CGFloat textlabelY = 90 - 64.f;
    for (int i = 0; i<3; i++) {
        
        UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(16, textlabelY+90*i, 81, 30)];
        textlabel.text = [NSString stringWithFormat:@"安全问题%d:",i+1];
        textlabel.font = [UIFont systemFontOfSize:15.0f];
        textlabel.tag = i + 10;
        [header addSubview:textlabel];
        
        
        UILabel *textlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY([header viewWithTag:(i+10)].frame) + 8, 81, 30)];
        textlabel2.text = @"输入答案";
        textlabel2.font = [UIFont systemFontOfSize:15.0f];
        textlabel2.tag = i + 100;
        [header addSubview:textlabel2];
    }
    
    //输入框
    _textfield1 = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX([header viewWithTag:(0+100)].frame) + 4, CGRectGetMidY([header viewWithTag:(0+100)].frame) - 15, 200, 30)];
    _textfield1.borderStyle = UITextBorderStyleNone;
    _textfield1.layer.borderWidth = 0.5f;
    _textfield1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _textfield1.backgroundColor = [UIColor whiteColor];
    _textfield1.font = [UIFont systemFontOfSize:15.0f];
    _textfield1.delegate = self;
    [header addSubview:_textfield1];
    
    //输入框
    _textfield2 = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX([header viewWithTag:(1 + 100)].frame) + 4, CGRectGetMidY([header viewWithTag:(1+100)].frame) - 15, 200, 30)];
    _textfield2.borderStyle = UITextBorderStyleNone;
    _textfield2.layer.borderWidth = 0.5f;
    _textfield2.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _textfield2.backgroundColor = [UIColor whiteColor];
    _textfield2.font = [UIFont systemFontOfSize:15.0f];
    _textfield2.delegate = self;
    [header addSubview:_textfield2];
    
    //输入框
    _textfield3 = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX([header viewWithTag:(2 + 100)].frame) + 4, CGRectGetMidY([header viewWithTag:(2 + 100)].frame) - 15, 200, 30)];
    _textfield3.borderStyle = UITextBorderStyleNone;
    _textfield3.layer.borderWidth = 0.5f;
    _textfield3.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _textfield3.backgroundColor = [UIColor whiteColor];
    _textfield3.font = [UIFont systemFontOfSize:15.0f];
    _textfield3.delegate = self;
    _textfield1.returnKeyType = _textfield2.returnKeyType = _textfield3.returnKeyType = UIReturnKeyDone;
    _textfield3.enablesReturnKeyAutomatically = _textfield2.enablesReturnKeyAutomatically = _textfield1.enablesReturnKeyAutomatically = YES;
    [header addSubview:_textfield3];
    
    _questionComboBox1 = [[AJComboBox alloc] initWithFrame:CGRectMake(CGRectGetMaxX([header viewWithTag:(0 + 10)].frame) + 4, CGRectGetMidY([header viewWithTag:(0 + 10)].frame) - 15, 200, 30)];
    [_questionComboBox1 setLabelText:DEFAULT_LABEL];
    [_questionComboBox1 setDelegate:self];
    [_questionComboBox1 setTag:1000];
    [_questionComboBox1 setArrayData:_questionArrays];
    [header addSubview:_questionComboBox1];
    
    _questionComboBox2 = [[AJComboBox alloc] initWithFrame:CGRectMake(CGRectGetMaxX([header viewWithTag:(1 + 10)].frame) + 4, CGRectGetMidY([header viewWithTag:(1 + 10)].frame) - 15, 200, 30)];
    [_questionComboBox2 setLabelText:DEFAULT_LABEL];
    [_questionComboBox2 setDelegate:self];
    [_questionComboBox2 setTag:1001];
    [_questionComboBox2 setArrayData:_questionArrays];
    [header addSubview:_questionComboBox2];
    
    _questionComboBox3 = [[AJComboBox alloc] initWithFrame:CGRectMake(CGRectGetMaxX([header viewWithTag:(2 + 10)].frame) + 4, CGRectGetMidY([header viewWithTag:(2 + 10)].frame) - 15, 200, 30)];
    [_questionComboBox3 setLabelText:DEFAULT_LABEL];
    [_questionComboBox3 setDelegate:self];
    [_questionComboBox3 setTag:1002];
    [_questionComboBox3 setArrayData:_questionArrays];
    [header addSubview:_questionComboBox3];
    
    
    //确定按钮
    UIButton *SureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    SureBtn.frame = CGRectMake(10, 390 - 64, header.frame.size.width-20, 45);
    [SureBtn setTitle:@"确定" forState:UIControlStateNormal];
    SureBtn.layer.cornerRadius = 3.0f;
    SureBtn.layer.masksToBounds = YES;
    SureBtn.backgroundColor = GreenColor;
    [SureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    SureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [SureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:SureBtn];
    
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"安全问题设置";
//    [self.navigationController.navigationBar setBarTintColor:KColor];
//    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
//                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
//    
//    // 导航条返回按钮
//    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
//    backItem.tintColor = [UIColor whiteColor];
//    [self.navigationItem setLeftBarButtonItem:backItem];
}


#pragma mark - 单选框代理方法 AJComboBoxDelegate
-(void)didChangeComboBoxValue:(AJComboBox *)comboBox selectedIndex:(NSInteger)selectedIndex
{
    for (int i = 0; i < _questionId.count; i++) {
        
        SafeQuestion *bean =  _questionId[i];
        if (comboBox.tag == 1000) {
            if (bean.question == _questionArrays1[selectedIndex]) {
                _questionId1 = bean.rowId;
                
                DLOG(@"_questionId1: %ld", (long)_questionId1);
            }
        }
        
        if (comboBox.tag == 1001) {
            if (bean.question == _questionArrays2[selectedIndex]) {
                _questionId2 = bean.rowId;
                DLOG(@"_questionId2: %ld", (long)_questionId2);
            }
        }
        
        if (comboBox.tag == 1002) {
            if (bean.question == _questionArrays3[selectedIndex]) {
                _questionId3 = bean.rowId;
                DLOG(@"_questionId3: %ld", (long)_questionId3);
            }
        }
    }
    
    if(comboBox.tag==1000){
        
        _questionComboBox1.labelText = _questionArrays1[selectedIndex];
        [self setSeclectTable:_questionArrays1[selectedIndex] sender:comboBox];
    } else if(comboBox.tag == 1001) {
        
        
        _questionComboBox2.labelText = _questionArrays2[selectedIndex];
        [self setSeclectTable:_questionArrays2[selectedIndex] sender:comboBox];
    } else if(comboBox.tag == 1002) {
        
        _questionComboBox3.labelText = _questionArrays3[selectedIndex];
        [self setSeclectTable:_questionArrays3[selectedIndex] sender:comboBox];
    }
}

#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark UItextfielddelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
    
}

#pragma mark 确定按钮
- (void)sureBtnClick:(id)sender
{
    if ([_questionComboBox1.labelText  isEqualToString:DEFAULT_LABEL]) {
        [SVProgressHUD showErrorWithStatus:@"请选择安全问题一"];
        return;
    }
    
    if ([_textfield1.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请回答问题一"];
        return;
    }
    
    if ([_questionComboBox2.labelText  isEqualToString:DEFAULT_LABEL]) {
        [SVProgressHUD showErrorWithStatus:@"请选择安全问题二"];
        return;
    }
    
    if ([_textfield2.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请回答问题二"];
        return;
    }
    
    if ([_questionComboBox3.labelText  isEqualToString:DEFAULT_LABEL]) {
        [SVProgressHUD showErrorWithStatus:@"请选择安全问题三"];
        return;
    }
    
    if ([_textfield3.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请回答问题三"];
        return;
    }
    
    [self requestSubmitData];
}

#pragma mark 重新获取验证码按钮
- (void)RecoverBtnClick
{
    DLOG(@"重新获取按钮");
}

#pragma mark UIalertViewdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
}

#pragma 请求数据
-(void) requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [ReLogin outTheTimeRelogin:self];
        return;
    }
    
    _requestType = 0;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"107" forKey:@"OPT"];// 客户端安全问题内容接口
    [parameters setObject:@"" forKey:@"body"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    _isLoading = YES;
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    DLOG(@"===%@=======", dics);
    DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        if(_requestType == 0){
            NSArray *dataArr = [dics objectForKey:@"questionArr"];
            
            for (NSDictionary *item in dataArr) {
                SafeQuestion *bean =  [[SafeQuestion alloc] init];
                
                bean.rowId = [[item objectForKey:@"id"] intValue];
                bean.question = [item objectForKey:@"name"];
                [_questionArrays addObject:[item objectForKey:@"name"]];
                [_questionId addObject:bean];
            }
            
            [self setSeclectTable:nil sender:nil];
        }else if(_requestType == 1){
            // 通知全局广播 LeftMenuController 修改UI操作
            [[NSNotificationCenter defaultCenter]  postNotificationName:@"updatelist" object:@"0"];
            
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
//            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:NO];
        }
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    } else {
        // 服务器返回数据异常
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
    
    _isLoading = NO;
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    _isLoading = NO;
    // 服务器返回数据异常
    //    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
    _isLoading = NO;
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}


#pragma  submit请求数据
-(void) requestSubmitData
{
    if (AppDelegateInstance.userInfo == nil) {
        [ReLogin outTheTimeRelogin:self];
        return;
    }
    
    _requestType = 1;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"108" forKey:@"OPT"];// 客户端安全问题内容接口
    [parameters setObject:@"" forKey:@"body"];
    
    DLOG(@"_questionId1 ->%ld", (long)_questionId1);
    DLOG(@"_questionId2 ->%ld", (long)_questionId2);
    DLOG(@"_questionId3 ->%ld", (long)_questionId3);
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)_questionId1] forKey:@"question1"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)_questionId2] forKey:@"question2"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)_questionId3] forKey:@"question3"];
    if (_textfield1.text) {
        NSString *aswerStr1 = [NSString encrypt3DES:_textfield1.text key:DESkey];
        [parameters setObject:aswerStr1 forKey:@"answer1"];
    }else{
        [parameters setObject:@"" forKey:@"answer1"];
        
    }
    if (_textfield2.text) {
        NSString *aswerStr1 = [NSString encrypt3DES:_textfield2.text key:DESkey];
        [parameters setObject:aswerStr1 forKey:@"answer2"];
    }else{
        [parameters setObject:@"" forKey:@"answer2"];
        
    }
    if (_textfield3.text) {
        NSString *aswerStr1 = [NSString encrypt3DES:_textfield3.text key:DESkey];
        [parameters setObject:aswerStr1 forKey:@"answer3"];
    }else{
        
        [parameters setObject:@"" forKey:@"answer3"];
        
    }
    
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
}


#pragma mark
-(void) setSeclectTable:(NSString *)value sender:(AJComboBox *)comboBox
{
    _questionArrays1 = [[NSMutableArray alloc] init];
    _questionArrays2 = [[NSMutableArray alloc] init];
    _questionArrays3 = [[NSMutableArray alloc] init];
    
    [_questionArrays1 addObjectsFromArray:_questionArrays];
    [_questionArrays2 addObjectsFromArray:_questionArrays];
    [_questionArrays3 addObjectsFromArray:_questionArrays];
    
    if(value != nil && comboBox != nil){
        if (comboBox.tag == 1000) {
            
            [_questionArrays2 removeObject:value];
            [_questionArrays3 removeObject:value];
            
            [_questionArrays2 removeObject:_questionComboBox3.labelText];
            [_questionArrays3 removeObject:_questionComboBox2.labelText];
            
            [_questionArrays1 removeObject:_questionComboBox2.labelText];
            [_questionArrays1 removeObject:_questionComboBox3.labelText];
            
        } else if(comboBox.tag == 1001){
            
            [_questionArrays1 removeObject:value];
            [_questionArrays3 removeObject:value];
            
            [_questionArrays1 removeObject:_questionComboBox3.labelText];
            [_questionArrays3 removeObject:_questionComboBox1.labelText];
            
            [_questionArrays2 removeObject:_questionComboBox1.labelText];
            [_questionArrays2 removeObject:_questionComboBox3.labelText];
            
        } else if(comboBox.tag == 1002){
            [_questionArrays1 removeObject:value];
            [_questionArrays2 removeObject:value];
            
            [_questionArrays1 removeObject:_questionComboBox2.labelText];
            [_questionArrays2 removeObject:_questionComboBox1.labelText];
            
            [_questionArrays3 removeObject:_questionComboBox1.labelText];
            [_questionArrays3 removeObject:_questionComboBox2.labelText];
            
        }
    }
    
    [_questionComboBox1 setArrayData:_questionArrays1];
    [_questionComboBox2 setArrayData:_questionArrays2];
    [_questionComboBox3 setArrayData:_questionArrays3];
    
    _questionComboBox1.table.frame = CGRectMake(_questionComboBox1.frame.origin.x, CGRectGetMaxY(_questionComboBox1.frame), _questionComboBox1.frame.size.width, [_questionArrays1 count]*30);
    
    _questionComboBox2.table.frame = CGRectMake(_questionComboBox2.frame.origin.x, CGRectGetMaxY(_questionComboBox2.frame), _questionComboBox2.frame.size.width, [_questionArrays2 count]*30);
    
    _questionComboBox3.table.frame = CGRectMake(_questionComboBox3.frame.origin.x, CGRectGetMaxY(_questionComboBox3.frame), _questionComboBox3.frame.size.width, [_questionArrays3 count]*30);
}

- (void)didClickAjComboBox
{
    [self.view endEditing:YES];
}


-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}


@end
