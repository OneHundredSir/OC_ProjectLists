//
//  KeyBoardView.h
//  testioskbui
//
//  Created by apple on 13-2-19.
//  Copyright (c) 2013年 croc0di1e. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ValidKeyboardTouchNotify <NSObject>

-(void)touchNotify:(id)sender Type:(int)itype;

@end

@interface KeyBoardViewPassGuard : UIView

@property (nonatomic, retain) id<ValidKeyboardTouchNotify> delegate;
@property (nonatomic, retain) NSMutableArray *m_viewframes;
@property (nonatomic, retain) NSMutableArray *m_views;

@property (nonatomic, retain) NSMutableArray *m_senders;
@end
