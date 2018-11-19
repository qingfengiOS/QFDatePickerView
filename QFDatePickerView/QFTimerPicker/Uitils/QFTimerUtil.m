//
//  QFUtil.m
//  QFTimerPicker
//
//  Created by 情风 on 2018/11/19.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

#import "QFTimerUtil.h"
#import "QFDateModel.h"
#import "QFMinuteModel.h"
#import "QFHourModel.h"

static NSDateFormatter *_dateFormatter;

@implementation QFTimerUtil

+ (void)load {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    }
}

#pragma mark - Public
+ (NSMutableArray *)dateArray {
    
    NSMutableArray *dateArray = [NSMutableArray array];
    NSString *currentDateString = [self getCurrentDateStr];
    
    for (NSInteger i = 0; i < 3; i++) {
        NSString *dateString = [self distanceDate:currentDateString aDay:i];//获取第i天的日期
        NSString *week = [self currentWeek:dateString type:NO];//获取星期几
        
        QFDateModel *model = [[QFDateModel alloc]init];
        model.dateString = dateString;//实际日期
        model.showDateString = [NSString stringWithFormat:@"%@ %@",[self getMDStringByString:dateString],week];//展示的日期
        
        [dateArray addObject:model];
    }
    return dateArray;
}

+ (NSMutableArray *)hourArrayByToday:(BOOL)isToday {
    NSMutableArray *hourArray = [NSMutableArray array];
    
    NSInteger star = 0;//不是今天，数据源从0~23
    //如果是今天，数据源从当前时间之后开始
    if (isToday) {
        NSString *currentDateString = [self getCurrentDateStr];
        
        NSInteger currentHour = [self getHString:currentDateString];
        NSInteger currentMin = [self getMString:currentDateString];
        
        if (currentMin >= 40) {
            star = currentHour + 1;
        } else {
            star = currentHour;
        }
    }
    for (NSInteger i = star; i < 24 ; i++) {
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
    
    return hourArray;
}

+ (NSMutableArray *)minuteArrayByToady:(BOOL)isToday selectedHour:(NSString *)selectedHour {
    
    NSMutableArray *minuteArray = [NSMutableArray array];
    NSString *currentDateString = [self getCurrentDateStr];
    NSInteger currentHour = [self getHString:currentDateString];
    
    BOOL isCurrentHour = NO;
    NSInteger hour = [[selectedHour substringToIndex:2] integerValue];
    if (hour == currentHour) {
        isCurrentHour = YES;
    }
    NSInteger star = 0;//不是今天或者不是今天的当前小时，数据源从0~50分
    if (isToday && isCurrentHour) {//如果今天且在当前小时，那么数据源从当前时间20分之后开始
        NSInteger currentMin = [self getMString:currentDateString];
        
        if (currentMin > 30 && currentMin <= 40) {//当前30分之后了 数据从0->50可选
            star = 0;
        } else if (currentMin > 40 && currentMin <= 50) {//当前40分之后了 数据从10->50可选
            star = 1;
        } else if (currentMin > 50) {//当前50分之后了 数据从20->50可选
            star = 2;
        } else {
            if (currentMin % 10 == 0) {//整10的分钟数 比如：10 20 30...
                star = currentMin / 10 + 2;
            } else {
                star = currentMin / 10 + 1 + 2;
            }
        }
    }
    
    for (NSInteger i = star; i < 6; i++) {
        QFMinuteModel *model = [[QFMinuteModel alloc]init];
        if (i == 0) {
            model.minuteString = @"00";
            model.showMinuteString = @"00分";
        } else {
            model.minuteString = [NSString stringWithFormat:@"%ld",i * 10];
            model.showMinuteString = [NSString stringWithFormat:@"%ld分",i * 10];
        }
        
        [minuteArray addObject:model];
    }
    
    return minuteArray;
}

#pragma mark - Private
///得到当前日期
+ (NSString *)getCurrentDateStr {
    
    //获取当前时间，日期
    NSDate *currentDate = [NSDate date];
    [_dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [_dateFormatter stringFromDate:currentDate];
    
    return dateString;
}

/**
 NSString 转 NSDate
 
 @param string NSString
 @return NSDate
 */
+ (NSDate *)stringToDate:(NSString *)string {
    NSDate *date = [_dateFormatter dateFromString:string];
    return date;
}

/**
 Date转String
 
 @param date NSDate
 @return yyyy-MM-dd
 */
+ (NSString *)dateToString:(NSDate *)date {
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
@end
