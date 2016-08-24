//
//  AccountInfoViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//账户中心--》账户管理--》账户信息

#import "AccountInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ColorTools.h"
#import "AccountInfoComboBox.h"

#import "AccountInfo.h"

#import "NSString+UserInfo.h"
#import "MSKeyboardScrollView.h"
#import "AccountItem.h"

#define fontsize 14.0f
#define HeightSize  24
#define YPostion  64 + HeightSize //如果坐标从0开始，那64改0

#define DefaultCheckLabel @"- 请选择 -"

#define TAG_NAME 30 //名字
#define TAG_AGE 31 // 年龄
#define TAG_IDCARD 32 // 身份证
#define TAG_PHONE1 33 // 手机号码1
#define TAG_NUMBER1 34 // 验证码1
#define TAG_EMAIL 37 // 验证码2

#define TAG_SEX 40 //性别
#define TAG_EDUCATION 41 // 教育
#define TAG_PROVINCE 42 // 省份
#define TAG_CITY 43 // 城市
#define TAG_MARRIAGE 44 // 婚姻
#define TAG_CAR 45 // 车贷
#define TAG_HOUSE 46 // 房贷

#define MAN @"男"
#define MAN_INDEX 1 // 男的为1
#define WOMAN @"女"
#define WOMAN_INDEX 2 // 女的是2

#define INT_TO_STRING(x)  [NSString stringWithFormat:@"%ld", (long)x]

@interface AccountInfoViewController ()<UITextFieldDelegate,AccountInfoComboBoxDelegate,UIScrollViewDelegate, HTTPClientDelegate>
{
    NSArray *_titleArr;
    
    NSMutableArray *_sexArr;
    
    NSMutableArray *_educationArr;
    NSMutableArray *_provinceArr;
    NSMutableArray *_cityArr;
    NSMutableArray *_marriageArr;
    NSMutableArray *_carArr;
    NSMutableArray *_houseArr;
    
    NSMutableDictionary *_educationDics;
    NSMutableDictionary *_provinceDics;
    NSMutableDictionary *_cityDics;
    NSMutableDictionary *_marriageDics;
    NSMutableDictionary *_carDics;
    NSMutableDictionary *_houseDics;
    NSMutableDictionary *_cityInitDics;// 城市原始数据
    
    NSInteger _provinceTag;
    
    NSInteger _requestType;// 0代表请求基本资料，1代表提交修改资料，2代表获取验证码
}

@property (nonatomic,strong)UITextField *nameField;
@property (nonatomic,strong)UITextField *AgeField;
@property (nonatomic,strong)UITextField *PhoneField1;
@property (nonatomic,strong)UITextField *numField1;
@property (nonatomic,strong)UITextField *cardField;
@property (nonatomic,strong)UITextField *mailField;
@property (nonatomic,strong)UIButton *verifyBtn1;
@property (nonatomic,strong)UIButton *saveBtn;
@property (nonatomic,strong)AccountInfoComboBox *sexComboBox;
@property (nonatomic,strong)AccountInfoComboBox *educationComboBox;
@property (nonatomic,strong)AccountInfoComboBox *provinceComboBox;
@property (nonatomic,strong)AccountInfoComboBox *cityComboBox;
@property (nonatomic,strong)AccountInfoComboBox *marriageComboBox;
@property (nonatomic,strong)AccountInfoComboBox *carComboBox;
@property (nonatomic,strong)AccountInfoComboBox *houseComboBox;
@property (nonatomic,strong)MSKeyboardScrollView *ScrollView;
@property (nonatomic,strong)UIView *backView;


@property (nonatomic, strong) AccountInfo *accountInfo;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation AccountInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _typeNum = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
    
    _requestType = 0;
    [self requestData];
    
}

/**
 * 初始化数据
 */
