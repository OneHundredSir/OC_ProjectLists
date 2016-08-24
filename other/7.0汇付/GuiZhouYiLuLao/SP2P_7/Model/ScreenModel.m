//
//  ScreenModel.m
//  SP2P_7
//
//  Created by Jerry on 14-7-11.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "ScreenModel.h"

@implementation ScreenModel
-(void)encodeWithCoder:(NSCoder *)aCoder{
    //encode properties/values
    [aCoder encodeObject:self.name    forKey:@"ScreenName"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.Tag]  forKey:@"Tag"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.Checked]     forKey:@"checked"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if((self = [super init])) {
        //decode properties/values
        self.name       = [aDecoder decodeObjectForKey:@"ScreenName"];
        self.Tag   = [[aDecoder decodeObjectForKey:@"Tag"] integerValue];
        self.Checked = [[aDecoder decodeObjectForKey:@"date"] integerValue];
    }
    
    return self;
}

@end