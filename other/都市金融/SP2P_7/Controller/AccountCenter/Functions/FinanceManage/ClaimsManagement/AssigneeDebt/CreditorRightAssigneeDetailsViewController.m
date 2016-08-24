//
//  CreditorRightAssigneeDetailsViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-8-4.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  债权受让详情
#import "CreditorRightAssigneeDetailsViewController.h"
#import "ColorTools.h"

@interface CreditorRightAssigneeDetailsViewController()<HTTPClientDelegate>
{
    
    NSArray *titleArr;
    
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *transferName;  // 转让人
@property (nonatomic, strong) UILabel *transferTitle;  // 转让标题
@property (nonatomic, strong) UILabel *transferBP;  // 转让底价
@property (nonatomic, strong) UILabel *transferDeadline;  // 转让截止时间
@property (nonatomic, strong) UITextView *transferReason;  // 转让原因
@property (nonatomic, strong) UILabel *receiveCorpus;  // 待收本金

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation CreditorRightAssigneeDetailsViewController
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
    titleArr = @[@"转让人:",@"转让标题:",@"待收本金:",@"转让底价:",@"转让截止时间:",@"转让原因:"];
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MSWIDTH, MSHIGHT)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i<[titleArr count]; i++) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = [titleArr objectAtIndex:i];
        titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        
        if (i == 0) {
            titleLabel.frame = CGRectMake(10, 30, 60, 30);
        }else if(i == 1||i == 2||i == 3) {
            titleLabel.frame = CGRectMake(10, 30 + i * 40, 75, 30);
        }else if(i == 4) {
            titleLabel.frame = CGRectMake(10, 190, 105, 30);
        }else if(i == 5) {
            titleLabel.frame = CGRectMake(10, 230, 75, 30);
        }
        
        [_scrollView addSubview:titleLabel];
        
    }
    
    _transferName = [[UILabel alloc] init];
    _transferName.frame = CGRectMake(70, 30, MSWIDTH-140, 30);
    _transferName.text = @"";
    _transferName.font = [UIFont boldSystemFontOfSize:15.0f];
    _transferName.textColor = [UIColor redColor];
    [_scrollView addSubview:_transferName];
    
    _transferTitle = [[UILabel alloc] init];
    _transferTitle.frame = CGRectMake(80, 70, MSWIDTH-90, 30);
    _transferTitle.text = @"";
    _transferTitle.font = [UIFont boldSystemFontOfSize:15.0f];
    _transferTitle.textColor = [UIColor redColor];
    [_scrollView addSubview:_transferTitle];
    
    _receiveCorpus = [[UILabel alloc] init];
    _receiveCorpus.frame = CGRectMake(80, 110, MSWIDTH-160, 30);
    _receiveCorpus.text = @"";
    _receiveCorpus.font = [UIFont boldSystemFontOfSize:15.0f];
    _receiveCorpus.textColor = [UIColor redColor];
    [_scrollView addSubview:_receiveCorpus];
    
    _transferBP = [[UILabel alloc] init];
    _transferBP.frame = CGRectMake(80, 150, MSWIDTH-160, 30);
    _transferBP.text = @"";
    _transferBP.font = [UIFont boldSystemFontOfSize:15.0f];
    _transferBP.textColor = [UIColor redColor];
    [_scrollView addSubview:_transferBP];
    
    _transferDeadline = [[UILabel alloc] init];
    _transferDeadline.frame = CGRectMake(110, 190, MSWIDTH-160, 30);
    _transferDeadline.text = @"";
    _transferDeadline.font = [UIFont boldSystemFontOfSize:15.0f];
    _transferDeadline.textColor = [UIColor redColor];
    [_scrollView addSubview:_transferDeadline];
    
    _transferReason = [[UITextView alloc] init];
    _transferReason.frame = CGRectMake(80, 230, MSWIDTH-90, 30);
    _transferReason.text = @"";
    _transferReason.textAlignment = NSTextAlignmentJustified;
    _transferReason.font = [UIFont boldSystemFontOfSize:15.0f];
    _transferReason.textColor = [UIColor redColor];
    _transferReason.scrollEnabled = NO;
    [_scrollView addSubview:_transferReason];
    
    for (UIView *view in self.view.subviews) {
        CGRect frame = view.frame;
        frame.origin.y -= 10.f;
        view.frame = frame;
    }
}
/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"债权受让详情";
//    [self.navigationController.navigationBar setBarTintColor:KColor];
//    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
//                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
//    
//    
//    // 导航条返回按钮
//    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
//    backItem.tintColor = [UIColor whiteColor];
//    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    
}

#pragma 返回按钮触发方法
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

/**
 加载数据
 */
- (void)requestData
{
    if (AppDelegateInstance.userInfo == nil||_signId == nil) {
        [ReLogin outTheTimeRelogin:self];
        return;
    }else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"56" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:_signId forKey:@"signId"];
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
    }
}

#pragma mark HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        DLOG(@"返回成功  msg -> %@",[obj objectForKey:@"msg"]);
        
        _transferName.text = [obj objectForKey:@"transferName"];
        _transferTitle.text = [obj objectForKey:@"transferTitle"];
        _transferBP.text = [NSString stringWithFormat:@"%.2f元",[[obj objectForKey:@"transferBP"]floatValue]];
        if (![[obj objectForKey:@"transferDeadline"] isEqual:[NSNull null]]) {
            _transferDeadline.text = [[NSString stringWithFormat:@"%@",[obj objectForKey:@"transferDeadline"]] substringWithRange:NSMakeRange(0, 19)];
        }
        
        _receiveCorpus.text =  [NSString stringWithFormat:@"%.2f元", [[obj objectForKey:@"debtAmount"]floatValue]];
        
        _transferReason.text =  [NSString stringWithFormat:@"%@", [obj objectForKey:@"transferReason"]];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        UIFont *font = [UIFont boldSystemFontOfSize:16.0f];
        NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        CGSize LabelSiZe = [_transferReason.text boundingRectWithSize:CGSizeMake(MSWIDTH-95, 2000)options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        _transferReason.frame =  CGRectMake(80, 230, MSWIDTH-90, LabelSiZe.height+20);
        
        _scrollView.contentSize = CGSizeMake(MSWIDTH, CGRectGetMaxY(_transferReason.frame)+30);
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    }else {
        DLOG(@"返回失败  msg -> %@",[obj objectForKey:@"msg"]);
        
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
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}



@end
