//
//  WHDBuyTableViewController.m
//  xiaorizi
//
//  Created by HUN on 16/6/3.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDBuyTableViewController.h"

@interface WHDBuyTableViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *table;

@end

@implementation WHDBuyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUpTable];
    [self makeUpHeader];
    [self makeUpSessionHeader];
    [self makeUpWebview];
    
    [self setUpTableItem];
}

-(void)setUpTableItem
{
    
    CGRect bRect=(CGRect){0,0,40,40};
    //喜欢
    UIButton *libtn=[UIButton setImageAndTitleWithrame:bRect
                                          andNomalName:nil
                                         andNomalImage:@"collect_1"
                                        andSeletedName:nil
                                       andSeletedImage:@"collect_2"];
    [libtn addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *likebarBtn=[[UIBarButtonItem alloc]initWithCustomView:libtn];
    likebarBtn.tag=1;
    
    //分享
    UIButton *shareBtn=[[UIButton alloc]initWithFrame:bRect];
    [shareBtn setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sharebarBtn=[[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    sharebarBtn.tag=2;
    
    //加到右边
    self.navigationItem.rightBarButtonItems=@[sharebarBtn,likebarBtn];
}
-(void)like:(UIButton *)btn
{
    btn.selected=!btn.selected;
}

-(void)share:(UIButton *)btn
{
    NSLog(@"分享准备中.....");
}


/**
 *  tableview设置
 */
-(void)makeUpTable
{
    //自动适配
    _table.rowHeight=UITableViewAutomaticDimension;
    _table.estimatedRowHeight=2000;
    _table.contentSize=(CGSize){VIEWW*2.0,VIEWH};
}


//上面一个可以放大的imageview，通过手势
-(void)makeUpHeader
{
    
}

-(void)makeUpSessionHeader
{
    
}
//建立一个webview
-(UIWebView *)makeUpWebview
{

    UIWebView *webView=[[UIWebView alloc]initWithFrame:self.view.frame];
    //测试用
    NSString *httpStr=@"<body><html><head></head><body><p>虽然数码产品日新月异，打字和收发邮件的便利让整个世界几乎能够零距离的交流，不过很多人依然迷恋于纸张的手感，就算互联网提供了更快速的选择，还是很执著于翻阅书本及杂志的真实感，偶尔也想提笔写张手写卡片，把满满暖意寄给朋友。</p><p><img alt=\"\" data-cke-saved-src=\"http://pic.huodongjia.com/event/2015-05-06/event121381.jpg\" height=\"430\" src=\"http://pic.huodongjia.com/event/2015-05-06/event121381.jpg\" width=\"700\"></img></p><p><img alt=\"\" data-cke-saved-src=\"http://pic.huodongjia.com/event/2015-05-06/event121375.jpg\" height=\"434\" src=\"http://pic.huodongjia.com/event/2015-05-06/event121375.jpg\" width=\"650\"></img></p><p>Schoene Schreibwaren利用黑白为主的空间，把纸张变得很时尚。产品包括各式各样的像本，笔记簿，行事历等。也像精品店一样提供客制化的商品。</p><p><img alt=\"\" data-cke-saved-src=\"http://pic.huodongjia.com/event/2015-05-06/event121376.jpg\" height=\"634\" src=\"http://pic.huodongjia.com/event/2015-05-06/event121376.jpg\" width=\"950\"></img></p><p><img alt=\"\" data-cke-saved-src=\"http://pic.huodongjia.com/event/2015-05-06/event121377.jpg\" height=\"634\" src=\"http://pic.huodongjia.com/event/2015-05-06/event121377.jpg\" width=\"950\"></img></p><p><img alt=\"\" data-cke-saved-src=\"http://pic.huodongjia.com/event/2015-05-06/event121378.jpg\" height=\"180\" src=\"http://pic.huodongjia.com/event/2015-05-06/event121378.jpg\" width=\"300\"></img></p><p><img alt=\"\" data-cke-saved-src=\"http://pic.huodongjia.com/event/2015-05-06/event121382.jpg\" height=\"368\" src=\"http://pic.huodongjia.com/event/2015-05-06/event121382.jpg\" width=\"736\"></img>​</p><p></p><p><strong>地址</strong></p><p>Niederbarnimstr. 6</p><p>10247 Berlin</p><p><strong>网站</strong></p><p>http://www.schoeneschreibwaren.com/</p><p><strong>营业时间</strong></p><p>周一至周五: 10am – 7pm</p><p>周六: 10am - 6pm</p></body></html></body>";
    
    NSString *urlStr=@"http://api.xiaorizi.me/app/share-130125.html";

    
    [webView loadHTMLString:httpStr baseURL:[NSURL URLWithString:urlStr]];
    return webView;
}
#pragma mark datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID =@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
