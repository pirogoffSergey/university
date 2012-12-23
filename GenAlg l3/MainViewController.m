//
//  MainViewController.m
//  GeneticAlgorithm
//
//  Created by Oxygen on 13.09.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import "MainViewController.h"
#import "CustomTableViewController.h"
#import "GeneticAlgorithmModel.h"
#import "GeneticAlgorithmModelNew.h"

#import "PlotView.h"
#import "GAInequalitiesSystem.h"
#import "GAInequality.h"


#define A0_PARAM_FIELD 1
#define A1_PARAM_FIELD 2
#define A2_PARAM_FIELD 3
#define A3_PARAM_FIELD 4
#define A4_PARAM_FIELD 5


#define LEFT_BORDER_FIELD 6
#define RIGHT_BORDER_FIELD 7


@interface MainViewController () <UITextFieldDelegate>
{
    CustomTableViewController *_tableViewControl;
    
    GeneticAlgorithmModelNew *_genAlrorithmNew;
    GAInequalitiesSystem *_syst;
    
    PlotView *_plot;
    BOOL _isRedrawingNow;
}
@end


@implementation MainViewController

@synthesize resultsTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableViewControl = [[CustomTableViewController alloc] initWithFrame:resultsTableView.frame];
    [self.view addSubview:_tableViewControl.tableView];
    
    self.a0ParamLabel.delegate = self;
    self.a0ParamLabel.tag = A0_PARAM_FIELD;
    self.a1ParamLabel.delegate = self;
    self.a1ParamLabel.tag = A1_PARAM_FIELD;
    self.a2ParamLabel.delegate = self;
    self.a2ParamLabel.tag = A2_PARAM_FIELD;
    self.a3ParamLabel.delegate = self;
    self.a3ParamLabel.tag = A3_PARAM_FIELD;
    self.a4ParamLabel.delegate = self;
    self.a4ParamLabel.tag = A4_PARAM_FIELD;
    
    self.leftBorderLabel.delegate = self;
    self.leftBorderLabel.tag = LEFT_BORDER_FIELD;
    self.rightBorderLabel.delegate = self;
    self.rightBorderLabel.tag = RIGHT_BORDER_FIELD;
    
    
    
    // PLOT
    _plot = [[PlotView alloc] initWithFrame:self.placeForPlot.frame];
    _plot.leftBorder = 0;
    _plot.rightBorder = 20;
    
    _syst = [GAInequalitiesSystem new];
    GAInequality *en1 = [[GAInequality alloc] initWithA:-1 B:3 C:6];
    GAInequality *en2 = [[GAInequality alloc] initWithA:-3 B:2 C:-3];
    GAInequality *en3 = [[GAInequality alloc] initWithA:6 B:2 C:42];
    [_syst addInequaly:en1];
    [_syst addInequaly:en2];
    [_syst addInequaly:en3];

    _plot.ineqSystem = _syst;
    
    [self.placeForPlot removeFromSuperview];
    [self.view addSubview:_plot];
    
    [self.activIndicator removeFromSuperview];
    
   
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector (handleDoubleTap:)];
    [doubleTap setDelaysTouchesBegan: YES];
    [doubleTap setNumberOfTapsRequired: 2];
    [_plot addGestureRecognizer: doubleTap];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _genAlrorithmNew = [GeneticAlgorithmModelNew new];
    _genAlrorithmNew.leftBorderX = 0;
    _genAlrorithmNew.rightBorderX = 20;
    _genAlrorithmNew.ineqSystem = _syst;
    _genAlrorithmNew.packOfDotsFromSet = [_plot takePackOfDotsFromSet];
    [_genAlrorithmNew generateFirstPopulation];
    
    [_tableViewControl.sections addObject:_genAlrorithmNew.firstPopulation];
    [_tableViewControl reloadTableView];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


