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
#import "bankNameViewController.h"
#import "AJComboBox.h"
#import "AccountItem.h"
#define NUMBERS @"0123456789\n"
#define NMUBERS2 @"0123456789./*-+~!@#$%^&()_+-=,./;'[]{}:<>?`"
//#define INT_TO_STRING(x)  [NSString stringWithFormat:@"%ld", x]

@interface AddBankVCardViewController ()<UITextFieldDelegate, HTTPClientDelegate,AJComboBoxDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    
    NSMutableArray *dataArr;
    NSArray *titleArr;
    NSInteger _requestNum;
    NSMutableArray *_bankIdArr;//银行ID数组
    NSArray *_bankCodeNameArr;
    NSMutableArray *_provincesArr;
    NSMutableArray *_provinceIdArr;//省份ID数组
    NSMutableArray *_citysArr;//城市数组
    NSMutableArray *_cityIdArr;//城市ID数组
    NSArray *_cityNameArr;
    
    NSString *_bankIdStr;
    NSString *_provinceIdStr;
    NSString *_cityIdStr;
    NSString *_provinceStr;
    NSString *_screenStr;
    NSMutableDictionary *_cityDics;
}

@property (nonatomic, strong) UITextField *banknameField;

@property (nonatomic, strong) UITextField *idField;

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *branchbankField;

@property (nonatomic,strong)AJComboBox *cityComboBox;

@property (nonatomic,strong)AJComboBox *provinceComboBox;

@property (nonatomic,strong)AJComboBox *bankComboBox;

