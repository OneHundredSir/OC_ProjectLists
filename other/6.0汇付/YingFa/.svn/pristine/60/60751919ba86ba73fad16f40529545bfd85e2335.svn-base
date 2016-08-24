//
//  CreditBorrowingScaleViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-3.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "CreditBorrowingScaleViewController.h"
#import "ColorTools.h"
#import "UIFolderTableView.h"
#import "RequirementsView.h"
#import "ProductDescriptionViewController.h"
#import "ReimbursementProcessView.h"
#import "ReleaseBorrowInfoViewController.h"
#import "AccountInfoViewController.h"
#import "ActivationViewController.h"

@interface CreditBorrowingScaleViewController ()<UITableViewDataSource,UITableViewDelegate,HTTPClientDelegate>
{
    
    NSArray *dataArr;
    NSInteger _isBaseInfo;
    NSInteger _isEmail;
}

@property (nonatomic, strong) UIFolderTableView *listView;

@property (nonatomic, strong) RequirementsView *requireView;

@property (nonatomic, strong) UILabel *RangeLabel2;
@property (nonatomic, strong) UILabel *dataLabel1;

@property(nonatomic, strong) NSMutableArray *titleArr;;
@property(nonatomic, strong) NSArray *optReviewMaterial;
@property(nonatomic, copy)   NSString *applyconditons;
@property (nonatomic,strong) UIScrollView  *scrollView;
@property(nonatomic ,strong) NetWorkClient *requestClient;
@property(nonatomic ,strong) UILabel *promptLabel;
@property(nonatomic ,strong) UILabel *dataLabel;
@end

@implementation CreditBorrowingScaleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    // 初始化数据
    [self initData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _titleArr = [[NSMutableArray alloc] init];
    //titleArr = @[@"1.行驶证",@"2.户口本",@"3.银行交易流水",@"4.公用事业缴费单",@"5.银行对账单",@"6.央行征信记录",@"7.工作收入证明",@"8.房产证"];
    dataArr = @[@"产品描述",@"申请条件",@"还款流程"];
    
    
    // 初始化视图
    [self initView];
    
}

/**
 * 初始化数据
 */
- (void)initData
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //3.1客户端借款标产品接口
    [parameters setObject:@"19" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%@",self.productId]   forKey:@"productId"];
    if (AppDelegateInstance.userInfo.userId != nil) {
        [parameters setObject:AppDelegateInstance.userInfo.userId   forKey:@"id"];
    }else
        [parameters setObject:@""   forKey:@"id"];
    
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    
    
    //滚动视图
    _scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator =NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = KblackgroundColor;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 545);
    [self.view addSubview:_scrollView];
    
    UILabel *RangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 30)];
    RangeLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    RangeLabel.text = @"额度范围:";
    [_scrollView addSubview:RangeLabel];
    
    
    _RangeLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 240, 30)];
    _RangeLabel2.font = [UIFont systemFontOfSize:13.0f];
    //RangeLabel2.text = @"300.0-5000,000.00元";
    _RangeLabel2.textColor = PinkColor;
    [_scrollView addSubview:_RangeLabel2];
    
    
    UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 150, 30)];
    dataLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    dataLabel.text = @"必审资料:";
    [_scrollView addSubview:dataLabel];
    
    _dataLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(72, 35, self.view.frame.size.width - 92, 30)];
    _dataLabel1.font = [UIFont systemFontOfSize:13.0f];
    _dataLabel1.textColor = [UIColor lightGrayColor];
    _dataLabel1.numberOfLines = 0;
    _dataLabel1.lineBreakMode = NSLineBreakByCharWrapping;
    [_scrollView addSubview:_dataLabel1];
    
    
    _promptLabel = [[UILabel alloc] initWithFrame:CGRectZero];//(8, 190, self.view.frame.size.width-10, 40)
    _promptLabel.text =@"【财富提示】:每提交一份可选审核材料，可提高借款额度2000-5000元。";
    _promptLabel.textColor = [UIColor lightGrayColor];
    _promptLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _promptLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    _promptLabel.numberOfLines = 0;
    [_scrollView addSubview:_promptLabel];
    
    _listView = [[UIFolderTableView alloc] initWithFrame:CGRectMake(0, 190, self.view.frame.size.width, 800)  style:UITableViewStyleGrouped];
    _listView.delegate = self;
    _listView.backgroundColor = KblackgroundColor;
    _listView.dataSource = self;
    _listView.scrollEnabled = NO;
    [_scrollView addSubview:_listView];
    
}



