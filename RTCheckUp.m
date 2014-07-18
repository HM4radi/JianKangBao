//
//  RTCheckUp.m
//  Health
//
//  Created by GeoBeans on 14-7-14.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import "RTCheckUp.h"

@interface RTCheckUp ()

@end

@implementation RTCheckUp

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)saveDataToAVOS:(NSMutableDictionary *)dic{
    
    AVObject *checkUp=[AVObject objectWithClassName:@"JKCheckUpRecord"];
    [checkUp setObject:[AVUser currentUser].objectId forKey:@"userObjectId"];
    [checkUp setObject:selectedType forKey:@"checkType"];
    [checkUp setObject:selectedDate forKey:@"checkTime"];
    [checkUp setObject:checkUpRecord.indexArray forKey:@"indexArray"];
    [checkUp setObject:imagePathArray forKey:@"imagePathArray"];
    
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    for (UIImage *img in imageArray ) {
        NSData *imageData = UIImageJPEGRepresentation(img, 0.3);
        [arr addObject:imageData];
    }
    
    [checkUp saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [checkUp saveEventually];
        if (!error) {
            [dic setObject:checkUp.objectId forKey:@"objectId"];
            [self.dataDelegate addRecord:dic];
//            AVFile *file = [AVFile fileWithName:@"imageArray" data:[NSKeyedArchiver archivedDataWithRootObject:arr]];
//            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                [checkUp setObject:file forKey:@"imageArray"];
//                [checkUp saveInBackground];
//            } progressBlock:^(NSInteger percentDone) {
//                NSLog(@"percent=%d",percentDone);
//            }];
            
        }
    }];
    checkUp=nil;
}

- (IBAction)touchBack:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)touchOK:(id)sender {
    
    if (selectedDate&&selectedType&&([imageArray count]>0||[checkUpRecord.indexArray count]>0)) {

        [self saveImageToLocal];
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:selectedDate,@"date",selectedType,@"type",nil];

        if (checkUpRecord.indexArray) {
            [dic setObject:checkUpRecord.indexArray forKey:@"indexArray"];
            [dic setObject:[NSString stringWithFormat:@"%d", [checkUpRecord.indexArray count]] forKey:@"indexArrayCount"];
        }
        [self saveDataToAVOS:dic];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)inputIndex{
    if (!inputCheckUp) {
        inputCheckUp=[[RTAddCheckUpVC alloc]init];
        inputCheckUp.dataDelegate=self;
    }
    inputCheckUp.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:inputCheckUp animated:YES completion:nil];
    
    inputCheckUp=nil;
}

- (void)viewWillLayoutSubviews{
    [self.navBar setFrame:CGRectMake(0, 0, 320, 64)];
    self.navBar.translucent=YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    checkUpType=[[NSArray alloc]initWithObjects:@"血常规",@"肝功能",@"肾功能",@"尿常规",@"血脂分析",@"其他项目", nil];
    
    if (!timePicker) {
        timePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0,30,320,100)];
        [timePicker setDate:[NSDate date] animated:YES];
        timePicker.tag=0;
    }
    
    if (!typePicker) {
        typePicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0,30,320,100)];
        typePicker.delegate = self;
        typePicker.dataSource=self;
        typePicker.showsSelectionIndicator = YES;
        typePicker.tag=0;
        selectedType=[checkUpType objectAtIndex:0];
    }
    
    if (!actionView) {
        actionView = [[UIActionSheet alloc] initWithTitle:@"请选择体检时间\n\n\n\n\n\n\n\n\n\n\n\n\n" delegate:self  cancelButtonTitle:@"取消" destructiveButtonTitle:@"完成" otherButtonTitles:nil, nil];
        actionView.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
        [actionView setBounds:CGRectMake(0,0,100,200)];
    }
    
    dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    dateFormatter1=[[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"yyyy.MM.dd"];
    
    checkUpRecord=[RTCheckUpRecord shareInstance];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    self.input.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inputIndex)];
    [self.input addGestureRecognizer:tapGesture];
    
    self.inputTime.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inputTimeLabel)];
    [self.inputTime addGestureRecognizer:tapGesture2];

    self.inputType.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGesture3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inputTypeLabel)];
    [self.inputType addGestureRecognizer:tapGesture3];
    
    imageNum=0;
    showImage=[[UIView alloc]initWithFrame:self.view.frame];
    [showImage setBackgroundColor:[UIColor whiteColor]];
    
    if (!DEVICE_IS_IPHONE5) {
        [self.scrollView setFrame:CGRectMake(8,279, 302, 110)];
    }

    if (checkUpRecord.exist) {
        self.timeLabel.text=[dateFormatter stringFromDate:checkUpRecord.checkUpTime];
        self.typeLabel.text=checkUpRecord.checkUpStyle;
        self.timeLabel.font=[UIFont fontWithName:@"Arial-BoldItalicMT" size:18];
        self.timeLabel.textColor=[UIColor redColor];
        self.typeLabel.font=[UIFont fontWithName:@"Arial-BoldItalicMT" size:18];
        self.typeLabel.textColor=[UIColor redColor];
        
        self.lbl1.hidden=YES;
        self.lbl2.hidden=YES;
        self.inputTime.hidden=YES;
        self.inputType.hidden=YES;
        self.input.hidden=YES;
        self.rightButton.tintColor=[UIColor clearColor];
        self.rightButton.enabled=NO;
        
        [self readDataFromAVOS];
    }else{
        self.timeLabel.font=[UIFont fontWithName:@"Arial-BoldItalicMT" size:14];
        self.timeLabel.textColor=[UIColor lightGrayColor];
        self.typeLabel.font=[UIFont fontWithName:@"Arial-BoldItalicMT" size:14];
        self.typeLabel.textColor=[UIColor lightGrayColor];
        
        addImgview=[[UIImageView alloc] initWithFrame:CGRectMake(100*imageNum, 10, 90, 90)];
        addImgview.contentMode=UIViewContentModeScaleAspectFill;
        addImgview.clipsToBounds=YES;
        
        UIImage *tempImg=[UIImage imageNamed:@"addImage.png"];
        [addImgview setImage:tempImg];
        [self.scrollView addSubview:addImgview];
        addImgview.userInteractionEnabled=YES;
        UITapGestureRecognizer *Gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePhotos)];
        [addImgview addGestureRecognizer:Gesture];
    }
}

