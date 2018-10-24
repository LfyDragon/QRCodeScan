//
//  DevelopmentUtil.h
//  NSThread-GCD-NSOperation
//
//  Created by ios2chen on 2018/9/19.
//  Copyright © 2018年 Lfy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DevelopmentUtil : NSObject

//TODO:相机权限
+(BOOL)cameraAuthorization;
//TODO:相册权限
+(BOOL)albumAuthorization;
//TODO:麦克风权限
+(BOOL)audioAuthorization;
//TODO:定位权限
+(BOOL)locationAuthorization;
//TODO:通讯录权限
+(BOOL)phoneBookAuthorization;
//TODO:通知权限
+(void)notificationAuthorization:(void (^)(BOOL aAllow))allow;
//TODO:全局提示框
+(void)showMessageWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate;
@end
