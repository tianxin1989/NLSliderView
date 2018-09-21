//
//  NLSliderView.m
//  NLSliderView
//
//  Created by 秦田新 on 2018/9/19.
//  Copyright © 2018年 悟空. All rights reserved.
//
#define RGBCOLOR(r, g, b)  [UIColor colorWithRed:r/256.f green:g/256.f blue:b/256.f alpha:1.f]
#define DEFAULTGAP 3   //模块的中间留白
#define SLIDERWIDTH 24   //模块的大小

#import "NLSliderView.h"
#import <Masonry.h>

@interface NLSliderView ()

@property (nonatomic, strong) UIColor *processColor;
@property (nonatomic, weak) UIView *processView;
@property (nonatomic,assign) CGFloat lineHight;
@property (nonatomic, weak) UIImageView *sliderImage;
@property (nonatomic, weak) UIImageView *startImage;
@end

@implementation NLSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initProcessView];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
         [self initProcessView];
    }
    return self;
}

- (void)initProcessView {
    self.processColor = RGBCOLOR(26, 179, 148);
    self.lineHight = 2;
    UIView *borderView = [[UIView alloc]init];
    borderView.backgroundColor = RGBCOLOR(238, 238, 238);
    [self addSubview:borderView];
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.height.mas_equalTo(self.lineHight);
        make.centerY.equalTo(self);
    }];
    
    //进度
    UIView *processView = [[UIView alloc] init];
    processView.backgroundColor = self.processColor;
    [self addSubview:processView];
    self.processView = processView;
    
    UIImageView *startImage = [[UIImageView alloc]init];
    startImage.image = [UIImage imageNamed:@"slider_start"];
    [self addSubview:startImage];
    self.startImage = startImage;
    
    UIImageView *sliderImage = [[UIImageView alloc]init];
    sliderImage.image = [UIImage imageNamed:@"slider_sliding"];
    sliderImage.userInteractionEnabled = YES;
    UIPanGestureRecognizer *tapGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sliderImageTap:)];
    tapGesture.maximumNumberOfTouches = 1;
    [sliderImage addGestureRecognizer:tapGesture];
    [self addSubview:sliderImage];
    self.sliderImage = sliderImage;
    
    [startImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(6);
        make.width.mas_equalTo(6);
        make.centerY.equalTo(self);
        make.leading.equalTo(self.mas_leading);
    }];

    [sliderImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(SLIDERWIDTH);
        make.width.mas_equalTo(SLIDERWIDTH);
        make.centerY.equalTo(self);
        make.leading.equalTo(self.mas_leading).offset(-DEFAULTGAP);
    }];

    [processView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.lineHight);
            make.leading.equalTo(self);
            make.centerY.equalTo(self);
            make.trailing.mas_equalTo(self.mas_leading);
    }];
}


