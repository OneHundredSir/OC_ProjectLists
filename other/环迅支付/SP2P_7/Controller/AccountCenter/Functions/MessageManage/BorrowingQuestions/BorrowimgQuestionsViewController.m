//
//  BorrowimgQuestionsViewController.m
//  SP2P_7
//
//  Created by kiu on 14-10-14.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "BorrowimgQuestionsViewController.h"

#import "MessageBox.h"
#import "MessageBoxCell.h"
#import "BQDetailViewController.h"

@interface BorrowimgQuestionsViewController ()<UITableViewDelegate,UITableViewDataSource, HTTPClientDelegate,UIActionSheetDelegate> {
    NSMutableArray *_dataArrays;        // 数据
    NSInteger _editNum;                   // 总的数据
    
    NSInteger _total;                   // 总的数据
    
    NSInteger _currPage;                // 查询的页数
    UITableViewCellEditingStyle selectEditingStyle;
    
    BOOL editStatus;                    // 是否编辑状态（决定点击是否进入内页）
    
    NSInteger _isDelete;                // 删除状态（解析不同数据
    NSInteger _selectNum;
    NSInteger _deleteNum;
}

@property (nonatomic,strong) UITableView *listView;
@property (nonatomic,strong) UIView *bottomView;
@property(nonatomic ,strong) NetWorkClient *requestClient;
@property (nonatomic,strong)UIView *aboveView;
@property (nonatomic,strong)UIBarButtonItem   *editBarButtonItem;
@property (nonatomic,strong)UIButton *selectBtn;
//@property (nonatomic,strong)UIButton *markBtn;  // 标记
@property (nonatomic,strong)UIButton *deleteBtn;  // 删除

@property(nonatomic) NSTimeInterval time;
@end

@implementation BorrowimgQuestionsViewController

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
    _dataArrays = [[NSMutableArray alloc] init];
    _editNum = 0;
    editStatus = NO;
    _isDelete = 0;
    _selectNum = 0;
    _deleteNum = 0;
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //列表视图
    _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _listView.delegate = self;
    _listView.dataSource = self;
    [self.view addSubview:_listView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_listView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
//    [_listView headerBeginRefreshing];
    [self headerRereshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_listView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable:) name:@"QuestionBoxMegSuccess" object:nil];
    
    //  底部模块及一些按钮功能
    _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    _bottomView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40);
    _bottomView.backgroundColor = KColor;
    
    //选中全部
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(8 ,8,25, 25);
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"checkbox2_unchecked"] forState:UIControlStateNormal];
    _selectBtn.tag = 0;
    [_selectBtn addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_selectBtn];
    
    //删除按钮
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(self.view.frame.size.width - 45, 4, 28, 28);
    [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_img"] forState:UIControlStateNormal];
    _deleteBtn.tag = 2;
    [_deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_deleteBtn];
}

// 调用通知，刷新数据。
-(void) updateTable:(id)obj
{
//    [_listView headerBeginRefreshing];
    [self headerRereshing];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"借款提问";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];

   _editBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editButtonClicked:)];
    _editBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:_editBarButtonItem];
    
}



#pragma mark - Table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArrays.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *settingcell = @"settingCell";
    
    MessageBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:settingcell];
    
    if (cell == nil) {
        cell = [[MessageBoxCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:settingcell];
    }
    
    //  设置间隔线距离
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 30, 0, 0)];
    
    // 设置 cell 右边的箭头
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    MessageBox *meg = _dataArrays[indexPath.row];
    [cell fillCellWithObject:meg];
    return cell;
}



// 选中行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLOG(@"Click -> %ld", (long)indexPath.row);
    if (editStatus) {
        DLOG(@"您点击了第%ld分区第%ld行",(long)indexPath.section, (long)indexPath.row);
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_img_selete"] forState:UIControlStateNormal];
        
    }else {
        
        MessageBox *meg = _dataArrays[indexPath.row];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        BQDetailViewController *message = [[BQDetailViewController alloc] init];
    //    message.index = indexPath.row + 1;
        message.bidId = meg.messageId;
        [self.navigationController pushViewController:message animated:YES];
        
    }
}

