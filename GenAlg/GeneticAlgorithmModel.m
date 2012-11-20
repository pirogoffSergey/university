//
//  GeneticAlgorithmModel.m
//  GeneticAlgorithm
//
//  Created by Oxygen on 14.09.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import "GeneticAlgorithmModel.h"


@interface GeneticAlgorithmModel()
{
    NSMutableArray *_firstPopulation;
    NSMutableArray *_publicFirstPopulation; //consists of GAIndivid objects
    
    NSArray *_currentPopulation;
    NSArray *_previousPopulation;
    int _currentIteration;
    
    NSMutableArray *_populationsOfIndivids;
}
@end


@implementation GeneticAlgorithmModel

- (id)init
{
    self = [super init];
    if(self) {
        _a0Param = 2;
        _a1Param = 0;
        _a2Param = 1;
        _a3Param = 2;
        _a4Param = 1;
        
        self.isSearchMax = YES;
        
        _leftBorder = -1;
        _rightBorder = 0;
        
        _binaryCodeLength = 12;
        _maxIterationsCount = 20;
        
        _populationIndividsCount = 10;
        _parentsIndividsCount = 10;
        _mutationChance = 0.3;
        
        _currentIteration = 0;
        
        _populationsOfIndivids = [NSMutableArray array];
        _publicFirstPopulation = [NSMutableArray array];
        [self generateFirstPopulation];
    }
    return self;
}


#pragma mark -
#pragma mark Public Methods

- (void)start {
    
    BOOL isFound = NO;
    NSArray *result;
    
    int iterations = 5+arc4random()%5;
    
    do {
        result = [self nextIteration];
        [self.tableView.sections addObject:result];
        [self.tableView reloadTableView];
        isFound = [self isBestElementsFoundInCurrentPopulation:_currentPopulation
                                                 previousPopulation:_previousPopulation];
    }while ((isFound==NO) || (_currentIteration<iterations));
    
    NSLog(@"finished!");
    NSLog(@"spent: %d iterations", _currentIteration);
}

- (NSArray *)nextIteration
{
    if(!_currentIteration) {
        _currentPopulation = _firstPopulation;
    }
    
    NSArray *probabilitiesOfPopulation = [self calculatePosibilitiesForPopulation:_currentPopulation];
    NSArray *parents = [self determineNewParentsForPopulation:_currentPopulation probabilities:probabilitiesOfPopulation];
    parents = [self crossingOverAPopulation:parents];
    parents = [self mutateAPopulation:parents];
    
    _previousPopulation = _currentPopulation;

    NSArray *bestFromBoth = [self chooseBestFromParent:parents childred:_currentPopulation];
    _currentPopulation = [self tmpParents:parents children:_currentPopulation best:bestFromBoth];
    _currentIteration++;
    
    return [self makePublicPopulation:parents];
}

- (void)regenerateFirstPopulation
{
    _firstPopulation = nil;
    _currentPopulation = nil;
    _currentIteration = 0;
    _publicFirstPopulation = nil;
    _publicFirstPopulation = [NSMutableArray new];

    [self generateFirstPopulation];
}

- (NSArray *)firstPopulation
{
    return _publicFirstPopulation;
}


#pragma mark -
#pragma mark Finding all Min/Max -es Methods (lr2)

