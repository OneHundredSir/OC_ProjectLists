//
//  BaseViewController.m
//  Flower
//
//  Created by HUN on 16/7/7.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "BaseViewController.h"

#import "CityCommonVC.h"
#import "WebCommonVC.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置背景指定的颜色
    [self.view setBackgroundColor:mainColor];
    //默认是不显示的
    self.tabBarController.tabBar.hidden = YES;

    
}
#pragma mark 使用viewWillAppear让主页面现实tabar
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTranslucent:YES];
    
    __weak BaseViewController *weakSelf = self;
    if (self.isMainView) {
        self.tabBarController.tabBar.hidden = NO;
    }else
    {
        [self setLeftBtn:@"back"  andTitle:nil];
        self.leftBtnBlock = ^(UIButton *btn){
            [weakSelf popVC];
        };
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark 传进来判断是否主页的

-(void)_isloginStateWithNotoViewControllerName:(NSString *)VCname
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (delegate.isLogin == NO) {
        BaseViewController *vc = [NSClassFromString(@"LoginViewController") new];
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        if (![VCname isEqualToString:@""]) {
            //同传进来的VC启动
            BaseViewController *vc = [NSClassFromString(@"VCname") new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}


#pragma mark 设置判断是否主页面，主页面需要现实tabar，默认navitation


-(void)setIsMainView:(BOOL)isMainView
{
    _isMainView = isMainView;
    
}


static  CGFloat magin = 5;
/** 设置左边的按钮 */
-(void)setLeftBtn:(NSString *)iconStr andTitle:(NSString *)titleStr
{
    UIButton *leftBtn=[[UIButton alloc]init];
    if (iconStr || titleStr) {
        UIImage *imag = [UIImage imageNamed:iconStr];
        CGSize fontSize = [titleStr sizeWithFont:font(13) constrainedToSize:(CGSize){MAXFLOAT,44}];
        [leftBtn setImage:imag forState:UIControlStateNormal];
        //        NSLog(@"%@",NSStringFromCGSize(fontSize));
        leftBtn.frame = CGRectMake(magin, 0, fontSize.width+magin+imag.size.width, 44);
        [leftBtn setTitle:titleStr forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else if (iconStr || !titleStr)
    {
        UIImage *imag = [UIImage imageNamed:iconStr];
        leftBtn.frame = CGRectMake(magin, 0, imag.size.width+magin, 44);
        [leftBtn setImage:imag forState:UIControlStateNormal];
    }else
    {
        CGSize fontSize = [titleStr sizeWithFont:font(13) constrainedToSize:(CGSize){MAXFLOAT,44}];
        //        NSLog(@"%@",NSStringFromCGSize(fontSize));
        leftBtn.frame = CGRectMake(magin, 0, fontSize.width+magin, 44);
        [leftBtn setTitle:titleStr forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [leftBtn addTarget:self action:@selector(leftWay:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=item;
}

-(void)setLeftBtnIcon:(NSString *)iconStr andLeftBtnSeletdIcon:(NSString *)seletedStr
{
    UIButton *leftBtn=[[UIButton alloc]init];
    
    UIImage *imag = [UIImage imageNamed:iconStr];
    leftBtn.frame = CGRectMake(magin, 0, imag.size.width, imag.size.width);
    [leftBtn setImage:imag forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:seletedStr] forState:UIControlStateSelected];
    
    [leftBtn addTarget:self action:@selector(leftWay:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=item;
}

/** 设置右边的按钮 */
-(void)setRightBtn:(NSString *)iconStr andTitle:(NSString *)titleStr
{
    UIButton *rightBtn=[[UIButton alloc]init];
    if (iconStr)
    {
        UIImage *imag = [UIImage imageNamed:iconStr];
        rightBtn.frame = CGRectMake(magin, 0, imag.size.width+magin, 44);
        [rightBtn setImage:imag forState:UIControlStateNormal];
    }else if (iconStr && !titleStr)
    {
        UIImage *imag = [UIImage imageNamed:iconStr];
        rightBtn.frame = CGRectMake(magin, 0, imag.size.width+magin, 44);
        [rightBtn setImage:imag forState:UIControlStateNormal];
    }else
    {
        NSAttributedString *string = [[NSAttributedString alloc]initWithString:titleStr attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:font(13),NSStrokeWidthAttributeName:[NSNumber numberWithFloat:4]}];
        
        CGSize fontSize = [titleStr sizeWithFont:font(13) constrainedToSize:(CGSize){MAXFLOAT,44}];
        rightBtn.frame = CGRectMake(magin, 0, fontSize.width+magin, 44);
        [rightBtn setAttributedTitle:string forState:UIControlStateNormal];
        [rightBtn setTitle:titleStr forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [rightBtn addTarget:self action:@selector(rightWay:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}

/** 设置顶部 */
-(void)setViewTitle:(NSString *)title
{
    UILabel *titleLB = [[UILabel  alloc]initWithFrame:(CGRect){0,0,100,44}];
    titleLB.text = title;
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.textColor = [UIColor blackColor];
    titleLB.font=font(14);
    self.navigationItem.titleView = titleLB;
}




#pragma mark 方法实现
//左边方法实现
-(void)leftWay:(UIButton *)btn
{
    if (_leftBtnBlock) {
        _leftBtnBlock(btn);
    }
}

-(void)rightWay:(UIButton *)btn
{
    if (_rightBtnBlock) {
        _rightBtnBlock(btn);
    }
}

#pragma mark 推栈出去
-(id)PushVC:(NSString *)classStr andName:(NSString *)name isPush:(BOOL)isPush
{
    BaseViewController *vc = [NSClassFromString(classStr) new];
    [vc setViewTitle:name];
    //默认推出去的view是固定的
    vc.view.frame = CGRectMake(0, 0, k_width, k_height);
    //如果不推出去的话就自己玩去吧
    if (isPush) {
        [self.navigationController pushViewController:vc animated:YES];
    }
    return vc;
}

#pragma mark 出栈//多一个判断
-(void)popVC
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark 扔出去给Login的几种方法
#pragma mark - 自己写的方法
- (BOOL)valiMobile:(NSString *)mobile{
    if (mobile.length < 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}

#pragma mark 不带block的提示框
-(void)alertMetionWitDetail:(NSString *)detailTitle
{
    UIAlertController *AlertVC = [UIAlertController alertControllerWithTitle:@"提示" message: detailTitle preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OKAciton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [AlertVC addAction:OKAciton];
    [self presentViewController:AlertVC animated:YES completion:nil];
}

#pragma mark 带block的提示框
-(void)alertMetionWitDetail:(NSString *)detailTitle andFinishBlock:(void(^)())block
{
    UIAlertController *AlertVC = [UIAlertController alertControllerWithTitle:@"提示" message: detailTitle preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OKAciton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block();
        }
    }];
    [AlertVC addAction:OKAciton];
    [self presentViewController:AlertVC animated:YES completion:^{
        
    }];
}

-(void)webRequestLoginWithUserName:(NSString *)userName AndPassword:(NSString *)pwd andFinishBlock:(void(^)(NSData *  data, NSURLResponse *  response, NSError *  error))finishBlock
{
    NSString *webPath = [NSString stringWithFormat:@"http://218.244.138.142:8083/bdt/rest/userIntf/login?mobile=%@&password=%@",userName,pwd];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:webPath]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (finishBlock) {
            finishBlock(data,response,error);
        }
    }];
    [task resume];
}

#pragma mark 判断是不是登陆的状态
-(void)isLoginSatueWith:(BaseViewController *)targetVC
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    RootViewController *rootVc = [self getRootViewController];
    if (delegate.isLogin == NO) {
        if(rootVc.isBackFromLogin == YES)
        {
            //我采取的方法就是设置多一个属性做判断，放在系统的单例中做逻辑运算
            //因为跳转回来的时候会不断的进入willapear，所以会不断重复的跳出来
            rootVc.tabarVc.selectedIndex = 1;
            rootVc.isBackFromLogin = NO;
        }else
        {
            LoginViewController *vc = [LoginViewController new];
            CGFloat statueHeight = 22;
            vc.view.frame =(CGRect){0,statueHeight,k_width,k_height-statueHeight};
            [self presentViewController:vc animated:YES completion:nil];
        }
    }else
    {
        if (targetVC!=nil) {
            [self.navigationController pushViewController:targetVC animated:YES];
        }
    }
    
}

//获取根视图的控制器
-(id)getRootViewController
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    RootViewController *rootVc = (RootViewController *)delegate.window.rootViewController;
    return rootVc;
}

#pragma mark 跳转到城市页面
-(CityCommonVC *)showCityView
{
    CityCommonVC *cityVC = [CityCommonVC new];
    BaseNavigationViewController *navi = [[BaseNavigationViewController alloc]initWithRootViewController:cityVC];
//    CGFloat statueHeight = 22;
//    navi.view.frame = (CGRect){0,0,k_width,k_height-statueHeight};
    [cityVC setViewTitle:@"选择国家和地区"];
    cityVC.modalTransitionStyle = UIModalPresentationPageSheet;
//    [self.navigationController pushViewController:navi animated:YES];
    [self presentViewController:navi animated:YES completion:nil];
    
    return cityVC;
}
#pragma mark 跳转到网页,传一个值进去
-(void)showWebViewWithUrlString:(NSString *)string
{
    WebCommonVC *webView = [WebCommonVC new];
    webView.UrlString = string;
    BaseNavigationViewController *navi = [[BaseNavigationViewController alloc]initWithRootViewController:webView];
    [webView setViewTitle:@"服务条款"];
    webView.modalTransitionStyle = UIModalPresentationCurrentContext;
    //    [self.navigationController pushViewController:navi animated:YES];
    [self presentViewController:navi animated:YES completion:nil];
    
}


@end
