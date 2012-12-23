//
//  PlotView.m
//  PlotsDrawer
//
//  Created by Oxygen on 26.09.12.
//  Copyright (c) 2012 oxy. All rights reserved.
//

#import "PlotView.h"

@interface PlotView ()
{
    UIImageView *_canvas;
    UIImageView *_dotsLayer;
    
    NSMutableArray *_chartPointsPack; //Array of Arrays(with CGPoints packed to NSValue)
    NSMutableArray *_dropLinesPack; //Array of Arrays(with CGPoints packed to NSValue)
    NSMutableArray *_dropLinesPackOriginal; //Array of Arrays(with CGPoints packed to NSValue)
}
@end


@implementation PlotView


- (id)init
{
    self = [super init];
    if (self) {
        self.leftBorder = 0;
        self.rightBorder = 20;
        
        self.needDrawSubLines = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.leftBorder = 0;
        self.rightBorder = 20;
        
        self.needDrawSubLines = YES;
        _chartPointsPack = [NSMutableArray new];
        _dropLinesPack = [NSMutableArray new];
        _dropLinesPackOriginal = [NSMutableArray new];
        [self buildChartDots];
        [self buildDropLines];

    }
    return self;
}


- (void) layoutSubviews
{
    _canvas = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:_canvas];
    [self redraw];
}


- (void)redraw
{
    [_canvas setImage:[self imageWithSize:_canvas.frame.size color:[UIColor clearColor]]];
    
    [self drawAxises];
    [self buildChartDots];
    [self buildDropLines];
    [self drawDropPack];
    [self drawChartPack];
    
    if(_dotsLayer) {
        [self clearDotsLayer];
    }
}

- (NSArray *)takePackOfDotsFromSet {
    return _dropLinesPackOriginal;
}


#pragma mark -
#pragma mark Draw Axies

- (void)drawAxises
{
    // X axis
    [_canvas setImage:[self lineFrom:CGPointMake(0, _canvas.frame.size.height-10) to:CGPointMake(_canvas.frame.size.width, _canvas.frame.size.height-10) image:_canvas.image withColor:[UIColor blackColor]]];
    
    //make X arrow
    [_canvas setImage:[self lineFrom:CGPointMake(_canvas.frame.size.width,_canvas.frame.size.height-10)
                                  to:CGPointMake(_canvas.frame.size.width-10,(_canvas.frame.size.height-10)-5)
                               image:_canvas.image
                           withColor:[UIColor blackColor]]];
    [_canvas setImage:[self lineFrom:CGPointMake(_canvas.frame.size.width,_canvas.frame.size.height-10)
                                  to:CGPointMake(_canvas.frame.size.width-10,(_canvas.frame.size.height-10)+5)
                               image:_canvas.image
                           withColor:[UIColor blackColor]]];
    
    if([self isNeedDrawYaxis]) {
        // Y axis
        [_canvas setImage:[self lineFrom:CGPointMake(10, 0) to:CGPointMake(10, _canvas.frame.size.height) image:_canvas.image withColor:[UIColor blackColor]]];
        
        //make Y arrow
        [_canvas setImage:[self lineFrom:CGPointMake(10, 0)
                                      to:CGPointMake(10-5, 10)
                                   image:_canvas.image
                               withColor:[UIColor blackColor]]];
        [_canvas setImage:[self lineFrom:CGPointMake(10, 0)
                                      to:CGPointMake(10+5, 10)
                                   image:_canvas.image
                               withColor:[UIColor blackColor]]];
    }
    
    
    //making dots
    int iteration = 0;
    CGPoint xPoint;
    CGPoint yPoint;
    for(float x=_leftBorder; x<_rightBorder; x++) {
        
        xPoint = [self interpritateFuncToScreenX:x y:0];
        yPoint = [self interpritateFuncToScreenX:0 y:-x];
        [self drawVerticalRisochkaAtPoint:xPoint];
        [self drawHorizontalRisochkaAtPoint:yPoint];
        
        
        //making axes gradation
        if(iteration%2 == 0) {
            if (x < 0) {
                [self drawText:[NSString stringWithFormat:@"%.1f",x] atPoint:CGPointMake(xPoint.x-8,xPoint.y)]; //x
                [self drawText:[NSString stringWithFormat:@"%.1f",x] atPoint:CGPointMake(yPoint.x+5,yPoint.y-6)]; //y
            }
            else if (x > 0) {
                [self drawText:[NSString stringWithFormat:@"%.1f",x] atPoint:CGPointMake(xPoint.x-5,xPoint.y)]; //x
                [self drawText:[NSString stringWithFormat:@"%.1f",x] atPoint:CGPointMake(yPoint.x+5,yPoint.y-6)]; //y
            }
        }
        
        //draw sublines
        if(self.needDrawSubLines) {
            
            [_canvas setImage: [self lineFrom:CGPointMake(xPoint.x, 0) to:CGPointMake(xPoint.x, _canvas.frame.size.height) image:_canvas.image withColor:[UIColor grayColor] lineWidth:0.1]];//x
            
            [_canvas setImage: [self lineFrom:CGPointMake(0, yPoint.y) to:CGPointMake(_canvas.frame.size.width, yPoint.y) image:_canvas.image withColor:[UIColor grayColor] lineWidth:0.1]];//x
        }
        iteration++;
    }
}

