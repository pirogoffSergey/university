//
//  GeneticAlgorithmModel.h
//  GeneticAlgorithm
//
//  Created by Oxygen on 14.09.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GAIndivid.h"
#import "PlotView.h"

#import "CustomTableViewController.h"

@interface GeneticAlgorithmModel : NSObject <PlotViewProtocol>

//function is: ax^2 + bx + c


@property (nonatomic, strong) CustomTableViewController *tableView;

@property (nonatomic, assign) int a0Param;
@property (nonatomic, assign) int a1Param;
@property (nonatomic, assign) int a2Param;
@property (nonatomic, assign) int a3Param;
@property (nonatomic, assign) int a4Param;

@property (nonatomic, assign) int leftBorder;
@property (nonatomic, assign) int rightBorder;

@property (nonatomic, assign) int binaryCodeLength;
@property (nonatomic, assign) int maxIterationsCount;

@property (nonatomic, assign) int populationIndividsCount;
@property (nonatomic, assign) int parentsIndividsCount;
@property (nonatomic, assign) float mutationChance;

@property (nonatomic, assign) BOOL isSearchMax;


- (void)start;

- (NSArray *)nextIteration; //returns array of GAIndivids
- (float)valueOfIndivid:(NSArray *)anIndivid;

- (NSArray *)firstPopulation;
- (void)regenerateFirstPopulation;

- (NSString *)roundNumber:(float)number;
+ (NSString *)roundNumber:(float)number;

- (BOOL)isIndivid:(NSArray *)anIndivid likeAnotherIndivid:(NSArray *)standard;

@end
