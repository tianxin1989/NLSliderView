//
//  NLSliderView.h
//  NLSliderView
//
//  Created by 秦田新 on 2018/9/19.
//  Copyright © 2018年 悟空. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NLSliderType) {
    NLSliderTypeLeft = 0, //默认从左开始滑动
    NLSliderTypeMiddle = 1 //从中间向两边滑动
};


@class NLSliderView;

@protocol NLSliderViewDelegate <NSObject>

@optional

- (void)sliderView:(NLSliderView *)sliderView sliderpPrcentDidChange:(CGFloat)newPercent;
@end

@interface NLSliderView : UIView

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, weak) id <NLSliderViewDelegate> delegate;

/** */
@property (nonatomic, assign) NLSliderType sliderType;


@end
