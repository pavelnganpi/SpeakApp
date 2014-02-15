//
//  SpeakViewController.m
//  Speak
//
//  Created by Ian Perry on 2/15/14.
//  Copyright (c) 2014 SpeakTeam. All rights reserved.
//

#import "SpeakViewController.h"
#import <Wit.h>

@interface SpeakViewController () <WitDelegate>
@property (strong, nonatomic) UILabel *label;
@end

@implementation SpeakViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [Wit sharedInstance].delegate = self;
 
    [self setUp];
}

- (void)setUp
{
    CGRect screen = [UIScreen mainScreen].bounds;
    CGFloat w = 100;
    CGRect rect = CGRectMake(screen.size.width/2 - w/2, 60, w, 100);
    
    WITMicButton *witButton = [[WITMicButton alloc] initWithFrame:rect];
    [self.view addSubview:witButton];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, screen.size.width, 50)];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];
    
}

#pragma mark - WitDelegate methods

- (void)witDidGraspIntent:(NSString *)intent entities:(NSDictionary *)entities body:(NSString *)body error:(NSError *)e
{
    if (e)
    {
        NSLog(@"error: %@", [e localizedDescription]);
    }
    
    self.label.text = [NSString stringWithFormat:@"intent = %@", intent];
    
    [self.view addSubview:self.label];
}



@end
