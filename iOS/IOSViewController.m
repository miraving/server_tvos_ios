//
//  IOSViewController.m
//  ios
//
//  Created by Vitalii Obertynskyi on 12/26/16.
//
//

#import "IOSViewController.h"
#import "Defines.h"
#import <CloudKit/CloudKit.h>
#import <SafariServices/SafariServices.h>

@interface IOSViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buyButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

// CloudKit
@property (nonatomic, strong) CKContainer *cloudContainer;
@property (nonatomic, strong) CKDatabase *publicDB;
@property (nonatomic, strong) CKDatabase *privateDB;

@end

@implementation IOSViewController

- (void)loadView
{
    [super loadView];
    
    // CloudKit
    self.cloudContainer = [CKContainer containerWithIdentifier:kDefaultContainerIdentifier];
    self.publicDB = self.cloudContainer.publicCloudDatabase;
    self.privateDB = self.cloudContainer.privateCloudDatabase;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self cloudSetup];
}

// Cloud
- (void)cloudSetup
{
    CKQuerySubscription *qSubscription = [[CKQuerySubscription alloc] initWithRecordType:@"MyRecords"
                                                                               predicate:[NSPredicate predicateWithValue:YES]
                                                                                 options:CKQuerySubscriptionOptionsFiresOnRecordCreation];
    
    CKNotificationInfo *notification = [[CKNotificationInfo alloc] init];
//    [notification setShouldBadge:YES];
    [notification setAlertBody:@"Tap to buy ticket..."];
    [notification setShouldSendContentAvailable:YES];
    
    [qSubscription setNotificationInfo:notification];
    [self.publicDB saveSubscription:qSubscription completionHandler:^(CKSubscription *subscription, NSError *error) {
        
        if (error == nil)
        {
            NSLog(@"Result: %@", subscription);
        }
        else
        {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (void)fetchRemoteTicket
{
    if (self.reciveObjectID)
    {
        CKRecordID *objID = [[CKRecordID alloc] initWithRecordName:self.reciveObjectID];
        [self.publicDB fetchRecordWithID:objID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
            
            NSLog(@"%@", record);
            
            if (error == nil)
            {
                NSString *str = record[@"StringField"];
                NSURL *url = [NSURL URLWithString:str];
                if (url)
                {
                    SFSafariViewController *controller = [[SFSafariViewController alloc] initWithURL:url];
                    [self.navigationController presentViewController:controller animated:YES completion:^{
                        
                        [self.publicDB deleteRecordWithID:record.recordID completionHandler:^(CKRecordID * _Nullable recordID, NSError * _Nullable error) {
                            
                            NSLog(@"Delete record complite! Error: %@", error.localizedDescription);
                        }];
                    }];
                }
            }
        }];
    }
}

- (void)setReciveObjectID:(NSString *)value
{
    _reciveObjectID = [value copy];
    [self fetchRemoteTicket];
}

#pragma mark - Actions
- (void)refteshTap:(id)sender
{
    
}

- (void)buyTap:(id)sender
{
    
}

@end
