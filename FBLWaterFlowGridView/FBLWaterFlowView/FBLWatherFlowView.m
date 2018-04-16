//
//  FBLWatherFlowView.m
//  FBLWaterFlowGridView
//
//  Created by fatboyli on 15/11/17.
//  Copyright © 2015年 fatboyli. All rights reserved.
//

#import "FBLWatherFlowView.h"

#define KEY_CELLFRAMES_NAME                                         @"KEY_CELLFRAMES_NAME"
#define KEY_HEADERFRAMES_NAME                                       @"KEY_HEADERFRAMES_NAME"
#define KEY_FOOTERERFRAMES_NAME                                     @"KEY_FOOTERERFRAMES_NAME"

#define KEY_DEQUE_CLASSNAME                                         @"KEY_DEQUE_CLASSNAME"
#define KEY_DEQUE_OBJECTARRAY                                       @"KEY_DEQUE_OBJECTARRAY"

#define KEY_DISPLAYDICT_HEADERPREFIX                                @"header"
#define KEY_DISPLAYDICT_FOOTERPREFIX                                @"footer"

#define KEY_VIEWTYPE_HEADER                                         @"KEY_VIEWTYP_HEADER"
#define KEY_VIEWTYPE_FOOTER                                         @"KEY_VIEWTYP_FOOTER"
#define KEY_VIEWTYPE_CELL                                           @"KEY_VIEWTYP_CELL"


@implementation FBLWatherFlowViewLayoutNode

@end


@interface FBLWatherFlowViewLayoutNodeManager()
@property (nonatomic ,strong)NSMutableArray                          *nodeArray;  //用区间去做线段树
@property (nonatomic ,assign)NSInteger                               totalleft;  //用区间去做线段树
@property (nonatomic ,assign)NSInteger                               totalright;  //用区间去做线段树

@end

@implementation FBLWatherFlowViewLayoutNodeManager

- (instancetype)initWithLeft:(NSInteger)left right:(NSInteger)right value:(CGFloat)value
{
    self = [super init];
    self.nodeArray = [NSMutableArray new];
    
    FBLWatherFlowViewLayoutNode *rootNode = [FBLWatherFlowViewLayoutNode new];
    rootNode.left = left;
    rootNode.right = right;
    rootNode.value = value;
    self.totalleft = left;
    self.totalright  = right;
    [self.nodeArray addObject:rootNode];
    return self;
}

//这个是最核心的算法了，很复杂。基于线段树的思想,把线段树变成数组，处理逻辑
- (CGRect)addSize:(CGSize)size
{
    NSArray * valueSortArray = [self getValueSortArray];
    //开始遍历
    if(size.width > (self.totalright - self.totalleft))
    {
        size.width = self.totalright - self.totalleft - 1.0;        //不能越界
    }
    BOOL find = NO;
    CGFloat currentY = [valueSortArray[0] floatValue]; // 必须从下一个像素开始
    for (int i = 0 ; i < [valueSortArray count] && !find; i ++)
    {
        currentY = [valueSortArray[i] floatValue];          //开始遍历最大值，肯定有一个是成功的拉
        for(int nodeIndex = 0 ; nodeIndex < [self.nodeArray count] ; nodeIndex ++)
        {
            FBLWatherFlowViewLayoutNode *currentNode = self.nodeArray[nodeIndex];
            if((currentNode.value > currentY)) //这里不能用等于
            {
                ;
            }else{ //小于的话，说明可以开始
                NSInteger endIndex = [self getEndIndeWithCurrentIndex:nodeIndex sizeWidth:size.width];
                //等于-1 说明不够长
                if(endIndex == -1) //已经不够长了
                {
                    break;  //跳出内层荀晗
                }
                BOOL isBadNodeindex = NO;
                for(int j = nodeIndex + 1; j <= endIndex ; j ++) //必须用<= 这里操作都是闭区间的
                {
                    FBLWatherFlowViewLayoutNode *tmpNode = self.nodeArray[j];
                    if(tmpNode.value > currentY)
                    {
                        isBadNodeindex = YES;       //说明后面有比这个高的，不可以
                        break;
                    }
                }
                if(isBadNodeindex)
                {
                    continue;
                }else
                {
                    find = YES;
                    CGRect resRect =  CGRectMake(currentNode.left, currentY, size.width, size.height); //压住的阴影
                    [self splitNodeArrayWithRect:resRect beiginIndex:nodeIndex endIndex:endIndex];
//                    NSLog(@"add size :CGsize(%f,%f) array is:%@", size.width , size.height , [self getNodeStr]);
                    return resRect;
                }
                
            }
        }
    }
    
    return CGRectMake(0, 0, 0, 0);
}

