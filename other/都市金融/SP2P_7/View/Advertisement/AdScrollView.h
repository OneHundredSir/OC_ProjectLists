

#import <UIKit/UIKit.h>
#import "AdvertiseGallery.h"
#import "InformationViewController.h"

@class AdScrollView;

#pragma mark - FocusImageFrameDelegate
@protocol FocusImageFrameDelegate <NSObject>
@optional
- (void)foucusImageFrame:(AdScrollView *)imageFrame didSelectItem:(AdvertiseGallery *)item;
- (void)foucusImageFrame:(AdScrollView *)imageFrame currentItem:(int)index;

@end


@interface AdScrollView : UIView<UIGestureRecognizerDelegate, UIScrollViewDelegate>
{
    BOOL _isAutoPlay;
}
- (id)initWithFrame:(CGRect)frame delegate:(id<FocusImageFrameDelegate>)delegate imageItems:(NSArray *)items isAuto:(BOOL)isAuto;

- (id)initWithFrame:(CGRect)frame delegate:(id<FocusImageFrameDelegate>)delegate focusImageItems:(AdvertiseGallery *)items, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithFrame:(CGRect)frame delegate:(id<FocusImageFrameDelegate>)delegate imageItems:(NSArray *)items;
- (void)scrollToIndex:(int)aIndex;

#pragma mark 改变添加视图内容
-(void)changeImageViewsContent:(NSArray *)aArray;

@property (nonatomic, assign) id<FocusImageFrameDelegate> delegate;
@property (nonatomic,strong)InformationViewController *InformationVC;

@end
