//
//  App.h
//  MoreImagesDownloaded_Multithreading
//
//  Created by  江苏 on 16/5/7.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface App : NSObject

@property(copy,nonatomic)NSString* name;

@property(copy,nonatomic)NSString* icon;

@property(copy,nonatomic)NSString* download;

+(NSArray*)apps;

@end
