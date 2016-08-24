//
//  WHDFunViewController.m
//  FootLove
//
//  Created by HUN on 16/6/30.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDFunViewController.h"
#import "WHDFunTableViewCell.h"
@interface WHDFunViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation WHDFunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configTable];
}

-(void)configTable
{
    //配置下面
    [_myTableView registerNib:[UINib nibWithNibName:@"WHDFunTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WHDFunTableViewCell"];
    _myTableView.estimatedRowHeight = 1000;
    _myTableView.rowHeight = UITableViewAutomaticDimension;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WHDFunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WHDFunTableViewCell"];
    
    return cell;
}

@end
