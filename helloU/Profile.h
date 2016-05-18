//
//  Profile.h
//  helloU
//
//  Created by Ricardo Nazario on 3/16/16.
//  Copyright © 2016 Ricardo Nazario. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>

extern const struct CloudKitProfileFields {
    __unsafe_unretained NSString *identifier;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *bio;
    __unsafe_unretained NSString *gender;
    __unsafe_unretained NSString *imageRef;
    __unsafe_unretained NSString *image;
} CloudKitProfileFields;

@interface Profile : NSObject

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *bio;
@property (nonatomic, copy, readonly) NSString *gender;
@property (nonatomic, copy, readonly) NSString *imageRef;
@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithInputData:(id)inputData;

@end
