//
//  GAIndivid.m
//  GeneticAlgorithm
//
//  Created by Oxygen on 16.09.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import "GAIndivid.h"

@implementation GAIndivid

- (id)initWithBinCode:(NSArray *)binCode value:(NSNumber *)aNumber fitness:(NSNumber *)aFitness
{
    self = [super init];
    if(self) {
        self.binaryCode = binCode;
        self.value = aNumber;
        self.fitness = aFitness;
    }
    return self;
}

@end