- (void)initData
{
    _provinceTag = -1;
    
    _accountInfo =  [[AccountInfo alloc] init];
    
    _titleArr = @[@"真实姓名",@"性别",@"年龄", @"邮箱", @"身份证号码", @"文化程度",@"户口所在地",@"婚姻情况",@"购车情况",@"购房情况",@"手机1",@"验证码"];
    _educationDics = [[NSMutableDictionary alloc] init];
    _provinceDics = [[NSMutableDictionary alloc] init];
    _cityDics = [[NSMutableDictionary alloc] init];
    _marriageDics = [[NSMutableDictionary alloc] init];
    _carDics = [[NSMutableDictionary alloc] init];
    _houseDics = [[NSMutableDictionary alloc] init];
    
    _cityInitDics = [[NSMutableDictionary alloc] init];
    
    _educationArr = [[NSMutableArray alloc] init];
    _provinceArr = [[NSMutableArray alloc] init];
    _cityArr = [[NSMutableArray alloc] init];
    _marriageArr = [[NSMutableArray alloc] init];
    _carArr = [[NSMutableArray alloc] init];
    _houseArr = [[NSMutableArray alloc] init];
    
    _sexArr = [[NSMutableArray alloc] init];
    AccountItem *man = [[AccountItem alloc] init];
    man.rowId = MAN_INDEX;
    man.name = MAN;
    AccountItem *woman = [[AccountItem alloc] init];
    woman.rowId = WOMAN_INDEX;
    woman.name = WOMAN;
    [_sexArr addObject:man];
    [_sexArr addObject:woman];
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //滚动视图
    _ScrollView =[[MSKeyboardScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    _ScrollView.userInteractionEnabled = YES;
    _ScrollView.scrollEnabled = YES;
    _ScrollView.showsHorizontalScrollIndicator =NO;
    _ScrollView.showsVerticalScrollIndicator = NO;
    _ScrollView.delegate = self;
    _ScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_ScrollView];
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _backView.backgroundColor = [UIColor whiteColor];
    [_ScrollView addSubview:_backView];
    
    UIControl *viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [viewControl addTarget:self action:@selector(controlAction) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:viewControl];
    
    //标题文本
    for (int i=0; i<=11; i++) {
        UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + i * 36, 70, 30)];
        titlelabel.textAlignment = NSTextAlignmentRight;
        titlelabel.font = [UIFont systemFontOfSize:fontsize];
        titlelabel.text = [_titleArr objectAtIndex:i];
        titlelabel.tag = i + 10;// 标记
        [_backView addSubview:titlelabel];
        
        if (i <= 11) {
            // 添加*号
            UILabel *markLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 12 + i*36, 10, 30)];
            markLabel.textAlignment = NSTextAlignmentCenter;
            markLabel.font = [UIFont systemFontOfSize:fontsize];
            markLabel.text = @"*";
            markLabel.tag = i + 100;// 标记
            markLabel.textColor = PinkColor;
            [_backView addSubview:markLabel];
            
        }
    }
    
    //名字输入框
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX([self.view viewWithTag:(0+100)].frame) + 4, CGRectGetMidY([self.view viewWithTag:(0+10)].frame)-13, 150, 26)];
    _nameField.borderStyle = UITextBorderStyleRoundedRect;
    _nameField.delegate = self;
    _nameField.font = [UIFont systemFontOfSize:fontsize];
    _nameField.placeholder = @"请输入真实名字";
    _nameField.tag = TAG_NAME;
    _nameField.keyboardType = UIKeyboardTypeDefault;
    _nameField.returnKeyType = UIReturnKeyNext;
    [_backView addSubview:_nameField];
    
    //性别选择框
    _sexComboBox = [[AccountInfoComboBox alloc] initWithFrame:CGRectMake(CGRectGetMaxX([self.view viewWithTag:(1+100)].frame) + 4, CGRectGetMidY([self.view viewWithTag:(1+10)].frame) - HeightSize/2 , 84, HeightSize)];
    [_sexComboBox setLabelText:DefaultCheckLabel];
    [_sexComboBox setArrayData:_sexArr];
    [_sexComboBox setDelegate:self];
    [_sexComboBox setTag:TAG_SEX];
    [_backView addSubview:_sexComboBox];
    
    //年龄输入框
    _AgeField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX([self.view viewWithTag:(2+100)].frame) + 4, CGRectGetMidY([self.view viewWithTag:(2+10)].frame) - 13, 84, 26)];
    _AgeField.borderStyle = UITextBorderStyleRoundedRect;
    _AgeField.delegate = self;
    _AgeField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _AgeField.returnKeyType = UIReturnKeyNext;
    _AgeField.font = [UIFont systemFontOfSize:fontsize];
    _AgeField.tag = TAG_AGE;
    _AgeField.placeholder = @"请输入年龄";
    [_backView addSubview:_AgeField];
    
    //邮箱输入框
    _mailField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX([self.view viewWithTag:(3+100)].frame) + 4, CGRectGetMidY([self.view viewWithTag:(3+10)].frame) - 13, 180, 26)];
    _mailField.borderStyle = UITextBorderStyleRoundedRect;
    _mailField.delegate = self;
    _mailField.keyboardType = UIKeyboardTypeEmailAddress;
    _mailField.returnKeyType = UIReturnKeyNext;
    _mailField.tag = TAG_EMAIL;
    _mailField.font = [UIFont systemFontOfSize:fontsize];
    _mailField.placeholder = @"请输入邮箱";
    [_backView addSubview:_mailField];
    
    //身份证输入框
    _cardField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX([self.view viewWithTag:(4+100)].frame) + 4, CGRectGetMidY([self.view viewWithTag:(4+10)].frame) - 13, 180, 26)];
    _cardField.borderStyle = UITextBorderStyleRoundedRect;
    _cardField.delegate = self;
    _cardField.font = [UIFont systemFontOfSize:fontsize];
    _cardField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _cardField.returnKeyType = UIReturnKeyNext;
    _cardField.tag = TAG_IDCARD;
    _cardField.placeholder = @"请输入身份证号码";
    [_backView addSubview:_cardField];
    
    //学历选择框
    _educationComboBox = [[AccountInfoComboBox alloc] initWithFrame:CGRectMake(CGRectGetMaxX([self.view viewWithTag:(5+100)].frame) + 4, CGRectGetMidY([self.view viewWithTag:(5+10)].frame) - HeightSize/2, 100, HeightSize)];
    [_educationComboBox setLabelText:DefaultCheckLabel];
    [_educationComboBox setDelegate:self];
    [_educationComboBox setTag:TAG_EDUCATION];
    [_educationComboBox setArrayData:_educationArr];
    [_backView addSubview:_educationComboBox];
    
    //省份选择框
    _provinceComboBox = [[AccountInfoComboBox alloc] initWithFrame:CGRectMake(CGRectGetMaxX([self.view viewWithTag:(6+100)].frame) + 4, CGRectGetMidY([self.view viewWithTag:(6+10)].frame) - HeightSize/2, 100, HeightSize)];
    [_provinceComboBox setLabelText:DefaultCheckLabel];
    [_provinceComboBox setDelegate:self];
    [_provinceComboBox setTag:TAG_PROVINCE];
    
    //城市选择框
    _cityComboBox = [[AccountInfoComboBox alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_provinceComboBox.frame) + 4, CGRectGetMidY([self.view viewWithTag:(6+10)].frame) - HeightSize/2, 100, HeightSize)];
    [_cityComboBox setLabelText:DefaultCheckLabel];
    [_cityComboBox setDelegate:self];
    [_cityComboBox setTag:TAG_CITY];
    
    [_provinceComboBox setArrayData:_provinceArr];
    [_cityComboBox setArrayData:_cityArr];
    [_backView addSubview:_provinceComboBox];
    [_backView addSubview:_cityComboBox];
    
    //婚姻情况选择框
    _marriageComboBox = [[AccountInfoComboBox alloc] initWithFrame:CGRectMake(CGRectGetMaxX([self.view viewWithTag:(7+100)].frame) + 4, CGRectGetMidY([self.view viewWithTag:(7+10)].frame) - HeightSize/2, 130, HeightSize)];
    [_marriageComboBox setLabelText:DefaultCheckLabel];
    [_marriageComboBox setDelegate:self];
    [_marriageComboBox setTag:TAG_MARRIAGE];
    [_marriageComboBox setArrayData:_marriageArr];
    [_backView addSubview:_marriageComboBox];
    
    //购车情况选择框
    _carComboBox = [[AccountInfoComboBox alloc] initWithFrame:CGRectMake(CGRectGetMaxX([self.view viewWithTag:(8+100)].frame) + 4, CGRectGetMidY([self.view viewWithTag:(8 + 10)].frame) - HeightSize/2, 130, HeightSize)];
    [_carComboBox setLabelText:DefaultCheckLabel];
    [_carComboBox setDelegate:self];
    [_carComboBox setTag:TAG_CAR];
    [_carComboBox setArrayData:_carArr];
    [_backView addSubview:_carComboBox];
    
    //购房情况选择框
    _houseComboBox = [[AccountInfoComboBox alloc] initWithFrame:CGRectMake(CGRectGetMaxX([self.view viewWithTag:(9+100)].frame) + 4, CGRectGetMidY([self.view viewWithTag:(9 + 10)].frame) - HeightSize/2, 130, HeightSize)];
    [_houseComboBox setLabelText:DefaultCheckLabel];
    [_houseComboBox setDelegate:self];
    [_houseComboBox setTag:TAG_HOUSE];
    [_houseComboBox setArrayData:_houseArr];
    [_backView addSubview:_houseComboBox];
    
    //手机号码1输入框
    _PhoneField1 = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX([self.view viewWithTag:(10 + 100)].frame) + 4, CGRectGetMidY([self.view viewWithTag:(10 + 10)].frame) - 13, 130, 26)];
    _PhoneField1.borderStyle = UITextBorderStyleRoundedRect;
    _PhoneField1.delegate = self;
    _PhoneField1.font = [UIFont systemFontOfSize:fontsize];
    _PhoneField1.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _PhoneField1.returnKeyType = UIReturnKeyNext;
    _PhoneField1.placeholder = @"请输入手机1号码";
    _PhoneField1.tag = TAG_PHONE1;
    [_backView addSubview:_PhoneField1];
    
    //验证码1输入框
    _numField1 = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX([self.view viewWithTag:(11 + 10)].frame) + 19, CGRectGetMidY([self.view viewWithTag:(11 + 10)].frame) - 13, 130, 26)];
    _numField1.borderStyle = UITextBorderStyleRoundedRect;
    _numField1.delegate = self;
    _numField1.font = [UIFont systemFontOfSize:fontsize];
    _numField1.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _numField1.returnKeyType = UIReturnKeyDone;
    _numField1.tag = TAG_NUMBER1;
    _numField1.placeholder = @"请输入验证码";
    [_backView addSubview:_numField1];
    
    
    //验证码按钮
    _verifyBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_verifyBtn1 setFrame:CGRectMake(CGRectGetMaxX(_numField1.frame) + HeightSize/2, CGRectGetMidY(_numField1.frame) - 13, 60, 26)];
    [_verifyBtn1 setTitle:@"点击获取" forState:UIControlStateNormal];
    [_verifyBtn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _verifyBtn1.layer.cornerRadius = 4.0f;
    _verifyBtn1.layer.masksToBounds = YES;
    _verifyBtn1.backgroundColor  = KblackgroundColor;
    _verifyBtn1.titleLabel.textColor = [UIColor grayColor];
    _verifyBtn1.titleLabel.font = [UIFont systemFontOfSize:fontsize];
    [_verifyBtn1 setTag:1000+1];
    [_verifyBtn1 addTarget:self action:@selector(verifyClick:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_verifyBtn1];
    
    
    
    //保存按钮
    _saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_saveBtn setFrame:CGRectMake(self.view.frame.size.width*0.5-60, CGRectGetMaxY(_verifyBtn1.frame)+40 , 120, 30)];
    [_saveBtn setTitle:@"保 存" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _saveBtn.layer.cornerRadius= 4.0f;
    _saveBtn.layer.masksToBounds = YES;
    _saveBtn.backgroundColor = GreenColor;
    _saveBtn.titleLabel.textColor = [UIColor whiteColor];
    _saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [_saveBtn setTag:1003];
    [_saveBtn addTarget:self action:@selector(verifyClick:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_saveBtn];
    
    _ScrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(_backView.frame) + HeightSize);
    
}

-(void) setValue
{
    [self setEnable:!_accountInfo.isAddBaseInfo];
    
    if (_accountInfo.realName != nil && ![_accountInfo.realName isEqual:[NSNull null]]) {
        _nameField.text = _accountInfo.realName;
    }
    
    if(_accountInfo.age != 0){
        _AgeField.text = INT_TO_STRING(_accountInfo.age);
    }
    
    if (_accountInfo.cellPhone1 != nil && ![_accountInfo.cellPhone1 isEqual:[NSNull null]]) {
        _PhoneField1.text = _accountInfo.cellPhone1;
    }
    
    if (_accountInfo.cellPhone2 != nil && ![_accountInfo.cellPhone2 isEqual:[NSNull null]]) {
        _PhoneField1.text = _accountInfo.cellPhone2;
    }
    
    if (_accountInfo.email != nil && ![_accountInfo.email isEqual:[NSNull null]]) {
        _mailField.text = _accountInfo.email;
    }
    
    if (_accountInfo.idNo != nil && ![_accountInfo.idNo isEqual:[NSNull null]]) {
        _cardField.text = _accountInfo.idNo;
    }
    
    if (_accountInfo.sex != nil && ![_accountInfo.sex isEqual:[NSNull null]]) {
        [_sexComboBox setLabelText:_accountInfo.sex];
    }
    
    _sexComboBox.table.frame= CGRectMake(_sexComboBox.frame.origin.x, _sexComboBox.frame.origin.y+YPostion-_ScrollView.contentOffset.y, _sexComboBox.frame.size.width, _sexArr.count*30);
    
    AccountItem *education = [_educationDics objectForKey:INT_TO_STRING(_accountInfo.higtestEdu)];
    if (education) {
        [_educationComboBox setLabelText:education.name];
    }
    // _educationArr = [[_educationDics allValues]mutableCopy];
    [_educationComboBox setArrayData:_educationArr];
    _educationComboBox.table.frame= CGRectMake(_educationComboBox.frame.origin.x, _educationComboBox.frame.origin.y+YPostion-_ScrollView.contentOffset.y, _educationComboBox.frame.size.width, [_educationArr  count]*30);
    
    
    AccountItem *province = [_provinceDics objectForKey:INT_TO_STRING(_accountInfo.registedPlacePro)];
    if (province) {
        [_provinceComboBox setLabelText:province.name];
    }
    //_provinceArr = [[_provinceDics allValues]mutableCopy];
    if (_provinceArr) {
        [_provinceComboBox setArrayData:_provinceArr];
        NSInteger size = 0;
        if ([_provinceArr  count] > 7) {
            size = 7;
        }else {
            size = [_provinceArr  count];
        }
        _provinceComboBox.table.frame= CGRectMake(_provinceComboBox.frame.origin.x, _provinceComboBox.frame.origin.y+YPostion-_ScrollView.contentOffset.y, _provinceComboBox.frame.size.width, size*30);
    }
    
    AccountItem *city = [_cityInitDics objectForKey:INT_TO_STRING(_accountInfo.registedPlaceCity)];
    // 从原始数据取
    if (city) {
        [_cityComboBox setLabelText:city.name];
    }
    
    _cityArr = [[[_cityDics objectForKey:INT_TO_STRING(_accountInfo.registedPlacePro)] allValues]mutableCopy];
    if (_cityArr) {
        [_cityComboBox setArrayData:_cityArr];
        NSInteger size = 0;
        if ([_cityArr  count] > 7) {
            size = 7;
        }else {
            size = [_cityArr  count];
        }
        _cityComboBox.table.frame= CGRectMake(_cityComboBox.frame.origin.x, _cityComboBox.frame.origin.y+YPostion-_ScrollView.contentOffset.y, _cityComboBox.frame.size.width, size*30);
    }
    
    AccountItem *marital = [_marriageDics objectForKey:INT_TO_STRING(_accountInfo.maritalStatus)];
    if (marital) {
        [_marriageComboBox setLabelText:marital.name];
    }
    // _marriageArr = [[_marriageDics allValues]mutableCopy];
    if (_marriageArr) {
        [_marriageComboBox setArrayData:_marriageArr];
        _marriageComboBox.table.frame= CGRectMake(_marriageComboBox.frame.origin.x, _marriageComboBox.frame.origin.y+YPostion-_ScrollView.contentOffset.y, _marriageComboBox.frame.size.width, [_marriageArr count]*30);
    }
    
    AccountItem *car = [_carDics objectForKey:INT_TO_STRING(_accountInfo.carStatus)];
    if (car) {
        [_carComboBox setLabelText:car.name];
    }
    // _carArr = [[_carDics allValues]mutableCopy];
    if (_carArr) {
        [_carComboBox setArrayData:_carArr];
        _carComboBox.table.frame= CGRectMake(_carComboBox.frame.origin.x, _carComboBox.frame.origin.y+YPostion-_ScrollView.contentOffset.y, _carComboBox.frame.size.width, [_carArr count]*30);
    }
    
    AccountItem *house = [_houseDics objectForKey:INT_TO_STRING(_accountInfo.housrseStatus)];
    if (house) {
        [_houseComboBox setLabelText:house.name];
    }
    // _houseArr = [[_houseDics allValues]mutableCopy];
    if (_houseArr) {
        [_houseComboBox setArrayData:_houseArr];
        _houseComboBox.table.frame= CGRectMake(_houseComboBox.frame.origin.x, _houseComboBox.frame.origin.y+YPostion-_ScrollView.contentOffset.y, _houseComboBox.frame.size.width, [_houseArr count]*30);
    }
    
}

-(void) setEnable:(BOOL) isEnable
{
    
    _nameField.enabled = isEnable;
    _AgeField.enabled = isEnable;
    _PhoneField1.enabled = isEnable;
    _numField1.enabled = isEnable;
    _cardField.enabled = isEnable;
    _mailField.enabled = isEnable;
    
    _verifyBtn1.enabled = isEnable;
    _verifyBtn1.hidden = !isEnable;
    _saveBtn.enabled = isEnable;
    _saveBtn.hidden = !isEnable;
    
    _sexComboBox.enabled = isEnable;
    _educationComboBox.enabled = isEnable;
    _provinceComboBox.enabled = isEnable;
    _cityComboBox.enabled = isEnable;
    _marriageComboBox.enabled = isEnable;
    _carComboBox.enabled = isEnable;
    _houseComboBox.enabled = isEnable;
    
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"账户信息";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
}

#pragma mark 验证码按钮触发方法
- (void)verifyClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 1001:
            _requestType = 2;
            [self getVerification:btn];
            
            break;
        case 1002:
            _requestType = 2;
            [self getVerification:btn];
            break;
        case 1003:
            _requestType = 1;
            [self submitAccountInfo];
            break;
    }
}

