//
//  GoldenSection.m
//  LinearOptimization
//
//  Created by Oxygen on 19.10.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import "GoldenSection.h"

@interface GoldenSection()
{
    double _goldenDelta;
}
@end


@implementation GoldenSection

- (id)init
{
    self = [super init];
    if (self) {
        
        // default values
        self.leftBorder = -1;
        self.rightBorder = 1;
        self.f = ^double(double x){
            return x*x;
        };
        
        _goldenDelta = (1 + sqrt(5))/2;
        self.epsi = 0.01;
    }
    return self;
}


- (double)findMin
{
    return [self findExtremMin:YES];
}

- (double)findMax
{
   return [self findExtremMin:NO];
}

- (double)findExtremMin:(BOOL)isMin
{
    // isMin == YES -> min
    // isMin == NO -> max
    
    _spentIterations = 0;
    int iteration = 0;
    
    double a = self.leftBorder;
    double b = self.rightBorder;
    
    double x1 = 0;
    double x2 = 0;
    
    do {
        x1 = b - (b-a)/_goldenDelta;
        x2 = a + (b-a)/_goldenDelta;
        
        if (isMin) {
            if (self.f(x1) >= self.f(x2)) {
                a = x1;
            }
            else {
                b = x2;
            }
        }
        else { //find MAX elem
            if (self.f(x1) <= self.f(x2)) {
                a = x1;
            }
            else {
                b = x2;
            }
        }
        
        if(fabs(b-a) < self.epsi) {
            NSLog(@"spent \'%d\' iterations", iteration);
            _spentIterations = iteration;
            return (a + b)/2.0;
        }
        
        iteration ++;
        
    } while (iteration<100);
    
    if(iteration >= 100) {
        _spentIterations = iteration;
        NSLog(@"can't reach this accuracy!");
    }
    
    return (a + b)/2.0;
}


@end
