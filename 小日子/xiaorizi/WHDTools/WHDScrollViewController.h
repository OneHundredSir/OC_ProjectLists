//
//  WHDScrollViewController.h
//  xiaorizi
//
//  Created by HUN on 16/6/1.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WHDscrollViewViewDelegate;

@interface WHDScrollViewController : UIView<WHDscrollViewViewDelegate>
{
    __unsafe_unretained id <WHDscrollViewViewDelegate> _delegate;
}

@property (nonatomic, assign) id <WHDscrollViewViewDelegate> delegate;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *imageViewAry;

@property (nonatomic, readonly) UIScrollView *scrollView;

@property (nonatomic, readonly) UIPageControl *pageControl;

-(void)shouldAutoShow:(BOOL)shouldStart;

@end

@protocol WHDscrollViewViewDelegate <NSObject>

@optional
- (void)didClickPage:(WHDScrollViewController *)view atIndex:(NSInteger)index;

@end