#pragma 返回按钮触发方法
- (void)backClick
{
    if (editStatus) {
        
        _isDelete = 0;
        _deleteNum = 0;
        editStatus = NO;
        _editBarButtonItem.title = @"编辑";
        [_listView setEditing:NO animated:YES];
        _listView.allowsMultipleSelectionDuringEditing = NO;
        
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_img"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:.3 animations:^{
            _listView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            _bottomView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40);
        } completion:^(BOOL finished) {
            [_bottomView removeFromSuperview];
        }];
        
        _editNum = 0;
        _selectNum = 0;
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"checkbox2_unchecked"] forState:UIControlStateNormal];
        
        for (int temp = 0; temp < _dataArrays.count; temp ++) {
            MessageBox *box = _dataArrays[temp];
            box.selectall = @"0";
        }
        [_listView reloadData];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

// 点击编辑按钮
- (void)editButtonClicked:(id)sender {
    if (_dataArrays.count == 0) {
        [SVProgressHUD showImage:nil status:@"当前暂无可编辑的信息!"];
        return;
    }
    
    _listView.userInteractionEnabled = YES;
    if (_editNum == 0) {
        editStatus = YES;
        _isDelete = 0;
        _editBarButtonItem.title = @"取消";
        _deleteNum = 0;
        
        [UIView animateWithDuration:.3 animations:^{
            _listView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 40);
            _bottomView.frame = CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40);
        }];
        
        selectEditingStyle = UITableViewCellEditingStyleDelete;
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"checkbox2_unchecked"] forState:UIControlStateNormal];
        _listView.allowsMultipleSelectionDuringEditing = YES;
        [_listView setEditing:YES animated:YES];
        
        [self.view insertSubview:_bottomView aboveSubview:self.view];
        _editNum = 1;
    }else{
        
        _isDelete = 0;
        _deleteNum = 0;
        editStatus = NO;
        _editBarButtonItem.title = @"编辑";
        [_listView setEditing:NO animated:YES];
        _listView.allowsMultipleSelectionDuringEditing = NO;
        
        [UIView animateWithDuration:.3 animations:^{
            _listView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            _bottomView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40);
        } completion:^(BOOL finished) {
            [_bottomView removeFromSuperview];
        }];
        
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_img"] forState:UIControlStateNormal];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"checkbox2_unchecked"] forState:UIControlStateNormal];
        _editNum = 0;
        _selectNum = 0;
        for (int temp = 0; temp < _dataArrays.count; temp ++) {
            MessageBox *box = _dataArrays[temp];
            box.selectall = @"0";
        }
        [_listView reloadData];
    }
    
}


//选中全部cell
-(void)selectClick
{
    
    DLOG(@"点击选择按钮!!!!");
    if (_selectNum == 0) {
        _selectNum = 1;
        _deleteNum = 1;
        _listView.userInteractionEnabled = NO;
        _listView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40);
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"checkbox2_checked"] forState:UIControlStateNormal];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_img_selete"] forState:UIControlStateNormal];
        
        for (int temp = 0; temp < _dataArrays.count; temp ++) {
            MessageBox *box = _dataArrays[temp];
            box.selectall = @"1";
        }
        [_listView reloadData];
    }else{
        _selectNum = 0;
        _deleteNum = 0;
        _listView.userInteractionEnabled = YES;
        _listView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40);
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"checkbox2_unchecked"] forState:UIControlStateNormal];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_img"] forState:UIControlStateNormal];
        
        for (int temp = 0; temp < _dataArrays.count; temp ++) {
            MessageBox *box = _dataArrays[temp];
            box.selectall = @"0";
        }
        [_listView reloadData];
    }
    
}

