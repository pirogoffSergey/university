//
//  MainViewController.m
//  LinearOptimization
//
//  Created by Oxygen on 19.10.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import "MainViewController.h"
#import "PlotView.h"

#import "GoldenSection.h"
#import "ParabolaMethod.h"

#import "GradientMethod.h"


#define A_FIELD 1
#define B_FIELD 2
#define C_FIELD 3
#define D_FIELD 4

#define R_FIELD 5

@interface MainViewController () <UITextFieldDelegate>
{
    PlotView *_plotView;
    
    GradientMethod *_gradMethod;
}
@end


@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.radiusTF.delegate = self;
    self.aField.delegate = self;
    self.bField.delegate = self;
    self.cField.delegate = self;
    self.dField.delegate = self;
    self.radiusTF.tag = R_FIELD;
    self.aField.tag = A_FIELD;
    self.bField.tag = B_FIELD;
    self.cField.tag = C_FIELD;
    self.dField.tag = D_FIELD;
    
    _gradMethod = [GradientMethod new];
    _gradMethod.logView = self.resultTV;

    
    
    double(^f)(double) = ^double(double x){
        return sqrt(_gradMethod.r*_gradMethod.r - x*x);
    };

    _plotView = [[PlotView alloc] initWithFrame:self.plotPlace.frame];
    _plotView.leftBorder = -10;
    _plotView.rightBorder = 10;
    _plotView.f = f;
    _plotView.isCircleDraw = YES;
    
    [self.plotPlace removeFromSuperview];
    [self.view addSubview:_plotView];
}


- (IBAction)start:(id)sender {
    
    // hide keyboard
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    [_gradMethod calculate];
    [_plotView clearDotsLayer];
    
    [_plotView addBoldDotAtX:_gradMethod.foundedDot.x y:_gradMethod.foundedDot.y];
    [_plotView addBoldDotAtX:_gradMethod.projectedDot.x y:_gradMethod.projectedDot.y];
}

- (void)viewDidUnload {
    [self setPlotPlace:nil];
    [self setResultTV:nil];
    [self setRadiusTF:nil];
    [super viewDidUnload];
}


#pragma mark -
#pragma mark TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"tf = %@", textField.text);
    if(![self isContainsNumber:textField.text]) {
        textField.text = @"0";
    }
    
    
    switch (textField.tag) {
        case R_FIELD:
            _gradMethod.r = textField.text.doubleValue;
            break;
            
        case A_FIELD:
            _gradMethod.a = textField.text.doubleValue;
            break;
            
        case B_FIELD:
            _gradMethod.b = textField.text.doubleValue;
            break;
            
        case C_FIELD:
            _gradMethod.c = textField.text.doubleValue;
            break;
            
        case D_FIELD:
            _gradMethod.d = textField.text.doubleValue;
            break;
            
        default:
            break;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
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










