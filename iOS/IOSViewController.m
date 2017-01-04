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
#import <SafariServices/SafariServices.h>


@interface IOSViewController () <AsyncClientDelegate>
@property (nonatomic, strong) AsyncClient *client;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buyButton;

@property (nonatomic, copy) NSString *recivedURL;
@end

@implementation IOSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.buyButton setEnabled:NO];
    [self.buyButton setTarget:self];
    [self.buyButton setAction:@selector(buyTap:)];
    
    [self.refreshButton setEnabled:YES];
    [self.refreshButton setTarget:self];
    [self.refreshButton setAction:@selector(refreshTap:)];
    
    [self createClient];
    
#if DEBUG
//    [self.buyButton setEnabled:YES];
//    [self setRecivedURL:@"http://google.com.ua/"];
#endif
}
- (void)createClient
{
    if (self.client != nil)
    {
        [self.client stop];
        self.client = nil;
    }
    
    self.client = [[AsyncClient alloc] init];
    [self.client setServiceType:kServiceType];
    [self.client setDelegate:self];
    [self.client setAutoConnect:YES];
    [self.client setIncludesPeerToPeer:YES];
    [self.client start];
}
#pragma mark - Actions
- (void)refreshTap:(id)sender
{
    [self createClient];
}

- (void)buyTap:(id)sender
{
    if (self.recivedURL.length > 0)
    {
        NSURL *url = [NSURL URLWithString:self.recivedURL];
        if (url)
        {
            SFSafariViewController *controller = [[SFSafariViewController alloc] initWithURL:url];
            [self.navigationController presentViewController:controller animated:YES completion:nil];
        }
    }
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
    [self.refreshButton setEnabled:NO];
}

- (void)client:(AsyncClient *)theClient didDisconnect:(AsyncConnection *)connection
{
    NSLog(@"didDisconnect");
    [self.refreshButton setEnabled:YES];
}

- (void)client:(AsyncClient *)theClient didReceiveCommand:(AsyncCommand)command object:(id)object connection:(AsyncConnection *)connection
{
    NSLog(@"didReceiveCommand");
    NSLog(@"%@", object);
    if ([object isKindOfClass:[NSString class]])
    {
        self.recivedURL = object;
        [self.buyButton setEnabled:YES];
    }
    else
    {
        [self.buyButton setEnabled:NO];
    }
}

- (void)client:(AsyncClient *)theClient didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
    [self.buyButton setEnabled:NO];
    [self.refreshButton setEnabled:YES];
}


@end