//删除按钮
-(void)deleteClick
{
    _listView.userInteractionEnabled = YES;
    DLOG(@"点击删除按钮!!!!");
    _isDelete = 1;
    // 选中的行
    NSArray *selectedRows = [_listView indexPathsForSelectedRows];
     NSMutableString *ids = [[NSMutableString alloc] init];
    
    // 是否删除特定的行
    BOOL deleteSpecificRows = selectedRows.count > 0;
    // 删除特定的行
    if (deleteSpecificRows&& _deleteNum == 0)
    {
        // 将所选的行的索引值放在一个集合中进行批量删除
        NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
        
        for (NSIndexPath *selectionIndex in selectedRows)
        {
            [indicesOfItemsToDelete addIndex:selectionIndex.row];
            
            // 取出ID串，发送给服务器
            MessageBox *box = _dataArrays[selectionIndex.row];
            [ids appendString:[NSString stringWithFormat:@"%ld", (long)box.messageId]];
            if (_dataArrays.count) {
                [ids appendString:@","];
            }
        }
        [ids deleteCharactersInRange:NSMakeRange(ids.length-1,1)];
        DLOG(@"ids -> %@", ids);
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"84" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
        [parameters setObject:ids forKey:@"ids"];
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
        
        // 从数据源中删除所选行对应的值
        [_dataArrays removeObjectsAtIndexes:indicesOfItemsToDelete];
        
        //删除所选的行
        [_listView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    if(_deleteNum == 1)
    {
        // 发送请求，响应服务器
        
        for (int temp = 0; temp < _dataArrays.count; temp ++) {
            // 取出ID串，发送给服务器
            MessageBox *box = _dataArrays[temp];
            [ids appendString:[NSString stringWithFormat:@"%ld", (long)box.messageId]];
            if (_dataArrays.count) {
                [ids appendString:@","];
            }
        }
        [ids deleteCharactersInRange:NSMakeRange(ids.length-1,1)];
        DLOG(@"ids -> %@", ids);
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:@"84" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
        [parameters setObject:ids forKey:@"ids"];
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
        
        // 删除全部
        [_dataArrays removeAllObjects];
        
        [_listView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [_listView setEditing:NO animated:YES];
    
    _listView.allowsMultipleSelectionDuringEditing = NO;
    
}

//标记按钮
-(void)markClick
{
    
    DLOG(@"标记按钮!!!!");
    _listView.userInteractionEnabled = YES;
    UIActionSheet *SheetView = [[UIActionSheet alloc]
                                initWithTitle:nil
                                delegate:self
                                cancelButtonTitle:@"取消"
                                destructiveButtonTitle:@"标记为已读"
                                otherButtonTitles:@"标记为未读", nil];
    [SheetView showInView:self.view];
    
    
}
#pragma UIActionSheet代理方法
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    _isDelete = 1;
    NSArray *selectedRows = [_listView indexPathsForSelectedRows];
    
    // 是否特定的行
    BOOL deleteSpecificRows = selectedRows.count > 0;
    // 将所选的行的索引值放在一个集合中进
    NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
    NSMutableString *ids = [[NSMutableString alloc] init];
    // 特定的行
    if (deleteSpecificRows && _deleteNum == 0)
    {
        for (NSIndexPath *selectionIndex in selectedRows)
        {
            [indicesOfItemsToDelete addIndex:selectionIndex.row];
            
            // 取出ID串，发送给服务器
            MessageBox *box = _dataArrays[selectionIndex.row];
            [ids appendString:[NSString stringWithFormat:@"%ld", (long)box.messageId]];
            if (_dataArrays.count) {
                [ids appendString:@","];
            }
        }
        [ids deleteCharactersInRange:NSMakeRange(ids.length-1,1)];
        DLOG(@"ids -> %@", ids);
        
    }
    if(_deleteNum == 1)
    {
        // 发送请求，响应服务器
        NSMutableString *ids = [[NSMutableString alloc] init];
        
        for (int temp = 0; temp < _dataArrays.count; temp ++) {
            // 取出ID串，发送给服务器
            MessageBox *box = _dataArrays[temp];
            [ids appendString:[NSString stringWithFormat:@"%ld", (long)box.messageId]];
            if (_dataArrays.count) {
                [ids appendString:@","];
            }
        }
        [ids deleteCharactersInRange:NSMakeRange(ids.length-1,1)];
        DLOG(@"ids -> %@", ids);
        
    }
    
    DLOG(@"选择选项为%ld",(long)buttonIndex);
    if (ids!=nil  && buttonIndex != 2) {
        
        if(buttonIndex){
            
            // 标记为未读，发送请求给服务器
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [parameters setObject:@"86" forKey:@"OPT"];
            [parameters setObject:@"" forKey:@"body"];
            [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
            [parameters setObject:ids forKey:@"ids"];
            
            if (_requestClient == nil) {
                _requestClient = [[NetWorkClient alloc] init];
                _requestClient.delegate = self;
            }
            [_requestClient requestGet:@"app/services" withParameters:parameters];
            
            
            
        }else{
            
            // 标记为已读，发送请求给服务器
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [parameters setObject:@"85" forKey:@"OPT"];
            [parameters setObject:@"" forKey:@"body"];
            [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
            [parameters setObject:ids forKey:@"ids"];
            
            if (_requestClient == nil) {
                _requestClient = [[NetWorkClient alloc] init];
                _requestClient.delegate = self;
            }
            [_requestClient requestGet:@"app/services" withParameters:parameters];
            
        }
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _isDelete = 0;
            _currPage = 1;
            _total = 1;
            
            [self requestData];// 刷新表格
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self hiddenRefreshView];
        });
    }
}

#pragma mark - 编辑
// 设置删除按钮标题
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

// 是否可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}
// 编辑模式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return selectEditingStyle;
    
}

#pragma mark 删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除模式
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        // 从数据源中删除
        [_dataArrays removeObjectAtIndex:indexPath.row];
        // 删除行
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}


