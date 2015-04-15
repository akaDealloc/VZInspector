//
//  VZInspectorConsoleView.m
//  VZInspector
//
//  Created by moxin.xt on 14-11-26.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "VZInspectorConsoleView.h"
#import <objc/runtime.h>
#import "VZInspectorButtonIcons.h"

#define kButtonStatusKey @"VZButtonStatusKey"

@interface VZInspectorConsoleView()<UITextFieldDelegate>

@property (nonatomic, strong) UITextView *consoleView;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) NSMutableArray *logs;
@property(nonatomic,assign) NSInteger logMax;
@property(nonatomic,assign) CGRect oldFrm;

@property (nonatomic, strong) NSArray *buttonIconsArray;

@end

@implementation VZInspectorConsoleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.buttonIconsArray = @[[[VZBorderIcon  alloc] init],
                                  [[VZGridIcon alloc] init],
                                  [[VZSandBoxIcon alloc] init],
                                  [[VZGridIcon alloc] init],
                                  [[VZExitIcon alloc] init]];
        
        float width = [UIScreen mainScreen].bounds.size.width / 4;
        float space = (width - kIconDimension) / 2;
        for (int i = 0; i < self.buttonIconsArray.count; i++) {
            float x = space + space * (i % 4) * 2 + (i % 4) * kIconDimension;
            float y = space + space * (int)(i / 4) * 2 + (int)(i / 4) * kIconDimension;
            CGRect frame = CGRectMake(x, y, kIconDimension, kIconDimension);
            
            UIView *view = self.buttonIconsArray[i];
            view.backgroundColor = [UIColor clearColor];
            view.frame = frame;
            [self addSubview:view];
            
            UIButton *button = [[UIButton alloc] initWithFrame:frame];
            button.backgroundColor = [UIColor clearColor];
            button.tag = i;
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            objc_setAssociatedObject(button, kButtonStatusKey, @0, OBJC_ASSOCIATION_COPY);
        }

        
        
//        self.oldFrm = frame;
//        // Initialization code
//        self.logs = [NSMutableArray new];
//        self.logMax = 20;
//        
//        _consoleView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-28-10-5)];
//        _consoleView.font = [UIFont fontWithName:@"Courier-Bold" size:12];
//        _consoleView.textColor = [UIColor orangeColor];
//        _consoleView.backgroundColor = [UIColor clearColor];
//        _consoleView.indicatorStyle = 0;
//        _consoleView.editable = NO;
//        _consoleView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        [self setConsoleText];
//        [self addSubview:_consoleView];
//        
//        
//        _inputField = [[UITextField alloc] initWithFrame:CGRectMake(10,frame.size.height - 28 - 10 ,frame.size.width-20,28)];
//        _inputField.borderStyle = UITextBorderStyleRoundedRect;
//        _inputField.font = [UIFont fontWithName:@"Courier" size:12];
//        _inputField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//        _inputField.autocorrectionType = UITextAutocorrectionTypeNo;
//        _inputField.returnKeyType = UIReturnKeyDone;
//        _inputField.enablesReturnKeyAutomatically = NO;
//        _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _inputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        _inputField.placeholder = @"Enter help to see commands...";
//        _inputField.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
//        _inputField.delegate = self;
//        [self addSubview:_inputField];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardWillShow:)
//                                                     name:UIKeyboardWillShowNotification
//                                                   object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardWillHide:)
//                                                     name:UIKeyboardWillHideNotification
//                                                   object:nil];
        
        
    }
    return self;
}

- (void)buttonPressed:(UIButton *)button {
    switch (button.tag) {
        case 0://border
        {
            NSNumber *status = objc_getAssociatedObject(button, kButtonStatusKey);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            [self.parentViewController performSelector:@selector(showBorder:) withObject:status];
#pragma clang diagnostic pop
            if (status.integerValue == 0) {
                objc_setAssociatedObject(button, kButtonStatusKey, @1, OBJC_ASSOCIATION_COPY);
            } else {
                objc_setAssociatedObject(button, kButtonStatusKey, @0, OBJC_ASSOCIATION_COPY);
            }
            break;
        }
        case 1://business view's border and class name
        {
            NSNumber *status = objc_getAssociatedObject(button, kButtonStatusKey);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            [self.parentViewController performSelector:@selector(showBusinessViewBorder:) withObject:status];
#pragma clang diagnostic pop
            if (status.integerValue == 0) {
                objc_setAssociatedObject(button, kButtonStatusKey, @1, OBJC_ASSOCIATION_COPY);
            } else {
                objc_setAssociatedObject(button, kButtonStatusKey, @0, OBJC_ASSOCIATION_COPY);
            }
            break;
        }
        case 2://sandbox
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            [self.parentViewController performSelector:@selector(showSandBox) withObject:nil];
#pragma clang diagnostic pop
            break;
        case 3://grid
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            [self.parentViewController performSelector:@selector(showGrid) withObject:nil];
#pragma clang diagnostic pop
            break;
        case 4://exit
        {
            UIButton* btn = [UIButton new];
            btn.tag = 10;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            [self.parentViewController performSelector:@selector(onBtnClikced:) withObject:btn];
#pragma clang diagnostic pop
            break;
        }
        default:
            break;
    }
}

