//
//  GoldenSection.h
//  LinearOptimization
//
//  Created by Oxygen on 19.10.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GoldenSection : NSObject

@property (nonatomic, assign) double leftBorder;
@property (nonatomic, assign) double rightBorder;
@property (nonatomic, assign) double epsi;

@property (nonatomic, copy) double(^f)(double);

@property (nonatomic, readonly) int spentIterations;

- (double)findMin;
- (double)findMax;

@end
