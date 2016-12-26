//
//  TVOSViewController.m
//  tvOS
//
//  Created by Vitalii Obertynskyi on 12/26/16.
//
//

#import "TVOSViewController.h"
#import "AsyncServer.h"
#import "Defines.h"

@interface TVOSViewController () <AsyncServerDelegate>
@property (nonatomic, strong) AsyncServer *server;

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation TVOSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.server = [[AsyncServer alloc] init];
    [self.server setServiceType:kServiceType];
    [self.server setServiceName:kServiceName];
    [self.server setPort:kServicePort];
    [self.server setDelegate:self];
    
    [self.server start];
}

#pragma mark - Actions
- (IBAction)sendCommand:(UIButton *)sender
{
    [self.server sendObject:sender.titleLabel.text];
}

#pragma mark - Async server delegate methods
- (void)server:(AsyncServer *)theServer didConnect:(AsyncConnection *)connection
{
    NSLog(@"didConnect");
}

- (void)server:(AsyncServer *)theServer didDisconnect:(AsyncConnection *)connection
{
    NSLog(@"didDisconnect");
}

- (void)server:(AsyncServer *)theServer didReceiveCommand:(AsyncCommand)command object:(id)object connection:(AsyncConnection *)connection
{
    NSLog(@"didReceiveCommand -> %@", object);
    NSLog(@"Service.connection: %@", theServer.connections);
    
    [self.label setText:[NSString stringWithFormat:@"Recived: %@", object]];
}

- (void)server:(AsyncServer *)theServer didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error.localizedDescription);
}

@end
