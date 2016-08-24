//
//  BarButtonItem.h
//  QYGW
//
//  Created by 李小斌 on 14-4-10.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarButtonItem : UIBarButtonItem

@property (nonatomic,strong) UIImage *normalImage;
@property (nonatomic,strong) UIImage *selectedImage;
@property (nonatomic,strong) UIButton *customButton;

@property (nonatomic) SEL customAction;
@property (nonatomic,strong) id customTarget;

/**
 * Create and return a new bar button item.
 * @param image The image of the button to show when unselected. Works best with images under 44x44.
 * @param selectedImage The image of the button to show when the button is tapped. Works best with images under 44x44.
 * @param target The target of the selector
 * @param action The selector to perform when the button is tapped
 *
 * @return An instance of the new button to be used like a normal UIBarButtonItem
 */
+(BarButtonItem *) barItemWithImage:(UIImage *) image selectedImage: (UIImage *) image target:(id) target action:(SEL) action;

- (void)setNormalImage:(UIImage *)image;

- (void)setSelectedImage:(UIImage *)image;

- (void)setCustomAction:(SEL)action;


@end
