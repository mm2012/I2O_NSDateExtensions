//
//  I2ONSDate+Extensions.m
//
//  Copyright (c) 2013 Mikki Mann, Idea2Objects. All rights reserved.
//
/*
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 */


//**  '[NSCalendar currentCalendar]' to used to get the user's preferred Calendar,
// instead of using Gregorian calendar automatically.


#import "I2ONSDate+Extensions.h"

@implementation NSDate (Extensions)

+(int)currentHour
{
    NSDateComponents *dateComps = [[NSCalendar currentCalendar] components: (NSHourCalendarUnit | NSMinuteCalendarUnit)
                                                                  fromDate:[NSDate date]];
    return [dateComps hour];
}

+(int)currentMinute
{
    NSDateComponents *dateComps = [[NSCalendar currentCalendar] components: (NSHourCalendarUnit | NSMinuteCalendarUnit)
                                                                  fromDate:[NSDate date]];
    return [dateComps minute];
}

+(NSString*)currentTimeTextHHMM
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

-(int)year {
    NSCalendar *userCal = [NSCalendar currentCalendar];
    NSDateComponents *components = [userCal components:NSYearCalendarUnit fromDate:self];
    return [components year];
}


-(int)month {
    NSCalendar *userCal = [NSCalendar currentCalendar];
    NSDateComponents *components = [userCal components:NSMonthCalendarUnit fromDate:self];
    return [components month];
}

-(NSString*)monthName {
     NSCalendar *userCal = [NSCalendar currentCalendar];
    NSDateComponents *components = [userCal components:NSMonthCalendarUnit fromDate:self];
    
    NSArray *monthNames = @[@"January",@"February",@"March",
                            @"April", @"May", @"June", @"July",@"August", @"September",@"October",
                            @"November",@"December"];
    return [monthNames objectAtIndex:[components month]-1];  // -1 because monthNames array index starts at 0
}

-(int)day {
     NSCalendar *userCal = [NSCalendar currentCalendar];
     NSDateComponents *components = [userCal components:NSDayCalendarUnit fromDate:self];
    return [components day];
}

-(int)firstWeekDayInMonth {
     NSCalendar *userCal = [NSCalendar currentCalendar];
     [userCal setFirstWeekday:2]; //monday is first day
        //[gregorian setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"nl_NL"]];
    
        //Set date to first of month
    NSDateComponents *comps = [userCal components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:self];
    [comps setDay:1];
    NSDate *newDate = [userCal dateFromComponents:comps];
    
    return [userCal ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:newDate];
}

-(NSDate *)offsetMonth:(int)numMonths {
     NSCalendar *userCal = [NSCalendar currentCalendar];
    [userCal setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:numMonths];
    //[offsetComponents setHour:1];
    //[offsetComponents setMinute:30];
    return [userCal dateByAddingComponents:offsetComponents
                                      toDate:self options:0];
}

-(NSDate *)offsetHours:(int)hours {
     NSCalendar *userCal = [NSCalendar currentCalendar];
    [userCal setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        //[offsetComponents setMonth:numMonths];
    [offsetComponents setHour:hours];
        //[offsetComponents setMinute:30];
    return [userCal dateByAddingComponents:offsetComponents
                                      toDate:self options:0];
}


-(NSDate *)offsetDay:(int)numDays {
     NSCalendar *userCal = [NSCalendar currentCalendar];
    [userCal setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:numDays];
    
    return [userCal dateByAddingComponents:offsetComponents
                                      toDate:self options:0];
}



-(int)numDaysInMonth {
    NSCalendar *userCal = [NSCalendar currentCalendar];
    NSRange rng = [userCal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
    NSUInteger numberOfDaysInMonth = rng.length;
    return numberOfDaysInMonth;
}

+(NSDate *)dateStartOfDay:(NSDate *)date {
    NSCalendar *userCal = [NSCalendar currentCalendar];
    NSDateComponents *components = [userCal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate: date];
    return [userCal dateFromComponents:components];
}

+(NSDate *)dateStartOfWeek {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: - ((([components weekday] - [gregorian firstWeekday])
                                      + 7 ) % 7)];
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:[NSDate date] options:0];
    
    NSDateComponents *componentsStripped = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                        fromDate: beginningOfWeek];
    
    //gestript
    beginningOfWeek = [gregorian dateFromComponents: componentsStripped];
    
    return beginningOfWeek;
}

+(NSDate *)dateForSundayOfWeek {
     NSCalendar *userCal = [NSCalendar currentCalendar];
    [userCal setFirstWeekday:1]; //sunday
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: - ((([components weekday] - [userCal firstWeekday])
                                      + 7 ) % 7)];
    NSDate *beginningOfWeek = [userCal dateByAddingComponents:componentsToSubtract toDate:[NSDate date] options:0];
    
    NSDateComponents *componentsStripped = [userCal components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                        fromDate: beginningOfWeek];
    
    //gestript
    beginningOfWeek = [userCal dateFromComponents: componentsStripped];
    
    return beginningOfWeek;
}


+(NSDate *)dateEndOfWeek {
     NSCalendar *userCal = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    
    
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay: + (((([components weekday] - [userCal firstWeekday])
                                  + 7 ) % 7))+6];
    NSDate *endOfWeek = [userCal dateByAddingComponents:componentsToAdd toDate:[NSDate date] options:0];
    
    NSDateComponents *componentsStripped = [userCal components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                        fromDate: endOfWeek];
    
    //gestript
    endOfWeek = [userCal dateFromComponents: componentsStripped];
    return endOfWeek;
}

@end
