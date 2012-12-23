//
//  GeneticAlgorithmModelNew.h
//  GeneticAlgorithm
//
//  Created by Oxygen on 20.12.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GAIndivid.h"
#import "PlotView.h"

#import "CustomTableViewController.h"
#import "GAInequalitiesSystem.h"


@interface GeneticAlgorithmModelNew : NSObject

@property (nonatomic, strong) CustomTableViewController *tableView;
@property (nonatomic, strong) GAInequalitiesSystem *ineqSystem;

@property (nonatomic, assign) int leftBorderX;
@property (nonatomic, assign) int rightBorderX;
@property (nonatomic, assign) int binaryCodeLength;
@property (nonatomic, assign) float mutationChance;

@property (nonatomic, strong) NSArray *firstPopulation; // array of GAIndivids
//@property (nonatomic, strong) NSArray *ranksOfPopulation; // array of NSNumbers

@property (nonatomic, strong) NSArray *packOfDotsFromSet; //Array of Arrays(with CGPoints packed to NSValue)

- (void)generateFirstPopulation;
- (void)regenerateFirstPopulation;

- (void)calculate;

@end
