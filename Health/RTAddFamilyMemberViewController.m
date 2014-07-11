//
//  RTAddFamilyMemberViewController.m
//  Health
//
//  Created by Mac on 7/10/14.
//  Copyright (c) 2014 RADI Team. All rights reserved.





/*说明
 
   前提是手机号不能超过两个用户注册。
 */
//

#import "RTAddFamilyMemberViewController.h"
#import "RTAddMemResultView.h"
#import "RTFamilyDetailViewController.h"
#import "RTFamilyShip.h"
@interface RTAddFamilyMemberViewController ()

@end

@implementation RTAddFamilyMemberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.rightAndErrorImage.hidden=YES;
    self.resultTableView.hidden=YES;
    self.resultView2.hidden=YES;
    self.resultView.hidden=YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SubmitAndDismiss:(id)sender {
    UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定添加完毕？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alerView.tag=10001;
    [alerView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10001) {
        if (buttonIndex==0) {
            NSLog(@"ALerView1");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        if (buttonIndex==1) {
            NSLog(@"ALerView1");
            
        }

    }
    if (alertView.tag==10000) {
        if (buttonIndex==0) {
            NSLog(@"ALerView2");
        }
        if (buttonIndex==1) {
             NSLog(@"ALerView2");
        }
        
    }
    
    
    
}


-(BOOL)checkPhoneNumber
{
    
    NSString *phone=self.AddMemPhoneInputInText.text;
    
    if(phone.length!=11)
    {
        
        self.errorInfoLabel.text=@"输入手机号不正确";
        self.rightAndErrorImage.hidden=NO;
        self.rightAndErrorImage.image=[UIImage imageNamed:@"error.png"];
        self.resultCountLabel.text=@"0";
        return NO;
    }
    else
    {
          self.rightAndErrorImage.hidden=NO;
          self.rightAndErrorImage.image=[UIImage imageNamed:@"right.png"];
          self.errorInfoLabel.text=@"";
        
        
        return YES;
        //查找
    }
}


-(IBAction)doAddFamilyShipIntoAVOS:(id)sender
{
    
    if (self.targetAVUserArray!=nil) {
        for (AVUser *temp in self.targetAVUserArray) {
            [self addTargetAVUserIdInMyItemsOnAVOS:temp];
        }
    }

    UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"好友请求已经发送给TA～,耐心等待哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alerView.tag=10000;
    [alerView show];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}


// - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
// {
// UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
// 
// // Configure the cell...
// 
// return cell;
// }


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
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
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark - textField delegate method

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    
    //清楚结果View上的内容
    if(self.resultView.subviews!=nil)
    {
        for (UIView *subview in self.resultView.subviews) {
            [subview removeFromSuperview];
        }
        for (UIView *subview in self.resultView2.subviews) {
            [subview removeFromSuperview];
        }
        self.resultView.hidden=YES;
        self.resultView2.hidden=YES;

    }
    
    if ([self checkPhoneNumber]) {
        [self findUserByPhone:self.AddMemPhoneInputInText.text];
    };
    
    
    
    return YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{
    
    //在此处可以限制字长
    
    //    if (textField==self.phoneInputField) {
    //        Register.username=[textField.text stringByReplacingCharactersInRange:range withString:string];
    //    }
    //    if (textField==self.passwordInputField) {
    //        Register.pwd=[textField.text stringByReplacingCharactersInRange:range withString:string];
    //    }
    //
    return YES;
    
}



#pragma 后台操作方法

-(void)findUserByPhone:(NSString*)phone
{
    [self.SearchActivityIndicator startAnimating];
    AVQuery * query = [AVUser query];
    [query whereKey:@"phone" equalTo:phone];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            self.targetAVUserArray=objects;
            //回调处理函数
            [self addSearchResultsToView:self.targetAVUserArray];
            [self.SearchActivityIndicator stopAnimating];
        } else {
            self.errorInfoLabel.text=error.localizedDescription;
            
            self.resultCountLabel.text=@"0";
        }
    }];
    
}

