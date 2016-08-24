//
//  RepaymentViewController.m
//  SP2P_6.1
//
//  Created by kiu on 14/12/2.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  财富工具箱 -> 还款计算器

#import "RepaymentViewController.h"

#import "QCheckBox.h"
#import "ColorTools.h"
#import "AJComboBox.h"
#import "RepaymentcalculatorCell.h"
#import "RepaymentcalculatorMode.h"
#import "Repaymentcalculator.h"

#define fontSize  14.0f  //字体大小
#define NUMBERS @"0123456789.\n"

@interface RepaymentViewController ()<UIScrollViewDelegate, UITextFieldDelegate, AJComboBoxDelegate, HTTPClientDelegate, UITableViewDelegate, UITableViewDataSource>
{
    
    NSArray *titleArr1;
    NSArray *titleArr2;
    NSArray *titleArr3;
    NSArray *titleArr4;
    NSArray *pickerData;
    NSArray *wayArr;
    
    NSMutableArray *collectionArrays;
}

@property (nonatomic, strong)UITableView *listView;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)UIView *middleView;
@property (nonatomic, strong)UIView *downView;
@property (nonatomic, strong)QCheckBox *check;
@property (nonatomic, strong)AJComboBox *wayComboBox;
@property (nonatomic, strong)Repaymentcalculator *repaymentCal;

@property(nonatomic ,strong)NetWorkClient *requestClient;

@property (nonatomic, strong)UILabel *titlelabel22;

@end

