//
//  AJBorrowerInfoCoontroller.m
//  SP2P_7
//
//  Created by Ajax on 16/3/18.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJBorrowerInfoCoontroller.h"
#import "AJBorrowerInfoCell.h"
#import "AJBorrowerInfoCellModel.h"
#import "AJBorrowerInfo.h"

@interface AJBorrowerInfoCoontroller ()
@property (nonatomic, strong) NSDictionary *responseObj;
@end

static NSString * const reuseIdentifier = @"AJBorrowerInfoCell";
@implementation AJBorrowerInfoCoontroller

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KblackgroundColor;
    [self.tableView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.allowsSelection = NO;
    [self fillArrayWithBorrowerInfo:nil];
}

- (void)setResponseObj:(NSDictionary *)responseObj
{
    _responseObj = responseObj;
    
    AJBorrowerInfo *info = [AJBorrowerInfo objectWithKeyValues:responseObj];
    [self fillArrayWithBorrowerInfo:info];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)fillArrayWithBorrowerInfo:(AJBorrowerInfo *)info
{
    if (info != nil) {
    
        if (self.ipsAcctNo == YES) {
            
            if ([AppDelegateInstance.userInfo.ipsAcctNo isEqual:[NSNull null]]) {
                self.ipsAcctNo = YES;
            }else if (!AppDelegateInstance.userInfo.ipsAcctNo.length>0){
                
                 self.ipsAcctNo = YES;// 在个人中心时确定是否可以编辑，是否汇付开户
            }else{
                
                self.ipsAcctNo = NO;
            }
        }
        DLOG(@"%@", AppDelegateInstance.userInfo.ipsAcctNo);
        AJBorrowerInfoCellModel *model1 = [AJBorrowerInfoCellModel new];
        model1.title = @"企业名称";
        model1.content = info.companyName;
        model1.canEdit = self.ipsAcctNo;
        
        AJBorrowerInfoCellModel *model2 = [AJBorrowerInfoCellModel new];
        model2.title = @"营业执照编号";
        model2.content = info.businessLicense;
        model2.canEdit = NO;
        
        AJBorrowerInfoCellModel *model3 = [AJBorrowerInfoCellModel new];
        model3.title = @"组织机构代码";
        model3.content = info.orgCode;
        model3.canEdit = self.ipsAcctNo;
        
        AJBorrowerInfoCellModel *model4 = [AJBorrowerInfoCellModel new];
        model4.title = @"税务登记号";
        model4.content = info.taxRegistrationCode;
        model4.canEdit = self.ipsAcctNo;
        NSArray *group1 = @[model1, model2, model3, model4];
        
        AJBorrowerInfoCellModel *model5 = [AJBorrowerInfoCellModel new];
        model5.title = @"法人代表姓名";
        model5.canEdit = self.ipsAcctNo;
        model5.content = info.realName;
        AJBorrowerInfoCellModel *model6 = [AJBorrowerInfoCellModel new];
        model6.title = @"法人代表身份证号码";
        model6.content = info.idNo;
        model6.canEdit = self.ipsAcctNo;
        AJBorrowerInfoCellModel *model7 = [AJBorrowerInfoCellModel new];
        model7.title = @"企业联系人";
        model7.canEdit = self.ipsAcctNo;
        model7.content = info.companyContacts;
        AJBorrowerInfoCellModel *model8 = [AJBorrowerInfoCellModel new];
        model8.title = @"企业联系人手机";
        model8.canEdit = self.ipsAcctNo;
        model8.content = info.companyContactsMobile;
        NSArray *group2 = @[model5, model6, model7, model8];

        self.dataArray = [NSMutableArray arrayWithObjects:group1, group2, nil];
    }else{
        
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AJBorrowerInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
//    NSString *identifer = [NSString stringWithFormat:@"%d", (int)(indexPath.row + indexPath.section)];
//    AJBorrowerInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
//    if (!cell) {
//        
//        cell = [[NSBundle mainBundle]loadNibNamed:reuseIdentifier owner:nil options:0][0];
//    }
    cell.aAJBorrowerInfoCellModel = self.dataArray[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
@end
