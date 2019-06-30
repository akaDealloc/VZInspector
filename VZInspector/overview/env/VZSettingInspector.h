//
//  Copyright © 2016年 Vizlab. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^vz_api_env_callback)(void);
typedef void(^vz_api_env_switch_callback)(void);

@interface VZSettingInspector : NSObject

+ (VZSettingInspector* )sharedInstance;
+ (void)addAPIEnvButtonWithName:(NSString* )type Selected:(BOOL)selected Callback:(vz_api_env_callback)callback;
+ (void)addAPIEnvSwitchWithName:(NSString* )type Selected:(BOOL)selected Callback:(vz_api_env_switch_callback)callback;
+ (NSArray* )currentAPIEnvButtons;
+ (NSArray* )currentAPIEnvSwitches;

@end
