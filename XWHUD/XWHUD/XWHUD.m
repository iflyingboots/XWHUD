//
//  XWHUD.m
//  XWHUD
//
//  Created by Xin Wang on 11/27/16.
//  Copyright © 2016 Xin Wang. All rights reserved.
//

#define kDefaultSpinnerColor [UIColor whiteColor]
#define kDefaultHUDColor [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:.8]
#define kSuccessImage [UIImage imageNamed:@"XWHUD.bundle/hud-success"]
#define kErrorImage [UIImage imageNamed:@"XWHUD.bundle/hud-error"]
#define kDefaultMessageColor [UIColor whiteColor]

static const float kDefaultHUDWidthHeight = 80.f;
static const float kDefaultHUDCornerRadius = 10.f;

#import "XWHUD.h"

@interface XWHUD ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@end

@implementation XWHUD

+ (void)show
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self shared] destoryHUD];
        [[self shared] createWithMessage:nil image:nil timeout:0];
        [[self shared] showHUD];
    });
}

+ (void)showError
{
    [self showError:nil];
}

+ (void)showError:(NSString *)message
{
    [self showError:message timeout:0];
}

+ (void)showError:(NSString *)message timeout:(NSTimeInterval)timeout
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self shared] destoryHUD];
        [[self shared] createWithMessage:message image:kErrorImage timeout:timeout];
        [[self shared] showHUD];
    });
}

+ (void)showSuccess
{
    [self showSuccess:nil];
}

+ (void)showSuccess:(NSString *)message
{
    [self showSuccess:message timeout:0];
}

+ (void)showSuccess:(NSString *)message timeout:(NSTimeInterval)timeout
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self shared] destoryHUD];
        [[self shared] createWithMessage:message image:kSuccessImage timeout:timeout];
        [[self shared] showHUD];
    });
}

+ (void)hide
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self shared] hideHUD];
    });
}

#pragma mark - Private

- (instancetype)init
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.userInteractionEnabled = NO;
    }
    
    return self;
}

+ (instancetype)shared
{
    static dispatch_once_t onceToken;
    static XWHUD *instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)destoryHUD
{
    [self.hud removeFromSuperview];
    self.hud = nil;
}

- (void)createWithMessage:(NSString *)message image:(UIImage *)image timeout:(NSTimeInterval)timeout
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    CGRect centerItemFrame;
    if (image) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        // Use image to replace spinner
        imageView.frame = CGRectMake(0, 0, 30, 30);
        imageView.center = CGPointMake(self.hud.bounds.size.width/2, self.hud.bounds.size.height/2);
        centerItemFrame = imageView.frame;
        [self.hud addSubview:imageView];
    } else {
        self.spinner.center = CGPointMake(self.hud.bounds.size.width/2, self.hud.bounds.size.height/2);
        centerItemFrame = self.spinner.frame;
        [self.hud addSubview:self.spinner];
    }
    
    if (message) {
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        messageLabel.font = [UIFont systemFontOfSize:12.f];
        messageLabel.text = message;
        messageLabel.textColor = self.messageColor;
        messageLabel.frame = ({
            CGRect frame = messageLabel.frame;
            frame.size.width = self.hud.frame.size.width;
            frame.size.height = 20.f;
            frame.origin.x = 0;
            frame.origin.y = centerItemFrame.size.height + centerItemFrame.origin.y;
            frame;
        });
        NSDictionary *attributes = @{NSFontAttributeName: messageLabel.font};
        NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
        CGRect labelFrame = [messageLabel.text boundingRectWithSize:self.hud.frame.size options:options attributes:attributes context:nil];
        self.hud.frame = ({
            CGRect frame = self.hud.frame;
            frame.size.height += labelFrame.size.height / 2;
            frame;
        });
        [self.hud addSubview:messageLabel];
    }
    [self addSubview:self.hud];
    
    if (timeout > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideHUD];
        });
    }
}

- (void)showHUD
{
    self.hud.transform = CGAffineTransformScale(self.hud.transform, 1.2, 1.2);
    self.hud.alpha = 0;
    NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut;
    [UIView animateWithDuration:0.2 delay:0 options:options animations:^{
        self.hud.transform = CGAffineTransformScale(self.hud.transform, 0.7, 0.7);
        self.hud.alpha = 1;
    } completion:^(BOOL finished) {
        self.hud.transform = CGAffineTransformIdentity;
    }];
}

- (void)hideHUD
{
    self.hud.transform = CGAffineTransformScale(self.hud.transform, 1.2, 1.2);
    self.hud.alpha = 1;
    NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn;
    [self.spinner stopAnimating];
    [UIView animateWithDuration:0.2 delay:0 options:options animations:^{
        self.hud.transform = CGAffineTransformScale(self.hud.transform, 0.7, 0.7);
        self.hud.alpha = 0;
    } completion:^(BOOL finished) {
        self.hud.transform = CGAffineTransformIdentity;
        [self destoryHUD];
        [self removeFromSuperview];
    }];
}

#pragma mark - Getters

- (UIView *)hud
{
    if (!_hud) {
        _hud = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDefaultHUDWidthHeight, kDefaultHUDWidthHeight)];
        _hud.center = self.superview.center;
        _hud.backgroundColor = self.hudColor;
        _hud.layer.cornerRadius = kDefaultHUDCornerRadius;
        _hud.layer.masksToBounds = YES;
    }
    
    return _hud;
}

- (UIActivityIndicatorView *)spinner
{
    if (!_spinner) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _spinner.color = [UIColor whiteColor];
        _spinner.hidesWhenStopped = YES;
        [_spinner startAnimating];
    }
    
    return _spinner;
}

- (UIColor *)spinnerColor
{
    return _spinnerColor ?: kDefaultSpinnerColor;
}

- (UIColor *)hudColor
{
    return _hudColor ?: kDefaultHUDColor;
}

- (UIColor *)messageColor
{
    return _messageColor ?: kDefaultMessageColor;
}

@end
