//
//  AppContext.m
//  ClaimApp
//
//  Created by administrator on 1/6/11.
//  Copyright 2011 eBao. All rights reserved.
//

#import "AppContext.h"
#import <QuartzCore/QuartzCore.h>

static NSDictionary *Names;
static NSArray *Keys;
static NSMutableString *userToken;
static NSMutableDictionary *TempKeyValues;
static NSMutableDictionary *BackupTempKeyValues;
static NSInteger networkingCount = 0;

@implementation AppContext


+ (void)initialize{
	NSLog(@"AppContext init");
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"AppEnv" ofType:@"plist"];
	NSDictionary *dict =[[NSDictionary alloc] initWithContentsOfFile:path];
	Names = dict;
	// [dict release];
    //NSLog(@"Dictionary %@", Names);
	
	NSArray *array = [[Names allKeys] sortedArrayUsingSelector:@selector(compare:)];
	Keys = array;
	
	// NSLog(@"Length %@", [Names count]);
}

+(NSString *) getContextValueByKey:(NSString *) key{
	// NSArray *array = [Names objectForKey:key];
	
	// NSLog(@"Val Ary %@", array);
	if ([Names objectForKey:[key stringByAppendingString:[AppContext getAppMode]]] !=nil) {
		return [Names objectForKey:[key stringByAppendingString:[AppContext getAppMode]]];
	}else {
		return [Names objectForKey:key];
	}	
}

+(NSString *) getServiceUrl:(NSString *) serviceKey{

	return [NSString stringWithFormat:@"%@%@&serviceVersion=%@&ct=%i&cv=%@&ugdi=%@&appkey=%@",[self getContextValueByKey:@"AppServer"],[AppContext getContextValueByKey:serviceKey],[AppContext getContextValueByKey:@"AppVersion"],[[UIDevice currentDevice] userInterfaceIdiom],[[UIDevice currentDevice] systemVersion],[AppContext getTempContextValueByKey:kUniqueGlobalDeviceIdentifierKey],[AppContext getTempContextValueByKey:kUniqueAppKey]];
} 

+(NSString *) getAppMode{
	return [Names objectForKey:@"AppMode"];
}

+(void) setUserToken:(NSString *) token{
	// NSString *ctoken = [Names objectForKey:@"UserToken"];
	userToken = [NSMutableString stringWithString:token];
}

+(NSString *) getUserToken{
	return userToken;
}

+(void)performTransition:(UIView *) view1 toAppearView:(UIView *) view2 parentView:(UIView *)containerView 
			   transType:(NSString *)transType transSubType:(NSString *) transSubType
{
	// First create a CATransition object to describe the transition
	CATransition *transition = [CATransition animation];
	// Animate over 3/4 of a second
	transition.duration = 0.50;
	// using the ease in/out timing function
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	// Now to set the type of transition. Since we need to choose at random, we'll setup a couple of arrays to help us.
	// NSString *types[4] = {kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
	// NSString *subtypes[4] = {kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
	if (transType != nil) {
		transition.type = transType;
	}else {
		transition.type = kCATransitionMoveIn;
	}
	
	if (transSubType != nil) {
		transition.subtype = transSubType;
	}else {
		transition.subtype = kCATransitionFromRight;
	}
	
	// NSLog(@"Transition type %@", transition);
	
	// Finally, to avoid overlapping transitions we assign ourselves as the delegate for the animation and wait for the
	// -animationDidStop:finished: message. When it comes in, we will flag that we are no longer transitioning.
	// transitioning = YES;
	transition.delegate = self;
	
	// Next add it to the containerView's layer. This will perform the transition based on how we change its contents.
	[containerView.layer addAnimation:transition forKey:nil];
	
	[containerView addSubview:view2];
	
	// Here we hide view1, and show view2, which will cause Core Animation to animate view1 away and view2 in.
	view1.hidden = YES;
	view2.hidden = NO;
	
	// And so that we will continue to swap between our two images, we swap the instance variables referencing them.
	// UIImageView *tmp = view2;
	// view2 = view1;
	// view1 = tmp;
}