#pragma mark 点击空白处收回键盘
- (void)controlAction
{
    
    for (UITextField *textField in [_backView  subviews])
    {
        if ([textField isKindOfClass: [UITextField class]]) {
            
            [textField  resignFirstResponder];
        }
        
    }
    
}


#pragma mark 单选框代理方法
-(void)didChangeComboBoxValue:(AccountInfoComboBox *)comboBox selectedIndex:(NSInteger)selectedIndex
{
    switch (comboBox.tag) {
        case TAG_SEX:
        {
            AccountItem *sex = [_sexArr objectAtIndex:selectedIndex];
            if (sex) {
                comboBox.labelText = sex.name;
                _accountInfo.sexId = sex.rowId;
            }
        }
            break;
        case TAG_EDUCATION:
        {
            AccountItem *education = [_educationArr objectAtIndex:selectedIndex];
            if (education) {
                comboBox.labelText = education.name;
                _accountInfo.higtestEdu = education.rowId;
            }
        }
            break;
        case TAG_PROVINCE:
        {
            AccountItem *province = [_provinceArr objectAtIndex:selectedIndex];
            if (province) {
                comboBox.labelText = province.name;
                _accountInfo.registedPlacePro = province.rowId;
            }
            
            // 复位城市信息
            [_cityComboBox setLabelText:DefaultCheckLabel];
            _provinceTag = province.rowId;
            _cityArr = [[[_cityDics objectForKey:INT_TO_STRING(_provinceTag)] allValues]mutableCopy];
            if (_cityArr) {
                [_cityComboBox setArrayData:_cityArr];
                
                if (_provinceTag >= 0) {
                    NSInteger size = 0;
                    if ([_cityArr  count] > 7) {
                        size = 7;
                    }else {
                        size = [_cityArr  count];
                    }
                    _cityComboBox.table.frame= CGRectMake(_cityComboBox.frame.origin.x, _cityComboBox.frame.origin.y+YPostion-_ScrollView.contentOffset.y, _cityComboBox.frame.size.width, size*30);
                }
            }
            
        }
            break;
        case TAG_CITY:
        {
            AccountItem *city = [_cityArr objectAtIndex:selectedIndex];
            if (city) {
                comboBox.labelText = city.name;
                _accountInfo.registedPlaceCity = city.rowId;
            }
        }
            break;
        case TAG_MARRIAGE:
        {
            AccountItem *marital = [_marriageArr objectAtIndex:selectedIndex];
            if (marital) {
                comboBox.labelText = marital.name;
                _accountInfo.maritalStatus = marital.rowId;
            }
        }
            break;
        case TAG_CAR:
        {
            AccountItem *car = [_carArr objectAtIndex:selectedIndex];
            if (car) {
                comboBox.labelText = car.name;
                _accountInfo.carStatus = car.rowId;
            }
        }
            break;
        case TAG_HOUSE:
        {
            AccountItem *house = [_houseArr objectAtIndex:selectedIndex];
            if (house) {
                comboBox.labelText = house.name;
                _accountInfo.housrseStatus = house.rowId;
            }
        }
            break;
        default:
            break;
    }
}

