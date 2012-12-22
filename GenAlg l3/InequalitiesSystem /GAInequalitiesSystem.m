//
//  GAInequalitiesSystem.m
//  GeneticAlgorithm
//
//  Created by Oxygen on 20.12.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import "GAInequalitiesSystem.h"


@interface GAInequalitiesSystem ()

@property (nonatomic, strong) NSMutableArray *system;

@end


@implementation GAInequalitiesSystem

- (id)init {
    self = [super init];
    if(self) {
        self.system = [NSMutableArray array];
    }
    return self;
}


#pragma mark -
#pragma mark Public Methods

- (void)addInequaly:(GAInequality *)ineq {
    [self.system addObject:ineq];
}

- (BOOL)doesDotBelongToSystem:(CGPoint)dot {
    
    if(!self.system.count) {
        return NO;
    }
    
    for (GAInequality *ineq in self.system) {
        if(![ineq doesDotBelongToInequality:dot]) {
            return NO; //at least one inequality bad
        }
    }
    return YES;
}

- (NSArray *)allInequalities {
    return self.system;
}

@end