- (NSString *)getNodeStr
{
    NSMutableString *mutableStr = [NSMutableString new];
    for(int i = 0 ; i < [self.nodeArray count ] ; i ++)
    {
        FBLWatherFlowViewLayoutNode * tmpNode = self.nodeArray[i];
        [mutableStr appendString:[NSString stringWithFormat:@"\n left:%f right:%f value:%f" ,tmpNode.left ,tmpNode.right ,tmpNode.value ]];
    }
    return mutableStr;
}

- (void)splitNodeArrayWithRect:(CGRect)shdowRect beiginIndex:(NSInteger)beiginIndex endIndex:(NSInteger)endIndex   //影响的区域是beiginIndex和EndIndex
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[self.nodeArray count]];
    FBLWatherFlowViewLayoutNode *newNode = [FBLWatherFlowViewLayoutNode new];
    newNode.left = shdowRect.origin.x;
    newNode.right = shdowRect.origin.x + shdowRect.size.width;
    newNode.value = shdowRect.origin.y + shdowRect.size.height;
    for(NSInteger i = 0 ;i < beiginIndex ;i ++)
    {
        FBLWatherFlowViewLayoutNode *tmpNode = self.nodeArray[i];
        [array addObject:tmpNode];
    }
    [array addObject:newNode];//把新的node添加上
    FBLWatherFlowViewLayoutNode *endNode = self.nodeArray[endIndex];  //有可能吧endIndex 给截断
    if(endNode.right > newNode.right)
    {
        FBLWatherFlowViewLayoutNode * newPartNode = [FBLWatherFlowViewLayoutNode new];  //有可能吧endIndex 给截断
        newPartNode.left = newNode.right;
        newPartNode.right = endNode.right;
        newPartNode.value = endNode.value;
        [array addObject:newPartNode];
    }
    for(NSInteger i = endIndex+1 ;i < [self.nodeArray count] ;i ++)
    {
        FBLWatherFlowViewLayoutNode *tmpNode = self.nodeArray[i];
        [array addObject:tmpNode];
    }
    [self.nodeArray removeAllObjects];
    self.nodeArray = nil;
    self.nodeArray = array;
}

- (NSInteger)getEndIndeWithCurrentIndex:(NSInteger)currentIndex sizeWidth:(CGFloat)sizeWidth
{
    FBLWatherFlowViewLayoutNode *currentNode = self.nodeArray[currentIndex];
    CGFloat left  = currentNode.left;
    CGFloat endRight = left + sizeWidth;
    for (NSInteger j = currentIndex; j < [self.nodeArray count]; j ++)
    {
        FBLWatherFlowViewLayoutNode *tmpNode = self.nodeArray[j];
        if(tmpNode.right >= endRight ) //说明找到了
        {
            return j;
        }
    }
    FBLWatherFlowViewLayoutNode * lastNode = self.nodeArray[[self.nodeArray count] -1];
    if(endRight > lastNode.right)   //如果超过最后一个，返回-1
    {
        return -1;
    }
    return [self.nodeArray count] - 1;   //返回最后一个就可以了
}

- (NSArray *)getValueSortArray
{
    //通过冒泡排序 这里没有几个，所以应该是可以用这种排序的，一行最多也就五个
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[self.nodeArray count]];
    for(int i = 0 ; i < [self.nodeArray count]; i ++)
    {
        [array addObject:@(((FBLWatherFlowViewLayoutNode *)self.nodeArray[i]).value)];
    }
    
    for(int i = 0 ; i < [array count] ; i++)
    {
        for(int j = i +1; j < [array count] ; j ++)
        {
            CGFloat jValue = [array[j] floatValue];
            CGFloat iValue = [array[i] floatValue];
            if(jValue < iValue)
            {
                array[i] = @(jValue);       //互换
                array[j] = @(iValue);
            }
        }
    }
    return array;                           //这样就可以了排序了
}

