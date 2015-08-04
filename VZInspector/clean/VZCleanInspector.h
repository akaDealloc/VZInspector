//
//  VZCleanInspector.h
//  VZInspector
//
//  Created by heling on 15/8/4.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VZCleanInspector : NSObject

//@[@"Library/abc",@"Library/xxxx"]
@property(nonatomic,copy) NSArray *pathList;

+ (VZCleanInspector* )sharedInstance;

- (void)clean;

@end
