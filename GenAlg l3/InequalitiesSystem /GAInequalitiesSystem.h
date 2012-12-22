//
//  GAInequalitiesSystem.h
//  GeneticAlgorithm
//
//  Created by Oxygen on 20.12.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GAInequality.h"


@interface GAInequalitiesSystem : NSObject

- (void)addInequaly:(GAInequality *)ineq;
- (BOOL)doesDotBelongToSystem:(CGPoint)dot;

- (NSArray *)allInequalities;

@end
