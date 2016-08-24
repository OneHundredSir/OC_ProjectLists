//
//  WHDYaoYiYao.m
//  
//
//  Created by HUN on 16/6/1.
//
//

#import "WHDYaoYiYao.h"

@interface WHDYaoYiYao ()
@property (weak, nonatomic) IBOutlet UIImageView *upPart;
@property (weak, nonatomic) IBOutlet UIImageView *downpart;

@property(nonatomic,assign)__block CGRect upRect;
@property(nonatomic,assign)__block CGRect downRect;
@end

@implementation WHDYaoYiYao

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"摇一摇";
    
    self.upRect=self.upPart.frame;
    self.downRect=self.downpart.frame;
    
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 并让自己成为第一响应者
    [self becomeFirstResponder];
}
static CGFloat magin=30;
//用touch测试测试而已
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    
//    NSLog(@"开始摇动");
//    CGFloat magin=30;
//    [UIView animateWithDuration:0.5 animations:^{
//        self.upPart.transform=CGAffineTransformTranslate(self.upPart.transform, 0, -magin);
//        self.downpart.transform=CGAffineTransformTranslate(self.downpart.transform, 0, magin);
//    }];
//
//    
//}
//-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [UIView animateWithDuration:0.5 animations:^{
//        self.upPart.transform=CGAffineTransformTranslate(self.upPart.transform, 0, magin);
//        self.downpart.transform=CGAffineTransformTranslate(self.downpart.transform, 0, -magin);
//    }];
//}
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    NSLog(@"开始摇动");
    CGFloat magin=30;
    [UIView animateWithDuration:0.5 animations:^{
        self.upPart.transform=CGAffineTransformTranslate(self.upPart.transform, 0, -magin);
        self.downpart.transform=CGAffineTransformTranslate(self.downpart.transform, 0, magin);
    }];
    
    return;
}

// 摇一摇取消摇动
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"取消摇动");
    return;
}

// 摇一摇摇动结束
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
        NSLog(@"摇动结束");
        [UIView animateWithDuration:0.5 animations:^{
            self.upPart.transform=CGAffineTransformTranslate(self.upPart.transform, 0, magin);
            self.downpart.transform=CGAffineTransformTranslate(self.downpart.transform, 0, -magin);
        }];
    }
    return;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
