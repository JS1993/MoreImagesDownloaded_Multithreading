//
//  ViewController.m
//  MoreImagesDownloaded_Multithreading
//
//  Created by  江苏 on 16/5/7.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import "ViewController.h"
#import "App.h"

@interface ViewController ()

@property(strong,nonatomic)NSArray* apps;

@property(strong,nonatomic)NSMutableDictionary* appCaches;

@end

@implementation ViewController

-(NSMutableDictionary *)appCaches
{
    if (_appCaches==nil) {
        _appCaches=[NSMutableDictionary dictionary];
    }
    return _appCaches;
}

-(NSArray *)apps{
    if (_apps==nil) {
        _apps=[App apps];
    }
    return _apps;
}


- (void)viewDidLoad {
    [super viewDidLoad];
 
}

#pragma mark--tableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.apps.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identifier=@"cell";
    
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.textLabel.text=[self.apps[indexPath.row] name];
    
    cell.detailTextLabel.text=[self.apps[indexPath.row] download];
    
    NSString *imageUrl=(NSString*)[self.apps[indexPath.row] icon];
    
    NSURL* url=[NSURL URLWithString:imageUrl];
    
    NSData*
    
    
    return cell;
}

@end
