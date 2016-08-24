//
//  JSONString.m
//  SP2P_7
//
//  Created by Cindy on 15-6-4.
//  Copyright (c) 2015年 EIMS. All rights reserved.
//

#import "JSONString.h"

@implementation JSONString


+ (NSString *)toJSONData:(id)theData{
    
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                        
                                                       options:NSJSONWritingPrettyPrinted
                        
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        
        return  [[NSString alloc] initWithData:jsonData
                 
                                      encoding:NSUTF8StringEncoding];
    }else{
        
        return @"";
    }
    
}

@end
