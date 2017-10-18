//
//  FtScrollTextView.h
//  走马灯效果
//
//  Created by 程建良 on 2016/12/22.
//  Copyright © 2016年 JosePh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FtScrollTextView : UIView

@property (nonatomic,copy)NSString *text;

@property (nonatomic,assign)NSTimeInterval speed;

@property (nonatomic,strong)UIColor *textColor;

@property (nonatomic,strong)UIFont *textFont;

@property (nonatomic,assign)CGFloat  spacing;

-(void)timerInvalidate;

@end
