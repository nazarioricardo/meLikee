//
//  HelloViewController.m
//  helloU
//
//  Created by Ricardo Nazario on 2/27/16.
//  Copyright © 2016 Ricardo Nazario. All rights reserved.
//

#import "HelloViewController.h"
#import "Profile.h"

@interface HelloViewController ()
{
    NSMutableArray *_profilesArray;
}

@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *skipTutorial;

@property (nonatomic) NSString *gender;

-(void)saveToDefaults:(NSString *)chosenGender;

@end

@implementation HelloViewController

- (IBAction)genderSelected:(id)sender {

    if (sender == self.femaleButton) {
        self.gender = @"Female";
    } else {
        self.gender = @"Male";
    }
    
    [self saveToDefaults:self.gender];
    
    [self performSegueWithIdentifier:@"HelloSegue" sender:self];
    
}

- (IBAction)skipTutorial:(id)sender {
    
    [self.pageViewController.view removeFromSuperview];
    [self saveToDefaults:@"learned"];
    self.skipTutorial.hidden = YES;
}

- (IBAction)tutorial:(id)sender {
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 60);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    self.skipTutorial.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.femaleButton.layer.masksToBounds = YES;
    self.femaleButton.layer.cornerRadius = self.femaleButton.layer.frame.size.height/2;
    
    self.maleButton.layer.masksToBounds = YES;
    self.maleButton.layer.cornerRadius = self.maleButton.layer.frame.size.height/2;
    
    self.pageTitles = @[@"Welcome!", @"First Step:", @"Find a Match", @"Figure It Out!", @"Get a Room!"];
    self.pageInstructions = @[@"Turn the page to learn how to use the first offline online dating app!", @"Choose what gender you want to be. You can change later, we are gender fluid!", @"Find the match of your dreams! (That is, who you dream of being.)", @"Present your phone to any hotty that is physically near you, and let us do the talking ;).", @"You lucky ducky!"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *learned = [defaults objectForKey:@"learned"];
    
    if (!learned) {
        
        //Create page view controller
        self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
        self.pageViewController.dataSource = self;
        
        PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        // Change the size of page view controller
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 60);
        
        [self addChildViewController:_pageViewController];
        [self.view addSubview:_pageViewController.view];
        [self.pageViewController didMoveToParentViewController:self];
    } else {
        self.skipTutorial.hidden = YES;
    }
    
    

}

-(void)viewDidAppear:(BOOL)animated {
    
    NSLog(@"HelloViewController did appear");
    
    [self saveToDefaults:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *chosenGender = [defaults objectForKey:@"chosenGender"];
    NSLog(@"Loading with default %@", chosenGender);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveToDefaults:(NSString *)chosenGender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:chosenGender forKey:@"chosenGender"];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    UINavigationController *navc = [segue destinationViewController];
    UProfileListViewController *upvc = (UProfileListViewController *)[navc topViewController];
    
    // Pass the selected object to the new view controller.
    [upvc setSelectedGender:self.gender];
}

#pragma mark - PageView Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController *)viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = ((PageContentViewController *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    

    
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    
    
    
    //pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.instructionText = self.pageInstructions[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}


@end
