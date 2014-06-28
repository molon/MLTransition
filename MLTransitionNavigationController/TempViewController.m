//
//  TempViewController.m
//  MLTransitionNavigationController
//
//  Created by molon on 6/28/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "TempViewController.h"
#import "MLTransitionFromRightToLeft.h"
#import "MLTransitionFromLeftToRight.h"

@interface TempViewController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;

@end

@implementation TempViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUInteger lastIndex = [self.navigationController.viewControllers indexOfObject:self]-1;
    UIColor *lastColor = nil;
    if (lastIndex<self.navigationController.viewControllers.count) {
        lastColor = ((UIViewController*)self.navigationController.viewControllers[lastIndex]).view.backgroundColor;
    }
    
    NSArray *colors = @[
                        [UIColor colorWithRed:0.004 green:0.656 blue:0.014 alpha:1.000],
                        [UIColor colorWithRed:0.698 green:0.587 blue:0.170 alpha:1.000],
                        [UIColor colorWithRed:0.132 green:0.588 blue:0.656 alpha:1.000],
                        [UIColor colorWithRed:0.656 green:0.253 blue:0.621 alpha:1.000],
                        [UIColor colorWithRed:0.265 green:0.303 blue:0.656 alpha:1.000],
                        ];
    UIColor *bkgColor = colors[arc4random()%colors.count];

    while ([bkgColor isEqual:lastColor]) {
        bkgColor = colors[arc4random()%colors.count];
    }
    self.view.backgroundColor = bkgColor;
    [self.view addSubview:self.button];
    
    self.title = @"ML_VC";
    
    //测试自定义返回按钮会不会影响拖返。PS:默认系统的是会影响的
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
}

- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pressed
{
    TempViewController *vc = [[TempViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (UIButton *)button
{
    if (!_button) {
		UIButton *button = [[UIButton alloc]init];
		[button setTitle:@"按下" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:0.181 green:0.500 blue:0.097 alpha:1.000];
        [button addTarget:self action:@selector(pressed) forControlEvents:UIControlEventTouchUpInside];
        
        
        _button = button;
    }
    return _button;
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.button.frame = CGRectMake(0, 0, 100, 40);
    self.button.center = self.view.center;
}

@end
