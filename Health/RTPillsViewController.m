//
//  RTPillsViewController.m
//  Health
//
//  Created by GeoBeans on 14-5-27.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import "RTPillsViewController.h"

@interface RTPillsViewController ()

@end

@implementation RTPillsViewController

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
    [self.addNavBar setFrame:CGRectMake(0, 0, 320, 64)];
    self.navLabel2.frame=CGRectMake(100,32,120,20);
    if (DEVICE_IS_IPHONE5) {
        [self.controlScroll setFrame:CGRectMake(0, 64, 320, 464)];
        self.controlScroll.contentSize=CGSizeMake(self.view.frame.size.width,464);
    }
    else{
        [self.controlScroll setFrame:CGRectMake(0, 64, 320, 376)];
        self.controlScroll.contentSize=CGSizeMake(self.view.frame.size.width,464);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    recordArray=[[NSMutableArray alloc]init];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    self.tableView.backgroundColor=[UIColor clearColor];
    cellNum=0; 
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    if (!DEVICE_IS_IPHONE5) {
        [self.tableView setFrame:CGRectMake(0, 64, 320, 376)];
    }
    
    [self.timePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    dateFormatter1=[[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"HH:mm"];
    dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    //textField
    self.nameField.delegate=self;
    self.nameField.tag=0;
    self.numField.delegate=self;
    self.numField.tag=1;
    [self.nameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.alarmSwitch addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
    setAlarm=NO;
    self.alarmSwitch.on=NO;
 
    self.beforeAfter.selectedSegmentIndex=0;
    
    
    //Drop Down List
    _ddList = [[DDList alloc] initWithStyle:UITableViewStylePlain];
    _ddList._delegate = self;
    [self.addView addSubview:_ddList.view];
    [_ddList.view setFrame:CGRectMake(165, 109, 135, 0)];
    
    pillsSearching=[[NSMutableArray alloc]initWithObjects:@"阿司匹林",@"阿丁宁",@"阿莫西林",@"阿奇霉素", nil];
    
    refreshTimes=0;
    footer=false;
    [self readDataFromAVOS];
    
}

- (void)footerRereshing{
    footer=true;
    refreshTimes++;
    [self readDataFromAVOS];
}

- (void)headerRereshing{
    refreshTimes=0;
    [self readDataFromAVOS];
}


- (void)datePickerValueChanged{
    selectedTime=[dateFormatter1 stringFromDate:[self.timePicker date]];
}

-(void)switchAction{
    if (self.alarmSwitch.on==YES) {
        setAlarm=YES;
    }else{
        setAlarm=NO;
    }
}

- (IBAction)touchBack:(id)sender {
    [UIView beginAnimations:@"view flip" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView transitionWithView:self.view.superview
                      duration:0.2
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{ [self.view removeFromSuperview];  }
                    completion:NULL];
    [UIView commitAnimations];
}

- (IBAction)add:(id)sender {
    
    [self initpillsInDB];
    self.nameField.text=nil;
    self.numField.text=nil;
    [self.timePicker setDate:[NSDate date] animated:NO];
    [UIView beginAnimations:@"view flip" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView transitionWithView:self.view.superview
                      duration:0.2
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{ [self.view addSubview:self.addView];  }
                    completion:NULL];
    [UIView commitAnimations];
}

- (IBAction)touchFinish:(id)sender {
    if (!currentName||!currentNum||!currentBeforeAfter||!selectedTime) {
        NSString *msg = @"请输入完整信息";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else
    {
        if (setAlarm) {
            [self setAlarmNotification];
        }
        
        [self saveDataToAVOS];
        
        [UIView beginAnimations:@"view flip" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView transitionWithView:self.view.superview
                          duration:0.2
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{ [self.addView removeFromSuperview];  }
                        completion:NULL];
        [UIView commitAnimations];
        
    }
}

- (void)initpillsInDB{
    if (!pillsInDB) {
        pillsInDB=[[NSMutableArray alloc]init];
    }
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    AVQuery *query=[AVQuery queryWithClassName:@"JKMedicinePlan"];
    [query whereKey:@"userObjectId" equalTo:[mySettingData objectForKey:@"CurrentUserName"]];
    [query selectKeys:@[@"userMedicine"]];
    [pillsInDB removeAllObjects];
    NSArray *arr=[query findObjects];
    for (AVObject *obj in arr) {
        if (![pillsInDB containsObject:[obj objectForKey:@"userMedicine"]]) {
            [pillsInDB addObject:[obj objectForKey:@"userMedicine"]];
        }
    }
}

- (void)resetpillsSearching:(NSString*)string{
//    if (!pillsSearching) {
//        pillsSearching=[[NSMutableArray alloc]init];
//    }
//    [pillsSearching removeAllObjects];
//    AVQuery *query=[AVQuery queryWithClassName:@"JKMedicine"];
//    [query whereKey:@"name" hasPrefix:string];
//    [query selectKeys:@[@"medicineName"]];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            for (AVObject *obj in objects) {
//                [pillsSearching addObject:[obj objectForKey:@"medicineName"]];
//            [_ddList updateData:pillsSearching];
//            }
//        }
//    }];
}

- (void)readDataFromAVOS{
    
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *s=[dateFormatter2 stringFromDate:[NSDate date]];
    NSString *s1=[s substringToIndex:10];
    NSDate *zero = [[dateFormatter2 dateFromString:[NSString stringWithFormat:@"%@ 00:00",s1]] dateByAddingTimeInterval:-86400*refreshTimes];
    NSDate *one = [[dateFormatter2 dateFromString:[NSString stringWithFormat:@"%@ 00:00",s1]] dateByAddingTimeInterval:-86400*(refreshTimes-1)];

    dateFormatter2=nil;
    s=nil;
    s1=nil;
 
    AVQuery *query=[AVQuery queryWithClassName:@"JKMedicinePlan"];
    
    [query addAscendingOrder:@"userMedicineTime"];
    [query whereKey:@"userObjectId" equalTo:[mySettingData objectForKey:@"CurrentUserName"]];
    
    [query whereKey:@"userMedicineTime" greaterThan:zero];
    [query whereKey:@"userMedicineTime" lessThan:one];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (!footer) {
                [recordArray removeAllObjects];
            }
 
            for (int i=0; i<[objects count]; i++) {
                NSString *medicineName=[[objects objectAtIndex:i] objectForKey:@"userMedicine"];
                NSDate *medicineTime=[[objects objectAtIndex:i] objectForKey:@"userMedicineTime"];
                NSString *before=[[objects objectAtIndex:i] objectForKey:@"beforeDinner"];
                NSString *medicineCount=[[objects objectAtIndex:i] objectForKey:@"userMedicineCount"];
                NSString *objectId=[[objects objectAtIndex:i] objectForKey:@"objectId"];
                NSString *iscomplete=[[objects objectAtIndex:i] objectForKey:@"userMedicineIsComplete"];
                
                [recordArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:medicineName, @"name",medicineTime, @"time", before, @"before",medicineCount,@"number",iscomplete,@"complete",objectId,@"objectId",nil]];
            }
            
            cellNum=[recordArray count];
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
            footer=false;
        } else {
            if (footer) {
                refreshTimes--;
            }
            
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息加载失败" message:@"网络有点不给力哦，请稍后再试~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            footer=false;
        }
    }];
    query=nil;
}

