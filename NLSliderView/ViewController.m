//
//  ViewController.m
//  NLSliderView
//
//  Created by 秦田新 on 2018/9/19.
//  Copyright © 2018年 悟空. All rights reserved.
//

#import "ViewController.h"
#import "NLSliderView.h"
#import <Masonry.h>

@interface ViewController ()<NLSliderViewDelegate>

@property (weak, nonatomic) IBOutlet NLSliderView *lineProgressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    self.lineProgressView.progress = 0.5;
    self.lineProgressView.delegate = self;
    
    NLSliderView *line = [[NLSliderView alloc]initWithFrame:CGRectMake(10, 200, 300, 30)];
    line.delegate = self;
    [self.view addSubview:line];
    [line setSliderType:NLSliderTypeMiddle];
     line.progress = 0.75;

   // line.progress = 0.75;
  
}

- (void)sliderView:(NLSliderView *)sliderView sliderpPrcentDidChange:(CGFloat)newPercent {
    NSLog(@"newPercentnewPercent = %.2f",newPercent);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
