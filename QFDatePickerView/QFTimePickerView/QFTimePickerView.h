//
//  QFTimePickerView.h
//  QFDatePickerView
//
//  Created by iosyf-02 on 2017/11/14.
//  Copyright © 2017年 情风. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QFTimePickerView : UIView

/**
 初始化方法

 @param startHour 其实时间点 时
 @param endHour 结束时间点 时
 @param period 间隔多少分中
 @param block 返回选中的时间
 @return QFTimePickerView实例
 */
- (instancetype)initDatePackerWithStartHour:(NSString *)startHour endHour:(NSString *)endHour period:(NSInteger)period response:(void (^)(NSString *))block;

- (void)show;

@end
