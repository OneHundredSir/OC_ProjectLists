//
//  AccountInfoViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//账户中心--》账户管理--》账户信息

#import "AccountInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ColorTools.h"

#import "AccountInfo.h"
#import "NSString+UserInfo.h"
#import "MSKeyboardScrollView.h"
#import "RestUIAlertView.h"
#import "UIButton+WebCache.h"

#import "AccountItem.h"
#import "TabViewController.h"
#import "AccuontSafeViewController.h"
#import "TwoCodeViewController.h"
#import "BankCardManageViewController.h"

#define fontsize 14.0f

#define DefaultCheckLabel @"- 请选择 -"

#define TAG_NAME 30 //名字
#define TAG_AGE 31 // 年龄
#define TAG_IDCARD 32 // 身份证
#define TAG_PHONE1 33 // 手机号码1
#define TAG_NUMBER1 34 // 验证码1
//#define TAG_PHONE2 35 // 手机号码2
//#define TAG_NUMBER2 36 // 验证码2
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

#define INT_TO_STRING(x)  [NSString stringWithFormat:@"%ld", x]

@interface AccountInfoViewController ()<UITextFieldDelegate,UIScrollViewDelegate, HTTPClientDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate>
{
    NSArray *_titleArr;
    
    NSMutableArray *_sexArr;
    NSMutableArray *_detailArr;
    
    NSArray *_educationArr;
    NSArray *_provinceArr;
    NSArray *_cityArr;
    NSArray *_marriageArr;
    NSArray *_carArr;
    NSArray *_houseArr;
    NSArray *_sexsArr;
    
    NSMutableDictionary *_educationDics;
    NSMutableDictionary *_provinceDics;
    NSMutableDictionary *_cityDics;
    NSMutableDictionary *_marriageDics;
    NSMutableDictionary *_carDics;
    NSMutableDictionary *_houseDics;
    NSMutableDictionary *_cityInitDics;// 城市原始数据
    
    NSMutableArray *_skyCityArr;// 城市

    NSMutableArray *_provincesArr;
    NSMutableArray *_provinceIdArr;
    NSMutableArray *_agesArr;
    NSMutableArray *_citysArr;
    NSMutableArray *_cityIdArr;
    NSMutableArray *_higtestEduArr;
    NSMutableArray *_higtestEduIdArr;
    NSMutableArray *_housesArr;
    NSMutableArray *_housesIdArr;
    NSMutableArray *_marriagesArr;
    NSMutableArray *_marriagesIdArr;
    NSMutableArray *_carsArr;
    NSMutableArray *_carsIdArr;
    
    NSInteger _provinceTag;
    
    NSInteger _requestType;// 0代表请求基本资料，1代表提交修改资料，2代表获取验证码
    
    BOOL isNum;     // 是否需要验证码。（只有首次编辑才需要验证码  0: 需要  1：不需要）
    BOOL isPhone;   // 是否设定了安全手机。（0：没有  1：已设定）
    BOOL isMail;   // 是否设定了安全邮箱。（0：没有  1：已设定）

    NSString *_nameStr;
    NSString *_sexStr;
    NSString *_ageStr;
    NSString *_cardIdStr;
    NSString *_educationStr;
    NSString *_cityStr;
    NSString *_marriageStr;
    NSString *_carStr;
    NSString *_houseStr;
    
    NSString *_screenTypeStr;
}

@property (nonatomic,strong)UITextField *nameField;
@property (nonatomic,strong)UITextField *AgeField;
@property (nonatomic,strong)UITextField *PhoneField1;
@property (nonatomic,strong)UITextField *numField1;
@property (nonatomic,strong)UITextField *cardField;
@property (nonatomic,strong)UITextField *mailField;
@property (nonatomic,strong)UIButton *verifyBtn1;
@property (nonatomic,strong)UIButton *saveBtn;
@property (nonatomic,strong)UIScrollView *ScrollView;
@property (nonatomic,strong)UIView *backView;

@property (nonatomic,strong)UILabel *numLabel;  // 验证码Title
@property (nonatomic,strong)UILabel *starLabel;  // 验证码 后面的*

@property (nonatomic, strong) AccountInfo *accountInfo;
@property(nonatomic ,strong) NetWorkClient *requestClient;

@property (nonatomic, strong) UIButton *headerBtn;
@property (nonatomic, copy) NSString *logoStr;
@property (nonatomic)UIImage *hearImg;
@property (nonatomic, strong) UITableView *accountTableView;
@property (nonatomic, strong) UIBarButtonItem *saveItem;

@property(nonatomic ,strong) UIPickerView *pickerView;
@property(nonatomic ,strong) UIPickerView *citypickerView;
@property(nonatomic ,strong) UIView  *provinceBackView;

@end

