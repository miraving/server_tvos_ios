//
//  TVOSViewController.m
//  tvOS
//
//  Created by Vitalii Obertynskyi on 12/26/16.
//
//

#import "TVOSViewController.h"
#import "Defines.h"
#import <CloudKit/CloudKit.h>

@interface TVOSViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *indicator;
// CloudKit
@property (nonatomic, strong) CKContainer *cloudContainer;
@property (nonatomic, strong) CKDatabase *publicDB;
@property (nonatomic, strong) CKDatabase *privateDB;

@end

@implementation TVOSViewController

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

#pragma mark - CloudKit
- (void)cloudSetup
{
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError *error) {
        if (accountStatus == CKAccountStatusNoAccount) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign in to iCloud"
                                                                           message:@"Sign in to your iCloud account to write records. On the Home screen, launch Settings, tap iCloud, and enter your Apple ID. Turn iCloud Drive on. If you don't have an iCloud account, tap Create a new Apple ID."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Okay"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            [self loadCloudData];
        }
    }];
}

- (void)loadCloudData
{
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];//predicateWithFormat:@"StringField == '222'"];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"MyRecords" predicate:predicate];
    [self.publicDB performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> *results, NSError *error) {
       
        if (error == nil)
        {
            NSLog(@"Results: %@", results);
        }
        else
        {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

#pragma mark - Actions
- (IBAction)sendCommand:(UIButton *)sender
{
    NSString *ident = [NSString stringWithFormat:@"%lu", (unsigned long)[NSDate new].description.hash];
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:ident];
    CKRecord *record = [[CKRecord alloc] initWithRecordType:@"MyRecords" recordID:recordID];
    
    record[@"StringField"] = @"http://www.ticketmaster.com/";

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

@end