@property(nonatomic ,strong) NetWorkClient *requestClient;
@property(nonatomic ,strong) UIPickerView *pickerView;
@property(nonatomic ,strong) UIPickerView *bankPickerView;
@property(nonatomic ,strong) UILabel *provinceCityLabel;
@property(nonatomic ,strong) UILabel *bankLabel;
@property(nonatomic ,strong) UIView  *provinceBackView;
@property(nonatomic ,strong) UIView  *bankBackView;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectBank:) name:@"selectBank" object:nil];
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
    _provinceStr = @"";
    _screenStr = @"2";
    _bankIdArr = [NSMutableArray array];
    _provinceIdArr = [NSMutableArray array];
    _cityIdArr = [NSMutableArray array];
    _provincesArr = [NSMutableArray array];
    _cityDics = [NSMutableDictionary dictionary];
    _citysArr = [NSMutableArray array];
    _cityNameArr = @[];
    titleArr = @[@"持卡人",@"卡号",@"选择银行",@"开户行所在地",@"开户支行"];
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
    
    UILabel *banknamelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, MSWIDTH - 20, 30)];
    banknamelabel.text = @"请绑定本人的储蓄卡，储蓄卡需开通网银";
    banknamelabel.textColor = [UIColor darkGrayColor];
    banknamelabel.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:banknamelabel];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(5, 100, MSWIDTH - 10, 210)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5.0f;
    backView.layer.masksToBounds = YES;
    [self.view addSubview:backView];
    
    
    UIControl *viewControl1 = [[UIControl alloc] initWithFrame:backView.frame];
    [viewControl1 addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:viewControl1];
    
    //输入框
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(105, 10, MSWIDTH - 125, 36)];
    _nameField.borderStyle = UITextBorderStyleNone;
    //    _nameField.layer.borderColor = [[UIColor blackColor] CGColor];
    //    _nameField.layer.borderWidth = 0.5f;
    //    _nameField.backgroundColor = [UIColor whiteColor];
    _nameField.textColor = [UIColor blackColor];
    _nameField.font = [UIFont systemFontOfSize:15.0f];
    _nameField.textAlignment = NSTextAlignmentRight;
    _nameField.delegate = self;
    //    _nameField.tag = 1002;
    //    _nameField.text = _bankCard.accountName;
    _nameField.placeholder = @"请输入持卡人姓名";
    [backView addSubview:_nameField];
    
    for (int i = 0; i <= 4; i++) {
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 46 + i * 40, MSWIDTH - 20, 0.5)];
        lineLabel.backgroundColor = [UIColor grayColor];
        if (i<4) {
            [backView addSubview:lineLabel];
        }
        if(i == 2 || i == 3){
            UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(MSWIDTH - 35, 15 + i * 40, 20, 20)];
            arrowImg.image = [UIImage imageNamed:@"cell_more_btn"];
            [backView addSubview:arrowImg];
        }
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 16 + i * 40, 110, 20)];
        titleLabel.text = titleArr[i];
        [backView addSubview:titleLabel];
    }
    
    //账号输入框
    _idField = [[UITextField alloc] initWithFrame:CGRectMake(105, 50, MSWIDTH - 125, 36)];
    _idField.borderStyle = UITextBorderStyleNone;
    _idField.font = [UIFont systemFontOfSize:15.0f];
    //        _idField.text = _bankCard.account;
    _idField.keyboardType = UIKeyboardTypeNumberPad;
    _idField.textAlignment = NSTextAlignmentRight;
    _idField.delegate = self;
    _idField.tag = 1100;
    _idField.placeholder = @"请输入银行卡号";
    [backView   addSubview:_idField];
    
    _bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 94, MSWIDTH - 155, 25)];
    _bankLabel.textAlignment = NSTextAlignmentRight;
    UITapGestureRecognizer *bankTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bankTap)];
    bankTapGR.numberOfTouchesRequired = 1;
    bankTapGR.numberOfTapsRequired = 1;
    _bankLabel.userInteractionEnabled = YES;
    [backView addSubview:_bankLabel];
    [_bankLabel addGestureRecognizer:bankTapGR];
    
    _provinceCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 134, MSWIDTH - 155, 25)];
    _provinceCityLabel.textAlignment = NSTextAlignmentRight;
    UITapGestureRecognizer *CityTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cityTap)];
    CityTapGR.numberOfTouchesRequired = 1;
    CityTapGR.numberOfTapsRequired = 1;
    _provinceCityLabel.userInteractionEnabled = YES;
    [backView addSubview:_provinceCityLabel];
    [_provinceCityLabel addGestureRecognizer:CityTapGR];
    
    //省份选择框
    _provinceComboBox = [[AJComboBox alloc] initWithFrame:CGRectMake(5, 90, MSWIDTH - 20, 36)];
    [_provinceComboBox setLabelText:@"--请选择省份--"];
    [_provinceComboBox setDelegate:self];
    [_provinceComboBox setTag:201];
    //    [backView addSubview:_provinceComboBox];
    
    //所在城市选择框
    _cityComboBox = [[AJComboBox alloc] initWithFrame:CGRectMake(5, 130, MSWIDTH - 20, 36)];
    [_cityComboBox setLabelText:@"--请选择城市--"];
    [_cityComboBox setTag:202];
    [_cityComboBox setDelegate:self];
    _cityComboBox.userInteractionEnabled = NO;
    //    [backView addSubview:_cityComboBox];
    

    
    //银行名称输入框
    _branchbankField = [[UITextField alloc] initWithFrame:CGRectMake(105, 170, MSWIDTH - 125, 36)];
    _branchbankField.borderStyle = UITextBorderStyleNone;
    _branchbankField.font = [UIFont systemFontOfSize:15.0f];
    _branchbankField.delegate = self;
    //    _branchbankField.tag = 1001;
    _branchbankField.textAlignment = NSTextAlignmentRight;
    _branchbankField.placeholder = @"请填写开户支行名称";
    [backView addSubview:_branchbankField];
    
    
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(10, CGRectGetMaxY(backView.frame) + 16, self.view.frame.size.width-20, 45);
    [addBtn setTitle:@"下一步" forState:UIControlStateNormal];
    addBtn.layer.cornerRadius = 3.0f;
    addBtn.layer.masksToBounds = YES;
    addBtn.backgroundColor = GreenColor;
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [addBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    UILabel *infolabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(addBtn.frame)+10, MSWIDTH - 20, 30)];
    infolabel.text = @"提醒：后续只能添加该持卡人的用户卡";
    infolabel.textColor = [UIColor darkGrayColor];
    infolabel.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:infolabel];
    
    //底部筛选视图
    _provinceBackView = [[UIView alloc] initWithFrame:CGRectMake(0, MSHIGHT+200, MSWIDTH, 200)];
    _provinceBackView.backgroundColor  = [UIColor blackColor];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, MSWIDTH, 160)];
    //    指定Delegate
    _pickerView.delegate=self;
    _pickerView.backgroundColor = [UIColor whiteColor];
    //    显示选中框
    _pickerView.showsSelectionIndicator=YES;
    [_provinceBackView addSubview:_pickerView];
    [self.view addSubview:_provinceBackView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 5, 60, 30);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [_provinceBackView addSubview:cancelBtn];
    
    UIButton *surebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    surebtn.frame = CGRectMake(MSWIDTH - 70, 5, 60, 30);
    [surebtn setTitle:@"确定" forState:UIControlStateNormal];
    [surebtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [_provinceBackView addSubview:surebtn];
}

