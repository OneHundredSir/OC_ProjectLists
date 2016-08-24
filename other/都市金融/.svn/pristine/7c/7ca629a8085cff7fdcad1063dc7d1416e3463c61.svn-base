//
//  OutBoxDetailViewController.m
//  SP2P_7
//
//  Created by kiu on 14-10-16.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  站内信 -> 发件箱 -> 详情

#import "OutBoxDetailViewController.h"
#import "FilterHTML.h"
#import "ColorTools.h"
#import "SendMessageViewController.h"

@interface OutBoxDetailViewController ()<HTTPClientDelegate> {
    int status;
    
    BOOL up;
    BOOL down;
    NSString *receiverName;
    
    NSString *_id;
    int statusOPT;
}

@property (nonatomic, strong) UITextView *content;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *inBoxNameLabel;
//@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, weak) UITextView *textV;

//@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *upBtn;
@property (nonatomic, strong) UIButton *downBtn;
@property (nonatomic, strong) UIButton *replyBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation OutBoxDetailViewController

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
    statusOPT = 135;
    status = 0;
}

/**
 初始化数据
 */
- (void)initView
{
     self.title = @"发件箱";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat selfW = self.view.bounds.size.width;
    CGFloat selfH = self.view.bounds.size.height - 64;
    
    // 标题
    CGFloat _titleLabelLeading = 15.f;
    CGFloat _titleLabelH = 25.f;
    CGFloat _titleLabelTop = 10.f;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabelLeading, _titleLabelTop, selfW - 2*_titleLabelLeading, _titleLabelH)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_titleLabel];
    
    // 发件人
    CGFloat _inBoxNameLabelY = CGRectGetMaxY(_titleLabel.frame);
    _inBoxNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabelLeading, _inBoxNameLabelY, selfW/2, _titleLabelH)];
    _inBoxNameLabel.font = [UIFont systemFontOfSize:14.0f];
    _inBoxNameLabel.textColor = [UIColor darkGrayColor];
    _inBoxNameLabel.backgroundColor = _titleLabel.backgroundColor;
    [self.view addSubview:_inBoxNameLabel];
    
    // 时间
    CGFloat _timeLabelX = CGRectGetMaxX(_inBoxNameLabel.frame);
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_timeLabelX, _inBoxNameLabelY,selfW - _timeLabelX - 10, _titleLabelH)];
    _timeLabel.font = [UIFont systemFontOfSize:13.0f];
    _timeLabel.textColor = [UIColor darkGrayColor];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.backgroundColor = _titleLabel.backgroundColor;
    [self.view addSubview:_timeLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_inBoxNameLabel.frame) + 10, selfW + 10, 2)];
    line.text = @"------------------------------------------------------------------------------------------------------------------------";
    line.textColor = [UIColor darkGrayColor];
    [self.view addSubview:line];
    
    CGFloat textVY = CGRectGetMaxY(line.frame) + 8;
    CGFloat bottomViewH = 40.f;
    UITextView *textV = [[UITextView alloc] initWithFrame:CGRectMake(0, textVY, selfW, selfH - textVY - bottomViewH)];
    textV.dataDetectorTypes = UIDataDetectorTypeAll;
    textV.textContainerInset = UIEdgeInsetsMake(0, _titleLabelLeading, 0, 10);
    textV.font = [UIFont fontWithName:@"Arial" size:14];
    textV.backgroundColor = self.view.backgroundColor;
    textV.editable = NO;
    textV.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:textV];
    self.textV = textV;
    
    //  底部模块及一些按钮功能
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, selfH - bottomViewH, selfW, bottomViewH)];
    bottomView.backgroundColor = KColor;
    [self.view addSubview:bottomView];
    _upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _upBtn.frame = CGRectMake(10, 2,36, 36);
    [_upBtn setImage:[UIImage imageNamed:@"login_arrow_up"] forState:UIControlStateNormal];
    [_upBtn.layer setMasksToBounds:YES];
    [_upBtn.layer setCornerRadius:3.0];
    _upBtn.tag = 0;
    [_upBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_upBtn];
    
    _downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _downBtn.frame = CGRectMake(45, 2,36, 36);
    [_downBtn setImage:[UIImage imageNamed:@"login_arrow_down"] forState:UIControlStateNormal];
    [_downBtn.layer setMasksToBounds:YES];
    [_downBtn.layer setCornerRadius:3.0];
    _downBtn.tag = 1;
    [_downBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_downBtn];
    
    _replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _replyBtn.frame = CGRectMake(self.view.frame.size.width - 80, 2, 36, 36);
    [_replyBtn setImage:[UIImage imageNamed:@"upload _documents_btn"] forState:UIControlStateNormal];
    [_replyBtn.layer setMasksToBounds:YES];
    [_replyBtn.layer setCornerRadius:3.0];
    _replyBtn.tag = 2;
    [_replyBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_replyBtn];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(self.view.frame.size.width - 45, 2, 36, 36);
    [_deleteBtn setImage:[UIImage imageNamed:@"loan_nopass"] forState:UIControlStateNormal];
    [_deleteBtn.layer setMasksToBounds:YES];
    [_deleteBtn.layer setCornerRadius:3.0];
    _deleteBtn.tag = 3;
    
    [_deleteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_deleteBtn];
}


