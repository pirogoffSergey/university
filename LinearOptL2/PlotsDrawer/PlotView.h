//
//  PlotView.h
//  PlotsDrawer
//
//  Created by Oxygen on 26.09.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PlotView : UIView

@property (nonatomic, assign) float leftBorder;
@property (nonatomic, assign) float rightBorder;
@property (nonatomic, assign) BOOL needDrawSubLines;
@property (nonatomic, copy) double(^f)(double);


@property (nonatomic, assign) BOOL isCircleDraw;

- (id)initWithFrame:(CGRect)frame;
- (void)redraw;

- (void)drawCirlceChartWithRaduis:(CGFloat)r;

- (void)addBoldDotAtX:(double)x y:(double)y;
- (void)clearDotsLayer;

@end


/*
  HOW TO USE
 
 _plotView = [[PlotView alloc] initWithFrame:self.someView.frame];
 
 _plotView.leftBorder = -4;
 _plotView.rightBorder = 4;
 
 [self.someView removeFromSuperview];
 [self.view addSubview:_plotView];

 */