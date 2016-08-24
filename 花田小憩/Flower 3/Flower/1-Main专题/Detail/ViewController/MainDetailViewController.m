//
//  MainDetailViewController.m
//  Flower
//
//  Created by HUN on 16/7/11.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "MainDetailViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface MainDetailViewController ()<UIScrollViewDelegate,UIWebViewDelegate>
/**
 *  作者头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *titleIcon;

/**
 *  v头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *VIcon;
/**
 *  作者名称
 */
@property (weak, nonatomic) IBOutlet UILabel *authorName;
/**
 *  作为职位
 */
@property (weak, nonatomic) IBOutlet UILabel *authorWorkLB;

/**
 *  订阅人数
 */
@property (weak, nonatomic) IBOutlet UILabel *bookLB;

/**
 *  最后发送的时间
 */
@property (weak, nonatomic) IBOutlet UILabel *lastTime;

/**
 *  评论数目
 */
@property (weak, nonatomic) IBOutlet UILabel *discussNumLB;
/**
 *  爱心数目
 */
@property (weak, nonatomic) IBOutlet UILabel *likeNumLB;
/**
 *  看的人数
 */
@property (weak, nonatomic) IBOutlet UILabel *viewNumLB;


/**
 *  scrollView
 */
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//播放器
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property(nonatomic,weak)UIView *frameView;
@property(nonatomic,weak)UIView *mediaBackView;
@end

@implementation MainDetailViewController
{
    //分享页面
    UIView *shareView;
    //网页
    UIWebView *webView;
    //滚动条
    MBProgressHUD *hub;
    

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置右边分享按钮
    [self _initRightBtn];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
//    NSLog(@"--->又启动了");
}


#pragma mark - set方法
-(void)setModel:(MainTableModel *)model
{
    _model = model;
    
    //设置自己的个人图片
    [_titleIcon sd_setImageWithURL:[NSURL URLWithString:_model.author.headImg]];
    _titleIcon.layer.cornerRadius = _titleIcon.frame.size.width/2.0;
    _titleIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    _titleIcon.layer.borderWidth = 1;
    _titleIcon.clipsToBounds = YES;
    //设置点赞颜色,看下要不要判断
    NSString *imgStr = _model.author.newAuth==1?@"黄色v.png":@"黑色v.png";
    //    NSLog(@"%ld",_model.author.newAuth );
    _VIcon.image = [UIImage imageNamed:imgStr];
    
    /**
     *  作者名称
     */
    _authorName.text = _model.author.userName;
    /**
     *  作为职位
     */
    _authorWorkLB.text = _model.author.identity;
    
    /**
     *  订阅人数
     */
    _bookLB.text = [NSString stringWithFormat:@"已有%ld人订阅",(long)_model.author.subscibeNum];
    
    /**
     *  最后发送的时间
     */
    NSString *creatTime = _model.category.createDate;
    NSDate *date = [self convertDateFromString:creatTime];
   _lastTime.text =[self compareCurrentTime:date] ;
    
    /**
     *  评论数目
     */
    _discussNumLB.text = [NSString stringWithFormat:@"%ld", (long)_model.favo];
    /**
     *  爱心数目
     */
    _likeNumLB.text = [NSString stringWithFormat:@"%ld", (long)_model.fnCommentNum];
    /**
     *  看的人数
     */
    _viewNumLB.text = [NSString stringWithFormat:@"%d",_model.read];
 
    [self _initScrollView:_model];
}


#pragma mark 时间处理
/**
 *  字符串转时间nsdate
 */
-(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}


/**
 *  传进去时间，与先做做对比。
 */
-(NSString *) compareCurrentTime:(NSDate*) compareDate
//
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

#pragma mark - UI按钮事件
/**
 *  订阅按钮
 */
- (IBAction)bookAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    NSString *str = sender.selected?@"🤗已经添加关注":@"😱已经取消关注";
    [self alertMetionWitDetail:str];
}

/**
 *  喜欢按钮
 */
- (IBAction)likeAction:(UIButton *)sender
{
    if (sender.selected == NO) {
        sender.selected = !sender.selected;
    }else
    {
        [self alertMetionWitDetail:@"🤔已经点过赞了"];
    }
    
}

/**
 *  评论页面跳转
 */
- (IBAction)discussAction:(UIButton *)sender
{
    
}

