#小日子objective-C
---
>##这里用到的库

####1、MBProgressHUD (弹窗)
####2、MJExtension（字典转模型）
####3、MJRefresh（上下拉刷新）
####4、SDWebImage（网络图片下载）

>##库的使用

- [x] 注意这下面只是这里用，这里只是介绍了这里用到的，具体学习请参考每个第三方的demo的使用

####1、MBProgressHUD (弹窗)
```
/**
 *  布置提示框
 */
-(void)setUpHub:(NSString *)show
{
    //初始化进度框，置于当前的View当中
    _Hub = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_Hub];
    //如果设置此属性则当前的view置于后台
    _Hub.dimBackground = YES;
    
    _Hub.mode=MBProgressHUDModeDeterminate;
    
    //设置对话框文字
    _Hub.labelText = show;

    
    //显示对话框
    [_Hub showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        sleep(1);
    } completionBlock:^{
        //操作执行完后取消对话框
        [_Hub removeFromSuperview];
        _Hub = nil;
    }];
}

```

####2、MJExtension（字典转模型）

```
#pragma mark - lazy load
-(NSMutableArray *)firModel_list
{
    if (_firModel_list) {
        return _firModel_list;
    }
    _firModel_list=[@[] mutableCopy];
    NSString *path=[[NSBundle mainBundle]pathForResource:@"events" ofType:nil];
    //把JSON数据转换成字典
    NSData *data=[NSData dataWithContentsOfFile:path];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //获取字典中的数组,------->这里就是用到了第三方的转模型
    //WHDFirModel这只是自定义的字典模型
    NSArray *getArr=dic[@"list"];
    for (NSDictionary *realDic in getArr) {
        WHDFirModel *model=[WHDFirModel mj_objectWithKeyValues:realDic];
        [_firModel_list addObject:model];
    }
    
    return _firModel_list;
}


```

####3、MJRefresh（上下拉刷新）

```
 _table.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
 [NSTimer scheduledTimerWithTimeInterval:2 target:self  selector:@selector(stopme) userInfo:nil repeats:NO];
 }];

 _table.mj_footer=[MJRefreshAutoFooter footerWithRefreshingBlock:^{
 [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(stopme) userInfo:nil repeats:NO];
 }];
 _table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
 }];
 

结束刷新有几种方法
if (data) {
     [_table.mj_header endRefreshing];
}else{
[_table.mj_footer endRefreshingWithNoMoreData];
}
 [_table.mj_header endRefreshing];

```

####4、SDWebImage（网络图片下载）

```
----导入：UIImageView+WebCache----
[firCell.backImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"mebackground"]];

```

>##简单的库实现，如果喜欢的朋友麻烦帮忙点个赞哈～入门的朋友可以练练手

![展示图片](http://ww3.sinaimg.cn/mw690/79b09a4djw1f4ovgf1gxyg20900fr7wk.gif)

[github地址](https://github.com/OneHundredSir/OC_smallDay):https://github.com/OneHundredSir/OC_smallDay


#多说无益，功能介绍，附上gif动态图展示

>左上角选择地图

![左上角选择地图.gif](http://upload-images.jianshu.io/upload_images/1730495-6c446ba0acdac61a.gif?imageMogr2/auto-orient/strip)

>顶部scrollView与tableView

![顶部scrollView与tableView.gif](http://upload-images.jianshu.io/upload_images/1730495-c94b36c0ccc3ccde.gif?imageMogr2/auto-orient/strip)

>广告页面

![广告页面.gif](http://upload-images.jianshu.io/upload_images/1730495-129cab8c43597a9c.gif?imageMogr2/auto-orient/strip)
>collectionView

![collectionView.gif](http://upload-images.jianshu.io/upload_images/1730495-cafaf48b6ccef44f.gif?imageMogr2/auto-orient/strip)

>search功能

![search.gif](http://upload-images.jianshu.io/upload_images/1730495-9e08f09217175f75.gif?imageMogr2/auto-orient/strip)

>我的页面功能

![我的.gif](http://upload-images.jianshu.io/upload_images/1730495-f4126be6dc2e2cb8.gif?imageMogr2/auto-orient/strip)

这个是demo
这个案例中用到的第三方框架自己参考参考,不是一定要用也可以自己封装
```
pod 'MJRefresh', '~> 3.1.9'
pod 'SDWebImage'
pod 'XMPPFramework'
pod 'FMDB'
pod 'MBProgressHUD'
pod 'IQKeyboardManager'
pod 'MJExtension', '~> 3.0.11'
```

**[FootLove-OC  Demo](https://github.com/OneHundredSir/FootLove-OC)**

项目仿写请勿用于商业～仅供学习交流，如有侵犯公司商业权益请联系我的微信:hundreda，我将及时处理相关信息
我的个人简书地址 项目仿写请勿用于商业～仅供学习交流，如有侵犯公司商业权益请联系我的微信:hundreda，我将及时处理相关信息
喜欢的朋友可以赏我2块大洋买糖吃～和我一样屌丝的朋友希望能给我点个

##赠人点赞，手留余香~~~~

![点赞图片](http://ww4.sinaimg.cn/large/79b09a4djw1f4ovo4t9afg20v008d74x.gif)
