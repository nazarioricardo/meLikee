//
//  CloudKitManager.h
//  helloU
//
//  Created by Ricardo Nazario on 3/15/16.
//  Copyright © 2016 Ricardo Nazario. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Profile.h"
#import "uLine.h"

typedef void(^CloudKitCompletionHandler)(NSArray *results, NSError *error);
typedef void (^CloudKitImageHandler)(UIImage *resultImage, NSError *error);
typedef void (^CloudKitRecordCompletionHandler)(uLine *line, NSError *error);

@interface CloudKitManager : NSObject

@property NSArray *profilesArray;

+(void)fetchProfilesFromGender:(NSString *)gender withCompletionHandler:(CloudKitCompletionHandler)handler;
//+(void)fetchProfileDataFromGender:(NSString *)gender withCompletionHandler:(void (^)(NSArray *, CKQueryCursor *, NSError *))handler;
+(void)getNumberOfLinesFromProfile:(NSString *)profileName ofLevel:(NSString *)level withCompletionHandler:(CloudKitCompletionHandler)handler;
+(void)fetchLine:(NSString *)lineName withCompletionHandler:(CloudKitRecordCompletionHandler)handler;

@end
