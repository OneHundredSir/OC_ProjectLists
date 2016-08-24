//
//  AddBankVCardViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-27.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "AddBankVCardViewController.h"
#import "RestUIAlertView.h"

#import "ColorTools.h"
#import "BankCardInfo.h"
#import "SendValuedelegate.h"
#import "AJComboBox.h"
#define NUMBERS @"0123456789\n"
#define NMUBERS2 @"0123456789./*-+~!@#$%^&()_+-=,./;'[]{}:<>?`"

@interface AddBankVCardViewController ()<UITextFieldDelegate, HTTPClientDelegate,AJComboBoxDelegate>
{
    
    NSMutableArray *dataArr;
    NSInteger _requestNum;
    NSMutableArray *_bankIdArr;//银行ID数组
    NSMutableArray *_provinceIdArr;//省份ID数组
    NSMutableArray *_cityIdArr;//城市ID数组
    
    NSString *_bankIdStr;
    NSString *_provinceIdStr;
    NSString *_cityIdStr;
}

@property (nonatomic, strong) UITextField *banknameField;

@property (nonatomic, strong) UITextField *idField;

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *branchbankField;

@property (nonatomic,strong)AJComboBox *cityComboBox;

@property (nonatomic,strong)AJComboBox *provinceComboBox;

@property (nonatomic,strong)AJComboBox *bankComboBox;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation AddBankVCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _requestNum = 1;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"167" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    
    [_requestClient requestGet:@"app/services" withParameters:parameters];


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
    
}

/**
 * 初始化数据
 */
- (void)initData
{
    if (_bankCard == nil) {
        _bankCard = [[BankCard alloc] init];
    }
    _bankIdStr = @"-1";
    _provinceIdStr = @"-2";
    _cityIdStr = @"-3";
    _bankIdArr = [NSMutableArray array];
    _provinceIdArr = [NSMutableArray array];
    _cityIdArr = [NSMutableArray array];

    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    dataArr = [[NSMutableArray alloc] init];
    
    UIControl *viewControl = [[UIControl alloc] initWithFrame:self.view.bounds];
    [viewControl addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewControl];
    
    UILabel *banknamelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 200, 30)];
    banknamelabel.text = @"请绑定持卡人本人的银行卡";
    banknamelabel.textColor = [UIColor darkGrayColor];
    banknamelabel.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:banknamelabel];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(5, 100, MSWIDTH - 10, 250)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5.0f;
    backView.layer.masksToBounds = YES;
    [self.view addSubview:backView];
    
    
    UIControl *viewControl1 = [[UIControl alloc] initWithFrame:backView.frame];
    [viewControl1 addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:viewControl1];
    
    //输入框
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(5, 10, MSWIDTH - 20, 36)];
    _nameField.borderStyle = UITextBorderStyleNone;
//    _nameField.layer.borderColor = [[UIColor blackColor] CGColor];
//    _nameField.layer.borderWidth = 0.5f;
//    _nameField.backgroundColor = [UIColor whiteColor];
    _nameField.textColor = [UIColor blackColor];
    _nameField.font = [UIFont systemFontOfSize:15.0f];
    _nameField.delegate = self;
//    _nameField.tag = 1002;
//    _nameField.text = _bankCard.accountName;
    _nameField.placeholder = @"持卡人";
    [backView addSubview:_nameField];
    
    for (int i = 0; i <= 4; i++) {
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 46 + i * 40, MSWIDTH - 20, 0.5)];
        lineLabel.backgroundColor = [UIColor grayColor];
        [backView addSubview:lineLabel];
    }
    
        //账号输入框
        _idField = [[UITextField alloc] initWithFrame:CGRectMake(5, 50, MSWIDTH - 20, 36)];
        _idField.borderStyle = UITextBorderStyleNone;
        _idField.font = [UIFont systemFontOfSize:15.0f];
//        _idField.text = _bankCard.account;
        _idField.keyboardType = UIKeyboardTypeNumberPad;
        _idField.delegate = self;
        _idField.tag = 1100;
        _idField.placeholder = @"卡号";
        [backView   addSubview:_idField];
    
