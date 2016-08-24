//
//  CreditScreenViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-7-15.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "CreditScreenViewController.h"

#import "ColorTools.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"
#import "QCheckBox.h"
#import "ScreenModel.h"

// 判断iPhone型号
#import "IsiPhoneDevice.h"

@interface CreditScreenViewController ()<UITableViewDataSource,UITableViewDelegate,SKSTableViewDelegate,HTTPClientDelegate>
{
    
    NSMutableArray *ScreenArr;
    NSMutableArray *screenDataArr;
    NSMutableArray *prodNameArr;
    NSMutableArray *prodIdArr;
    
}

@property (nonatomic,strong) NSArray *contents;
@property (nonatomic,strong)QCheckBox *check;
@property (nonatomic,strong)SKSTableView *tableView;
@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation CreditScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //请求数据
    [self requestData];
    
    // 初始化数据
    [self initData];

    
}

/**
 * 初始化数据
 */
- (void)initData
{
//    [self contents];
    ScreenArr = [[NSMutableArray alloc] init];
    screenDataArr = [[NSMutableArray alloc] init];
    prodIdArr = [[NSMutableArray alloc] init];
    prodNameArr = [[NSMutableArray alloc] init];
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
// 适配筛选视图的尺寸
    NSString *deviceString = [IsiPhoneDevice deviceString];
    
    if([deviceString isEqualToString:@"iPhone 6"]) {
        
        self.leftMargin += 20;
        
    }else if([deviceString isEqualToString:@"iPhone6 Plus"]) {
        
        self.leftMargin += 30;
        
    }

    
    //列表初始化
    _tableView = [[SKSTableView alloc] initWithFrame:CGRectMake(self.leftMargin, 64, MSWIDTH - self.leftMargin, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    self.tableView.SKSTableViewDelegate = self;
    [self.view addSubview:_tableView];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *savedEncodedData = [defaults objectForKey:@"ScreenList2"];
    if(savedEncodedData != nil)
    {
        
        ScreenArr = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:savedEncodedData];
    }
   
    
}

-(void)requestData
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //5 app首页（opt=132）
    [parameters setObject:@"162" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
}


////初始化
//- (NSArray *)contents
//{
//    if (!_contents) {
//        
//        _contents = @[@[@[@"利率",@"10%以下",@"10%-15%",@"15%-20%",@"20%以上"]],
//                      @[@[@"待收本金",@"1000以下",@"1001-5000",@"5001-10000",@"10001-30000",@"30000以上"]],
//                      @[@[@"借款类型",@"实地考察标",@"信用借款标",@"净值借款标",@"秒还借款标",@"抵押借款标"]]];
//        
//    }
//    
//    return _contents;
//}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dataDics = obj;
    if ([[NSString stringWithFormat:@"%@",[dataDics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        NSArray *productsArr = [dataDics objectForKey:@"products"];
        if (productsArr.count && ![productsArr isEqual:[NSNull null]]) {
            
            for (NSDictionary *itemDic in productsArr) {
                NSString *prodName = [itemDic objectForKey:@"name"];
                NSString *prodId = [NSString stringWithFormat:@"%@",[itemDic objectForKey:@"id"]];
                [prodNameArr addObject:prodName];
                [prodIdArr addObject:prodId];
            }
            DLOG(@"%@",prodNameArr);
            if (prodNameArr.count) {
                //添加借款类型标题
                [prodNameArr insertObject:@"借款类型" atIndex:0];
                NSArray *dataArr = @[prodNameArr];
                
                //多维数组
                _contents = @[@[@[@"利率",@"10%以下",@"10%-15%",@"15%-20%",@"20%以上"]],
                            @[@[@"待收本金",@"1000以下",@"1001-5000",@"5001-10000",@"10001-30000",@"30000以上"]],
                            dataArr];
                DLOG(@"合并数组为:%@",_contents);
                // 初始化视图
                [self initView];
            }
        }
        
    }else if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    }else{
        
        // 服务器返回数据异常
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        
        
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    
    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
    
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18.0];
    titleLabel.text = @"筛选条件";
    self.navigationItem.titleView =  titleLabel;
    [self.navigationController.navigationBar setBarTintColor:GreenColor];
    
}

#pragma mark - UITableView代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.contents count]+2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 10.0f;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3||section == 4) {
        return 1;
    }
    else
    {
        return [self.contents[section] count];
    }
}

