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
    return self;
}


#pragma mark -
#pragma mark MainMethods

- (void)generateFirstPopulation {
    NSMutableArray *population = [NSMutableArray array];
    
    GAIndivid *anIndivid;
    for(int i=0; i<30; i++) {
        
        do {
            anIndivid = [self randIndividFromSet];
        }while(![self.ineqSystem doesDotBelongToSystem: anIndivid.pt]);
        [population addObject:anIndivid];
    }
    self.currentPopulation = population;
    self.firstPopulation = self.currentPopulation;
}


#pragma mark -
#pragma mark Convertations

- (NSArray *)randBinIndivid
{
    NSMutableArray *anIndivid = [NSMutableArray array];
    
    for (int j=0; j<self.binaryCodeLength; j++) {
        [anIndivid addObject: [NSNumber numberWithInt: arc4random()%2]];
    }
    return anIndivid;
}

- (GAIndivid *)randIndividFromSet
{
    if(!self.packOfDotsFromSet || !self.packOfDotsFromSet.count) {
        assert(YES); //pack of dots empty!
        return nil;
    }
    
    int r1 = arc4random()%self.packOfDotsFromSet.count;
    NSArray *lineDots = [self.packOfDotsFromSet objectAtIndex:r1];
    CGPoint somePt = ((NSValue *)[lineDots objectAtIndex:0]).CGPointValue;
    double y = somePt.y;
    
    double fromX = somePt.x;
    somePt = ((NSValue *)[lineDots objectAtIndex:lineDots.count-1]).CGPointValue;
    double toX = somePt.x;
    
    //rand from diapason (fromX - toX)
    double x = fromX + arc4random()%(int)toX;
    
    //make binaryRepresentation
    NSArray *binX = [self individBinFromValue:x];
    NSArray *binY = [self individBinFromValue:y];
    
    return [[GAIndivid alloc] initWithBinCodeX:binX binCodeY:binY fitness:CGPointMake(x, y)];
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
    return ((A/pow(2, self.binaryCodeLength)) * (self.rightBorderX - self.leftBorderX)) + self.leftBorderX;
}

// int -> bin (converts number in INTeger to BINary)
- (NSArray *)binaryFromNumber:(int)number {
    
    int max = pow(2, self.binaryCodeLength) -1;
    NSLog(@"number = %d", number);
    assert(number<max); //max allowed number exceeded
    
    NSMutableArray *result = [NSMutableArray array];
    int diff=0;
    int numbTemp = number;
    
    for (int i=self.binaryCodeLength-1; i>=0; i--) {
        
        diff = numbTemp-pow(2, i);
        if(diff>=0) {
            numbTemp -= pow(2, i);
            [result addObject: [NSNumber numberWithInt:1]];
        }
        else {
            [result addObject: [NSNumber numberWithInt:0]];
        }
    }
    return result;
}

//individ value  ->  individ binary code 
- (NSArray *)individBinFromValue:(CGFloat)value
{
    int B = ((value - self.leftBorderX)/(self.rightBorderX - self.leftBorderX)) * pow(2, self.binaryCodeLength);
    
    NSArray *arr = [self binaryFromNumber:B];
    return arr;
}


@end








