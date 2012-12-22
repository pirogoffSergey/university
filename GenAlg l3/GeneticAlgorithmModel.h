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

@property (nonatomic, assign) int leftBorderX;
@property (nonatomic, assign) int rightBorderX;
@property (nonatomic, assign) int topBorderY;
@property (nonatomic, assign) int bottomBorderY;


@property (nonatomic, assign) int binaryCodeLength;

@property (nonatomic, assign) int populationIndividsCount;
@property (nonatomic, assign) int parentsIndividsCount;
@property (nonatomic, assign) float mutationChance;



- (void)start;

- (NSArray *)nextIteration; //returns array of GAIndivids
- (float)valueOfIndivid:(NSArray *)anIndivid;

- (NSArray *)firstPopulation;
- (void)regenerateFirstPopulation;

- (NSString *)roundNumber:(float)number;
+ (NSString *)roundNumber:(float)number;

- (BOOL)isIndivid:(NSArray *)anIndivid likeAnotherIndivid:(NSArray *)standard;

@end
