//
//  GAInequality.m
//  GeneticAlgorithm
//
//  Created by Oxygen on 22.12.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import "GAInequality.h"

@interface GAInequality ()

@property (nonatomic, copy) BOOL(^comparator)(CGFloat n1, CGFloat n2);

@end



@implementation GAInequality

#pragma mark -
#pragma mark Ptivate Methods

- (void)setSignType:(GAInequalitySignType)signType {
    _signType = signType;
    [self setupComparator];
}

- (void)setupComparator {
    switch (self.signType) {
        case kLess:
           self.comparator = ^(CGFloat n1, CGFloat n2){
                if(n1<n2)
                    return YES;
                else
                    return NO;
            };
            break;
            
        case kLessOrEqual:
            self.comparator = ^(CGFloat n1, CGFloat n2){
                if(n1<=n2)
                    return YES;
                else
                    return NO;
            };
            break;
            
        case kHigher:
            self.comparator = ^(CGFloat n1, CGFloat n2){
                if(n1>n2)
                    return YES;
                else
                    return NO;
            };
            break;
            
        case kHigherOrEqual:
            self.comparator = ^(CGFloat n1, CGFloat n2){
                if(n1>=n2)
                    return YES;
                else
                    return NO;
            };
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark Public Methods

- (id)initWithA:(CGFloat)a B:(CGFloat)b C:(CGFloat)c
{
    self = [super init];
    if(self) {
        _a = a;
        _b = b;
        _c = c;
        _signType = kLessOrEqual;
    }
    return self;
}

- (BOOL)doesDotBelongToInequality:(CGPoint)dot {

    CGFloat leftPart = self.a*dot.x + self.b*dot.y;
    return self.comparator(leftPart,self.c);
}

@end