-(void)takePhotos{
    
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag!=255) {
        if (buttonIndex==0) {
            if (timePicker.tag!=0) {
                self.timeLabel.text=[dateFormatter stringFromDate:[timePicker date]];
                self.timeLabel.font=[UIFont fontWithName:@"Arial-BoldItalicMT" size:18];
                self.timeLabel.textColor=[UIColor redColor];
                selectedDate=[timePicker date];
            }else if (typePicker.tag!=0){
                if([selectedType length]>0)
                self.typeLabel.text=selectedType;
                self.typeLabel.font=[UIFont fontWithName:@"Arial-BoldItalicMT" size:18];
                self.typeLabel.textColor=[UIColor redColor];

            }
        }

    }
        
    if (actionSheet.tag==255) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //支持相机
            if (buttonIndex==0) {
                [self choosePhotoFromCamera];
            }
            else if (buttonIndex==1){
            //从相册选择
                [self choosePhotoFromAlbum];
            }
        }else{
        //不支持相机
            if (buttonIndex==0) {
                //从相册选择
                [self choosePhotoFromAlbum];
            }
        }
    }
}

//**********************相机*************************//
-(void)choosePhotoFromAlbum{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 10;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{

    if (!imageArray) {
        imageArray=[[NSMutableArray alloc]init];
    }
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(100*imageNum, 10, 90, 90)];
            imgview.contentMode=UIViewContentModeScaleAspectFill;
            imgview.clipsToBounds=YES;

            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            [imgview setImage:tempImg];
            
           
            [imageArray addObject:tempImg];
            
            imgview.userInteractionEnabled=YES;
            UITapGestureRecognizer *Gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fullScreen:)];
            [imgview addGestureRecognizer:Gesture];
            
            
            [self.scrollView addSubview:imgview];
            imageNum++;
        }
    [addImgview setFrame:CGRectMake(100*imageNum, 10, 90, 90)];
    [self.scrollView setContentSize:CGSizeMake(100*(imageNum+1),0)];
}

-(void)fullScreen:(UIGestureRecognizer*)sender{
    
    UIImageView* img=[[UIImageView alloc]initWithImage:((UIImageView*)sender.view).image];
    [img setFrame:CGRectMake(0, 124, 320, 320)];
    img.userInteractionEnabled=YES;
    UITapGestureRecognizer *Gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endFullScreen)];
    [img addGestureRecognizer:Gesture];
    [showImage addSubview:img];
    
    [UIView beginAnimations:@"view flip" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{ [self.view addSubview:showImage];  }
                    completion:NULL];
    [UIView commitAnimations];
    img=nil;
}

-(void)endFullScreen{
    [UIView beginAnimations:@"view flip" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{ [showImage removeFromSuperview];  }
                    completion:NULL];
    [UIView commitAnimations];
}

-(void)choosePhotoFromCamera{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (!imageArray) {
        imageArray=[[NSMutableArray alloc]init];
    }
    [imageArray addObject:image];
    

    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(100*imageNum, 10, 90, 90)];
    [imgView setImage:image];
    
    imgView.userInteractionEnabled=YES;
    UITapGestureRecognizer *Gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fullScreen:)];
    [imgView addGestureRecognizer:Gesture];
    
    [self.scrollView addSubview:imgView];
    imageNum++;
    [self.scrollView setContentSize:CGSizeMake(100*(imageNum+1), 0)];
    [addImgview setFrame:CGRectMake(100*imageNum, 10, 90, 90)];
}

- (void)saveImageToLocal
{
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    if ([imageArray count]>0) {
        if (!imagePathArray) {
            imagePathArray=[[NSMutableArray alloc]init];
        }
        for (int i=0; i<[imageArray count]; i++) {
            NSData *imageData = UIImageJPEGRepresentation([imageArray objectAtIndex:i], 0.5);
            NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d",[dateFormatter1 stringFromDate:selectedDate],i]];
            [imagePathArray addObject:fullPath];
            [imageData writeToFile:fullPath atomically:NO];
        }
    }
    });
}

