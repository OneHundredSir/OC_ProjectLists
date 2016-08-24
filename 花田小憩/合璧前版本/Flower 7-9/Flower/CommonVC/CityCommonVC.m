//
//  CityCommonVC.m
//  Flower
//
//  Created by HUN on 16/7/9.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "CityCommonVC.h"

@interface CityCommonVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *cityTableView;

@property(nonatomic,strong)NSDictionary *areaListDic;

@property(nonatomic,strong)NSMutableArray *cityGroupArr;


@end

@implementation CityCommonVC
#pragma mark - 懒加载（lazyload）

-(NSDictionary *)areaListDic
{
    if (_areaListDic == nil) {
        _areaListDic = [NSMutableDictionary dictionary];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"country.plist" ofType:nil];
        NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:path];
        _areaListDic = dic ;
    }
    return _areaListDic;
}

-(NSMutableArray *)cityGroupArr
{
    if (_cityGroupArr ==nil) {
        _cityGroupArr = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"country.plist" ofType:nil];
        NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:path];
//        NSLog(@"%@",dic);
        //获取数据
        [_cityGroupArr addObjectsFromArray:dic.allKeys];
        //让数组排序
        [_cityGroupArr sortUsingSelector:@selector(compare:)];
//        NSLog(@"%@",_cityGroupArr);//测试用
    }
    return _cityGroupArr;
}


#pragma mark - 加载视图 （system）
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];

    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    __weak CityCommonVC *weakSelf = self;
    
    self.leftBtnBlock = ^(UIButton *btn){
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
}


#pragma mark - tableView
#pragma mark delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *string = self.areaListDic[self.cityGroupArr[indexPath.section]][indexPath.row];
    if (self.Seletedblock) {
        self.Seletedblock(string);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.areaListDic.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *cityArr = self.areaListDic[self.cityGroupArr[section]];
//    NSLog(@"%@",cityArr);
    return cityArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    //获取一段包含中文和非中文的例如:"英属维尔京群岛+1340"
    NSString *string = self.areaListDic[self.cityGroupArr[indexPath.section]][indexPath.row];
    NSString *CZstring = @"";
    NSString *Telstring = @"";
    for (int i =0 ; i<string.length; i++) {
        int a = [string characterAtIndex:i];
        if (!(a > 0x4e00 && a < 0x9fff)) {
           CZstring = [CZstring stringByAppendingString:[string substringWithRange:(NSRange){0,i}]];
           Telstring = [Telstring stringByAppendingString:[string substringWithRange:(NSRange){i,string.length-i}]];
            break;
        }
    }
    NSLog(@"%@,%@",CZstring,Telstring);
    
    cell.textLabel.text = CZstring;
    cell.detailTextLabel.text = Telstring;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.cityGroupArr[section];
}
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(5_0)
{
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender NS_AVAILABLE_IOS(5_0)
{
    return YES;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *arr = [@[] mutableCopy];
    [arr addObjectsFromArray:self.cityGroupArr];
    return arr;
}

@end
