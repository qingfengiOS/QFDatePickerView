//
//  QFTimerPicker.m
//  QFTimerPicker
//
//  Created by 情风 on 2018/11/19.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

#import "QFTimerPicker.h"
#import "QFTimerUtil.h"
#import "QFTimerDataSourceModel.h"
#import "QFDateModel.h"
#import "QFHourModel.h"
#import "QFMinuteModel.h"

@interface QFTimerPicker ()<UIPickerViewDataSource,UIPickerViewDelegate>

/// 底层View
@property (nonatomic, strong) UIView *contentView;

/// 该pickerView所加载在的View 如果为nil就加载在Window上
@property (nonatomic, strong) UIView *superView;

/// 回调Block
@property (nonatomic, copy) ReturnBlock returnBlock;

/// 选中的日期下标
@property (nonatomic, assign) NSInteger selectedDateIndex;

/// 选中的小时下标
@property (nonatomic, assign) NSInteger selectedHourIndex;

/// 选中的分钟下标
@property (nonatomic, assign) NSInteger selectedMinuteIndex;

@property (nonatomic, strong)  QFTimerDataSourceModel *dataSourceModel;

@end

@implementation QFTimerPicker

#pragma mark - Life Cycle
- (instancetype)initWithResponse:(ReturnBlock)block {
    if (self = [super init]) {
        [self initDataSource];
        [self initAppreaence];
        
    }
    self.returnBlock = block;
    return self;
}

- (instancetype)initWithSuperView:(UIView *)superView response:(ReturnBlock)block {
    if (self = [super init]) {
        [self initDataSource];
        [self initAppreaence];
    }
    self.returnBlock = block;
    self.superView = superView;
    return self;
}

#pragma mark - InitDataSource
- (void)initDataSource {
    self.selectedDateIndex = 0;
    self.selectedHourIndex = 0;
    self.selectedMinuteIndex = 0;
    
    self.dataSourceModel = [QFTimerUtil configDataSource];
}

#pragma mark - InitAppreaence
- (void)initAppreaence {

    self.frame = [UIScreen mainScreen].bounds;
    //设置背景颜色为黑色，并有0.4的透明度
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 260, [UIScreen mainScreen].bounds.size.width, 260)];
    [self addSubview:self.contentView];
    
    
    //添加白色view
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:whiteView];
    
    //添加确定和取消按钮
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 80) * i, 0, 80, 50)];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button setTitle:i == 0 ? @"取消" : @"确认" forState:UIControlStateNormal];
        
        if (i != 0) {
            [button setTitleColor:[UIColor colorWithRed:41.0 / 255.0 green:152.0 / 255.0 blue:255.0 / 255.0 alpha:1] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1] forState:UIControlStateNormal];
        }
        [whiteView addSubview:button];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + i;
    }
    
    //文本提示
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 20)];
    titleLabel.center = whiteView.center;
    titleLabel.text = @"选择预约时间";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:34.0/255 green:34.0/255 blue:34.0/255 alpha:1];
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [whiteView addSubview:titleLabel];
    
    //分割线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 49, [UIScreen mainScreen].bounds.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
    [whiteView addSubview:line];
    
    //pickerView
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 210)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:pickerView];
}

#pragma mark - Public
- (void)show {//pickerView出现

    if (self.superView) {
        [self.superView addSubview:self];
    } else {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    [UIView animateWithDuration:0.4 animations:^{
        self.contentView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.contentView.bounds.size.height,  [UIScreen mainScreen].bounds.size.width, self.contentView.bounds.size.height);
    }];
}

- (void)dismiss {//pickerView消失
    
    [UIView animateWithDuration:0.4 animations:^{
        self.contentView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, self.contentView.center.y + self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - Event Response
- (void)buttonAction:(UIButton *)sender {
    if (sender.tag == 100) {//取消
        [self dismiss];
    } else {//确定
        if (self.returnBlock) {
            QFDateModel *dateModel = self.dataSourceModel.dateArray[self.selectedDateIndex];
        
            QFHourModel *hourModel;
            if (self.selectedDateIndex == 0) {//选中的今天
                hourModel = self.dataSourceModel.todayHourArray[self.selectedHourIndex];
            } else {
                hourModel = self.dataSourceModel.hourArray[self.selectedHourIndex];
            }
        
            QFMinuteModel *minModel;
            if (self.selectedHourIndex == 0 && self.selectedDateIndex == 0) {//选中的今天的第一个小时
                minModel = self.dataSourceModel.todayMinuteArray[self.selectedMinuteIndex];
            } else {
                minModel = self.dataSourceModel.minuteArray[self.selectedMinuteIndex];
            }
            
            NSString *returnStr = [NSString stringWithFormat:@"%@ %@:%@",dateModel.dateString,hourModel.hourString,minModel.minuteString];
            self.returnBlock(returnStr);
        }
        [self dismiss];
    }
}

#pragma mark - UIPickerViewDataSource UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.dataSourceModel.dateArray.count;
    } else if (component == 1) {
        if (self.selectedDateIndex == 0) {//选中的今天
            return self.dataSourceModel.todayHourArray.count;
        } else {
            return self.dataSourceModel.hourArray.count;
        }
    } else {
        if (self.selectedHourIndex == 0 && self.selectedDateIndex == 0) {//选中的今天的第一个小时
            return self.dataSourceModel.todayMinuteArray.count;
        } else {
            return self.dataSourceModel.minuteArray.count;
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return [UIScreen mainScreen].bounds.size.width / 2;
    } else {
        return [UIScreen mainScreen].bounds.size.width / 5;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UILabel *)recycledLabel {
    if (!recycledLabel) {
        recycledLabel = [[UILabel alloc] init];
    }
    recycledLabel.textAlignment = NSTextAlignmentCenter;
    [recycledLabel setFont:[UIFont systemFontOfSize:18]];
    recycledLabel.textColor = [UIColor colorWithRed:34.0f / 255.0f green:34.0f / 255.0f blue:34.0f / 255.0f alpha:1.0f];
    
    if (component == 0) {
        QFDateModel *dateModel = self.dataSourceModel.dateArray[row];
        recycledLabel.text = dateModel.showDateString;
    } else if (component == 1) {
        QFHourModel *hourModel;
        if (self.selectedDateIndex == 0) {//选中的今天
            hourModel = self.dataSourceModel.todayHourArray[row];
        } else {
            hourModel = self.dataSourceModel.hourArray[row];
        }
        recycledLabel.text = hourModel.showHourString;
    } else {
        QFMinuteModel *minModel;
        if (self.selectedHourIndex == 0 && self.selectedDateIndex == 0) {//选中的今天的第一个小时
            minModel = self.dataSourceModel.todayMinuteArray[row];
        } else {
            minModel = self.dataSourceModel.minuteArray[row];
        }
        recycledLabel.text = minModel.showMinuteString;
    }
    
    return recycledLabel;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedDateIndex = row;
        self.selectedHourIndex = 0;
        self.selectedMinuteIndex = 0;
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    } else if (component == 1) {
        self.selectedHourIndex = row;
        self.selectedMinuteIndex = 0;
        [pickerView selectRow:0 inComponent:2 animated:YES];
    } else {
        self.selectedMinuteIndex = row;
    }
    [pickerView reloadAllComponents];
}


@end
