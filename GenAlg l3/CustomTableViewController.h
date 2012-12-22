//
//  CustomTableViewController.h
//  GeneticAlgorithm
//
//  Created by Oxygen on 13.09.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAIndivid.h"

@interface CustomTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *sections; // array of arrays of GAIndivids

- (id)initWithFrame:(CGRect)aFrame;
- (void)reloadTableView;

- (void)selectCellsWithMaxElements;
- (void)selectCellAtIndexPathAtIndexPath:(NSIndexPath *)indexPath;
- (void)deselectCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)deselectAllCells;

@end
