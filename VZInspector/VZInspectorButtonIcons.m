//
//  VZInspectorButtonIcons.m
//  VZInspector
//
//  Created by lingwan on 15/4/13.
//  Copyright (c) 2015年 VizLabe. All rights reserved.
//

#import "VZInspectorButtonIcons.h"

@implementation VZExitIcon
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
    CGContextSetLineWidth(context, kIconLineWidth);
    
    int padding = kIconPadding * 1.8;
    CGContextMoveToPoint(context, padding, padding);//upper-left
    CGContextAddLineToPoint(context, kIconDimension - padding, kIconDimension - padding);//lower-right
    CGContextMoveToPoint(context, kIconDimension - padding, padding);//upper-right
    CGContextAddLineToPoint(context, padding, kIconDimension - padding);//lower-left
    
    CGContextStrokePath(context);
}
@end

@implementation VZBorderIcon
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
    CGContextSetLineWidth(context, kIconLineWidth);
    
    CGContextAddRect(context, CGRectMake(kIconPadding, kIconPadding + 4, kIconDimension - kIconPadding * 2, kIconDimension - kIconPadding * 2 - 8));
    
    CGContextStrokePath(context);
}
@end

@implementation VZSandBoxIcon
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
    CGContextSetLineWidth(context, kIconLineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    float radius = (kIconDimension / 2 - kIconPadding / 2) * 1.414;
    //top
    CGContextMoveToPoint(context, kIconPadding / 2, kIconDimension / 2);
    CGContextAddArcToPoint(context, kIconDimension / 2, kIconPadding / 2, kIconDimension - kIconPadding / 2, kIconDimension / 2, radius);
    CGContextStrokePath(context);
    //bottom
    CGContextMoveToPoint(context, kIconPadding / 2, kIconDimension / 2);
    CGContextAddArcToPoint(context, kIconDimension / 2, kIconDimension - kIconPadding / 2, kIconDimension - kIconPadding / 2, kIconDimension / 2, radius);
    CGContextStrokePath(context);
    //eyeball
    [[UIColor orangeColor] setFill];
    CGContextAddArc(context, kIconDimension / 2, kIconDimension / 2, kIconDimension / 8, 0, M_PI * 2, 1);
    CGContextFillPath(context);
}
@end

@implementation VZGridIcon
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
    CGContextSetLineWidth(context, kIconLineWidth);
    
    float distance = kIconDimension / 3;
    float padding = (kIconDimension - distance) / 2;
    
    //horizontal
    [self drawSingleLine:context :CGPointMake(kIconPadding, padding) :CGPointMake(kIconDimension - kIconPadding, padding)];
    [self drawSingleLine:context :CGPointMake(kIconPadding, padding + distance) :CGPointMake(kIconDimension - kIconPadding, padding + distance)];
    //vertical
    [self drawSingleLine:context :CGPointMake(padding, kIconPadding) :CGPointMake(padding, kIconDimension - kIconPadding)];
    [self drawSingleLine:context :CGPointMake(padding + distance, kIconPadding) :CGPointMake(padding + distance, kIconDimension - kIconPadding)];
}

- (void) drawSingleLine:(CGContextRef)context :(CGPoint) startPt :(CGPoint) endPt{
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
    CGContextSetLineWidth(context, kIconLineWidth);
    CGContextSetShouldAntialias(context, NO);
    CGContextMoveToPoint(context, startPt.x, startPt.y);
    CGContextAddLineToPoint(context, endPt.x, endPt.y);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}
@end

@implementation VZMemWarningIcon
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
    CGContextSetLineWidth(context, kIconLineWidth);
    
    //todo
}
@end