#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)btnClick:(UIButton *)btn {
    switch (btn.tag) {
        case 0:
        {
            DLOG(@"上一页");
            if (up) {
                status = 2;
                
                statusOPT = 135;
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
                
                statusOPT = 135;
                [self requset];
            }else {
               [SVProgressHUD showSuccessWithStatus:@"已经是最后一条"];
            }
        }
            break;
        case 2:
        {
            DLOG(@"回复");
            
            SendMessageViewController *sender = [[SendMessageViewController alloc] init];
            sender.borrowName = receiverName;
            [self.navigationController pushViewController:sender animated:YES];
        }
            break;
        case 3:
        {
            DLOG(@"删除");
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除" message:@"确定要删除此信息吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            
            [alertView show];
        }
            break;
            
        default:
            break;
    }
}

- (void)requset {
    
    if (AppDelegateInstance.userInfo == nil) {
        [ReLogin goLogin:self];
        return;
    }else {
    
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"135" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"user_id"];
        [parameters setObject:[NSString stringWithFormat:@"%d", _index] forKey:@"index"];
        [parameters setObject:[NSString stringWithFormat:@"%d", status] forKey:@"status"];
        
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
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        DLOG(@"返回成功  msg -> %@",[obj objectForKey:@"msg"]);
        
        if (statusOPT == 135) {
            
            DLOG(@"name -> %@", [[obj objectForKey:@"page"] objectForKey:@"receiver_name"]);
            
            receiverName = [[obj objectForKey:@"page"] objectForKey:@"receiver_name"];
            _inBoxNameLabel.text = [NSString stringWithFormat:@"收件人: %@", [[obj objectForKey:@"page"] objectForKey:@"receiver_name"]];
            _titleLabel.text = [[obj objectForKey:@"page"] objectForKey:@"title"];
            
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[[obj objectForKey:@"page"] objectForKey:@"time"] objectForKey:@"time"] doubleValue]/1000];
            NSDateFormatter *dataFormat = [[NSDateFormatter alloc] init];
            [dataFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            _timeLabel.text = [dataFormat stringFromDate:date];
            _index = [[obj objectForKey:@"index"] intValue];
            _id = [NSString stringWithFormat:@"%@", [[obj objectForKey:@"page"] objectForKey:@"id"]];
            up = [[obj objectForKey:@"up"] boolValue];
            down = [[obj objectForKey:@"down"] boolValue];
            
            self.textV.text = [NSString stringWithFormat:@"%@", [[obj objectForKey:@"page"] objectForKey:@"content"]];
            self.textV.text = [FilterHTML filterHTML:self.textV.text];
        }else if (statusOPT == 148) {

            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        
            // 删除成功，发送通知。
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OutMegSuccess" object:self];
            
            if (!up && !down) {
                [self.navigationController popViewControllerAnimated:NO];
                return;
            }
            else if (_index == 1 && !up && down) {
                status = 0;
            }else{
                status = 2;
            }
            
            statusOPT = 135;
            [self requset];
        }
        
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
    //    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

#pragma mark UIAlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    DLOG(@"buttonIndex: %ld", (long)buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            if (AppDelegateInstance.userInfo == nil) {
                [ReLogin outTheTimeRelogin:self];
                return;
            }else {
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                
                statusOPT = 148;
                [parameters setObject:@"148" forKey:@"OPT"];
                [parameters setObject:@"" forKey:@"body"];
                [parameters setObject:_id forKey:@"ids"];
                [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
                
                if (_requestClient == nil) {
                    _requestClient = [[NetWorkClient alloc] init];
                    _requestClient.delegate = self;
                }
                [_requestClient requestGet:@"app/services" withParameters:parameters];
            }
        }
            
            break;
        case 1:
            
            break;
    }
}

@end