@implementation AccountInfoViewController

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
    isNum = NO;
    isPhone = NO;
    isMail = NO;
    
     _accountInfo =  [[AccountInfo alloc] init];
    _detailArr = [NSMutableArray array];
    _screenTypeStr = @"性别";
    _sexsArr = @[@"男",@"女"];
    _titleArr = @[@"真实姓名",@"性别",@"年龄",@"身份证号码", @"文化程度",@"户口所在地",@"婚姻情况",@"购车情况",@"购房情况"];
    _educationDics = [[NSMutableDictionary alloc] init];
    _provinceDics = [[NSMutableDictionary alloc] init];
    _cityDics = [[NSMutableDictionary alloc] init];
    _marriageDics = [[NSMutableDictionary alloc] init];
    _carDics = [[NSMutableDictionary alloc] init];
    _houseDics = [[NSMutableDictionary alloc] init];
    
    _cityInitDics = [[NSMutableDictionary alloc] init];
    _skyCityArr = [[NSMutableArray alloc] init];

    _educationArr = [[NSMutableArray alloc] init];
    _provinceArr = [[NSMutableArray alloc] init];
    _cityArr = [[NSMutableArray alloc] init];
    _marriageArr = [[NSMutableArray alloc] init];
    _carArr = [[NSMutableArray alloc] init];
    _houseArr = [[NSMutableArray alloc] init];
    
    _sexArr = [[NSMutableArray alloc] init];
    AccountItem *man = [[AccountItem alloc] init];
    man.rowId = [NSString stringWithFormat:@"%d",MAN_INDEX];
    man.name = MAN;
    AccountItem *woman = [[AccountItem alloc] init];
    woman.rowId = [NSString stringWithFormat:@"%d",WOMAN_INDEX];
    woman.name = WOMAN;
    [_sexArr addObject:man];
    [_sexArr addObject:woman];
    
    _provincesArr = [NSMutableArray array];
    _provinceIdArr = [NSMutableArray array];
    
    _citysArr = [NSMutableArray array];
    _cityIdArr = [NSMutableArray array];
    _higtestEduArr = [NSMutableArray array];
    _higtestEduIdArr = [NSMutableArray array];
    _housesArr = [NSMutableArray array];
    _housesIdArr  = [NSMutableArray array];
    _marriagesArr  = [NSMutableArray array];
    _marriagesIdArr  = [NSMutableArray array];
    _carsArr = [NSMutableArray array];
    _carsIdArr = [NSMutableArray array];
    _agesArr = [NSMutableArray array];
    for (int i = 1; i <= 100; i++) {
        [_agesArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
}

- (void)initView
{
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //滚动视图
    _ScrollView =[[MSKeyboardScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _ScrollView.userInteractionEnabled = YES;
    _ScrollView.scrollEnabled = YES;
    _ScrollView.showsHorizontalScrollIndicator =NO;
    _ScrollView.showsVerticalScrollIndicator = NO;
    _ScrollView.delegate = self;
    _ScrollView.backgroundColor = KblackgroundColor;
    _ScrollView.contentSize = CGSizeMake(MSWIDTH, MSHIGHT+100);
    [self.view addSubview:_ScrollView];
    
    UIView *headerView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    headerView.backgroundColor = [UIColor whiteColor];
    [_ScrollView addSubview:headerView];
    
    UIControl *viewControl1 = [[UIControl alloc] initWithFrame:headerView.bounds];
    [viewControl1 addTarget:self action:@selector(cpsClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:viewControl1];
    
    // logo图片
    _headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _headerBtn.frame = CGRectMake(35, 5, 60, 60);
    [_headerBtn.layer setMasksToBounds:YES];
    [_headerBtn.layer setCornerRadius:30.0]; //设置矩形四个圆角半径
    [_headerBtn addTarget:self action:@selector(changeIcon) forControlEvents:UIControlEventTouchUpInside];
    [_headerBtn setBackgroundImage:[UIImage imageNamed:@"default_head"] forState:UIControlStateNormal];
    [_headerBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
    if (AppDelegateInstance.userInfo != nil) {
        
        [_headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:AppDelegateInstance.userInfo.userImg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head"]];
    }
    [headerView addSubview:_headerBtn];// 登陆头像
    
    
    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 30, MSWIDTH - 170, 20)];
    namelabel.textAlignment = NSTextAlignmentLeft;
    namelabel.font = [UIFont boldSystemFontOfSize:15.0f];
    if (AppDelegateInstance.userInfo != nil) {
        
      namelabel.text = AppDelegateInstance.userInfo.userName;
    }
    [headerView addSubview:namelabel];
    
    UIImageView *codeImg = [[UIImageView alloc] initWithFrame:CGRectMake(MSWIDTH - 70, 25, 25, 25)];
    codeImg.image = [UIImage imageNamed:@"twoCode"];
    [headerView addSubview:codeImg];
    
    UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(MSWIDTH - 35, 25, 20, 20)];
    arrowImg.image = [UIImage imageNamed:@"cell_more_btn"];
    [headerView addSubview:arrowImg];
    
//    UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, MSWIDTH, 0.8)];
//    lineLabel1.backgroundColor = [UIColor lightGrayColor];
//    [headerView addSubview:lineLabel1];
    
//    UILabel *lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH/2, 70, 0.8, 70)];
//    lineLabel2.backgroundColor = [UIColor lightGrayColor];
//    [headerView addSubview:lineLabel2];
    
    
//    UIButton *cardBtn = [UIButton buttonWithType:UIButtonTypeCustom];//button的类型
//    cardBtn.frame =CGRectMake(0, 71, MSWIDTH/2, 69);//button的frame
//    [cardBtn setImage:[UIImage imageNamed:@"order_icon_205"] forState:UIControlStateNormal];//给button添加image
//    cardBtn.imageEdgeInsets = UIEdgeInsetsMake(20,15,20,40);
//    [cardBtn setTitle:@"银行卡" forState:UIControlStateNormal];
//    cardBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    cardBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [cardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [cardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//    cardBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -cardBtn.titleLabel.bounds.size.width, 0, 0);
//    [cardBtn addTarget:self action:@selector(cardClick) forControlEvents:UIControlEventTouchUpInside];
//    [headerView addSubview:cardBtn];
//    
//    
//    UIButton *saftBtn = [UIButton buttonWithType:UIButtonTypeCustom];//button的类型
//    saftBtn.frame =CGRectMake(MSWIDTH/2+1, 71, MSWIDTH/2, 69);//button的frame
//    [saftBtn setImage:[UIImage imageNamed:@"order_icon_206"] forState:UIControlStateNormal];//给button添加image
//    saftBtn.imageEdgeInsets = UIEdgeInsetsMake(20,15,20,40);
//    [saftBtn setTitle:@"安全" forState:UIControlStateNormal];
//    saftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    saftBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [saftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [saftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//    saftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -saftBtn.titleLabel.bounds.size.width, 0, 0);
//    [saftBtn addTarget:self action:@selector(intoSafeClick) forControlEvents:UIControlEventTouchUpInside];
//    [headerView addSubview:saftBtn];
    
    
    _accountTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 90, self.view.frame.size.width, 450) style:UITableViewStylePlain];
    _accountTableView.delegate = self;
    _accountTableView.dataSource = self;
    _accountTableView.scrollEnabled = NO;
    
    [_accountTableView setBackgroundColor:KblackgroundColor];
    [_ScrollView addSubview:_accountTableView];
    
//    //名字输入框
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(80, 5, MSWIDTH - 90, 40)];
    _nameField.delegate = self;
    _nameField.backgroundColor = [UIColor whiteColor];
    _nameField.font = [UIFont systemFontOfSize:fontsize];
    _nameField.textAlignment = NSTextAlignmentRight;
    _nameField.placeholder = @"请输入真实名字";
    _nameField.tag = TAG_NAME;
    _nameField.keyboardType = UIKeyboardTypeDefault;
//    _nameField.returnKeyType = UIReturnKeyNext;

//
    //身份证输入框
    _cardField = [[UITextField alloc] initWithFrame:CGRectMake(100, 5, MSWIDTH - 110, 40)];
    _cardField.delegate = self;
    _cardField.backgroundColor = [UIColor redColor];
    _cardField.backgroundColor = [UIColor whiteColor];
    _cardField.font = [UIFont systemFontOfSize:fontsize];
    _cardField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//    _cardField.returnKeyType = UIReturnKeyNext;
    _cardField.textAlignment = NSTextAlignmentRight;
    _cardField.tag = TAG_IDCARD;
    _cardField.placeholder = @"请输入身份证号码";
//
    
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
    
    
//    _citypickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, MSWIDTH, 160)];
//    //    指定Delegate
//    _citypickerView.delegate=self;
//    _citypickerView.backgroundColor = [UIColor whiteColor];
//    //    显示选中框
//    _citypickerView.showsSelectionIndicator=YES;
//    [_provinceBackView addSubview:_citypickerView];
    
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
   
    
    if ([_screenTypeStr isEqualToString:@"性别"]) {
        
      [_detailArr  replaceObjectAtIndex:1 withObject:_sexStr];
        
    }else if ([_screenTypeStr isEqualToString:@"年龄"]) {
        
        [_detailArr  replaceObjectAtIndex:2 withObject:_ageStr];
        
    }else if ([_screenTypeStr isEqualToString:@"学历"]) {
        
    [_detailArr  replaceObjectAtIndex:4 withObject:_educationStr];
        
    }else if ([_screenTypeStr isEqualToString:@"城市"]) {
        
        [_detailArr  replaceObjectAtIndex:5 withObject:_cityStr];
        
    }else if ([_screenTypeStr isEqualToString:@"婚姻"]) {
        
        [_detailArr  replaceObjectAtIndex:6 withObject:_marriageStr];
        
    }else if ([_screenTypeStr isEqualToString:@"购车"]) {
        
        [_detailArr  replaceObjectAtIndex:7 withObject:_carStr];
        
    }else if ([_screenTypeStr isEqualToString:@"购房"]) {
        
      [_detailArr  replaceObjectAtIndex:8 withObject:_houseStr];
    }
   
    [UIView animateWithDuration:0.5 animations:^{
        _provinceBackView.frame = CGRectMake(0, MSHIGHT + 200, MSWIDTH, 200);
    } completion:^(BOOL finished) {
       [_accountTableView reloadData];
    }];
}
#pragma mark -
#pragma mark Picker Date Source Methods

