//
//  RTAddCheckUpVC.m
//  Health
//
//  Created by GeoBeans on 14-7-14.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import "RTAddCheckUpVC.h"
#import "BlockTextPromptAlertView.h"

@interface RTAddCheckUpVC ()

@end

@implementation RTAddCheckUpVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillLayoutSubviews{
    [self.navBar setFrame:CGRectMake(0, 0, 320, 64)];
    self.navBar.translucent=YES;
}

- (IBAction)touchOK:(id)sender {
    [self.dataDelegate refreshTableView];
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)touchBack:(id)sender {
    [checkUpRecord resetting];
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView1.dataSource=self;
    self.tableView1.delegate=self;
    self.tableView1.tag=1;
    self.tableView1.rowHeight = 44;
    
    
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    self.tableView2.tag=2;
    self.tableView2.rowHeight = 44;
    self.tableView2.allowsSelection = NO; // We essentially implement our own selection
    self.tableView2.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    currentRow=0;
    NSString *plistPath=[[NSBundle mainBundle] pathForResource:@"CheckUpDictionary" ofType:@"plist"];
    checkPlist=[[NSMutableArray alloc]initWithContentsOfFile:plistPath];
    typeList =[[NSMutableArray alloc]init];
    allIndex=[[NSArray alloc]init];

    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
    for (NSDictionary *dic in checkPlist) {
        [typeList addObject:[dic objectForKey:@"typeName"]];
        [tempArray addObjectsFromArray:[dic objectForKey:@"indexArray"]];
    }
    allIndex=[tempArray copy];
    tempArray=nil;
    
    searchResults=[[NSMutableArray alloc]init];
    beginSearch=NO;
    
    checkUpRecord=[RTCheckUpRecord shareInstance];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag==1) {
        return [typeList count];
    }else if(tableView.tag==2){
    return [[[checkPlist objectAtIndex:currentRow] objectForKey:@"indexArray"] count];
    }
    else{
        return [searchResults count];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag==1) {
        currentRow=[indexPath row];
        [self.tableView2 reloadData];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    if (tableView.tag==1) {
        
        BOOL nibsRegistered = NO;
        static NSString *Cellidentifier=@"RTTypeCell";
        if (!nibsRegistered) {
            UINib *nib = [UINib nibWithNibName:@"RTTypeCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
            nibsRegistered = YES;
        }
        
        RTTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RTTypeCell"];
        
        NSUInteger row=[indexPath row];
        cell.typeNameLabel.text=[typeList objectAtIndex:row];
        return cell;
        
    }else if (tableView.tag==2){
    
        SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
        NSInteger row=[indexPath row];
    
        NSString *s1=[[[[checkPlist objectAtIndex:currentRow] objectForKey:@"indexArray"] objectAtIndex:row] objectForKey:@"range"];
        
        if (cell == nil) {
            NSMutableArray *rightUtilityButtons = [NSMutableArray new];
            
            [rightUtilityButtons addUtilityButtonWithColor:
             [UIColor colorWithRed:1.0f green:0.51f blue:0.51f alpha:1.0]
                                                     title:@"偏高"];
            [rightUtilityButtons addUtilityButtonWithColor:
             [UIColor colorWithRed:0.14f green:0.94f blue:0.89f alpha:1.0f]
                                                     title:@"偏低"];
            [rightUtilityButtons addUtilityButtonWithColor:
             [UIColor colorWithRed:0.24f green:0.53f blue:0.93f alpha:1.0f]
                                                     title:@"输入"];

            cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellIdentifier
                                      containingTableView:_tableView2
                                       leftUtilityButtons:nil
                                      rightUtilityButtons:rightUtilityButtons];
            cell.delegate = self;
        }
        cell.textLabel.text = [[[[checkPlist objectAtIndex:currentRow] objectForKey:@"indexArray"] objectAtIndex:row] objectForKey:@"indexName"];
        
        NSString *s2=[[[[checkPlist objectAtIndex:currentRow] objectForKey:@"indexArray"] objectAtIndex:row] objectForKey:@"unit"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"参考值:%@ %@",s1,s2];
        cell.textLabel.font=[UIFont fontWithName:@"Arial-BoldItalicMT" size:14];
    return cell;
    
    }
    else{
        
        SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            NSMutableArray *rightUtilityButtons = [NSMutableArray new];
            
            [rightUtilityButtons addUtilityButtonWithColor:
             [UIColor colorWithRed:1.0f green:0.51f blue:0.51f alpha:1.0]
                                                     title:@"偏高"];
            [rightUtilityButtons addUtilityButtonWithColor:
             [UIColor colorWithRed:0.14f green:0.94f blue:0.89f alpha:1.0f]
                                                     title:@"偏低"];
            [rightUtilityButtons addUtilityButtonWithColor:
             [UIColor colorWithRed:0.24f green:0.53f blue:0.93f alpha:1.0f]
                                                     title:@"输入"];
            
            cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellIdentifier
                                      containingTableView:_tableView2 // Used for row height and selection
                                       leftUtilityButtons:nil
                                      rightUtilityButtons:rightUtilityButtons];
            cell.delegate = self;
        }
        
        NSUInteger row=[indexPath row];
        
        cell.textLabel.text=[[searchResults objectAtIndex:row] objectForKey:@"indexName"];
        NSString *s1=[[searchResults objectAtIndex:row] objectForKey:@"range"];
        NSString *s2=[[searchResults objectAtIndex:row] objectForKey:@"unit"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"参考值:%@ %@",s1,s2];

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.textLabel.font=[UIFont fontWithName:@"Arial-BoldItalicMT" size:14];
        
        return cell;

    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //NSLog(@"scroll view did begin dragging");
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set background color of cell here if you don't want white
}

