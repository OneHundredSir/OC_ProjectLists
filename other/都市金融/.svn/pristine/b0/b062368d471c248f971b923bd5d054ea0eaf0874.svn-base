//
//  LoginWindowTextField.h
//  SP2P_7
//
//  Created by kiu on 14-6-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJComboBox.h"

@protocol LoginWindowDelegate <NSObject>

- (void)shiftAccount:(NSString *)userName;

@end

@interface LoginWindowTextField : UITextField<AJComboBoxDelegate>
@property (nonatomic, copy) NSString *placeName;
@property (nonatomic, strong) UIImageView *leftImage;
@property (nonatomic, strong) UIButton *rightImage;
@property (nonatomic, weak) id<LoginWindowDelegate> loginWindowDelegate;
@property (nonatomic,strong) NSArray *userLists;

- (UITextField *)textWithleftImage:(NSString *)leftIcon rightImage:(NSString *)rightIcon placeName:(NSString *)placeName;

@end