//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger listNum;
    if ([_screenTypeStr isEqualToString:@"城市"]) {
        listNum = 2;
    }else
        listNum = 1;
    return listNum;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger num = 0;
    if ([_screenTypeStr isEqualToString:@"性别"]) {
        
        num = _sexsArr.count;
    }else if ([_screenTypeStr isEqualToString:@"年龄"]) {
        
        num = _agesArr.count;

    }else if ([_screenTypeStr isEqualToString:@"学历"]) {
        
        num = _higtestEduArr.count;
        
    }else if ([_screenTypeStr isEqualToString:@"城市"]) {
        
        if (component == 0) {//省份个数
            num = [_provincesArr count];
        } else {//市的个数
            num  = [_citysArr count];
        }
        
    }else if ([_screenTypeStr isEqualToString:@"婚姻"]) {
        
        num = _marriagesArr.count;
        
    }else if ([_screenTypeStr isEqualToString:@"购车"]) {
        
        num = _carsArr.count;
        
    }else if ([_screenTypeStr isEqualToString:@"购房"]) {
        
        num = _housesArr.count;
    }
    
    return num;
}

#pragma mark Picker Delegate Methods

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *contentStr = @"";
    
    if ([_screenTypeStr isEqualToString:@"性别"]) {
        
        contentStr = _sexsArr[row];
        
    }else if ([_screenTypeStr isEqualToString:@"年龄"]) {
        
        contentStr = _agesArr[row];
        
    }else if ([_screenTypeStr isEqualToString:@"学历"]) {
        
        contentStr = _higtestEduArr[row];
        
    }else if ([_screenTypeStr isEqualToString:@"城市"]) {
        
        if (component == 0) {//选择省份名
            contentStr =  [_provincesArr objectAtIndex:row];
            
        } else {//选择市名
            if (row >_citysArr.count) {
                contentStr =  [_citysArr objectAtIndex:0];
            }else
                contentStr = [_citysArr objectAtIndex:row];
        }
        
    }else if ([_screenTypeStr isEqualToString:@"婚姻"]) {
        
        contentStr = _marriagesArr[row];
        
    }else if ([_screenTypeStr isEqualToString:@"购车"]) {
        
        contentStr = _carsArr[row];
        
    }else if ([_screenTypeStr isEqualToString:@"购房"]) {
        
        contentStr = _housesArr[row];
    }
    
    return contentStr;
}

