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
        
        NSLog(@"已经有了图片，从缓存中直接加载");
        
    }else{
        
        //得到沙盒下Caches文件夹路径
        NSString* cachesPath=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        //得到图片文件名
        NSString* fileName=[app.icon lastPathComponent];
        //得到图片文件的全路径
        NSString* imagePath=[cachesPath stringByAppendingPathComponent:fileName];
        //加载该文件数据
        NSData* data=[NSData dataWithContentsOfFile:imagePath];
        
        //判断沙盒中是否存在文件
        if (data) {
            
            //如果沙盒中存在，直接加载
            UIImage* image=[UIImage imageWithData:data];
            
            cell.imageView.image=image;
            
            self.appCaches[app.icon]=image;
            
            NSLog(@"已经有了图片，从沙盒中直接加载");
            
        }else{
           
            //如果沙盒中不存在，则下载完成，加载之后，写入沙盒中
            NSString *imageUrl=app.icon;
            
            NSURL* url=[NSURL URLWithString:imageUrl];
            
            NSData* data=[NSData dataWithContentsOfURL:url];
            
            UIImage* image=[UIImage imageWithData:data];
            
            cell.imageView.image=image;
            
            self.appCaches[app.icon]=image;
            
            [data writeToFile:imagePath atomically:YES];
            
            NSLog(@"%@",imagePath);
            
            NSLog(@"没有图片，下载完成再加载");
        }
        
        
        
    }
    
    return cell;
}

@end
