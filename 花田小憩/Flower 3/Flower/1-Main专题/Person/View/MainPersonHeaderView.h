//
//  MainPersonHeaderView.h
//  Flower
//
//  Created by HUN on 16/7/13.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonModel;
@interface MainPersonHeaderView : UICollectionReusableView
/**
 *  传进来的personModel
 */
@property(nonatomic,strong)PersonModel *model;


@property (weak, nonatomic) IBOutlet UIButton *columBtn;
/**
 *  专栏按钮的block
 */
@property(nonatomic,copy)void (^columBlock)(UIButton *btn);

/**
 *  专栏按钮的block
 */
@property(nonatomic,copy)void (^introduceBlock)(UIButton *btn);

/**
 *  专栏按钮的block
 */
@property(nonatomic,copy)void (^bookBlock)(UIButton *btn);


//移动层面
@property(nonatomic,strong)CALayer *btnLayer;

#pragma mark 刷新按钮，扔出去block
- (IBAction)refleshColloction:(UIButton *)sender;

-(void)makeLayerWithX:(CGFloat)X;

@end