//    //账号输入框
//    UITextField *shenTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 90, MSWIDTH - 20, 36)];
//    shenTextField.borderStyle = UITextBorderStyleNone;
//    shenTextField.font = [UIFont systemFontOfSize:15.0f];
//    shenTextField.text = _bankCard.account;
//    shenTextField.delegate = self;
//    shenTextField.tag = 1000;
//    shenTextField.placeholder = @"省";
//    [backView   addSubview:shenTextField];
//    
//    //账号输入框
//    UITextField *cityTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 130, MSWIDTH - 20, 36)];
//    cityTextField.borderStyle = UITextBorderStyleNone;
//    cityTextField.font = [UIFont systemFontOfSize:15.0f];
//    cityTextField.text = _bankCard.account;
//    cityTextField.delegate = self;
//    cityTextField.tag = 1000;
//    cityTextField.placeholder = @"市";
//    [backView   addSubview:cityTextField];
    
    //省份选择框
    _provinceComboBox = [[AJComboBox alloc] initWithFrame:CGRectMake(5, 90, MSWIDTH - 20, 36)];
    [_provinceComboBox setLabelText:@"--请选择省份--"];
    [_provinceComboBox setDelegate:self];
    [_provinceComboBox setTag:201];
    [backView addSubview:_provinceComboBox];
    
    //所在城市选择框
    _cityComboBox = [[AJComboBox alloc] initWithFrame:CGRectMake(5, 130, MSWIDTH - 20, 36)];
    [_cityComboBox setLabelText:@"--请选择城市--"];
    [_cityComboBox setTag:202];
    [_cityComboBox setDelegate:self];
    _cityComboBox.userInteractionEnabled = NO;
    [backView addSubview:_cityComboBox];

    
    
//    //银行名称输入框
//    _banknameField = [[UITextField alloc] initWithFrame:CGRectMake(5, 170, MSWIDTH - 20, 36)];
//    _banknameField.borderStyle = UITextBorderStyleNone;
//    _banknameField.font = [UIFont systemFontOfSize:15.0f];
//    _banknameField.delegate = self;
//    _banknameField.tag = 1001;
//    _banknameField.placeholder = @"开户行";
//    [backView addSubview:_banknameField];
    
    //银行选择框
    _bankComboBox = [[AJComboBox alloc] initWithFrame:CGRectMake(5, 170, MSWIDTH - 20, 36)];
    [_bankComboBox setLabelText:@"--请选择开户行--"];
    [_bankComboBox setDelegate:self];
    [_bankComboBox setTag:203];
    [backView addSubview:_bankComboBox];
    
    //银行名称输入框
    _branchbankField = [[UITextField alloc] initWithFrame:CGRectMake(5, 210, MSWIDTH - 20, 36)];
    _branchbankField.borderStyle = UITextBorderStyleNone;
    _branchbankField.font = [UIFont systemFontOfSize:15.0f];
    _branchbankField.delegate = self;
//    _branchbankField.tag = 1001;
    _branchbankField.placeholder = @"分支网点";
    [backView addSubview:_branchbankField];

    
    
//    UILabel *bankidlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_banknameField.frame) + 6, 70, 30)];
//    bankidlabel.text = @"账号";
//    bankidlabel.textColor = [UIColor darkGrayColor];
//    bankidlabel.font = [UIFont boldSystemFontOfSize:15.0f];
//    [self.view addSubview:bankidlabel];
//    

    
//    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_idField.frame) + 6, 70, 30)];
//    namelabel.text = @"收款人";
//    namelabel.textColor = [UIColor darkGrayColor];
//    namelabel.font = [UIFont boldSystemFontOfSize:15.0f];
//    [self.view addSubview:namelabel];
    
   
    
    UIButton *surebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    surebtn.frame = CGRectMake(10, CGRectGetMaxY(backView.frame) + 16, self.view.frame.size.width-20, 45);
    [surebtn setTitle:@"添 加" forState:UIControlStateNormal];
    surebtn.layer.cornerRadius = 3.0f;
    surebtn.layer.masksToBounds = YES;
    surebtn.backgroundColor = GreenColor;
    [surebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    surebtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [surebtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:surebtn];
    
}

