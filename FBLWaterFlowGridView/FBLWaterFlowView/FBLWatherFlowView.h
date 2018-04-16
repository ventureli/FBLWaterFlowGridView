//
//  FBLWatherFlowView.h
//  FBLWaterFlowGridView
//
//  Created by fatboyli on 15/11/17.
//  Copyright © 2015年 fatboyli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBLWatherFlowReuseView.h"


@interface FBLWatherFlowViewLayoutNode : NSObject

@property(nonatomic ,assign)CGFloat                 left;           //左边区间
@property(nonatomic ,assign)CGFloat                 right;          //右边区间
@property(nonatomic ,assign)CGFloat                 value;          //当前值


@end

typedef enum FBLWaterFlowAliginType
{
    FBLWaterFlowAliginTypeLeft = 0,
    FBLWaterFlowAliginTypeCenter = 1,
    FBLWaterFlowAliginTypeRight = 2,
    
}FBLWaterFlowAliginType;

@interface FBLWatherFlowViewLayoutNodeManager : NSObject
- (NSInteger)maxValue;
@end

@class FBLWatherFlowView;

@protocol FBLWatherFlowViewDataSource <NSObject>

@required
- (NSInteger)numberOfSections;                                                          //有多少个section
- (NSInteger)numberOfItemsInSection:(NSInteger)section;                                 //每个section中有多好个ITM
- (FBLWatherFlowReuseView *)FBLWatherFlowView:(FBLWatherFlowView *)watherFlowView  cellForItemAtIndexPath:(NSIndexPath *)indexPath;            //取得cell
- (CGSize)FBLWatherFlowView:(FBLWatherFlowView *)watherFlowView sizeForItemAtIndexPath:(NSIndexPath *)indexPath;            //item size ,size 的单位是 行列
@optional
- (FBLWatherFlowReuseView *)headerForSection:(NSInteger )section;                       //取得header
- (FBLWatherFlowReuseView *)footerForSection:(NSInteger )section;                       //取得footer

- (UIEdgeInsets)FBLWatherFlowView:(FBLWatherFlowView *)watherFlowView insetForSectionAtIndex:(NSInteger)section;            //sectionInsert
- (CGFloat)FBLWatherFlowView:(FBLWatherFlowView *)watherFlowView rowSpacingForSectionAtIndex:(NSInteger)section;            //topmargin最小值
- (CGFloat)FBLWatherFlowView:(FBLWatherFlowView *)watherFlowView columSpacingForSectionAtIndex:(NSInteger)section;          //rightmarigin最小值
- (CGFloat)FBLWatherFlowView:(FBLWatherFlowView *)watherFlowView heightForHeaderInSection:(NSInteger)section;               //header 高度
- (CGFloat)FBLWatherFlowView:(FBLWatherFlowView *)watherFlowView heightForFooterInSection:(NSInteger)section;                //footer 高度
- (FBLWaterFlowAliginType)FBLWatherFlowView:(FBLWatherFlowView *)watherFlowView aliginTypeForSection:(NSInteger)section;



@end

@protocol FBLWatherFlowViewDelegate <NSObject>

- (void)FBLWatherFlowView:(FBLWatherFlowView *)watherFlowView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;            //目前只支持这一个代理方法

@end


@interface FBLWatherFlowView : UIScrollView                     //没有这种view ，参考tableView 和collectionView 创造一个瀑布流卡片式布局view，datasource和delegate 参考tableView,目前只支持竖屏滑动，不支持横屏滑动

@property(nonatomic , weak)id<FBLWatherFlowViewDataSource>                                  dataSource;
@property(nonatomic , weak)id<FBLWatherFlowViewDelegate>                                    wahterDelegate;


- (void)reloadData;                                             //关键方法重新加载数据
- (void)registerClass:(Class)className forIdentify:(NSString *)identify;
- (FBLWatherFlowReuseView *)dequeueReusablecellWithIdentify:(NSString *)identify;

@end
