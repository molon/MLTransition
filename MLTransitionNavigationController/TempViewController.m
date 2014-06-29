//
//  TempViewController.m
//  MLTransitionNavigationController
//
//  Created by molon on 6/28/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "TempViewController.h"

@interface TempViewController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;

@property (nonatomic, assign) BOOL hideStatusBar;
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
                        [UIColor colorWithRed:0.221 green:0.437 blue:0.510 alpha:1.000],
                        [UIColor colorWithRed:0.654 green:0.656 blue:0.487 alpha:1.000],
                        ];
    UIColor *bkgColor = colors[arc4random()%colors.count];

    while ([bkgColor isEqual:lastColor]) {
        bkgColor = colors[arc4random()%colors.count];
    }
    self.view.backgroundColor = bkgColor;
    
//测试1套
    self.hideStatusBar = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBarHidden = YES;
    [self.view addSubview:self.imageView];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressed)];
    [self.imageView addGestureRecognizer:gesture];
    return;
    

//测试2套
    [self.view addSubview:self.button];
    
    //测试自定义头部内容
    UILabel *label = [[UILabel alloc]init];
    label.text = @"ML_VC";
    [label sizeToFit];
    label.backgroundColor = [UIColor yellowColor];
    self.navigationItem.titleView = label;
    
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

- (UIImageView *)imageView
{
    if (!_imageView) {
		UIImageView *imageView = [[UIImageView alloc]init];
        if ([self.navigationController.viewControllers indexOfObject:self]%2==0) {
            imageView.image = [UIImage imageNamed:@"IMG_0767.PNG"];
        }else{
            imageView.image = [UIImage imageNamed:@"IMG_0768.PNG"];
        }
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        
        _imageView = imageView;
    }
    return _imageView;
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.button.frame = CGRectMake(0, 0, 100, 40);
    self.button.center = self.view.center;
    
    self.imageView.frame = self.view.bounds;
}

- (BOOL)prefersStatusBarHidden
{
    return self.hideStatusBar;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

@end