-(void)addTargetAVUserIdInMyItemsOnAVOS:(AVUser*)usr
{
    [self.SearchActivityIndicator startAnimating];
    AVUser *currentUser=[AVUser currentUser];
    
    RTFamilyShip *familyShip=[RTFamilyShip initWithUser:currentUser targetUser:usr];
    [familyShip doAddRelationship];
    self.errorInfoLabel.text=familyShip.errorInfoString;
    [self.SearchActivityIndicator stopAnimating];
}


-(void)addSearchResultsToView:(NSArray*)SearchUserArray
{
    self.resultCountLabel.text=[NSString stringWithFormat:@"%d",[SearchUserArray count]];
    RTUserInfo *temp;
    if ([SearchUserArray count]>2) {
        
    }
    else
    {
    switch ([SearchUserArray count]) {
        case 1:
        {
            temp=[SearchUserArray objectAtIndex:0];
            AVFile *imageFile=temp.userImage;
            NSData *imageData=[imageFile getData];
            //添加用户名
            UILabel *namelabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 30, 120, 20)];
            namelabel.text=temp.username;
            [self.resultView addSubview:namelabel];
            // 添加加好友button
            UIButton *AddBtn=[[UIButton alloc]initWithFrame:CGRectMake(280, 30, 20, 20)];
            
            [AddBtn setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
            //设置button事件
            [AddBtn addTarget:self action:@selector(doAddFamilyShipIntoAVOS:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.resultView addSubview:AddBtn];
            
            UIImageView *portraitView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
            [portraitView.layer setCornerRadius:CGRectGetHeight(portraitView.bounds)/2];
//            portraitView.layer.borderColor = [UIColor blueColor].CGColor;
//            portraitView.layer.borderWidth = 0.5;
            [portraitView.layer setMasksToBounds:YES];
            [portraitView setImage:[UIImage imageWithData:imageData]];
            [self.resultView addSubview:portraitView];
              self.resultView.hidden=NO;
            break;
        }
        case 2:
        {
            
            //add1
            temp=[SearchUserArray objectAtIndex:0];
            AVFile *imageFile=temp.userImage;
            NSData *imageData=[imageFile getData];
            
            UILabel *namelabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 30, 120, 20)];
            namelabel.text=temp.username;
            [self.resultView addSubview:namelabel];
            
            UIButton *AddBtn=[[UIButton alloc]initWithFrame:CGRectMake(280, 30, 20, 20)];
            
            [AddBtn setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
            [AddBtn addTarget:self action:@selector(doAddFamilyShipIntoAVOS:) forControlEvents:UIControlEventTouchUpInside];
            [self.resultView addSubview:AddBtn];
            
            
            UIImageView *portraitView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
            [portraitView.layer setCornerRadius:CGRectGetHeight(portraitView.bounds)/2];
            portraitView.layer.borderColor = [UIColor blueColor].CGColor;
            portraitView.layer.borderWidth = 0.5;
            [portraitView.layer setMasksToBounds:YES];
            [portraitView setImage:[UIImage imageWithData:imageData]];
            [self.resultView addSubview:portraitView];
            //add2
            temp=[SearchUserArray objectAtIndex:1];
            imageFile=temp.userImage;
            imageData=[imageFile getData];
            
            namelabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 30, 120, 20)];
            namelabel.text=temp.username;
            [self.resultView2 addSubview:namelabel];
            
            UIButton *AddBtn2=[[UIButton alloc]initWithFrame:CGRectMake(280, 30, 20, 20)];
            
            [AddBtn2 setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
            [AddBtn2 addTarget:self action:@selector(doAddFamilyShipIntoAVOS:) forControlEvents:UIControlEventTouchUpInside];
            [self.resultView2 addSubview:AddBtn2];
            
            
            portraitView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
            [portraitView.layer setCornerRadius:CGRectGetHeight(portraitView.bounds)/2];
//            portraitView.layer.borderColor = [UIColor blueColor].CGColor;
//            portraitView.layer.borderWidth = 0.5;
            [portraitView.layer setMasksToBounds:YES];
            [portraitView setImage:[UIImage imageWithData:imageData]];
            [self.resultView2 addSubview:portraitView];
            self.resultView2.hidden=NO;
            self.resultView.hidden=NO;
            break;
        }
    }
    
        
    }
    
}


-(void)errorHandler
{
    UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"错误" message:self.resultCountLabel.text delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alerView show];
}



@end