- (void)drawVerticalRisochkaAtPoint:(CGPoint)point
{
    [_canvas setImage:[self lineFrom:CGPointMake(point.x, point.y-3)
                                  to:CGPointMake(point.x, point.y+3)
                               image:_canvas.image
                           withColor:[UIColor blackColor]]];
}

- (void)drawHorizontalRisochkaAtPoint:(CGPoint)point
{
    [_canvas setImage:[self lineFrom:CGPointMake(point.x-3, point.y)
                                  to:CGPointMake(point.x+3, point.y)
                               image:_canvas.image
                           withColor:[UIColor blackColor]]];
}

- (void)drawText:(NSString *)text atPoint:(CGPoint)pt
{
    UIFont *font = [UIFont fontWithName:@"Arial" size:8];
    UIImage *stringImage = [self imageFromText:text withFont:font andColor:nil];
    [_canvas setImage:[self combineImage:_canvas.image withImage:stringImage atPoint:pt]];
}

- (BOOL)isNeedDrawYaxis
{
    if(self.leftBorder<=0 && self.rightBorder>=0) {
        return YES;
    }
    else {
        return NO;
    }
}


#pragma mark -
#pragma mark Draw Chart (Inequalities  Mode)

- (void)buildChartDots
{
    assert((_rightBorder-_leftBorder) > 0);
        
    float step = 0.01;
    float y1 = 0;
    float y2 = 0;
    
    CGPoint p1;
    CGPoint p2;
    
    NSArray *inequalities = [self.ineqSystem allInequalities];
    for(GAInequality *ineq in inequalities) {
        
        NSMutableArray *oneLineDots = [NSMutableArray array];
        for(float h=_leftBorder; h<_rightBorder-step; h+=step) {
            
            y1 = [ineq asFunction:h];
            y2 = [ineq asFunction:h+step];
            
            p1 = [self interpritateFuncToScreenX:h y:-y1]; //invert Y cause we transform (0,0)to (160,240)
            p2 = [self interpritateFuncToScreenX:h y:-y2];
            
            if((p1.y < 0 || p2.y < 0) || (p1.y > _canvas.frame.size.height || p2.y > _canvas.frame.size.height)) {
                continue;
            }
            
            [oneLineDots addObject:[NSValue valueWithCGPoint:p1]];
            [oneLineDots addObject:[NSValue valueWithCGPoint:p2]];
        }
        [_chartPointsPack addObject:oneLineDots];
    }    
}