@implementation RepaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
    
    if ([_listView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_listView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([_listView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [_listView setLayoutMargins:UIEdgeInsetsZero];
        
    }
}

/**
 * 初始化数据
 */
- (void)initData
{
    titleArr1 = @[@"借款金额",@"年利率",@"借款期限",@"还款方式"];
    titleArr2 = @[@"元", @"%",@"月"];
    titleArr3 = @[@"借款总额   |  ", @"月利率   |  ", @"月还本息   |  ", @"还款本息总额   |  "];
    titleArr4 = @[@"期数",@"1",@"2",@"3"];
    pickerData = @[@"等额本息", @"等额本息2", @"等额本息3"];
    wayArr = @[@"等额本息",@"先息后本",@"一次性还款"];
    
    collectionArrays =[[NSMutableArray alloc] init];
}


/**
 初始化数据
 */
- (void)initView
{
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //滚动视图
    _scrollView =[[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = KblackgroundColor;
    [self.view addSubview:_scrollView];
    
    // 上面白背景
    _topView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, MSWIDTH-20, 225)];
    _topView.backgroundColor = [UIColor whiteColor];
    [_topView.layer setMasksToBounds:YES];
    [_topView.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [_scrollView addSubview:_topView];
    
    // 监听屏幕，释放键盘
    UIControl *viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [viewControl addTarget:self action:@selector(controlAction) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:viewControl];
    
    // 中间白背景
    _middleView = [[UIView alloc] initWithFrame:CGRectMake(10, 245, MSWIDTH-20, 210)];
    _middleView.backgroundColor = [UIColor whiteColor];
    [_middleView.layer setMasksToBounds:YES];
    [_middleView.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [_scrollView addSubview:_middleView];
    
    UIButton *calculateBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [calculateBtn setFrame:CGRectMake(65, _topView.frame.size.height - 40, 80, 25)];
    [calculateBtn setTitle:@"计算" forState:UIControlStateNormal];
    [calculateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [calculateBtn.layer setCornerRadius:3.0f];
    calculateBtn.backgroundColor = GreenColor;
    [calculateBtn addTarget:self action:@selector(calculateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:calculateBtn];
    
    //单选按钮
    _check = [[QCheckBox alloc] initWithDelegate:self];
    _check.frame = CGRectMake(185, _topView.frame.size.height - 40, 100, 25);
    [_check setImage:[UIImage imageNamed:@"checkbox3_unchecked.png"] forState:UIControlStateNormal];
    [_check setImage:[UIImage imageNamed:@"checkbox3_checked.png"] forState:UIControlStateSelected];
    [_check setTitle:@"天标" forState:UIControlStateNormal];
    [_check setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_check.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [_topView addSubview:_check];
    
    for (int i = 0; i <= 3; i++) {
        //  ---------------------------------  第二表格  ---------------------------------
        //第一个个表格第一字段
        UILabel *titlelabel11 = [[UILabel alloc] initWithFrame:CGRectMake(30, 20 + i * 40, 70, 30)];
        titlelabel11.text = [titleArr1 objectAtIndex:i];
        titlelabel11.textAlignment = NSTextAlignmentRight;
        titlelabel11.font = [UIFont systemFontOfSize:fontSize];
        [_topView addSubview:titlelabel11];
        
        //第一表格输入文本框
        UITextField  *textField = [[UITextField alloc] initWithFrame:CGRectMake(_topView.frame.size.width*0.5 - 45, 18 + i * 40, 140, 35)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        
        if (i==0) {
            textField.placeholder = @"请输入借款金额";
        }else if(i==1){
            textField.placeholder = @"请输入年利率";
        }else if(i == 2) {
            textField.placeholder = @"请输入借款期限";
        }
        textField.font = [UIFont systemFontOfSize:13.0f];
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        [textField setTag:80+i];
        [_topView addSubview:textField];
        if (i==3) {
            [textField removeFromSuperview];
        }
        
        //第一表格第二字段
        UILabel *titlelabel12 = [[UILabel alloc] initWithFrame:CGRectMake(250, 20 + i * 40, 15, 30)];
        if (i != 3) {
            titlelabel12.text = [titleArr2 objectAtIndex:i];
        }else{
            titlelabel12.text = nil;
        }
        titlelabel12.font = [UIFont systemFontOfSize:fontSize];
        [_topView addSubview:titlelabel12];
        
        //  -----------------------------------------------------------------------------
        
        //  ---------------------------------  第二表格  ---------------------------------
        //第一字段
        UILabel *titlelabel21 = [[UILabel alloc] initWithFrame:CGRectMake(35, 55 + i * 40, 100, 30)];
        titlelabel21.text = [titleArr3 objectAtIndex:i];
        titlelabel21.textAlignment = NSTextAlignmentRight;
        titlelabel21.font = [UIFont systemFontOfSize:fontSize];
        [_middleView addSubview:titlelabel21];
        
        //第二表格显示数据字段
        _titlelabel22 = [[UILabel alloc] initWithFrame:CGRectMake(150, 55 + i * 40, 100, 30)];
        //_titlelabel22.text = @"暂无数据";
        [_titlelabel22 setTag:100 + i];
        _titlelabel22.font = [UIFont systemFontOfSize:fontSize];
        [_middleView addSubview:_titlelabel22];
        
        //第二表格第三个字段
        UILabel *titlelabel23 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.5 + 70, 55 + i * 40, 30, 30)];
        if (i==1) {
            titlelabel23.text = [titleArr2 objectAtIndex:1];
        }else {
            titlelabel23.text = [titleArr2 objectAtIndex:0];
        }
        
        titlelabel23.font = [UIFont systemFontOfSize:fontSize];
        titlelabel23.backgroundColor = [UIColor clearColor];
        [_middleView addSubview:titlelabel23];
        //  -----------------------------------------------------------------------------
        
    }
    
    //  ----------------    还款明细  start   ---------------
    // 底下白背景
    _downView = [[UIView alloc] initWithFrame:CGRectZero];
    _downView.backgroundColor = [UIColor whiteColor];
    [_downView.layer setMasksToBounds:YES];
    [_downView.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [_scrollView addSubview:_downView];
    
    // 期数
    UILabel *titlelabel31 = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 40, 30)];
    titlelabel31.text = @"期数";
    titlelabel31.textAlignment = NSTextAlignmentCenter;
    titlelabel31.font = [UIFont systemFontOfSize:fontSize];
    [_downView addSubview:titlelabel31];
    
    // 月还本息
    UILabel *titlelabel32 = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, (MSWIDTH-80)/2, 30)];
    titlelabel32.text = @"月还本息";
    titlelabel32.textAlignment = NSTextAlignmentCenter;
    titlelabel32.font = [UIFont systemFontOfSize:fontSize];
    [_downView addSubview:titlelabel32];
    
    // 本息余额
    UILabel  *titlelabel33 = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH-CGRectGetWidth(titlelabel32.frame), 50, CGRectGetWidth(titlelabel32.frame), 30)];
    titlelabel33.text = @"本息余额";
    titlelabel33.textAlignment = NSTextAlignmentCenter;
    titlelabel33.font = [UIFont systemFontOfSize:fontSize];
    [_downView addSubview:titlelabel33];
    
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 40, 30)];
    title1.text = @"1";
    title1.textAlignment = NSTextAlignmentCenter;
    title1.font = [UIFont systemFontOfSize:fontSize];
    [_downView addSubview:title1];
    
    _downView.frame = CGRectMake(10, 465, MSWIDTH-20, 135);
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _downView.frame.origin.y + _downView.frame.size.height + 10);
    
    _listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _listView.frame = CGRectMake(0, 85, _downView.frame.size.width, 240);
    _listView.delegate = self;
    _listView.dataSource = self;
    [_listView setBackgroundColor:[UIColor whiteColor]];
    
    [_downView addSubview:_listView];
    
    //第一和第二的标题文本
    for (int j = 0; j <= 1; j++) {
        UILabel *heardlabel =[[UILabel alloc] init];
        
        if (j==0) {
            [heardlabel setFrame:CGRectMake(20, 260, MSWIDTH-40, 30)];
            heardlabel.text = @"计算结果";
        }else {
            [heardlabel setFrame:CGRectMake(20, 475, MSWIDTH-40, 30)];
            heardlabel.text = @"还款明细";
        }
        
        heardlabel.textAlignment = NSTextAlignmentCenter;
        [heardlabel.layer setMasksToBounds:YES];
        [heardlabel.layer setCornerRadius:5.0f];
        heardlabel.font = [UIFont boldSystemFontOfSize:fontSize];
        heardlabel.backgroundColor = SETCOLOR(230, 230, 230, 1);
        [_scrollView addSubview:heardlabel];
    }
    
    //还款方式选择框
    _wayComboBox = [[AJComboBox alloc] initWithFrame:CGRectMake(_topView.frame.size.width*0.5 - 45, 143, 140, 25)];
    [_wayComboBox setLabelText:@"- 请选择 -"];
    [_wayComboBox setArrayData:wayArr];
    //[_wayComboBox setDelegate:self];
    [_wayComboBox setTag:123];
    [_topView addSubview:_wayComboBox];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"还款计算器";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

