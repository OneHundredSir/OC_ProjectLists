//
//  BQDetailViewController.m
//  SP2P_6.1
//
//  Created by kiu on 14-10-17.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  站内信 -> 借款提问 -> 详情

#import "BQDetailViewController.h"

#import "ColorTools.h"
#import "SendMessageViewController.h"

@interface BQDetailViewController ()<HTTPClientDelegate> {
    int status;
    
    BOOL up;
    BOOL down;
    int statusOPT;
    NSString *_id;
    
    NSString *inName;   // 发件人
}

@property (nonatomic, strong) UITextView *content;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *inBoxNameLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *upBtn;
@property (nonatomic, strong) UIButton *downBtn;
@property (nonatomic, strong) UIButton *replyBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation BQDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
    
    [self requset];
}

/**
 * 初始化数据
 */
- (void)initData
{
    statusOPT = 141;
    status = 0;
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 104)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    //    [self.view addSubview:_scrollView];
    
    // 标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 75, 150, 30)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    _titleLabel.textColor = [UIColor blackColor];
    [self.view addSubview:_titleLabel];
    
    // 时间
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 75, 150, 30)];
    _timeLabel.font = [UIFont systemFontOfSize:14.0f];
    _timeLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:_timeLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 135, self.view.frame.size.width + 100, 2)];
    line.text = @"----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------";
    line.textColor = [UIColor darkGrayColor];
    [self.view addSubview:line];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _contentLabel.text = @"";
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _contentLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:_contentLabel];
    
    // 发件人
    _inBoxNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 100, 260, 30)];
    _inBoxNameLabel.font = [UIFont systemFontOfSize:14.0f];
    _inBoxNameLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:_inBoxNameLabel];
    
//    //  底部模块及一些按钮功能
//    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
//    bottomView.backgroundColor = KColor;
//    [self.view insertSubview:bottomView aboveSubview:_scrollView];
//    
//    _upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _upBtn.frame = CGRectMake(10, 2,36, 36);
//    [_upBtn setImage:[UIImage imageNamed:@"login_arrow_up"] forState:UIControlStateNormal];
//    [_upBtn.layer setMasksToBounds:YES];
//    [_upBtn.layer setCornerRadius:3.0];
//    _upBtn.tag = 0;
//    [_upBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomView addSubview:_upBtn];
//    
//    _downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _downBtn.frame = CGRectMake(45, 2,36, 36);
//    [_downBtn setImage:[UIImage imageNamed:@"login_arrow_down"] forState:UIControlStateNormal];
//    [_downBtn.layer setMasksToBounds:YES];
//    [_downBtn.layer setCornerRadius:3.0];
//    _downBtn.tag = 1;
//    [_downBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomView addSubview:_downBtn];
//    
//    _replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _replyBtn.frame = CGRectMake(self.view.frame.size.width - 80, 2, 36, 36);
//    [_replyBtn setImage:[UIImage imageNamed:@"upload _documents_btn"] forState:UIControlStateNormal];
//    [_replyBtn.layer setMasksToBounds:YES];
//    [_replyBtn.layer setCornerRadius:3.0];
//    _replyBtn.tag = 2;
//    [_replyBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomView addSubview:_replyBtn];
//    
//    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _deleteBtn.frame = CGRectMake(self.view.frame.size.width - 45, 2, 36, 36);
//    [_deleteBtn setImage:[UIImage imageNamed:@"loan_nopass"] forState:UIControlStateNormal];
//    [_deleteBtn.layer setMasksToBounds:YES];
//    [_deleteBtn.layer setCornerRadius:3.0];
//    _deleteBtn.tag = 3;
//    
//    [_deleteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomView addSubview:_deleteBtn];
    
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"系统消息";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"upload _documents_btn"] style:UIBarButtonItemStyleDone target:self action:@selector(replyClick)];
    rightItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
}

