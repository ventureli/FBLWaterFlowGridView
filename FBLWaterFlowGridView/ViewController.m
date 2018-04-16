//
//  ViewController.m
//  FBLWaterFlowGridView
//
//  Created by fatboyli on 15/11/17.
//  Copyright © 2015年 fatboyli. All rights reserved.
//

#import "ViewController.h"
#import "FBLWatherFlowView.h"
#import "FBLHeaderView.h"
@interface ViewController ()<FBLWatherFlowViewDataSource ,FBLWatherFlowViewDelegate>

@property (nonatomic ,strong)NSArray                                                *listData;
@property (nonatomic ,strong)FBLWatherFlowView                                      *mainView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self fixData];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.mainView = [[FBLWatherFlowView alloc] initWithFrame:self.view.bounds];
    //注册接口
    [self.mainView registerClass:[FBLMyHeaderView class] forIdentify:@"header"];
    [self.mainView registerClass:[FBLMyFooterView class] forIdentify:@"footer"];
    [self.mainView registerClass:[FBLMyCellView class] forIdentify:@"cell"];
    self.mainView.wahterDelegate = self;
    self.mainView.dataSource = self;
    self.mainView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.mainView];
    [self.mainView reloadData];
    
}

- (void)fixData
{
    int firstWidth = (self.view.bounds.size.width - 100)/3.0;   //不能出现循环小数
    int secondWidth = (self.view.bounds.size.width - 100)/6.0;
    int thirdWidth = (self.view.bounds.size.width - 100)/3.0;
    self.listData = @[
                      @[
                          
                          [NSValue valueWithCGSize:CGSizeMake(firstWidth, 200)],
                          [NSValue valueWithCGSize:CGSizeMake(firstWidth, 200)],
                          [NSValue valueWithCGSize:CGSizeMake(firstWidth, 95)],
                          [NSValue valueWithCGSize:CGSizeMake(firstWidth, 95)],
                          
                          [NSValue valueWithCGSize:CGSizeMake(firstWidth, 200)],
                          [NSValue valueWithCGSize:CGSizeMake(firstWidth, 200)],
                          [NSValue valueWithCGSize:CGSizeMake(firstWidth, 60)],
                          [NSValue valueWithCGSize:CGSizeMake(firstWidth, 60)],
                          [NSValue valueWithCGSize:CGSizeMake(firstWidth, 60)],
                          
                          [NSValue valueWithCGSize:CGSizeMake(firstWidth, 200)],
                          [NSValue valueWithCGSize:CGSizeMake(firstWidth, 200)],
                          [NSValue valueWithCGSize:CGSizeMake(firstWidth, 42.5)],
                          [NSValue valueWithCGSize:CGSizeMake(firstWidth, 42.5)],
                          [NSValue valueWithCGSize:CGSizeMake(firstWidth, 42.5)],
                          [NSValue valueWithCGSize:CGSizeMake(firstWidth, 42.5)],
                          
                          ],
                      @[
                          
                          
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth * 2 + 10, secondWidth * 2 +10)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth * 5 + 40)],
                          
                          

                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth * 2 + 10, secondWidth * 2 +10)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
//                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
//                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
//                          [NSValue valueWithCGSize:CGSizeMake(secondWidth, secondWidth)],
                          
                          ],
                      
                      @[
                          
                          
                          [NSValue valueWithCGSize:CGSizeMake(thirdWidth, 200)],
                          [NSValue valueWithCGSize:CGSizeMake(thirdWidth, 150)],
                          [NSValue valueWithCGSize:CGSizeMake(thirdWidth, 180)],
                          [NSValue valueWithCGSize:CGSizeMake(thirdWidth, 230)],
                          
                          [NSValue valueWithCGSize:CGSizeMake(thirdWidth, 210)],
                          [NSValue valueWithCGSize:CGSizeMake(thirdWidth, 160)],
                          [NSValue valueWithCGSize:CGSizeMake(thirdWidth, 90)],
                          [NSValue valueWithCGSize:CGSizeMake(thirdWidth, 120)],
                          [NSValue valueWithCGSize:CGSizeMake(thirdWidth, 240)],
                          
                          [NSValue valueWithCGSize:CGSizeMake(thirdWidth, 200)],
                          [NSValue valueWithCGSize:CGSizeMake(thirdWidth, 360)],
                          [NSValue valueWithCGSize:CGSizeMake(thirdWidth, 200)],
                          [NSValue valueWithCGSize:CGSizeMake(thirdWidth, 150)],
                          [NSValue valueWithCGSize:CGSizeMake(thirdWidth, 180)],
                          [NSValue valueWithCGSize:CGSizeMake(thirdWidth, 290)],
                          
                          [NSValue valueWithCGSize:CGSizeMake(thirdWidth, 110)],
                          [NSValue valueWithCGSize:CGSizeMake(thirdWidth, 160)],
                          [NSValue valueWithCGSize:CGSizeMake(thirdWidth, 128)],
                          [NSValue valueWithCGSize:CGSizeMake(thirdWidth, 120)],
                          [NSValue valueWithCGSize:CGSizeMake(thirdWidth, 265)],
                          
                          [NSValue valueWithCGSize:CGSizeMake(thirdWidth, 78)],
                          [NSValue valueWithCGSize:CGSizeMake(thirdWidth, 198)],
                  

                          
                          ],
                      @[
                          
                          [NSValue valueWithCGSize:CGSizeMake(500, 100)],
                          [NSValue valueWithCGSize:CGSizeMake(300, 100)],
                          [NSValue valueWithCGSize:CGSizeMake(50, 100)],
                          [NSValue valueWithCGSize:CGSizeMake(200, 100)],
                          [NSValue valueWithCGSize:CGSizeMake(80, 180)],
                          [NSValue valueWithCGSize:CGSizeMake(40, 50)],
                          [NSValue valueWithCGSize:CGSizeMake(40, 50)],
                          [NSValue valueWithCGSize:CGSizeMake(40, 50)],
                          [NSValue valueWithCGSize:CGSizeMake(40, 50)],
                          [NSValue valueWithCGSize:CGSizeMake(260, 190)],
                          [NSValue valueWithCGSize:CGSizeMake(200, 90)],
                          [NSValue valueWithCGSize:CGSizeMake(200, 90)],
                          [NSValue valueWithCGSize:CGSizeMake(200, 90)],
                          [NSValue valueWithCGSize:CGSizeMake(200, 90)],
                          [NSValue valueWithCGSize:CGSizeMake(150, 100)],
                          [NSValue valueWithCGSize:CGSizeMake(100, 100)],
                          [NSValue valueWithCGSize:CGSizeMake(50, 100)],
                          [NSValue valueWithCGSize:CGSizeMake(200, 100)],
                          [NSValue valueWithCGSize:CGSizeMake(80, 80)],
                          [NSValue valueWithCGSize:CGSizeMake(40, 50)],
                          [NSValue valueWithCGSize:CGSizeMake(100, 100)],
                          ],
                      ];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -WatherFlowView delegate