- (void)readImageFromLocal{

    if (imagePathArray) {
        for (int i=0; i<[imagePathArray count]; i++) {
            UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:[imagePathArray objectAtIndex:i]];
            UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(100*imageNum, 10, 90, 90)];
            [imgView setImage:savedImage];

            imgView.userInteractionEnabled=YES;
            UITapGestureRecognizer *Gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fullScreen:)];
            [imgView addGestureRecognizer:Gesture];
            
            [self.scrollView addSubview:imgView];
            [self.scrollView setContentSize:CGSizeMake(100*(imageNum+1), 0)];
            imageNum++;

        }
    }
}

-(void)readDataFromAVOS{

    AVQuery *query=[AVQuery queryWithClassName:@"JKCheckUpRecord"];
    
    [query selectKeys:@[@"imagePathArray",@"indexArray"]];
    
    [query whereKey:@"objectId" equalTo:checkUpRecord.objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
                imagePathArray=[[objects objectAtIndex:0] objectForKey:@"imagePathArray"];
                checkUpRecord.indexArray=[[objects objectAtIndex:0] objectForKey:@"indexArray"];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *path=[imagePathArray objectAtIndex:0];
                
                if ([fileManager fileExistsAtPath:path]) {
                    [self readImageFromLocal];

                }else{
                    //[self readImageFromAVOS];
                }
            
            [self.tableView reloadData];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息加载失败" message:@"网络有点不给力哦，请稍后再试~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
    query=nil;
}

-(void)readImageFromAVOS{
    
    AVQuery *query=[AVQuery queryWithClassName:@"JKCheckUpRecord"];
    
    [query selectKeys:@[@"imageArray"]];
    
    [query whereKey:@"objectId" equalTo:checkUpRecord.objectId];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if (!error) {
            AVFile *file=[[objects objectAtIndex:0] objectForKey:@"imageArray"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                     NSArray *arr=[NSKeyedUnarchiver unarchiveObjectWithData:data];
                    for (int i=0; i<[imageArray count]; i++) {
                        
                        UIImage *savedImage = [[UIImage alloc] initWithData:[arr objectAtIndex:i]];
                        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(100*imageNum, 0, 90, 90)];
                        [imgView setImage:savedImage];
                        
                        [self.scrollView addSubview:imgView];
                        [self.scrollView setContentSize:CGSizeMake(100*imageNum, 0)];
                        imageNum++;
                    }

                }
            } progressBlock:^(NSInteger percentDone) {
                NSLog(@"%d",percentDone);
            }];
           
                    }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息加载失败" message:@"网络有点不给力哦，请稍后再试~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    
    }];

}
     
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)inputTypeLabel {
    [self showSelectView2];
}
- (void)inputTimeLabel {

    [self showSelectView1];
}

- (void)showSelectView1{
    if (typePicker.tag!=0) {
        [typePicker removeFromSuperview];
        typePicker.tag=0;
    }
    if (timePicker.tag==0) {
        actionView.title=@"请选择体检时间\n\n\n\n\n\n\n\n\n\n\n\n\n";
        [actionView addSubview:timePicker];
        timePicker.tag=1;
    }
    [actionView showInView:self.tableView];
}

- (void)showSelectView2{
    if (timePicker.tag!=0) {
        [timePicker removeFromSuperview];
        timePicker.tag=0;
    }
    if (typePicker.tag==0) {
        actionView.title=@"请选择体检项目\n\n\n\n\n\n\n\n\n\n\n\n\n";
        [actionView addSubview:typePicker];
        typePicker.tag=1;
    }
    [actionView showInView:self.tableView];
}
//*********************pickerView********************//
//  返回1列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

//  返回每一列的列表项数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [checkUpType count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [checkUpType objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    selectedType=[checkUpType objectAtIndex:row];
}

//*********************tableView********************//
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BOOL nibsRegistered = NO;
    
    static NSString *Cellidentifier=@"indexCell";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"indexCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
        nibsRegistered = YES;
    }
    
    indexCell *cell=[tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
    
	NSUInteger row=[indexPath row];
    
    cell.indexNameLabel.text=[[checkUpRecord.indexArray objectAtIndex:row] objectForKey:@"indexName"];
    cell.referenceLabel.text=[[checkUpRecord.indexArray objectAtIndex:row] objectForKey:@"reference"];
    cell.statusLabel.text=[[checkUpRecord.indexArray objectAtIndex:row] objectForKey:@"status"];
    cell.valueLabel.text=[[checkUpRecord.indexArray objectAtIndex:row] objectForKey:@"value"];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [checkUpRecord.indexArray count];
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
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [[tableView cellForRowAtIndexPath:indexPath] setSelectionStyle:UITableViewCellSelectionStyleGray];
//    NSUInteger row = [indexPath row];
//    [self loadDetailView:row];
//    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
}


- (void)refreshTableView{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
