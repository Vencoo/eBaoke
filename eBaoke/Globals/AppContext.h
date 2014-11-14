//
//  AppContext.h
//  ClaimApp
//
//  Created by administrator on 1/6/11.
//  Copyright 2011 eBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define IOSVersion [[UIDevice currentDevice]systemVersion].floatValue


#define kCommonLoadingViewTag	-999 
#define kNoAccountViewTag	-998 
#define kEmptyTempKeyValue	@"_EBAO_BLANK" 

#define kWaitingForInput	@"..." 


#define kBoolYesFlag     @"Y"
#define kBoolNoFlag      @"N"

#define kUniqueGlobalDeviceIdentifierKey     @"_UGDI"
#define kUniqueAppKey     @"_App_Key"

#define kEmptyMsgImage      @"bundle://empty.png"
#define kDefNewMsgImage     @"bundle://newmsg.png"

#define kPostContentTypeSelect  @"select"
#define kPostContentTypeValue  @"value"


#define kPostContentTypeUsername  @"username"
#define kPostContentTypePassword  @"password"
#define kPostContentTypeUuid  @"uuid"
#define kPostContentTypeUserId  @"user_id"


#define kPostXMLContentType  @"text/xml;charset=UTF-8";


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)



@interface AppContext : NSObject {

} 

+(NSString *) getContextValueByKey:(NSString *) key;

+(NSString *) getServiceUrl:(NSString *) serviceKey;

+(NSString *) getAppMode;

+(void) setUserToken:(NSString *) token;

+(NSString *) getUserToken;

+(void)performTransition:(UIView *) view1 toAppearView:(UIView *) view2 parentView:(UIView *)containerView 
			   transType:(NSString *)transType transSubType:(NSString *) transSubType;

+(NSString *) getFilePath:(NSString *) fileName;

+(BOOL) checkResponse:(NSDictionary *) responseContent;
+(BOOL) checkResponseDoNotShowError:(NSDictionary *) responseContent;
+(BOOL) checkInput:(id) inputText  comment:(NSString *) comment;

+(void) alertException:(NSError*)error;

+(void) alertContent:(NSString *)content;

+(id) getTempContextValueByKey:(NSString *) key;

+(void) setTempContextValueByKey:(NSString *) key value:(id) value;

+(void) saveTempContextValue:(NSString *)fileName;

+(void) loadTempContextValue:(NSString *)fileName;

+(void) commitTempContextValue;

+(void) rollbackTempContextValue;

+(void) clearTempContextValue;

+(NSString *) transferToHtml:(NSString *) source;

+(void)performCommonLoading:(UIView *) containerView isStart:(BOOL)isStart;

+ (void)didStartNetworking;

+ (void)didStopNetworking;

+ (void)setKeyboardType:(UITextField *)textInput keyboardType:(NSString *)keyboardType;

// +(UINavigationController *) findRootNavCtrl:(UIViewController *) currView; 

+(NSString *)dictionaryToXml :(NSDictionary*)dic error : (NSString **)error;
/**use as NSDictionary *dic = [AppContext nsDataToObject:data encoding:NSUTF8StringEncoding];  this method returned object is auto release ,please don't release it.*/
+(id)nsDataToObject :(NSData*)data encoding:(NSStringEncoding)encoding;


+(void) setPreferenceByKey:(NSString *) key value:(id) value;

+(id) getPreferenceByKey:(NSString *) key  needMerge:(BOOL)needMerge;

@end
