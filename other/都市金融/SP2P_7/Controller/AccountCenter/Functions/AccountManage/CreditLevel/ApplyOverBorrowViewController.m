//
//  ApplyOverBorrowViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-30.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "ApplyOverBorrowViewController.h"
#import "ColorTools.h"
#import "ApplyRecordViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UploadDocumentsCell.h"
#import "AuditSubjectViewController.h"
#import "ReviewIntegralDetail.h"
#import "JSONKit.h"

@interface ApplyOverBorrowViewController ()<UITextFieldDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate, HTTPClientDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) UITableView *ListView;
@property (nonatomic,strong) UITextField *limitField;
@property (nonatomic,strong) UITextView *ReasontextView;
@property (nonatomic, strong)UIScrollView *ScrollView;
@property (nonatomic,strong) NSMutableArray *listArray;
@property(nonatomic ,strong) NetWorkClient *requestClient;
@property(nonatomic ,strong) UILabel *textlabel4;
@property(nonatomic ,strong) UIButton *upBtn;
@property(nonatomic ,copy) NSString *imgStr;
@property(nonatomic ,copy) NSMutableArray *imgArr;
@property(nonatomic ,copy) NSString *jsonStr;
@end

@implementation ApplyOverBorrowViewController

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
    //通知检测对象
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(updateList:) name:@"selected" object:nil];
    _imgStr = [[NSString alloc] init];
    _imgArr = [[NSMutableArray alloc] init];
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    
    
    //滚动视图
    _ScrollView =[[UIScrollView alloc] initWithFrame:self.view.bounds];
    _ScrollView.userInteractionEnabled = YES;
    _ScrollView.scrollEnabled = YES;
    _ScrollView.showsHorizontalScrollIndicator = NO;
    _ScrollView.showsVerticalScrollIndicator = NO;
    _ScrollView.delegate = self;
    _ScrollView.backgroundColor = KblackgroundColor;
    _ScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_ScrollView];
   
    UIControl *viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [viewControl addTarget:self action:@selector(controlAction) forControlEvents:UIControlEventTouchUpInside];
    [_ScrollView addSubview:viewControl];
    
    UILabel *textlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 120, 30)];
    textlabel1.text = @"申请超额额度:";
    textlabel1.font = [UIFont boldSystemFontOfSize:15.0f];
    textlabel1.textColor = [UIColor darkGrayColor];
    [_ScrollView addSubview:textlabel1];
    
    
    UILabel *textlabel11 = [[UILabel alloc] initWithFrame:CGRectMake(310, 70, 20, 30)];
    textlabel11.text = @"元";
    textlabel11.font = [UIFont boldSystemFontOfSize:14.0f];
    textlabel11.textColor = [UIColor lightGrayColor];
    
    _limitField = [[UITextField alloc] initWithFrame:CGRectMake(10, 35, self.view.frame.size.width-20, 35)];
    _limitField.borderStyle = UITextBorderStyleNone;
    _limitField.placeholder = @"请输入超额额度";
    _limitField.font = [UIFont systemFontOfSize:14.0f];
    _limitField.delegate = self;
    _limitField.keyboardType = UIKeyboardTypeDecimalPad;
    _limitField.layer.borderWidth = 0.5f;
    _limitField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _limitField.layer.cornerRadius = 3.0f;
    _limitField.layer.masksToBounds = YES;
    _limitField.rightView = textlabel11;
    _limitField.backgroundColor = [UIColor whiteColor];
    _limitField.rightViewMode = UITextFieldViewModeAlways;
    [_limitField addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventEditingChanged];
    [_ScrollView addSubview:_limitField];
    

    
    UILabel *textlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, self.view.frame.size.width-20, 30)];
    textlabel2.text = @"申请原因";
    textlabel2.font = [UIFont boldSystemFontOfSize:15.0f];
    [_ScrollView addSubview:textlabel2];
    
    
    
    _ReasontextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 105, self.view.frame.size.width-20, 100)];
    _ReasontextView.backgroundColor = [UIColor whiteColor];
    _ReasontextView.delegate = self;
    _ReasontextView.layer.borderWidth = 0.5f;
    _ReasontextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _ReasontextView.layer.cornerRadius = 3.0f;
    _ReasontextView.layer.masksToBounds = YES;
    [_ScrollView addSubview:_ReasontextView];
    
    
    
    UILabel *textlabel3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 205, 120, 30)];
    textlabel3.text = @"可提交审核资料:";
    textlabel3.font = [UIFont boldSystemFontOfSize:14.0f];
    [_ScrollView addSubview:textlabel3];
    
    UIButton *applysubjectsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    applysubjectsBtn.frame = CGRectMake(100,205, 180, 30);
    [applysubjectsBtn setTitle:@"从审核科目中选择..." forState:UIControlStateNormal];
    applysubjectsBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    applysubjectsBtn.titleLabel.textAlignment= NSTextAlignmentLeft;
    [applysubjectsBtn setTitleColor:PinkColor forState:UIControlStateNormal];
    [applysubjectsBtn addTarget:self action:@selector(applysubjectsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_ScrollView addSubview:applysubjectsBtn];
    
    _ListView = [[UITableView alloc] initWithFrame:CGRectMake(0, 235, self.view.frame.size.width, 150) style:UITableViewStyleGrouped];
    _ListView.delegate = self;
    _ListView.scrollEnabled = NO;
    _ListView.dataSource = self;
    [_ScrollView addSubview:_ListView];

    _textlabel4 = [[UILabel alloc] initWithFrame:CGRectMake(20, 240, 300, 20)];
    _textlabel4.text = @"注:也可以先提交申请，再提交审核资料。";
    _textlabel4.textColor = [UIColor grayColor];
    _textlabel4.font = [UIFont boldSystemFontOfSize:13.0f];
    [_ScrollView addSubview:_textlabel4];
    
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:bottomView aboveSubview:_ScrollView];
    
    UIButton *SubmitApplyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    SubmitApplyBtn.frame = CGRectMake(self.view.frame.size.width*0.5-50, 8,100, 25);
    [SubmitApplyBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [SubmitApplyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    SubmitApplyBtn.layer.cornerRadius = 3.0f;
    SubmitApplyBtn.layer.masksToBounds = YES;
    SubmitApplyBtn.backgroundColor = GreenColor;
    SubmitApplyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [SubmitApplyBtn addTarget:self action:@selector(SubmitApplyBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:SubmitApplyBtn];
}



/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"申请超额借款";
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    // 导航条返回按钮
    UIBarButtonItem *RightItem=[[UIBarButtonItem alloc] initWithTitle:@"申请记录" style:UIBarButtonItemStyleDone target:self action:@selector(RightItemClick)];
    RightItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:RightItem];
}

