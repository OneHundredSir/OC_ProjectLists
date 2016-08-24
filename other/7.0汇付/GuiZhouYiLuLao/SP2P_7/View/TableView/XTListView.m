//
//  XTListView.m
//  XTNews
//
//  Created by tage on 14-4-30.
//  Copyright (c) 2014年 XT. All rights reserved.
//

#import "XTListView.h"
#import "XTTableViewCell.h"
#import "XTModelHandle.h"
#import "NewsObject.h"
#import "InfoNewsViewController.h"
#import "CacheUtil.h"
#define kIS_IOS7       (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_6_1)

@interface XTListView ()<UITableViewDelegate,UITableViewDataSource, FocusImageFrameDelegate,HTTPClientDelegate>
{

    NSInteger _currPage;//页数
    NSInteger _num;//识别不同网络请求
}
@property (nonatomic, strong) NSMutableArray *adArrays;
@property (nonatomic ,strong) NSMutableArray *dataSource;
@property(nonatomic ,strong) NetWorkClient *requestClient;
@property(nonatomic ,copy) NSString *infoFileName;

@end

@implementation XTListView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

            _dataSource = @[].mutableCopy;
            _currPage = 1;
    }
    return self;
}


-(void)webData:(NSString *)typeId
{
    _num = 0;
    _currPage = 1;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //财富资讯接口（opt=131）
    [parameters setObject:@"131" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:typeId forKey:@"id"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_currPage] forKey:@"currPage"];
    
    _infoFileName = [CacheUtil creatCacheFileName:parameters];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];

}
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.contentTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
     // 自动刷新(一进入程序就下拉刷新)
//    [self.contentTableView headerBeginRefreshing];
    [self headerRereshing];
    
//     2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.contentTableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _num = 0;
    _currPage = 1;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //财富资讯接口（opt=131）
    [parameters setObject:@"131" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:_typeIdStr forKey:@"id"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_currPage] forKey:@"currPage"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
}

- (void)footerRereshing
{
    _num = 1;
    _currPage ++;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //财富资讯接口（opt=131）
    [parameters setObject:@"131" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:_typeIdStr forKey:@"id"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_currPage]forKey:@"currPage"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];

}


-(void) readCache
{
    // 刷新前先加载缓存数据
    NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachePath = [path stringByAppendingPathComponent:_infoFileName];// 合成归档保存的完整路径
    NSDictionary *dics = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];// 上一次缓存数据
    [self processData:dics isCache:YES];// 读取上一次成功缓存的数据
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
//    [self readCache];
}


// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    
    
     [self processData:obj isCache:NO];// 读取当前请求到的数据
}

-(void) processData:(NSDictionary *)dataDics isCache:(BOOL) isCache
{
    if ([[NSString stringWithFormat:@"%@",[dataDics objectForKey:@"error"]] isEqualToString:@"-1"]) {

        if(!isCache){
            // 非缓存数据，且返回的是-1 成功的数据，才更新数据源，否则不保存
            NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
            NSString *cachePath = [path stringByAppendingPathComponent:_infoFileName];// 合成归档保存的完整路径
            [NSKeyedArchiver archiveRootObject:dataDics toFile:cachePath];// 数据归档，存取缓存
            
        }
     
        if (_num == 0) {
            
            [_dataSource removeAllObjects];
        }
        NSMutableArray *newArr = [[NSMutableArray alloc] init];
        NSArray *newsArr = [dataDics objectForKey:@"list"];
        if (newsArr.count) {
            
            for (NSDictionary *item in newsArr){
                
                NewsObject *object = [[NewsObject alloc] init];
                object.title = [item objectForKey:@"title"];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970: [[[item objectForKey:@"time"] objectForKey:@"time"] doubleValue]/1000];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd"];
                object.timeStr = [dateFormat stringFromDate: date];
                
                NSString *contentStr = [item objectForKey:@"content"];
                
                // *******  去掉 html字符串中所有标签  **********
                
                NSString *result = [self filterHTML:contentStr];
                DLOG(@"result -> %@", result);
                
                if(result.length < 35)
                {
                    
                    object.digest = [result   substringWithRange:NSMakeRange(0,result.length)];//截取字符串
                    
                }else {
                    
                    object.digest = [result   substringWithRange:NSMakeRange(0,35)];//截取字符串
                    
                }
                
                // *****************************
                
                //截取内容文段
//                NSError *error1;
////                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=span style=\"font-size:14px;\">).*(?=</span)" options:0 error:&error1];
//                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<[^>]+>|&nbsp;)" options:0 error:&error1];
//                DLOG(@"regex -> %@", regex);
//                
//                if (regex != nil) {
//                    NSTextCheckingResult *firstMatch=[regex firstMatchInString:contentStr options:0 range:NSMakeRange(0, [contentStr length])];
//                    
//                    if (firstMatch) {
//                        NSRange resultRange = [firstMatch rangeAtIndex:0];
//                        NSString *result = [contentStr stringByReplacingCharactersInRange:resultRange withString:@""];
//                        
//                        从contentStr当中截取数据
//                        NSString *result=[contentStr substringWithRange:resultRange];
//                        输出结果
//                          DLOG(@"->%@<-",result);
//                        
//                        if(result.length < 35)
//                        {
//                            
//                            object.digest = [result   substringWithRange:NSMakeRange(0,result.length)];//截取字符串
//                        }
//                        else
//                            object.digest = [result   substringWithRange:NSMakeRange(0,35)];//截取字符串
//                    }
//                    
//                }
                
                if (![[item objectForKey:@"image_filename"] isEqual:[NSNull null]]) {
                    if ([[item objectForKey:@"image_filename"] hasPrefix:@"http"]) {
                        
                         object.imageSRC = [NSString stringWithFormat:@"%@", [item objectForKey:@"image_filename"]];
                        
                    }else{
                        
                        object.imageSRC = [NSString stringWithFormat:@"%@%@",Baseurl, [item objectForKey:@"image_filename"]];
                    }
                    
                }
                
                object.newsId = [NSString stringWithFormat:@"%@",[item objectForKey:@"entityId"]];
                object.authorStr = [item objectForKey:@"author"];
                object.replyCount = [item objectForKey:@"read_count"];
                [newArr addObject:object];
            }
            [self reloadListViewDataSource:newArr];
            
           
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
              [self hiddenRefreshView];
        });
        if (_requestClient != nil) {
            [_requestClient cancel];
        }
        
    }
    else{
        [self hiddenRefreshView];
        if (_requestClient != nil) {
            [_requestClient cancel];
        }
        if (!isCache) {
            
            DLOG(@"返回失败===========%@",[dataDics objectForKey:@"msg"]);
                  [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [dataDics objectForKey:@"msg"]]];
       
        }
        
    }
    
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    [self hiddenRefreshView];
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
    if (_num == 0) {
        [self readCache];
    }
    
}