#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    DLOG(@"==借款类型详情返回成功=======%@",obj);
    NSDictionary *dics = obj;
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        _RangeLabel2.text = [NSString stringWithFormat:@"%@元",[dics objectForKey:@"limitRange"]];//额度范围
        _applyconditons = [dics objectForKey:@"applyconditons"] ;  //申请条件
        
        _isEmail = [[dics objectForKey:@"isEmailVerified"] integerValue];
        _isBaseInfo = [[dics objectForKey:@"isAddBaseInfo"] integerValue];
        
        
        NSArray *reviewMaterial = [dics objectForKey:@"reviewMaterial"];
        NSArray *optReviewMaterial = [dics objectForKey:@"optReviewMaterial"];
        
        NSString *reviewStr = @"";
        for (NSDictionary *reviewDic in reviewMaterial) {
            reviewStr = [reviewStr stringByAppendingFormat:@" %@ ", [[reviewDic  objectForKey:@"auditItem"] objectForKey:@"name"]];
            DLOG(@"==必审材料证件名称:=======%@",reviewStr);
        }
        _dataLabel1.text = reviewStr;//显示必审材料证件名称
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        UIFont *font =[UIFont systemFontOfSize:13.0f];
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        CGSize labelSize = [reviewStr boundingRectWithSize:CGSizeMake(MSWIDTH-92, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        _dataLabel1.frame = CGRectMake(_dataLabel1.frame.origin.x, _dataLabel1.frame.origin.y,_dataLabel1.frame.size.width, labelSize.height+20);
        
        
        if (_titleArr.count != 0) {
            [_titleArr removeAllObjects];
        }
        int i = 1;
        for (NSDictionary *reviewDic2 in optReviewMaterial) {
            NSString *optreviewStr = [NSString  stringWithFormat:@"%d.%@",i++, [[reviewDic2  objectForKey:@"auditItem"] objectForKey:@"name"]];
            DLOG(@"==选审材料证件名称:=======%@",optreviewStr);
            [_titleArr addObject:optreviewStr];
        }
        
        UILabel *dataLabel11 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_dataLabel1.frame), 150, 30)];
        dataLabel11.font = [UIFont boldSystemFontOfSize:13.0f];
        dataLabel11.text = @"选审资料:";
        dataLabel11.tag = 199;
        [_scrollView addSubview:dataLabel11];
        int j=0,k=0;
        
        for (int i = 0; i < [_titleArr count]; i++) {
            
            UILabel *dataLabel22 = [[UILabel alloc] init];
            if (i % 2 == 0) {
                dataLabel22.frame = CGRectMake(75, CGRectGetMaxY(_dataLabel1.frame) + j * 20, 150, 30);
                j++;
            }else {
                dataLabel22.frame = CGRectMake(190, CGRectGetMaxY(_dataLabel1.frame) + k * 20, 150, 30);
                k++;
            }
            
            dataLabel22.font = [UIFont systemFontOfSize:13.0f];
            dataLabel22.lineBreakMode = NSLineBreakByCharWrapping;
            dataLabel22.text = [_titleArr objectAtIndex:i];
            dataLabel22.textColor = [UIColor lightGrayColor];
            dataLabel22.tag = 200+i;
            [_scrollView addSubview:dataLabel22];
        }
        
        UILabel *label33 = (UILabel *)[self.view viewWithTag:199+_titleArr.count];
        
        _promptLabel.frame = CGRectMake(8, CGRectGetMaxY(label33.frame)+10,MSWIDTH-10, 40);
        _listView.frame = CGRectMake(_listView.frame.origin.x, CGRectGetMaxY(_promptLabel.frame)+10,_listView.frame.size.width, _listView.frame.size.height);
        
    }else {
        
        DLOG(@"返回成功===========%@",[obj objectForKey:@"msg"]);
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


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = _titleStr;
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    // 发布借款
    UIBarButtonItem *publishItem=[[UIBarButtonItem alloc] initWithTitle:@"发布借款" style:UIBarButtonItemStyleDone target:self action:@selector(publishClick)];
    publishItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:publishItem];
    
}

