//
//  RepaymentcalculatorCell.m
//  SP2P_7
//
//  Created by kiu on 14/11/13.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "RepaymentcalculatorCell.h"
#import "RepaymentcalculatorMode.h"

@interface RepaymentcalculatorCell ()

@property (nonatomic , strong) id object;

@property (nonatomic,strong) UILabel *num;
@property (nonatomic,strong) UILabel *monPay;
@property (nonatomic,strong) UILabel *stillPay;

@end

@implementation RepaymentcalculatorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _num = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 60, 30)];
        _num.textAlignment = NSTextAlignmentCenter;
        _num.font = [UIFont systemFontOfSize:14];
        [self addSubview:_num];
        
        // 月还本息
        _monPay = [[UILabel alloc] initWithFrame:CGRectZero];
        _monPay.textAlignment = NSTextAlignmentCenter;
        _monPay.textColor = [UIColor redColor];
        _monPay.font = [UIFont systemFontOfSize:14];
        [self addSubview:_monPay];
        
        // 本息余额
        _stillPay = [[UILabel alloc] initWithFrame:CGRectZero];
        _stillPay.textColor = [UIColor redColor];
        _stillPay.textAlignment = NSTextAlignmentCenter;
        _stillPay.font = [UIFont systemFontOfSize:14];
        [self addSubview:_stillPay];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.object) {
        
        if ([self.object isMemberOfClass:[RepaymentcalculatorMode class]]) {
            RepaymentcalculatorMode *object = self.object;
            
            _num.frame = CGRectMake(10, 5, 60, 30);
            _monPay.frame = CGRectMake(80, 5, 120, 30);
            _stillPay.frame = CGRectMake(190, 5, 100, 30);
            
            _num.text = object.num;
            _monPay.text = object.monPay;
            _stillPay.text = object.stillPay;
        }
    }
}

- (void)fillCellWithObject:(id)object
{
    self.object = object;
}

@end
