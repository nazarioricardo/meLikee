//
//  UProfileViewController.m
//  helloU
//
//  Created by Ricardo Nazario on 2/27/16.
//  Copyright © 2016 Ricardo Nazario. All rights reserved.
//

#import "UProfileListViewController.h"
#import "Profile.h"

@interface UProfileListViewController ()

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UILabel *findingLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *UProfileCollectionView;

@property (nonatomic) Profile *selectedProfile;
@property (nonatomic) NSArray *recordsArray;

@end

@implementation UProfileListViewController

#pragma mark - IBActions

- (IBAction)changeGender:(id)sender {
    
    self.profilesArray = nil;
    
    [self.UProfileCollectionView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.UProfileCollectionView.numberOfSections)]];
        
    if ([self.selectedGender isEqualToString:@"Female"]) {
        self.selectedGender = @"Male";
    } else {
        self.selectedGender = @"Female";
    }
    NSLog(@"Changing to %@", self.selectedGender);
    NSLog(@"The array is %@", self.profilesArray);
     
     self.findingLabel.text = @"Sex change!";
    
    [self updateGender:self.selectedGender];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self.view setBackgroundColor:[UIColor colorWithRed:212.0/255.0 green:184.0/255.0 blue:225.0/255.0 alpha:1]];
     UIColor *navColor = [UIColor colorWithRed:63.0/255.0 green:93.0/255.0 blue:255.0/255.0 alpha:1];
     UIColor *buttonColor = [UIColor colorWithRed:255.0/255.0 green:220.0/255.0 blue:251.0/255.0 alpha:1];
     
     [[UINavigationBar appearance] setTranslucent:NO];
     
     UINavigationBar.appearance.barTintColor = navColor;
     
     [[UINavigationBar appearance] setTintColor:buttonColor];
     [[UINavigationBar appearance] setTitleTextAttributes:
      [NSDictionary dictionaryWithObjectsAndKeys:
       [UIColor whiteColor], NSForegroundColorAttributeName,
       [UIFont fontWithName:@"Gill Sans" size:16.0], NSFontAttributeName,nil]];

}
-(void)viewWillAppear:(BOOL)animated {
     
    if (!self.profilesArray) {
        
        [self updateGender:_selectedGender];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)updateGender:(NSString *)chosenGender {
    [self shouldAnimateIndicator:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [CloudKitManager fetchProfilesFromGender:chosenGender
                       withCompletionHandler: ^(NSArray *results, NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (error) {
            // Present error message
            NSLog(@"%@", error);
            [weakSelf presentMessage:error.userInfo[NSLocalizedDescriptionKey]];
        } else {
            //NSMutableArray *tempProfilesArray = [[NSMutableArray alloc] initWithArray:results];
            strongSelf.profilesArray = results;
            
            [strongSelf.UProfileCollectionView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.UProfileCollectionView.numberOfSections)]];
        }
        [strongSelf shouldAnimateIndicator:NO];
    }];
}

- (void)presentMessage:(NSString *)errorMsg {
    
    UIAlertController *alert = [UIAlertController
                                 alertControllerWithTitle:NSLocalizedString(@"Error!", nil)
                                 message:errorMsg
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Okay"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                              [alert dismissViewControllerAnimated:YES
                                                                                        completion:nil];
                                                          }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)shouldAnimateIndicator:(BOOL)animate {
    if (animate) {
        self.findingLabel.hidden = NO;
        self.indicatorView.hidden = NO;
        [self.indicatorView startAnimating];
    } else {
        self.findingLabel.hidden = YES;
        self.indicatorView.hidden = YES;
        [self.indicatorView stopAnimating];
    }
    self.view.userInteractionEnabled = !animate;
}

#pragma mark - UICollectionView Data

// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return [self.profilesArray count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProfileCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:[ProfileCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    
    Profile *current = [self.profilesArray objectAtIndex:indexPath.row];
    
    //UIColor *borderColor = [UIColor colorWithRed:255.0/255.0 green:177.0/255.0 blue:221.0/225.0 alpha:1];
    
     cell.layer.masksToBounds = YES;
     cell.layer.cornerRadius = cell.layer.frame.size.width/2;
     cell.layer.backgroundColor = (__bridge CGColorRef _Nullable)([UIColor colorWithWhite:0 alpha:0]);
     
     [cell setProfile:current];
    
    return cell;
}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Select Item

    self.selectedProfile = self.profilesArray[indexPath.row];
    [self performSegueWithIdentifier:@"ProfileSegue" sender:self];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    UProfilePageViewController *uppvc = [segue destinationViewController];
    
    [uppvc setSelectedProfile:self.selectedProfile];
    
    // Pass the selected object to the new view controller.
}

@end