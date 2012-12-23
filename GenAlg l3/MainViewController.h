//
//  MainViewController.h
//  GeneticAlgorithm
//
//  Created by Oxygen on 13.09.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *a0ParamLabel; //a
@property (strong, nonatomic) IBOutlet UITextField *a1ParamLabel; //b
@property (strong, nonatomic) IBOutlet UITextField *a2ParamLabel; //c


@property (strong, nonatomic) IBOutlet UITableView *resultsTableView;
@property (weak, nonatomic) IBOutlet UITableView *inequalitiesTableView;


@property (strong, nonatomic) IBOutlet UIImageView *placeForPlot;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activIndicator;

- (IBAction)regenerateAction:(id)sender;
- (IBAction)startAction:(id)sender;
- (IBAction)addIneq:(id)sender;

@end