- (NSArray *)tmpParents:(NSArray *)parents children:(NSArray *)children best:(NSArray *)bestFromBoth{
    
    // merge two arrays in one
    NSMutableArray *together = [NSMutableArray arrayWithArray:parents];
    for (NSArray *obj in children) {
        [together addObject:obj];
    }
    
    NSMutableArray *mostLooksLike = [NSMutableArray array];
    NSMutableArray *tempBestLooksLike = [NSMutableArray array];
    
    /// search
    NSArray *bestIndivid = [bestFromBoth objectAtIndex:0];
    for (NSArray *individ in together) {
        
        if([self isArray:bestIndivid equalToArray:individ]) {
            continue; //don't need to compare with itself
        }
        // check if it looks like bestIndivid
        if([self isIndivid:bestIndivid likeAnotherIndivid:individ]) {
            [tempBestLooksLike addObject:individ];
        }
    }
    
    //now we have tempBestLooksLike array of elements for bestIndivid
    if(tempBestLooksLike.count == 0) {
        
        NSLog(@"there is no look like elements");
    }
    else {
        int count=0;
        if(tempBestLooksLike.count > 5) {
            count = 5;
        }
        else {
            count = tempBestLooksLike.count;
        }
        
        for (int i=0; i<count; i++) {
            [mostLooksLike addObject:[tempBestLooksLike objectAtIndex:i]];
        }
    }

    for(NSArray *elem in bestFromBoth) {
        if(mostLooksLike.count == 10) {
            break;
        }
        [mostLooksLike addObject:elem];
    }
    
    return mostLooksLike;
}


- (NSArray *)findBestFromParents:(NSArray *)parents children:(NSArray *)children best:(NSArray *)bestFromBoth{
    
    // merge two arrays in one
    NSMutableArray *together = [NSMutableArray arrayWithArray:parents];
    for (NSArray *obj in children) {
        [together addObject:obj];
    }
    
    NSMutableArray *mostLooksLike = [NSMutableArray array];
    NSMutableArray *tempBestLooksLike = [NSMutableArray array];
    
    // search
    for (NSArray *bestIndivid in bestFromBoth) {
        
        for (NSArray *individ in together) {
            
            if([self isArray:bestIndivid equalToArray:individ]) {
                continue; //don't need to compare with itself
            }
            
            // check if it looks like bestIndivid
            if([self isIndivid:bestIndivid likeAnotherIndivid:individ]) {
                [tempBestLooksLike addObject:individ];
            }
        }
        //now we have tempBestLooksLike array of elements for bestIndivid
        // let't take the best looksLike element for it
        NSArray *theMostLooksLikeElem;
        if(tempBestLooksLike.count == 0) {
        
            NSLog(@"tich!");
            theMostLooksLikeElem = bestIndivid;
        }
        else {
            NSLog(@"%d", tempBestLooksLike.count);
            theMostLooksLikeElem = [tempBestLooksLike objectAtIndex: [self findIndividWithMaxYValueInPopulation:tempBestLooksLike]];
        }
        
        [mostLooksLike addObject:theMostLooksLikeElem];
        [tempBestLooksLike removeAllObjects];
    }
    
    return mostLooksLike;
}

- (BOOL)isIndivid:(NSArray *)anIndivid likeAnotherIndivid:(NSArray *)standard
{
    double deltaX = 0.6;
    double deltaY = 0.01;
    
    double x1 = [self valueOfIndivid:anIndivid];
    double x2 = [self valueOfIndivid:standard];
    
    double y1 = [self f:x1];
    double y2 = [self f:x2];
    
    if(fabs(x1-x2) >= deltaX &&
       fabs(y1-y2) <= deltaY) {
        
//        NSLog(@"ind1: %@", [self arrayToString:anIndivid]);
//        NSLog(@"std: %@", [self arrayToString:standard]);
        return YES;
    }
    return NO;
}

- (BOOL)isArray:(NSArray *)arr equalToArray:(NSArray *)second {

    if(arr.count != second.count) {
        return NO;
    }
    
    NSNumber *n1;
    NSNumber *n2;
    
    for(int i=0; i<arr.count; i++) {
        n1 = [arr objectAtIndex:i];
        n2 = [second objectAtIndex:i];
        
        if(![n1 isEqualToNumber:n2]) {
            return NO;
        }
    }    
    return YES;
}

- (int)findIndividWithMaxYValueInPopulation:(NSArray *)population
{
    //population - array of arrays
    int maxInd = 0;
    NSArray *curMaxElem = [population objectAtIndex:0];
    NSArray *prevMaxElem = [population objectAtIndex:0];
    for (int i=0; i<population.count; i++) {
        
        curMaxElem = [self findMaxFromBinariesNumbersOne:curMaxElem second: [population objectAtIndex:i]];
        if (curMaxElem != prevMaxElem) {
            maxInd = i;
            prevMaxElem = curMaxElem;
        }
    }
    return maxInd;
}