#pragma mark - scrollview
#pragma mark 分两部分，一个是上部分的view一个是下部分的webview
static CGFloat backH = 0;
-(void)_initScrollView:(MainTableModel *)model
{
    _scrollView.frame = [UIScreen mainScreen].bounds;
    backH = _scrollView.frame.size.height *0.4;
    CGFloat backW = _scrollView.frame.size.width;
    CGFloat maginY = 5;
    UIView *backView = [[UIView alloc]initWithFrame:(CGRect){0,0,backW,backH}];
    backView.backgroundColor = [UIColor whiteColor];
    //图片
    CGFloat ImgH = backH * 0.6;
    CGFloat ImgW =backW;
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:(CGRect){0,0,ImgW-maginY*2,ImgH}];
    CGPoint center = backView.center;
    center.y = ImgH/2.0;
    imageV.center = center;
    [imageV sd_setImageWithURL:[NSURL URLWithString:model.smallIcon]];
    [backView addSubview:imageV];
    NSString *urlstr = _model.videoUrl;
    if (urlstr.length>0)
    {
        UIButton *btn = [[UIButton alloc]initWithFrame:imageV.frame];
        [btn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(mediaPlay:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:btn];
    }
    //媒体库
    _mediaBackView = backView;
    self.frameView = imageV;
    
    //label部分
    NSString *titleName = model.title;
    CGSize titleSize = [titleName sizeWithFont:font(18) constrainedToSize:(CGSize){MAXFLOAT,MAXFLOAT}];
    //判断是否超出
    titleSize.width = titleSize.width>=backView.frame.size.width?backView.frame.size.width-maginY:titleSize.width;
    UILabel *titleLB = [[UILabel alloc]initWithFrame:(CGRect){(backW-titleSize.width)/2.0,maginY*2+ImgH,titleSize.width,titleSize.height}];
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.text = titleName;
    titleLB.font =font(18);
    titleLB.textColor = [UIColor blackColor];
    [backView addSubview:titleLB];
    
    //label2种类
    NSString *detailName = [NSString stringWithFormat:@"#%@#",model.category.name];
    CGSize detailSize = [titleName sizeWithFont:font(12) constrainedToSize:(CGSize){MAXFLOAT,MAXFLOAT}];
    UILabel *detailLB = [[UILabel alloc]initWithFrame:(CGRect){0,0,detailSize.width,detailSize.height}];
    detailLB.textAlignment = NSTextAlignmentCenter;
    center.y = maginY*4+ImgH+titleLB.frame.size.height +detailSize.height/2.0;
    detailLB.center = center;
    detailLB.text = detailName;
    detailLB.font = font(12);
    detailLB.textColor = [UIColor blackColor];
    [backView addSubview:detailLB];
    
    CGFloat viewW = detailSize.width *0.8;
    CGFloat viewY = maginY + detailLB.frame.origin.y + detailSize.height;
    UIView *view = [[UIView alloc]initWithFrame:(CGRect){(backW-viewW)/2.0,viewY,viewW,2}];
    view.backgroundColor = [UIColor grayColor];
    [backView addSubview:view];
    
    //webView,一开始不允许点击
    CGFloat webH =  _scrollView.frame.size.height;
    webView = [[UIWebView alloc]initWithFrame:(CGRect){0,backH,backW,webH}];
    webView.userInteractionEnabled = NO;
    webView.delegate = self;
    NSString *urlStr = _model.pageUrl;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    webView.scrollView.bounces = NO;
    [webView loadRequest:request];
    
    
    //加载进度条
    hub = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hub.labelText = @"正在玩命加载...";
    // 设置图片
    hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableview_loading"]];
    // 再设置模式
    hub.mode = MBProgressHUDModeIndeterminate;
    hub.tintColor = [UIColor grayColor];
    // 隐藏时候从父控件中移除
    hub.removeFromSuperViewOnHide = YES;
    [hub show:YES];
    
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(backW, backH+webH);
    [_scrollView addSubview:backView];
    [_scrollView addSubview:webView];
}

-(void)mediaPlay:(UIButton *)btn
{
    [self createMPPlayerController:_model.videoUrl];
    [self.moviePlayer play];
}

