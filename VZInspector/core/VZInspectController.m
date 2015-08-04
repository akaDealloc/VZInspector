//
//  VZInspectController.m
//  VZInspector
//
//  Created by moxin.xt on 14-9-23.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#include <QuartzCore/QuartzCore.h>
#import "VZInspector.h"
#import "VZInspectController.h"
#import "VZInspectorWindow.h"
#import "VZInspectorOverlay.h"
#import "VZInspectorLogView.h"
#import "VZInspectorCrashRootView.h"
#import "VZInspectorSettingView.h"
#import "VZInspectorToolboxView.h"
#import "VZInspectorGridView.h"
#import "VZInspectorSandBoxRootView.h"
#import "VZInspectorHeapRootView.h"
#import "VZInspectorOverview.h"
#import "VZInspectorNetworkHistoryView.h"
#import "UIWindow+VZInspector.h"
#import "NSObject+VZInspector.h"
#import "VZBorderInspector.h"
#import "VZInspectorTimer.h"
#import "VZInspectorRevealView.h"
#import "VZInspectorDeviceView.h"
#import "VZImageInspector.h"
#import "VZInspectorLocationView.h"
#import "VZCleanInspector.h"

@interface VZInspectController()<VZInspectorToolboxViewCallback>

@property(nonatomic,strong) UIView* contentView;
@property(nonatomic,strong) VZInspectorOverview* overview;
@property(nonatomic,strong) VZInspectorLogView* logView;
@property(nonatomic,strong) VZInspectorSettingView* settingView;
@property(nonatomic,strong) VZInspectorToolboxView* toolboxView;

@end

@implementation VZInspectController

- (UIView* )topView
{
    return _currentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _currentIndex = 0;
    
    //create content view
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)];
    self.contentView.userInteractionEnabled = YES;
    [self.view addSubview:self.contentView];
    
    //create four views:
    
    //1,overview
    self.overview = [[VZInspectorOverview alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40) parentViewController:self];
    _currentView = self.overview;
    [self.view addSubview:self.overview];
    
    //2,logview
    self.logView = [[VZInspectorLogView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40) parentViewController:self];
    
    //3,toolboxView
    self.toolboxView = [[VZInspectorToolboxView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40) parentViewController:self];
    self.toolboxView.callback = self;
    
    //4,settingsview
    self.settingView = [[VZInspectorSettingView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40) parentViewController:self];

    
    
    //4:tab
    for (int i=0; i<5; i++) {
        
        
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        int w = screenBounds.size.width/5;
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(w*i, self.view.frame.size.height-40, w, 40)];
        btn.tag = i+10;
        btn.backgroundColor = [UIColor darkGrayColor];
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 2.0f;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onBtnClikced:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i==0) {
            [btn setTitle:@"Status" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }
        if (i==1) {
            [btn setTitle:@"Log" forState:UIControlStateNormal];
        }
        if (i==2) {
            [btn setTitle:@"Toolbox" forState:UIControlStateNormal];
        }
        if (i==3) {
            [btn setTitle:@"ENV" forState:UIControlStateNormal];
        }
        if (i==4) {
            
            [btn setTitle:@"Close" forState:UIControlStateNormal];
        }
        [self.contentView addSubview:btn];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    //NSLog(@"[%@]-->dealloc",self.class);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public API
//
- (void)start
{
    [self.overview startTimer];

}
- (void)stop
{
    [self.overview stopTimer];
}

- (BOOL)canTouchPassThrough:(CGPoint)pt
{
    int w = self.view.bounds.size.width;
    int h = self.view.bounds.size.height;
    
    if (_currentView.class == [VZInspectorGridView class]) {
        
        if (pt.y < 20) {
            return NO;
        }
        else
            return YES;
    }
    else if (_currentView.class == [VZInspectorLogView class]
             ||_currentView.class == [VZInspectorSandBoxRootView class]
             ||_currentView.class == [VZInspectorHeapRootView class]
             ||_currentView.class == [VZInspectorCrashRootView class]
             ||_currentView.class == [VZInspectorToolboxView class]
             ||_currentView.class == [VZInspectorNetworkHistoryView class]
             ||_currentView.class == [VZInspectorDeviceView class]
             ||_currentView.class == [VZInspectorLocationView class]
             )
    {
        return NO;
    }
    else if (_currentView == self.overview)
    {
        if (pt.y > h-40) {
            return NO;
        } else if (pt.y > h-(40+10+54) && pt.x > w-(10+54)) {
            return NO;
        }
        else
            return YES;
    }
    else if (_currentView == self.settingView)
    {
        if (pt.y < 40) {
            return NO;
        }
        else if (pt.y > h-40 ) {
            return NO;
        }
        else
            return YES;
    }
    else
    {
        if (pt.y > h-40 ) {
            return NO;
        }
        else
            return YES;
    }
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private API



//tab clicked:
- (void)onBtnClikced:(UIButton* )sender
{
    
    for (UIView* v in self.contentView.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            UIButton* btn = (UIButton* )v;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    
    if (sender.tag != 14) {
        [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    }

    switch (sender.tag) {
        case 10:
        {
            if (_currentIndex == 0) {
                return;
            }
            
            [UIView transitionFromView:_currentView toView:self.overview duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
                
                [_currentView removeFromSuperview];
                [self.contentView addSubview:self.overview];
                _currentView = self.overview;
                _currentIndex = 0;
                
            }];
            
            break;
        }
        case 11:
        {
            
            if (_currentIndex == 1) {
                return;
            }
            [UIView transitionFromView:_currentView toView:self.logView duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
                
                [_currentView removeFromSuperview];
                [self.contentView addSubview:self.logView];
                _currentView = self.logView;
                _currentIndex = 1;
            }];
            
            break;
        }
            
        case 12:
        {
            if (_currentIndex == 2) {
                return;
            }
            
            [UIView transitionFromView:_currentView toView:self.toolboxView duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
                
                [_currentView removeFromSuperview];
                [self.contentView addSubview:self.toolboxView];
                _currentView = self.toolboxView;
                _currentIndex = 2;
                
            }];
            
            break;
        }
        case 13:
        {
            [UIView transitionFromView:_currentView toView:self.settingView duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
                
                [_currentView removeFromSuperview];
                [self.contentView addSubview:self.settingView];
                _currentView = self.settingView;
                _currentIndex = 3;
            }];
            
            break;
        }
        case 14:
        {
            [self onClose];
            break;
        }
        default:
            break;
    }
    
}