//监听轮子的移动
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   
    if ([_screenTypeStr isEqualToString:@"性别"]) {
        
        _sexStr = _sexsArr[row];
        if ([_sexStr isEqualToString:MAN]) {
            _accountInfo.sexId = MAN_INDEX;
        } else {
            _accountInfo.sexId = WOMAN_INDEX;
        }
     
    }else if ([_screenTypeStr isEqualToString:@"年龄"]) {
        
        _ageStr = _agesArr[row];
    }else if ([_screenTypeStr isEqualToString:@"学历"]) {
        
        _educationStr = _higtestEduArr[row];
        _accountInfo.higtestEdu = [_higtestEduIdArr[row] integerValue];
    }else if ([_screenTypeStr isEqualToString:@"城市"]) {
        
        if (component == 0) {
            NSString *seletedProvince = [_provincesArr objectAtIndex:row];
            //        _provinceIdStr = [NSString stringWithFormat:@"%ld",row];
            _accountInfo.registedPlacePro = [_provinceIdArr[row] integerValue];
            _cityArr = [[_cityDics objectForKey:_provinceIdArr[row]] allValues];
            NSInteger selectedCityIndex = [self.pickerView selectedRowInComponent:1];
            NSString *seletedCity = @"";
            if (_cityArr.count) {
                
                [_citysArr removeAllObjects];
                [_cityIdArr removeAllObjects];
                for (AccountItem *cityItem in _cityArr) {
                    [_citysArr addObject:cityItem.name];
                    [_cityIdArr addObject:cityItem.rowId];
                }
                [_pickerView reloadComponent:1];
                if (selectedCityIndex > _citysArr.count) {
                    
                    seletedCity = [_citysArr objectAtIndex:_citysArr.count -1];
                     _accountInfo.registedPlaceCity = [_cityIdArr[_citysArr.count -1] integerValue];
                }else{
                  seletedCity = [_citysArr objectAtIndex:selectedCityIndex];
                _accountInfo.registedPlaceCity = [_cityIdArr[selectedCityIndex] integerValue];
                }
            }
            
           _cityStr = [NSString stringWithFormat:@"%@,%@", seletedProvince,seletedCity];
            DLOG(@"%@",_cityStr);
            DLOG(@"_accountInfo.registedPlaceCit = %ld",(long)_accountInfo.registedPlaceCity);
            DLOG(@"_accountInfo.registedPlacePro = %ld",(long)_accountInfo.registedPlacePro);

        }
        else {
            NSInteger selectedProvinceIndex = [self.pickerView selectedRowInComponent:0];
            NSString *seletedProvince = [_provincesArr objectAtIndex:selectedProvinceIndex];
            NSString *seletedCity = @"";
            seletedCity = [_citysArr objectAtIndex:row];
            _cityStr = [NSString stringWithFormat:@"%@,%@", seletedProvince,seletedCity];
            DLOG(@"%@",_cityStr);
//            DLOG(@"%@",_skyCityArr);
            
            for (NSDictionary *dic in _skyCityArr) {
                if ([dic objectForKey:seletedCity]) {
                    NSString *cityIdStr = [dic objectForKey:seletedCity];
                    DLOG(@"cityIdStr = %@",cityIdStr);
                    DLOG(@"seletedCity = %@",seletedCity);
                    
                    //截取头2位取出是辖市区的特殊情况
                    if ([seletedCity isEqualToString:@"市辖区"]) {
                        NSString *sub1 = [[NSString stringWithFormat:@"%@",cityIdStr] substringToIndex:2];
                        NSString *sub2 = [[NSString stringWithFormat:@"%ld",(long)_accountInfo.registedPlacePro] substringToIndex:2];
                        if ([sub1 isEqualToString:sub2]) {
                            _accountInfo.registedPlaceCity = [cityIdStr integerValue];
                            
                        }
                        
                    }else if ([seletedCity isEqualToString:@"县"]) {
                        NSString *sub1 = [[NSString stringWithFormat:@"%@",cityIdStr] substringToIndex:2];
                        //                        NSString *sub2 = [seletedProvince substringToIndex:2];
                        NSString *sub2 = [[NSString stringWithFormat:@"%ld",(long)_accountInfo.registedPlacePro] substringToIndex:2];
                        
                        if ([sub1 isEqualToString:sub2]) {
                            _accountInfo.registedPlaceCity = [cityIdStr integerValue];
                            
                        }
                        
                    }else
                    {
                        _accountInfo.registedPlaceCity = [cityIdStr integerValue];
                        
                    }
                }
                
            }
            DLOG(@"_accountInfo.registedPlaceCit = %ld",(long)_accountInfo.registedPlaceCity);
            DLOG(@"_accountInfo.registedPlacePro = %ld",(long)_accountInfo.registedPlacePro);

        }

        
    }else if ([_screenTypeStr isEqualToString:@"婚姻"]) {
        
        _marriageStr = _marriagesArr[row];
        _accountInfo.maritalStatus = [_marriagesIdArr[row] integerValue];
//        [_detailArr  replaceObjectAtIndex:6 withObject:_marriageStr];

    }else if ([_screenTypeStr isEqualToString:@"购车"]) {
        
        _carStr = _carsArr[row];
        _accountInfo.carStatus = [_carsIdArr[row] integerValue];
//        [_detailArr  replaceObjectAtIndex:7 withObject:_carStr];
        
    }else if ([_screenTypeStr isEqualToString:@"购房"]) {
        
        _houseStr = _housesArr[row];
        _accountInfo.housrseStatus = [_housesIdArr[row] integerValue];
    }

}


