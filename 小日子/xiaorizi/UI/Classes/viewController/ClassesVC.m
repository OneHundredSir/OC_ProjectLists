//
//  ClassesVC.m
//  xiaorizi
//
//  Created by HUN on 16/6/1.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "ClassesVC.h"
#import "WHDShowModel.h"
#import "WHDClassModel.h"
#import "WHDCollectionCell.h"
#import "WHDClassHeaderView.h"



#pragma mark 跳转过去
#import "WHDClassSeletedTableView.h"
#import "WHDSOSOViewController.h"
//#import "WHDSearchViewController.m"
#define MyColloctionID @"collection"
@interface ClassesVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
//@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(nonatomic,strong)NSMutableArray<WHDClassModel *> *classModels_list;

@end

@implementation ClassesVC
#pragma mark lazyload
-(NSMutableArray *)classModels_list
{
    if (_classModels_list)return _classModels_list;
    _classModels_list=[@[] mutableCopy];
    //获取数据
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Classify" ofType:nil];
    NSData *data=[NSData dataWithContentsOfFile:path];
    NSDictionary *getDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *tempModel=getDic[@"list"];
//    NSLog(@"%@",getDic);
    //这里刚才有点小卡壳，不管，只要知道有字典先转字典，目的就是为了装模型
    for (NSDictionary *dic in tempModel) {
        WHDClassModel *model=[WHDClassModel mj_objectWithKeyValues:dic];
        [_classModels_list addObject:model];
    }
    return _classModels_list;
}

#pragma mark - viewDidload
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"分类";
    [self setUpRightBarItem];
    [self setUpView];
}

-(void)setUpRightBarItem
{
    UIBarButtonItem *toolItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(toolWay)];
    self.navigationItem.rightBarButtonItem=toolItem;
}
/**
 *  搜索工具
 */
-(void)toolWay
{
    WHDSOSOViewController *vc=[[WHDSOSOViewController alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 设置collection
-(void)setUpView
{
    //注册Cell，必须要有
    [_collectionView registerNib:[UINib nibWithNibName:@"WHDCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"WHDCollectionCell"];
    _collectionView.backgroundColor=[UIColor whiteColor];
    //注册头view
    [_collectionView registerNib:[UINib nibWithNibName:@"WHDClassHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader" withReuseIdentifier:@"WHDClassHeaderView"];
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - datasource
#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.classModels_list.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *models=self.classModels_list[section].tags;
    return models.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WHDCollectionCell  *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"WHDCollectionCell" forIndexPath:indexPath];
    NSArray *models=self.classModels_list[indexPath.section].tags;
//    NSLog(@"第%d列的有%d个",indexPath.section,models.count);
    cell.model=models[indexPath.row];
    return cell;
}

//注意这里需要注册！非常重要
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        WHDClassHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WHDClassHeaderView" forIndexPath:indexPath];
        
        NSString *title = _classModels_list[indexPath.section].title;
        NSLog(@"headerTitle:%@",title);
        headerView.lbTitle.text = title;
        
//        headerView.backgroundColor=[UIColor yellowColor];
        reusableview = headerView;
        
    }
    return reusableview;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(90, 90);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5,10, 5, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){VIEWW,60};
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *models=self.classModels_list[indexPath.section].tags;
    WHDShowModel *model=models[indexPath.row];
    NSString *title=model.name;
    WHDClassSeletedTableView *showVC=[[WHDClassSeletedTableView alloc]init];
    showVC.title=title;
    showVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:showVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
