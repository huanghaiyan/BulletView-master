//
//  BulletManager.m
//  BulletView-master
//
//  Created by 黄海燕 on 16/8/1.
//  Copyright © 2016年 huanghy. All rights reserved.
//

#import "BulletManager.h"
#import "BulletView.h"

@interface BulletManager ()
//弹道的数据来源
@property (nonatomic,strong) NSMutableArray *dataSource;
//弹道使用过程中的数组变量
@property (nonatomic,strong) NSMutableArray *bulletComments;
//存储弹幕view的数组变量
@property (nonatomic,strong) NSMutableArray *bulletViews;

@property (nonatomic,assign) BOOL bStopAnimation;
@end

@implementation BulletManager

- (instancetype)init
{
    if (self = [super init]) {
        self.bStopAnimation = YES;
    }
    return self;
}

- (void)start
{
    if (!self.bStopAnimation) {
        return;
    }
    self.bStopAnimation = NO;
    [self.bulletComments removeAllObjects];
    [self.bulletComments addObjectsFromArray:self.dataSource];
    [self initBulletComment];
}

- (void)stop
{
    if (self.bStopAnimation) {
        return;
    }
    self.bStopAnimation = YES;
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletView *view = obj;
        [view stopAnimation];
        view = nil;
    }];
    [self.bulletViews removeAllObjects];
}

//初始化弹幕，随机分配弹幕轨迹
- (void)initBulletComment
{
    NSMutableArray *trajectorys = [NSMutableArray arrayWithArray:@[@(0),@(1),@(2)]];
    for (int i = 0; i<3; i++) {
        if (self.bulletComments.count > 0) {
            //通过随机数获取到弹幕的轨迹
            NSInteger index = arc4random()%trajectorys.count;
            int trajectory = [[trajectorys objectAtIndex:index] intValue];
            [trajectorys removeObjectAtIndex:index];
            
            //从弹道数组中逐一取出弹幕数据
            NSString *comment = [self.bulletComments firstObject];
            [self.bulletComments removeObjectAtIndex:0];
            //创建弹幕view
            [self createBulletView:comment trajectory:trajectory];
        }
    }
}


- (void)createBulletView:(NSString *)comment trajectory:(int)trajectory
{
    if (self.bStopAnimation) {
        return;
    }
    BulletView *bulletView = [[BulletView alloc]initWithComment:comment];

    bulletView.trajectory = trajectory;
    [self.bulletViews addObject:bulletView];
    
    __weak typeof (bulletView) weakView = bulletView;
    __weak typeof (self) myself = self;
    bulletView.moveStatusBlock = ^(MoveStatus status){
        if (self.bStopAnimation) {
            return ;
        }
        switch (status) {
            case Start:{
                //弹幕开始进入屏幕，将view加入弹幕管理的变量中bulletViews
                [myself.bulletViews addObject:weakView];
                break;
            }
            case Enter:{
                //弹幕完全进入屏幕，判断是否还有其他内容，如果有则在该弹幕轨迹中创建一个弹幕
                NSString *comment = [myself nextComment];
                if (comment) {
                    [myself createBulletView:comment trajectory:trajectory];
                }
                break;
            }
            case End:{
                //弹幕完全飞出屏幕后，从BulletViews中删除，释放资源
                if ([myself.bulletViews containsObject:weakView]) {
                    [weakView stopAnimation];
                    [myself.bulletViews removeObject:weakView];
                }
                if (myself.bulletViews.count == 0) {
                    //说明屏幕上已经没有弹幕，开始循环滚动
                    self.bStopAnimation = YES;
                    [myself start];
                }
                break;
            }
            default:
                break;
        }
    };
    
    if (self.generateViewBlock) {
        self.generateViewBlock(bulletView);
    }
}

- (NSString *)nextComment
{
    if (self.bulletComments.count == 0) {
        return nil;
    }
    NSString *comment = [self.bulletComments firstObject];
    if (comment) {
        [self.bulletComments removeObjectAtIndex:0];
    }
    return comment;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithArray:@[@"弹幕1---",
                                                       @"弹幕2~~~~",
                                                       @"弹幕3————————————————",
                                                       @"弹幕4",
                                                       @"弹幕5~~~~~~~~~",
                                                       @"弹幕6---",
                                                       @"弹幕7~~~~",
                                                       @"弹幕8————————————————",
                                                       @"弹幕9",
                                                       @"弹幕10~~~~~~~~~",
                                                       @"弹幕11",
                                                       @"弹幕12~~~~~~~~~"]];
    }
    return _dataSource;
}

- (NSMutableArray *)bulletComments
{
    if (!_bulletComments) {
        _bulletComments = [NSMutableArray array];
    }
    return _bulletComments;
}

- (NSMutableArray *)bulletViews
{
    if (!_bulletViews) {
        _bulletViews = [NSMutableArray array];
    }
    return _bulletViews;
}

@end
