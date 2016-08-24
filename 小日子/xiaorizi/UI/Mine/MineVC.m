//
//  MineVC.m
//  xiaorizi
//
//  Created by HUN on 16/6/1.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "MineVC.h"
#import "WHDYaoYiYao.h"
#import "WHDShowMyInfo.h"

#import "WHDSelfViewController.h"
#import "WHDDingViewController.h"
#import "WHDLeaveViewController.h"
#import "WHDSelfWebViewController.h"

@interface MineVC ()<UITableViewDataSource,UITableViewDelegate,
                    UIImagePickerControllerDelegate,UINavigationControllerDelegate>//使用相册需要的两个代理


#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)
@property (weak, nonatomic) IBOutlet UIView *backView;

@property(nonatomic,strong)NSArray *item_arr;
@property (strong, nonatomic) IBOutlet UIView *header;

@property(nonatomic,strong)NSArray *item_imgs;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property(nonatomic,strong)MBProgressHUD *Hub;
@property (weak, nonatomic) IBOutlet UIButton *imaBtn;
@end

@implementation MineVC
/**
 *  跳转到注册界面
 */
-(void)showRegister
{
    WHDRegisterViewController *vc=[WHDRegisterViewController new];
    vc.title=@"注册";
    vc.hidesBottomBarWhenPushed=YES;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem=nil;
    
    self.title=@"我的";
    _imaBtn.layer.cornerRadius=_imaBtn.frame.size.width/2.0;
    _imaBtn.clipsToBounds=YES;
    
    //设置头像的边框
    _backView.backgroundColor =[UIColor clearColor];
    _backView.layer.borderWidth=2;
    _backView.layer.borderColor=[UIColor whiteColor].CGColor;
    _backView.layer.cornerRadius=_backView.frame.size.width/2.0;
    [self setUpRightBar];
    [self setUptable];
}

/**
 *  布置提示框
 */
-(void)setUpHub:(NSString *)show
{
    //初始化进度框，置于当前的View当中
    _Hub = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_Hub];
    //如果设置此属性则当前的view置于后台
    _Hub.dimBackground = YES;
    
    _Hub.mode=MBProgressHUDModeDeterminate;
    
    //设置对话框文字
    _Hub.labelText = show;

    
    //显示对话框
    [_Hub showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        sleep(1);
    } completionBlock:^{
        //操作执行完后取消对话框
        [_Hub removeFromSuperview];
        _Hub = nil;
    }];
}

/**
 *  点击头像
 */
- (IBAction)phone:(UIButton *)sender
{
    AppDelegate *delegatemy=[UIApplication sharedApplication].delegate;
    if (delegatemy.isOn) {
        //添加提示框
        UIAlertController *controller=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *phoneAc = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self phoneJob];
        }];
        UIAlertAction *picAc = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self picJob];
        }];
        UIAlertAction *delAc = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [controller addAction:phoneAc];
        [controller addAction:picAc];
        [controller addAction:delAc];
        [self presentViewController:controller animated:YES completion:nil];
    }else
    {
        [self showRegister];
    }
    
}
#pragma mark - UIImagePickerController相册问题
#pragma mark 拍照
-(void)phoneJob
{
    //判断有没有相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickVc=[[UIImagePickerController alloc]init];
        imagePickVc.delegate=self;
        imagePickVc.allowsEditing=YES;
        imagePickVc.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickVc animated:YES completion:nil];
    }else
    {
        [self setUpHub:@"我靠居然你特么没有相机"];
    }
}

#pragma mark 从相册获取图片
-(void)picJob
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePickVc=[[UIImagePickerController alloc]init];
        imagePickVc.delegate=self;
        imagePickVc.allowsEditing=YES;
        imagePickVc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickVc animated:YES completion:nil];
    }else
    {
        [self setUpHub:@"没有相册啊大哥！"];
    }
    
}
#pragma mark 实现UIImagePickerController代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)
{
    NSLog(@"lalala");
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"%@",info);
    UIImage *image=info[@"UIImagePickerControllerOriginalImage"];
    [_imaBtn setImage:image forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"---->");
    [picker popViewControllerAnimated:YES];
}


#pragma mark - 右边工具
-(void)setUpRightBar
{
    
    UIButton *btn=[[UIButton alloc]initWithFrame:(CGRect){0,0,40,40}];
    [btn setImage:[UIImage imageNamed:@"settinghhhh"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"settingh"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(searchWay) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *toolItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem=toolItem;
}

/**
 *  跳转到我的工具栏
 */

-(void)searchWay
{
    WHDShowMyInfo *view=[WHDShowMyInfo WHDShowTableView];
    view.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark 设置tableview
-(void)setUptable
{
    
    self.item_arr=@[@"个人中心",@"我的订单",@"我的收藏",@"留言反馈",@"应用推荐"];
    self.item_imgs=@[@"recomment",@"recomment",@"recomment",@"recomment",@"recomment"];
    _table.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    _table.separatorColor=[UIColor blackColor];
    _table.estimatedRowHeight=1000;
    _table.rowHeight=UITableViewAutomaticDimension;
    
//    _table.rowHeight=70;
    _table.bounces=NO;
    _table.tableHeaderView=_header;
}

#pragma mark datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return self.item_arr.count;
    }else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:myCellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellID];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section==0) {
        cell.textLabel.text=self.item_arr[indexPath.row];
        cell.imageView.image=[UIImage imageNamed:self.item_imgs[indexPath.row]];
    }else
    {
        cell.textLabel.text=@"摇一摇 每天都有小惊喜";
        cell.imageView.image=[UIImage imageNamed:@"yaoyiyao"];
    }
    return cell;
}


#pragma mark delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
       
        NSInteger num=indexPath.row;
        AppDelegate *delegate=[UIApplication sharedApplication].delegate;
        if (delegate.isOn) {
            if (num==0)//个人中心
            {
                WHDSelfViewController *vc1=[WHDSelfViewController new];
                vc1.title=self.item_arr[indexPath.row];
                vc1.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:vc1 animated:YES];
            }else if(num==1)//我的订单
            {
                WHDDingViewController *vc1=[WHDDingViewController new];
                vc1.title=self.item_arr[indexPath.row];
                vc1.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:vc1 animated:YES];
                
            }else if(num==3)//留言
            {
                WHDLeaveViewController *vc1=[WHDLeaveViewController new];
                vc1.title=self.item_arr[indexPath.row];
                vc1.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:vc1 animated:YES];
                
            }else if(num==4)//应用推荐
            {
                WHDSelfWebViewController *vc1=[WHDSelfWebViewController new];
                vc1.title=self.item_arr[indexPath.row];
                vc1.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:vc1 animated:YES];
            }
        }else
        {
            //跳转的哦啊注册页面
            [self showRegister];
        }
        
    }else
    {
        WHDYaoYiYao *yaoVC=[[WHDYaoYiYao alloc]init];
        yaoVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:yaoVC animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
