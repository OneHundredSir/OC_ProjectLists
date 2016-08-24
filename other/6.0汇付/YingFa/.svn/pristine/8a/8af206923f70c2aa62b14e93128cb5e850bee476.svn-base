//
//  HomeListView.m
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-17.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "HomeListView.h"

#import "FullInvestmentTableViewCell.h"
#import "InvestmentTableViewCell.h"

#import "Investment.h"

#import "HomeHeaderView.h"

#import "BorrowingDetailsViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "ColorTools.h"

#define kIS_IOS7                (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_6_1)

@interface HomeListView ()<UITableViewDelegate, UITableViewDataSource>
{
    
    NSInteger _qualityNum;
    NSInteger _fullNum;
    
}
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIScrollView *scrollView1;
@property (nonatomic, strong) NSMutableArray *qualityIdArr;
@property (nonatomic, strong) NSMutableArray *fullyIdArr;
@end

@implementation HomeListView

- (id)initWithFrame:(CGRect)frame type:(HomeListViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
    
        _dataSource = @[].mutableCopy;
        
        
        [self initData];
        [self initView];
//        [self addContentView];
    }
    return self;
}

- (void)initData
{
    _qualityArr = [[NSMutableArray alloc] init];
    _fullyArr =  [[NSMutableArray alloc] init];
    _qualityIdArr = [[NSMutableArray alloc] init];
    _fullyIdArr = [[NSMutableArray alloc] init];

}

- (void)initView
{
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 15,self.frame.size.width, 40)];
    _scrollView.contentSize =  CGSizeMake(3*self.frame.size.width, 0);
    _scrollView.pagingEnabled =YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    _scrollView.bounces=NO; //反弹效果
    _scrollView.alwaysBounceVertical=YES;
    _scrollView.delegate = nil;
//    _scrollView.userInteractionEnabled = NO;
    _scrollView.alwaysBounceHorizontal=YES;
    
    
    
    _scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 15,self.frame.size.width, 40)];
    _scrollView1.contentSize =  CGSizeMake(3*MSWIDTH, 0);
    _scrollView1.pagingEnabled =YES;
    _scrollView1.scrollEnabled = YES;
    _scrollView1.showsHorizontalScrollIndicator=NO;
    _scrollView1.showsVerticalScrollIndicator = NO;
    [_scrollView1 setBackgroundColor:[UIColor clearColor]];
    _scrollView1.bounces=NO; //反弹效果
    _scrollView1.alwaysBounceVertical=YES;
    _scrollView1.delegate = nil;
//    _scrollView1.userInteractionEnabled = NO;
    _scrollView1.alwaysBounceHorizontal=YES;
    
    [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
   [NSTimer scheduledTimerWithTimeInterval:35.0f target:self selector:@selector(scrollTimer1) userInfo:nil repeats:YES];
}

-(void)layoutSubviews
{
    __weak typeof(self) weakSelf = self;
    
    [weakSelf reloadListViewDataSource:_dataSource.copy];
   
}



- (void)addContentView:(NSMutableArray *)qualityArrr qualitydata:(NSMutableArray *)qualitydataArrr qualityIdArr:(NSMutableArray *)qualityIdArrr  full:(NSMutableArray *)fullyArr fullData:(NSMutableArray *)fullydataArr fullIdArr:(NSMutableArray *)fullIdArrr
{
 
    _contentTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _headerView1 = [[HomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 56)];
    
    if(_type == HomeListViewTypeQuality){
        
        //滚动栏ID数组
        if (qualityIdArrr!= nil) {
            _qualityIdArr = qualityIdArrr;
//            DLOG(@"qully arr is %@",_qualityIdArr);
        }
        
        
        for (UIView *view in [_scrollView subviews]) {
            [view removeFromSuperview];
        }
        [_headerView1 addSubview:_scrollView];
        
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 62, 55)];
        backView.backgroundColor = GreenColor;
        [_headerView1 addSubview:backView];
        
        
        UILabel *qualityLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 5, 50, 30)];
        qualityLabel.text = @"优质";
        qualityLabel.textColor = [UIColor whiteColor];
        qualityLabel.font =  [UIFont fontWithName:@"Arial-BoldMT" size:15];
        [_headerView1 addSubview:qualityLabel];
        UILabel *qualityLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(7, 21, 80, 30)];
        qualityLabel2.text = @"借款标";
        qualityLabel2.textColor = [UIColor whiteColor];
        qualityLabel2.font =  [UIFont fontWithName:@"Arial-BoldMT" size:15];
        [_headerView1 addSubview:qualityLabel2];
        
        _headerView1.title.text = @"TA在借款";
        if(qualityArrr.count)
        {
             _qualityNum =  qualityArrr.count;
            for (int i =0; i < [qualityArrr count];i++)
            {
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*self.frame.size.width+75, 2, self.frame.size.width-90, 35)];
                label.font = [UIFont boldSystemFontOfSize:13.0f];
                label.text = [qualityArrr objectAtIndex:i];
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[qualityArrr objectAtIndex:i]];
                [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:NSMakeRange(0, str.length)];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, str.length)];
                NSInteger nameLen = [[qualitydataArrr objectAtIndex:i*2] integerValue];
                NSInteger amountLen = [[qualitydataArrr objectAtIndex:i*2+1] integerValue];
                [str addAttribute:NSForegroundColorAttributeName value:BluewordColor range:NSMakeRange(0,nameLen+2)];
                [str addAttribute:NSForegroundColorAttributeName value:GreenColor range:NSMakeRange(nameLen+2+1+17,amountLen+1)];
                
                
                label.attributedText = str;
                label.numberOfLines = 0;
                label.userInteractionEnabled = YES;
                label.lineBreakMode = NSLineBreakByCharWrapping;
                //label.textColor = [UIColor darkGrayColor];
                label.tag = i;
                [_scrollView addSubview:label];
    
                UITapGestureRecognizer *tapClick1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
                UIView *tapview = [tapClick1 view];