- (void)createMPPlayerController:(NSString *)urlNamePath {
    NSURL *movieURL = [NSURL URLWithString:urlNamePath];
    self.moviePlayer =[[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    [self.moviePlayer prepareToPlay];
    self.moviePlayer.shouldAutoplay=YES;
    [self.moviePlayer setControlStyle:MPMovieControlStyleDefault];
    [self.moviePlayer setFullscreen:YES];
    [self.moviePlayer.view setFrame:self.frameView.frame];
//    NSLog(@"%@",NSStringFromCGRect(movewController.view));
    [_mediaBackView addSubview:self.moviePlayer.view];//设置写在添加之后   // 这里是addSubView
    
    
    //    这里注册相关操作的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.moviePlayer]; //播放完后的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieScalinedCallback:)
                                                 name:MPMoviePlayerScalingModeDidChangeNotification
                                               object:self.moviePlayer]; //播放完后的通知
}

//缩放的代码
-(void)movieScalinedCallback:(NSNotification*)notify{
    // 视频播放完或者在presentMoviePlayerViewControllerAnimated下的Done按钮被点击响应的通知。
    MPMoviePlayerController* theMovie = [notify object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    [self dismissMoviePlayerViewControllerAnimated];
    NSLog(@"--->");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//完成的通知
-(void)movieFinishedCallback:(NSNotification*)notify{
    // 视频播放完或者在presentMoviePlayerViewControllerAnimated下的Done按钮被点击响应的通知。
    MPMoviePlayerController* theMovie = [notify object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    
    [self dismissMoviePlayerViewControllerAnimated];
}

#pragma mark - 右边分享功能
-(void)_initRightBtn
{
    [self setRightBtn:@"ad_share" andTitle:nil];
    shareView = [self _setShareView];
    [self.view addSubview:shareView];
    CGFloat viewH = self.view.frame.size.height;
    CGFloat viewW = self.view.frame.size.width;
    CGFloat viewY = -viewH;
    shareView.frame = (CGRect){0,viewY,viewW,viewH};
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [shareView addGestureRecognizer:tap];
    //    设置右边分享按钮的view
    __weak typeof(shareView) weakshareView = shareView;
    self.rightBtnBlock = ^(UIButton *btn){
        btn.selected = !btn.selected;
        if (btn.selected) {
            [UIView animateWithDuration:0.25 animations:^{
                weakshareView.transform = CGAffineTransformMakeTranslation(0, viewH);
            }];
        }else
        {
            [UIView animateWithDuration:0.25 animations:^{
                weakshareView.transform = CGAffineTransformIdentity;
            }];
        }
        
    };
}

/**
 *  tap触摸事件
 */
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    __weak typeof(shareView) weakshareView = shareView;
    [UIView animateWithDuration:0.25 animations:^{
        weakshareView.transform = CGAffineTransformIdentity;
    }];
}

/**
 *  设置一个分享的页面
 */
- (UIView *)_setShareView
{
    UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    view.backgroundColor = [UIColor redColor];
    //设置毛玻璃效果
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithFrame:(CGRect){0,0,self.view.frame.size.width,self.view.frame.size.height}];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    [blurView setEffect:effect];
    [view addSubview:blurView];
    
    
//    NSArray *shareNames = @[@"微信",@"微博",@"QQ",@"朋友圈"];
    NSArray *shareImgs = @[@"weixin",@"weibo",@"qq",@"pengyouquan"];
    CGFloat magin = view.frame.size.width * 0.35;
//    NSLog(@"%@",NSStringFromCGRect([UIScreen mainScreen].bounds));
//    NSLog(@"%lf",magin);
    CGFloat btnW = (view.frame.size.width - (shareImgs.count+1)*magin)/shareImgs.count;
    CGFloat btnH = btnW + magin;
    for (int i =0; i<shareImgs.count; i++) {
        NSString *imgName = [NSString stringWithFormat:@"s_%@_50",shareImgs[i]];
        UIButton *btn = [[UIButton alloc]initWithFrame:(CGRect){magin+(magin+btnW)*i,15,btnW,btnH}];
//        [btn setTitle:shareNames[i] forState:UIControlStateNormal];
//        btn.titleLabel.font = font(10);
        [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        btn.tag = 10 + i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    
    return view;
}
/**
 *  分享按钮事件
 */
-(void)btnAction:(UIButton *)btn
{
    NSInteger index =  btn.tag;
    if (index == 10)//@"微信"
    {
        NSLog(@"微信");
    }else if (index == 11)//@"微博
    {
        NSLog(@"微博");
    }else if (index == 12)//@"QQ"
    {
        NSLog(@"QQ");
    }else if (index == 13)//@"朋友圈"
    {
        NSLog(@"朋友圈");
    }
}

#pragma mark scrollDelegate 

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView)//注意这里有两个scrollView要区分出来
    {
        webView.userInteractionEnabled = scrollView.contentOffset.y - 50 >= backH?YES:NO;
    }
}

#pragma mark webDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [hub hide:YES];
    
}

@end
