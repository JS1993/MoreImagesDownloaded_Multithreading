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
    
    App* app=self.apps[indexPath.row];
    
    cell.textLabel.text=app.name;
    
    cell.detailTextLabel.text=app.download;
    
    UIImage* image=self.appCaches[app.icon];
    
    if (image) {
       
        cell.imageView.image=image;
        
        NSLog(@"已经有了图片，直接加载");
        
    }else{
        
        NSString *imageUrl=app.icon;
        
        NSURL* url=[NSURL URLWithString:imageUrl];
        
        NSData* data=[NSData dataWithContentsOfURL:url];
        
        image=[UIImage imageWithData:data];
        
        cell.imageView.image=image;
        
        self.appCaches[app.icon]=image;
        
        NSLog(@"没有图片，下载完成再加载");
        
    }
    
    return cell;
}

@end
