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

@property (nonatomic, assign) BOOL audoChangeNavBarHidden;

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
                        [UIColor whiteColor],
                        [UIColor lightGrayColor],
                        ];
    UIColor *bkgColor = colors[arc4random()%colors.count];
    
    while ([bkgColor isEqual:lastColor]) {
        bkgColor = colors[arc4random()%colors.count];
    }
    self.view.backgroundColor = bkgColor;
    
    //测试1套
    [self.view addSubview:self.imageView];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressed)];
    [self.imageView addGestureRecognizer:gesture];
    self.title = ([self.navigationController.viewControllers indexOfObject:self]%2==0)?@"1张照片":@"LIKESTYLE";
    
    //自定义返回按钮，懒得找图了，
    //PS：题外话，其实只是为了设置自定义返回按钮不建议使用leftBarButtonItem的方式。使用appearance方式也可很好的达成效果。
    //但是如果需要使用中间拖返模式就需要用此库了。
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    return;
    
    
    //测试2套-------------------------------------------
    //测试切换nav的隐藏后效果
    self.audoChangeNavBarHidden = YES;
    
    [self.view addSubview:self.button];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    
    //测试自定义头部内容
    UILabel *label = [[UILabel alloc]init];
    label.text = @"ML_VC";
    [label sizeToFit];
    label.backgroundColor = [UIColor yellowColor];
    self.navigationItem.titleView = label;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.audoChangeNavBarHidden) {
        [[self navigationController] setNavigationBarHidden:[self.navigationController.viewControllers indexOfObject:self]%2==0 animated:animated];
    }
}

- (BOOL)hidesBottomBarWhenPushed {
    return [[self.navigationController.viewControllers firstObject] isEqual:self]?NO:[self.navigationController.visibleViewController isEqual:self];
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
            imageView.image = [UIImage imageNamed:@"IMG_2079.jpg"];
        }else{
            imageView.image = [UIImage imageNamed:@"IMG_2078.jpg"];
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

@end