#pragma mark 返回按钮
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UITableView 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return collectionArrays.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *settingcell = @"settingCell";
    
    RepaymentcalculatorCell *cell = [tableView dequeueReusableCellWithIdentifier:settingcell];
    
    if (cell == nil) {
        cell = [[RepaymentcalculatorCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:settingcell];
    }
    
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
    RepaymentcalculatorMode *aboutus = collectionArrays[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    aboutus.num = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    [cell fillCellWithObject:aboutus];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

#pragma 计算按钮点击触发方法
- (void)calculateBtnClick:(UIButton *)btn
{
    [self controlAction];
    
    //通过tag获取控件对象
    UITextField *textfield1 = (UITextField *)[_topView viewWithTag:80];
    UITextField *textfield2 = (UITextField *)[_topView viewWithTag:81];
    UITextField *textfield3 = (UITextField *)[_topView viewWithTag:82];
    
    //判断输入框输入状态
    if ([textfield1.text length]==0||[textfield2.text length]==0||[textfield3.text length]==0)
    {
        
        [SVProgressHUD showErrorWithStatus:@"请输入完整信息后再进行计算"];
        
    }else {
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        //还款计算器接口
        [parameters setObject:@"9" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:textfield1.text forKey:@"borrowSum"];
        [parameters setObject:textfield2.text forKey:@"yearRate"];
        [parameters setObject:textfield3.text forKey:@"borrowTime"];
        [parameters setObject:[NSString stringWithFormat:@"%ld",_wayComboBox.selectedIndex+1] forKey:@"repayWay"];
        [parameters setObject:[NSString stringWithFormat:@"%d",_check.checked] forKey:@"isDay"];
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
            
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
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
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        [collectionArrays removeAllObjects];
        
        DLOG(@"dic is %@",dics);
        
        _repaymentCal = [[Repaymentcalculator alloc] init];
        _repaymentCal.monPay = [[dics objectForKey:@"monPay"] floatValue];
        _repaymentCal.monRate = [[dics objectForKey:@"monRate"] floatValue];
        _repaymentCal.allPay = [[dics objectForKey:@"allPay"] floatValue];
        
        NSArray *dataArr = [dics objectForKey:@"list"];
        for (NSDictionary *item in dataArr) {
            RepaymentcalculatorMode *repayMode = [[RepaymentcalculatorMode alloc] init];
            
            repayMode.monPay =  [NSString stringWithFormat:@"%.2f", [[item objectForKey:@"monPay"] floatValue]];
            repayMode.stillPay = [NSString stringWithFormat:@"%.2f", [[item objectForKey:@"stillPay"] floatValue]];
            
            [collectionArrays addObject:repayMode];
        }
        
        [self setView];
        
    }else {
        
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
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"无可用网络"]];
}

// 初始化模型数据
- (void)setView {
    UITextField *textfield1 = (UITextField *)[_topView viewWithTag:80];
    
    UILabel *amountlabel = (UILabel *)[_middleView viewWithTag:100];
    UILabel *ratelabel = (UILabel *)[_middleView viewWithTag:101];
    UILabel *monPaylabel = (UILabel *)[_middleView viewWithTag:102];
    UILabel *allPaylabel = (UILabel *)[_middleView viewWithTag:103];
    
    amountlabel.text = textfield1.text;
    ratelabel.text = [NSString stringWithFormat:@"%0.2f", _repaymentCal.monRate];
    monPaylabel.text =[NSString stringWithFormat:@"%0.2f", _repaymentCal.monPay];
    allPaylabel.text = [NSString stringWithFormat:@"%0.2f",_repaymentCal.allPay];
    
    if (_wayComboBox.selectedIndex == 2 || _check.selected) {
        _listView.frame = CGRectMake(0, 85, _downView.frame.size.width, 40);
    }else{
        _listView.frame = CGRectMake(0, 85, _downView.frame.size.width, collectionArrays.count * 40);
    }
    
    _downView.frame = CGRectMake(10, 465, MSWIDTH-20, 85 + _listView.frame.size.height + 25);
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _downView.frame.origin.y + _downView.frame.size.height + 10);
    
    [_listView reloadData];
}

#pragma mark 点击空白处收回键盘
- (void)controlAction
{
    
    for (UITextField *textField in [_topView subviews])
    {
        if ([textField isKindOfClass: [UITextField class]]) {
            
            [textField  resignFirstResponder];
        }
        
    }
}

#pragma 单选框选中触发方法
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    DLOG(@"did tap on CheckBox:%@ checked:%d", checkbox.titleLabel.text, checked);
}

#pragma mark 单选框代理方法
-(void)didChangeComboBoxValue:(AJComboBox *)comboBox selectedIndex:(NSInteger)selectedIndex
{
    
    DLOG(@"selected is %ld",(long)selectedIndex);
}

#pragma 文本框协议代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
    
}

#pragma 限制只能输入数字和.
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    
    BOOL canChange = [string isEqualToString:filtered];
    
    return canChange;
}

#pragma mark - 
#pragma scrollView 代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    _wayComboBox.table.frame = CGRectMake(_wayComboBox.frame.origin.x + 10, _wayComboBox.frame.origin.y + 30 - scrollView.contentOffset.y, _wayComboBox.frame.size.width, [wayArr count] * 30);
    
}

#pragma 退出页面
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //    if (_requestClient != nil) {
    //        [_requestClient cancel];
    //    }
}

@end
