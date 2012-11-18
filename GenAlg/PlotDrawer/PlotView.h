//
//  PlotView.h
//  PlotsDrawer
//
//  Created by Oxygen on 26.09.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlotViewProtocol <NSObject>

- (CGFloat)f:(CGFloat)x;

@end


@interface PlotView : UIView

@property (nonatomic, assign) float leftBorder;
@property (nonatomic, assign) float rightBorder;
@property (nonatomic, assign) BOOL needDrawSubLines;

@property (nonatomic, weak) id<PlotViewProtocol> mathDelegate;

- (id)initWithFrame:(CGRect)frame;
- (void)redraw;

@end


/*
  HOW TO USE
 
 
 _plotView = [[PlotView alloc] initWithFrame:self.someView.frame];
 
 _plotView.mathDelegate = self;
 
 _plotView.leftBorder = -4;
 _plotView.rightBorder = 4;
 
 [self.someView removeFromSuperview];
 [self.view addSubview:_plotView];

 
 // implementation of <PlotViewProtocol>
    - (float)f:(CGFloat)x
    {
        return (2 + x*x + 2*x*x*x + x*x*x*x);
    }
 
 */