+(NSString *) getFilePath:(NSString *) fileName{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+(BOOL) checkResponse:(NSDictionary *) responseContent{
    
    if (!responseContent || ![responseContent isKindOfClass:[NSDictionary class]]) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示", nil)
													  message: NSLocalizedString(@"Unknown response data format", nil)
													 delegate:nil 
											cancelButtonTitle:NSLocalizedString(@"OK", @"")  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
        
        return NO;
    }
    
	NSString *errCode = [responseContent objectForKey:@"ERR_CODE"];
	NSString *responseCode = [responseContent objectForKey:@"RESPONSE_CODE"];
	
	NSString *alertMsg = @"";
	if (errCode != nil) {
		alertMsg = [responseContent objectForKey:@"ERR_MSG"];
		if (alertMsg == nil) {
			alertMsg = [AppContext getContextValueByKey:errCode];
		}
	}else if (responseCode != nil) {
		alertMsg = [responseContent objectForKey:@"RESPONSE_MSG"];
		if (alertMsg == nil) {
			alertMsg = [AppContext getContextValueByKey:responseCode];
		}
	}
	
	if (errCode != nil || responseCode != nil) {
		UIAlertView *alert =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示", nil)
													  message: NSLocalizedString(alertMsg, nil)
													 delegate:nil 
											cancelButtonTitle:NSLocalizedString(@"OK", @"")  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
	}
		
	if (errCode == nil) {
		return YES;
	}
	return NO;
}

+(BOOL) checkResponseDoNotShowError:(NSDictionary *) responseContent{
    
    if (!responseContent || ![responseContent isKindOfClass:[NSDictionary class]]) {
        
        return NO;
    }
    
    NSString *errCode = [responseContent objectForKey:@"ERR_CODE"];
    NSString *responseCode = [responseContent objectForKey:@"RESPONSE_CODE"];
    
    NSString *alertMsg = @"";
    if (errCode != nil) {
        alertMsg = [responseContent objectForKey:@"ERR_MSG"];
        if (alertMsg == nil) {
            alertMsg = [AppContext getContextValueByKey:errCode];
        }
    }else if (responseCode != nil) {
        alertMsg = [responseContent objectForKey:@"RESPONSE_MSG"];
        if (alertMsg == nil) {
            alertMsg = [AppContext getContextValueByKey:responseCode];
        }
    }
    
    if (errCode != nil || responseCode != nil) {
       
    }
    
    if (errCode == nil) {
        return YES;
    }
    return NO;
}


+(BOOL) checkInput:(id) inputText  comment:(NSString *) comment{
    if ([inputText isKindOfClass:[UITextField class]] && (inputText == nil || [inputText text].length == 0)) {
        if (comment) {
            [AppContext alertContent:comment];
        }
        
        [inputText becomeFirstResponder];
        
        return NO;
    }else if (inputText == nil || ([inputText isKindOfClass:[NSString class]] && (inputText == nil || [inputText length] == 0))) {
        if (comment) {
            [AppContext alertContent:comment];
        }
        
        return NO;
    }
    
    return YES;
}

+(void) alertException:(NSError*)error{
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示", @"")
                                                  message: [error description]
                                                 delegate:nil 
                                        cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [alert show];
    [alert release];
}

+(void) alertContent:(NSString *)content{
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示", @"")
                                                  message: content
                                                 delegate:nil 
                                        cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    
    [alert show];
    [alert release];
}

+(id) getTempContextValueByKey:(NSString *) key{
	if (TempKeyValues == nil) {
		TempKeyValues = [[NSMutableDictionary alloc] init];	        
	}
    
    if (BackupTempKeyValues == nil) {
        BackupTempKeyValues = [[NSMutableDictionary alloc] init];
    }
	
	return [TempKeyValues objectForKey:key];
}

+(void) setTempContextValueByKey:(NSString *) key value:(id) value{
	[AppContext getTempContextValueByKey:@"INIT"];
    
    // backup
    if ([BackupTempKeyValues objectForKey:key] == nil) {
        if ([AppContext getTempContextValueByKey:key]!= nil) {
            [BackupTempKeyValues setValue:[AppContext getTempContextValueByKey:key] forKey:key];
        }else
        {
            [BackupTempKeyValues setValue:kEmptyTempKeyValue forKey:key];
        }
    } 
	
	if (value != nil) {
		[TempKeyValues setValue:value forKey:key];
	}else {
		[TempKeyValues removeObjectForKey:key];
	}
	
}

+(void) saveTempContextValue:(NSString *)fileName{
    [TempKeyValues writeToFile:[AppContext getFilePath: [NSString stringWithFormat:@"%@.plist",fileName]] atomically:YES];
    [BackupTempKeyValues removeAllObjects];
}

+(void) loadTempContextValue:(NSString *)fileName{
    TempKeyValues = [[NSMutableDictionary alloc] initWithContentsOfFile:[AppContext getFilePath: [NSString stringWithFormat:@"%@.plist",fileName]]];	
    
    [BackupTempKeyValues removeAllObjects];
}

+(void) commitTempContextValue{
    [BackupTempKeyValues removeAllObjects];
}