- (NSInteger)numberOfSections
{
    return [self.listData count];
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = self.listData[section];
    return [array count];
}
- (FBLWatherFlowReuseView *)FBLWatherFlowView:(FBLWatherFlowView *)watherFlowView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FBLMyCellView *view = (FBLMyCellView *)[watherFlowView dequeueReusablecellWithIdentify:@"cell"];
    view.titlelabel.text = [NSString stringWithFormat:@"%ld" ,indexPath.row];
    [view setBackgroundColor:[UIColor colorWithRed:((indexPath.row *50 )%255)/255.0 green:(indexPath.row *20 )/255.0  blue:(indexPath.row *10 )/255.0  alpha:0.5]];
    return  view;//这里在测试情况下不用
}
- (FBLWatherFlowReuseView *)headerForSection:(NSInteger )section
{
    
    FBLMyHeaderView *view = (FBLMyHeaderView *)[self.mainView dequeueReusablecellWithIdentify:@"header"];
    view.titlelabel.text = [NSString stringWithFormat:@" header section:%ld" ,section];
    [view setBackgroundColor:[UIColor colorWithRed:((section *50 )%255)/255.0 green:(section *20 )/255.0  blue:(section *10 )/255.0  alpha:0.5]];
    if(section == 0)
    {
         view.titlelabel.text = [NSString stringWithFormat:@"  %ld 实现相对规则布局" ,section];
    }else if(section == 1)
    {
        view.titlelabel.text = [NSString stringWithFormat:@"  %ld 实现相对不规则布局" ,section];

    }else if(section == 2)
    {
        view.titlelabel.text = [NSString stringWithFormat:@"  %ld 实现传统瀑布流布局" ,section];
        
    }else if(section == 3)
    {
        view.titlelabel.text = [NSString stringWithFormat:@"  %ld 完全不规则布局" ,section];
        
    }

    
    
    return  view;//这里在测试情况下不用

}
- (FBLWatherFlowReuseView *)footerForSection:(NSInteger )section
{
    FBLMyFooterView *view = (FBLMyFooterView *)[self.mainView dequeueReusablecellWithIdentify:@"footer"];
    view.titlelabel.text = [NSString stringWithFormat:@" footer section:%ld" ,section];
    [view setBackgroundColor:[UIColor colorWithRed:((section *50 )%255)/255.0 green:(section *20 )/255.0  blue:(section *10 )/255.0  alpha:0.5]];
    
    return  view;//这里在测试情况下不用
}
- (FBLWaterFlowAliginType)FBLWatherFlowView:(FBLWatherFlowView *)watherFlowView aliginTypeForSection:(NSInteger)section
{
    return FBLWaterFlowAliginTypeCenter;
}
- (CGSize)FBLWatherFlowView:(FBLWatherFlowView *)watherFlowView sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSValue * value = ((NSArray *)self.listData[indexPath.section])[indexPath.row];
    return value.CGSizeValue;
}
- (UIEdgeInsets)FBLWatherFlowView:(FBLWatherFlowView *)watherFlowView insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 10, 0);
}
- (CGFloat)FBLWatherFlowView:(FBLWatherFlowView *)watherFlowView rowSpacingForSectionAtIndex:(NSInteger)section;
{
    return 10.0;
}
- (CGFloat)FBLWatherFlowView:(FBLWatherFlowView *)watherFlowView columSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}
- (CGFloat)FBLWatherFlowView:(FBLWatherFlowView *)watherFlowView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}
- (CGFloat)FBLWatherFlowView:(FBLWatherFlowView *)watherFlowView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

- (void)FBLWatherFlowView:(FBLWatherFlowView *)watherFlowView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *meessage = [NSString stringWithFormat:@"section %ld , row:%ld", indexPath.section ,indexPath.row];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"点击" message:meessage delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)viewWillLayoutSubviews
{
    [self fixData];
    [super viewWillLayoutSubviews];
}

#pragma mark -end


@end
