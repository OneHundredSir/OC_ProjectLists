//
//  SortItemGrop.m
//  SP2P_6.0
//
//  Created by 李小斌 on 14-6-5.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "SortItemGrop.h"

#import "SortItem.h"

#import "ColorTools.h"

@interface SortItemGrop()
{
    NSArray *_sortArrays;
    UIView *_line;
    int _currentPosition;
}

@end

@implementation SortItemGrop

- (id) initWithFrame:(CGRect)frame sortArrays:(NSArray *) arrays defaultPosition:(int) position
{
    self = [super initWithFrame:frame];
    if (self) {
        _sortArrays = arrays;
        
        for (SortItem *sortView in _sortArrays) {
            [sortView addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        _line.backgroundColor = PinkColor;
        [self addSubview:_line];
        
        [self setPosition:position];
    }
    return self;
}

- (void) itemClick:(id)sender
{
     for (SortItem *sortView in _sortArrays) {
         if(sortView != sender){
            [sortView setState:SortDefault];
         }else {
            [UIView animateWithDuration:0.25 animations:^(void){
                _line.frame =CGRectMake(sortView.frame.origin.x-2, 0, sortView.frame.size.width, self.frame.size.height);
            }];
            int position = (int) [_sortArrays indexOfObject:sortView];
            if(position == _currentPosition){
                if([sortView sortState] == SortDesc){
                    [sortView setState:SortAsc];
                }else if([sortView sortState] == SortAsc){
                    [sortView setState:SortDesc];
                }
             }else {
                [sortView setState:SortDesc];// 恢复上次排序
                
             }
             _currentPosition = position;
         }
         
    }
    
    
   
}

- (void) setPosition:(int) position
{
    SortItem *sortView = _sortArrays[position];
    [self itemClick:sortView];
}

@end
