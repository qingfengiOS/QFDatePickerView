//
//  QFUtil.m
//  QFTimerPicker
//
//  Created by 情风 on 2018/11/19.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

#import "QFTimerUtil.h"
#import "QFTimerDataSourceModel.h"
#import "QFDateModel.h"
#import "QFHourModel.h"
#import "QFMinuteModel.h"

static NSDateFormatter *_dateFormatter;

static NSInteger const kBenginTimeDely = 20;//数据源的开始时间是当前时间的kBenginTimeDely分钟 并且向上取整
static NSInteger const kTimeInterval = 10;//时间间隔 默认10分钟一个刻度
static NSInteger const kDays = 3;//从今天起能选择多少天 默认3天

@implementation QFTimerUtil

+ (void)load {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
}

#pragma mark - Public
+ (QFTimerDataSourceModel *)configDataSource {
    
    QFTimerDataSourceModel *dataSourceModel = [QFTimerDataSourceModel new];
    
    NSMutableArray *dateArray = [NSMutableArray array];//日期数据源
    NSMutableArray *todayHourArray = [NSMutableArray array];//当天的小时数据源
    NSMutableArray *todayMinuteArray = [NSMutableArray array];//当天的分钟数据源
    NSMutableArray *hourArray = [NSMutableArray array];//非当天的小时数据源
    NSMutableArray *minuteArray = [NSMutableArray array];//非当天的分钟数据源
    
    NSString *beginTime = [self getTimerAfterCurrentTime:kBenginTimeDely];//开始时间（也就是当前时间20分钟后）
    NSInteger currentMin = [self getMString:beginTime];
    if (currentMin % kTimeInterval != 0) {
        beginTime = [self getTimerAfterTime:beginTime periodMin:(kTimeInterval - currentMin % kTimeInterval)];//开始时间向上取整
    }
    NSDate *currentDate = [NSDate date];
    NSDate *appointDate;
    NSTimeInterval oneDay = 24 * 60 * 60;
    for (int i = 0; i < kDays; i++) {
        appointDate = [currentDate initWithTimeIntervalSinceNow: oneDay * i];
        NSString *nextDateStr = [self getTomorrowDay:appointDate];
        NSString *week = [self currentWeek:nextDateStr type:NO];//获取星期几
        
        QFDateModel *model = [[QFDateModel alloc]init];
        model.dateString = nextDateStr.length > 10 ? [nextDateStr substringToIndex:10] : nextDateStr;//实际日期
        model.showDateString = [NSString stringWithFormat:@"%@ %@",[self getMDStringByString:nextDateStr],week];//展示的日期
        [dateArray addObject:model];
    }
    
    
    NSInteger beginHour = [self getHString:beginTime];
    for (NSInteger i = beginHour; i < 24 ; i++) {
        QFHourModel *model = [[QFHourModel alloc]init];
        if (i < 10) {
            model.hourString = [NSString stringWithFormat:@"0%ld",i];
            model.showHourString = [NSString stringWithFormat:@"%ld点",i];
        } else {
            model.hourString = [NSString stringWithFormat:@"%ld",i];
            model.showHourString = [NSString stringWithFormat:@"%ld点",i];
        }
        [todayHourArray addObject:model];
    }

    for (NSInteger i = 0; i < 24 ; i++) {
        QFHourModel *model = [[QFHourModel alloc]init];
        if (i < 10) {
            model.hourString = [NSString stringWithFormat:@"0%ld",i];
            model.showHourString = [NSString stringWithFormat:@"%ld点",i];
        } else {
            model.hourString = [NSString stringWithFormat:@"%ld",i];
            model.showHourString = [NSString stringWithFormat:@"%ld点",i];
        }
        [hourArray addObject:model];
    }
    
    NSInteger beginMin = [self getMString:beginTime];
    NSInteger minStart = beginMin / kTimeInterval;
    
    for (NSInteger i = minStart; i < 60 / kTimeInterval; i++) {
        QFMinuteModel *model = [[QFMinuteModel alloc]init];
        if (i * kTimeInterval < 10) {
            model.minuteString = [NSString stringWithFormat:@"0%ld",(long)i * kTimeInterval];
            model.showMinuteString = [NSString stringWithFormat:@"0%ld分",(long)i * kTimeInterval];
        } else {
            model.minuteString = [NSString stringWithFormat:@"%ld",i * kTimeInterval];
            model.showMinuteString = [NSString stringWithFormat:@"%ld分",i * kTimeInterval];
        }
        
        [todayMinuteArray addObject:model];
    }
    
    for (NSInteger i = 0; i <  60 / kTimeInterval; i++) {
        QFMinuteModel *model = [[QFMinuteModel alloc]init];
        if (i * kTimeInterval< 10) {
            model.minuteString = [NSString stringWithFormat:@"0%ld",(long)i * kTimeInterval];
            model.showMinuteString = [NSString stringWithFormat:@"0%ld分",(long)i * kTimeInterval];
        } else {
            model.minuteString = [NSString stringWithFormat:@"%ld",i * kTimeInterval];
            model.showMinuteString = [NSString stringWithFormat:@"%ld分",i * kTimeInterval];
        }
        
        [minuteArray addObject:model];
    }

    dataSourceModel.dateArray = dateArray;
    
    dataSourceModel.hourArray = hourArray;
    dataSourceModel.minuteArray = minuteArray;
    
    dataSourceModel.todayHourArray = todayHourArray;
    dataSourceModel.todayMinuteArray = todayMinuteArray;
    
    return dataSourceModel;
}

