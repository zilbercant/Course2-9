//
//  SecondViewController.m
//  Lesson10
//
//  Created by Azat Almeev on 05.11.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()
@property (nonatomic, copy) void(^someBlock)();
@property (nonatomic, strong) NSNumber *num;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) self_ = self;
    self.someBlock = ^{
        NSLog(@"%@", self_.num);
    };
    self.num = @2;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.someBlock();
}

- (void)dealloc {
    NSLog(@"Dealloc");
}

@end
