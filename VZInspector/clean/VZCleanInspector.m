//
//  VZCleanInspector.m
//  VZInspector
//
//  Created by heling on 15/8/4.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "VZCleanInspector.h"

@implementation VZCleanInspector

+ (VZCleanInspector* )sharedInstance
{
    static VZCleanInspector* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [VZCleanInspector new];
    });
    
    return instance;
}

- (void)clean{
    if (self.pathList.count==0) {
        return;
    }
    NSString *homeDir= NSHomeDirectory();
    for (NSString *s in self.pathList) {
        NSString *path = [NSString stringWithFormat:@"%@/%@",homeDir,s];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}
@end
