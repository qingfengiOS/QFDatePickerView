//
//  ViewController.m
//  QFTimerPicker
//
//  Created by 情风 on 2018/11/19.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

#import "ViewController.h"
#import "QFTimerPicker.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)chooseDate:(UIButton *)sender {
    QFTimerPicker *picker = [[QFTimerPicker alloc]initWithSuperView:self.view response:^(NSString *selectedStr) {
        NSLog(@"%@",selectedStr);
        [sender setTitle:selectedStr forState:UIControlStateNormal];
        
    }];
    
    [picker show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
