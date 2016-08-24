//
//  AJBorrowerInfoCell.m
//  SP2P_7
//
//  Created by Ajax on 16/3/18.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJBorrowerInfoCell.h"
#import "AJBorrowerInfoCellModel.h"

@interface AJBorrowerInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;


@end
@implementation AJBorrowerInfoCell

- (void)setAAJBorrowerInfoCellModel:(AJBorrowerInfoCellModel *)aAJBorrowerInfoCellModel
{
    _aAJBorrowerInfoCellModel = aAJBorrowerInfoCellModel;
    
    self.title.text = aAJBorrowerInfoCellModel.title;
    self.content.userInteractionEnabled = aAJBorrowerInfoCellModel.canEdit;
    
    self.content.text = aAJBorrowerInfoCellModel.content;
}

@end