- (NSInteger)maxValueIndex
{
    NSInteger maxIndex = 0;
    CGFloat maxValue = ((FBLWatherFlowViewLayoutNode *)self.nodeArray[0]).value;
    for (NSInteger i = 1 ; i < [self.nodeArray count]; i ++)
    {
        FBLWatherFlowViewLayoutNode *tmpNode = self.nodeArray[i];
        if(tmpNode.value > maxValue)
        {
            maxIndex = i;
            maxValue = tmpNode.value;
        }
    }
    return maxIndex;
}

- (NSInteger)maxValue
{
    NSInteger index = [self maxValueIndex];
    return ((FBLWatherFlowViewLayoutNode *)self.nodeArray[index]).value;
}

@end

/////////////////////////////////////////////////////////////////////
@interface FBLWatherFlowView()

@property (nonatomic ,strong)NSMutableArray                              *frameAttributes;
@property (nonatomic ,strong)NSMutableDictionary                         *dequeueCellDict;
//缓冲池
@property (nonatomic ,strong)NSMutableDictionary                         *displayingCells;  //用区间去做线段树
@property (nonatomic ,assign)CGFloat                                     lastReloadWidth;  //用区间去做线段树
@end

@implementation FBLWatherFlowView

#pragma mark -懒加载

- (NSMutableArray *)frameAttributes
{
    if(_frameAttributes == nil)
    {
        _frameAttributes = [NSMutableArray new];
    }
    return _frameAttributes;
}

- (NSMutableDictionary *)dequeueCellDict
{
    if(_dequeueCellDict == nil)
    {
        _dequeueCellDict = [NSMutableDictionary new];
    }
    return _dequeueCellDict;
}


- (NSMutableDictionary *)displayingCells
{
    if(_displayingCells == nil)
    {
        _displayingCells = [NSMutableDictionary new];
    }
    return _displayingCells;
}



#pragma mark -end

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    return self;
}


#pragma mark -layoutAbout

- (void)setDataSource:(id<FBLWatherFlowViewDataSource>)dataSource
{
    _dataSource = dataSource;
}

- (void)resetView
{
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.frameAttributes removeAllObjects];
    
    NSArray *keys=  [self.displayingCells allKeys];
    for (int i = 0; i < [keys count]; i++)
    {
        FBLWatherFlowReuseView *viewcell = [self.displayingCells objectForKey:keys[i]];
        NSString *reuseIdentify = viewcell.reuseIdentify;
        NSMutableArray *array = ((NSDictionary *)self.dequeueCellDict[reuseIdentify])[KEY_DEQUE_OBJECTARRAY];
        [array addObject:viewcell];
        NSLog(@" add to cache with identify:%@", viewcell.reuseIdentify);
    }
    [self.displayingCells removeAllObjects];
    self.lastReloadWidth = self.bounds.size.width;
}

