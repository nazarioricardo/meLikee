//
//  PageContentViewController.h
//  meLikee
//
//  Created by Ricardo Nazario on 5/11/16.
//  Copyright © 2016 Ricardo Nazario. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelloViewController.h"

@interface PageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (nonatomic) NSUInteger pageIndex;
@property (nonatomic) NSString *titleText;
@property (nonatomic) NSString *instructionText;
@property (nonatomic) NSString *imageFile;

@end