#pragma mark - UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *settingcell = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingcell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:settingcell];
    }
    
    [cell setSeparatorInset:UIEdgeInsetsZero];
    if (_detailArr.count) {
         cell.detailTextLabel.hidden = NO;
        cell.detailTextLabel.text = _detailArr[indexPath.row];
    }
    if(indexPath.row == 0 && [cell.detailTextLabel.text isEqualToString:@"未设置"]){
        cell.detailTextLabel.hidden = YES;
        [cell.contentView addSubview:_nameField];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if(indexPath.row == 3 && [cell.detailTextLabel.text isEqualToString:@"未设置"]){
        cell.detailTextLabel.hidden = YES;
        [cell.contentView addSubview:_cardField];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = _titleArr[indexPath.row];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLOG(@"name - %@", _titleArr[indexPath.row]);
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //收回键盘
    [_nameField resignFirstResponder];
    [_cardField resignFirstResponder];
    
     NSInteger selectedIndex1 = [self.pickerView selectedRowInComponent:0];
    switch (indexPath.row) {
        case 1:
              {
                 _screenTypeStr = @"性别";
                  if (selectedIndex1 > _sexsArr.count-1) {
                      _sexStr = _sexsArr[1];
                  }else
                    _sexStr = _sexsArr[0];
                  
                  if ([_sexStr isEqualToString:MAN]) {
                      _accountInfo.sexId = MAN_INDEX;
                  } else {
                      _accountInfo.sexId = WOMAN_INDEX;
                  }
            
             }
            break;
        case 2:
            {
                _screenTypeStr = @"年龄";
                if (selectedIndex1 > _agesArr.count-1) {
                     _ageStr = _agesArr[_agesArr.count-1];
                }else
                  _ageStr = _agesArr[selectedIndex1];
            }
            break;
        case 4:
            {
                _screenTypeStr = @"学历";
                NSString *eduIdStr;
                if (selectedIndex1 > _higtestEduArr.count-1) {
                    _educationStr = _higtestEduArr[_higtestEduArr.count-1];
                    eduIdStr = _higtestEduIdArr[_higtestEduArr.count-1];
                }else{
                    _educationStr = _higtestEduArr[selectedIndex1];
                    eduIdStr = _higtestEduIdArr[selectedIndex1];
                }
                _accountInfo.higtestEdu = [eduIdStr integerValue];
            }
            break;
        case 5:
            {
                _screenTypeStr = @"城市";
//                NSInteger selectedIndex2 = [self.pickerView selectedRowInComponent:1];
                NSString *seletedProvince = [_provincesArr objectAtIndex:selectedIndex1];
                _accountInfo.registedPlacePro = [_provinceIdArr[selectedIndex1] integerValue];
                _cityArr = [[_cityDics objectForKey:_provinceIdArr[selectedIndex1]] allValues];
                NSString *seletedCity = @"";
                if (_cityArr.count) {
                    
                    [_citysArr removeAllObjects];
                    [_cityIdArr removeAllObjects];
                    for (AccountItem *cityItem in _cityArr) {
                        [_citysArr addObject:cityItem.name];
                        [_cityIdArr addObject:cityItem.rowId];
                    }

                    seletedCity = [_citysArr objectAtIndex:0];
                    _accountInfo.registedPlaceCity = [_cityIdArr[0] integerValue];
                }
                
                _cityStr = [NSString stringWithFormat:@"%@,%@", seletedProvince,seletedCity];
            }
            break;
        case 6:
            {
                _screenTypeStr = @"婚姻";
                NSString *marrIdStr;
                if (selectedIndex1 > _marriagesArr.count-1) {
                    _marriageStr = _marriagesArr[_marriagesArr.count-1];
                    marrIdStr = _marriagesIdArr[_marriagesArr.count-1];
                }else{
                    _marriageStr = _marriagesArr[selectedIndex1];
                     marrIdStr = _marriagesIdArr[selectedIndex1];
                }
                _accountInfo.maritalStatus = [marrIdStr integerValue];
            }
            break;
        case 7:
            {
                _screenTypeStr = @"购车";
                NSString *carIdStr;
                if (selectedIndex1 > _carsArr.count-1) {
                    _carStr = _carsArr[_carsArr.count-1];
                    carIdStr = _carsIdArr[_carsArr.count-1];
                }else{
                    _carStr = _carsArr[selectedIndex1];
                     carIdStr = _carsIdArr[selectedIndex1];
                }
                _accountInfo.carStatus = [carIdStr integerValue];
            }
            break;
        case 8:
            {
                _screenTypeStr = @"购房";
                NSString *houIdStr;
                if (selectedIndex1 > _housesArr.count-1) {
                    _houseStr = _housesArr[_housesArr.count-1];
                    houIdStr = _housesIdArr[_housesArr.count-1];
                }else{
                    _houseStr = _housesArr[selectedIndex1];
                    houIdStr = _housesIdArr[selectedIndex1];
                }
                _accountInfo.housrseStatus = [houIdStr integerValue];
            }
            break;
        default:{
              _screenTypeStr = @"无用";
          }
            break;
    }
   
    if (indexPath.row != 0 && indexPath.row != 3) {
        [self.pickerView reloadAllComponents];
        [UIView animateWithDuration:0.5 animations:^{
            _provinceBackView.frame = CGRectMake(0, MSHIGHT - 200, MSWIDTH, 200);
        } completion:nil];
    }
}

#pragma mark --
#pragma 推广点击触发方法
-(void)cpsClick
{
    TwoCodeViewController *cpsView = [[TwoCodeViewController alloc] init];
    cpsView.backTypeNum = 1;
    [self.navigationController pushViewController:cpsView animated:YES];
}


#pragma mark --
#pragma 银行卡点击触发方法
-(void)cardClick
{
        BankCardManageViewController *bankView = [[BankCardManageViewController alloc] init];
        bankView.backTypeNum = 1;
        [self.navigationController pushViewController:bankView animated:YES];

}

#pragma mark --
#pragma 头像点击触发方法
-(void)intoSafeClick
{

    AccuontSafeViewController *accountSafeView = [[AccuontSafeViewController alloc] init];
    accountSafeView.backTypeNum = 1;
    [self.navigationController pushViewController:accountSafeView animated:YES];


}

#pragma mark --
#pragma 头像点击触发方法
-(void)changeIcon
{


    DLOG(@"上传图片按钮");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"设置头像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [actionSheet addButtonWithTitle:@"拍照"];
    [actionSheet addButtonWithTitle:@"我的相册"];
    [actionSheet addButtonWithTitle:@"取消"];
    actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons - 1;
    [actionSheet showInView:self.view];

}

#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.editing = YES;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    
    if (buttonIndex == 0)//照相机
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }
        else{
            
            [SVProgressHUD showErrorWithStatus:@"该设备没有摄像头"];
            
        }
    }
    if (buttonIndex == 1)
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    if (buttonIndex == 2)
    {
        
    }
}

