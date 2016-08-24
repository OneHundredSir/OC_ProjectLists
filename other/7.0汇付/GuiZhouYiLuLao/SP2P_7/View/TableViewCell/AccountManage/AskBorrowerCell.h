//
//  AskBorrowerCell.h
//  SP2P_7
//
//  Created by Jerry on 14-9-26.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AskBorrowerCell : UITableViewCell

@property (nonatomic,strong) UILabel *numLabel;
@property (nonatomic,strong) UILabel *questionLabel;
@property (nonatomic,strong) UILabel *answerLabel;
@property (nonatomic,strong) UILabel *questionName;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *linelabel;
@property (nonatomic,strong) UILabel *textlabel;
@property (nonatomic,strong) id object;

- (void)fillCellWithObject:(id)object;

@end
