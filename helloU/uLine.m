//
//  uLine.m
//  helloU
//
//  Created by Ricardo Nazario on 4/7/16.
//  Copyright © 2016 Ricardo Nazario. All rights reserved.
//

#import "uLine.h"

const struct CloudKitLineFields CloudKitLineFields = {
    .identifier = @"id",
    .name = @"name",
    .level = @"level",
    .line = @"line"
};

@implementation uLine

#pragma mark - LifeCycle

- (instancetype)initWithInputData:(id)inputData {
    self = [super init];
    if (self) {
        [self mapObject:inputData];
    }
    return self;
}

#pragma mark - Private

- (void)mapObject:(CKRecord *)object {
    
    _identifier = object.recordID.recordName;
    _name = [object valueForKeyPath:CloudKitLineFields.name];
    _level = [object valueForKeyPath:CloudKitLineFields.level];
    CKAsset *audioAsset = [object valueForKeyPath:CloudKitLineFields.line];
    _url = audioAsset.fileURL;
    
    //NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageAsset.fileURL];
}

@end
