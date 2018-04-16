//
//  FBLHeaderView.h
//  FBLWaterFlowGridView
//
//  Created by fatboyli on 15/11/18.
//  Copyright © 2015年 fatboyli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBLWatherFlowReuseView.h"

@interface FBLMyCellView : FBLWatherFlowReuseView

@property(nonatomic,strong)UILabel                  *titlelabel;
@end

@interface FBLMyFooterView : FBLWatherFlowReuseView

@property(nonatomic,strong)UILabel                  *titlelabel;
@end

@interface FBLMyHeaderView : FBLWatherFlowReuseView

@property(nonatomic,strong)UILabel                  *titlelabel;
@end