#pragma mark UItableViewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [dataArr count];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 5.0f;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 5.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID2 = @"cellid2";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
    }
    cell.textLabel.text = [dataArr objectAtIndex:indexPath.section];
    cell.textLabel.font = [UIFont boldSystemFontOfSize :14.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIFolderTableView *folderTableView = (UIFolderTableView *)tableView;
    switch (indexPath.section) {
        case 0:
        {
            ProductDescriptionViewController *ProductDescriptionView = [[ProductDescriptionViewController alloc] init];
            ProductDescriptionView.productid = self.productId;
            [self.navigationController pushViewController:ProductDescriptionView animated:YES];
            
        }
            break;
            
        case 1:
        {
            _requireView= [[RequirementsView alloc] init];
            _requireView.textlabel.text = _applyconditons;
            _listView.scrollEnabled = NO;
            [folderTableView openFolderAtIndexPath:indexPath WithContentView:_requireView
                                         openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                             // opening actions
                                             //[self CloseAndOpenACtion:indexPath];
                                         }
                                        closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                            // closing actions
                                            //[self CloseAndOpenACtion:indexPath];
                                            //[cell changeArrowWithUp:NO];
                                        }
                                   completionBlock:^{
                                       // completed actions
                                       // _listView.scrollEnabled = YES;
                                   }];
            
        }
            break;
            
        case 2:
        {
            ReimbursementProcessView *ReimburseView= [[ReimbursementProcessView alloc] init];
            _listView.scrollEnabled = NO;
            [folderTableView openFolderAtIndexPath:indexPath WithContentView:ReimburseView
                                         openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                             // opening actions
                                             //[self CloseAndOpenACtion:indexPath];
                                         }
                                        closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                            // closing actions
                                            //[self CloseAndOpenACtion:indexPath];
                                            //[cell changeArrowWithUp:NO];
                                        }
                                   completionBlock:^{
                                       // completed actions
                                       //_listView.scrollEnabled = YES;
                                   }];
            
            
        }
            break;
            
    }
}


#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma 发布借款方法
- (void)publishClick
{
    
    DLOG(@"发布借款按钮");
    if (AppDelegateInstance.userInfo == nil) {
        
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        
    }else {
        
        if (_isBaseInfo == 1 && _isEmail == 1)//已激活且完善资料
        {
            
            ReleaseBorrowInfoViewController *releaseBorrowInfoView = [[ReleaseBorrowInfoViewController alloc] init];
            releaseBorrowInfoView.productID = self.productId;
            //            releaseBorrowInfoView.rangeString = self.RangeStr;
            DLOG(@"self.title -> %@", self.title);
            if ([self.title isEqualToString:@"秒还借款"]) {
                releaseBorrowInfoView.isRepayment = 1;
            }else {
                releaseBorrowInfoView.isRepayment = 0;
            }
            
            [self.navigationController pushViewController:releaseBorrowInfoView animated:YES];
            
            
        }else if (_isBaseInfo == 0 && _isEmail == 1)//已激活未完善资料
        {
            [SVProgressHUD showErrorWithStatus:@"请先完善资料!"];
            AccountInfoViewController *infoView = [[AccountInfoViewController alloc] init];
            infoView.typeNum = 1;
            infoView.cbsVC = self;
            UINavigationController *infoVc = [[UINavigationController alloc] initWithRootViewController:infoView];
            [self.navigationController presentViewController:infoVc animated:YES completion:nil];
            
            
        }else if (_isEmail == 0)//未激活
        {
            
            [SVProgressHUD showErrorWithStatus:@"请先激活帐号!"];
            DLOG(@"fjdjfkdfjdfjkdhfjkd 未激活");
            ActivationViewController *activatView = [[ActivationViewController alloc] init];
            [self.navigationController pushViewController:activatView animated:YES];
            
        }
        
    }
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end
