//
//  JSModel.h
//  JoinTheFoot
//
//  Created by skd on 16/6/27.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSModel : NSObject
//当亲状态
@property (nonatomic,strong) id current_state;
//距离
@property (nonatomic,strong) id distance;

@property (nonatomic,strong) id fans_num;

@property (nonatomic,strong) id focus_num;

@property (nonatomic,strong) id image_path;

@property (nonatomic,strong) id invite_code;

@property (nonatomic,strong) id member_id;

@property (nonatomic,strong) id member_name;

@property (nonatomic,strong) id member_type;

@property (nonatomic,strong) id mobile_guid;

@property (nonatomic,strong) id shop_name;

@property (nonatomic,strong) id skill;

@property (nonatomic,strong) id v_score;

@property (nonatomic,strong) id v_totle;

@property (nonatomic,strong) id video_path
;
@property (nonatomic,strong) id work_id;


- (instancetype)initWithDic:(NSDictionary *)dic;
@end
