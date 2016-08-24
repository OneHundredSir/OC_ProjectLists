//
//  SliderViewController.m
//  BRSliderViewController
//
//  Created by gitBurning on 15/3/9.
//  Copyright (c) 2015年 BR. All rights reserved.
// 资讯（暂时没有缓存）

#import "SliderViewController.h"
#import "SliderCollectionViewCell.h"
#import "CacheUtil.h"
#import "SKYinfoCell.h"
#import "AdvertiseGallery.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kIndexCell @"SliderCollectionViewCell"

@interface SliderViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,sliderScrollerDelegate,HTTPClientDelegate>
{
    NSMutableArray *_titleArrays;
    NSMutableArray *_idArrays;
    NSMutableArray *tempArr;

}
@property (nonatomic, assign) CGFloat topWidth;
@property (nonatomic, assign) CGFloat offSet;
@property (nonatomic, strong) UIScrollView *sliderView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NetWorkClient *requestClient;
@property (nonatomic, copy) NSString *segmentFileName;

@end

@implementation SliderViewController
- (instancetype)initWithViewControllers:(NSArray *)viewControllers
{
    self = [super init];
    if (self) {
        _viewControllers = [viewControllers copy];
        
        self.selectIndex=0;
        
       // _selectedIndex = NSNotFound;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutSubview];
    
    [self initData];
    
    [self initView];
    // Do any additional setup after loading the view.
    
    //请求，默认第一个是3
}

-(void)layoutSubview{
    NSMutableArray * array=[NSMutableArray array];
    
    NSArray * titiles=@[@"工程招标",@"采购招标",@"监理招标",@"材料价格",@"中标公示",@"企业信息"];
    for (int i=0; i<titiles.count; i++) {
        UIViewController * nex=[[UIViewController alloc] init];
        
        switch (i) {
            case 0:
                nex.view.backgroundColor=[UIColor grayColor];
                break;
            case 1:
                nex.view.backgroundColor=[UIColor lightGrayColor];
                break;
            case 2:
                nex.view.backgroundColor=[UIColor blueColor];
                break;
            case 3:
                nex.view.backgroundColor=[UIColor brownColor];
                break;
            case 4:
                nex.view.backgroundColor=[UIColor greenColor];
                break;
            case 5:
                nex.view.backgroundColor=[UIColor redColor];
                break;
            default:
                break;
        }
        [array addObject:nex];
    }
    
    self.viewControllers = array;
    self.titileArray=titiles;
    self.selectColor=[UIColor blueColor];
    self.selectIndex=3;
    self.sliderDelegate=self;
}

- (void)initData
{
    _titleArrays = [[NSMutableArray alloc] init];
    _idArrays = [[NSMutableArray alloc] init];
    tempArr = [[NSMutableArray alloc] init];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //财富资讯接口（opt=130）
    [parameters setObject:@"130" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    
    _segmentFileName = [CacheUtil creatCacheFileName:parameters];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
}


-(void)setSelectColor:(UIColor *)selectColor{
    _selectColor=selectColor;
    
}

- (void)initView
{
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.offSet=64;
    
    self.topWidth=80;
    
    if (self.titileArray.count<4) {
        self.topWidth=kScreenWidth/self.titileArray.count;
    }
    if (_isNeedCustomWidth) {
        self.topWidth=100;
    }
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing=0.f;//左右间隔
    flowLayout.minimumLineSpacing=0.f;
    flowLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    self.colletionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,self.offSet,kScreenWidth,kTopViewHeight) collectionViewLayout:flowLayout];
    
    self.colletionView.delegate=self;
    self.colletionView.dataSource=self;
    
    self.colletionView.showsHorizontalScrollIndicator=NO;
    UINib *nib=[UINib nibWithNibName:kIndexCell bundle:nil];
    
    [self.colletionView registerNib: nib forCellWithReuseIdentifier:kIndexCell];
    
    
    UILabel * line=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.colletionView.frame)-0.5, kScreenWidth, 0.5)];
    line.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:line];
    [self.view addSubview:self.colletionView];
    
    CGRect frame = CGRectMake(self.indicatorInsets.left, kTopViewHeight-INDICATOR_HEIGHT+0.5, self.topWidth, INDICATOR_HEIGHT);
    _indicator = [[UIView alloc] initWithFrame:frame];
    _indicator.backgroundColor=self.selectColor;
    [self.colletionView addSubview:self.indicator];
    
    
    self.colletionView.backgroundColor=[UIColor clearColor];
    
    self.sliderView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.colletionView.frame), kScreenWidth, kScreenHeight-CGRectGetMaxY(self.colletionView.frame))];
    self.sliderView.backgroundColor=[UIColor greenColor];
    [self.view addSubview:_sliderView];
    
    
    [self.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:[UIViewController class]]) {
            UIViewController * vc=obj;
            CGRect newFrame=vc.view.frame;
            newFrame.size.height=CGRectGetHeight(self.sliderView.frame);
            newFrame.origin.x+=idx*CGRectGetWidth(self.sliderView.frame);
            newFrame.origin.y=0;
            vc.view.frame=newFrame;
            // vc.view.backgroundColor=[UIColor grayColor];
            [self.sliderView addSubview:vc.view];
            
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(newFrame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height+64) style:UITableViewStylePlain];
            _tableView.showsVerticalScrollIndicator = NO;
            _tableView.dataSource = self;
            _tableView.delegate = self;
            [self.sliderView addSubview:_tableView];
            
        }
    }];
    
    self.sliderView.delegate=self;
    self.sliderView.pagingEnabled=YES;
    self.sliderView.bounces=NO;
    self.sliderView.contentSize=CGSizeMake(CGRectGetWidth(self.sliderView.frame)*self.viewControllers.count, CGRectGetHeight(self.sliderView.frame));
    self.sliderView.showsHorizontalScrollIndicator=NO;
    
    if (self.selectIndex>0) {
        
        [self silderWithIndex:self.selectIndex isNeedScroller:NO];
    }

   
    
}