- (void)hideKeyboard
{
    [self.inputField  resignFirstResponder];
}

- (void)setConsoleText
{
    NSString *text = @"Let's Hack: See what you can do ?";
    text = [text stringByAppendingString:@"\n--------------------------------------\n"];
    text = [text stringByAppendingString:[[self.logs arrayByAddingObject:@">"] componentsJoinedByString:@"\n"]];
    _consoleView.text = text;
    
    [_consoleView scrollRangeToVisible:NSMakeRange(_consoleView.text.length, 0)];
}

- (void)keyboardWillShow:(NSNotification* )notification
{
    CGRect frame = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve = [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    [UIView animateWithDuration:duration delay:0.0 options:(UIViewAnimationOptions)curve animations:^{
        
        self.inputField.frame = CGRectMake(self.inputField.frame.origin.x, frame.origin.y - 28 - 10, self.inputField.frame.size.width , self.inputField.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillHide:(NSNotification* )notification
{
    CGFloat duration = [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve = [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    [UIView animateWithDuration:duration delay:0.0 options:(UIViewAnimationOptions)curve animations:^{
        
        self.inputField.frame = CGRectMake(10,self.frame.size.height - 28 - 10 ,300,28);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text isEqualToString:@""])
    {
        [self log:textField.text];
        
        [self handleEnterText:textField.text];
        textField.text = @"";
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (void)log:(NSString *)format, ...
{
    va_list argList;
    va_start(argList,format);
    
    NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
    
    [self.logs addObject:[@">> " stringByAppendingString:message]];
    if ([self.logs count] > self.logMax)
    {
        [self.logs removeObjectAtIndex:0];
    }
    [self setConsoleText];
    
    va_end(argList);
    
}

- (void)handleEnterText:(NSString* )text
{
    //noop;
    if ([text isEqualToString:@"exit"]) {
        
        UIButton* btn = [UIButton new];
        btn.tag = 10;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [self.parentViewController performSelector:@selector(onBtnClikced:) withObject:btn];
#pragma clang diagnostic pop
        
    }
    else if([text isEqualToString:@"version"])
    {
        //[self log:[TBCityGlobal version]];
    }
    else if ([text isEqualToString:@"grid"])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [self.parentViewController performSelector:@selector(showGrid) withObject:nil];
#pragma clang diagnostic pop
    
    }
    else if ([text isEqualToString:@"border"])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [self.parentViewController performSelector:@selector(showBorder) withObject:nil];
#pragma clang diagnostic pop
    }
    else if ([text isEqualToString:@"crash"])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [self.parentViewController performSelector:@selector(showCrashLogs) withObject:nil];
#pragma clang diagnostic pop
    }
    else if ([text isEqualToString:@"heap"])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [self.parentViewController performSelector:@selector(showHeap) withObject:nil];
#pragma clang diagnostic pop
    }
    else if ([text isEqualToString:@"sandbox"])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [self.parentViewController performSelector:@selector(showSandBox) withObject:nil];
#pragma clang diagnostic pop
    }
    else if ([text isEqualToString:@"mw on"])
    {
        [self.parentViewController setValue:@(YES) forKey:@"performMemoryWarning"];
        
    }
    else if ([text isEqualToString:@"mw off"])
    {
        [self.parentViewController setValue:@(NO) forKeyPath:@"performMemoryWarning"];
    }

    else if ([text isEqualToString:@"help"])
    {
        [self log:@"try:\n exit \n sandbox \n grid \n border \n crashes \n heap \n mw on \n mw off \n"];
        
    }
    else
    {
        [self log:@"try something else..."];
    }
}
@end