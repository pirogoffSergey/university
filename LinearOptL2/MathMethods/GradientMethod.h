//
//  GradientMethod.h
//  LinearOptimization
//
//  Created by Oxygen on 04.12.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GradientMethod : NSObject

@property (nonatomic, weak) UITextView *logView;

@property (nonatomic, assign) double r;
@property (nonatomic, assign) double a;
@property (nonatomic, assign) double b;
@property (nonatomic, assign) double c;
@property (nonatomic, assign) double d;



@property (nonatomic, assign) CGPoint foundedDot;
@property (nonatomic, assign) CGPoint projectedDot;


- (void)calculate;

@end