- (BOOL)isBestElementsFoundInCurrentPopulation:(NSArray *)curPopulation previousPopulation:(NSArray *)prevPopulation {
    
    assert(curPopulation.count == prevPopulation.count);
    
    //found best from cur
    int bestCurIndx = [self findIndividWithMaxYValueInPopulation:curPopulation];
    NSArray *bestCurElem = [curPopulation objectAtIndex:bestCurIndx];
    
    int bestPrevIndx = [self findIndividWithMaxYValueInPopulation:prevPopulation];
    NSArray *bestPrevElem = [prevPopulation objectAtIndex:bestPrevIndx];
    
    double curX = [self valueOfIndivid:bestCurElem];
    double prevX = [self valueOfIndivid:bestPrevElem];
    
    double curY = [self f:curX];
    double prevY =[self f:prevX];
    
    if(fabs(curY - prevY) <= 0.001) {
        return YES;
    }
    else {
        return NO;
    }
}


#pragma mark -
#pragma mark MainMethods

- (void)generateFirstPopulation
{
    NSMutableArray *anIndivid = nil;
    _firstPopulation = [NSMutableArray array];
    
    for (int i=0; i<self.populationIndividsCount; i++) {

        // generate a new individ
        anIndivid = [NSMutableArray array];
        for (int j=0; j<self.binaryCodeLength; j++) {

            //generate elements of binary code of individ
            [anIndivid addObject: [NSNumber numberWithInt: arc4random()%2]];
        }
        [_firstPopulation addObject:anIndivid];
    
        float valueOfIndivid = [self valueOfIndivid:anIndivid];
        [_publicFirstPopulation addObject:[[GAIndivid alloc] initWithBinCode:anIndivid value:[NSNumber numberWithFloat:valueOfIndivid] fitness:[NSNumber numberWithFloat:[self f:valueOfIndivid]]]];
        
        anIndivid = nil;
    }
}

//makes representation of usual array of binCodes to array of objects GAIndivid
- (NSArray *)makePublicPopulation:(NSArray *)population
{
    NSMutableArray *publicPopulation = [NSMutableArray array];
    
    NSArray *anIndivid = nil;
    float valueOfIndivid = 0;
    for (int i=0; i<population.count; i++) {
        
        anIndivid = [population objectAtIndex:i];
        valueOfIndivid = [self valueOfIndivid:anIndivid];
        
        [publicPopulation addObject:[[GAIndivid alloc] initWithBinCode:anIndivid value:[NSNumber numberWithFloat:valueOfIndivid] fitness:[NSNumber numberWithFloat:[self f:valueOfIndivid]]]];
    }
    return publicPopulation;
}

- (NSArray *)chooseBestFromParent:(NSArray *)parentPopulation childred:(NSArray *)childrenPopulation
{
    // merge two arrays in one
    NSMutableArray *together = [NSMutableArray arrayWithArray:parentPopulation];
    for (NSArray *obj in childrenPopulation) {
        [together addObject:obj];
    }
    
    
    // finding max elements from two arrays
    NSMutableArray *result = [NSMutableArray array];
    NSArray *curMaxElem = nil;
    NSArray *prevMaxElem = nil;
    int maxInd = 0;
    
    do {
        maxInd = 0;
        curMaxElem = [together objectAtIndex:0];
        prevMaxElem = [together objectAtIndex:0];
        for (int i=0; i<together.count; i++) {
            
            curMaxElem = [self findMaxFromBinariesNumbersOne:curMaxElem second: [together objectAtIndex:i]];
            if (curMaxElem != prevMaxElem) {
                maxInd = i;
                prevMaxElem = curMaxElem;
            }
        }
        [result addObject:curMaxElem];
        [together removeObjectAtIndex:maxInd];
    } while(result.count < 10);
    
    return result;
}

