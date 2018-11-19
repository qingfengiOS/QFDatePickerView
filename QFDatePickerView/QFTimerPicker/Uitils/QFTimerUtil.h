//
//  QFUtil.h
//  QFTimerPicker
//
//  Created by 情风 on 2018/11/19.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QFTimerUtil : NSObject


/**
 获取日期数据源

 @return 日期数据源 默认到当前日期三天后
 */
+ (NSMutableArray *)dateArray;

/**
 获取小时数据源

 @param isToday 是否是当天
 @return 小时数据源
 */
+ (NSMutableArray *)hourArrayByToday:(BOOL)isToday;


/**
 获取分钟数据源

 @param isToday 是否今天
 @return 分钟数据源
 */
+ (NSMutableArray *)minuteArrayByToady:(BOOL)isToday selectedHour:(NSString *)selectedHour;
@end
