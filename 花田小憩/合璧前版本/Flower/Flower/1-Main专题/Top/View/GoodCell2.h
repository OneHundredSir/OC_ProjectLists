//
//  GoodCell2.h
//  Flower
//
//  Created by HUN on 16/7/12.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArticleModel;

@interface GoodCell2 : UITableViewCell

@property(nonatomic,strong)ArticleModel *model;

//扔出去的网络没有数据直接把排列好的输出了sort = indexpath.row+1
@property(nonatomic,assign)NSInteger sort;

@end
