//
//  PersonBookCell.h
//  Flower
//
//  Created by HUN on 16/7/13.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonModel;
@interface PersonBookCell : UICollectionViewCell


/**
 *  传进来的personModel
 */
@property(nonatomic,strong)PersonModel *model;


@end
