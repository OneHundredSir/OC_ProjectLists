//
//  AJInterstductionController.m
//  SP2P_7
//
//  Created by Ajax on 16/1/19.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJInterstductionController.h"
#import "AJInterstductionCell.h"
#import "AJDailyManagerHeaderData.h"

@interface AJInterstductionController ()
@property (nonatomic, strong) AJDailyManagerHeaderData *data;
@property (nonatomic, copy) NSMutableArray *texts;
@end

@implementation AJInterstductionController

- (NSMutableArray *)texts
{
    if (_texts == nil) {
        _texts = [NSMutableArray arrayWithObject:@{@"特点：":@"每日生息，T+1 返息"}];
    }
    return _texts;
}
//- (NSMutableAttributedString *)testText
//{
////    if (_text == nil) {
//        _text = @"redafafdsafdsafdsafredafreafdsafdsafdsafdsaredafafdsafdsafdsafdsaredafafdsafdsafdsafdsaredafafdsafdsafdsafdsaredafafdsafdsafdsafdsadsa";
//        NSString *str = nil;
//    NSDictionary *titleAttr = @{NSFontAttributeName: [UIFont systemFontOfSize:16], NSForegroundColorAttributeName: [ColorTools colorWithHexString:@"#646464"]};
//     NSDictionary *contentAttr = @{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [ColorTools colorWithHexString:@"#969696"]};
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 10;//行间距
//    paragraphStyle.headIndent = 10.f;
//    paragraphStyle.tailIndent = 10.f;
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    paragraphStyle.alignment = NSTextAlignmentJustified;
//    
//    NSDictionary *testAttr = @{NSFontAttributeName: [UIFont systemFontOfSize:16], NSForegroundColorAttributeName: [ColorTools colorWithHexString:@"#646464"], NSParagraphStyleAttributeName: paragraphStyle};
//    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc] initWithString:_text attributes:testAttr];
//        NSRange dayRange = [aCreditorTransfer.time rangeOfString:@"天"];
//        NSRange hourRange = [aCreditorTransfer.time rangeOfString:@"时"];
//        NSRange minuteRange = [aCreditorTransfer.time rangeOfString:@"分"];
//        NSDictionary *dayAttribute = @{NSForegroundColorAttributeName: self.dueIn.textColor, NSFontAttributeName: self.dueIn.font};
//        [str addAttributes:dayAttribute range:NSMakeRange(0, dayRange.location)];
//        //    NSRange hourRangenumber = NSMakeRange(dayRange.location + 1, hourRange.location);
//        [str addAttributes:dayAttribute range: NSMakeRange(dayRange.location + 1, hourRange.location - dayRange.location - 1)];
//        [str addAttributes:dayAttribute range: NSMakeRange(hourRange.location + 1, minuteRange.location - hourRange.location -1)];
//    }
//    return AttributedString;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
}
- (void)setData:(AJDailyManagerHeaderData *)data
{
    _data = data;
    
    [self.texts addObject:@{@"产品说明：": data.description_}];
    [self.texts addObject:@{@"购买规则：": data.invest_rule}];
    [self.texts addObject:@{@"转出规则：": data.transfer_rule}];
    
    [self.tableView reloadData];
}

- (void)initView
{
//    CGFloat padding = 12.0f;
//    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(padding, 0, self.view.bounds.size.width - 2*padding, self.view.bounds.size.height)];
////    textView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
//    textView.showsVerticalScrollIndicator = NO;
//    textView.attributedText = [self testText];
//    [self.view addSubview:textView];
//    textView.editable = NO;
//    textView.backgroundColor = KblackgroundColor;
//    textView.attributedText = ;
//    self.tableView.tableFooterView = [[UIView alloc] ]
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.texts.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AJInterstductionCell *cell = [AJInterstductionCell cellWithTableView:tableView];
    NSDictionary *dic = self.texts[indexPath.row];
    NSString *key = [dic allKeys].firstObject;
    cell.content = dic[key];
    cell.title = key;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 列寬
    NSDictionary *dic = self.texts[indexPath.row];
     NSString *key = [dic allKeys].firstObject;
    CGFloat contentWidth = tableView.bounds.size.width - 2*20.f/2;
    CGSize size = [dic[key] boundingRectWithSize:CGSizeMake(contentWidth, 1000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]}context:nil].size;
    // 用何種字體進行顯示
    return 82.f/2 + size.height + 20.f/2;

}
@end