- (NSArray *)findMaxFromBinariesNumbersOne:(NSArray *)one second:(NSArray *)second
{
    assert([one count] == [second count]);
    
//    NSLog(@"one: %@", [self arrayToString:one]);
//    NSLog(@"scnd: %@", [self arrayToString:second]);
    
    float oneInt = [self valueOfIndivid:one];
    float secondInt = [self valueOfIndivid:second];
    float yOne = [self f:oneInt];
    float yScnd = [self f:secondInt];
    
    if(yOne >= yScnd) {
        return one;
    }
    else {
        return second;
    }
}



- (NSArray *)calculatePosibilitiesForPopulation:(NSArray *)aPopulation
{
    //calculate f(Xi)
    NSMutableArray *adaptions = [NSMutableArray array];
    
    //for array of individs
    NSMutableArray *populationOfIndivids = [NSMutableArray new];
    GAIndivid *anIndivid = nil;
    NSNumber *anAdaptation = nil;
    
    float sum = 0;
    
    for (int i=0; i<aPopulation.count; i++) {
        
        float x = [self valueOfIndivid: [aPopulation objectAtIndex:i]];
        float fx = [self f:x];
        sum += fx;
        
        anAdaptation = [NSNumber numberWithFloat:fx];
        anIndivid = [[GAIndivid alloc] initWithBinCode:[aPopulation objectAtIndex:i] value:[NSNumber numberWithFloat:x] fitness:anAdaptation];
        [populationOfIndivids addObject:anIndivid];
        anIndivid = nil;
        
        [adaptions addObject: anAdaptation];
    }
    [_populationsOfIndivids addObject:populationOfIndivids];
    
    //calculate probabilities of each individ
    NSMutableArray *individsProbabilities = [NSMutableArray array];
    
    for (int i=0; i<adaptions.count; i++) {
        [individsProbabilities addObject: [NSNumber numberWithFloat: ((NSNumber *)[adaptions objectAtIndex:i]).floatValue/sum]];
    }
    NSLog(@"individs probabilities: %@", individsProbabilities);
    return individsProbabilities;
}

- (NSArray *)determineNewParentsForPopulation:(NSArray *)aPopulation probabilities:(NSArray *)elemsProbabiliries
{
    NSMutableArray *newParents = [NSMutableArray array];
    for (int i=0; i<self.populationIndividsCount; i++) {
        [newParents addObject: [aPopulation objectAtIndex: [self rouletteMethod:elemsProbabiliries]]];
    }
    return newParents;
}

- (NSArray *)crossingOverAPopulation:(NSArray *)aPopulation
{
    NSMutableArray *crossedPopulation = [NSMutableArray arrayWithArray:aPopulation];
    
    assert(aPopulation.count%2 == 0); //must be even count of elements!
    
    NSArray *twoElementsCrossed = nil;
    for (int i=0; i<crossedPopulation.count-1; i++) {
        twoElementsCrossed = [self makeCrossingOver:[crossedPopulation objectAtIndex:i] secondElem:[crossedPopulation objectAtIndex:i+1]];
        
        [crossedPopulation removeObjectAtIndex:i];
        [crossedPopulation insertObject:[twoElementsCrossed objectAtIndex:0] atIndex:i];
        
        [crossedPopulation removeObjectAtIndex:i+1];
        [crossedPopulation insertObject:[twoElementsCrossed objectAtIndex:1] atIndex:i+1];
    }
    return crossedPopulation;
}

- (NSArray *)mutateAPopulation:(NSArray *)aPopulation
{
    NSMutableArray *mutatedPopulation = [NSMutableArray arrayWithArray:aPopulation];
    
    NSArray *mutatedIndivid = nil;
    for (int i=0; i<aPopulation.count; i++) {
        
        mutatedIndivid = [self mutateAnIndivid: [mutatedPopulation objectAtIndex:i] withChance:self.mutationChance];
        [mutatedPopulation removeObjectAtIndex:i];
        [mutatedPopulation insertObject:mutatedIndivid atIndex:i];
    }
    
    return mutatedPopulation;
}



