//
//  FindPassowrdViewController.m
//  CareD
//
//  Created by LakesMac on 15/11/20.
//  Copyright © 2015年 Tec-Erica. All rights reserved.
//

#import "FindPassowrdViewController.h"
#import "TimerManagerForEmail.h"

@interface FindPassowrdViewController ()
{
    BOOL _isVerified;
}

@property (nonatomic,strong) UIView *mainContentView;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UILabel *timerLabel;
@end

@implementation FindPassowrdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(backVC)];
    
    NSNumber *number = [AVUser currentUser][@"emailVerified"];
    BOOL isVerified = number.boolValue;
    _isVerified = isVerified;
    
    self.mainContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CareD_Lake_MainScreenBounds.size.width * 0.618, 40)];
    self.mainContentView.center = CGPointMake(CareD_Lake_MainScreenBounds.size.width / 2, 60);
    self.mainContentView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.mainContentView.layer.shadowOffset = CGSizeMake(0, -1);
    self.mainContentView.layer.shadowOpacity = 0.7;
    self.mainContentView.layer.cornerRadius = 10;
    self.mainContentView.layer.borderColor = [UIColor blackColor].CGColor;
    self.mainContentView.layer.masksToBounds = YES;
    self.mainContentView.layer.borderWidth = 1;
    [self.view addSubview:self.mainContentView];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(8, 0, self.mainContentView.frame.size.width * 0.618, self.mainContentView.frame.size.height)];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.placeholder = @"注册时的邮箱";
    self.textField.adjustsFontSizeToFitWidth = YES;
    [self.mainContentView addSubview:self.textField];
    
    self.button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.button.frame = CGRectMake(self.textField.frame.origin.x + self.textField.frame.size.width, 0, self.mainContentView.frame.size.width - self.textField.frame.size.width, self.mainContentView.frame.size.height);
    self.button.backgroundColor = CareD_Lake_COLOR_AbsintheGreen;
    [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    if (isVerified) {
        [self.button setTitle:@"发送" forState:(UIControlStateNormal)];
        self.button.enabled = NO;
    } else {
        [self.button setTitle:@"发送" forState:(UIControlStateNormal)];
    }
    [self.button setTintColor:[UIColor whiteColor]];
    [self.mainContentView addSubview:self.button];
    
    
    self.timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CareD_Lake_MainScreenBounds.size.width, 30)];
    self.timerLabel.font = [UIFont systemFontOfSize:17];
    self.timerLabel.center = CGPointMake(CareD_Lake_MainScreenBounds.size.width / 2, self.mainContentView.frame.origin.y + 100);
    self.timerLabel.textAlignment = NSTextAlignmentCenter;
    self.timerLabel.text = [NSString stringWithFormat:@"%ld秒以后可以重新发送",[TimerManagerForEmail sharedTimerManager].second];
    
    if ([[TimerManagerForEmail sharedTimerManager] second] > 0) {
        self.timerLabel.alpha = 1;
        self.button.enabled = NO;
    } else {
        self.timerLabel.alpha = 0;
        self.button.enabled = YES;
    }
    
    [self.view addSubview:self.timerLabel];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeLabel) userInfo:nil repeats:YES];
}

- (void)buttonAction:(UIButton *)sender {
    if ([self.textField.text isEqualToString:@""]) {
        return;
    }
    [TimerManagerForEmail sharedTimerManager].second = 60;
    [[YCUserManager sharedUserManager] findPasswordByEmail:self.textField.text];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"邮件已经发送" message:@"请检查您的邮箱，如果没有收到该邮件，请确保您的邮箱已经被验证。" preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }]];
    [self presentViewController:alert animated:YES completion:^{
        
    }];

    
    
}

- (void)changeLabel {
    [TimerManagerForEmail sharedTimerManager].second = [TimerManagerForEmail sharedTimerManager].second - 1;
    self.timerLabel.text = [NSString stringWithFormat:@"%ld秒以后可以重新发送",[TimerManagerForEmail sharedTimerManager].second];
    if ([TimerManagerForEmail sharedTimerManager].second > 0) {
        self.timerLabel.alpha = 1;
        self.button.enabled = NO;
    } else {
        self.timerLabel.alpha = 0;
        self.button.enabled = YES;
    }
    if (_isVerified) {
        [self.button setTitle:@"发送" forState:(UIControlStateNormal)];
        self.button.enabled = NO;
    } else {
        [self.button setTitle:@"发送" forState:(UIControlStateNormal)];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)backVC {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end