//
//  BannerView.h
//  过足瘾
//
//  Created by maShaiLi on 16/6/29.
//  Copyright © 2016年 maShaiLi. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BannerView : UIView

//传出模型的block
@property (nonatomic,copy) void(^advModelBlock)();

//不同按钮抛出blcok
@property (nonatomic,copy) void(^btnBlock)(UIButton *btn);


//api
- (void)getDataFromNet:(NSString *)url;

@end