#pragma 银行卡回调
-(void)selectBank:(NSNotification *)notification
{
   NSString *numstr = (NSString*)[notification object];
    NSInteger num = [numstr integerValue];
    _bankLabel.text = _bankCodeNameArr[num];
    _bankIdStr = _bankIdArr[num];
}

#pragma 取消按钮
-(void)cancelClick
{
 
    [UIView animateWithDuration:0.5 animations:^{
        _provinceBackView.frame = CGRectMake(0, MSHIGHT + 200, MSWIDTH, 200);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma 确定按钮
-(void)sureClick
{
    
    [UIView animateWithDuration:0.5 animations:^{
        _provinceBackView.frame = CGRectMake(0, MSHIGHT + 200, MSWIDTH, 200);
    } completion:^(BOOL finished) {
        _provinceCityLabel.text = _provinceStr;
    }];
}

#pragma 银行卡选择
-(void)bankTap
{
    [_nameField resignFirstResponder];
    [_idField resignFirstResponder];
    [_branchbankField resignFirstResponder];
     _provinceBackView.frame = CGRectMake(0, MSHIGHT + 200, MSWIDTH, 200);
    
    bankNameViewController *bankNameView = [[bankNameViewController alloc] init];
    [self.navigationController pushViewController:bankNameView animated:YES];

}

#pragma 开户城市选择
-(void)cityTap
{
    [_nameField resignFirstResponder];
    [_idField resignFirstResponder];
    [_branchbankField resignFirstResponder];

    [_pickerView reloadAllComponents];
    [UIView animateWithDuration:0.5 animations:^{
        _provinceBackView.frame = CGRectMake(0, MSHIGHT - 200, MSWIDTH, 200);
    } completion:^(BOOL finished) {
        
    }];
    
    
    
}

#pragma mark -
#pragma mark Picker Date Source Methods

//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger num = 0;
    
   if (component == 0) {//省份个数
            num = [_provincesArr count];
        } else {//市的个数
           num  = [_citysArr count];
        }

    return num;
}

#pragma mark Picker Delegate Methods

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *contentStr = @"";
    if (component == 0) {//选择省份名
        contentStr =  [_provincesArr objectAtIndex:row];
      
    } else {//选择市名
        contentStr =  [_citysArr objectAtIndex:row];
    }
    return contentStr;
}

//监听轮子的移动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        NSString *seletedProvince = [_provincesArr objectAtIndex:row];
        _provinceIdStr = [NSString stringWithFormat:@"%@",_provinceIdArr[row]];

//         [self requestCityData:_provinceIdArr[row]];
        
//        //重点！更新第二个轮子的数据
//        [self.pickerView reloadComponent:1];
        
        NSInteger selectedCityIndex = [self.pickerView selectedRowInComponent:1];
        NSString *seletedCity = @"";
        _cityNameArr = [[_cityDics objectForKey:_provinceIdArr[row]] allValues];
        if (_cityNameArr.count) {
            [_citysArr removeAllObjects];
            [_cityIdArr removeAllObjects];
            for (AccountItem *cityItem in _cityNameArr) {
                [_citysArr addObject:cityItem.name];
                [_cityIdArr addObject:cityItem.rowId];
            }
            [_pickerView reloadComponent:1];
            if (selectedCityIndex > _citysArr.count) {
                
                seletedCity = [_citysArr objectAtIndex:_citysArr.count -1];
                _cityIdStr = _cityIdArr[_citysArr.count -1];
            }else{
                seletedCity = [_citysArr objectAtIndex:selectedCityIndex];
                _cityIdStr = _cityIdArr[selectedCityIndex];
            }

        }
        _provinceStr = [NSString stringWithFormat:@"%@,%@", seletedProvince,seletedCity];
//        NSLog(@"%@",_provinceStr);
    }
    else {
        NSInteger selectedProvinceIndex = [self.pickerView selectedRowInComponent:0];
        NSString *seletedProvince = [_provincesArr objectAtIndex:selectedProvinceIndex];
        NSString *seletedCity = @"";
        seletedCity = [_citysArr objectAtIndex:row];
        _provinceStr = [NSString stringWithFormat:@"%@,%@", seletedProvince,seletedCity];
        NSLog(@"%@",_provinceStr);
    }
}