- (void)onClose
{
    [self stop];
    [VZInspector hide];
}

- (void)onBack
{
    [UIView transitionFromView:_currentView toView:self.contentView duration:0.4 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
        
        [_currentView removeFromSuperview];
        [self.view addSubview:self.contentView];
        [self.contentView addSubview:self.toolboxView];
        
        _currentView = self.toolboxView;
        _currentIndex = 2;
        
    }];
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -  callback


- (void)onToolBoxViewClicked:(VZToolBoxType)type
{
    switch (type) {
        case kNetworkLogs:
        {
            [self showNetworkLogs];
            break;
        }
        
        case kCrashLogs:
        {
            [self showCrashLogs];
            break;
        }
            
        case kSandBox:
        {
            [self showSandBox];
            break;
        }
            
        case kBorder:
        {
            [self showBorder];
            break;
        }
        case kHeaps:
        {
            [self showHeap];
            break;
        }
        case kGrids:
        {
            [self showGrid];
            break;
        }
        case kMemoryWarningOn:
        {
            [self startMemoryWarning];
            break;
        }
        case kMemoryWarningOff:
        {
            [self stopMemoryWarning];
            break;
        }
        case kReveal:
        {
            [self showReveal];
            break;
        }
        case kDevice:
        {
            [self showDeviceInfo];
            break;
        }
        case kImage:
        {
            [self inspectImage];
            break;
        }
        case kLocation:
        {
            [self showFakeLocation];
            break;
        }
        case kClean:
        {
            [self cleanCache];
            break;
        }

        default:
            break;
    }
}


- (void)showSandBox
{
    VZInspectorSandBoxRootView* sandBoxView = [[VZInspectorSandBoxRootView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) parentViewController:self];
    
    
    [UIView transitionFromView:self.contentView toView:sandBoxView duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
        
        [self.contentView removeFromSuperview];
        [self.view addSubview:sandBoxView];
        _currentView = sandBoxView;
        _currentIndex = -1;
        
    }];
}

- (void)showGrid
{
    VZInspectorGridView* gridView = [[VZInspectorGridView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) parentViewController:self];
    
    
    [UIView transitionFromView:self.contentView toView:gridView duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
        
        [self.contentView removeFromSuperview];
        [self.view addSubview:gridView];
        _currentView = gridView;
        _currentIndex = -1;
        
    }];
}

- (void)showHeap
{
    VZInspectorHeapRootView* heapView = [[VZInspectorHeapRootView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) parentViewController:self];
    
    [UIView transitionFromView:self.contentView toView:heapView
                      duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished) {
                        
                        [self.contentView removeFromSuperview];
                        [self.view addSubview:heapView];
                        _currentView = heapView;
                        _currentIndex = -1;
                    }];
    
}

- (void)showNetworkLogs
{
    VZInspectorNetworkHistoryView* networkView = [[VZInspectorNetworkHistoryView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) parentViewController:self];
    
    [UIView transitionFromView:self.contentView toView:networkView
                      duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished) {
                        
                        [self.contentView removeFromSuperview];
                        [self.view addSubview:networkView];
                        _currentView = networkView;
                        _currentIndex = -1;
                    }];
    
}

- (void)showCrashLogs
{
    VZInspectorCrashRootView* crashView = [[VZInspectorCrashRootView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) parentViewController:self];
    
    [UIView transitionFromView:self.contentView toView:crashView
                      duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished) {
                        
                        [self.contentView removeFromSuperview];
                        [self.view addSubview:crashView];
                        _currentView = crashView;
                        _currentIndex = -1;
                    }];
    
}

- (void)showBorder
{
    [[VZBorderInspector sharedInstance] showBorder];
    [self onClose];
}

- (void)inspectImage {
    [[VZImageInspector sharedInstance] inspect];
    [self onClose];
}

- (void)showDeviceInfo
{
    VZInspectorDeviceView * deviceView = [[VZInspectorDeviceView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) parentViewController:self];
    
    
    [UIView transitionFromView:self.contentView toView:deviceView duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
        
        [self.contentView removeFromSuperview];
        [self.view addSubview:deviceView];
        _currentView = deviceView;
        _currentIndex = -1;
        
    }];
}

- (void)startMemoryWarning
{
    self.overview.memoryWarning = true;
}

- (void)stopMemoryWarning
{
    self.overview.memoryWarning = false;
}

- (void)showReveal
{
    //todo...
}
- (void)showFakeLocation
{
    VZInspectorLocationView * locationView = [[VZInspectorLocationView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) parentViewController:self];
    
    
    [UIView transitionFromView:self.contentView toView:locationView duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
        
        [self.contentView removeFromSuperview];
        [self.view addSubview:locationView];
        _currentView = locationView;
        _currentIndex = -1;
        
    }];
}

-(void)cleanCache
{
    [[VZCleanInspector sharedInstance] clean];
}

@end
