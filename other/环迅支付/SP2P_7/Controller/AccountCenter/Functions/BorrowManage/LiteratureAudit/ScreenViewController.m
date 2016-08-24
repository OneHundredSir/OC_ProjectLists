//
//  ScreenViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//借款资料审核筛选
#import "ScreenViewController.h"
#import "ColorTools.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"
#import "QCheckBox.h"
#import "ScreenModel.h"


@interface ScreenViewController ()<UITableViewDataSource,UITableViewDelegate,SKSTableViewDelegate>
{
    NSMutableArray *ScreenArr;
}

@property (nonatomic,strong) NSArray *contents;
@property (nonatomic,strong)QCheckBox *check;
@property (nonatomic,strong)SKSTableView *tableView;

@end

@implementation ScreenViewController

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
    [self contents];
    ScreenArr = [[NSMutableArray alloc] init];
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    

    //列表初始化
    _tableView = [[SKSTableView alloc] initWithFrame:CGRectMake(self.leftMargin, 0, self.view.frame.size.width - self.leftMargin, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    self.tableView.SKSTableViewDelegate = self;
    [self.view addSubview:_tableView];
    
}

//初始化
- (NSArray *)contents
{
    if (!_contents) {
        
        _contents = @[@[@[@"借款类型",@"信用借款标",@"净值借款标",@"秒还借款标",@"机构担保标",@"实地考察标"]],
                      @[@[@"审核状态",@"已通过",@"未通过",@"审核中",@"未提交"]],
                      @[@[@"有效期",@"有效",@"未提交",@"失效",@"无效"]]];
        
    }
    
    return _contents;
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
    
    
    if (indexPath.section == 3||indexPath.section == 4) {
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
    
    if(indexPath.section == 3)
    {
        
        
        cell.textLabel.text = nil;
        cell.isExpandable = NO;
        cell.userInteractionEnabled = NO;
        return cell;
    }
    
    if (indexPath.section == 4)
    {
        
        UIButton *emptyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        emptyBtn.frame = CGRectMake(30, 3,90, 25);
        emptyBtn.backgroundColor = [UIColor grayColor];
        [emptyBtn setTitle:@"清空" forState:UIControlStateNormal];
        [emptyBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        emptyBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
        [emptyBtn.layer setMasksToBounds:YES];
        [emptyBtn.layer setCornerRadius:3.0];
        [emptyBtn addTarget:self action:@selector(emptyBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:emptyBtn];
        
        
        UIButton *SureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        SureBtn.frame = CGRectMake(130, 3,90, 25);
        SureBtn.backgroundColor = GreenColor;
        [SureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [SureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        SureBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
        [SureBtn.layer setMasksToBounds:YES];
        [SureBtn.layer setCornerRadius:3.0];
        [SureBtn addTarget:self action:@selector(SureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:SureBtn];
        
        
        cell.isExpandable = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    if (indexPath.section < 3)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",self.contents[indexPath.section][indexPath.row][indexPath.subRow]];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        [cell setTag:100+indexPath.row];
        //单选按钮
        _check = [[QCheckBox alloc] initWithDelegate:self];
        _check.frame = CGRectMake(self.view.frame.size.width-90, 5, 40, 40);
        [_check setTag:[[NSString stringWithFormat:@"%ld%ld%ld", (long)indexPath.section, (long)indexPath.row,(long)indexPath.subRow] intValue]];
        for (int i=0; i<[ScreenArr count]; i++) {
            ScreenModel *model = [ScreenArr objectAtIndex:i];
            if (_check.tag==model.Tag) {
                DLOG(@"111");
                model.name=cell.textLabel.text;
                DLOG(@"%@",model.name);
                [_check setImage:[UIImage imageNamed:@"checkbox1_checked.png"] forState:UIControlStateNormal];
                _check.selected=YES;
            }
        }
        [_check setTitle:nil forState:UIControlStateNormal];
        [_check setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_check.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
        
        [cell addSubview:_check];
        
        
        return cell;
    }
  
 
    return cell;
}


#pragma 单选框选中触发方法
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked
{
    
    DLOG(@"did tap on CheckBox:%ld checked:%d", (long)checkbox.tag, checked);
    //先判断是否选中状态
    if (checked ==1) {
        
        ScreenModel *model1 = [[ScreenModel alloc] init];
        model1.Tag = checkbox.tag;
        model1.Checked = checkbox.checked;
        [ScreenArr addObject:model1];
        
    }
    
    else
    {
        for (int i=0; i<[ScreenArr count]; i++) {
            ScreenModel *model = [ScreenArr objectAtIndex:i];
            if (model.Tag == checkbox.tag)
            {
                [ScreenArr removeObject:model];
                
            }
        }
        
    }
    
    
    [_tableView reloadData];
}


#pragma mark 确定按钮
- (void)SureBtnClick
{
    DLOG(@"确定按钮");
    [self.sideMenuViewController hideMenuViewController];

}


#pragma mark 清空筛选条件
- (void)emptyBtnClick
{
    
    DLOG(@"清空条件");
    [ScreenArr removeAllObjects];
    [_tableView reloadData];
    
}
@end
