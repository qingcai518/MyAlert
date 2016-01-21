//
//  ViewController.m
//  MyAlert
//
//  Created by user on 2016/01/20.
//  Copyright © 2016年 user. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back.png"]];
    backImage.userInteractionEnabled = YES;
    backImage.frame = CGRectMake(0, 0, 375, 667);
    [self.view addSubview:backImage];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 355, 60)];
    title.font = [UIFont fontWithName:@"Verdana-BoldItalic" size:40];
    title.textColor = [UIColor whiteColor];
    title.text = @"Mr. Alert";
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
    
    UITextField *station = [[UITextField alloc]initWithFrame:CGRectMake(30, 200, 315, 40)];
    station.borderStyle = UITextBorderStyleRoundedRect;
    station.backgroundColor = [UIColor whiteColor];
    station.placeholder = @"駅名を入力してください";
    station.font = [UIFont fontWithName:@"Arial" size:20];
    station.clearButtonMode = UITextFieldViewModeAlways;
    station.returnKeyType = UIReturnKeyGo;
    [self.view addSubview:station];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
