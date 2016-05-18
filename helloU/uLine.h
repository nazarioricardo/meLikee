//
//  uLine.h
//  helloU
//
//  Created by Ricardo Nazario on 4/7/16.
//  Copyright © 2016 Ricardo Nazario. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>

extern const struct CloudKitLineFields {
    __unsafe_unretained NSString *identifier;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *level;
    __unsafe_unretained NSString *line;
} CloudKitLineFields;

@interface uLine : NSObject

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *level;
@property (nonatomic, strong) NSURL *url;

- (instancetype)initWithInputData:(id)inputData;

@end
