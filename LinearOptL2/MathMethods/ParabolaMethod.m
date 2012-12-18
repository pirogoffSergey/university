//
//  ParabolaMethod.m
//  LinearOptimization
//
//  Created by Oxygen on 20.10.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import "ParabolaMethod.h"


@implementation ParabolaMethod

- (id)init
{
    self = [super init];
    if (self) {
        
        // default values
        self.leftBorder = -1;
        self.rightBorder = 1;
        self.f = ^double(double x){
            return pow(x, 3) - x +exp(-x); //x^3 - x + e^(-x)
        };
        self.h = 0.1;
    }
    return self;
}


- (double)findMin {
    
    double a=_leftBorder, b=_rightBorder, c, ya, yb, yc, s, t, yt, x;
    c = (b+a)/2.0;
    
    double e=_epsi;
    _spentIterations = 0;
    
    ya=_f(a);
    yb=_f(b);
    yc=_f(c);
    
    int maxIterations = 1000;
    
    while (b-a>2*e) {
        if(_spentIterations == maxIterations) {
            break;
        }
        
        s=c+0.5*( (b-c)*(b-c)*(ya-yc) - (c-a)*(c-a)*(yb-yc) )/( (b-c)*(ya-yc) + (c-a)*(yb-yc) );
        
        if (s==c) {
            t=(a+c)/2;
        }
        else {
            t=s;
        }
        
        yt=_f(t); _spentIterations++;
        if (t<c) {
            if (yt<yc) {
                b=c;
                yb=yc;
                c=t;
                yc=yt;
            }
            else if (yt>yc) {
                a=t;
                ya=yt;
            }
            else {
                a=t;
                ya=yt;
                b=c;
                yb=yc;
                c=(a+b)/2;
                yc=_f(c);
                _spentIterations++;
            }
        }
        else if (t>c) {
            if (yt<yc) {
                a=c;
                ya=yc;
                c=t;
                yc=yt;
            }
            else if(yt>yc) {
                b=t;
                yb=yt;
            }
            else {
                a=c;
                ya=yc;
                b=t;
                yb=yt;
                c=(a+b)/2;
                yc=_f(c);
                _spentIterations++;
            }
        }
    }
    x=(a+b)/2;
    return x;
}

/*
//- (double)findMin {
//    double a=0, b=1, c, ya, yb, yc, s, t, yt, x, y;
//    
//    c = (b-a)/2.0;
//    
//    double e=0.1;
//    int N = 0;
//        
//    ya=_f(a);
//    yb=_f(b);
//    yc=_f(c);
//    
//    while (b-a>2*e) {
//        
//        s=c+0.5*( (b-c)*(b-c)*(ya-yc) - (c-a)*(c-a)*(yb-yc) )/( (b-c)*(ya-yc) + (c-a)*(yb-yc) );
//        
//        if (s==c) t=(a+c)/2; //see here
//        else t=s;
//        
//        yt=_f(t); N++;
//        if (t<c)
//        {
//            if (yt<yc) {b=c; yb=yc; c=t; yc=yt;}
//            else if (yt>yc) {a=t; ya=yt;}
//            else {a=t; ya=yt; b=c; yb=yc; c=(a+b)/2; yc=_f(c); N++;}
//        }
//        else if (t>c)
//        {
//            if (yt<yc) {a=c; ya=yc; c=t; yc=yt;}
//            else if(yt>yc) {b=t; yb=yt;}
//            else {a=c; ya=yc; b=t; yb=yt; c=(a+b)/2; yc=_f(c); N++; }
//        }
//    }
//    
//    x=(a+b)/2; y=_f(x);
//    NSLog(@"\nx = %.5f \n", x);
//  //  NSLog(@"y = %.5f \n \n", y);
//    
//    NSLog(@"kol-vo tochek: %d", N);
//    
//    return x;
//}
*/
@end
