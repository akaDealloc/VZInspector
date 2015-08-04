//
//  VZInspector.m
//  VZInspector
//
//  Created by moxin.xt on 14-9-23.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "VZInspector.h"
#import "VZInspectorOverlay.h"
#import "VZInspectorWindow.h"
#import "VZHeapInspector.h"
#import "VZCrashInspector.h"
#import "VZOverviewInspector.h"
#import "VZSettingInspector.h"
#import "VZLogInspector.h"
#import "VZInspectController.h"
#import "VZNetworkObserver.h"
#import "VZBorderInspector.h"
#import "VZCleanInspector.h"

@implementation VZInspector

+ (void)showOnStatusBar
{
    [VZInspectorOverlay show];
}
+ (BOOL)isShow
{
    return ![VZInspectorWindow sharedInstance].hidden;
}

+ (void)show
{
    [VZInspectorWindow sharedInstance].hidden = NO;
}

+ (void)hide
{
    [VZInspectorWindow sharedInstance].hidden = YES;
    
}

+ (void)setClassPrefixName:(NSString *)name
{
    [VZHeapInspector   setClassPrefixName:name];
    [VZBorderInspector setViewClassPrefixName:name];
}

+ (void)setShouldHandleCrash:(BOOL)b
{
    if (b) {
        [[VZCrashInspector sharedInstance] install];
    }
    
}

+ (void)setShouldHookNetworkRequest:(BOOL)b
{
    [VZNetworkObserver setEnabled:b];
    [VZNetworkObserver setShouldEnableOnLaunch:b];
}

+ (void)setLogNumbers:(NSUInteger)num
{
    [VZLogInspector setNumberOfLogs:num];
}

+ (void)setObserveCallback:(NSString* (^)(void)) callback;
{
    [VZOverviewInspector sharedInstance].observingCallback = callback;
}

+ (void)setDefaultAPIEnvIndex:(NSInteger)index
{
    [VZSettingInspector sharedInstance].defaultEnvIndex = index;
}

+ (void)setDevAPIEnvCallback:(void(^)(void))callback
{
    [VZSettingInspector sharedInstance].apiDevCallback = callback;
}

+ (void)setTestAPIEnvCallback:(void(^)(void))callback
{
    [VZSettingInspector sharedInstance].apiTestCallback = callback;
}

+ (void)setProductionAPIEnvCallback:(void(^)(void))callback
{
    [VZSettingInspector sharedInstance].apiProductionCallback = callback;
}

+ (void)setCleanPathList:(NSArray *)pathList{
    [VZCleanInspector sharedInstance].pathList = pathList;
}
@end
