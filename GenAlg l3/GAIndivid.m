//
//  GAIndivid.m
//  GeneticAlgorithm
//
//  Created by Oxygen on 16.09.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import "GAIndivid.h"

@implementation GAIndivid

- (id)initWithBinCodeX:(NSArray *)binCode1 binCodeY:(NSArray *)binCode2 fitness:(CGPoint)pt
{
    self = [super init];
    if(self) {
        self.binaryCodeX = binCode1;
        self.binaryCodeY = binCode2;
        self.pt = pt;
    }
    return self;
}

@end