// 限制申请超额输入金额长度
- (void)changeValue:(UITextField *)textField {
    DLOG(@"借款金额在改变。");
    
    if (textField == _limitField) {
        if (textField.text.length > 8) {
            textField.text = [textField.text substringToIndex:8];
        }
    }
}


#pragma mark UItableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (_listArray.count) {
        
        return _listArray.count;
        
    }else
        return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0f;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 2.0f;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UploadDocumentsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[UploadDocumentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ReviewIntegralDetail *model = [_listArray objectAtIndex:indexPath.section];
    cell.NameLabel.text = model.name;
    cell.stateLabel.text = @"未提交";
    cell.tag = 100+indexPath.section;
    cell.uploadBtn.tag = 100+indexPath.section;
    [cell.uploadBtn addTarget:self action:@selector(uploadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


#pragma mark 提交证件按钮
- (void)uploadBtnClick:(UIButton *)btn
{
    _upBtn = btn;
    DLOG(@"上传图片按钮");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [actionSheet addButtonWithTitle:@"拍照"];
    [actionSheet addButtonWithTitle:@"从手机相册选择"];
    [actionSheet addButtonWithTitle:@"取消"];
    actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons - 1;
    [actionSheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
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
    if (image!=nil) {
        
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:@"1" forKey:@"type"];
        
        // 1. Create `AFHTTPRequestSerializer` which will create your request.
        AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
        
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        
        // 2. Create an `NSMutableURLRequest`.
        
        NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST"
                                                                        URLString:[NSString stringWithFormat:@"%@%@",Baseurl,@"/app/uploadPhoto"]
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
                                                 
                                                [SVProgressHUD showSuccessWithStatus:@"上传成功!"];
                                                  _imgStr =[dic objectForKey:@"filename"] ;
                                                 UploadDocumentsCell *cell;
                                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0) {
                                                     
                                                     cell = (UploadDocumentsCell *)[_upBtn superview];
                                                 }else {
                                                     cell = (UploadDocumentsCell *)[[_upBtn superview]  superview];
                                                 }
                                                 cell.stateLabel.text = @"上传成功";
                                                 cell.stateLabel.backgroundColor = GreenColor;
                                                 [_upBtn removeFromSuperview];
                                                 //取出成功上传的字段加入字典
                                                  ReviewIntegralDetail *model = [_listArray objectAtIndex:_upBtn.tag - 100];
                                                 NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                                                 [dic setObject:[NSString stringWithFormat:@"%@",model.no] forKey:@"id"];
                                                 [dic setObject:_imgStr forKey:@"filename"];
                                                 [_imgArr addObject:dic];
                                                 _jsonStr = [_imgArr JSONString];
                                                 DLOG(@"jsonstr is %@",_jsonStr);
  
                                             }else{
                                                 
                                               
                                                 [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
                                                 
                                                 
                                             }
                                             
                                             
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


#pragma mark 审核科目
- (void)applysubjectsBtnClick
{
    DLOG(@"审核科目选择");
    AuditSubjectViewController *auditSubjectView = [[AuditSubjectViewController alloc] init];
    [self.navigationController pushViewController:auditSubjectView animated:YES];
}



#pragma mark 通知调用的方面
-(void)updateList:(NSNotification *)notification
{
    _listArray = (NSMutableArray *)[notification object];
    _ListView.frame = CGRectMake(0, 235, self.view.frame.size.width, 74*_listArray.count);
    _textlabel4.frame = CGRectMake(0, 232+74*_listArray.count, self.view.frame.size.width, 20);
    _ScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 235+74*_listArray.count+64);
    [_ListView reloadData];
}



#pragma mark 提交申请
- (void)SubmitApplyBtn
{
    [self requestData];
    DLOG(@"提交申请");
  
}

#pragma mark UIalertViewdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}



#pragma mark UItextfielddelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

#pragma mark 点击空白处收回键盘
- (void)controlAction
{
    [_ReasontextView resignFirstResponder];
    [_limitField resignFirstResponder];
    
    for (UITextField *textField in [_ScrollView subviews])
    {
        if ([textField isKindOfClass: [UITextField class]]) {
            
            [textField  resignFirstResponder];
        }
        
    }
    
}


#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}

#pragma 申请记录触发方法
- (void)RightItemClick
{
    // DLOG(@"返回按钮");
    ApplyRecordViewController *ApplyRecordView = [[ApplyRecordViewController alloc] init];
    [self.navigationController pushViewController:ApplyRecordView animated:YES];
    
    
}

#pragma mark - UITextView Delegate Methods

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;
    
}

#pragma 请求数据
-(void) requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [ReLogin outTheTimeRelogin:self];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"120" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:_limitField.text forKey:@"excessAmount"]; //超额额度
    [parameters setObject:_ReasontextView.text forKey:@"applyReason"]; // 申请原因
    if (_jsonStr) {
        [parameters setObject:_jsonStr forKey:@"jsonAuditItems"];// 审核资料数组
    }else
    [parameters setObject:@"[]" forKey:@"jsonAuditItems"];// 审核资料数组
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
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        
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

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}
@end
