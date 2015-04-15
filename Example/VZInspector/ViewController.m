//
//  ViewController.m
//  VZInspector
//
//  Created by moxin.xt on 14-9-23.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "ViewController.h"
#import "VZHeapInspector.h"

@interface VZTestView : UIView
@end

@implementation VZTestView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}
@end

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView* tableView;
@property(nonatomic,strong) NSMutableArray* items;

@end

@implementation ViewController

- (UIView* )loadingFooterView
{
    UIView* v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds)-20)/2, 11, 20, 20)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [indicator startAnimating];
    [v addSubview:indicator];
   
    return v;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(load)];
    
    self.items = [NSMutableArray new];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self load];
    
    //fake
    VZTestView *testView = [[VZTestView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    [self.view addSubview:testView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"vzline"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"vzline"];
    }
    
    NSDictionary* info = self.items[indexPath.row];
    
    
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = info[@"text"];
    [cell.textLabel sizeToFit];
    
    return cell;

}

- (void)load
{
    [self.items removeAllObjects];
    [self.tableView reloadData];
    self.tableView.tableFooterView = [self loadingFooterView];
    
    NSString* url = @"https://api.app.net/stream/0/posts/stream/global";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VZRequestLog" object:nil userInfo:@{@"url":url}];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary* JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        for (NSDictionary* dict in JSON[@"data"]) {
            [self.items addObject:dict];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.tableView.tableFooterView = nil;
            [self.tableView reloadData];
            
            if (!error) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"VZResponseLog" object:nil userInfo:@{@"json":JSON}];
            }
            else{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"VZResponseLog" object:nil userInfo:@{@"error":error}];
            }
        });
        
    }] resume];
    
}


@end
