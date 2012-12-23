//
//  GeneticAlgorithmModelNew.m
//  GeneticAlgorithm
//
//  Created by Oxygen on 20.12.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import "GeneticAlgorithmModelNew.h"


@interface GeneticAlgorithmModelNew ()

@property (nonatomic, strong) NSArray *currentPopulation; //array of GAIndivids
@property (nonatomic, strong) NSArray *ranks; //arrat of NSNumber

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
        
        _ranks = [NSArray array];
    }    
    return self;
}


#pragma mark -
#pragma mark Public Methods

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

- (void)regenerateFirstPopulation
{
    [self generateFirstPopulation];
    self.ranks = [self ranksByGoldenbergForPopulation:_currentPopulation];
    self.ranksOfPopulation = self.ranks;
}

- (void)calculate {
//    [self calculateRanks];
    
//    [self chooseBestFromPopulation];
    
//    [self chooseNonComparatableIndivids];
     
}


#pragma mark -
#pragma mark MainMethods

- (void)chooseNonComparatableIndivids {
    
    NSArray *tmpPopulation = _currentPopulation;
    NSArray *lastGoodPop;
    NSArray *ranks;
    int prevPopulationCount = 0;
    
    do {
        prevPopulationCount = tmpPopulation.count;
        ranks = [self calculateRanksForPopulation:tmpPopulation];
        
        
//        for(int i=0; i<ranks.count; i++) {
//            GAIndivid *ind = [tmpPopulation objectAtIndex:i];
//            NSLog(@"ind : %@", [NSValue valueWithCGPoint:ind.pt]);
//            NSLog(@"rank = %@", [ranks objectAtIndex:i]);
//        }
//        NSLog(@"-------------------------------");
        lastGoodPop = [NSArray arrayWithArray:tmpPopulation];
        tmpPopulation = [self chooseBestFromPopulation:tmpPopulation withRanks:ranks];
        
    }while (tmpPopulation.count);//(prevPopulationCount != tmpPopulation.count);
    
    
    for(int i=0; i<lastGoodPop.count; i++) {
        GAIndivid *ind = [lastGoodPop objectAtIndex:i];
        NSLog(@"ind : %@", [NSValue valueWithCGPoint:ind.pt]);
    }
    NSLog(@"choosen %d ELEMENTS", lastGoodPop.count);
}

- (NSArray *)ranksByGoldenbergForPopulation:(NSArray *)population {
    //все недоминирующие инд = 1
    //удаляем их
    //count=2
    //новым недоминирующим инд = count
    NSMutableArray *resultRanks = [NSMutableArray arrayWithArray:population];
    
    
    NSArray *tmpPopulation = population;
    NSMutableArray *newTmpPopulation = [NSMutableArray array];
    int curRank = 1;
    int tmpRank = 1;
    
    do {
        [newTmpPopulation removeAllObjects];
        for(GAIndivid *ind in tmpPopulation) {
            tmpRank = 1;
            for(GAIndivid *ind2 in tmpPopulation) {
                if(ind!=ind2) {
                    if([self isIndivid:ind dominateIndivid:ind2]) {
                        tmpRank++;
                    }
                }
            }
            
            if(tmpRank==1) {
                //this is nonDominated individ
                [resultRanks replaceObjectAtIndex:[population indexOfObject:ind] withObject:[NSNumber numberWithInt:curRank]];
            }
            else {
                [newTmpPopulation addObject:ind];
            }
        }
        curRank++;
        tmpPopulation = [NSArray arrayWithArray:newTmpPopulation];
    }while(newTmpPopulation.count != 0);
    
    //
//    NSLog(@"got ranks:");
//    for(NSNumber *n in resultRanks) {
//        NSLog(@"rank = %d", n.intValue);
//    }
//    NSLog(@"");
    return resultRanks;
}

- (NSArray *)calculateRanksForPopulation:(NSArray *)population {
    
    NSMutableArray *ranksNew = [NSMutableArray array];
    int curRank=0;
    
    for(GAIndivid *individ in population) {
        curRank=1;
        for(GAIndivid *individ2 in population) {
            if(individ!=individ2) {
                
                if([self isIndivid:individ dominateIndivid:individ2]) {
                    curRank++;
                }
            }
        }
        //NSLog(@"rank = %d",curRank);
        [ranksNew addObject: [NSNumber numberWithInt:curRank]];
    }
//    self.ranks = ranksNew;
    return ranksNew;
}

- (void)calculateAverageFitness {
    
    NSMutableArray *averageFitnesses = [NSMutableArray array];
    int curRank = 0;
    double Fi=0;
    
    for (int i=0; i<self.currentPopulation.count; i++) {
        
        curRank = ((NSNumber *)[self.ranks objectAtIndex:i]).intValue;
        if(curRank > 1) {
            
            double sum = 0;
            for(int k=0; k<curRank-1; k++) {
                sum += [self individsCountWithRank:k];
            }
            Fi = self.currentPopulation.count - sum - 0.5*([self individsCountWithRank:curRank] - 1);
        }
        else {
            Fi = self.currentPopulation.count - 0.5*([self individsCountWithRank:1] - 1);
        }
        [averageFitnesses addObject: [NSNumber numberWithDouble:Fi]];
    }
}

- (NSArray *)chooseBestFromPopulation:(NSArray *)population withRanks:(NSArray *)ranks {
    assert(population.count == ranks.count);
    NSMutableArray *newPopulation = [NSMutableArray array];
    
    for (int i=0; i<ranks.count; i++) {
        if(((NSNumber *)[ranks objectAtIndex:i]).intValue != 1) {
            [newPopulation addObject: [population objectAtIndex:i]];
        }
    }
//    NSLog(@"there is %d ELEMENTS for next pop", newPopulation.count);
    return newPopulation;
}


#pragma mark -
#pragma mark SubMethods

- (BOOL)isIndivid:(GAIndivid *)ind1 dominateIndivid:(GAIndivid *)ind2 {
 
    if(ind1.pt.x >= ind2.pt.x) {
        if(ind1.pt.y >= ind2.pt.y) {
            
            if(ind1.pt.x == ind2.pt.x && ind1.pt.y == ind2.pt.y) {
                return NO;
            }
            else {
                return YES;
            }
        }
    }
    return NO;
}

- (int)individsCountWithRank:(int)rank {
    
    int count=0;
    for(NSNumber *r in self.ranks) {
        if(r.intValue == rank) {
            count++;
        }
    }
    return count;
}

- (int)maxIndividsRank {
    int max = ((NSNumber *)[self.ranks objectAtIndex:0]).intValue;
    
    for(NSNumber *n in self.ranks) {
        if(n.intValue > max) {
            max = n.intValue;
        }
    }
    return max;
}


#pragma mark -
#pragma mark Rands

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
#pragma mark Convertations

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
//    NSLog(@"number = %d", number);
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