- (void)saveDataToAVOS{
    
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    
    AVObject *medicinePlan=[AVObject objectWithClassName:@"JKMedicinePlan"];
    [medicinePlan setObject:currentName forKey:@"userMedicine"];
    [medicinePlan setObject:@"0" forKey:@"userMedicineIsComplete"];
    [medicinePlan setObject:[NSNumber numberWithInt:[currentNum intValue]]forKey:@"userMedicineCount"];
    [medicinePlan setObject:[self.timePicker date] forKey:@"userMedicineTime"];
    [medicinePlan setObject:currentBeforeAfter forKey:@"beforeDinner"];
    [medicinePlan setObject:[mySettingData objectForKey:@"CurrentUserName"] forKey:@"userObjectId"];
    
    [medicinePlan saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [medicinePlan saveEventually];
        if (!error) {
            [recordArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:currentName, @"name",selectedTime, @"time", currentBeforeAfter, @"before",currentNum,@"number",@"0",@"complete",medicinePlan.objectId,@"objectId",nil]];
            cellNum=[recordArray count];
            [self.tableView reloadData];
            currentName=nil;
            currentNum=nil;
            currentBeforeAfter=nil;
            selectedTime=nil;
        }
    }];
    medicinePlan=nil;
}

- (IBAction)touchCancel:(id)sender {
    [UIView beginAnimations:@"view flip" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView transitionWithView:self.view.superview
                      duration:0.2
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{ [self.addView removeFromSuperview];  }
                    completion:NULL];
    [UIView commitAnimations];
}


