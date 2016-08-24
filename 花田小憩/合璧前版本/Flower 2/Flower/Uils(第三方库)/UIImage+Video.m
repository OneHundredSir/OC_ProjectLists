//
//  UIImage+Video.m
//  Flower
//
//  Created by HUN on 16/7/12.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "UIImage+Video.h"
#import <AVFoundation/AVFoundation.h>
@implementation UIImage (Video)


+(UIImage *)videoTransformFromUrl:(NSString *)url
{
    //根据视频的URL创建AVURLasset
    AVURLAsset *asset = [[AVURLAsset alloc]initWithURL:[NSURL URLWithString:url] options:nil];
    //根据AVURLasset创建对象
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    
    //定义获取0侦处额视频截图
    CMTime time = CMTimeMake(600, 10);
    NSError *error = nil;
    CMTime actualTime;
    //获取time视频截图
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    //讲CGimage转化威image
    UIImage *imageL = [[UIImage alloc]initWithCGImage:image];
    return imageL;
}

@end
