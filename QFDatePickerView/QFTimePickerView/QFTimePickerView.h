//
//  QFTimePickerView.h
//  QFDatePickerView
//
//  Created by iosyf-02 on 2017/11/14.
//  Copyright © 2017年 情风. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QFTimePickerView : UIView

- (instancetype)initDatePackerWithStartHour:(NSString *)startHour endHour:(NSString *)endHour period:(NSInteger)period response:(void (^)(NSString *))block;

- (void)show;

@end
