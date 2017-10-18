//
//  FtScrollTextView.m
//  走马灯效果
//
//  Created by 程建良 on 2016/12/22.
//  Copyright © 2016年 JosePh. All rights reserved.
//

#import "FtScrollTextView.h"
#import "FtSrollLabel.h"
@interface FtScrollTextView ()

@property (nonatomic,strong)NSTimer *timer;

@end

@implementation FtScrollTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initText];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _initText];
    }
    return self;
}

- (void)_initText{
    self.clipsToBounds = YES;
    self.speed = 0.03;
    self.textFont = [UIFont systemFontOfSize:15.f];
    self.spacing = 30.0;
    self.textColor = [UIColor blackColor];
}

-(void)setTextColor:(UIColor *)textColor{
    if (_textColor != textColor) {
        _textColor = textColor;
        [self setNeedsLayout];
    }

}
- (void)setText:(NSString *)text{
    if (![_text isEqualToString:text]) {
        _text = text;
        [self setNeedsLayout];
    }
}

- (void)setTextFont:(UIFont *)textFont{
    if (_textFont != textFont) {
        _textFont = textFont;
        [self setNeedsLayout];
    }
}
-(void)setSpeed:(NSTimeInterval)speed{
    if (_speed != speed) {
        _speed = speed;
        [self setNeedsLayout];
    }
}
-(void)setSpacing:(CGFloat)spacing{
    if (_spacing != spacing) {
        _spacing = spacing;
        [self setNeedsLayout];
    }
}

#pragma mark -

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self _updateScrollTextView];
    
}

- (void)_updateScrollTextView
{
    for (int i = 0; i < self.subviews.count; i++) {
        UIView * view = [self.subviews objectAtIndex:i];
        [view removeFromSuperview];
        view = nil;
    }
    CGSize size = [_text sizeWithAttributes:@{NSFontAttributeName: self.textFont}];
    NSInteger width = size.width + 1;
    size = CGSizeMake(width, size.height);
    [self beginScrollWith:size];
}

-(void)beginScrollWith:(CGSize)size{
    if (self.frame.size.width >= size.width) {
        [self createTextLabelWithSize:size];
    }else{
        [self startAnimationWithSize:size];
    }
    
}
-(void)startAnimationWithSize:(CGSize)size{
    [self createTextLabelWithSize:size andTag:1];
    [self createTextLabelWithSize:size andTag:2];
    CGFloat width = self.frame.size.width;
    CGFloat y = (self.frame.size.height -size.height)/2.0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:_speed repeats:YES block:^(NSTimer * _Nonnull timer) {
        for (id view in self.subviews) {
            if ([view isKindOfClass:[FtSrollLabel class]]) {
                FtSrollLabel *label = (FtSrollLabel *)view;
            
                if (label.frame.origin.x >= -(size.width + _spacing-width) && label.frame.origin.x < width) {
                    label.frame = CGRectMake(label.frame.origin.x -1, y, size.width, size.height);
                    label.isMove = YES;
                }else if (label.frame.origin.x <= -size.width) {
                    label.frame = CGRectMake(width, y, size.width, size.height);
                }else if( label.frame.origin.x>-size.width&& label.frame.origin.x < -(size.width + _spacing-width)){
                    for (id view in self.subviews) {
                        if ([view isKindOfClass:[FtSrollLabel class]]) {
                            FtSrollLabel *label = (FtSrollLabel *)view;
                            if (label.isMove) {
                                label.isMove = NO;
                            }else{
                                label.frame = CGRectMake(label.frame.origin.x -1, y, size.width, size.height);
                            }
                       }
                    }
                }
            }
        }
    }];
}
-(void)createTextLabelWithSize:(CGSize)size{
    [self createTextLabelWithSize:size andTag:0];
}
-(void)createTextLabelWithSize:(CGSize)size andTag:(int)tag{
    FtSrollLabel *textLabel = [[FtSrollLabel alloc]initWithFrame:CGRectMake(0, (self.frame.size.height -size.height)/2.0, size.width, size.height)];
    textLabel.text = self.text;
    if (size.width <=  self.frame.size.width) {
        textLabel.frame = CGRectMake((self.frame.size.width - size.width)/2.0, (self.frame.size.height -size.height)/2.0, size.width, size.height);
        textLabel.textAlignment = NSTextAlignmentCenter;
    }else{
        textLabel.textAlignment = NSTextAlignmentLeft;
    }
    textLabel.textColor = self.textColor;
    textLabel.font = self.textFont;
    textLabel.tag = tag;
    textLabel.backgroundColor = [UIColor clearColor];
    if (textLabel.tag == 2) {
        textLabel.frame = CGRectMake(self.frame.size.width, (self.frame.size.height -size.height)/2.0, size.width, size.height);
    }
    [self addSubview:textLabel];
}
-(void)dealloc{
    [self timerInvalidate];
}
-(void)timerInvalidate{
    [self.timer invalidate];
    self.timer = nil;
}

@end