-(void)didClickComboBox:(AccountInfoComboBox *)comboBox
{
    [self controlAction];
}


#pragma UITextFieldDelegate
// 当用户按下return键或者按回车键
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case TAG_NAME:
            [_AgeField becomeFirstResponder];
            break;
        case TAG_AGE:
            [_mailField becomeFirstResponder];
            break;
        case TAG_EMAIL:
            [_cardField becomeFirstResponder];
            break;
        case TAG_IDCARD:
            [_PhoneField1 becomeFirstResponder];
            break;
        case TAG_PHONE1:
            [_numField1 becomeFirstResponder];
            break;
        case TAG_NUMBER1:
            [textField resignFirstResponder];
            break;
            
        default:
            break;
    }
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    /* CGRect frame = textField.frame;
     int offset = frame.origin.y + 52 - (self.view.frame.size.height - 216.0);//键盘高度216
     
     NSTimeInterval animationDuration = 0.30f;
     [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
     [UIView setAnimationDuration:animationDuration];
     
     //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
     if(offset > 0)
     self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
     
     [UIView commitAnimations];*/
}

#pragma 返回按钮触发方法
- (void)backClick
{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    _sexComboBox.table.frame= CGRectMake(_sexComboBox.frame.origin.x, _sexComboBox.frame.origin.y+YPostion-scrollView.contentOffset.y, _sexComboBox.frame.size.width, [_sexArr count]*30);
    
    _educationComboBox.table.frame= CGRectMake(_educationComboBox.frame.origin.x, _educationComboBox.frame.origin.y+YPostion-scrollView.contentOffset.y, _educationComboBox.frame.size.width, [_educationArr count]*30);
    
    NSInteger provinceSize = 0;
    if ([_provinceArr  count] > 7) {
        provinceSize = 7;
    }else {
        provinceSize = [_provinceArr  count];
    }
    _provinceComboBox.table.frame= CGRectMake(_provinceComboBox.frame.origin.x, _provinceComboBox.frame.origin.y+YPostion-scrollView.contentOffset.y, _provinceComboBox.frame.size.width, provinceSize*30);
    
    NSInteger citySize = 0;
    if ([_cityArr  count] > 7) {
        citySize = 7;
    }else {
        citySize = [_cityArr  count];
    }
    _cityComboBox.table.frame= CGRectMake(_cityComboBox.frame.origin.x, _cityComboBox.frame.origin.y+YPostion-scrollView.contentOffset.y, _cityComboBox.frame.size.width, citySize*30);
    
    _marriageComboBox.table.frame= CGRectMake(_marriageComboBox.frame.origin.x, _marriageComboBox.frame.origin.y+YPostion-scrollView.contentOffset.y, _marriageComboBox.frame.size.width, [_marriageArr count]*30);
    
    _carComboBox.table.frame= CGRectMake(_carComboBox.frame.origin.x, _carComboBox.frame.origin.y+YPostion-scrollView.contentOffset.y, _carComboBox.frame.size.width, [_carArr count]*30);
    
    _houseComboBox.table.frame= CGRectMake(_houseComboBox.frame.origin.x, _houseComboBox.frame.origin.y+YPostion-scrollView.contentOffset.y, _houseComboBox.frame.size.width, [_houseArr count]*30);
    
}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self requestData];
}