#pragma mark
#pragma mark - UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(saveImage:) withObject:image afterDelay:0.5];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

- (void)saveImage:(UIImage *)image
{
    [_headerBtn setImage:image forState:UIControlStateNormal];
    _hearImg = image;
    
    
    if (_hearImg!= nil) {
        
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"userId"];
        [parameters setObject:@"1" forKey:@"type"];
        
        // 1. Create `AFHTTPRequestSerializer` which will create your request.
        AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
        
        
        NSData *imageData = UIImageJPEGRepresentation(_hearImg, 0.5);
        
        //    NSString *restUrl = [ShoveGeneralRestGateway buildUrl:@"/app/services" key:MD5key parameters:parameters];
        //
        //    DLOG(@">>>>>>>>>URL>>>>>>%@<<<<<<<", [NSString stringWithFormat:@"%@%@", Baseurl, restUrl]);
        
        
        // 2. Create an `NSMutableURLRequest`.
        
        NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@",Baseurl,@"/app/uploadUserPhoto"]
                                                                       parameters:parameters
                                                        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                            
                                                            
                                                            //上传时使用当前的系统事件作为文件名
                                                            
                                                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                                            
                                                            formatter.dateFormat = @"yyyyMMddHHmmss";
                                                            
                                                            NSString *str = [formatter stringFromDate:[NSDate date]];
                                                            
                                                            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
                                                            //
                                                            
                                                            
                                                            [formData appendPartWithFileData:imageData
                                                                                        name:@"imgFile"
                                                                                    fileName:fileName
                                                                                    mimeType:@"image/jpeg"];
                                                        } error:nil];
        
        // 3. Create and use `AFHTTPRequestOperationManager` to create an `AFHTTPRequestOperation` from the `NSMutableURLRequest` that we just created.
        DLOG(@">>>>>>>>request>>>>>>%@<<<<<<<", request);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        AFHTTPRequestOperation *operation =
        [manager HTTPRequestOperationWithRequest:request
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             DLOG(@"Success >>>>>>>>>>>>>>>>>%@", responseObject);
                                             NSDictionary *dic = (NSDictionary *)responseObject;
                                             if([[dic objectForKey:@"error"] integerValue] == -1)
                                             {
                                                 [SVProgressHUD showSuccessWithStatus:[dic objectForKey:@"msg"]];
                                                 if ([[dic objectForKey:@"filename"] hasPrefix:@"http"]) {
                                                     AppDelegateInstance.userInfo.userImg =[NSString stringWithFormat:@"%@",[dic objectForKey:@"filename"]] ;
                                                     [[AppDefaultUtil sharedInstance] setDefaultHeaderImageUrl:[NSString stringWithFormat:@"%@", [dic objectForKey:@"filename"]]];
                                                 }else
                                                 {
                                                     
                                                     AppDelegateInstance.userInfo.userImg =[NSString stringWithFormat:@"%@%@", Baseurl, [dic objectForKey:@"filename"]] ;
                                                     [[AppDefaultUtil sharedInstance] setDefaultHeaderImageUrl:[NSString stringWithFormat:@"%@%@", Baseurl, [dic objectForKey:@"filename"]]];
                                                 }
                                                 
                                                 
                                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
                                                     
                                                     
                                                     [self dismissViewControllerAnimated:YES completion:^(){}];
                                                     
                                                 });
                                                 
                                             }else{
                                                 
                                                 
//                                                 [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
                                                 
                                                 
                                             }
                                             
                                             
                                             [[NSNotificationCenter defaultCenter]  postNotificationName:@"update" object:nil];
                                             
                                             
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             DLOG(@"Failure >>>>>>>>>>>>>>>>>%@", error.description);
                                         }];
        
        // 4. Set the progress block of the operation.
        [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                            long long totalBytesWritten,
                                            long long totalBytesExpectedToWrite) {
            DLOG(@"Wrote >>>>>>>>>>>>>>>>>%lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
        }];
        
        // 5. Begin!
        [operation start];
        DLOG(@">>>>>>>>>>>>>>>END<<<<<<<<<<<<<<<<<");
        
    }

}

