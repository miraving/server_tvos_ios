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

@interface IOSViewController ()
@property (weak, nonatomic) IBOutlet UIView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *label;
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
    [self.indicator setBackgroundColor:[UIColor redColor]];
    [self createClient];
 
    [self cloudSetup];
}

// Cloud
- (void)cloudSetup
{
    CKQuerySubscription *qSubscription = [[CKQuerySubscription alloc] initWithRecordType:@"MyRecords"
                                                                               predicate:[NSPredicate predicateWithValue:YES]
                                                                                 options:CKQuerySubscriptionOptionsFiresOnRecordUpdate];
    
    CKNotificationInfo *notification = [[CKNotificationInfo alloc] init];
    [notification setShouldBadge:YES];
    
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

#pragma mark - Cloud
- (void)newObject:(NSString *)value
{
    NSString *ident = [NSString stringWithFormat:@"%lu", (unsigned long)[NSDate new].description.hash];
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:ident];
    CKRecord *record = [[CKRecord alloc] initWithRecordType:@"MyRecords" recordID:recordID];
    
    record[@"StringField"] = value;
    
    [self.publicDB saveRecord:record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        
        if (error == nil)
        {
            NSLog(@"Result: %@", record);
        }
        else
        {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        
    }];
}

#pragma mark - Actions
- (IBAction)sendCommand1:(UIButton *)sender
{
    NSString *tmp = sender.titleLabel.text;
    [self newObject:tmp];
}
- (IBAction)sendCommand2:(UIButton *)sender
{
    NSString *tmp = sender.titleLabel.text;
    [self newObject:tmp];
}
- (IBAction)sendCommand3:(UIButton *)sender
{
    NSString *tmp = sender.titleLabel.text;
    [self newObject:tmp];
}
@end
