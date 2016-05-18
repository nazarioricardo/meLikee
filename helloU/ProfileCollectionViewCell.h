//
//  ProfileCollectionViewCell.h
//  helloU
//
//  Created by Ricardo Nazario on 4/3/16.
//  Copyright © 2016 Ricardo Nazario. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Profile.h"

@interface ProfileCollectionViewCell : UICollectionViewCell

+ (NSString *)reuseIdentifier;
+ (NSString *)nibName;

- (void)setProfile:(Profile *)profile;

@end