- (void)sliderImageTap:(UIPanGestureRecognizer *)pan {
    CGPoint tapPoint = [pan locationInView:self];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:

            break;
        case UIGestureRecognizerStateChanged:{
            CGFloat width = self.bounds.size.width;
            CGFloat offsetX = tapPoint.x;
            if (offsetX < 0 || offsetX > width) { return; }
            if (_sliderType == NLSliderTypeLeft) { //左滑类型
                if (offsetX < DEFAULTGAP) {//小于间距
                    [self.sliderImage mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.leading.equalTo(self.mas_leading).offset(-DEFAULTGAP);
                    }];
                }else if (offsetX + SLIDERWIDTH < width){
                    [self.sliderImage mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.leading.equalTo(self.mas_leading).offset(offsetX-SLIDERWIDTH/2);
                    }];
                }else{
                    [self.sliderImage mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.leading.equalTo(self.mas_leading).offset(width - SLIDERWIDTH + DEFAULTGAP);
                    }];
                }
                [self.processView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.trailing.mas_equalTo(self.mas_leading).offset(offsetX);
                }];
            }else{//中间向两边滑
                if (offsetX < width/2 ) {//向左滑
                    [self.processView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.trailing.equalTo(self.mas_leading).offset(width/2);
                        make.leading.equalTo(self.mas_leading).offset(offsetX);
                    }];
                    CGFloat sliderOffset = offsetX < DEFAULTGAP ? -DEFAULTGAP : offsetX - SLIDERWIDTH/2;
                    [self.sliderImage mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.leading.equalTo(self.mas_leading).offset(sliderOffset);
                    }];
                }else{// 向右滑
                    [self.processView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.leading.equalTo(self.mas_leading).offset(width/2);
                        make.trailing.equalTo(self.mas_leading).offset(offsetX);
                    }];
                    CGFloat sliderOffset = offsetX + SLIDERWIDTH/2 > width ? width - SLIDERWIDTH +  DEFAULTGAP: offsetX - SLIDERWIDTH/2;
                    [self.sliderImage mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.leading.equalTo(self.mas_leading).offset(sliderOffset);
                    }];
                }
            }
           
            [self sliderPrcentDidChangeWithOffsetX:offsetX];
        }
            break;
        case UIGestureRecognizerStateEnded:
            break;
        case UIGestureRecognizerStateCancelled:
            break;
            
        default:
            break;
    }
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    CGFloat  width =  self.bounds.size.width;
    CGFloat offsetX = progress * width;
    if (offsetX < DEFAULTGAP) {//小于间距
        [self.sliderImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading).offset(-DEFAULTGAP);
        }];
    }else if (offsetX + SLIDERWIDTH < width){
        [self.sliderImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading).offset(offsetX-SLIDERWIDTH/2);
        }];
    }else{
        [self.sliderImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading).offset(width - SLIDERWIDTH + DEFAULTGAP);
        }];
    }
    switch (_sliderType) {
        case NLSliderTypeLeft:{
            [self.processView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(self.mas_leading).offset(offsetX);
            }];
        }
            break;
            
        case NLSliderTypeMiddle:{
            if (progress < 0.5) {
                [self.processView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.trailing.equalTo(self.mas_leading).offset(width/2);
                    make.leading.equalTo(self.mas_leading).offset(offsetX);
                }];
            }else{
                [self.processView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(self.mas_leading).offset(width/2);
                    make.trailing.equalTo(self.mas_leading).offset(offsetX);
                }];
            }
        }
            break;
        default:
            break;
    }
}

- (void)sliderPrcentDidChangeWithOffsetX:(CGFloat)offsetX {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderView:sliderpPrcentDidChange:)]) {
        CGFloat precent = offsetX > self.bounds.size.width ? 1.0 : offsetX/self.bounds.size.width;
        [self.delegate sliderView:self sliderpPrcentDidChange:precent];
    }
}

- (void)setSliderType:(NLSliderType)sliderType {
    _sliderType = sliderType;
    CGFloat  width =  self.bounds.size.width;
    if (sliderType == NLSliderTypeMiddle && _progress == 0) {//如果是从中间开始滑,默认比例为0.5
        _progress = 0.5;
    }
    CGFloat offsetX = _progress * width;
    
    if (offsetX < DEFAULTGAP) {//小于间距
        [self.sliderImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading).offset(-DEFAULTGAP);
        }];
    }else if (offsetX + SLIDERWIDTH < width){
        [self.sliderImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading).offset(offsetX-SLIDERWIDTH/2);
        }];
    }else{
        [self.sliderImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading).offset(width - SLIDERWIDTH + DEFAULTGAP);
        }];
    }
    switch (sliderType) {
        case NLSliderTypeLeft:{
            [self.startImage mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.mas_leading);
            }];
            [self.processView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(self.mas_leading).offset(offsetX);
            }];
        }
            break;
        case NLSliderTypeMiddle:{
            [self.startImage mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.mas_leading).offset(width/2 - 3);
            }];

            if (_progress < 0.5) {
                [self.processView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.trailing.equalTo(self.mas_leading).offset(width/2);
                    make.leading.equalTo(self.mas_leading).offset(offsetX);
                }];
            }else{
                [self.processView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(self.mas_leading).offset(width/2);
                    make.trailing.equalTo(self.mas_leading).offset(offsetX);
                }];
            }

        }
            break;

        default:
            break;
    }
}



@end