-(void) setValue
{
    [self setEnable:!_accountInfo.realName];
    
    if (_accountInfo.realName != nil && ![_accountInfo.realName isEqual:[NSNull null]]) {
        _nameStr = _accountInfo.realName;
        _nameField.text = _accountInfo.realName;
    }else
        _nameStr = @"未设置";
    
    if(_accountInfo.age != 0){
        _ageStr = [NSString stringWithFormat:@"%ld",_accountInfo.age];
    }else
        _ageStr = @"未设置";
    
    
    if (_accountInfo.idNo != nil && ![_accountInfo.idNo isEqual:[NSNull null]]) {
        _cardIdStr = [NSString stringWithFormat:@"%@*****%@",[_accountInfo.idNo substringWithRange:NSMakeRange(0, 6)],[_accountInfo.idNo substringWithRange:NSMakeRange(_accountInfo.idNo.length-4, 4)]];
        _cardField.text = _accountInfo.idNo;
    }else
        _cardIdStr = @"未设置";
    
    if (_accountInfo.sex != nil && ![_accountInfo.sex isEqual:[NSNull null]]) {
        _sexStr = _accountInfo.sex;
    }else
        _sexStr = @"未设置";
    
    AccountItem *education = [_educationDics objectForKey:INT_TO_STRING(_accountInfo.higtestEdu)];
    if (education) {
        _educationStr = education.name;
    }else
        _educationStr = @"未设置";
    
    _educationArr = [_educationDics allValues];


    AccountItem *province = [_provinceDics objectForKey:INT_TO_STRING(_accountInfo.registedPlacePro)];
 
    _provinceArr = [_provinceDics allValues];
  
    
    AccountItem *city = [_cityInitDics objectForKey:INT_TO_STRING(_accountInfo.registedPlaceCity)];
  
    if (province && city){
     
        _cityStr = [NSString stringWithFormat:@"%@,%@",province.name,city.name];
    
    }else
        _cityStr = @"未设置";
        
        
//    _cityArr = [[_cityDics objectForKey:INT_TO_STRING(_accountInfo.registedPlacePro)] allValues];
    
    _cityArr = [[_cityDics objectForKey:@"110000"] allValues];
    for (AccountItem *cityObj in _cityArr) {
        [_citysArr addObject:cityObj.name];
        [_cityIdArr addObject:cityObj.rowId];
    }
    
    AccountItem *marital = [_marriageDics objectForKey:INT_TO_STRING(_accountInfo.maritalStatus)];
    if (marital) {
        _marriageStr = marital.name;
    }else
        _marriageStr = @"未设置";
    
    _marriageArr = [_marriageDics allValues];
    
    AccountItem *car = [_carDics objectForKey:INT_TO_STRING(_accountInfo.carStatus)];
    if (car) {
        _carStr = car.name;
    }else
        _carStr = @"未设置";
    
    _carArr = [_carDics allValues];
  
    
    AccountItem *house = [_houseDics objectForKey:INT_TO_STRING(_accountInfo.housrseStatus)];
    if (house) {
        _houseStr = house.name;
    }else
        _houseStr = @"未设置";
    
    _houseArr = [_houseDics allValues];

    
    [_pickerView reloadAllComponents];
    [_detailArr addObject:_nameStr];
    [_detailArr addObject:_sexStr];
    [_detailArr addObject:_ageStr];
    [_detailArr addObject:_cardIdStr];
    [_detailArr addObject:_educationStr];
    [_detailArr addObject:_cityStr];
    [_detailArr addObject:_marriageStr];
    [_detailArr addObject:_carStr];
    [_detailArr addObject:_houseStr];
    [_accountTableView reloadData];
    
}

-(void) setEnable:(BOOL) isEnable
{

    
    _PhoneField1.enabled = !isPhone;
    _PhoneField1.hidden = isPhone;
    _verifyBtn1.enabled = !isPhone;
    _verifyBtn1.hidden = isPhone;
    _numField1.enabled = !isPhone;
    _numField1.hidden = isPhone;
    _numLabel.enabled = !isPhone;
    _numLabel.hidden = isPhone;
    _starLabel.enabled = !isPhone;
    _starLabel.hidden = isPhone;
    _mailField.enabled = !isMail;

    
    if (isNum) {
    
        _nameField.enabled = isEnable;
        _cardField.enabled = isEnable;
        
        NSLog(@"完善资料。");
    }else {
  
        
        _nameField.enabled = !isEnable;
        _cardField.enabled = !isEnable;
        
        NSLog(@"修改资料。");
    }
    
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"资料";
    
    // 导航条保存按钮
    _saveItem=[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(submitAccountInfo)];
    _saveItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:_saveItem];
    
}

#pragma mark 验证码按钮触发方法
- (void)verifyClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 1003:
            _requestType = 1;
            [self submitAccountInfo];
            break;
    }
}

#pragma mark 点击空白处收回键盘
- (void)controlAction
{
    [_nameField resignFirstResponder];
    [_cardField resignFirstResponder];

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
        default:
            break;
    }
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}


//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32  - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

