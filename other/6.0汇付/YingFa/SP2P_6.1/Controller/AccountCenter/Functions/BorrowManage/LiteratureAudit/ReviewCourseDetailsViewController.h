//
//  ReviewCourseDetailsViewController.h
//  SP2P_6.1
//
//  Created by Jerry on 14-7-30.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiteratureAudit.h"

@interface ReviewCourseDetailsViewController : UIViewController

@property(nonatomic, strong) LiteratureAudit *literatureAudit;
@property(nonatomic, strong) NSString *signId;

@end