#pragma mark -
#pragma mark Some math Methods

- (float)f:(float)x
{
    if(self.isSearchMax) {
        return self.a0Param + self.a1Param*x + self.a2Param*x*x + self.a3Param*x*x*x + self.a4Param*x*x*x*x; //for srch MAX
    }
    else {
        return -((-self.a0Param) + self.a1Param*x + self.a2Param*x*x + self.a3Param*x*x*x + self.a4Param*x*x*x*x); //for srch MIN
    } 
}

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
    
    return ((A/pow(2, self.binaryCodeLength)) * (self.rightBorder - self.leftBorder)) + self.leftBorder;
}

- (int)rouletteMethod:(NSArray *)elemntsProbabilities
{
    float randNumb = (arc4random()%10000)/10000.0;
    float curSum = 0;
    
    for (int i=0; i<elemntsProbabilities.count-1; i++) {
        
        curSum += ((NSNumber *)[elemntsProbabilities objectAtIndex:i]).floatValue;
        if(curSum <= randNumb &&
           randNumb < (curSum + ((NSNumber *)[elemntsProbabilities objectAtIndex:i+1]).floatValue)) {
           
            return i;
        }
        
        //exception //what if 1st elem is 0,7 and randNumb = 0.01
        if(i == 0 && ((NSNumber *)[elemntsProbabilities objectAtIndex:i]).floatValue >= randNumb) {
            return i;
        }
        
    }
    
    return -1;
}

- (NSString *)roundNumber:(float)number
{
    return [NSString stringWithFormat:@"%.4f", number];
}



#pragma mark -
#pragma mark SubMethods

-(NSArray *)makeCrossingOver:(NSArray *)firstElem secondElem:(NSArray *)aSecondElem
{
    assert(firstElem.count == aSecondElem.count);
    
    int crossingOverPoint = arc4random()%(self.binaryCodeLength/2 - 1);
    
    NSMutableArray *crossedFirst = [NSMutableArray arrayWithArray:firstElem];
    NSMutableArray *crossedSecond = [NSMutableArray arrayWithArray:aSecondElem];

    NSNumber *tmp = nil;
    
    for (int i=firstElem.count-crossingOverPoint; i<firstElem.count; i++) {
        tmp = [crossedFirst objectAtIndex:i];
        
        [crossedFirst removeObjectAtIndex:i];
        [crossedFirst insertObject:[crossedSecond objectAtIndex:i] atIndex:i];
        
        [crossedSecond removeObjectAtIndex:i];
        [crossedSecond insertObject:tmp atIndex:i];
    }
    return [NSArray arrayWithObjects:crossedFirst, crossedSecond, nil];
}

- (NSArray *)mutateAnIndivid:(NSArray *)individ withChance:(float)aChance
{
    NSMutableArray *mutatedIndivid = [NSMutableArray arrayWithArray:individ];
    float randNum = (arc4random()%1000)/1000.0;
    
    if(randNum <= aChance) {
        int mutationIndex = arc4random()%(individ.count-1);
        NSNumber *elem = [individ objectAtIndex: mutationIndex];
        if(elem.intValue == 0) {
            elem = [NSNumber numberWithInt:1];
        }
        else {
            elem = [NSNumber numberWithInt:0];
        }
        [mutatedIndivid removeObjectAtIndex:mutationIndex];
        [mutatedIndivid insertObject:elem atIndex:mutationIndex];
    }
    return mutatedIndivid;
}

- (NSString *)arrayToString:(NSArray *)anArray
{
    NSMutableString *result = [NSMutableString string];
    for(int i=0; i<anArray.count; i++) {
        [result appendString: ((NSNumber *)[anArray objectAtIndex:i]).stringValue];
    }
    return result;
}


#pragma mark Class Methods

+ (NSString *)roundNumber:(float)number
{
    return [NSString stringWithFormat:@"%.4f", number];
}

@end





