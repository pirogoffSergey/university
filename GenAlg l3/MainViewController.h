//
//  MainViewController.h
//  GeneticAlgorithm
//
//  Created by Oxygen on 13.09.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *a0ParamLabel;
@property (strong, nonatomic) IBOutlet UITextField *a1ParamLabel;
@property (strong, nonatomic) IBOutlet UITextField *a2ParamLabel;
@property (strong, nonatomic) IBOutlet UITextField *a3ParamLabel;
@property (strong, nonatomic) IBOutlet UITextField *a4ParamLabel;


@property (strong, nonatomic) IBOutlet UITableView *resultsTableView;

@property (strong, nonatomic) IBOutlet UITextField *leftBorderLabel;
@property (strong, nonatomic) IBOutlet UITextField *rightBorderLabel;

@property (strong, nonatomic) IBOutlet UIImageView *placeForPlot;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activIndicator;

- (IBAction)regenerateAction:(id)sender;
- (IBAction)calculateAction:(id)sender;
- (IBAction)startAction:(id)sender;


@end
