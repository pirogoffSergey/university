//
//  MainViewController.h
//  LinearOptimization
//
//  Created by Oxygen on 19.10.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *plotPlace;
@property (strong, nonatomic) IBOutlet UITextField *aField;
@property (strong, nonatomic) IBOutlet UITextField *bField;
@property (strong, nonatomic) IBOutlet UITextField *cField;
@property (strong, nonatomic) IBOutlet UITextField *dField;


@property (weak, nonatomic) IBOutlet UITextView *resultTV;

@property (weak, nonatomic) IBOutlet UITextField *radiusTF;


- (IBAction)start:(id)sender;

@end
