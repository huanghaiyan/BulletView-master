//
//  ViewController.m
//  BulletView-master
//
//  Created by 黄海燕 on 16/8/1.
//  Copyright © 2016年 huanghy. All rights reserved.
//

#import "ViewController.h"
#import "BulletView.h"
#import "BulletManager.h"
@interface ViewController ()
@property (nonatomic,strong) BulletManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.manager = [[BulletManager alloc]init];
    __weak typeof (self) myself = self;
    self.manager.generateViewBlock = ^(BulletView *view){
        [myself addBulletView:view];
    };
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [startBtn setTitle:@"start" forState:UIControlStateNormal];
    startBtn.frame = CGRectMake(100, 100, 100, 45);
    [startBtn addTarget:self action:@selector(clickStartBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [stopBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [stopBtn setTitle:@"stop" forState:UIControlStateNormal];
    stopBtn.frame = CGRectMake(200, 100, 100, 45);
    [stopBtn addTarget:self action:@selector(clickStopBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
}

- (void)clickStartBtn
{
    [self.manager start];
}

- (void)clickStopBtn{
    [self.manager stop];
}

- (void)addBulletView:(BulletView *)view
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(width, 300+view.trajectory*40, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
    [view startAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
