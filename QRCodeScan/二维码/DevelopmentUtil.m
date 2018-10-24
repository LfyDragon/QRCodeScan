//
//  DevelopmentUtil.m
//  NSThread-GCD-NSOperation
//
//  Created by ios2chen on 2018/9/19.
//  Copyright © 2018年 Lfy. All rights reserved.
//

#import "DevelopmentUtil.h"


@implementation DevelopmentUtil

/*
XXXStatusNotDetermined = 0,//用户还未选择是否授权该权限
XXXStatusRestricted    = 1,//客户端未被授权访问硬件的媒体类型。用户不能改变客         户的状态,可能由于活跃的限制,如家长控制
XXXStatusDenied        = 2,//拒绝授权
XXXStatusAuthorized    = 3,//同意授权
*/

/*
//跳转到‘设置’
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
*/

+(BOOL)cameraAuthorization{
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
        return NO;
    } else {
        return YES;
    }
    
    /*
     *默认情况下，如果用户在未选择权限的情况下，第一次使用该权限，系统自动弹出‘是否打开权限’的提示框。
     *以下权限皆是如此。
     *
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            //同意
        } else {
            //拒绝
        }
    }];
     */
    
}

+(BOOL)albumAuthorization{
    
    if ([UIDevice currentDevice].systemVersion.floatValue>=8.0) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
            return NO;
        } else {
            return YES;
        }
        
        /*
         [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
         
         }];
         */
        
    } else {
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        if (status == ALAuthorizationStatusRestricted || status == ALAuthorizationStatusDenied) {
            return NO;
        } else {
            return YES;
        }
        
        /*
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
        } failureBlock:^(NSError *error) {
            
        }];
         */
    }
    
}

+(BOOL)audioAuthorization{
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
        return NO;
    } else {
        return YES;
    }
    
    /*
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        if (granted) {
            //同意
        } else {
            //拒绝
        }
    }];
     */
}

+(BOOL)locationAuthorization{
    
    if ([CLLocationManager locationServicesEnabled]) {
        //手机已开启定位服务
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
            return NO;
        } else {
            return YES;
        }
    } else {
        
        //手机没有开启定位服务
        //给出提示
        return NO;
    }
    
    
    
    /*
     CLLocationManager *manager = [[CLLocationManager alloc]init];
     [manager requestAlwaysAuthorization];
     //[manager requestWhenInUseAuthorization];
     */
}

+(BOOL)phoneBookAuthorization{
    
    
    if (@available(iOS 9.0, *)) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if(status == CNAuthorizationStatusRestricted || status == CNAuthorizationStatusDenied){
            return NO;
        }
        else {
            return YES;
        }
        
        /*
         CNContactStore * store = [[CNContactStore alloc] init];
         [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
         if (granted) {
         
         }else{
         
         }
         }];
         */
    } else {
        
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        
        if(status == kABAuthorizationStatusDenied || status == kABAuthorizationStatusRestricted){
            return NO;
        }
        else{
            return YES;
        }
        /*
         ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
         ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
         if (granted) {
         
         CFRelease(addressBook);
         }else{
         
         }
         });
         */
    }
    
}

+(void)notificationAuthorization:(void (^)(BOOL))allow{
    
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
                allow(NO);
            } else {
                allow(YES);
            }
        }];
        
    } else {
        UIUserNotificationSettings *notificationSet = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (notificationSet.types == UIUserNotificationTypeNone) {
            allow(NO);
        } else {
            allow(YES);
        }
    }
    
    /*
     *使用示例
     */
    /*
    [DevelopmentUtil notificationAuthorization:^(BOOL aAllow) {
        if (aAllow) {
            NSLog(@"已开启通知");
        }else{
            NSLog(@"未开启通知");
            //弹出提示框
        }
    }];
     */
}

+(void)showMessageWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate{
    
   // UIAlertView *alertView = [UIAlertView alloc]initWithTitle:<#(nullable NSString *)#> message:<#(nullable NSString *)#> delegate:<#(nullable id)#> cancelButtonTitle:<#(nullable NSString *)#> otherButtonTitles:<#(nullable NSString *), ...#>, nil
    
}

@end