#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark 回复按钮
- (void)replyClick
{
     DLOG(@"回复按钮");
   
    SendMessageViewController *sender = [[SendMessageViewController alloc] init];
    sender.borrowName = inName;
    [self.navigationController pushViewController:sender animated:YES];
}

- (void)btnClick:(UIButton *)btn {
    switch (btn.tag) {
        case 0:
        {
            DLOG(@"上一页");
            if (up) {
                status = 2;
                
                statusOPT = 141;
                [self requset];
            }else {
                [SVProgressHUD showSuccessWithStatus:@"已经是第一条"];
            }
        }
            break;
        case 1:
        {
            DLOG(@"下一页");
            
            if (down) {
                status = 1;
                
                statusOPT = 141;
                [self requset];
            }else {
                [SVProgressHUD showSuccessWithStatus:@"已经是最后一条"];
            }
        }
            break;
        case 2:
        {
            DLOG(@"回复");
        }
            break;
        case 3:
        {
            DLOG(@"删除");
            
//            if (AppDelegateInstance.userInfo == nil) {
//                [SVProgressHUD showErrorWithStatus:@"亲，请登录！"];
//                return;
//            }else {
//                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//                
//                statusOPT = 84;
//                [parameters setObject:@"84" forKey:@"OPT"];
//                [parameters setObject:@"" forKey:@"body"];
//                [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
//                [parameters setObject:_id forKey:@"ids"];
//                
//                if (_requestClient == nil) {
//                    _requestClient = [[NetWorkClient alloc] init];
//                    _requestClient.delegate = self;
//                }
//                [_requestClient requestGet:@"app/services" withParameters:parameters];
//            }
        }
            break;
            
        default:
            break;
    }
}



- (void)requset {
    
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"亲，请登录！"];
        return;
    }else {
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"141" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_bidId] forKey:@"id"];
    //    [parameters setObject:[NSString stringWithFormat:@"%d", _index] forKey:@"index"];
    //    [parameters setObject:[NSString stringWithFormat:@"%d", status] forKey:@"status"];
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
    }
}

#pragma mark - HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{

}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    DLOG(@"返回数据为%@",obj);
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        DLOG(@"返回成功  msg -> %@",[obj objectForKey:@"msg"]);
        
        if (statusOPT == 141) {
        
            inName = [[obj objectForKey:@"bidQuestion"] objectForKey:@"name"];
            _inBoxNameLabel.text = [NSString stringWithFormat:@"发件人: %@", [[obj objectForKey:@"bidQuestion"] objectForKey:@"name"]];
            _titleLabel.text = [obj objectForKey:@"bidNo"];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[[obj objectForKey:@"bidQuestion"] objectForKey:@"time"] objectForKey:@"time"] doubleValue]/1000];
            NSDateFormatter *dataFormat = [[NSDateFormatter alloc] init];
            [dataFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            _timeLabel.text = [dataFormat stringFromDate:date];
            _id = [NSString stringWithFormat:@"%@", [[obj objectForKey:@"bidQuestion"] objectForKey:@"id"]];
            
            _contentLabel.text = [NSString stringWithFormat:@"    %@", [[obj objectForKey:@"bidQuestion"] objectForKey:@"content"]];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            UIFont *font = [UIFont fontWithName:@"Arial" size:14];
            NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
            
            CGSize _label1Sz = [_contentLabel.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
            //DLOG(@"_label1Sz.height -> %f", _label1Sz.height);
            
            // 根据文本的内容，自定义 frame 值。 CGRectMake(25, 320, 80, 40)
            _contentLabel.frame = CGRectMake(10, 145, self.view.frame.size.width - 20, _label1Sz.height + 5);
            
        }else if (statusOPT == 84) {
            
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
            
            status = 2;
            
            statusOPT = 141;
            [self requset];
        }
        
        //发送通知。
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InBoxMegSuccess" object:self];
    
    }else {
        DLOG(@"返回失败  msg -> %@",[obj objectForKey:@"msg"]);
        
       [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
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