-(NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 4||indexPath.section == 3) {
        return 0;
    }
    else
    {
        return [self.contents[indexPath.section][indexPath.row] count] - 1;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellid = [NSString stringWithFormat:@"cellid%ld",(long)indexPath.section];
    SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        
    }

    if (indexPath.section < 3) {
        cell.textLabel.text = self.contents[indexPath.section][indexPath.row][0];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        cell.isExpandable = YES;
        
        return cell;
    }
    
    
    if(indexPath.section ==3)
    {
        
        
        cell.textLabel.text = nil;
        cell.isExpandable = NO;
        cell.userInteractionEnabled = NO;
        return cell;
    }
    
    if (indexPath.section == 4)
    {
        cell.isExpandable = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = YES;
        
        UIButton *emptyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        emptyBtn.frame = CGRectMake(self.leftMargin-25, 8,90, 25);
        emptyBtn.backgroundColor = [UIColor grayColor];
        [emptyBtn setTitle:@"清空" forState:UIControlStateNormal];
        [emptyBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        emptyBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
        emptyBtn.userInteractionEnabled = YES;
        [emptyBtn.layer setMasksToBounds:YES];
        [emptyBtn.layer setCornerRadius:3.0];
        [emptyBtn addTarget:self action:@selector(emptyBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:emptyBtn];
        
        
        UIButton *SureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        SureBtn.frame = CGRectMake(self.leftMargin+70, 8,90, 25);
        SureBtn.backgroundColor = GreenColor;
        [SureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [SureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        SureBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
        SureBtn.userInteractionEnabled = YES;
        [SureBtn.layer setMasksToBounds:YES];
        [SureBtn.layer setCornerRadius:3.0];
        [SureBtn addTarget:self action:@selector(SureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:SureBtn];
        
        
     
        return cell;
        
    }
    
        return cell;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld%ld", (long)indexPath.section, (long)indexPath.row,(long)indexPath.subRow];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setTag:[[NSString stringWithFormat:@"%ld%ld%ld", (long)indexPath.section, (long)indexPath.row,(long)indexPath.subRow] intValue]];
    
    if (indexPath.section < 3)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",self.contents[indexPath.section][indexPath.row][indexPath.subRow]];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];

        
        
        //单选按钮
        _check = [[QCheckBox alloc] initWithDelegate:self];
        _check.frame = CGRectMake(self.view.frame.size.width-self.leftMargin-30, 5, 40, 40);
        [_check setTag:[[NSString stringWithFormat:@"%ld%ld%ld", (long)indexPath.section, (long)indexPath.row,(long)indexPath.subRow] intValue]];
        for (int i=0; i<[ScreenArr count]; i++) {
            ScreenModel *model = [ScreenArr objectAtIndex:i];
            if (_check.tag==model.Tag) {
                model.name=cell.textLabel.text;
                DLOG(@"%@",model.name);
                [_check setImage:[UIImage imageNamed:@"checkbox1_unchecked"] forState:UIControlStateNormal];
                cell.textLabel.textColor = PinkColor;
                _check.selected=YES;
            }
        }
        [_check setImage:[UIImage imageNamed:@"checkbox1_unchecked"] forState:UIControlStateNormal];
        [_check setImage:[UIImage imageNamed:@"screen_btn"] forState:UIControlStateSelected];
        [_check setTitle:nil forState:UIControlStateNormal];
        [_check setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_check.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
        
        [cell.contentView addSubview:_check];
        
    }
    return cell;
}



#pragma 单选框选中触发方法
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked
{
    
     DLOG(@"did tap on CheckBox:%ld checked:%d", (long)checkbox.tag, checked);
    
    UITableViewCell *cell = (UITableViewCell *)[_tableView viewWithTag:checkbox.tag];
    
    
        UITableViewCell *cell11 = (UITableViewCell *)[_tableView viewWithTag:1];
        UITableViewCell *cell12 = (UITableViewCell *)[_tableView viewWithTag:2];
        UITableViewCell *cell13 = (UITableViewCell *)[_tableView viewWithTag:3];
        UITableViewCell *cell14 = (UITableViewCell *)[_tableView viewWithTag:4];
    
        UITableViewCell *cell21 = (UITableViewCell *)[_tableView viewWithTag:101];
        UITableViewCell *cell22 = (UITableViewCell *)[_tableView viewWithTag:102];
        UITableViewCell *cell23 = (UITableViewCell *)[_tableView viewWithTag:103];
        UITableViewCell *cell24 = (UITableViewCell *)[_tableView viewWithTag:104];
        UITableViewCell *cell25 = (UITableViewCell *)[_tableView viewWithTag:105];
    
        UITableViewCell *cell31 = (UITableViewCell *)[_tableView viewWithTag:201];
        UITableViewCell *cell32 = (UITableViewCell *)[_tableView viewWithTag:202];
        UITableViewCell *cell33 = (UITableViewCell *)[_tableView viewWithTag:203];
        UITableViewCell *cell34 = (UITableViewCell *)[_tableView viewWithTag:204];
        UITableViewCell *cell35 = (UITableViewCell *)[_tableView viewWithTag:205];
        UITableViewCell *cell36 = (UITableViewCell *)[_tableView viewWithTag:206];
        UITableViewCell *cell37 = (UITableViewCell *)[_tableView viewWithTag:207];

        QCheckBox *checkbox11  = (QCheckBox *)[cell11.contentView viewWithTag:1];
        QCheckBox *checkbox12  = (QCheckBox *)[cell12.contentView viewWithTag:2];
        QCheckBox *checkbox13  = (QCheckBox *)[cell13.contentView viewWithTag:3];
        QCheckBox *checkbox14  = (QCheckBox *)[cell14.contentView viewWithTag:4];
        
        QCheckBox *checkbox21  = (QCheckBox *)[cell21.contentView viewWithTag:101];
        QCheckBox *checkbox22  = (QCheckBox *)[cell22.contentView viewWithTag:102];
        QCheckBox *checkbox23  = (QCheckBox *)[cell23.contentView viewWithTag:103];
        QCheckBox *checkbox24  = (QCheckBox *)[cell24.contentView viewWithTag:104];
        QCheckBox *checkbox25  = (QCheckBox *)[cell25.contentView viewWithTag:105];
        
        QCheckBox *checkbox31  = (QCheckBox *)[cell31.contentView viewWithTag:201];
        QCheckBox *checkbox32  = (QCheckBox *)[cell32.contentView viewWithTag:202];
        QCheckBox *checkbox33  = (QCheckBox *)[cell33.contentView viewWithTag:203];
        QCheckBox *checkbox34  = (QCheckBox *)[cell34.contentView viewWithTag:204];
        QCheckBox *checkbox35  = (QCheckBox *)[cell35.contentView viewWithTag:205];
        QCheckBox *checkbox36  = (QCheckBox *)[cell36.contentView viewWithTag:206];
        QCheckBox *checkbox37  = (QCheckBox *)[cell37.contentView viewWithTag:207];

    
    //先判断是否选中状态
    if (checkbox.checked) {
        
        ScreenModel *model1 = [[ScreenModel alloc] init];
        model1.Tag = checkbox.tag;
        model1.Checked = checkbox.checked;
        [ScreenArr addObject:model1];
        cell.textLabel.textColor = PinkColor;
        
        switch (checkbox.tag) {
            case 1:
                  {
                        checkbox13.checked = 0;
                        checkbox12.checked = 0;
                        checkbox14.checked = 0;
                      for (int i = 0; i<[ScreenArr count]; i++) {
                          ScreenModel *model = [ScreenArr objectAtIndex:i];
                          cell.textLabel.textColor = [UIColor lightGrayColor];
                          if (model.Tag == 2 || model.Tag ==3 ||model.Tag ==4) {
                              if (model.Tag != checkbox.tag)
                              {
                                  [ScreenArr removeObject:model];
                                  
                              }
                          }
                        
                      }
                  }
                  break;
            case 2:
                {
                        checkbox13.checked = 0;
                        checkbox11.checked = 0;
                        checkbox14.checked = 0;
                    for (int i = 0; i<[ScreenArr count]; i++) {
                        ScreenModel *model = [ScreenArr objectAtIndex:i];
                        cell.textLabel.textColor = [UIColor lightGrayColor];
                        if (model.Tag == 1 || model.Tag ==3 ||model.Tag ==4) {
                            if (model.Tag != checkbox.tag)
                            {
                                [ScreenArr removeObject:model];
                                
                            }
                        }
                        
                    }

                }
                break;
            case 3:
                {
                        checkbox11.checked = 0;
                        checkbox12.checked = 0;
                        checkbox14.checked = 0;
                    for (int i = 0; i<[ScreenArr count]; i++) {
                        ScreenModel *model = [ScreenArr objectAtIndex:i];
                        cell.textLabel.textColor = [UIColor lightGrayColor];
                        if (model.Tag == 1 || model.Tag ==2 ||model.Tag ==4) {
                            if (model.Tag != checkbox.tag)
                            {
                                [ScreenArr removeObject:model];
                                
                            }
                        }
                        
                    }
                }
                break;
            case 4:
                {
                        checkbox13.checked = 0;
                        checkbox12.checked = 0;
                        checkbox11.checked = 0;
                    for (int i = 0; i<[ScreenArr count]; i++) {
                        ScreenModel *model = [ScreenArr objectAtIndex:i];
                        cell.textLabel.textColor = [UIColor lightGrayColor];
                        if (model.Tag == 1 || model.Tag ==3 ||model.Tag ==2) {
                            if (model.Tag != checkbox.tag)
                            {
                                [ScreenArr removeObject:model];
                                
                            }
                        }
                        
                    }
                }
                break;
            case 101:
            {
                checkbox23.checked = 0;
                checkbox22.checked = 0;
                checkbox24.checked = 0;
                checkbox25.checked = 0;
                for (int i = 0; i<[ScreenArr count]; i++) {
                    ScreenModel *model = [ScreenArr objectAtIndex:i];
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                    if (model.Tag == 102 || model.Tag ==103 || model.Tag ==104 || model.Tag ==105) {
                        if (model.Tag != checkbox.tag)
                        {
                            [ScreenArr removeObject:model];
                            
                        }
                    }
                    
                }
            }
                break;
            case 102:
            {
                checkbox23.checked = 0;
                checkbox21.checked = 0;
                checkbox24.checked = 0;
                checkbox25.checked = 0;
                for (int i = 0; i<[ScreenArr count]; i++) {
                    ScreenModel *model = [ScreenArr objectAtIndex:i];
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                    if (model.Tag == 101 || model.Tag ==103 || model.Tag ==104 || model.Tag ==105) {
                        if (model.Tag != checkbox.tag)
                        {
                            [ScreenArr removeObject:model];
                            
                        }
                    }
                    
                }
            }
                break;
            case 103:
            {
                checkbox21.checked = 0;
                checkbox22.checked = 0;
                checkbox24.checked = 0;
                checkbox25.checked = 0;
                for (int i = 0; i<[ScreenArr count]; i++) {
                    ScreenModel *model = [ScreenArr objectAtIndex:i];
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                    if (model.Tag == 102 || model.Tag ==101 || model.Tag ==104 || model.Tag ==105) {
                        if (model.Tag != checkbox.tag)
                        {
                            [ScreenArr removeObject:model];
                            
                        }
                    }
                    
                }
            }
                break;
            case 104:
            {
                checkbox23.checked = 0;
                checkbox22.checked = 0;
                checkbox21.checked = 0;
                checkbox25.checked = 0;
                for (int i = 0; i<[ScreenArr count]; i++) {
                    ScreenModel *model = [ScreenArr objectAtIndex:i];
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                    if (model.Tag == 102 || model.Tag ==103 || model.Tag ==101 || model.Tag ==105) {
                        if (model.Tag != checkbox.tag)
                        {
                            [ScreenArr removeObject:model];
                            
                        }
                    }
                    
                }
            }
                break;
            case 105:
            {
                checkbox23.checked = 0;
                checkbox22.checked = 0;
                checkbox21.checked = 0;
                checkbox24.checked = 0;
                for (int i = 0; i<[ScreenArr count]; i++) {
                    ScreenModel *model = [ScreenArr objectAtIndex:i];
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                    if (model.Tag == 102 || model.Tag ==103 || model.Tag ==104 || model.Tag ==101) {
                        if (model.Tag != checkbox.tag)
                        {
                            [ScreenArr removeObject:model];
                            
                        }
                    }
                    
                }
            }
                break;
            case 201:
            {
                checkbox33.checked = 0;
                checkbox32.checked = 0;
                checkbox35.checked = 0;
                checkbox34.checked = 0;
                checkbox36.checked = 0;
                checkbox37.checked = 0;
                for (int i = 0; i<[ScreenArr count]; i++) {
                    ScreenModel *model = [ScreenArr objectAtIndex:i];
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                    if (model.Tag == 202 || model.Tag ==203 || model.Tag ==204 || model.Tag == 205 || model.Tag ==206 || model.Tag == 207) {
                        if (model.Tag != checkbox.tag)
                        {
                            [ScreenArr removeObject:model];
                            
                        }
                    }
                    
                }
            }
                break;
            case 202:
            {
                checkbox33.checked = 0;
                checkbox35.checked = 0;
                checkbox31.checked = 0;
                checkbox34.checked = 0;
                checkbox36.checked = 0;
                checkbox37.checked = 0;
                for (int i = 0; i<[ScreenArr count]; i++) {
                    ScreenModel *model = [ScreenArr objectAtIndex:i];
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                    if (model.Tag == 201 || model.Tag ==203 || model.Tag == 204 || model.Tag == 205 || model.Tag ==206 || model.Tag == 207) {
                        if (model.Tag != checkbox.tag)
                        {
                            [ScreenArr removeObject:model];
                            
                        }
                    }
                    
                }
            }
                break;
            case 203:
            {
                checkbox35.checked = 0;
                checkbox32.checked = 0;
                checkbox31.checked = 0;
                checkbox34.checked = 0;
                checkbox36.checked = 0;
                checkbox37.checked = 0;
                for (int i = 0; i<[ScreenArr count]; i++) {
                    ScreenModel *model = [ScreenArr objectAtIndex:i];
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                    if (model.Tag == 202 || model.Tag ==201 || model.Tag ==204 || model.Tag == 205  || model.Tag ==206 || model.Tag == 207) {
                        if (model.Tag != checkbox.tag)
                        {
                            [ScreenArr removeObject:model];
                            
                        }
                    }
                    
                }
            }
                break;
            case 204:
            {
                checkbox33.checked = 0;
                checkbox32.checked = 0;
                checkbox31.checked = 0;
                checkbox35.checked = 0;
                checkbox36.checked = 0;
                checkbox37.checked = 0;
                for (int i = 0; i<[ScreenArr count]; i++) {
                    ScreenModel *model = [ScreenArr objectAtIndex:i];
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                    if (model.Tag == 202 || model.Tag ==203 || model.Tag == 201 || model.Tag == 205  || model.Tag ==206 || model.Tag == 207) {
                        if (model.Tag != checkbox.tag)
                        {
                            [ScreenArr removeObject:model];
                            
                        }
                    }
                    
                }
            }
                break;
            case 205:
            {
                checkbox33.checked = 0;
                checkbox32.checked = 0;
                checkbox31.checked = 0;
                checkbox34.checked = 0;
                checkbox36.checked = 0;
                checkbox37.checked = 0;
                for (int i = 0; i<[ScreenArr count]; i++) {
                    ScreenModel *model = [ScreenArr objectAtIndex:i];
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                    if (model.Tag == 202 || model.Tag == 203 || model.Tag == 204 || model.Tag == 201 || model.Tag ==206 || model.Tag == 207) {
                        if (model.Tag != checkbox.tag)
                        {
                            [ScreenArr removeObject:model];
                            
                        }
                    }
                    
                }
            }
                break;
            case 206:
            {
                checkbox33.checked = 0;
                checkbox32.checked = 0;
                checkbox31.checked = 0;
                checkbox34.checked = 0;
                checkbox35.checked = 0;
                checkbox37.checked = 0;
                for (int i = 0; i<[ScreenArr count]; i++) {
                    ScreenModel *model = [ScreenArr objectAtIndex:i];
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                    if (model.Tag == 202 || model.Tag == 203 || model.Tag == 204 || model.Tag == 201 || model.Tag ==205 || model.Tag == 207) {
                        if (model.Tag != checkbox.tag)
                        {
                            [ScreenArr removeObject:model];
                            
                        }
                    }
                    
                }
            }
                break;
            case 207:
            {
                checkbox33.checked = 0;
                checkbox32.checked = 0;
                checkbox31.checked = 0;
                checkbox34.checked = 0;
                checkbox36.checked = 0;
                checkbox35.checked = 0;
                for (int i = 0; i<[ScreenArr count]; i++) {
                    ScreenModel *model = [ScreenArr objectAtIndex:i];
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                    if (model.Tag == 202 || model.Tag == 203 || model.Tag == 204 || model.Tag == 201  || model.Tag ==206 || model.Tag == 205) {
                        if (model.Tag != checkbox.tag)
                        {
                            [ScreenArr removeObject:model];
                            
                        }
                    }
                    
                }
            }
                break;
        }
        
    }
    else
    {
    
    
        for (int i = 0; i<[ScreenArr count]; i++) {
            ScreenModel *model = [ScreenArr objectAtIndex:i];
            cell.textLabel.textColor = [UIColor lightGrayColor];
                if (model.Tag == checkbox.tag)
                {
                    [ScreenArr removeObject:model];
                    
                }
            
        }

    
    }
    DLOG(@"筛选选中的数组 ====== %@",ScreenArr);
    //刷新列表
    [_tableView reloadData];
}


#pragma mark 筛选确定按钮
- (void)SureBtnClick
{
    if (ScreenArr.count) {
        
        NSData *encodedCurBirdSightingList = [NSKeyedArchiver archivedDataWithRootObject:ScreenArr];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:encodedCurBirdSightingList forKey:@"ScreenList2"];
        
    }
    NSInteger num1 = 0,num2 = 0;
    NSString *idStr = @"";
    DLOG(@"确定按钮");
    for (int i = 0; i<[ScreenArr count]; i++) {
        
        ScreenModel *model = [ScreenArr objectAtIndex:i];
        if (model.Tag >=1 && model.Tag <=4) {
            num1 = model.Tag;
        }
        else  if (model.Tag>=101 && model.Tag <=105) {
            
            num2 = model.Tag - 100;
        }
        else   if (model.Tag>=201 && model.Tag <=207) {
            
                idStr = [prodIdArr objectAtIndex:model.Tag - 201];
        }

    }

    [screenDataArr addObject:[NSString stringWithFormat:@"%ld",(long)num1]];
    [screenDataArr addObject:[NSString stringWithFormat:@"%ld",(long)num2]];
//    if (num3 == 0) {
//        [screenDataArr addObject:@""];
//    }
//    else
    [screenDataArr addObject:idStr];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"screen2" object:screenDataArr];
    [self.sideMenuViewController hideMenuViewController];
}


#pragma mark 清空筛选条件
- (void)emptyBtnClick
{
    
    DLOG(@"清空筛选条件");
    [ScreenArr removeAllObjects];
    [_tableView reloadData];
    
}


@end
