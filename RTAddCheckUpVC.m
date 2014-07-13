//
//  RTAddCheckUpVC.m
//  Health
//
//  Created by GeoBeans on 14-7-12.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import "RTAddCheckUpVC.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSArray *arr1=[[NSArray alloc]initWithObjects:@"白细胞计数(WBC)",@"红细胞计数(RBC)",@"血红蛋白浓度(HGB)",@"红细胞压积(HCT)",@"平均红细胞体积(MCV)",@"平均红细胞血红蛋白含量(MCH)",@"平均红细胞血红蛋白浓度(MCHC)",@"血小板计数(PLT)",@"淋巴细胞比值(LY%)",@"单核细胞比例(MONO%)",@"中性粒细胞比例(NEUT%)",@"淋巴细胞计数(LY)(参考值：0.8~4.0)",@"单核细胞计数(MONO)",@"中性粒细胞计数(NEUT)",@"红细胞分布宽度",@"血小板体积分布宽度(PDW)", nil];
//    NSDictionary *dic1=[[NSDictionary alloc]initWithObjectsAndKeys:@"血常规",@"typeName",arr1,@"indexArray", nil];
//    
//    NSArray *arr2=[[NSArray alloc]initWithObjects:@"丙氨酸转氨酶(ALT)",@"谷-丙转氨酶(GPT)",@"门冬氨酸转氨酶(AST)",@"谷-草转氨酶(GOT)",@"碱性磷酸酶(ALP)",@"γ-谷氨酰转肽酶(GGT)",@"总胆汁酸",@"白蛋白/球蛋白(A/G)",@"总胆红素(T-Bil)",@"直接胆红素(D-Bil)",nil];
//    NSDictionary *dic2=[[NSDictionary alloc]initWithObjectsAndKeys:@"肝功能",@"typeName",arr2,@"indexArray", nil];
//    
//    NSArray *arr3=[[NSArray alloc]initWithObjects:@"血尿素氮(BUN)",@"血肌酐(Scr)",@"血尿素",@"血尿酸",@"尿肌酐(Cr)",@"尿蛋白",@"选择性蛋白尿指数(SPI)",@"β2-微球蛋白清除试验",@"尿素清除率",@"血内生肌酐清除率",@"尿素氮/肌酐比值(BUN)",@"酚红(酚磺太)排泄试验(PSP)",nil];
//    NSDictionary *dic3=[[NSDictionary alloc]initWithObjectsAndKeys:@"肾功能",@"typeName",arr3,@"indexArray", nil];
//    
//    NSArray *arr4=[[NSArray alloc]initWithObjects:@"尿白细胞（LEU）",@"亚硝酸盐（NIT）",@"尿蛋白（PRO）",@"葡萄糖（GLU-U）",@"酮体（KET）",@"尿胆原（URO）",@"胆红素（BIL）",@"尿液酸碱度（PH-U）",@"比重（SG）",@"隐血（BLU）",@"抗坏血酸（VC）",@"颜色（COL）",@"透明度（TMD）",@"吞噬细胞（TSXB）",@"白细胞管型（U_WBC-C）",@"颗粒管型（KLGX-F）",@"透明管型（U_TM-CA）",@"红细胞管型（U_RBC-）",@"蜡样管型（LYGX）",@"白细胞镜检（WBC-J1）",@"红细胞镜检",nil];
//    NSDictionary *dic4=[[NSDictionary alloc]initWithObjectsAndKeys:@"尿常规",@"typeName",arr4,@"indexArray", nil];
//    
//    NSArray *arr5=[[NSArray alloc]initWithObjects:@"总胆固醇(TC)",@"甘油三酯(TG)",@"高密度脂蛋白胆固醇(HDL-C)",@"低密度脂蛋白胆固醇(LDL-C)",@"载脂蛋白A1(ApoA1)",@"载脂蛋白B(ApoB)",@"胆固醇脂",nil];
//    NSDictionary *dic5=[[NSDictionary alloc]initWithObjectsAndKeys:@"血脂分析",@"typeName",arr5,@"indexArray", nil];
//    
//    NSArray *arr6=[[NSArray alloc]initWithObjects:@"血糖",@"类风湿因子甲胎蛋白",@"癌坯抗原",@"糖类抗原（CA-199）",@"糖类抗原（CA7-24）",@"糖类抗原（CA-242）",@"神经元特异性烯醇化酶",@"前列腺特异性抗原",@"三碘甲状腺原氨酸",@"甲状腺素",@"促甲状腺素",@"骨密度",@"骨密度",@"血压",@"心率",@"雄性激素",@"雌性激素",nil];
//    NSDictionary *dic6=[[NSDictionary alloc]initWithObjectsAndKeys:@"其他指标",@"typeName",arr6,@"indexArray", nil];
    
    //typeArray=[[NSMutableArray alloc]initWithObjects:dic1,dic2,dic3,dic4,dic5,dic6, nil];
    
    self.tableView1.dataSource=self;
    self.tableView1.delegate=self;
    self.tableView1.tag=1;
    self.tableView2.dataSource=self;
    self.tableView2.delegate=self;
    self.tableView2.tag=2;
    currentRow=0;
    NSString *plistPath=[[NSBundle mainBundle] pathForResource:@"CheckUpDictionary" ofType:@"plist"];
    checkPlist=[[NSMutableArray alloc]initWithContentsOfFile:plistPath];
    typeList =[[NSMutableArray alloc]init];
    for (NSDictionary *dic in checkPlist) {
        [typeList addObject:[dic objectForKey:@"typeName"]];
    }
    
}
- (IBAction)touchBack:(id)sender {
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)touchOK:(id)sender {
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        
        static BOOL nibsRegistered = NO;
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
        
    }else{
        static BOOL nibsRegistered = NO;
        static NSString *Cellidentifier=@"RTIndexCell";
        if (!nibsRegistered) {
            UINib *nib = [UINib nibWithNibName:@"RTIndexCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
            nibsRegistered = YES;
        }
        
        RTIndexCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RTIndexCell"];
        
        NSUInteger row=[indexPath row];
        
        NSDictionary *dic=[checkPlist objectAtIndex:currentRow];
        NSArray *indexArr=[dic objectForKey:@"indexArray"];
        cell.indexNameLabel.text=[indexArr objectAtIndex:row];

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
        return [typeList count];
    }else
        
        return [[[checkPlist objectAtIndex:currentRow] objectForKey:@"indexArray"] count];
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
    if (tableView.tag==1) {
        return 44;
    }else
        
        return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        currentRow=[indexPath row];
        [self.tableView2 reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