#pragma mark - SWTableViewDelegate

//- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
//    switch (index) {
//        case 0:
//            NSLog(@"left button 0 was pressed");
//            break;
//        case 1:
//            NSLog(@"left button 1 was pressed");
//            break;
//        case 2:
//            NSLog(@"left button 2 was pressed");
//            break;
//        case 3:
//            NSLog(@"left btton 3 was pressed");
//        default:
//            break;
//    }
//}

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
        {
            NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:cell.textLabel.text,@"indexName",cell.detailTextLabel.text,@"reference",@"偏高",@"status",@"",@"value",nil];
            [checkUpRecord.indexArray addObject:dic];
            [cell hideUtilityButtonsAnimated:YES];
            [self displayNotification];
            break;
        }
        case 1:
        {
            NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:cell.textLabel.text,@"indexName",cell.detailTextLabel.text,@"reference",@"偏低",@"status",@"",@"value",nil];
            [checkUpRecord.indexArray addObject:dic];
            
            [cell hideUtilityButtonsAnimated:YES];
            [self displayNotification];
            break;
        }
        case 2:
        {
            [cell hideUtilityButtonsAnimated:YES];
            [self showTextInputView:cell.textLabel.text And:cell.detailTextLabel.text];
            break;
        }
        default:
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//search bar
- (void)filterContentForSearchText:(NSString*)searchText{
    
    [searchResults removeAllObjects];
    for (NSDictionary *dic in allIndex) {
        NSRange range=[[dic objectForKey:@"indexName"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (range.location!=NSNotFound) {
            [searchResults addObject:dic];
        }
    }
}

#pragma mark - UISearchDisplayController delegate methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString];
    
    return YES;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
    beginSearch=YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    beginSearch=NO;

}


//AlertView
-(void)showTextInputView:(NSString*)string1 And:(NSString*)string2{
    UITextField *textField;
    
    BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:string1 message:string2 textField:&textField block:^(BlockTextPromptAlertView *alert){
        [alert.textField resignFirstResponder];
        return YES;
    }];
    
    alert.textField.keyboardType=UIKeyboardTypeDecimalPad;
    [alert setCancelButtonWithTitle:@"取消" block:nil];
    [alert addButtonWithTitle:@"确定" block:^{
        
        NSString *string3;
        NSLog(@"%d",[string2 rangeOfString:@" "].location);
        NSString *temps=[string2 substringWithRange:NSMakeRange([string2 rangeOfString:@":"].location+1,[string2 rangeOfString:@" "].location-[string2 rangeOfString:@":"].location)];
        float low=[[temps substringWithRange:NSMakeRange(0, [temps rangeOfString:@"-"].location)] floatValue];
        float high=[[temps substringFromIndex:[temps rangeOfString:@"-"].location+1] floatValue];
        if ([textField.text floatValue]>high) {
            string3=@"偏高";
        }else if ([textField.text floatValue]<low){
            string3=@"偏低";
        }else{
            string3=@"正常";
        }
        NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:string1,@"indexName",string2,@"reference",string3,@"status",textField.text,@"value",nil];
        [checkUpRecord.indexArray addObject:dic];
        [self displayNotification];
    }];
    [alert show];

}

- (void)displayNotification {
    if (self.notify.isAnimating) return;
    
    [self.view addSubview:self.notify];
    [self.notify presentWithDuration:0.5f speed:0.3f inView:self.view completion:^{
        [self.notify removeFromSuperview];
    }];
}

- (BDKNotifyHUD *)notify {
    if (_notify != nil) return _notify;
    _notify = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:@"Checkmark.png"] text:@"添加成功"];
    _notify.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
    return _notify;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
