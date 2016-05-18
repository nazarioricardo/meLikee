//
//  UProfileViewController.h
//  helloU
//
//  Created by Ricardo Nazario on 2/27/16.
//  Copyright © 2016 Ricardo Nazario. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UProfilePageViewController.h"
#import "ProfileCollectionViewCell.h"
#import "CloudKitManager.h"

@class Profile;

@interface UProfileListViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) NSString *selectedGender;
@property (nonatomic) NSArray *profilesArray;
//@property (nonatomic) NSArray *biosArray;

@end
