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
#import "QFTimerPicker.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)showYearSelectView:(id)sender {
    
    QFDatePickerView *datePickerView = [[QFDatePickerView alloc]initYearPickerWithView:self.view response:^(NSString *str) {
        NSString *string = str;
        NSLog(@"str = %@",string);
    }];
    [datePickerView show];
}

- (IBAction)showDatePickerView:(id)sender {
    
    QFDatePickerView *datePickerView = [[QFDatePickerView alloc]initDatePackerWithSUperView:self.view response:^(NSString *str) {
        NSString *string = str;
        NSLog(@"str = %@",string);
    }];
    [datePickerView show];
}

- (IBAction)showTimePickerVierw:(id)sender {
    
    QFTimePickerView *pickerView = [[QFTimePickerView alloc]initDatePackerWithStartHour:@"18" endHour:@"12" period:5 response:^(NSString *str) {
        NSString *string = str;
        NSLog(@"str = %@",string);
    }];
    [pickerView show];
}

- (IBAction)chooseDate:(UIButton *)sender {
    QFTimerPicker *picker = [[QFTimerPicker alloc]initWithSuperView:self.view response:^(NSString *selectedStr) {
        NSLog(@"%@",selectedStr);
        [sender setTitle:selectedStr forState:UIControlStateNormal];
        
    }];
    
    [picker show];
}
@end