#pragma mark - 网络请求
- (void)requestData:(NSInteger)index
{
    NSLog(@"request index = %ld",(long)index);
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    
    DLOG(@"==返回成功=======%@",obj);
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        NSArray *dataArr = [obj objectForKey:@"ads"];
        if ([dataArr count]!=0) {
            for (NSDictionary *item in dataArr)
            {
                AdvertiseGallery *bean = [[AdvertiseGallery alloc] init];
                bean.title = [item objectForKey:@"title"];
                
                if ([[NSString stringWithFormat:@"%@",[item objectForKey:@"image_filename"]] hasPrefix:@"http"]) {
                    
                    bean.image = [NSString stringWithFormat:@"%@",[item objectForKey:@"image_filename"]];
                }else{
                    
                    bean.image = [NSString stringWithFormat:@"%@%@",Baseurl,[item objectForKey:@"image_filename"]];
                }
                
                bean.idStr = [item objectForKey:@"id"];
                bean.tag = [tempArr count] + 1;
                [tempArr addObject:bean];
                
            }
            [_tableView reloadData];
            
        }

        
    }else {
        
        DLOG(@"返回失败===========%@",[obj objectForKey:@"msg"]);
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        
    }
}

//-(void) processData:(NSDictionary *)dataDics isCache:(BOOL) isCache
//{
//    [_titleArrays removeAllObjects];
//    [_idArrays removeAllObjects];
//    if ([[NSString stringWithFormat:@"%@",[dataDics objectForKey:@"error"]] isEqualToString:@"-1"]) {
//        
//        if(!isCache){
//            // 非缓存数据，且返回的是-1 成功的数据，才更新数据源，否则不保存
//            NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
//            NSString *cachePath = [path stringByAppendingPathComponent:_segmentFileName];// 合成归档保存的完整路径
//            [NSKeyedArchiver archiveRootObject:dataDics toFile:cachePath];// 数据归档，存取缓存
//            
//        }
//        
//        
//        NSArray *typeArr = [dataDics objectForKey:@"types"];
//        for (NSDictionary *dic in typeArr) {
//            
//            NSString *titleStr = [dic objectForKey:@"name"];
//            NSString *idStr = [dic objectForKey:@"id"];
//            [_titleArrays addObject:titleStr];
//            [_idArrays addObject:idStr];
//        }
//        //        DLOG(@"栏目ID数组为%@",_idArrays);
//        
//        [tempArr removeAllObjects];
//        NSArray *dataArr = [dataDics objectForKey:@"ads"];
//        if ([dataArr count]!=0) {
//            for (NSDictionary *item in dataArr)
//            {
//                AdvertiseGallery *bean = [[AdvertiseGallery alloc] init];
//                bean.title = [item objectForKey:@"title"];
//                
//                if ([[NSString stringWithFormat:@"%@",[item objectForKey:@"image_filename"]] hasPrefix:@"http"]) {
//                    
//                    bean.image = [NSString stringWithFormat:@"%@",[item objectForKey:@"image_filename"]];
//                }else{
//                    
//                    bean.image = [NSString stringWithFormat:@"%@%@",Baseurl,[item objectForKey:@"image_filename"]];
//                }
//                
//                bean.idStr = [item objectForKey:@"id"];
//                bean.tag = [tempArr count] + 1;
//                [tempArr addObject:bean];
//                
//            }
//            
//        }
//        [self initView];
//        
//    }
//    else{
//        if (!isCache) {
//            
//            DLOG(@"返回失败===========%@",[dataDics objectForKey:@"msg"]);
//            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [dataDics objectForKey:@"msg"]]];
//            
//        }
//        
//    }
//    
//}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    //    [self readCache];
    // 服务器返回数据异常
    //    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}



