//
//  BulletManager.h
//  BulletView-master
//
//  Created by 黄海燕 on 16/8/1.
//  Copyright © 2016年 huanghy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BulletView;
@interface BulletManager : NSObject

@property (nonatomic,copy) void (^generateViewBlock)(BulletView *view);
- (void)start;
- (void)stop;

@end