//                tapview.tag = label.tag;
                tapClick1.numberOfTapsRequired = 1;
                tapClick1.numberOfTouchesRequired = 1;
                tapClick1.view.backgroundColor = [UIColor redColor];
                [label addGestureRecognizer:tapClick1];
                
                
            }
            
        }

        
    }else  if(_type == HomeListViewTypeFull){
        
        
        //滚动栏ID数组
        if (fullIdArrr != nil) {
            _fullyIdArr = fullIdArrr;
//            DLOG(@"full arr is %@",_fullyIdArr);
        }
        
        for (UIView *view in [_scrollView1 subviews]) {
            [view removeFromSuperview];
        }
        
        [_headerView1 addSubview:_scrollView1];
        
       
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 62, 55)];
        backView.backgroundColor = GreenColor;
        [_headerView1 addSubview:backView];
        
        UILabel *fullLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 50, 30)];
        fullLabel.text = @"最新";
        fullLabel.textColor = [UIColor whiteColor];
        fullLabel.font =  [UIFont fontWithName:@"Helvetica-Bold" size:15];
        [_headerView1 addSubview:fullLabel];
        UILabel *fullLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 21, 80, 30)];
        fullLabel2.text = @"满标";
        fullLabel2.textColor = [UIColor whiteColor];
        fullLabel2.font =  [UIFont fontWithName:@"Helvetica-Bold" size:15];
        [_headerView1 addSubview:fullLabel2];
        
        
        _headerView1.title.text = @"TA在理财";
        if(fullyArr.count){
             _fullNum = fullyArr.count;
        for (int i =0; i < [fullyArr count];i++)
        {
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(i * self.frame.size.width + 75, 2, self.frame.size.width - 90, 35)];

            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[fullyArr objectAtIndex:i]];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:NSMakeRange(0, str.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, str.length)];
            NSInteger nameLen = [[fullydataArr objectAtIndex:i * 2] integerValue];
            NSInteger amountLen = [[fullydataArr objectAtIndex:i * 2 + 1] integerValue];
            [str addAttribute:NSForegroundColorAttributeName value:BluewordColor range:NSMakeRange(0, nameLen + 2)];
            [str addAttribute:NSForegroundColorAttributeName value:GreenColor range:NSMakeRange(nameLen + 2 + 1 + 5,amountLen+1)];
            
            label2.attributedText = str;
            label2.userInteractionEnabled = YES;
            label2.numberOfLines = 0;
            label2.lineBreakMode = NSLineBreakByCharWrapping;
            label2.tag = i;
            [_scrollView1 addSubview:label2];
            
            UITapGestureRecognizer *tapRg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick1:)];
            UIView *tapview = [tapRg view];
            tapview.backgroundColor = [UIColor greenColor];
            tapRg.numberOfTapsRequired = 1;
            tapRg.numberOfTouchesRequired = 1;
            [label2 addGestureRecognizer:tapRg];
        }
            
       }
     

    }
    _contentTableView.tableHeaderView = _headerView1;
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    _contentTableView.scrollEnabled = NO;
    [self addSubview:_contentTableView];
    
}

- (void)reloadListViewDataSource:(NSArray *)array
{
    [_dataSource removeAllObjects];
    
    [_dataSource addObjectsFromArray:array];

    [self.contentTableView reloadData];
}