#pragma mark 
- (void)sureBtnClick
{
    if (AppDelegateInstance.userInfo == nil) {
        [ReLogin outTheTimeRelogin:self];
        return;
    }
    if ([_nameField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入持卡人姓名"];
        return;
    }
    
    if ([_idField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入银行卡号"];
        return;
    }

    if ([_provinceIdStr isEqualToString:@"-2"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择省份"];
        return;
    }
    if ([_cityIdStr isEqualToString:@"-3"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择城市"];
        return;
    }
    
    if ([_bankIdStr isEqualToString:@"-1"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择开户行"];
        return;
    }
    
    if ([_branchbankField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入分支网点"];
        return;
    }
 

    [self requestData];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
//    if(_editType == BankCardEditModify)
//    {
//        self.title = @"编辑银行卡";
//    }
//    else
//    {
        self.title = @"添加银行卡";
//    }
    
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

#pragma mark 点击空白处收回键盘
- (void)ControlAction
{
    
    [_nameField  resignFirstResponder];
    [_idField  resignFirstResponder];
    [_branchbankField  resignFirstResponder];
    
    
}

#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma 请求数据
-(void) requestData
{
    _requestNum = 3;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"99" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:_bankIdStr forKey:@"addBankCode"];
    [parameters setObject:_provinceIdStr forKey:@"addProviceCode"];
    [parameters setObject:_cityIdStr forKey:@"addCityCode"];
    [parameters setObject:_branchbankField.text forKey:@"addBranchBankName"];
    [parameters setObject:_idField.text  forKey:@"addAccount"];
    [parameters setObject:_nameField.text forKey:@"addAccountName"];

    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
    
//    DLOG(@"_bankCard.bankCardId ->%ld", (long)_bankCard.bankCardId);
//    if (_editType == BankCardEditModify) {
//        [parameters setObject:[NSString stringWithFormat:@"%ld" , (long)_bankCard.bankCardId] forKey:@"bankId"];
//        [parameters setObject:[NSString stringWithFormat:@"%d", 100] forKey:@"OPT"];
//    } else {
    
//    }
    
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}


#pragma 请求数据
-(void) requestCityData:(NSString *)provinceIdStr
{
    _requestNum = 2;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
     [parameters setObject:@"169" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:provinceIdStr forKey:@"provinceCode"];
    
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}




#pragma mark 下拉列表代理
-(void)didChangeComboBoxValue:(AJComboBox *)comboBox selectedIndex:(NSInteger)selectedIndex;
{
    
    DLOG(@"点了了下拉列表%ld的第%ld选项",comboBox.tag,selectedIndex);
    if(comboBox.tag == 201){
        [_cityComboBox setLabelText:@"--请选择城市--"];
        _provinceIdStr = [NSString stringWithFormat:@"%@",_provinceIdArr[selectedIndex]];
        [self requestCityData:_provinceIdArr[selectedIndex]];
       
    }
    
    
    if(comboBox.tag == 202){
        
      _cityIdStr = [NSString stringWithFormat:@"%@",_cityIdArr[selectedIndex]];
        
    }
    if (comboBox.tag == 203) {
        
        _bankIdStr = [NSString stringWithFormat:@"%@",_bankIdArr[selectedIndex]];
    }
}


#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{

    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    DLOG(@"===%@=======", dics);
    DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
    
        
        if (_requestNum == 1) {
            
            NSArray * provincesArr = [dics objectForKey:@"provinceNames"];
            _provinceIdArr = [dics objectForKey:@"provinceIds"];
            NSArray * bankArr = [dics objectForKey:@"bankCodeNames"];
            _bankIdArr = [dics objectForKey:@"bankCodeIds"];
            if (provincesArr && ![provincesArr isEqual:[NSNull null]]) {
               
                   [_provinceComboBox setArrayData:[provincesArr copy]];
                 _provinceComboBox.table.frame = CGRectMake(_provinceComboBox.frame.origin.x+5, _provinceComboBox.frame.origin.y+100, _provinceComboBox.frame.size.width, provincesArr.count>=6?6*30:provincesArr.count*30);
                
                }
            if (bankArr && ![bankArr isEqual:[NSNull null]]) {
                
                [_bankComboBox setArrayData:[bankArr copy]];
                  _bankComboBox.table.frame = CGRectMake(_bankComboBox.frame.origin.x+5, _bankComboBox.frame.origin.y+100, _bankComboBox.frame.size.width, bankArr.count>=6?6*30:bankArr.count*30);
            }
            
                
        }
        else if (_requestNum == 2) {
            NSArray *cityArr = [dics objectForKey:@"cityNames"];
            _cityIdArr = [dics objectForKey:@"cityIds"];
            if (cityArr && ![cityArr isEqual:[NSNull null]]) {
                
                [_cityComboBox setArrayData:[cityArr copy]];
                _cityComboBox.table.frame = CGRectMake(_cityComboBox.frame.origin.x+5, _cityComboBox.frame.origin.y+100, _cityComboBox.frame.size.width, cityArr.count>=6?6*30:cityArr.count*30);
                _cityComboBox.userInteractionEnabled = YES;
            }
            
        }
        else if (_requestNum == 3) {
            
         [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:AddBankCardSuccess object:self];
                        
                    });
            
        }


        

        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];        
    }else {
        // 服务器返回数据异常
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
      
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    // 服务器返回数据异常
//    [SVProgressHUD showErrorWithStatus:@"网络异常"];
   
}

// 无可用的网络
-(void) networkError
{
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
    
}

#pragma JGProgressHUDDelegate



-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

#pragma 限制只能输入数字和.
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL canChange = YES;
    
    if (textField.tag == 1100) {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
        
        canChange = [string isEqualToString:filtered];
        
       
    }else{
    
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([toBeString length] > 18) {
            textField.text = [toBeString substringToIndex:18];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"超过最大字数不能输入了" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            canChange =  NO;
        }
        //只能输入英文或中文
//        NSCharacterSet * charact;
//        charact = [[NSCharacterSet characterSetWithCharactersInString:NMUBERS2]invertedSet];
//        
//        NSString * filtered = [[string componentsSeparatedByCharactersInSet:charact]componentsJoinedByString:@""];
//        
//        canChange = [string isEqualToString:filtered];
//        if(canChange) {
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入英文或中文"
//                                                            delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
//            return NO;
//        }
    
    
    }
     return canChange;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}


@end