#pragma mark
- (void)sureBtnClick
{
    if (AppDelegateInstance.userInfo == nil) {
        [ReLogin outTheTimeRelogin:self];
        return;
    }
    if ([_nameField.text isEqualToString:@""]) {
        [SVProgressHUD showImage:nil status:@"持卡人不能为空"];
        return;
    }
    
    if ([_idField.text isEqualToString:@""]) {
        [SVProgressHUD showImage:nil status:@"卡号不能为空"];
        return;
    }

    if ([_provinceIdStr isEqualToString:@"-2"]|| [_cityIdStr isEqualToString:@"-3"]) {
        [SVProgressHUD showImage:nil status:@"开户行所在地不能为空"];
        return;
    }
    
    if ([_bankIdStr isEqualToString:@"-1"]) {
       [SVProgressHUD showImage:nil status:@"银行不能为空"];
        return;
    }
    
    if ([_branchbankField.text isEqualToString:@""]) {
       [SVProgressHUD showImage:nil status:@"开户支行不能为空"];
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
            
            _provincesArr = [dics objectForKey:@"provinceNames"];
            _provinceIdArr = [dics objectForKey:@"provinceIds"];
            _bankCodeNameArr = [dics objectForKey:@"bankCodeNames"];
            _bankIdArr = [dics objectForKey:@"bankCodeIds"];
             [_pickerView reloadComponent:0];
            if (_provinceIdArr.count!=0) {
                _provinceIdStr = [NSString stringWithFormat:@"%@",_provinceIdArr[0]];
            }
            NSArray *cityArr = [dics objectForKey:@"citylist"];
            for (NSDictionary *item in cityArr) {
                AccountItem *bean = [[AccountItem alloc] init];
                bean.rowId = [NSString stringWithFormat:@"%@",[item objectForKey:@"code"]];
                bean.provinceId = [NSString stringWithFormat:@"%@",[item objectForKey:@"province_code"]];
                bean.name = [NSString stringWithFormat:@"%@",[item objectForKey:@"name"]];
                
                NSMutableDictionary *dics = [_cityDics objectForKey:bean.provinceId];
                if (dics == nil) {
                    dics = [[NSMutableDictionary alloc] init];
                }
                
                [dics setObject:bean forKey:bean.rowId];
                [_cityDics setValue:dics forKey:bean.provinceId];
           }
            if (_cityDics.count && _provincesArr.count)
          {
           
            NSInteger selectedProvIndex = [self.pickerView selectedRowInComponent:0];
              NSString *seletedProvince = _provincesArr[selectedProvIndex];
            _cityNameArr = [[_cityDics objectForKey:_provinceIdArr[selectedProvIndex]] allValues];
              NSString *seletedCity = @"";
            if (_cityNameArr.count) {
                [_citysArr removeAllObjects];
                [_cityIdArr removeAllObjects];
                for (AccountItem *cityItem in _cityNameArr) {
                    [_citysArr addObject:cityItem.name];
                    [_cityIdArr addObject:cityItem.rowId];
                }
                [_pickerView reloadComponent:1];
            }
              if (selectedProvIndex > _citysArr.count) {
                  
                  seletedCity = [_citysArr objectAtIndex:_citysArr.count -1];
                  _cityIdStr = _cityIdArr[_citysArr.count -1];
              }else{
                  seletedCity = [_citysArr objectAtIndex:selectedProvIndex];
                  _cityIdStr = _cityIdArr[selectedProvIndex];
              }
              _provinceStr = [NSString stringWithFormat:@"%@,%@", seletedProvince,seletedCity];
          }
           
        }else if (_requestNum == 3) {
            
         [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
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

-(void)textFieldDidBeginEditing:(UITextField *)textField
{

  _provinceBackView.frame = CGRectMake(0, MSHIGHT + 200, MSWIDTH, 200);

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
