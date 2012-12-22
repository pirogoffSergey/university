//
//  PlotView.h
//  PlotsDrawer
//
//  Created by Oxygen on 26.09.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GAInequalitiesSystem.h"


@protocol PlotViewProtocol <NSObject>

- (CGFloat)f:(CGFloat)x;

@end


@interface PlotView : UIView

@property (nonatomic, assign) float leftBorder;
@property (nonatomic, assign) float rightBorder;
@property (nonatomic, assign) BOOL needDrawSubLines;

@property (nonatomic, strong) GAInequalitiesSystem *ineqSystem;


- (id)initWithFrame:(CGRect)frame;
- (void)redraw;

- (NSArray *)takePackOfDotsFromSet;

@end