- (void)reloadData
{
    if(!self.dataSource)                    //如果没有dataSource 就返回
    {
        return;
    }

    [self resetView];
    
    NSInteger sections = [self.dataSource numberOfSections];
    CGFloat sectionTop = 0.0;   //beigin is 0.0
    for (NSInteger sectionIndex = 0; sectionIndex < sections; sectionIndex ++)
    {
        NSMutableDictionary *sectionAttributes = [[NSMutableDictionary alloc] initWithCapacity:3];
        CGFloat headerHeight  =  [self FBLWatherFlowView:self heightForHeaderInSection:sectionIndex];
        if(headerHeight > 0)
        {
            sectionAttributes[KEY_HEADERFRAMES_NAME] = [NSValue valueWithCGRect:CGRectMake(0, sectionTop, self.bounds.size.width, headerHeight)];
        }
        NSInteger sectionCellsCount  = [self.dataSource numberOfItemsInSection:sectionIndex];
        UIEdgeInsets originsectionInsert = [self insetForSectionAtIndex:sectionIndex];   //用户给的section insert
        
        CGFloat rowSpace = [self  FBLWatherFlowView:self rowSpacingForSectionAtIndex:sectionIndex];
        CGFloat columnSpace = [self FBLWatherFlowView:self columSpacingForSectionAtIndex:sectionIndex];
        //更新sectionInsert
        UIEdgeInsets sectionInsert = UIEdgeInsetsMake(originsectionInsert.top - rowSpace/2 , originsectionInsert.left - columnSpace/2, originsectionInsert.bottom - rowSpace/2, originsectionInsert.right - columnSpace/2);             //更新后的用于排版的sectionInsert
        
        //关键部分，根据sectionCell进行排列
        sectionTop = sectionTop + headerHeight + sectionInsert.top;                     //add headerHeight                     //每个secll
        FBLWatherFlowViewLayoutNodeManager *layOutManager = [[FBLWatherFlowViewLayoutNodeManager alloc] initWithLeft:sectionInsert.left right:self.bounds.size.width - sectionInsert.right value:sectionTop];
        NSMutableArray * cellFrames = [[NSMutableArray alloc] initWithCapacity:sectionCellsCount];
        FBLWaterFlowAliginType aliginType = [self FBLWatherFlowView:self  aliginTypeForSection:sectionIndex];//对其方式
        
        CGFloat minLeft = 10000;                             //纪录最左边的值
        CGFloat maxRight = -10000;  //纪录最右边的值
        
        for (NSInteger cellIndex = 0 ; cellIndex < sectionCellsCount ; cellIndex ++)
        {
            CGSize cellSize = [self.dataSource FBLWatherFlowView:self sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:cellIndex inSection:sectionIndex]];
            
            
            CGSize newSize = CGSizeMake((NSInteger)(cellSize.width + columnSpace), (NSInteger)(cellSize.height + rowSpace)); //左右加大 为了保证线段树的封闭性，必须用int
            if(cellIndex == 34)
            {
                NSLog(@"good");
            }
            CGRect tmpcellFrame = [layOutManager addSize:newSize];

            CGRect finalRect = CGRectMake(tmpcellFrame.origin.x + columnSpace/2, tmpcellFrame.origin.y + rowSpace/2, cellSize.width, cellSize.height);
            //这里还有进行处理的
            //探测位置找到后，设置frame
            if(finalRect.origin.x < minLeft)
            {
                minLeft = finalRect.origin.x;
            }

            if(finalRect.origin.x + finalRect.size.width > maxRight)
            {
                maxRight = finalRect.origin.x + finalRect.size.width;
            }
            [cellFrames addObject:[NSValue valueWithCGRect:finalRect]];
        }
        //根据对其方式调整左右
        if(aliginType ==  FBLWaterFlowAliginTypeLeft )
        {
            ;//默认就是left布局的
        }else if(aliginType == FBLWaterFlowAliginTypeCenter)
        {
            //让左右边距相等
            CGFloat leftMargin = minLeft - originsectionInsert.left;
            CGFloat rightMargin = self.bounds.size.width - originsectionInsert.right - maxRight;    //这些都是
            CGFloat averageMarin = (leftMargin + rightMargin)/2;
            CGFloat xAddMargin = averageMarin - leftMargin;
            for (int i = 0 ; i < [cellFrames count]; i ++) {
                CGRect tmpRect = ((NSValue *)cellFrames[i]).CGRectValue;
                tmpRect.origin.x = tmpRect.origin.x + xAddMargin;
                cellFrames[i] = [NSValue valueWithCGRect:tmpRect];  //更新
            }
        }else if(aliginType == FBLWaterFlowAliginTypeRight)
        {
            CGFloat rightMargin = self.bounds.size.width - originsectionInsert.right - maxRight;    //这些都是
            CGFloat xAddMargin = rightMargin;
            for (int i = 0 ; i < [cellFrames count]; i ++) {
                CGRect tmpRect = ((NSValue *)cellFrames[i]).CGRectValue;
                tmpRect.origin.x = tmpRect.origin.x + xAddMargin;
                cellFrames[i] = [NSValue valueWithCGRect:tmpRect];  //更新
            }
        }
        sectionAttributes[KEY_CELLFRAMES_NAME] = cellFrames; //开始布局结束
        sectionTop =  layOutManager.maxValue + sectionInsert.bottom;        // add MaxValue
        CGFloat footerHeight  =  [self FBLWatherFlowView:self heightForHeaderInSection:sectionIndex];
        if(footerHeight > 0)
        {
            sectionAttributes[KEY_FOOTERERFRAMES_NAME] = [NSValue valueWithCGRect:CGRectMake(0, sectionTop, self.bounds.size.width, footerHeight)]; //add footerHeight
        }
        sectionTop += footerHeight;
        [self.frameAttributes addObject:sectionAttributes];
    }
    
    //这里开始布局
    [self setContentSize:CGSizeMake(self.bounds.size.width, sectionTop)]; //设置布局
