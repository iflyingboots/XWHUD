//
//  XWHUD.h
//  XWHUD
//
//  Created by Xin Wang on 11/27/16.
//  Copyright © 2016 Xin Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWHUD : UIView

@property (nonatomic, strong) UIView *hud;
@property (nonatomic, strong) UIColor *spinnerColor;
@property (nonatomic, strong) UIColor *hudColor;
@property (nonatomic, strong) UIColor *messageColor;

+ (void)show;
+ (void)hide;
+ (void)showError;
+ (void)showError:(NSString *)message;
+ (void)showError:(NSString *)message timeout:(NSTimeInterval)timeout;

+ (void)showSuccess;
+ (void)showSuccess:(NSString *)message;
+ (void)showSuccess:(NSString *)message timeout:(NSTimeInterval)timeout;;

@end