#pragma 返回按钮触发方法
- (void)backClick
{
    TabViewController *tabViewController = [TabViewController shareTableView];
    [self.frostedViewController presentMenuViewController];
    self.frostedViewController.contentViewController = tabViewController;
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
        [ReLogin outTheTimeRelogin:self];
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
            }else
                _accountInfo.sexId = 0;
            
            _accountInfo.carStatus = [[dics objectForKey:@"CarStatus"] intValue];// int
            _accountInfo.age = [[dics objectForKey:@"age"] intValue];// int
            
            NSArray *provinceArr = [dics objectForKey:@"provinceList"];
            for (NSDictionary *item in provinceArr) {
                AccountItem *bean = [[AccountItem alloc] init];
                bean.rowId = [NSString stringWithFormat:@"%@",[item objectForKey:@"id"]];
                bean.name = [item objectForKey:@"name"];
                [_provinceDics setValue:bean forKey:bean.rowId];
                [_provincesArr addObject:bean.name];
                [_provinceIdArr addObject:bean.rowId];
            }
            
            NSArray *cityArr = [dics objectForKey:@"cityList"];
            for (NSDictionary *item in cityArr) {
                AccountItem *bean = [[AccountItem alloc] init];
                bean.rowId = [NSString stringWithFormat:@"%@",[item objectForKey:@"id"]];
                bean.provinceId = [NSString stringWithFormat:@"%@",[item objectForKey:@"province_id"]];
                bean.name = [item objectForKey:@"name"];
                
                NSMutableDictionary *skyCityDic = [[NSMutableDictionary alloc] init];
                [skyCityDic setValue:[item objectForKey:@"id"]  forKey:[item objectForKey:@"name"]];
                
                [_skyCityArr addObject:skyCityDic];
                
                NSMutableDictionary *dics = [_cityDics objectForKey:bean.provinceId];
                if (dics == nil) {
                    dics = [[NSMutableDictionary alloc] init];
                }
                
                [dics setObject:bean forKey:bean.rowId];
                [_cityDics setValue:dics forKey:bean.provinceId];
                
                [_cityInitDics setValue:bean forKey:bean.rowId];
            }
            
            NSArray *housesArr = [dics objectForKey:@"housesList"];
            for (NSDictionary *item in housesArr) {
                AccountItem *bean = [[AccountItem alloc] init];
                bean.rowId = [NSString stringWithFormat:@"%@",[item objectForKey:@"id"]];
                bean.name = [item objectForKey:@"name"];
                [_houseDics setValue:bean forKey:bean.rowId];
                [_housesArr addObject:bean.name];
                [_housesIdArr addObject:bean.rowId];
                
            }
        
            
            NSArray *carArr = [dics objectForKey:@"carList"];
            for (NSDictionary *item in carArr) {
                AccountItem *bean = [[AccountItem alloc] init];
                bean.rowId = [NSString stringWithFormat:@"%@",[item objectForKey:@"id"]];
                bean.name = [item objectForKey:@"name"];
                [_carDics setValue:bean forKey:bean.rowId];
                [_carsArr addObject:bean.name];
                [_carsIdArr addObject:bean.rowId];
            }
            
            NSArray *maritalsArr = [dics objectForKey:@"maritalsList"];
            for (NSDictionary *item in maritalsArr) {
                AccountItem *bean = [[AccountItem alloc] init];
                bean.rowId = [NSString stringWithFormat:@"%@",[item objectForKey:@"id"]];
                bean.name = [item objectForKey:@"name"];
                [_marriageDics setValue:bean forKey:bean.rowId];
                [_marriagesArr addObject:bean.name];
                [_marriagesIdArr addObject:bean.rowId];
            }
            
            NSArray *educationsArr = [dics objectForKey:@"educationsList"];
            for (NSDictionary *item in educationsArr) {
                AccountItem *bean = [[AccountItem alloc] init];
                bean.rowId = [NSString stringWithFormat:@"%@",[item objectForKey:@"id"]];
                bean.name = [item objectForKey:@"name"];
                [_educationDics setValue:bean forKey:bean.rowId];
                [_higtestEduArr addObject:bean.name];
                [_higtestEduIdArr addObject:bean.rowId];
            }
            
            NSLog(@"手机号码：%@ - %@", [dics objectForKey:@"cellPhone1"], _accountInfo.cellPhone1);
            if (_accountInfo.cellPhone1 != nil && ![_accountInfo.cellPhone1 isEqual:[NSNull null]]) {
                
                isPhone = YES;

                
            }
            
            if (_accountInfo.idNo != nil && ![_accountInfo.idNo isEqual:[NSNull null]]) {
            
                
            }
            
            if (_accountInfo.email != nil && ![_accountInfo.email isEqual:[NSNull null]]) {
                
                isMail = YES;
                
            }
            
            if (![[dics objectForKey:@"realName"] isEqual:[NSNull null]]) {
                isNum = YES;
            }else {
                isNum = NO;
            }
            [self setValue];
            
        }else if(_requestType == 1){
            
            [self setEnable:NO];
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
//            TabViewController *tabViewController = [TabViewController shareTableView];
//            [self.frostedViewController presentMenuViewController];
//            self.frostedViewController.contentViewController = tabViewController;
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if(_requestType == 2){
            
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
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
    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}


#pragma mark  保存用户信息
-(void) submitAccountInfo
{

    
    if (AppDelegateInstance.userInfo == nil) {
        [ReLogin outTheTimeRelogin:self];
        return;
    }
    if (_nameField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入真实姓名!"];
        return;
    }
    if (_accountInfo.sexId == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择性别!"];
        return;
    }
    if ([_ageStr isEqualToString:@"未设置"]) {
        [SVProgressHUD showErrorWithStatus:@"请设置年龄!"];
        return;
    }
    if (_cardField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入身份证号码!"];
        return;
    }
    
    if (_accountInfo.higtestEdu == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择学历!"];
        return;
    }
    if ([_cityStr isEqualToString:@"未设置"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择户口所在地"];
        return;
    }
    if (_accountInfo.maritalStatus == 0) {
        [SVProgressHUD showErrorWithStatus:@"请设置婚姻情况!"];
        return;
    }
    if (_accountInfo.carStatus == 0) {
        [SVProgressHUD showErrorWithStatus:@"请设置购车情况!"];
        return;
    }
    if (_accountInfo.housrseStatus == 0) {
        [SVProgressHUD showErrorWithStatus:@"请设置购房情况!"];
        return;
    }
   
  
    _requestType = 1;
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
    [parameters setObject:@"" forKey:@"cellPhone1"];
    [parameters setObject:@"" forKey:@"randomCode1"];
    [parameters setObject:_ageStr forKey:@"age"];
    [parameters setObject:@"" forKey:@"email"];
    
    
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