- (void)tapClick:(UITapGestureRecognizer *)tapV
{
    DLOG(@"点击事件");
    UIView *tapview = [tapV view];
    DLOG(@"kkkkkkkkkkk 111111111 %ld",(long)tapview.tag);
    BorrowingDetailsViewController *BorrowingDetailsView = [[BorrowingDetailsViewController alloc] init];
    BorrowingDetailsView.borrowID = [NSString stringWithFormat:@"%@",_qualityIdArr[tapview.tag]];
    BorrowingDetailsView.hidesBottomBarWhenPushed = YES;
    [_HomeNAV.navigationController pushViewController:BorrowingDetailsView animated:NO];
    
}

- (void)tapClick1:(UITapGestureRecognizer *)tapV
{
    
    DLOG(@"点击事件");
    UIView *tapview = [tapV view];
    DLOG(@"kkkkkkkkkkk %ld",(long)tapview.tag);
    BorrowingDetailsViewController *BorrowingDetailsView = [[BorrowingDetailsViewController alloc] init];
    BorrowingDetailsView.borrowID = [NSString stringWithFormat:@"%@",_fullyIdArr[tapview.tag]];
    BorrowingDetailsView.hidesBottomBarWhenPushed = YES;
    [_HomeNAV.navigationController pushViewController:BorrowingDetailsView animated:YES];
    
}


/**
 *  填充对象
 *
 */
- (void)fillTableWithObject:(id)object
{
    _dataSource = object;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cate_cell";
    if (_type == HomeListViewTypeQuality){
        InvestmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[InvestmentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.calculatorView.hidden = YES;
        if (kIS_IOS7) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 14, 0, 14)];
        }
        Investment *object = [_dataSource objectAtIndex:indexPath.row];
        
        [cell fillCellWithObject:object];
        return cell;
    } else if(_type == HomeListViewTypeFull){
        FullInvestmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[FullInvestmentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        if (kIS_IOS7) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 14, 0, 14)];
        }
        Investment *object = [_dataSource objectAtIndex:indexPath.row];
        
        [cell fillCellWithObject:object];
        return cell;

    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == HomeListViewTypeQuality){
        return 80;
    }else if(_type == HomeListViewTypeFull){
        return 80;
    }
     return 80;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_type == HomeListViewTypeQuality){
        
        Investment *object = [_dataSource objectAtIndex:indexPath.row];
        if (![object.title isEqualToString:@"无数据"]) {
            BorrowingDetailsViewController *BorrowingDetailsView = [[BorrowingDetailsViewController alloc] init];
            BorrowingDetailsView.borrowID = object.borrowId;
            BorrowingDetailsView.hidesBottomBarWhenPushed = YES;
            [_HomeNAV.navigationController pushViewController:BorrowingDetailsView animated:NO];
        }
      
    }else if(_type == HomeListViewTypeFull){
        
        Investment *object = [_dataSource objectAtIndex:indexPath.row];
        if (![object.title isEqualToString:@"无数据"]) {
        BorrowingDetailsViewController *BorrowingDetailsView = [[BorrowingDetailsViewController alloc] init];
        BorrowingDetailsView.borrowID = object.borrowId;
        BorrowingDetailsView.hidesBottomBarWhenPushed = YES;
        [_HomeNAV.navigationController pushViewController:BorrowingDetailsView animated:NO];
            
        }
    }

}


//定时滚动
int timeCount = 0;
-(void)scrollTimer{
    timeCount ++;
    
    if (timeCount == _qualityNum) {
        timeCount = 0;
    }
    
    // DLOG(@"定时滚动！！！！！！！！！！！00000%d",timeCount);
    //[self.scrollView scrollRectToVisible:CGRectMake(timeCount * self.frame.size.width, 0, self.frame.size.width,50.0) animated:YES];
    switch (timeCount) {
        case 0:
        {
            
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
            break;
        case 1:
        {
            
            [_scrollView setContentOffset:CGPointMake(MSWIDTH, 0) animated:YES];
        }
            break;
            
        case 2:
        {
            
            [_scrollView setContentOffset:CGPointMake(MSWIDTH*2, 0) animated:YES];
        }
            break;
            
    }
    
}

//定时滚动
int timeCount1 = 0;
-(void)scrollTimer1
{
    timeCount1 ++;
    
    if (timeCount1 == _fullNum) {
        timeCount1 = 0;
    }
    
    switch (timeCount1) {
        case 0:
        {
          
            [_scrollView1 setContentOffset:CGPointMake(0, 0) animated:YES];
        }
            break;
        case 1:
        {
           
            [_scrollView1 setContentOffset:CGPointMake(MSWIDTH, 0) animated:YES];
        }
            break;
            
        case 2:
        {
       
            [_scrollView1 setContentOffset:CGPointMake(MSWIDTH*2, 0) animated:YES];
        }
            break;

    }
    
}


@end
