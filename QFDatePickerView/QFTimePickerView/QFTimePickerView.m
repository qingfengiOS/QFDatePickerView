//
//  QFTimePickerView.m
//  QFDatePickerView
//
//  Created by iosyf-02 on 2017/11/14.
//  Copyright © 2017年 情风. All rights reserved.
//

#import "QFTimePickerView.h"

@interface QFTimePickerView () <UIPickerViewDataSource,UIPickerViewDelegate>{
    UIView *contentView;
    void(^backBlock)(NSString *);
    
    NSMutableArray *hourArray;
    NSMutableArray *minArray;
    NSInteger currentHour;
    NSInteger currentMin;
    NSString *restr;
    
    NSString *selectedHour;
    NSString *selectedMin;
}

@property (nonatomic, assign) NSString *startTime;
@property (nonatomic, assign) NSString *endTime;
@property (nonatomic, assign) NSInteger period;

@end

@implementation QFTimePickerView

/**
 初始化方法
 
 @param startHour 其实时间点 时
 @param endHour 结束时间点 时
 @param period 间隔多少分中
 @param block 返回选中的时间
 @return QFTimePickerView实例
 */
- (instancetype)initDatePackerWithStartHour:(NSString *)startHour endHour:(NSString *)endHour period:(NSInteger)period response:(void (^)(NSString *))block{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    _startTime = startHour;
    _endTime = endHour;
    _period = period;
    
    [self initDataSource];
    [self initAppreaence];
    
    if (block) {
        backBlock = block;
    }
    return self;
}

#pragma mark - initDataSource
- (void)initDataSource {
    
    [self configHourArray];
    [self configMinArray];
    
    selectedHour = hourArray[0];
    selectedMin = minArray[0];
}

- (void)configHourArray {//配置小时数据源数组
    //初始化小时数据源数组
    hourArray = [[NSMutableArray alloc]init];
    
    NSString *startHour = [_startTime substringWithRange:NSMakeRange(0, 2)];
    NSString *endHour = [_endTime substringWithRange:NSMakeRange(0, 2)];
    
    if ([startHour integerValue] > [endHour integerValue]) {//跨天
        NSString *minStr = @"";
        for (NSInteger i = [startHour integerValue]; i < 24; i++) {//加当天的小时数
            if (i < 10) {
                minStr = [NSString stringWithFormat:@"0%ld",i];
            } else {
                minStr = [NSString stringWithFormat:@"%ld",i];
            }
            [hourArray addObject:minStr];
        }
        for (NSInteger i = 0; i <= [endHour integerValue]; i++) {//加次天的小时数
            if (i < 10) {
                minStr = [NSString stringWithFormat:@"0%ld",i];
            } else {
                minStr = [NSString stringWithFormat:@"%ld",i];
            }
            [hourArray addObject:minStr];
        }
        
    } else {
        for (NSInteger i = [startHour integerValue]; i < [endHour integerValue]; i++) {//加小时数
            NSString *minStr = @"";
            if (i < 10) {
                minStr = [NSString stringWithFormat:@"0%ld",i];
            } else {
                minStr = [NSString stringWithFormat:@"%ld",i];
            }
            [hourArray addObject:minStr];
        }
    }
    
}

- (void)configMinArray {//配置分钟数据源数组
    minArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 1 ; i <= 60; i++) {
        NSString *minStr = @"";
        if (i % _period == 0) {
            if (i < 10) {
                minStr = [NSString stringWithFormat:@"0%ld",(long)i];
            } else {
                minStr = [NSString stringWithFormat:@"%ld",(long)i];
            }
            [minArray addObject:minStr];
        }
    }
    [minArray insertObject:@"00" atIndex:0];
    [minArray removeLastObject];
}

#pragma mark - initAppreaence
- (void)initAppreaence {

    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 300)];
    [self addSubview:contentView];
    //设置背景颜色为黑色，并有0.4的透明度
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    //添加白色view
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:whiteView];
    //添加确定和取消按钮
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - 60) * i, 0, 60, 40)];
        [button setTitle:i == 0 ? @"取消" : @"确定" forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitleColor:[UIColor colorWithRed:97.0 / 255.0 green:97.0 / 255.0 blue:97.0 / 255.0 alpha:1] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        [whiteView addSubview:button];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10 + i;
    }
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.bounds), 260)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor = [UIColor colorWithRed:240.0/255 green:243.0/255 blue:250.0/255 alpha:1];
    
    //设置pickerView默认第一行 这里也可默认选中其他行 修改selectRow即可
    [pickerView selectRow:0 inComponent:0 animated:YES];
    [pickerView selectRow:0 inComponent:1 animated:YES];
    
    [contentView addSubview:pickerView];
}

#pragma mark - Actions
- (void)buttonTapped:(UIButton *)sender {
    if (sender.tag == 10) {
        [self dismiss];
    } else {
        
        restr = [NSString stringWithFormat:@"%@:%@",selectedHour,selectedMin];
    
        backBlock(restr);
        [self dismiss];
    }
}

#pragma mark - pickerView出现
- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.4 animations:^{
        contentView.center = CGPointMake(self.frame.size.width/2, contentView.center.y - contentView.frame.size.height);
    }];
}

#pragma mark - pickerView消失
- (void)dismiss{
    
    [UIView animateWithDuration:0.4 animations:^{
        contentView.center = CGPointMake(self.frame.size.width/2, contentView.center.y + contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIPickerViewDataSource UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return hourArray.count;
    }
    else {
        return minArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return hourArray[row];
    } else {
        return minArray[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        selectedHour = hourArray[row];
        
        if ([selectedHour isEqualToString:[hourArray lastObject]]) {
            [pickerView selectRow:0 inComponent:1 animated:YES];
            selectedMin = @"00";
        }
        [pickerView reloadComponent:1];
        
    } else {
        if ([selectedHour isEqualToString:[hourArray lastObject]]) {
            [pickerView selectRow:0 inComponent:1 animated:YES];
            selectedMin = @"00";
        } else {
            selectedMin = minArray[row];
        }
    }
}
@end
