//
//  WHDImgScrollView.h
//  FootLove
//
//  Created by HUN on 16/6/29.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHDImgScrollView : UIView


#pragma mark 给一个图片连接的数组这样就可以滚动轮播了
-(void)initwhdSetAdViewWithImgUrlArr:(NSArray *)ImgUrlArr;
@end