+(void) rollbackTempContextValue{
    NSArray *keys = [BackupTempKeyValues allKeys];
    for (NSString *key in keys) {
        if (![key isEqualToString:@"_EBAO_CLM_CASE_ID"]) {
            if ([[BackupTempKeyValues objectForKey:key] isEqual:kEmptyTempKeyValue]) {
                [AppContext setTempContextValueByKey:key value:nil];
            }else{
                [AppContext setTempContextValueByKey:key value:[BackupTempKeyValues objectForKey:key]];
            }
        }
    }
    
    [BackupTempKeyValues removeAllObjects];
}

+(void) clearTempContextValue{
    [TempKeyValues removeAllObjects];
    [BackupTempKeyValues removeAllObjects];
}

+(NSString *) transferToHtml:(NSString *) source{
	return [[[source stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"] 
				stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"] stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
}

+(void)performCommonLoading:(UIView *) containerView isStart:(BOOL)isStart{
		
	UIActivityIndicatorView *loading = (UIActivityIndicatorView *)[containerView viewWithTag: kCommonLoadingViewTag];
	if (loading == nil) {
		loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		// [loading startAnimating];
		loading.frame = CGRectMake(containerView.center.x - 20, containerView.center.y - 80, 40, 40);
		loading.tag = kCommonLoadingViewTag;
        loading.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		[containerView addSubview:loading];
	}
		
	if (isStart) {
		[loading startAnimating];
	}else {
		[loading stopAnimating];
	}
}

+ (void)didStartNetworking
{
    networkingCount += 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

+ (void)didStopNetworking
{
    //assert(networkingCount > 0);
    networkingCount -= 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = (networkingCount != 0);
}

+ (void)setKeyboardType:(UITextField *)textInput keyboardType:(NSString *)keyboardType{
    if ([keyboardType isEqualToString:@"PhonePad"]) {
        textInput.keyboardType = UIKeyboardTypePhonePad;
    }else if ([keyboardType isEqualToString:@"Email"]) {
        textInput.keyboardType = UIKeyboardTypeEmailAddress;
    }else if ([keyboardType isEqualToString:@"NumberPad"]) {
        textInput.keyboardType = UIKeyboardTypeNumberPad;
    }else{
        textInput.keyboardType = UIKeyboardTypeDefault;
    }
}

+(NSString *)dictionaryToXml :(NSDictionary*)dic error : (NSString **)error{
    NSData *xmlData = [NSPropertyListSerialization dataFromPropertyList:dic format:kCFPropertyListXMLFormat_v1_0 errorDescription:error];
    NSString *s=[[[NSString alloc] initWithData:xmlData encoding: NSUTF8StringEncoding]autorelease];
    return s;
}

+(id)nsDataToObject :(NSData*)data encoding:(NSStringEncoding)encoding{
    if(data == nil)
        return nil;
    
    NSString *string = [[NSString alloc]initWithData:data encoding:encoding];
    //NSLog(@"doc=%@",string);
    
    @try {
        id result = [string propertyList];
        
        return result;
    }
    @catch (NSException *exception) {
        [AppContext alertContent:[exception description]];
        return nil;
    }
    @finally {
        //[string release];
    }
}

+(void) setPreferenceByKey:(NSString *) key value:(id) value{
    //NSLog(@"-------- setPreferenceByKey key: %@ value: %@", key,value);
    
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")) {
        
        NSUbiquitousKeyValueStore *cloudKeyVaue = [NSUbiquitousKeyValueStore defaultStore];
        
        if ([cloudKeyVaue synchronize]) {
            [cloudKeyVaue setObject:value forKey:key];
        }else {
            NSLog(@"--------- iCloud Sync Fail");
        } 
    }
}

+(id) getPreferenceByKey:(NSString *) key needMerge:(BOOL)needMerge{
    NSString *localVal = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    NSString *cloudVal = nil;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")) {
        
        NSUbiquitousKeyValueStore *cloudKeyVaue = [NSUbiquitousKeyValueStore defaultStore];
        
        if ([cloudKeyVaue synchronize]) {
            cloudVal = [cloudKeyVaue stringForKey:key];
        } else {
            NSLog(@"--------- iCloud Sync Fail");
        } 
    }
    
    //NSLog(@"---- getPreferenceByKey \nkey = %@ \nlocal = %@  \ncloud = %@", key, localVal, cloudVal);
    
    if (needMerge && cloudVal && localVal) {
        cloudVal = [NSString stringWithFormat:@"%@,%@", cloudVal,localVal];
    }
    
    //NSLog(@"---- getPreferenceByKey \nreturn = %@", cloudVal? cloudVal : localVal);
    
    return cloudVal? cloudVal : localVal;
}

@end
