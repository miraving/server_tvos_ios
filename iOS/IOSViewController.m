//
//  IOSViewController.m
//  ios
//
//  Created by Vitalii Obertynskyi on 12/26/16.
//
//

#import "IOSViewController.h"
#import "AsyncClient.h"
#import "Defines.h"


@interface IOSViewController () <AsyncClientDelegate>
@property (nonatomic, strong) AsyncClient *client;

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation IOSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.client = [[AsyncClient alloc] init];
    [self.client setServiceType:kServiceType];
    [self.client setDelegate:self];
    [self.client setAutoConnect:YES];
    [self.client setIncludesPeerToPeer:YES];
    [self.client start];
}
#pragma mark - Actions
- (IBAction)sendCommand:(UIButton *)sender
{
    NSString *tmp = sender.titleLabel.text;
    [self.client sendObject:tmp];
}
- (IBAction)sendCommand2:(UIButton *)sender
{
    NSString *tmp = sender.titleLabel.text;
    [self.client sendObject:tmp];

}
#pragma mark - Async client delegate methods
- (BOOL)client:(AsyncClient *)theClient didFindService:(NSNetService *)service moreComing:(BOOL)moreComing
{
    NSLog(@"service:\n%@\n%@",  service.name, service.type);
    
    if (moreComing)
    {
        if ([service.name isEqualToString:kServiceName] &&
            [service.type isEqualToString:kServiceType])
        {
            return YES;
        }
        return NO;
    }
    
    return YES;
}

- (void)client:(AsyncClient *)theClient didConnect:(AsyncConnection *)connection
{
    NSLog(@"didConnect:");
}

- (void)client:(AsyncClient *)theClient didDisconnect:(AsyncConnection *)connection
{
    NSLog(@"didDisconnect");
}

- (void)client:(AsyncClient *)theClient didReceiveCommand:(AsyncCommand)command object:(id)object connection:(AsyncConnection *)connection
{
    NSLog(@"didReceiveCommand");
    NSLog(@"%@", object);
    [self.label setText:[NSString stringWithFormat:@"Recived: %@", object]];
}

- (void)client:(AsyncClient *)theClient didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
}


@end
