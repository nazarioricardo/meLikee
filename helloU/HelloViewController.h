//
//  HelloViewController.h
//  helloU
//
//  Created by Ricardo Nazario on 2/27/16.
//  Copyright © 2016 Ricardo Nazario. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>
#import "UProfileListViewController.h"
#import "PageContentViewController.h"
@class Profile;

@interface HelloViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageInstructions;

@end
