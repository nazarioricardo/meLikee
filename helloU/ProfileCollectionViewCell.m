//
//  ProfileCollectionViewCell.m
//  helloU
//
//  Created by Ricardo Nazario on 4/3/16.
//  Copyright © 2016 Ricardo Nazario. All rights reserved.
//

#import "ProfileCollectionViewCell.h"

@interface ProfileCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ProfileCollectionViewCell

+(NSString *)reuseIdentifier {
    return @"ProfileCell";
}

+(NSString *)nibName {
    return NSStringFromClass([self class]);
}

#pragma mark - Public

-(void)setProfile:(Profile *)profile {
    self.nameLabel.text = profile.name;

    self.imageView.alpha = 0.f;
    self.imageView.image = profile.image;
    
    UIColor *borderColor = [UIColor colorWithRed:253.0/255.0 green:0.0/255.0 blue:143.0/255.0 alpha:1];
    
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height/2;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderWidth = 1.0;
    self.imageView.layer.borderColor = borderColor.CGColor;
    
    [UIView animateWithDuration:.3 animations:^{
        self.imageView.alpha = 1.f;
    }];
}

@end
