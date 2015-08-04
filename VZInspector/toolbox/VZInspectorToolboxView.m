//
//  VZToolboxView.m
//  VZInspector
//
//  Created by lingwan on 15/4/16.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "VZInspectorToolboxView.h"
#import "VZInspectorResource.h"
#import <objc/runtime.h>


@interface VZInspectorToolboxView()
{
    int  _marginTop;
    NSArray* _icons;
}


@end

@implementation VZInspectorToolboxView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _type = kDefault;
        _marginTop = 120;
       
        
        _icons = @[@{@"Logs":[VZInspectorResource network_logs]},
                   @{@"Heap":[VZInspectorResource heap]},
                   @{@"Crash":[VZInspectorResource crash]},
                   @{@"SandBox":[VZInspectorResource sandbox]},
                   @{@"Gird":[VZInspectorResource grid]},
                   @{@"Border":[VZInspectorResource viewClass]},
                   @{@"Reveal":[VZInspectorResource reveal]},
                   @{@"Warning":[VZInspectorResource memoryWarningOn]},
                   @{@"Device":[VZInspectorResource device]},
                   @{@"Image":[VZInspectorResource image]},
                   @{@"Location":[VZInspectorResource location]},
                   @{@"Clean":[VZInspectorResource clean]}
                   ];

        
        UIImage* logo = [VZInspectorResource logo];
        
        UIImageView* logov= [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width - 60)/2, 30, 60, 60)];
        logov.image = logo;
        [self addSubview:logov];
        
        float w = frame.size.width / 5;
        float h = w;
        
        //draw grid
        for (int i=0; i<6; i++) {
        
            int x1 = i*w;
            int y1 = _marginTop;
            
            if (i==5) {
                x1 -= 2;
            }
            UIView* verticalLine = [[UIView alloc]initWithFrame:CGRectMake(x1, y1, 2, h*4)];
            verticalLine.backgroundColor = [UIColor grayColor];
            [self addSubview:verticalLine];
        }
        
        for (int i=0; i<5; i++) {
            
            int y2 = i*h + _marginTop;
            int x2 = 0;
            
            UIView* horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(x2, y2, frame.size.width, 2)];
            horizontalLine.backgroundColor = [UIColor grayColor];
            [self addSubview:horizontalLine];
        }

        for (int i=0; i<_icons.count; i++) {
            
            int x =   w*(i%5);
            int y = _marginTop + (i/5)*h;
            
            UIButton* btn  = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, w)];
            btn.tag = i;
            
            NSDictionary* tuple = _icons[i];
            NSString* title = [tuple allKeys][0];
            UIImage* icon   = [tuple allValues][0];
            [btn setTitle: title forState:UIControlStateNormal];
            [btn setImage: icon forState:UIControlStateNormal];
            
            [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
            [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            
            CGFloat spacing = 6.0;
            CGSize imageSize = btn.imageView.frame.size;
            btn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
   
            CGSize titleSize = btn.titleLabel.frame.size;
            btn.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), (w-32)/2, 0.0, 0.0);//icon width = 32

            [btn addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}


- (void)onBtnClicked:(UIView* )sender
{

    switch (sender.tag) {
        
        case 0:
        {
            _type = kNetworkLogs;
            break;
        }
        case 1:
        {
            _type = kHeaps;
            break;
        }
            
        case 2:
        {
            _type = kCrashLogs;
            break;
        }
        case 3:
        {
            _type = kSandBox;
            break;
        }
        case 4:
        {
            _type = kGrids;
            break;
        }
        case 5:
        {
            _type = kBorder;
            break;
        }
        case 6:
        {
            _type = kReveal;
            break;
        }
        case 7:
        {
            if (_type != kMemoryWarningOn) {
                _type = kMemoryWarningOn;
            }
            else
                _type = kMemoryWarningOff;
            break;
        }
        case 8:
        {
            _type = kDevice;
            break;
        }
        case 9:
        {
            _type = kImage;
            break;
        }
        case 10:
        {
            _type = kLocation;
            break;
        }
        case 11:
        {
            _type = kClean;
            break;
        }

            
        default:
            break;
    }
    
    if ([self.callback respondsToSelector:@selector(onToolBoxViewClicked:)]) {
        [self.callback onToolBoxViewClicked:_type];
    }

    
}

@end
