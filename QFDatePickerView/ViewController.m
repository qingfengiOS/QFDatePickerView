//
//  ViewController.m
//  dateDemo
//
//  Created by 情风 on 2017/1/12.
//  Copyright © 2017年 情风. All rights reserved.
//

#import "ViewController.h"
#import "QFDatePickerView.h"

#import "QFTimePickerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)showYearSelectView:(id)sender {
    QFDatePickerView *datePickerView = [[QFDatePickerView alloc]initYearPickerViewWithResponse:^(NSString *str) {
        NSString *string = str;
        NSLog(@"str = %@",string);
    }];
    [datePickerView show];
}

- (IBAction)showDatePickerView:(id)sender {
    
    QFDatePickerView *datePickerView = [[QFDatePickerView alloc]initDatePackerWithResponse:^(NSString *str) {
        NSString *string = str;
        NSLog(@"str = %@",string);
    }];
    [datePickerView show];

    
}
- (IBAction)showTimePickerVierw:(id)sender {
    
    QFTimePickerView *pickerView = [[QFTimePickerView alloc]initDatePackerWithStartHour:@"18" endHour:@"12" period:10 response:^(NSString *str) {
        NSString *string = str;
        NSLog(@"str = %@",string);
    }];
    [pickerView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