#pragma mark - Private
+ (NSString *)getTomorrowDay:(NSDate *)aDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:[components day]];
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [_dateFormatter stringFromDate:beginningOfWeek];
}
///得到当前日期
+ (NSString *)getCurrentDateStr {
    
    //获取当前时间，日期
    NSDate *currentDate = [NSDate date];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [_dateFormatter stringFromDate:currentDate];
    
    return dateString;
}

/**
 NSString 转 NSDate
 
 @param string NSString
 @return NSDate
 */
+ (NSDate *)stringToDate:(NSString *)string {
    [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [_dateFormatter dateFromString:string];
    return date;
}

/**
 Date转String
 
 @param date NSDate
 @return yyyy-MM-dd
 */
+ (NSString *)dateToString:(NSDate *)date {
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [_dateFormatter stringFromDate:date];
    return strDate;
}

/**
 根据日期计算星期几
 
 @param date 日期
 @param type YES 为周几 NO 为星期几
 @return 周几
 */
+ (NSString *)currentWeek:(NSString *)date type:(BOOL)type {
    
    if ([[date substringToIndex:10] isEqualToString:[[self getCurrentDateStr] substringToIndex:10]]) {
        return @"今天";
    }
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitWeekday;
    comps = [calendar components:unitFlags fromDate:[self stringToDate:date]];
    
    NSString *week = @"";
    if (type) {
        switch (comps.weekday) {
            case 1:week = @"周日";break;
            case 2:week = @"周一";break;
            case 3:week = @"周二";break;
            case 4:week = @"周三";break;
            case 5:week = @"周四";break;
            case 6:week = @"周五";break;
            case 7:week = @"周六";break;
            default:break;
        }
    }else {
        switch (comps.weekday) {
            case 1:week = @"星期天";break;
            case 2:week = @"星期一";break;
            case 3:week = @"星期二";break;
            case 4:week = @"星期三";break;
            case 5:week = @"星期四";break;
            case 6:week = @"星期五";break;
            case 7:week = @"星期六";break;
            default:break;
        }
    }
    return week;
}

/**
 计算X天后的日期
 
 @param nowDateString yyyy-MM-dd
 @param aDay 多少天后
 @return yyyy-MM-dd
 */
+ (NSString *)distanceDate:(NSString *)nowDateString aDay:(NSInteger)aDay {
    
    NSDate *date = [self stringToDate:nowDateString];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    comp.day = aDay;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:comp toDate:date options:0];
    
    return [self dateToString:newDate];
}
/**
 *  把完整时间变成 XX月XX日
 *
 *  @param dateString 完整返回时间
 *
 *  @return XX月XX日
 */
+ (NSString *)getMDStringByString:(NSString *)dateString {
    if (dateString.length >= 10) {
        NSString *month = [dateString substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [dateString substringWithRange:NSMakeRange(8, 2)];
        return [NSString stringWithFormat:@"%@月%@日",month,day];
    } else {
        return @"";
    }
    return @"";
}

/**
 *  取小时数
 *
 *  @param dateString 完整返回时间
 *
 *  @return XX
 */
+ (NSInteger)getHString:(NSString *)dateString {
    if (dateString.length >= 13) {
        return [[dateString substringWithRange:NSMakeRange(11, 2)] integerValue];
    } else {
        return 0;
    }
}

/**
 *  取分钟数
 *
 *  @param dateString 完整返回时间
 *
 *  @return XX
 */
+ (NSInteger)getMString:(NSString *)dateString {
    if (dateString.length >= 16) {
        return [[dateString substringWithRange:NSMakeRange(14, 2)] integerValue];
    } else {
        return 0;
    }
}
/**
 获取当前时间X分钟后的时间
 
 @param periodMin 需要的是多少分钟后的时间
 @return 当前时间X分钟之后的时间字符串
 */
+ (NSString *)getTimerAfterCurrentTime:(NSInteger)periodMin {
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *resultStr = [_dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:periodMin * 60]];
    return resultStr;
}

/**
 获取指定时间X分钟后的时间
 
 @param periodMin 需要的是多少分钟后的时间
 @return 指定时间X分钟后的时间字符串
 */
+ (NSString *)getTimerAfterTime:(NSString *)time periodMin:(NSInteger)periodMin {
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [_dateFormatter dateFromString:time];
    NSString *resultStr = [_dateFormatter stringFromDate:[date initWithTimeInterval:periodMin*60 sinceDate:date]];
    return resultStr;
}

@end
