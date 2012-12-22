//
//  GeneticAlgorithmModelNew.m
//  GeneticAlgorithm
//
//  Created by Oxygen on 20.12.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import "GeneticAlgorithmModelNew.h"


@interface GeneticAlgorithmModelNew ()

@property (nonatomic, strong) NSArray *currentPopulation;

@end


@implementation GeneticAlgorithmModelNew

- (id)init
{
    self = [super init];
    if(self) {
        _binaryCodeLength = 12;
        _mutationChance = 0.3;
        
        _leftBorderX = 0;
        _rightBorderX = 20;
    }
    
    [self generateFirstPopulation];
    self.firstPopulation = self.currentPopulation;
    return self;
}


#pragma mark -
#pragma mark MainMethods

- (void)generateFirstPopulation {
    NSMutableArray *population = [NSMutableArray array];
    
    NSArray *binCode1;
    NSArray *binCode2;
    CGPoint pt;
    GAIndivid *anIndivid;
    
    for(int i=0; i<30; i++) {
        binCode1 = [self randBinIndivid];
        binCode2 = [self randBinIndivid];
        pt = CGPointMake([self valueOfIndivid:binCode1], [self valueOfIndivid:binCode2]);
        anIndivid = [[GAIndivid alloc] initWithBinCodeX:binCode1 binCodeY:binCode2 fitness:pt];
        
        [population addObject:anIndivid];
    }
    
    self.currentPopulation = population;
}


#pragma mark -
#pragma mark SubMethods

- (NSArray *)randBinIndivid
{
    NSMutableArray *anIndivid = [NSMutableArray array];
    
    for (int j=0; j<self.binaryCodeLength; j++) {
        [anIndivid addObject: [NSNumber numberWithInt: arc4random()%2]];
    }
    return anIndivid;
}


#pragma mark -
#pragma mark Some math Methods

// bin -> int (simply converts number in BINary to INTeger)
- (int)numberFromBinary:(NSArray *)binaryCode
{
    int result = 0;
    for (int i=binaryCode.count-1; i>=0; i--) {
        if ([(NSNumber *)[binaryCode objectAtIndex:i] integerValue] != 0) {
            result += pow(2, (binaryCode.count-1)-i);
        }
    }
    return result;
}

//individ binary code -> individ value
- (float)valueOfIndivid:(NSArray *)anIndivid
{
    int A = [self numberFromBinary:anIndivid];
    
    float v = pow(2, self.binaryCodeLength);
    
    float div = (A/v);
    
    float res = (div * (self.rightBorderX - self.leftBorderX)) + self.leftBorderX;
    
    return res;
}

@end








