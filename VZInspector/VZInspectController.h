//
//  VZInspectController.h
//  VZInspector
//
//  Created by moxin.xt on 14-9-23.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VZInspectController : UIViewController

- (void)start;
- (void)stop;

- (BOOL)canTouchPassThrough:(CGPoint)pt;
+ (void)setClassPrefixName:(NSString* )name;

@end