#pragma mark---顶部的滑动试图
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    // return allSpaces.count;
    return self.titileArray.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    [self silderWithIndex:indexPath.row isNeedScroller:NO];
    
    
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SliderCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:kIndexCell forIndexPath:indexPath];
    UILabel * line=[[UILabel alloc] initWithFrame:CGRectMake(self.topWidth-0.5, 0,0.5 ,CGRectGetHeight(cell.frame)-0.5)];
    line.backgroundColor=[UIColor lightGrayColor];
    
    if (!_isNeedCustomWidth) {
        [cell insertSubview:line atIndex:cell.subviews.count-1];

    }
  
    cell.titile.text=self.titileArray[indexPath.row];
    
    if (self.selectIndex==indexPath.row) {
        cell.titile.textColor=self.selectColor;
    }
    else{
        cell.titile.textColor=[UIColor blackColor];
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(_topWidth, 44);
}

#pragma mark - 手势滑动
-(void)silderWithIndex:(NSInteger)index isNeedScroller:(BOOL)isNeed{
    
    //[self.view endEditing:YES];
    
  
    self.selectIndex=index;
    
    //滑动条动画
    [UIView animateWithDuration:0.1*(abs((int)(self.selectIndex-index))) animations:^{
        CGRect newframe=self.indicator.frame;
        newframe.origin.x=self.topWidth*index;
        self.indicator.frame=newframe;
        
    }];
    
    //整个选择列表滑动动画
    if (isNeed) {
       [self.colletionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    else{
        [self.sliderView setContentOffset:CGPointMake(kScreenWidth*index, 0) animated:YES];

    }
    
    
    
    [self.colletionView reloadData];
    
    
    if (self.sliderDelegate) {
        [self.sliderDelegate sliderScrollerDidIndex:index andSlider:self];
    }
    
#warning     NSLog(@"request data with index");
    [self requestData:index];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:self.sliderView]) {
        NSInteger index=scrollView.contentOffset.x/kScreenWidth;
        
        if (index!=self.selectIndex) {
            [self silderWithIndex:index isNeedScroller:YES];
        }
    }
}
-(id)getSelectSlider{
    return self.viewControllers[self.selectIndex];
}

#pragma mark - UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"tableView = %@",tableView);
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"cate_cell%ld",(long)indexPath.section];
    SKYinfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[SKYinfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    AdvertiseGallery *object = tempArr[indexPath.section];
    
    cell.titleLabel.text = object.title;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:object.urlStr] placeholderImage:[UIImage imageNamed:@"news_default"]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return tempArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.5f;
}

#pragma mark - sliderScrollerDelegate
-(void)sliderScrollerDidIndex:(NSInteger)index andSlider:(SliderViewController *)slider{
    
    NSString * tiitle=slider.titileArray[index];
    slider.title=tiitle;
    
    
}

@end
