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

@property(strong,nonatomic)NSOperationQueue* queue;

@property(strong,nonatomic)NSMutableDictionary* operations;

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

-(NSOperationQueue *)queue
{
    if (_queue==nil) {
        _queue=[[NSOperationQueue alloc]init];
    }
    return _queue;
}

-(NSMutableDictionary *)operations
{
    if (_operations==nil) {
        _operations=[NSMutableDictionary dictionary];
    }
    return _operations;
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
            
            //存入缓存字典中
            self.appCaches[app.icon]=image;
            
        }else{
           //需要下载前显示占位图片
            cell.imageView.image=[UIImage imageNamed:@"imageHolder"];
            
            NSOperation* operation=self.operations[app.icon];
            
            //如果线程队列中没有该线程，则重新创建并加入，再下载
            if (operation==nil) {
               
                //如果沙盒中不存在，则下载完成，加载之后，写入沙盒中
                NSString *imageUrl=app.icon;
                
                NSURL* url=[NSURL URLWithString:imageUrl];
                
                //给线程队列添加事件，开启子线程
                operation=[NSBlockOperation blockOperationWithBlock:^{
                    
                    NSData* data=[NSData dataWithContentsOfURL:url];
                    
                    //如果数据下载失败，删除线程队列中的该任务并跳出当前方法，防止程序崩溃
                    if (data==nil) {
                        
                        [self.operations removeObjectForKey:app.icon];
                        
                        return;
                    }
                    
                    UIImage* image=[UIImage imageWithData:data];
                    
                    //假设下载文件很大，需要1s的时间
                    [NSThread sleepForTimeInterval:1.0];
                    
                    //存入缓存字典中
                    self.appCaches[app.icon]=image;
                    
                    //回主线程更新界面（刷新当前行）
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        
                    }];
                    
                    //将下载好的数据写入沙盒中
                    [data writeToFile:imagePath atomically:YES];
                    //移除操作
                    [self.operations removeObjectForKey:app.icon];
                    
                }];
                
                //加入任务队列开始下载
                [self.queue addOperation:operation];
                //加入线程队列，记住该任务的状态
                self.operations[app.icon]=operation;
            }
        }
        
    }
    
    return cell;
}

@end
