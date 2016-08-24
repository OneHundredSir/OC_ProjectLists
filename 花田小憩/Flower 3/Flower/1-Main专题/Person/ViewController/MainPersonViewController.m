//
//  MainPersonViewController.m
//  Flower
//
//  Created by HUN on 16/7/13.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "MainPersonViewController.h"

#import "PersonColumnCell.h"
#import "PersonIntroduceCell.h"
#import "PersonBookCell.h"
#import "MainPersonHeaderView.h"
#import "IntroduceModel.h"
#import "ColumModel.h"
#import "AuthorModel.h"
@interface MainPersonViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

//专栏数据
@property(nonatomic,strong)NSMutableArray *columnArr;

//介绍
@property(nonatomic,strong)NSMutableArray *introduceArr;

//订阅者
@property(nonatomic,strong)NSMutableArray *bookArr;



@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(nonatomic,assign)CGFloat introH;

@end


@implementation MainPersonViewController
#pragma mark lazyLoad;
-(NSMutableArray *)columnArr
{
    if (_columnArr == nil) {
        _columnArr = [NSMutableArray array];
    }
    return _columnArr;
}

-(NSMutableArray *)introduceArr
{
    if (_introduceArr == nil) {
        _introduceArr = [NSMutableArray array];
    }
    return _introduceArr;
}

-(NSMutableArray *)bookArr
{
    if (_bookArr == nil) {
        _bookArr = [NSMutableArray array];
    }
    return _bookArr;
}

#pragma mark 各类set方法
-(void)setPersonModel:(PersonModel *)personModel
{
    _personModel = personModel;
}

#pragma mark 视图生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initView];
}

#pragma mark 初始化
static NSInteger statueNum = 0;
-(void)_initView
{
    [_collectionView registerNib:[UINib nibWithNibName:columnCell bundle:nil] forCellWithReuseIdentifier:columnCell];
    [_collectionView registerNib:[UINib nibWithNibName:introduceCell bundle:nil] forCellWithReuseIdentifier:introduceCell];
    [_collectionView registerNib:[UINib nibWithNibName:bookCell bundle:nil] forCellWithReuseIdentifier:bookCell];
    [_collectionView registerNib:[UINib nibWithNibName:PersonHeadV bundle:nil]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:PersonHeadV ];
 
    self.collectionView.alwaysBounceVertical = YES;
    
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (statueNum == 0)//专栏
        {
            [self webRequestForcolumn];
            columIndex++;
        }else if (statueNum == 1)//介绍
        {
           
        }else //订阅者
        {
            [self webRequestForBook];
            bookIndex++;
        }
        
    }];
    [_collectionView.mj_footer beginRefreshing];

}


#pragma mark - delegate


#pragma mark - datasource
#pragma mark 有多少个section
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    if (statueNum == 0)//专栏
//    {
//        return 1;
//    }else if (statueNum == 1)//介绍
//    {
//        return self.introduceArr.count;
//    }else //订阅者
//    {
//        return self.bookArr.count;
//    }
//}
#pragma mark section里面的
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (statueNum == 0)//专栏
    {
        return self.columnArr.count;
    }else if (statueNum == 1)//介绍
    {
        return self.introduceArr.count;
//        return 1;
    }else //订阅者
    {
        return self.bookArr.count;
//        return 1;
    }
}

static NSString *columnCell = @"PersonColumnCell";
static NSString *introduceCell = @"PersonIntroduceCell";
static NSString *bookCell = @"PersonBookCell";
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (statueNum == 0)//专栏
    {
       PersonColumnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:columnCell forIndexPath:indexPath];
        
        cell.model = self.columnArr[indexPath.row];
        return cell;
    }else if (statueNum == 1)//介绍
    {
        PersonIntroduceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:introduceCell forIndexPath:indexPath];
        cell.model = self.introduceArr[indexPath.row];
        self.introH = [cell personIntroduceHeight];
        return cell;
    }else //订阅者
    {
        PersonBookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bookCell forIndexPath:indexPath];
        
        cell.model = self.bookArr[indexPath.row];
        return cell;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout<布局>

#pragma mark - 设置头部
static NSString *PersonHeadV = @"MainPersonHeaderView";

 static NSInteger columIndex = 0;
 static NSInteger bookIndex = 0;
static BOOL isFirstForLayer = YES;
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        MainPersonHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:PersonHeadV forIndexPath:indexPath];
        headerView.model = self.personModel;
        
        reusableview = headerView;
        [headerView layoutIfNeeded];
        if (isFirstForLayer == YES) {
            [headerView makeLayerWithX:0];
            isFirstForLayer = NO;
        }
        
        #pragma mark - //设置数据刷新按钮事件
#pragma mark 请求专栏数据
        headerView.columBlock = ^(UIButton *btn)
        {
            statueNum = 0;
            columIndex = 0;
            [self.columnArr removeAllObjects];
            [_collectionView reloadData];
            [self webRequestForcolumn];
            
        };
        