- (void)drawChartPack {
    
    UIImage *image = _canvas.image;

    CGSize screenSize = self.frame.size;
    UIGraphicsBeginImageContext(screenSize);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    [image drawInRect:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    
    CGContextSetLineCap(currentContext, kCGLineCapRound);
    CGContextSetLineWidth(currentContext, 2);
    CGContextSetRGBStrokeColor(currentContext, 1, 1, 0, 1);
    CGContextBeginPath(currentContext);
    
    CGPoint pt1;
    CGPoint pt2;
    for(NSArray *chartPoints in _chartPointsPack) {
        
        for (int i=0; i<chartPoints.count-1; i++) {
            pt1 = ((NSValue *)[chartPoints objectAtIndex:i]).CGPointValue;
            pt2 = ((NSValue *)[chartPoints objectAtIndex:i+1]).CGPointValue;
            
            CGContextMoveToPoint(currentContext, pt1.x, pt1.y);
            CGContextAddLineToPoint(currentContext, pt2.x, pt2.y);
        }
    }
    
    CGContextStrokePath(currentContext);
    
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [_canvas setImage:ret];
}

- (void)buildDropLines {
    
    NSMutableArray *linePoints;
    NSMutableArray *linePointsOriginal;
    
    double h = 0.1;
    CGPoint dot;
    
    for(double i=20; i>0; i-=0.3) {
        
        linePoints = [NSMutableArray new];
        linePointsOriginal = [NSMutableArray new];
        for(double j=0; j<20; j+=h) {
            
            dot = CGPointMake(j, i);
            if([self.ineqSystem doesDotBelongToSystem:dot]) {
                
                [linePointsOriginal addObject:[NSValue valueWithCGPoint:dot]];
                
                dot = [self interpritateFuncToScreenX:dot.x y:-dot.y];
                [linePoints addObject:[NSValue valueWithCGPoint:dot]];
            }
        }
        if(linePoints.count!=0) {
            [_dropLinesPack addObject:linePoints];
            [_dropLinesPackOriginal addObject:linePointsOriginal];
        }
    }
}

- (void)drawDropPack {
    
    UIImage *image = _canvas.image;
    
    CGSize screenSize = self.frame.size;
    UIGraphicsBeginImageContext(screenSize);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    [image drawInRect:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    
    CGContextSetLineCap(currentContext, kCGLineCapRound);
    CGContextSetLineWidth(currentContext, 1);
    CGContextSetRGBStrokeColor(currentContext, 1, 0, 0, 1);
    CGContextBeginPath(currentContext);
    
    CGPoint pt1;
    CGPoint pt2;
    for(NSArray *dropPoints in _dropLinesPack) {
        
        pt1 = ((NSValue *)[dropPoints objectAtIndex:0]).CGPointValue;
        pt2 = ((NSValue *)[dropPoints objectAtIndex:dropPoints.count-1]).CGPointValue;        
        CGContextMoveToPoint(currentContext, pt1.x, pt1.y);
        CGContextAddLineToPoint(currentContext, pt2.x, pt2.y);
    }
    
    CGContextStrokePath(currentContext);
    
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [_canvas setImage:ret];
}



#pragma mark -
#pragma mark Drawing SubMethods

- (CGPoint)interpritateFuncToScreenX:(float)x y:(float)y
{
    float k = _canvas.frame.size.width/(_rightBorder - _leftBorder);
    
    return CGPointMake(k*x+10, k*y+(_canvas.frame.size.height-10));
}

/** Draws a line to an image and returns the resulting image */
- (UIImage *)lineFrom:(CGPoint)fromPoint to:(CGPoint)toPoint image:(UIImage *)image withColor:(UIColor *)color
{
    return [self lineFrom:fromPoint to:toPoint image:image withColor:color lineWidth:1.0];
}

- (UIImage *)lineFrom:(CGPoint)fromPoint to:(CGPoint)toPoint image:(UIImage *)image withColor:(UIColor *)color lineWidth:(CGFloat)width
{
    //get components of color
    CGFloat red = 0, green = 0, blue = 0, alpha = 0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    
    CGSize screenSize = self.frame.size;
    UIGraphicsBeginImageContext(screenSize);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    [image drawInRect:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    
    CGContextSetLineCap(currentContext, kCGLineCapRound);
    CGContextSetLineWidth(currentContext, width);
    CGContextSetRGBStrokeColor(currentContext, red, green, blue, 1);
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, fromPoint.x, fromPoint.y);
    CGContextAddLineToPoint(currentContext, toPoint.x, toPoint.y);
    CGContextStrokePath(currentContext);
    
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ret;
}


// Color+Rect -> UIImage
- (UIImage *)imageWithSize:(CGSize)size color:(UIColor *)aColor
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

// create from NSString -> UIImage
- (UIImage *)imageFromText:(NSString *)text withFont:(UIFont *)font andColor:(UIColor *)color
{
    if(!font){
        font = [UIFont systemFontOfSize:20.0];
    }
    CGSize size  = [text sizeWithFont:font];
    
    if (UIGraphicsBeginImageContextWithOptions != NULL){
        UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    }
    else{
        UIGraphicsBeginImageContext(size);
    }
    
    if(color){
        [color setFill];
    }
    [text drawAtPoint:CGPointMake(0.0, 0.0) withFont:font];
    
    // transfer image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*) combineImage:(UIImage *)mainImage withImage:(UIImage *)subImage atPoint:(CGPoint)pt
{
    CGSize size = CGSizeMake(mainImage.size.width, mainImage.size.height);
    UIGraphicsBeginImageContext(size);
    
    [mainImage drawAtPoint:CGPointMake(0, 0)];
    
    CGPoint starredPoint = pt;
    [subImage drawAtPoint:starredPoint];
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}


#pragma mark -
#pragma mark Work with 2nd Layer

- (void)addBoldDotAtX:(double)x y:(double)y
{
    if(!_dotsLayer) {
        _dotsLayer = [[UIImageView alloc] initWithFrame:_canvas.frame];
        _dotsLayer.image = [self imageWithSize:_canvas.frame.size color:[UIColor clearColor]];
        
        [_canvas addSubview:_dotsLayer];
    }
    
    CGPoint pt = [self interpritateFuncToScreenX:x y:-y];
    [_dotsLayer setImage: [self lineFrom:pt to:CGPointMake(pt.x, pt.y) image:_dotsLayer.image withColor:[UIColor blueColor] lineWidth:5]];
}

- (void)clearDotsLayer
{
    [_dotsLayer setImage:[self imageWithSize:_dotsLayer.frame.size color:[UIColor clearColor]]];
}

@end