//
//  SortItem.h
//  SP2P_6.0
//
//  Created by 李小斌 on 14-6-5.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    SortDefault = 0,// 未选中
	SortDesc = 1, // 降序
	SortAsc = 2,// 升序
    SortNone = 3,// 未选中
} SortState;

#define SORT_IMAGE_WIDTH 12.0f
#define SORT_IMAGE_HEIGHT 12.0f

#define LABEL_HEIGHT 20.0f

@interface SortItem : UIControl
{
    //UILabel *_nameLabel; // 名称标签
    CALayer *_sortImage;// 箭头图片
}
@property (nonatomic,strong) UILabel *nameLabel; // 名称标签
@property (nonatomic, assign) SortState sortState;

- (id)initWithFrame:(CGRect)frame andName:(NSString *)name sortImage:(NSString *)imageName state:(SortState) state;

- (void)setState:(SortState) state;

@end