#pragma mark 请求介绍数据
        headerView.introduceBlock = ^(UIButton *btn)
        {
            statueNum = 1;
            
            [self.introduceArr removeAllObjects];
            [_collectionView reloadData];
            [self webRequestForIntroduce];
        };
        
#pragma mark 请求订阅者数据
        headerView.bookBlock = ^(UIButton *btn)
        {
            
            //action=getMySubscibeAuthor
            //currentPageIndex=0
            //pageSize=15
            //userId=4a3dab7f-1168-4a61-930c-f6bc0f989f32
            statueNum = 2;
            
            bookIndex = 0;
            [self.bookArr removeAllObjects];
            [_collectionView reloadData];
            [self webRequestForBook];
            
        };
        
        
        
    }
    
    
    
    return reusableview;
}

#pragma mark 网络请求的二次封装包
/**
 *  请求专栏的网络加载
 */
-(void)webRequestForcolumn
{
    
    NSMutableDictionary *paramters = [@{} mutableCopy];
    NSString *indexPage = [NSString stringWithFormat:@"%ld",(long)columIndex];
    [paramters setObject:indexPage forKey:@"currentPageIndex"];
    [paramters setObject:@"5" forKey:@"pageSize"];
    [paramters setObject:self.personModel.id forKey:@"userId"];
    [WHDHttpRequest getUserColumnWithparamters:paramters andandCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *resultArr = dic[@"result"];
            if (resultArr.count>0) {
                [_collectionView.mj_footer endRefreshing];
            }else
                [_collectionView.mj_footer endRefreshingWithNoMoreData];
            for (NSDictionary *getDic in resultArr) {
                ColumModel *model = [ColumModel mj_objectWithKeyValues:getDic];
                model.authorModel = getDic[@"author"];
                [self.columnArr addObject:model];
            }
            [_collectionView reloadData];
        }else
        {
            NSLog(@"出现错误%@",error);
        }
    }];
}

/**
 *  请求介绍的网络加载
 */
-(void)webRequestForIntroduce
{
    
    [WHDHttpRequest getUserIntroduceWithuserId:self.personModel.id andandCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *resultDic = dic[@"result"];
            
            NSArray *listArr = resultDic[@"listContent"];
//            NSLog(@"%@",listArr);
            if (listArr.count>0) {
                [_collectionView.mj_footer endRefreshing];
            }else
                [_collectionView.mj_footer endRefreshingWithNoMoreData];
            
            for (NSDictionary *getDic in listArr) {
                IntroduceModel *model = [IntroduceModel mj_objectWithKeyValues:getDic];
                [self.introduceArr addObject:model];
            }
            [_collectionView reloadData];
            
        }else
        {
            NSLog(@"出现错误%@",error);
        }
    }];
    
}


/**
 *  请求预定的网络加载
 */
-(void)webRequestForBook
{
    [self.bookArr removeAllObjects];
    [_collectionView reloadData];
    NSMutableDictionary *paramters = [@{} mutableCopy];
    NSString *indexPage = [NSString stringWithFormat:@"%ld",(long)bookIndex];
    [paramters setObject:indexPage forKey:@"currentPageIndex"];
    [paramters setObject:@"5" forKey:@"pageSize"];
    [paramters setObject:self.personModel.id forKey:@"userId"];
    
    [self.bookArr removeAllObjects];
    [WHDHttpRequest getUserBookWithparamters:paramters andandCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *getArr = dic[@"result"];
            
            if (getArr.count>0) {
                [_collectionView.mj_footer endRefreshing];
            }else
                [_collectionView.mj_footer endRefreshingWithNoMoreData];
//            NSLog(@"%@",getArr);
            for (NSDictionary *getDic in getArr) {
                PersonModel *model = [PersonModel mj_objectWithKeyValues:getDic];
                if (![self.bookArr containsObject:model]) {
                    [self.bookArr addObject:model];
                }
            }
            
            [_collectionView reloadData];
            
        }else
        {
            NSLog(@"出现错误%@",error);
        }
    }];
}

#pragma mark 控制每个CELL的的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){k_width,k_height*0.25};
}

#pragma mark cell大小
static CGFloat maginX = 5;
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat columW = (k_width-3*maginX)/2.0;
    CGFloat columH = k_height * 0.33;
    
    CGFloat introBookW = k_width-2*maginX;
//    CGFloat introH = 30;
    CGFloat bookH = 40;
    if (statueNum == 0)//专栏
    {
        return (CGSize){columW,columH};
    }else if (statueNum == 1)//介绍
    {
        return (CGSize){introBookW,self.introH};
    }else //订阅者
    {
        return (CGSize){introBookW,bookH};
    }
}


#pragma mark 实现间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return (UIEdgeInsets){maginX,maginX,maginX,maginX};
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return maginX;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.01;
}
@end
