//
//  VZToolboxView.h
//  VZInspector
//
//  Created by lingwan on 15/4/16.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "VZInspectorView.h"

typedef NS_ENUM(NSInteger, VZToolBoxType)
{
    kDefault = -1,
    kNetworkLogs = 0,
    kHeaps ,
    kBorder,
    kCrashLogs,
    kSandBox,
    kGrids,
    kMemoryWarningOn,
    kMemoryWarningOff,
    kReveal,
    kDevice,
    kImage,
    kLocation,
    kClean
    
};

@protocol VZInspectorToolboxViewCallback <NSObject>

- (void)onToolBoxViewClicked:(VZToolBoxType)type;

@end

@interface VZInspectorToolboxView : VZInspectorView

@property(nonatomic,assign,readonly) VZToolBoxType type;
@property(nonatomic,weak) id<VZInspectorToolboxViewCallback> callback;

@end