//    [self setContentOffset:CGPointZero];
//    [self setTestUI];   //加载测试的UIin
    
}

//- (void)setTestUI
//{
//    for (int sectionIndex = 0; sectionIndex < [self.frameAttributes count]; sectionIndex ++) {
//        NSDictionary *sectionFrameDict = self.frameAttributes[sectionIndex];
//        NSValue *headerFrameValue = sectionFrameDict[KEY_HEADERFRAMES_NAME];
//        if(headerFrameValue)
//        {
//            CGRect rect = headerFrameValue.CGRectValue;
//            UIView *headerView = [self.dataSource headerForSection:sectionIndex];// [[UIView alloc] initWithFrame:rect];
//            [headerView setFrame:rect];
//            [self addSubview:headerView];
//        }
//        NSArray *cellFrameArray = sectionFrameDict[KEY_CELLFRAMES_NAME];
//        for(int cellIndex  = 0 ; cellIndex < [cellFrameArray count] ; cellIndex ++)
//        {
//            NSValue *rectValue = cellFrameArray[cellIndex];
//            UIView *cellView = [self.dataSource FBLWatherFlowView:self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:cellIndex inSection:sectionIndex]];
//            [cellView setFrame:rectValue.CGRectValue];
//          
//            [self addSubview:cellView];
//        }
//        NSValue *footerFrameValue = sectionFrameDict[KEY_FOOTERERFRAMES_NAME];
//        if(footerFrameValue)
//        {
//            CGRect rect = footerFrameValue.CGRectValue;
//            UIView *footView =[self.dataSource footerForSection:sectionIndex];
//            [footView  setFrame:rect];
//            [self addSubview:footView];
//        }
//    }
//}


- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)sectionIndex
{
    if([self.dataSource respondsToSelector:@selector(FBLWatherFlowView:insetForSectionAtIndex:)])
    {
        return [self.dataSource FBLWatherFlowView:self insetForSectionAtIndex:sectionIndex];
    }
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - reuse about
- (void)registerClass:(Class)className forIdentify:(NSString *)identify
{
    if(className && identify.length >0)
    {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        dict[KEY_DEQUE_CLASSNAME] = className;
        dict[KEY_DEQUE_OBJECTARRAY] = [NSMutableArray new];
        self.dequeueCellDict[identify] = dict;
    }
}
- (FBLWatherFlowReuseView *)dequeueReusablecellWithIdentify:(NSString *)identify
{
    if(identify.length <=0)
    {
        return nil;
    }
    NSDictionary *dict= self.dequeueCellDict[identify];
    Class theClass = dict[KEY_DEQUE_CLASSNAME];
    NSMutableArray *array = dict[KEY_DEQUE_OBJECTARRAY];
    if(!array || [array count] ==0)
    {
        FBLWatherFlowReuseView *view =[theClass new];
        view.reuseIdentify = identify;
        NSLog(@"new class %@ with identify %@", theClass , identify);
        return view;
    }else{
        FBLWatherFlowReuseView *view = array[0];
        [array removeObjectAtIndex:0];
        NSLog(@"reuse class %@ with identify %@ leftCount:%ld", theClass , identify , [array count]);
        return view;
    }
    
}

#pragma mark -end
 -(BOOL)isInScreen:(CGRect)frame
{
    BOOL isInscreen = ((CGRectGetMaxY(frame)>=self.contentOffset.y)&&(CGRectGetMaxY(frame) <= self.contentOffset.y+self.frame.size.height))
    || ( (CGRectGetMinY(frame)>=self.contentOffset.y)&&(CGRectGetMinY(frame)<=self.contentOffset.y+self.frame.size.height))
    || ( (CGRectGetMaxY(frame) >= (self.contentOffset.y + self.frame.size.height)) && (CGRectGetMinY(frame) <= self.contentOffset.y));
    return isInscreen;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if(self.lastReloadWidth != self.bounds.size.width)
    {
        [self reloadData];
        self.lastReloadWidth = self.bounds.size.width;
    }
 
    for(NSInteger sectionIndex = 0 ;sectionIndex < [self.frameAttributes count] ;sectionIndex ++)
    {
        NSDictionary *dict = self.frameAttributes[sectionIndex];
        
        CGRect headerFrame = ((NSValue *)dict[KEY_HEADERFRAMES_NAME]).CGRectValue;
        NSString *headerkey =[NSString stringWithFormat:@"%ld-%@", sectionIndex,KEY_DISPLAYDICT_HEADERPREFIX];
        [self progressReuseViewWithKey:headerkey withFrame:headerFrame withType:KEY_VIEWTYPE_HEADER WithIndexPath:[NSIndexPath indexPathForItem:0 inSection:sectionIndex]];
        NSArray *cellFrames = dict[KEY_CELLFRAMES_NAME];
        for(NSInteger cellIndex = 0 ; cellIndex < [cellFrames count] ;cellIndex ++)
        {
            CGRect cellFrame = ((NSValue *)cellFrames[cellIndex]).CGRectValue;
            NSString *key =[NSString stringWithFormat:@"%ld-%ld", sectionIndex ,cellIndex];
            [self progressReuseViewWithKey:key withFrame:cellFrame withType:KEY_VIEWTYPE_CELL WithIndexPath:[NSIndexPath indexPathForItem:cellIndex inSection:sectionIndex]];
            
        }
        //footer
        CGRect  footerFrame = ((NSValue *)dict[KEY_FOOTERERFRAMES_NAME]).CGRectValue;
        NSString *footerkey =[NSString stringWithFormat:@"%ld-%@", sectionIndex, KEY_DISPLAYDICT_FOOTERPREFIX];
        [self progressReuseViewWithKey:footerkey withFrame:footerFrame withType:KEY_VIEWTYPE_FOOTER WithIndexPath:[NSIndexPath indexPathForItem:0 inSection:sectionIndex]];
    }
   
}

- (void)progressReuseViewWithKey:(NSString *)key withFrame:(CGRect)frame withType:(NSString *)type WithIndexPath:(NSIndexPath *)path
{
    
    FBLWatherFlowReuseView * viewCell = self.displayingCells[key];    //这里来设置key
    if([self isInScreen:frame])
    {
        if(viewCell == nil)
        {
            if([type isEqualToString:KEY_VIEWTYPE_CELL])
            {
                viewCell =  [self.dataSource FBLWatherFlowView:self cellForItemAtIndexPath:path];
 
            }else if([type isEqualToString:KEY_VIEWTYPE_HEADER])
            {
                viewCell =  [self.dataSource headerForSection:path.section];
            }else if([type isEqualToString:KEY_VIEWTYPE_FOOTER])
            {
                viewCell =  [self.dataSource footerForSection:path.section];
            }

            viewCell.frame = frame;
            [self addSubview:viewCell];
            self.displayingCells[key] = viewCell;
        }
    }else{
        if(viewCell)
        {
            [viewCell removeFromSuperview];
            [self.displayingCells removeObjectForKey:key];
            NSMutableArray *array = self.dequeueCellDict[viewCell.reuseIdentify][KEY_DEQUE_OBJECTARRAY]; //这里是identify
             NSLog(@" add to cache with identify:%@", viewCell.reuseIdentify);
            [array addObject:viewCell];
        }
    }
    

}

#pragma mark -touchEnd

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(![self.wahterDelegate respondsToSelector:@selector(FBLWatherFlowView:didSelectItemAtIndexPath:)])
    {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint point1 = [touch locationInView:touch.view];
    CGPoint point = [touch locationInView:self];
    __block NSIndexPath *selectIndex = nil;
    [self.displayingCells enumerateKeysAndObjectsUsingBlock:^(NSString *key, FBLWatherFlowReuseView * viewcell, BOOL * _Nonnull stop) {
       
        if(CGRectContainsPoint(viewcell.frame, point))
        {
            
//            selectIndex = key;
            if([key rangeOfString:KEY_DISPLAYDICT_HEADERPREFIX].location == NSNotFound && [key rangeOfString:KEY_DISPLAYDICT_FOOTERPREFIX].location == NSNotFound) //不处理header和footer
            {
                NSArray * array =[key componentsSeparatedByString:@"-"];
                if([array count ] ==2)
                {
                    NSInteger section = [array[0] integerValue];
                    NSInteger row = [array[1] integerValue];
                    selectIndex = [NSIndexPath indexPathForItem:row inSection:section];
                }
            }
            *stop = YES;
        }
        
    }];
    
    if(selectIndex)
    {
        [self.wahterDelegate FBLWatherFlowView:self didSelectItemAtIndexPath:selectIndex];
    }
    
}

#pragma mark -delegate about

- (FBLWatherFlowReuseView *)headerForSection:(NSInteger )section
{
    if([self.dataSource respondsToSelector:@selector(headerForSection:)])
    {
        return [self.dataSource headerForSection:section];
    }else{
        return nil;
    }
}
- (FBLWatherFlowReuseView *)footerForSection:(NSInteger )section
{
    if([self.dataSource respondsToSelector:@selector(footerForSection:)])
    {
        return [self.dataSource footerForSection:section];
    }else{
        return nil;
    }
}
 
- (UIEdgeInsets)FBLWatherFlowView:(FBLWatherFlowView *)watherFlowView insetForSectionAtIndex:(NSInteger)section
{
    if([self.dataSource respondsToSelector:@selector(FBLWatherFlowView:insetForSectionAtIndex:)])
    {
        return [self.dataSource FBLWatherFlowView:self insetForSectionAtIndex:section];
    }
    return UIEdgeInsetsZero;
}
- (CGFloat)FBLWatherFlowView:(FBLWatherFlowView *)watherFlowView rowSpacingForSectionAtIndex:(NSInteger)section
{
    if([self.dataSource respondsToSelector:@selector(FBLWatherFlowView:rowSpacingForSectionAtIndex:)])
    {
        return [self.dataSource FBLWatherFlowView:self rowSpacingForSectionAtIndex:section];
    }
    return 5.0;
}

- (CGFloat)FBLWatherFlowView:(FBLWatherFlowView *)watherFlowView columSpacingForSectionAtIndex:(NSInteger)section
{
    if([self.dataSource respondsToSelector:@selector(FBLWatherFlowView:columSpacingForSectionAtIndex:)])
    {
        return  [self.dataSource FBLWatherFlowView:self columSpacingForSectionAtIndex:section];
    }
    return 5.0;
}
- (CGFloat)FBLWatherFlowView:(FBLWatherFlowView *)watherFlowView heightForHeaderInSection:(NSInteger)section
{
    if([self.dataSource respondsToSelector:@selector(FBLWatherFlowView:heightForHeaderInSection:)])
    {
        return [self.dataSource FBLWatherFlowView:self heightForHeaderInSection:section];
    }
    return 0.0;
}
- (CGFloat)FBLWatherFlowView:(FBLWatherFlowView *)watherFlowView heightForFooterInSection:(NSInteger)section
{
    if([self.dataSource respondsToSelector:@selector(FBLWatherFlowView:heightForFooterInSection:)])
    {
        return [self.dataSource FBLWatherFlowView:self heightForFooterInSection:section];
    }
    return 0.0;
}
- (FBLWaterFlowAliginType)FBLWatherFlowView:(FBLWatherFlowView *)watherFlowView aliginTypeForSection:(NSInteger)section
{
    if([self.dataSource respondsToSelector:@selector(FBLWatherFlowView:aliginTypeForSection:)])
    {
        return [self.dataSource FBLWatherFlowView:self aliginTypeForSection:section];
    }
    return FBLWaterFlowAliginTypeCenter;
}



@end
