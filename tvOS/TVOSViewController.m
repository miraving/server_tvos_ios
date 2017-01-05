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
@property (weak, nonatomic) IBOutlet UIView *indicator;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@end

@implementation TVOSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.buyButton setHidden:YES];
    [self.hintLabel setHidden:NO];
    
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
//    [self.server sendObject:sender.titleLabel.text];
    [self.server sendObject:@"http://www.centerstagetheatrekalamazoo.com/wp-content/uploads/sites/17/2014/05/ticket.png"];
}

#pragma mark - Async server delegate methods
- (void)server:(AsyncServer *)theServer didConnect:(AsyncConnection *)connection
{
    NSLog(@"didConnect");
    [self.indicator setBackgroundColor:[UIColor greenColor]];
    [self.buyButton setHidden:NO];
    [self.hintLabel setHidden:YES];
}

- (void)server:(AsyncServer *)theServer didDisconnect:(AsyncConnection *)connection
{
    NSLog(@"didDisconnect");
    [self.indicator setBackgroundColor:[UIColor redColor]];
    [self.buyButton setHidden:YES];
    [self.hintLabel setHidden:NO];
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
    [self.indicator setBackgroundColor:[UIColor yellowColor]];
    [self.hintLabel setHidden:NO];
    [self.buyButton setHidden:YES];
}

@end
