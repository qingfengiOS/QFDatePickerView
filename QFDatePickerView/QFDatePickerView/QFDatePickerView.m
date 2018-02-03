//
//  QFDatePickerView.m
//  dateDemo
//
//  Created by 情风 on 2017/1/12.
//  Copyright © 2017年 情风. All rights reserved.
//

#import "QFDatePickerView.h"
#import "AppDelegate.h"

@interface QFDatePickerView () <UIPickerViewDataSource,UIPickerViewDelegate>{
    UIView *contentView;
    void(^backBlock)(NSString *);
    
    NSMutableArray *yearArray;
    NSMutableArray *monthArray;
    NSInteger currentYear;
    NSInteger currentMonth;
    NSString *restr;
    
    NSString *selectedYear;
    NSString *selectecMonth;
    
    BOOL onlySelectYear;
}


@end

@implementation QFDatePickerView

#pragma mark - initDatePickerView
/**
 初始化方法，只带年月的日期选择
 
 @param block 返回选中的日期
 @return QFDatePickerView对象
 */
- (instancetype)initDatePackerWithResponse:(void (^)(NSString *))block{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    [self setViewInterface];
    if (block) {
        backBlock = block;
    }
    onlySelectYear = NO;
    return self;
}

/**
 初始化方法，只带年份的日期选择
 
 @param block 返回选中的年份
 @return QFDatePickerView对象
 */
- (instancetype)initYearPickerViewWithResponse:(void(^)(NSString*))block {
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    [self setViewInterface];
    if (block) {
        backBlock = block;
    }
    onlySelectYear = YES;
    return self;
}

#pragma mark - Configuration
- (void)setViewInterface {
    
    [self getCurrentDate];
    
    [self setYearArray];
    
    [self setMonthArray];
    
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
    
    //设置pickerView默认选中当前时间
    [pickerView selectRow:[selectedYear integerValue] - 1970 inComponent:0 animated:YES];
    if (!onlySelectYear) {
        [pickerView selectRow:[selectecMonth integerValue] - 1 inComponent:1 animated:YES];
    }
    
    [contentView addSubview:pickerView];
}

- (void)getCurrentDate {
    //获取当前时间 （时间格式支持自定义）
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];//自定义时间格式
    NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
    //拆分年月成数组
    NSArray *dateArray = [currentDateStr componentsSeparatedByString:@"-"];
    if (dateArray.count == 2) {//年 月
        currentYear = [[dateArray firstObject]integerValue];
        currentMonth =  [dateArray[1] integerValue];
    }
    selectedYear = [NSString stringWithFormat:@"%ld",(long)currentYear];
    selectecMonth = [NSString stringWithFormat:@"%ld",(long)currentMonth];
}

- (void)setYearArray {
    //初始化年数据源数组
    yearArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 1970; i <= currentYear ; i++) {
        NSString *yearStr = [NSString stringWithFormat:@"%ld年",(long)i];
        [yearArray addObject:yearStr];
    }
    [yearArray addObject:@"至今"];
}

- (void)setMonthArray {
    //初始化月数据源数组
    monthArray = [[NSMutableArray alloc]init];
    
    if ([[selectedYear substringWithRange:NSMakeRange(0, 4)] isEqualToString:[NSString stringWithFormat:@"%ld",currentYear]]) {
        for (NSInteger i = 1 ; i <= currentMonth; i++) {
            NSString *monthStr = [NSString stringWithFormat:@"%ld月",(long)i];
            [monthArray addObject:monthStr];
        }
    } else {
        for (NSInteger i = 1 ; i <= 12; i++) {
            NSString *monthStr = [NSString stringWithFormat:@"%ld月",(long)i];
            [monthArray addObject:monthStr];
        }
    }
}

#pragma mark - Actions
- (void)buttonTapped:(UIButton *)sender {
    if (sender.tag == 10) {
        [self dismiss];
    } else {
        if (onlySelectYear) {
            restr = [selectedYear stringByReplacingOccurrencesOfString:@"年" withString:@""];
        } else {
            if ([selectecMonth isEqualToString:@""]) {//至今的情况下 不需要中间-
                restr = [NSString stringWithFormat:@"%@%@",selectedYear,selectecMonth];
            } else {
                restr = [NSString stringWithFormat:@"%@-%@",selectedYear,selectecMonth];
            }
            
            restr = [restr stringByReplacingOccurrencesOfString:@"年" withString:@""];
            restr = [restr stringByReplacingOccurrencesOfString:@"月" withString:@""];
        }
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
    if (onlySelectYear) {//只选择年
        return 1;
    } else {
        return 2;
    }
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (onlySelectYear) {//只选择年
        return yearArray.count;
    } else {
        if (component == 0) {
            return yearArray.count;
        } else {
            return monthArray.count;
        }
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (onlySelectYear) {//只选择年
        return yearArray[row];
    } else {
        if (component == 0) {
            return yearArray[row];
        } else {
            return monthArray[row];
        }
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (onlySelectYear) {//只选择年
        selectedYear = yearArray[row];
    } else {
        if (component == 0) {
            selectedYear = yearArray[row];
            if ([selectedYear isEqualToString:@"至今"]) {//至今的情况下,月份清空
                [monthArray removeAllObjects];
                selectecMonth = @"";
            } else {//非至今的情况下,显示月份
                [self setMonthArray];
                selectecMonth = [NSString stringWithFormat:@"%ld",(long)currentMonth];
            }
            [pickerView reloadComponent:1];
            
        } else {
            selectecMonth = monthArray[row];
        }
    }
}

@end
