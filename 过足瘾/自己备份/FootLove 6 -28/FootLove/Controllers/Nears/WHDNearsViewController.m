//
//  WHDNearsViewController.m
//  FootLove
//
//  Created by HUN on 16/6/27.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDNearsViewController.h"
#import "WHDNearsCollectionViewCell.h"

@interface WHDNearsViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *myColloction;

@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegment;

@property (weak, nonatomic) IBOutlet UIView *segBackView;



@end

@implementation WHDNearsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setViewTitle:@"过足瘾"];
    
    [self _initItem];
}

-(void)_initItem
{
    //设置segment
    [_mySegment setTintColor:[UIColor whiteColor]];
    _segBackView.backgroundColor = W_BackColor;
    
    
    //设置collection
    [_myColloction registerNib:[UINib nibWithNibName:@"WHDNearsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"Cell"];
    _myColloction.backgroundColor = W_viewColor;
}


#pragma mark - colloction

#pragma mark datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 40;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WHDNearsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}

#pragma mark layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){100,100};
}


@end
