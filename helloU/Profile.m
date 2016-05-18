//
//  Profile.m
//  helloU
//
//  Created by Ricardo Nazario on 3/16/16.
//  Copyright © 2016 Ricardo Nazario. All rights reserved.
//

#import "Profile.h"


const struct CloudKitProfileFields CloudKitProfileFields = {
    .identifier = @"id",
    .name = @"name",
    .bio = @"bio",
    .gender = @"gender",
    .imageRef = @"imageRef",
    .image = @"image"
};

@implementation Profile

#pragma mark - Lifecycle

- (instancetype)initWithInputData:(id)inputData {
    self = [super init];
    if (self) {
        [self mapObject:inputData];
    }
    return self;
}

#pragma mark - Private

- (void)mapObject:(CKRecord *)object {
    
    _name = [object valueForKeyPath:CloudKitProfileFields.name];
    _bio = [object valueForKeyPath:CloudKitProfileFields.bio];
    _identifier = object.recordID.recordName;
    _gender = [object valueForKeyPath:CloudKitProfileFields.gender];
    _imageRef = [object valueForKeyPath:CloudKitProfileFields.imageRef];
    
    CKAsset *imageAsset = [object valueForKeyPath:CloudKitProfileFields.image];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageAsset.fileURL];
    _image = [UIImage imageWithData:imageData];
}

@end