//
//  LevelsViewController.m
//  helloU
//
//  Created by Ricardo Nazario on 2/27/16.
//  Copyright © 2016 Ricardo Nazario. All rights reserved.
//

#import "UProfilePageViewController.h"
#import "uLine.h"
@import AVFoundation;

@interface UProfilePageViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UILabel *findingLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *levelSelector;
@property (weak, nonatomic) IBOutlet UIButton *playAgainButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *findLineButton;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (nonatomic) NSString *selectedLevel; // From segment controller
@property (nonatomic) NSString *lineNumber; // Random number
@property (nonatomic) NSString *stringForQuery;
@property (nonatomic) uLine *selectedLine;

@end

@implementation UProfilePageViewController
- (IBAction)segmentChosen:(id)sender {
    
    long level = (long)self.levelSelector.selectedSegmentIndex;
    self.selectedLevel = [NSString stringWithFormat:@"%ld", level + 1];
}

- (IBAction)getLinePressed:(id)sender {
    
    [self fetchLine];
}

- (IBAction)playButtonPressed:(id)sender {
    BOOL played = [self.audioPlayer play];
    if (!played) {
        NSLog(@"Error");
    }
}

- (IBAction)stopButtonPressed:(id)sender {
    [self.audioPlayer stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"You selected %@", self.selectedProfile.name);
    self.imageView.image = self.selectedProfile.image;
    [self setTitle:self.selectedProfile.name];
    [self setSelectedLevel:@"1"];
    self.indicatorView.hidden = YES;
    
    UIColor *borderColor = [UIColor colorWithRed:253.0/255.0 green:0.0/255.0 blue:143.0/255.0 alpha:1];

    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2;
    self.imageView.layer.borderWidth = 1;
    self.imageView.layer.borderColor = borderColor.CGColor;
    
    NSLog(@"The image width is: %f", self.imageView.frame.size.width);
    
    self.findLineButton.layer.cornerRadius = self.findLineButton.frame.size.height/2;
    self.playAgainButton.layer.cornerRadius = self.playAgainButton.frame.size.height/2;
    self.stopButton.layer.cornerRadius = self.stopButton.frame.size.height/2;
    
    self.levelSelector.layer.cornerRadius = self.levelSelector.frame.size.height/2;

    
}

-(void)viewWillAppear:(BOOL)animated {
    [self setUpAudio];
}

#pragma mark - Private

-(void)fetchLine {
    
    [self shouldAnimateIndicator:YES];
    self.playAgainButton.hidden = YES;
    self.stopButton.hidden = YES;
    
    
    NSLog(@"%@ and level %@", self.selectedProfile.identifier, self.selectedLevel);
    
    __weak typeof(self) weakSelf = self;
    
    [CloudKitManager getNumberOfLinesFromProfile:self.selectedProfile.identifier
                                         ofLevel:self.selectedLevel
                           withCompletionHandler:^(NSArray *results, NSError *error) {
                               
                               __strong typeof(self) strongSelf = weakSelf;
                               
                               if (error) {
                            
                                   // Handle error
                                   NSLog(@"%@", error);
                                   [strongSelf shouldAnimateIndicator:NO];
                                   [weakSelf presentMessage:error.userInfo[NSLocalizedDescriptionKey]];
                               } else {
                                   
                                   int numberOfLines = (int)results.count;
                                   NSLog(@"There are %d lines to choose from", numberOfLines);
                                   int random = arc4random_uniform(numberOfLines) + 1;
                                   NSString *tempString = [NSString stringWithFormat:@"%d", random];
                                   self.lineNumber = tempString;
                                   
                                   self.stringForQuery = [self.selectedProfile.identifier stringByAppendingString:self.selectedLevel];
                                   self.stringForQuery = [self.stringForQuery stringByAppendingString:self.lineNumber];
                                   
                                   NSLog(@"The random line %@", self.stringForQuery);
                                   
                                   [CloudKitManager fetchLine:self.stringForQuery
                                        withCompletionHandler:^(uLine *line, NSError *error) {
                                            
                                            if (error) {
                                                
                                                // Handle error
                                                [weakSelf presentMessage:error.userInfo[NSLocalizedDescriptionKey]];
                                            } else {
                                                
                                                // Handle record
                                                self.selectedLine = line;
                                                self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:line.url
                                                                                                   fileTypeHint:@"mp3" error:&error]; // Handle Error
                                                BOOL played = [self.audioPlayer play];
                                                if (!played) {
                                                    NSLog(@"Error");
                                                }
                                                
                                                self.lineLabel.text = self.stringForQuery;
                                                
                                                [self shouldAnimateIndicator:NO];
                                                self.playAgainButton.hidden = NO;
                                                self.stopButton.hidden = NO;
                                                
                                            }
                                            [strongSelf shouldAnimateIndicator:NO];
                                        }];
                               }
                           }];
}

-(void)setUpAudio {
    NSError *error;
    
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    if (error) {
        NSAssert(error == nil, @"");
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error) {
        NSAssert(error == nil, @"");
    }
    
//    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"gabo1-2" withExtension:@"mp3"];
//    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
//    if (error) {
//        NSAssert(error == nil, @"");
//    }
    
    [self.audioPlayer setVolume:0.8];
    [self.audioPlayer prepareToPlay];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