//*********************tableView********************//

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static BOOL nibsRegistered = NO;
    
    static NSString *Cellidentifier=@"cell1";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"RTPillsTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
        nibsRegistered = YES;
    }
    
    RTPillsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
    NSUInteger row=[indexPath row]-1;
    cell.accessoryType=UITableViewCellAccessoryNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (row==-1) {
        cell.pillsName.text=@"药品名称";
        cell.pillsTime.text=@"时间";
        cell.pillsFood.text=@"餐前";
        cell.pillsNum.text=@"剂量";
        cell.pillsCmp.hidden=YES;
    }else{
        cell.pillsCmp.hidden=NO;
        NSDictionary *dic=[recordArray objectAtIndex:row];
        cell.pillsName.text=[dic objectForKey:@"name"];
        cell.pillsTime.text=[dateFormatter1 stringFromDate:[dic objectForKey:@"time"]];
        cell.pillsFood.text=[dic objectForKey:@"before"];
        cell.pillsNum.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"number"]];
        cell.pillsDay.text=[dateFormatter stringFromDate:[dic objectForKey:@"time"]];
        if ([[dic objectForKey:@"complete"] isEqualToString:@"0"]) {
            cell.pillsCmp.on=true;
        }else{
            cell.pillsCmp.on=false;
        }
    }
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return cellNum+1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//行缩进
-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    return row;
}
//改变行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

//*********************segmented Control********************//
- (IBAction)beforeAfter:(id)sender {
    if (self.beforeAfter.selectedSegmentIndex==0) {
        currentBeforeAfter=@"前";
    }else if (self.beforeAfter.selectedSegmentIndex==1)
        currentBeforeAfter=@"后";
}

-(void)setAlarmNotification{
  
	UILocalNotification *notification=[[UILocalNotification alloc] init];
	if (notification!=nil)
	{
        notification.fireDate=self.timePicker.date;
		notification.timeZone=[NSTimeZone defaultTimeZone];
		notification.soundName = UILocalNotificationDefaultSoundName;
		notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"您现在该服用%@药品了，剂量为%@片，健康宝祝您健康永存！",nil),self.nameField.text,self.numField.text];
		[[UIApplication sharedApplication] scheduleLocalNotification:notification];
	}
}

//*********************textField********************//
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag==0) {
        [_ddList.view setFrame:CGRectMake(165, 109, 135, 0)];
        [self setDDListHidden:NO];
        if ([[textField text] length]>0) {
            [_ddList updateData:pillsSearching];
        }else{
            [_ddList updateData:pillsInDB];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag==0) {
        currentName=textField.text;
        [self setDDListHidden:YES];
    }else if (textField.tag==1)
        currentNum=textField.text;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.nameField resignFirstResponder];
    [self.numField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.nameField resignFirstResponder];
    [self.numField resignFirstResponder];
    return  YES;
}
- (void) textFieldDidChange:(id) sender {
    UITextField *_field = (UITextField *)sender;
    NSString *text=[_field text];
    if ([text length] != 0) {
        [self setDDListHidden:NO];
        [self resetpillsSearching:text];
		//[_ddList updateData:pillsSearching];
	}
	else {
		[_ddList updateData:pillsInDB];
	}
}

//*******************drop down list******************//
- (void)setDDListHidden:(BOOL)hidden{
	NSInteger height = hidden ? 0 : 180;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.2];
	[_ddList.view setFrame:CGRectMake(165, 109, 135, height)];
	[UIView commitAnimations];
}

- (void)passValue:(NSString *)value{
    self.nameField.text=value;
    [self setDDListHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
