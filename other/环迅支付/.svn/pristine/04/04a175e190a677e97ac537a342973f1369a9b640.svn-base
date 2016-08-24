//
//  ChangeIconViewController.m
//  SP2P_7
//
//  Created by kiu on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  更换头像

#import "ChangeIconViewController.h"


#import "ColorTools.h"
#import "UserInfo.h"


@interface ChangeIconViewController ()<UIActionSheetDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,HTTPClientDelegate>

@property (nonatomic, strong) UIButton *iconView;
@property (nonatomic, copy) NSString *logoStr;
@property (nonatomic)UIImage *hearImg;
@property(nonatomic ,strong) NetWorkClient *requestClient;


@end

@implementation ChangeIconViewController

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
 初始化数据
 */
- (void)initData
{
    _logoStr = AppDelegateInstance.userInfo.userImg;
}

/**
 初始化数据
 */
- (void)initView
{
    [self initNavigationBar];
    
    [self initContentView];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"更换头像";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    // 导航条 左边 返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    // 导航条 左边 返回按钮
    UIBarButtonItem *canceItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"order_icon_2010"] style:UIBarButtonItemStyleDone target:self action:@selector(canceClick)];
    canceItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:canceItem];
}

/**
 * 初始化内容详情
 */
#pragma mark 初始化内容
- (void)initContentView
{
     //头像
    _iconView = [UIButton buttonWithType:UIButtonTypeCustom];
    _iconView.frame = CGRectMake(self.view.frame.size.width * 0.5 - 50, 84, 100, 100);
    [_iconView.layer setMasksToBounds:YES];
    [_iconView.layer setCornerRadius:50.0]; //设置矩形四个圆角半径
    [_iconView addTarget:self action:@selector(changeIconClick) forControlEvents:UIControlEventTouchUpInside];
//    [_iconView setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:_logoStr]];
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_logoStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"news_image_default"]];

    
    [self.view addSubview:_iconView];// 登陆头像
    
    UIButton *changeBut = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBut.frame = CGRectMake(self.view.frame.size.width * 0.5 - 75, 200, 150, 35);
    changeBut.backgroundColor = GreenColor;
    [changeBut setTitle:@"选择图片" forState:UIControlStateNormal];
    changeBut.titleLabel.font = [UIFont fontWithName:@"Arial" size:14.0];
    [changeBut.layer setMasksToBounds:YES];
    [changeBut.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
    [changeBut addTarget:self action:@selector(changeIconClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBut];
    
    
    UIButton *yesBut = [UIButton buttonWithType:UIButtonTypeCustom];
    yesBut.frame = CGRectMake(self.view.frame.size.width * 0.5 - 75, 250, 150, 35);
    yesBut.backgroundColor = PinkColor;
    [yesBut setTitle:@"上 传" forState:UIControlStateNormal];
    yesBut.titleLabel.font = [UIFont fontWithName:@"Arial" size:14.0];
    [yesBut.layer setMasksToBounds:YES];
    [yesBut.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
    [yesBut addTarget:self action:@selector(yesCLick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yesBut];
}

#pragma mark 1、返回
- (void)backClick
{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

#pragma mark 注销账户
- (void)canceClick
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"退出账户" message:@"确定要退出此账户吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    
    [alertView show];
}

#pragma mark CLick 上传按钮
- (void)changeIconClick
{
    DLOG(@"上传图片按钮");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [actionSheet addButtonWithTitle:@"拍照"];
    [actionSheet addButtonWithTitle:@"从手机相册选择"];
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
    [_iconView setImage:image forState:UIControlStateNormal];
    _hearImg = image;
}


#pragma mark 确定按钮
- (void)yesCLick
{
  
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
                                         
                                         
                                           [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
                                         
                                         
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



#pragma HTTPClientDelegate 网络数据回调代理


// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"error"]] isEqualToString:@"-1"]) {
            
            
            
        
    }else if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    
    }else{
        
        DLOG(@"返回失败===========%@",[obj objectForKey:@"msg"]);
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




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    DLOG(@"buttonIndex: %ld", (long)buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            // 记录 退出状态
            if (AppDelegateInstance.userInfo != nil) {
                [[AppDefaultUtil sharedInstance] removeGesturesPasswordWithAccount:AppDelegateInstance.userInfo.userName];// 移除该账号的手势密码
                //                [[AppDefaultUtil sharedInstance] setDefaultUserName:@""];// 清除用户昵称
                //                [[AppDefaultUtil sharedInstance] setDefaultUserPassword:@""];// 清除用户密码
                [[AppDefaultUtil sharedInstance] setDefaultAccount:@""];// 清除用户账号
                [[AppDefaultUtil sharedInstance] setDefaultHeaderImageUrl:@""];// 清除用户头像
                
                AppDelegateInstance.userInfo = nil;
                AppDelegateInstance.userInfo.isLogin = 0;
                
                [[NSNotificationCenter defaultCenter]  postNotificationName:@"update" object:nil];
                  [self.lefeMenuVc.sideMenuViewController hideMenuViewController];
                [self dismissViewControllerAnimated:YES completion:^(){}];
                
                
            }
            
        }
            
            break;
        case 1:
        
            break;
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
