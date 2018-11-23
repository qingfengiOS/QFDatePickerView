//
//  QFTimerPicker.h
//  QFTimerPicker
//
//  Created by 情风 on 2018/11/19.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ReturnBlock)(NSString *selectedStr);

@interface QFTimerPicker : UIView

/**
 初始化时间选择

 @param block 回调block 参数即是选择的日期
 @return 时间选择器实例
 */
- (instancetype)initWithResponse:(ReturnBlock)block;

/**
 初始化时间选择
 
 @param superView 时间选择器的父View，若为空，将时间选择器加载在window上面
 @param block 回调block 参数即是选择的日期
 @return 时间选择器实例
 */
- (instancetype)initWithSuperView:(UIView *)superView response:(ReturnBlock)block;


/**
 pickerView 出现
 */
- (void)show ;

/**
 pickerView 消失
 */
- (void)dismiss;
@end
