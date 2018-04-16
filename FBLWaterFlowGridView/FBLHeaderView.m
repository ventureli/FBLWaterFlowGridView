//
//  FBLHeaderView.m
//  FBLWaterFlowGridView
//
//  Created by fatboyli on 15/11/18.
//  Copyright © 2015年 fatboyli. All rights reserved.
//

#import "FBLHeaderView.h"

@implementation FBLMyCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.titlelabel = [[UILabel alloc] initWithFrame:self.bounds];
    [self.titlelabel setTextColor:[UIColor redColor]];
;
    self.titlelabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.titlelabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.titlelabel];
    return self;
}

@end


@implementation FBLMyFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.titlelabel = [[UILabel alloc] initWithFrame:self.bounds];
    [self.titlelabel setTextColor:[UIColor redColor]];
    [self.titlelabel setTextAlignment:NSTextAlignmentCenter];
    self.titlelabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.titlelabel];
    return self;
}

@end

@implementation FBLMyHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.titlelabel = [[UILabel alloc] initWithFrame:self.bounds];
    [self.titlelabel setTextColor:[UIColor blackColor]];
    [self.titlelabel setFont:[UIFont boldSystemFontOfSize:30]];
    [self.titlelabel setTextAlignment:NSTextAlignmentCenter];
    self.titlelabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.titlelabel];
    return self;
}

@end
