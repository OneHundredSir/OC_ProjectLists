//
//  AdvertiseGallery.m
//  SP2P_7
//
//  Created by 李小斌 on 14-6-20.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "AdvertiseGallery.h"


@implementation AdvertiseGallery

- (id)initWithTitle:(NSString *)title image:(NSString *)image tag:(NSInteger)tag url:(NSString *)urlStr id:(NSString *)idStr
{
    self = [super init];
    if (self) {
        self.title = title;
        self.image = image;
        self.urlStr = urlStr;
        self.tag = tag;
        self.idStr = idStr;
    }
    return self;
}


- (instancetype)initWithDict:(NSDictionary *)item
{
    if (self = [super init]) {
        self.title = [item objectForKey:@"title"];
        if ([[item objectForKey:@"image_filename"] hasPrefix:@"http"]) {
            
            self.image = [NSString stringWithFormat:@"%@",[item objectForKey:@"image_filename"]];
            
        }else {
            
            self.image = [NSString stringWithFormat:@"%@%@",Baseurl,[item objectForKey:@"image_filename"]];
            
        }
        self.urlStr = [item objectForKey:@"url"];
        self.tag = 1;

    }
    return self;
}
@end
