//
//  AJBorrowerInfoEditCoontroller.m
//  SP2P_7
//
//  Created by Ajax on 16/3/18.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJBorrowerInfoEditCoontroller.h"
#import "TwoCodeViewController.h"
#import "NetWorkClient.h"
#import "JSONKit.h"
#import "AJBorrowerInfo.h"
#import "AJBorrowerInfoCell.h"

@interface AJBorrowerInfoEditCoontroller ()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, weak) UIButton *headerBtn;
@property (nonatomic, strong) NetWorkClient *requestClient;
@end

@implementation AJBorrowerInfoEditCoontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubViews];
    
    UIBarButtonItem *save=[[UIBarButtonItem alloc]  initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveEdit)];
    [self.navigationItem setRightBarButtonItem:save];
}

- (NSString *)fieldTextSection:(NSInteger)section Row:(NSInteger)row
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    AJBorrowerInfoCell *cell = (AJBorrowerInfoCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    return cell.content.text;
    
}

- (void)saveEdit
{
    [self.view endEditing:YES];
    // 先查询是个人标 还是企业标
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"24" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    parameters[@"orgCode"] = [self fieldTextSection:0 Row:2];
    parameters[@"realName"] = [self fieldTextSection:1 Row:0];
    parameters[@"companyContactsMobile"] = [self fieldTextSection:1 Row:3];
    parameters[@"idNo"] = [self fieldTextSection:1 Row:1];
    parameters[@"companyName"] = [self fieldTextSection:0 Row:0];
    parameters[@"companyContacts"] = [self fieldTextSection:1 Row:2];
    parameters[@"taxRegistrationCode"] = [self fieldTextSection:0 Row:3];
    
    [parameters setObject:[NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.userId] forKey:@"id"];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [self.requestClient requestParameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        DLOG( @"%@", [responseObject JSONString]);
        
//        if ([responseObject[@"error"] intValue] == -1) {
//            
//            [SVProgressHUD dismiss];
//
//        }else{
        
            [SVProgressHUD showImage:nil status:responseObject[@"msg"]];
//        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self requestData];
}

- (NetWorkClient *)requestClient
{
    if (!_requestClient) {
        _requestClient = [[NetWorkClient alloc] init];
    }
    return _requestClient;
}


- (void)addSubViews
{
    CGFloat leading =10.f;
    CGFloat headerVeiwH = 80.f;
    CGFloat headerVeiwW =  self.view.frame.size.width;
    UIView *headerView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerVeiwW, headerVeiwH)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIControl *viewControl1 = [[UIControl alloc] initWithFrame:headerView.bounds];
    [viewControl1 addTarget:self action:@selector(cpsClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:viewControl1];
    
      // logo图片
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headerBtn.frame = CGRectMake(leading, leading, 60, 60);
    [headerBtn.layer setMasksToBounds:YES];
    [headerBtn.layer setCornerRadius:30.0]; //设置矩形四个圆角半径
    [headerBtn addTarget:self action:@selector(changeIcon) forControlEvents:UIControlEventTouchUpInside];
    [headerBtn setBackgroundImage:[UIImage imageNamed:@"default_head"] forState:UIControlStateNormal];
    [headerBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
    if (AppDelegateInstance.userInfo != nil) {
        
        [headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:AppDelegateInstance.userInfo.userImg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head"]];
    }
    [headerView addSubview:headerBtn];// 登陆头像
    self.headerBtn = headerBtn;
    
    CGFloat arrowImgW = 20.f;
    UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(headerVeiwW - arrowImgW - 10, (headerVeiwH -arrowImgW)/2, arrowImgW, arrowImgW)];
    arrowImg.image = [UIImage imageNamed:@"cell_more_btn"];
    [headerView addSubview:arrowImg];
    
    CGFloat codeImgW = 25;
    UIImageView *codeImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(arrowImg.frame) - 10 -codeImgW, (headerVeiwH -codeImgW)/2, codeImgW, codeImgW)];
    codeImg.image = [UIImage imageNamed:@"twoCode"];
    [headerView addSubview:codeImg];
    
    CGFloat namelabelH = 20;
    CGFloat nameLableX = CGRectGetMaxX(headerBtn.frame) + 10;
    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLableX, (headerVeiwH - namelabelH)/2, CGRectGetMinX(codeImg.frame) - 10 - nameLableX, namelabelH)];
    namelabel.textAlignment = NSTextAlignmentLeft;
    namelabel.font = [UIFont boldSystemFontOfSize:14.0f];
    if (AppDelegateInstance.userInfo != nil) {
        
        namelabel.text = AppDelegateInstance.userInfo.userName;
    }
    [headerView addSubview:namelabel];
    
    self.tableView.tableHeaderView = headerView;
}

#pragma 推广点击触发方法
-(void)cpsClick
{
    TwoCodeViewController *cpsView = [[TwoCodeViewController alloc] init];
    cpsView.backTypeNum = 1;
    [self.navigationController pushViewController:cpsView animated:YES];
}
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
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"该设备没有摄像头"];
        }
    }else if(buttonIndex == 1){// 我的相册
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else if (buttonIndex == 2){
        
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
    [self.headerBtn setImage:image forState:UIControlStateNormal];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"userId"];
    [parameters setObject:@"1" forKey:@"type"];
    
    // 1. Create `AFHTTPRequestSerializer` which will create your request.
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
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

@end
