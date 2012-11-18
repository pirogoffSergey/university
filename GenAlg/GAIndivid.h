//
//  GAIndivid.h
//  GeneticAlgorithm
//
//  Created by Oxygen on 16.09.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GAIndivid : NSObject

@property (nonatomic, strong) NSArray *binaryCode;
@property (nonatomic, strong) NSNumber *value;      //x
@property (nonatomic, strong) NSNumber *fitness;    //f(x)

- (id)initWithBinCode:(NSArray *)binCode value:(NSNumber *)aNumber fitness:(NSNumber *)aFitness;

@end
