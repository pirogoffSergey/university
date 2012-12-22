//
//  GAInequality.h
//  GeneticAlgorithm
//
//  Created by Oxygen on 22.12.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    kLess = 0,
    kLessOrEqual = 1,
    kHigher = 2,
    kHigherOrEqual = 3
} GAInequalitySignType;


//  Ax1 + Bx2 <= C

@interface GAInequality : NSObject

@property (assign) CGFloat a;
@property (assign) CGFloat b;
@property (assign) CGFloat c;
@property (nonatomic, assign) GAInequalitySignType signType;

- (id)initWithA:(CGFloat)a B:(CGFloat)b C:(CGFloat)c;
- (BOOL)doesDotBelongToInequality:(CGPoint)dot;

- (CGFloat)asFunction:(CGFloat)x;

@end
