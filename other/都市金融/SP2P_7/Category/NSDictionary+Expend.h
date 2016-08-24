//
//  NSDictionary+Format.h
//  P2P
//
//  Created by lirifu_p2p on 15-5-25.
//  Copyright (c) 2015年 sls001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Expend)

- (NSString*) strForKey:(NSString *) key;
- (NSInteger) intForKey:(NSString *) key;

- (NSString *) strForKey:(NSString *) key formatEnd:(NSString*) format;
- (NSString *) strForKey:(NSString *) key formatStart:(NSString*) format;

- (Boolean*) isNullForKey:(NSString *)key;

#pragma mark error值是否为-1
- (Boolean*) errorIsOk ;

@end
