//
//  DropDown.m
//  DropDown


#import "AJComboBox.h"
#import <QuartzCore/QuartzCore.h>

@implementation AJComboBox
@synthesize arrayData, delegate;
@synthesize dropDownHeight;
@synthesize labelText;
@synthesize enabled;

- (void)__show {
    viewControl.alpha = 0.0f;
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
    [mainWindow addSubview:viewControl];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         viewControl.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {}];
}

- (void)__hide {
    [UIView animateWithDuration:0.2f
                     animations:^{
                         viewControl.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [viewControl removeFromSuperview];
                     }];
}


- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [button setTitle:@"--Select--" forState:UIControlStateNormal];
        UIImage *bg =  [UIImage imageNamed:@"combo_bg"];
        CGFloat top = 4; // 顶端盖高度
        CGFloat bottom =  4; // 底端盖高度
        CGFloat left = 10; // 左端盖宽度
        CGFloat right = 1; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        // 指定为拉伸模式，伸缩后重新赋值
        bg = [bg resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        
        [button setBackgroundImage:bg forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
        button.titleLabel.textColor = [UIColor lightGrayColor];
        button.titleLabel.textAlignment = NSTextAlignmentLeft;
        
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        button.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
        [self addSubview:button];
        
        viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [viewControl setBackgroundColor:[UIColor clearColor]];
        [viewControl addTarget:self action:@selector(controlPressed) forControlEvents:UIControlEventTouchUpInside];
        
        
        dropDownHeight = [arrayData count]*30;
        
        CGFloat x = self.frame.origin.x;
        CGFloat y = self.frame.origin.y+84;
        
        _table = [[UITableView alloc] initWithFrame:CGRectMake(x, y, self.frame.size.width, dropDownHeight) style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
        CALayer *layer = _table.layer;
        layer.masksToBounds = YES;
        layer.cornerRadius = 3.0f;
        layer.borderWidth = 0.5f;
        [layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [viewControl addSubview:_table];
        
        
    }
    return self;
}

- (void) setLabelText:(NSString *)_labelText
{
    [labelText release];
    labelText = [_labelText retain];
    [button setTitle:labelText forState:UIControlStateNormal];
}

- (void) setEnable:(BOOL)_enabled
{
    enabled = _enabled;
    [button setEnabled:_enabled];
}

- (void) setArrayData:(NSArray *)_arrayData
{
    [arrayData release];
    arrayData = [_arrayData retain];
    [_table reloadData];
}

- (void) dealloc
{
    [viewControl release];
    [_table release];
    [super dealloc];
}

- (void) buttonPressed
{
    [self __show];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickAjComboBox)])
    {
        [self.delegate didClickAjComboBox];
    }

}



- (void) controlPressed
{
    //[viewControl removeFromSuperview];
    [self __hide];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    return [arrayData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell.textLabel setFont:button.titleLabel.font];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    cell.textLabel.text = [arrayData objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndex = [indexPath row];
    //[viewControl removeFromSuperview];
    [self __hide];
    [button setTitle:[self.arrayData objectAtIndex:[indexPath row]] forState:UIControlStateNormal];
    [delegate didChangeComboBoxValue:self selectedIndex:[indexPath row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return @"";
}

- (NSInteger) selectedIndex
{
    return _selectedIndex;
}

#pragma mark -
#pragma mark AJComboBoxDelegate

-(void)didChangeComboBoxValue:(AJComboBox *)comboBox selectedIndex:(NSInteger)selectedIndex
{
    
}	


@end