// 无可用的网络
-(void) networkError
{
    [self hiddenRefreshView];
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
    if (_num == 0) {
        [self readCache];
    }
    
    
}

- (void) headerViewData
{
 
    _adArrays = [[NSMutableArray alloc] init];
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:_tempArrays.count+2];
    //添加最后一张图 用于循环
    if (_tempArrays.count > 1)
    {
        AdvertiseGallery *bean = [_tempArrays objectAtIndex:_tempArrays.count-1];
        bean.tag = -1;
        [itemArray addObject:bean];
    }
    
    for (int i = 0; i < _tempArrays.count; i++)
    {
        AdvertiseGallery *bean = [_tempArrays objectAtIndex:i];
        [itemArray addObject:bean];
    }
    
    //添加第一张图 用于循环
    if (_tempArrays.count >1)
    {
        AdvertiseGallery *bean = [_tempArrays objectAtIndex:0];
        bean.tag = _tempArrays.count;
        [itemArray addObject:bean];
    }
    
    [_adArrays addObjectsFromArray:itemArray];
    
    _adScrollView = [[AdScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 160) delegate:self imageItems:_adArrays isAuto:YES];
    [self addSubview:_adScrollView];

}

- (void)addContentView
{
    _contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-50) style:UITableViewStylePlain];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    _contentTableView.tableHeaderView = _adScrollView;
   
    [self addSubview:_contentTableView];
}

- (void)reloadListViewDataSource:(NSMutableArray *)array
{
    [_dataSource addObjectsFromArray:array];
    [self.contentTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataSource.count) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 && _dataSource.count) {
        return 1;
    }
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
//       id object = _dataSource[0];
        
        static NSString *CellIdentify = @"Cell";

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentify];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentify];
            
            cell.backgroundColor = [UIColor lightGrayColor];
            
           [cell setSeparatorInset:UIEdgeInsetsMake(0, 320, 0, -320)];
        }
                
        return cell;
        
    }else{
        
       id object = _dataSource[indexPath.row];
        
        static NSString *CellIdentify = @"XTCell";
        
        XTTableViewCell *cell = (XTTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentify];
        
        if (!cell) {
            
            cell = [[XTTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentify];
            
            if (kIS_IOS7) {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, 14, 0, 14)];
            }
        }
        
        [cell fillCellWithObject:object];
        return cell;
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 0;
    }
    return [XTTableViewCell rowHeightForObject:_dataSource[indexPath.row]];
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_dataSource.count>=5) {
    
        if (indexPath.row == [_dataSource count]-2) {
            [self.contentTableView footerBeginRefreshing];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if (indexPath.section==1) {
        XTNewsObject *object = _dataSource[indexPath.row];
        DLOG(@"indexsetion is %@%@",@(indexPath.section),@(indexPath.row));
        InfoNewsViewController *InfoNewsView = [[InfoNewsViewController alloc] init];
        InfoNewsView.titleString = object.title;
        InfoNewsView.newsId = object.newsId;
        InfoNewsView.typeStr = @"返回";
        InfoNewsView.hidesBottomBarWhenPushed = YES;
        [_InformationView.navigationController pushViewController:InfoNewsView animated:YES];
        
    }
}


#pragma mark - FocusImageFrameDelegate

- (void)foucusImageFrame:(AdScrollView *)imageFrame didSelectItem:(AdvertiseGallery *)item
{
    
    DLOG(@"广告栏选中%ld",(long)item.tag);
    InfoNewsViewController *InfoNewsView = [[InfoNewsViewController alloc] init];
    InfoNewsView.titleString = item.title;
    InfoNewsView.newsId = item.idStr;
    InfoNewsView.hidesBottomBarWhenPushed = YES;
    [_InformationView.navigationController pushViewController:InfoNewsView animated:NO];
    
    
}

// 隐藏刷新视图
- (void) hiddenRefreshView
{
    if (!self.contentTableView.isHeaderHidden) {
        [self.contentTableView headerEndRefreshing];
    }
    
    if (!self.contentTableView.isFooterHidden) {
        [self.contentTableView footerEndRefreshing];
    }
}

// 去掉html字符串中所有标签
- (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    return html;
}

@end
