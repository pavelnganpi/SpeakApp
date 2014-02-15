//
//  SpeakViewController.m
//  Speak
//
//  Created by Ian Perry on 2/15/14.
//  Copyright (c) 2014 SpeakTeam. All rights reserved.
//

#import "SpeakViewController.h"

@interface SpeakViewController () <WitDelegate, SocketIODelegate>
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) SocketIO *socket;
@end

@implementation SpeakViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [Wit sharedInstance].delegate = self;
 
    [self setUp];
    [self createSocket];
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

- (void)createSocket
{
    self.socket = [[SocketIO alloc] initWithDelegate:self];
    [self.socket connectToHost:@"107.170.21.35" onPort:3000];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObject:@"object"] forKeys:[NSArray arrayWithObject:@"key"]];
//    [self.socket sendEvent:@"event" withData:dict];
//    [self.socket sendMessage:@"hello"];
    
    SocketIOCallback cb = ^(id argsData) {
        NSDictionary *response = argsData;
        // do something with response
        NSLog(@"response: %@", [response description]);
    };
    [self.socket sendEvent:@"welcomeAck" withData:dict andAcknowledge:cb];
}

#pragma mark - WitDelegate methods

- (void)witDidGraspIntent:(NSString *)intent entities:(NSDictionary *)entities body:(NSString *)body error:(NSError *)e
{
    if (e)
    {
        NSLog(@"error: %@", [e localizedDescription]);
    }
    
    self.label.text = [NSString stringWithFormat:@"intent = %@", intent];
    NSLog(@"Entities: %@", [entities description]);
    [self.view addSubview:self.label];
    
    // send intent to socket
    [self.socket sendMessage:@"test"];
}



@end
