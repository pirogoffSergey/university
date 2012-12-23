//
//  IneqTableController.h
//  GeneticAlgorithm
//
//  Created by Oxygen on 23.12.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAInequalitiesSystem.h"


@interface IneqTableController : UITableViewController

@property (nonatomic, strong) GAInequalitiesSystem *system;

- (id)initWithFrame:(CGRect)aFrame;
- (void)reloadTableView;

@end
