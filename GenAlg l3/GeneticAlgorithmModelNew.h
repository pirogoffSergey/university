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



@interface GeneticAlgorithmModelNew : NSObject

@property (nonatomic, strong) CustomTableViewController *tableView;

@property (nonatomic, assign) int leftBorderX;
@property (nonatomic, assign) int rightBorderX;
@property (nonatomic, assign) int topBorderY;
@property (nonatomic, assign) int bottomBorderY;

@property (nonatomic, assign) int binaryCodeLength;
@property (nonatomic, assign) float mutationChance;

@end
