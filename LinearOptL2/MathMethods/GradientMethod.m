//
//  GradientMethod.m
//  LinearOptimization
//
//  Created by Oxygen on 04.12.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import "GradientMethod.h"


#define eps 0.001



@interface GradientMethod ()

@end



@implementation GradientMethod

- (id)init {
    self = [super init];
    if(self) {
        self.r = 5;
        
        self.a = 1;
        self.b = 5;
        
        self.c = 1;
        self.d = 5;
    }
    return self;
}


#pragma mark -
#pragma mark F(x)

-(double)f:(CGPoint)pt {
    
    //  x^2 + 2y^2 + e^(x+y)
    double x0 = pt.x;
    double x1 = pt.y;

    double toReturn = _a*pow((x0-_b), 2);
    toReturn += _c*pow((x1-_d), 2);
    
    toReturn += exp(x0+x1);
    return toReturn;
}


#pragma mark -
#pragma mark Private Methods

-(CGPoint)grad_func:(CGPoint)x {
    
    double h = 0.000001;
    CGPoint temp = CGPointMake(x.x + h, x.y);
    
    double grad0 = ([self f:temp] - [self f:x])/h;
    CGPoint grad = CGPointMake(grad0, 0);
    
    temp.x = x.x;
    temp.y = x.y + h;
    
    double grad1 = ([self f:temp] - [self f:x])/h;
    grad.y = grad1;
    return grad;
}

- (CGPoint)Gradient:(CGPoint)input {
    
    CGPoint X;
    X.x = input.x;
    X.y = input.y;    
    
    double alpha = 1;
    CGPoint grad_funcDiff;
    CGPoint Xk;

    double summa = 1;
    do {
        grad_funcDiff = [self grad_func:X];
        Xk.x = X.x - alpha * grad_funcDiff.x;
        Xk.y = X.y - alpha * grad_funcDiff.y;

        if([self f:Xk] > [self f:X]) {
            alpha /= 2;
            continue;
        }
        else {
            grad_funcDiff = [self grad_func:Xk];
            summa = 0;
            double val = 0;
            X.x = Xk.x;
            val = grad_funcDiff.x;
            summa += val * val;
            X.y = Xk.y;
            val = grad_funcDiff.y;
            summa += val * val;
            summa = sqrt(summa);
        }
    }while(!(summa<eps));
    
    return Xk;
}


#pragma mark -
#pragma mark Public Methods

- (void)calculate {
    
    CGPoint x = CGPointMake(0, 0);
    CGPoint result = [self Gradient:x];
    self.foundedDot = result;
    
    
    self.logView.text = @"";
    
    [self log:@"Real dot:"];
    [self log:[NSString stringWithFormat:@"\nx1 = %f", result.x]];
    [self log:[NSString stringWithFormat:@"\nx2 = %f", result.y]];
    [self log:[NSString stringWithFormat:@"\ny= %f", [self f:result]]];
    
    
    CGPoint resultsProj = [self dotProjection:result];
    self.projectedDot = resultsProj;
    [self log:@"\n\nProjected:"];
    [self log:[NSString stringWithFormat:@"\nx1 = %f", resultsProj.x]];
    [self log:[NSString stringWithFormat:@"\nx2 = %f", resultsProj.y]];
    [self log:[NSString stringWithFormat:@"\ny= %f", [self f:resultsProj]]];
}



#pragma mark -
#pragma mark Projection

- (double)normaForDot:(CGPoint)pt {
    double underSqrt = pt.x*pt.x + pt.y*pt.y;
    return sqrt(underSqrt);
}

- (BOOL)isDotInsideTheBoll:(CGPoint)pt{
    
    //x^2+y^2 = R"2
    double res = pt.x * pt.x + pt.y * pt.y;
    if(res <= _r*_r) {
        return YES;
    }
    return NO;
}

- (CGPoint)dotProjection:(CGPoint)dot {
    
    if([self isDotInsideTheBoll:dot]) {
        return dot;
    }
    
    double norma = [self normaForDot:dot];
    double k = self.r/norma;
    return CGPointMake(k*dot.x, k*dot.y);
}


- (void)log:(NSString *)str {
    self.logView.text = [NSString stringWithFormat:@"%@%@", self.logView.text, str];
}

@end