/**
 加载数据
 */
- (void)requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [self hiddenRefreshView];
         [ReLogin outTheTimeRelogin:self];
        return;
    }else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"140" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"user_id"];
        [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_currPage] forKey:@"currPage"];
        
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
    [self hiddenRefreshView];
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        DLOG(@"返回成功  msg -> %@",[obj objectForKey:@"msg"]);
        
        //退出编辑模式
        editStatus = NO;
        _editBarButtonItem.title = @"编辑";
        [_listView setEditing:NO animated:YES];
        _listView.allowsMultipleSelectionDuringEditing = NO;
        [_bottomView removeFromSuperview];
        _editNum = 0;

        if (_isDelete==0) {
            if (_total == 1) {
                [_dataArrays removeAllObjects];// 清空全部数据
            }
            
            _total = [[obj objectForKey:@"totalNum"] integerValue];
            NSArray *dataArr = [[obj objectForKey:@"list"] objectForKey:@"page"];
            for (NSDictionary *item in dataArr) {
                
                MessageBox *mBox = [[MessageBox alloc] init];
                mBox.titleName = [NSString stringWithFormat:@"关联标编号:%ld",(long)[[item objectForKey:@"bidId"] integerValue]];
                mBox.senderName = [item objectForKey:@"name"];
                mBox.messageId = [[item objectForKey:@"id"] integerValue];
    //            mBox.status = [item objectForKey:@"read_status"];
                
                if( [item objectForKey:@"time"] != nil &&![[item objectForKey:@"time"] isEqual:[NSNull null]])
                {
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[item objectForKey:@"time"] objectForKey:@"time"] doubleValue]/1000];
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                
                    NSString  *timeStr = [[dateFormat stringFromDate: date] substringWithRange:NSMakeRange(0, 19)];
                    mBox.timeStr =  [self timeDown:timeStr];
                }
                
                mBox.content = [item objectForKey:@"content"];
                [_dataArrays addObject:mBox];
            }
        
            [_listView reloadData];// 刷新表格
        
//            // 2.2秒后刷新表格UI
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                
//                [_listView reloadData];// 刷新表格
//                // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//                [self hiddenRefreshView];
//            });
            
        }else {
            
             [SVProgressHUD showSuccessWithStatus:[obj objectForKey:@"msg"]];
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
    [self hiddenRefreshView];
    //    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
    [self hiddenRefreshView];
    
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _isDelete = 0;
    _currPage = 1;
    _total = 1;
    _selectNum = 0;
    _deleteNum = 0;
    
    [self requestData];
}

- (void)footerRereshing
{
    
    _currPage++;
    
    [self requestData];
    
}

#pragma Hidden View

// 隐藏刷新视图
-(void) hiddenRefreshView
{
    if (!_listView.isHeaderHidden) {
        [_listView headerEndRefreshing];
    }
    
    if (!_listView.isFooterHidden) {
        [_listView footerEndRefreshing];
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}



//剩余时间倒计时
- (NSString *)timeDown:(NSString *)timeStr
{
    //剩余时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *senddate=[NSDate date];
    //结束时间
    NSDate *endDate = [dateFormatter dateFromString:timeStr];
    //当前时间
    NSDate *senderDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:senddate]];
    //得到相差秒数
    _time=[endDate timeIntervalSinceDate:senderDate];
    int days = ((int)_time)/(3600*24);
    DLOG(@"FDFDFDFDF IS %d",days);
//    int hours = ((int)_time)%(3600*24)/3600;
//    int minute = ((int)_time)%(3600*24)%3600/60;
//    int seconds = ((int)_time)%(3600*24)%3600%60;
    
    if (days == 0)
    {
        return [timeStr substringWithRange:NSMakeRange(11, 5)];
    }
    else if (days == -1)
    {
       return @"昨天";
    }else
    {
    
      return [timeStr substringWithRange:NSMakeRange(5, 5)];
    
    }

}

@end
