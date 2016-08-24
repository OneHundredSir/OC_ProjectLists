//
//  WHDWebViewController.h
//  xiaorizi
//
//  Created by HUN on 16/6/2.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHDWebViewController : UIViewController

@property(nonatomic,copy)NSString *detailStr;
@property(nonatomic,copy)NSString *path;

@property(nonatomic,strong)UIBarButtonItem *likeBtn;

@property(nonatomic,strong)UIBarButtonItem *shareBtn;

@property (weak, nonatomic) IBOutlet UIImageView *tmpIMG;

@end
