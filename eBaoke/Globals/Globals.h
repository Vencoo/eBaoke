//
//  Globals.h
//  eBaoke
//
//  Created by evenTouch on 14-9-15.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#ifndef eBaoke_Globals_h
#define eBaoke_Globals_h

#import "Globals_keys.h"

#import "JSONKit.h"
#import "UIViewExt.h"
#import "AppContext.h"
#import "MBProgressHUD.h"

#import "EBCarListModel.h"
#import "EBCarDetailModel.h"
#import "EBPremiumModel.h"


#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height

#define IOSVersion [[UIDevice currentDevice]systemVersion].floatValue

#define IS_IPHONE_5 [[UIScreen mainScreen ]bounds].size.height == 568
#define IS_IPHONE_4 [[UIScreen mainScreen ]bounds].size.height == 480

#define kHTTPHeader @"multipart/form-data; boundary=3i2ndDfv2rTHiSisAbouNdArYfORhtTPEefj3q2f"

#endif
