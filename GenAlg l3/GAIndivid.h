//
//  GAIndivid.h
//  GeneticAlgorithm
//
//  Created by Oxygen on 16.09.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GAIndivid : NSObject

@property (nonatomic, strong) NSArray *binaryCodeX;
@property (nonatomic, strong) NSArray *binaryCodeY;

@property (nonatomic, assign) CGPoint pt; //(x,y)
@property (nonatomic, strong) NSNumber *fitness;    //f(x,y)


- (id)initWithBinCodeX:(NSArray *)binCode1 binCodeY:(NSArray *)binCode2 fitness:(NSNumber *)aFitness;

@end
