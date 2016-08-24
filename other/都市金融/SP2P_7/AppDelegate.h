

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "UserInfo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UserInfo *userInfo;

@property (strong, nonatomic) NSString *openType;

@property (strong, nonatomic) NSString *appId;
@property (strong, nonatomic) NSString *channelId;
@property (strong, nonatomic) NSString *userId;

@end