#pragma mark -
#pragma mark TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case A0_PARAM_FIELD:
            //check isValidData
            if(![self isContainsNumber:textField.text]) {
//                textField.text = [NSString stringWithFormat:@"%d",_genAlrorithm.a0Param];
                return;
            }
            else {
//                _genAlrorithm.a0Param = [textField.text intValue];
            }
            break;
        
        case A1_PARAM_FIELD:
            //check isValidData
            if(![self isContainsNumber:textField.text]) {
//                textField.text = [NSString stringWithFormat:@"%d",_genAlrorithm.a1Param];
                return;
            }
            else {
//                _genAlrorithm.a1Param = [textField.text intValue];
            }
            break;
            
        case A2_PARAM_FIELD:
            //check isValidData
            if(![self isContainsNumber:textField.text]) {
//                textField.text = [NSString stringWithFormat:@"%d",_genAlrorithm.a2Param];
                return;
            }
            else {
//                _genAlrorithm.a2Param = [textField.text intValue];
            }
            break;
        
        case A3_PARAM_FIELD:
            //check isValidData
            if(![self isContainsNumber:textField.text]) {
 //               textField.text = [NSString stringWithFormat:@"%d",_genAlrorithm.a3Param];
                return;
            }
            else {
 //               _genAlrorithm.a3Param = [textField.text intValue];
            }
            break;
            
        case A4_PARAM_FIELD:
            //check isValidData
            if(![self isContainsNumber:textField.text]) {
 //               textField.text = [NSString stringWithFormat:@"%d",_genAlrorithm.a4Param];
                return;
            }
            else {
  //              _genAlrorithm.a4Param = [textField.text intValue];
            }
            break;
            
        case LEFT_BORDER_FIELD:
            //check isValidData
            if(![self isContainsNumber:textField.text]) {
  //              textField.text = [NSString stringWithFormat:@"%d",_genAlrorithm.leftBorder];
                return;
            }
            else {
  //              _genAlrorithm.leftBorder = [textField.text intValue];
            }
            break;
            
        case RIGHT_BORDER_FIELD:
            //check isValidData
            if(![self isContainsNumber:textField.text]) {
//                textField.text = [NSString stringWithFormat:@"%d",_genAlrorithm.rightBorder];
                return;
            }
            else {
//                _genAlrorithm.rightBorder = [textField.text intValue];
            }
            break;
            
        default:
            [NSException raise:@"TextField exception" format:@"Some exception with identification of textField"];
            break;
    }
    
    [self regenerateAction:nil];
}


#pragma mark -
#pragma mark Actions

- (IBAction)regenerateAction:(id)sender {

    _tableViewControl.sections = nil;
    _tableViewControl.sections = [NSMutableArray new];
    [_tableViewControl reloadTableView];
    [_genAlrorithmNew regenerateFirstPopulation];

    [_tableViewControl.sections addObject:_genAlrorithmNew.firstPopulation];
    [_tableViewControl reloadTableView];
    
    [_plot clearDotsLayer];
}

- (IBAction)calculateAction:(id)sender {
    
//    NSArray *result = [_genAlrorithm nextIteration];
//    [_tableViewControl.sections addObject:result];
//    [_tableViewControl reloadTableView];
}

- (IBAction)startAction:(id)sender {
    
    [_tableViewControl deselectAllCells];
    
    [_genAlrorithmNew calculate];
    
    [self drawDotsPopulation];
    
//    _genAlrorithm.tableView = _tableViewControl;
//    [_genAlrorithm start];
    
//    [_tableViewControl selectCellsWithMaxElements];
}

- (void)handleDoubleTap:(UITapGestureRecognizer*)sender
{
    if(!_isRedrawingNow) {
        [self redrawPlot];
    }
}

- (void)redrawPlot {
    
    _isRedrawingNow = YES;
    [self.view addSubview:self.activIndicator];
    [self.activIndicator startAnimating];
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [_plot redraw];
        NSLog(@"called1");
    });
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.activIndicator stopAnimating];
        [self.activIndicator removeFromSuperview];
        _isRedrawingNow = NO;
        NSLog(@"called2");
    });
}

- (NSString *)arrayToString:(NSArray *)anArray
{
    NSMutableString *result = [NSMutableString string];
    for(int i=0; i<anArray.count; i++) {
        [result appendString: ((NSNumber *)[anArray objectAtIndex:i]).stringValue];
        if(i == 2 || i == 5 || i == 8) {
            [result appendString:@" "];
        }
    }
    return result;
}

- (void)drawDotsPopulation {

    for(GAIndivid *ind in _genAlrorithmNew.firstPopulation) {
        [_plot addBoldDotAtX:ind.pt.x y:ind.pt.y];
    }
}

#pragma mark -
#pragma mark Checkers

-(BOOL)isContainsNumber:(NSString *)string
{
    if([string length] == 0) {
        return NO;
    }
    if([string length] == 1 && ([string characterAtIndex:0] == '.' || [string characterAtIndex:0] == '-')) {
        return NO;
    }
    
    
    BOOL isContainsDot = NO;
    
    for(int i=0; i<[string length]; i++) {
        
        //if "-" value
        if(i==0 && ([string characterAtIndex:i] == '-')) {
            continue;
            
        } else if([string characterAtIndex:i] == '.') {
            if(!isContainsDot) {
                isContainsDot = YES;
            }
            else {
                return NO;
            }
            
        } else if(!isnumber([string characterAtIndex:i])) {
            return NO;
        }
    }
    
    return YES;
}

@end







