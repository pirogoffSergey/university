//
//  ParabolaMethod.h
//  LinearOptimization
//
//  Created by Oxygen on 20.10.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParabolaMethod : NSObject

@property (nonatomic, assign) double leftBorder;
@property (nonatomic, assign) double rightBorder;
@property (nonatomic, assign) double h;
@property (nonatomic, assign) double epsi;

@property (nonatomic, copy) double(^f)(double);

@property (nonatomic, readonly) int spentIterations;

- (double)findMin;

@end