#pragma 请求数据
-(void) requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"3" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
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
        
        if (_requestType == 0) {
            
            _accountInfo.realName = [dics objectForKey:@"realName"];
            _accountInfo.idNo = [dics objectForKey:@"idNo"];
            _accountInfo.cellPhone1 = [dics objectForKey:@"cellPhone1"];
            _accountInfo.cellPhone2 = [dics objectForKey:@"cellPhone2"];
            _accountInfo.email = [dics objectForKey:@"email"];
            _accountInfo.higtestEdu = [[dics objectForKey:@"higtestEdu"] intValue];// int
            _accountInfo.housrseStatus = [[dics objectForKey:@"housrseStatus"] intValue];//int
            _accountInfo.maritalStatus = [[dics objectForKey:@"maritalStatus"] intValue];//int
            _accountInfo.registedPlaceCity = [[dics objectForKey:@"registedPlaceCity"] intValue];//int
            _accountInfo.registedPlacePro = [[dics objectForKey:@"registedPlacePro"] intValue];//int
            _accountInfo.sex = [dics objectForKey:@"sex"];// string
            _accountInfo.isAddBaseInfo = [[dics objectForKey:@"isAddBaseInfo"] boolValue];
            
            if (![_accountInfo.sex isEqual:[NSNull null]]) {
                if ([_accountInfo.sex isEqualToString:MAN]) {
                    _accountInfo.sexId = MAN_INDEX;
                } else {
                    _accountInfo.sexId = WOMAN_INDEX;
                }
            }
            
            _accountInfo.carStatus = [[dics objectForKey:@"CarStatus"] intValue];// int
            _accountInfo.age = [[dics objectForKey:@"age"] intValue];// int
            
            NSArray *provinceArr = [dics objectForKey:@"provinceList"];
            for (NSDictionary *item in provinceArr) {
                AccountItem *bean = [[AccountItem alloc] init];
                bean.rowId = [[item objectForKey:@"id"] intValue];
                bean.name = [item objectForKey:@"name"];
                [_provinceArr addObject:bean];
                [_provinceDics setValue:bean forKey:INT_TO_STRING(bean.rowId)];
            }
            
            NSArray *cityArr = [dics objectForKey:@"cityList"];
            for (NSDictionary *item in cityArr) {
                AccountItem *bean = [[AccountItem alloc] init];
                bean.rowId = [[item objectForKey:@"id"] intValue];
                bean.provinceId = [[item objectForKey:@"province_id"] intValue];
                bean.name = [item objectForKey:@"name"];
                
                NSMutableDictionary *dics = [_cityDics objectForKey:INT_TO_STRING(bean.provinceId)];
                if (dics == nil) {
                    dics = [[NSMutableDictionary alloc] init];
                }
                
                [dics setObject:bean forKey:INT_TO_STRING(bean.rowId)];
                [_cityDics setValue:dics forKey:INT_TO_STRING(bean.provinceId)];
                
                [_cityInitDics setValue:bean forKey:INT_TO_STRING(bean.rowId)];
            }
            
            NSArray *housesArr = [dics objectForKey:@"housesList"];
            for (NSDictionary *item in housesArr) {
                AccountItem *bean = [[AccountItem alloc] init];
                bean.rowId = [[item objectForKey:@"id"] intValue];
                bean.name = [item objectForKey:@"name"];
                [_houseArr addObject:bean];
                [_houseDics setValue:bean forKey:INT_TO_STRING(bean.rowId)];
            }
            
            NSArray *carArr = [dics objectForKey:@"carList"];
            for (NSDictionary *item in carArr) {
                AccountItem *bean = [[AccountItem alloc] init];
                bean.rowId = [[item objectForKey:@"id"] intValue];
                bean.name = [item objectForKey:@"name"];
                [_carArr addObject:bean];
                [_carDics setValue:bean forKey:INT_TO_STRING(bean.rowId)];
            }
            
            NSArray *maritalsArr = [dics objectForKey:@"maritalsList"];
            for (NSDictionary *item in maritalsArr) {
                AccountItem *bean = [[AccountItem alloc] init];
                bean.rowId = [[item objectForKey:@"id"] intValue];
                bean.name = [item objectForKey:@"name"];
                [_marriageArr addObject:bean];
                [_marriageDics setValue:bean forKey:INT_TO_STRING(bean.rowId)];
            }
            
            NSArray *educationsArr = [dics objectForKey:@"educationsList"];
            for (NSDictionary *item in educationsArr) {
                AccountItem *bean = [[AccountItem alloc] init];
                bean.rowId = [[item objectForKey:@"id"] intValue];
                bean.name = [item objectForKey:@"name"];
                [_educationArr addObject:bean];
                [_educationDics setValue:bean forKey:INT_TO_STRING(bean.rowId)];
            }
            
            [self setValue];
            
        }else if(_requestType == 1){
            //            _saveBtn.userInteractionEnabled = NO;
            //            _saveBtn.alpha = 0;
            
            [self setEnable:NO];
            
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
            
#warning 增加提交用户资料成功后的视图跳转
            switch (_typeNum) {
                    
                case 1:
                {
                    ReleaseBorrowInfoViewController *releaseBorrowInfoView = [[ReleaseBorrowInfoViewController alloc] init];
                    releaseBorrowInfoView.productID = _cbsVC.productId;
                    
                    DLOG(@"self.title -> %@", _cbsVC.title);
                    if ([self.title isEqualToString:@"秒还借款"]) {
                        releaseBorrowInfoView.isRepayment = 1;
                    }else {
                        releaseBorrowInfoView.isRepayment = 0;
                    }
                    
                    [_cbsVC.navigationController pushViewController:releaseBorrowInfoView animated:NO];
                    
                }
                    break;
                case 2:
                {
                    ReleaseBorrowInfoViewController *releaseBorrowInfoView = [[ReleaseBorrowInfoViewController alloc] init];
                    releaseBorrowInfoView.productID = _pdpVC.productid;
                    
                    DLOG(@"self.title -> %@", _pdpVC.title);
                    if ([self.title isEqualToString:@"秒还借款"]) {
                        releaseBorrowInfoView.isRepayment = 1;
                    }else {
                        releaseBorrowInfoView.isRepayment = 0;
                    }
                    
                    [_pdpVC.navigationController pushViewController:releaseBorrowInfoView animated:NO];
                    
                    
                }
                    break;
            }
            [self dismissViewControllerAnimated:YES completion:^(){}];
            
            
            
        }
        else if(_requestType == 2){
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        }
        
    } else {
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

-(void) submitAccountInfo
{
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        return;
    }
    
    if ([_nameField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请填写真实姓名"];
        return;
    }
    
    if ([_sexComboBox.labelText isEqualToString:DefaultCheckLabel]) {
        [SVProgressHUD showErrorWithStatus:@"请选择性别"];
        return;
    }
    
    if ([_AgeField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请填写年龄"];
        return;
    }
    
    if ([_cardField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请填写身份证"];
        return;
    }
    
    if (![NSString validateIdCard:_cardField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的身份证"];
        return;
    }
    
    if ([_educationComboBox.labelText isEqualToString:DefaultCheckLabel]) {
        [SVProgressHUD showErrorWithStatus:@"请选择文化程度"];
        return;
    }
    
    if ([_provinceComboBox.labelText isEqualToString:DefaultCheckLabel]) {
        [SVProgressHUD showErrorWithStatus:@"请选择所在省份"];
        return;
    }
    
    if ([_cityComboBox.labelText isEqualToString:DefaultCheckLabel]) {
        [SVProgressHUD showErrorWithStatus:@"请选择所在城市"];
        return;
    }
    
    if ([_marriageComboBox.labelText isEqualToString:DefaultCheckLabel]) {
        [SVProgressHUD showErrorWithStatus:@"请选择婚姻情况"];
        return;
    }
    
    if ([_carComboBox.labelText isEqualToString:DefaultCheckLabel]) {
        [SVProgressHUD showErrorWithStatus:@"请选择购车情况"];
        return;
    }
    
    if ([_houseComboBox.labelText isEqualToString:DefaultCheckLabel]) {
        [SVProgressHUD showErrorWithStatus:@"请选择购房情况"];
        return;
    }
    
    if ([_PhoneField1.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请填写电话号码"];
        return;
    }
    
    if (![NSString validateMobile:_PhoneField1.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码1"];
        return;
    }
    
    if ([_numField1.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请填写收到的验证码"];
        return;
    }
    
    
    if (![_mailField.text isEqualToString:@""]) {
        if (![NSString validateEmail:_mailField.text]) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的邮箱"];
            return;
        }
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"24" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
    [parameters setObject:_nameField.text forKey:@"realName"];
    [parameters setObject:_cardField.text forKey:@"idNo"];
    [parameters setObject:INT_TO_STRING(_accountInfo.sexId) forKey:@"sex"];
    [parameters setObject:INT_TO_STRING(_accountInfo.higtestEdu) forKey:@"higtestEdu"];
    [parameters setObject:INT_TO_STRING(_accountInfo.registedPlacePro) forKey:@"registedPlacePro"];
    [parameters setObject:INT_TO_STRING(_accountInfo.registedPlaceCity) forKey:@"registedPlaceCity"];
    [parameters setObject:INT_TO_STRING(_accountInfo.maritalStatus) forKey:@"maritalStatus"];
    [parameters setObject:INT_TO_STRING(_accountInfo.housrseStatus) forKey:@"housrseStatus"];
    [parameters setObject:INT_TO_STRING(_accountInfo.carStatus) forKey:@"CarStatus"];
    [parameters setObject:_PhoneField1.text forKey:@"cellPhone1"];
    [parameters setObject:_numField1.text forKey:@"randomCode1"];
    //    [parameters setObject:_PhoneField2.text forKey:@"cellPhone2"];
    //    [parameters setObject:_numField2.text forKey:@"randomCode2"];
    [parameters setObject:_AgeField.text forKey:@"age"];
    [parameters setObject:_mailField.text forKey:@"email"];
    
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
}

//  获取验证码
-(void) getVerification:(UIButton *)sender
{
    if (sender.tag == 1001) {
        if ([_PhoneField1.text isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"请输入手机1电话号码"];
            return;
        }
    }
    
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        return;
    }
    __block int timeout = 30; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                if (sender.tag == 1001) {
                    [_verifyBtn1 setTitle:@"点击获取" forState:UIControlStateNormal];
                    _verifyBtn1.userInteractionEnabled = YES;
                    [_verifyBtn1 setAlpha:1];
                }
                
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                DLOG(@"____%@",strTime);
                
                if (sender.tag == 1001) {
                    [_verifyBtn1 setTitle:[NSString stringWithFormat:@"稍后(%@s)",strTime] forState:UIControlStateNormal];
                    _verifyBtn1.userInteractionEnabled = NO;
                    [_verifyBtn1 setAlpha:0.4];
                }
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"4" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    
    if (sender.tag == 1001) {
        [parameters setObject:_PhoneField1.text forKey:@"cellPhone"];
    }
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
}


-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end
