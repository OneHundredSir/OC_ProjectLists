//
//  AJChooseRecipientsController.m
//  SP2P_7
//
//  Created by Ajax on 16/1/30.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJChooseRecipientsController.h"
#import "JSONKit.h"
#import "AJChooseRecipients.h"
#import "AJChooseRecipientsCell.h"

@interface AJChooseRecipientsController ()<HTTPClientDelegate, UIAlertViewDelegate>
@property (nonatomic, assign) int totalPage;
@property (nonatomic, assign) int currPage;
@property(nonatomic ,strong) NetWorkClient *requestClient;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, assign) BOOL isRemoveAttentionRequest;
@property (nonatomic, strong) NSIndexPath *indexPathForEdit;
@end

@implementation AJChooseRecipientsController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {}
    return self;
}

- (NSMutableArray *)data
{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (NetWorkClient *)requestClient
{
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    return _requestClient;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
  self.title = @"关注用户";
    __weak typeof(self) weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        weakSelf.currPage = 1;
        [weakSelf sendRequestWithPage:weakSelf.currPage];
    }];
    
    [self.tableView addFooterWithCallback:^{
        
        if ( ++weakSelf.currPage <= weakSelf.totalPage) {
            [weakSelf sendRequestWithPage:weakSelf.currPage];
        }else{
            weakSelf.tableView.footerRefreshingText = @"已经到底啦";
            [weakSelf.tableView footerEndRefreshing];
        }

    }];
    UIView *tabHeader =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 10)];
    tabHeader.backgroundColor = KblackgroundColor;
    self.tableView.tableHeaderView = tabHeader;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView headerBeginRefreshing];
}

- (void)sendRequestWithPage:(int)page
{
    self.isRemoveAttentionRequest = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"" forKey:@"body"];
    parameters[@"OPT"] = @"67";
    parameters[@"id"] = AppDelegateInstance.userInfo.userId ;
    parameters[@"currPage"] = [NSString stringWithFormat:@"%@", @(page)];
    [self.requestClient requestGet:@"app/services" withParameters:parameters];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AJChooseRecipientsCell *cell = [AJChooseRecipientsCell cellWithTableView:tableView];
    cell.aAJChooseRecipients = self.data[indexPath.row];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *controlelr = self.navigationController.viewControllers[[self.navigationController.viewControllers indexOfObject:self]-1];
    [controlelr setValue:[self.data[indexPath.row]attention_user_name] forKeyPath:@"nameField.text"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消关注此人？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert  show];
        self.indexPathForEdit = indexPath;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {//
        self.isRemoveAttentionRequest = YES;
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:@"150" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:[self.data[self.indexPathForEdit.row] attentionID] forKey:@"attentionId"];
        [self.requestClient requestGet:@"app/services" withParameters:parameters];
    }
}


#pragma mark - HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{}

-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
//    DLOG(@"===%@=======", [dics JSONString]);
//    DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
    if ([[NSString stringWithFormat:@"%@",dics[@"error"]] isEqualToString:@"-1"]) {

        if ( self.isRemoveAttentionRequest == YES) {
            [SVProgressHUD showSuccessWithStatus:[obj objectForKey:@"msg"]];
            [self.data removeObjectAtIndex:self.indexPathForEdit.row];
            [self.tableView deleteRowsAtIndexPaths:@[self.indexPathForEdit] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            NSArray *attentionList = dics[@"list"];
            NSNumber *totolCount = dics[@"totalNum"];
            NSNumber *pageSize = dics[@"pageSize"];
            self.totalPage = [totolCount intValue]/[pageSize intValue] + 1;
            if (self.currPage == 1) {
                [self.data removeAllObjects];
            }
            if (![attentionList isEqual:[NSNull null]] && attentionList.count>0) {
                for (NSDictionary *item in attentionList) {
                    AJChooseRecipients *recipient = [[AJChooseRecipients alloc] initWithDict:item];
                    
                    [self.data addObject:recipient];
                }
            }
            [self.tableView reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView headerEndRefreshing];
                [self.tableView footerEndRefreshing];
            });

        }
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
        
    }else {
        // 服务器返回数据异常
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}

@end
