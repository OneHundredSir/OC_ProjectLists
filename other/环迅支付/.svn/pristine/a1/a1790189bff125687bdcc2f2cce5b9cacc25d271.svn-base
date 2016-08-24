//
//  MyTextField.h
//  testinputview
//
//  Created by pro on 12-1-30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyBoardViewPassGuard.h"
#define KEY_NONE_CHAOS          0x00
#define KEY_CHAOS_SWITCH_VIEW   0x01
#define KEY_CHAOS_PRESS_KEY     0x02
#define SHOW_ANIMATTION         0x04
#define KEY_NONE_KEY_PRESS      KEY_NONE_CHAOS
#define KEY_IPAD_KEY_PRESS      KEY_CHAOS_SWITCH_VIEW
#define KEY_IPHONE_KEY_PRESS    KEY_CHAOS_PRESS_KEY

@protocol instertWebviewTextDelegate <NSObject>
-(void)instertWText;
@end

@protocol OnCharDelegate<NSObject>
-(void)OnChar:(id)sender Char:(NSString*)inchar;
@end

@protocol DoneDelegate<NSObject>
-(void)DoneFun:(id)sender;
@end

void *NewBase64Decode(
                      const char *inputBuffer,
                      size_t length,
                      size_t *outputLength);

@interface PassGuardTextField : UITextField <ValidKeyboardTouchNotify, UITextInput>
{
@private
    UIView *m_curinputView;
    //UIView *m_curinputAccessoryView;
    NSTimer *m_timer;
    NSTimer *m_dotDelayTimer;
    
    UIView *m_inputView;
    UIView *m_inputPureNumView;
    UIView *m_inputNumView;
    UIView *m_inputSpecialcharView;
    UIView *m_inputCharView;
    
    NSString *m_strStore;
    bool m_shiftflag;
    bool m_capsflag;
    bool m_borientation;
    bool m_mode;

    int m_iSimple;
    int m_iStatus;
    int Xorkey[5];
    bool m_isStandardCharKeyboard;
    
    
    
@public
    
    NSString *m_strInput1;
    NSString *m_strInput2;
    NSString *m_strInput3;
    NSString *m_strInputX;
    NSString *m_strInputY;
    NSString *m_strInputR1;
    NSString *m_strInputR2;
    NSString *m_strInputR3;
    
    bool m_hasstatus;
    bool m_bsupportrotate;
    int  m_iMaxLen;
    bool m_bMaxLenTips;
    bool m_doubleclicked;
    
    id <instertWebviewTextDelegate> webdelegate;
}

@property (nonatomic) bool m_isEnablePaste;      //是否允许复制粘贴
@property (nonatomic) bool m_isDotDelay;         //密文是否延迟显示
@property (nonatomic) bool m_mode;               //输入框明密文模式
@property (nonatomic) bool m_hasstatus;          //设置键盘的按键状态，true表示有按键状态，false表示无按键状态。（默认为有状态）
@property (nonatomic) bool m_bsupportrotate;     //是否支持旋转
@property (nonatomic, retain) NSString *m_strInput1; //设置随机字符串，用来产生AES密钥（需要与解密端字符串同步）
@property (nonatomic, retain) NSString *m_strInput2; //设置RSA加密公钥。

@property (nonatomic, retain) NSString *m_strInput3; //保留属性，一般用来设置RSA算法填充。
@property (nonatomic, retain) NSString *m_strInputX;
@property (nonatomic, retain) NSString *m_strInputY;

@property (nonatomic, retain) NSString *m_strInputR1;//设置键盘输入正则规则,用来匹配字符框中已经输入字符
@property (nonatomic, retain) NSString *m_strInputR2;//设置正则表达式，供isMatch()函数使用
@property (nonatomic, retain) NSString *m_strInputR3;//设置键盘输入正则规则,用来过滤正在输入字符
@property (nonatomic, retain) NSString *m_license;   //控件正常运行所需的license，分为生产版和测试版，此处为appName＋boudleId
@property (nonatomic) int  m_iSimple;
@property (nonatomic) int  m_iStatus;
@property (nonatomic) bool m_isResignFirstRes;
@property (nonatomic) int  m_iMaxLen;     //设置密文最大可输入长度
@property (nonatomic) bool m_bMaxLenTips; //输入超过最大字符弹框提示
@property (nonatomic) bool m_isDebug;       //设置true为反调试模式
//UIKeyboardType keyboardType 设置键盘类型，设置UIKeyboardTypeNumberPad为全数字键盘，否则默认为全键盘。

@property (nonatomic) int m_ikeyordertype;  //控制键盘乱序功能：
                                            //KEY_NONE_CHAOS，表示不乱序（默认）；
                                            //KEY_CHAOS_SWITCH_VIEW，表示在初始化键盘和切换键盘的时候乱序；
                                            //KEY_CHAOS_PRESS_KEY，表示按下非功能键后乱序；
                                            //可组合使用。
@property (nonatomic) int m_ikeypresstype;  //控制按下键后的效果（该键放大并上浮，松开后恢复原状）：
                                            //KEY_NONE_KEY_PRESS，表示无效果（默认）；
                                            //KEY_IPAD_KEY_PRESS，表示使用ipad设备才有效果
                                            //KEY_IPHONE_KEY_PRESS，表示使用iphone设备才有效果；
                                            //可组合使用

@property (assign,nonatomic) id<instertWebviewTextDelegate> webdelegate;//web端/dutrust，输入框返回字符*方法，用于网页js回调
@property(nonatomic,assign)  id <OnCharDelegate> _onchardelegate;//dutrust专用接口

@property (assign,nonatomic) id<DoneDelegate> _DoneDelegate;//键盘推出时候的事件委托实现
@property (retain,nonatomic) id m_uiapp; //设置该属性为当前应用实例对象即可，即[UIApplication sharedApplication]。

- (id)  initWithMode:(bool)bmode;  //定义文本框内内容的显示方式

+ (void)initPassGuardCtrl;         //静态初始化接口，首先调用以对控件资源进行初始化。

- (NSString *)      getOutput1;
- (NSString *)      getOutput2;
- (NSInteger)       getOutput3;
- (NSString *)      getOutput4:(int)certype;//certype 分别为1、2、3、4；
                                            //1：标准版公钥格式
                                            //2：3081或3082公钥格式
                                            //3：证书格式
                                            //4：base64编码短公钥格式
- (NSString *)      getOutput5;
- (NSString *)      getOutput6;
- (NSString *)      getOutput7;
- (NSString *)      getOutputPassGuardVersion;
- (NSArray  *)      getInputLevel;
- (bool)            isMatch;
- (void)            Clean;

- (float)getKeyboardHeight;//获取键盘高度，dutrust专用接口
- (void)forcelayoutkeyboard;

@end
