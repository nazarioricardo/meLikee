//
//  CloudKitManager.m
//  helloU
//
//  Created by Ricardo Nazario on 3/15/16.
//  Copyright © 2016 Ricardo Nazario. All rights reserved.
//

#import "CloudKitManager.h"

@interface CloudKitManager ()
{
    NSMutableArray *_profilesArray;
}

@end

@implementation CloudKitManager

+(CKDatabase *)publicCloudDatabase {
    return [[CKContainer defaultContainer] publicCloudDatabase];
}

// Retrieve existing profiles of selected gender
+(void)fetchProfilesFromGender:(NSString *)gender withCompletionHandler:(CloudKitCompletionHandler)handler {
    
    CKDatabase *database = [self publicCloudDatabase];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gender = %@", [gender lowercaseString]];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"uProfile" predicate:predicate];
    
    [database performQuery:query
                                inZoneWithID:nil
                           completionHandler:^(NSArray *results, NSError *error) {
                
                               if (!handler) return;
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   handler ([self mapProfiles:results], error);
                               });
                           }];
}

//+(void)fetchProfileDataFromGender:(NSString *)gender withCompletionHandler:(void (^)(NSArray *, CKQueryCursor *, NSError *))handler {
//    
//    CKDatabase *database = [self publicCloudDatabase];
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gender = %@", [gender lowercaseString]];
//    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"uProfile" predicate:predicate];
//    
//    CKQueryOperation *dataQueryOperation = [[CKQueryOperation alloc] initWithQuery:query];
//    dataQueryOperation.desiredKeys = @[@"gender", @"name"];
//    [database addOperation:dataQueryOperation];
//    
////    CKQueryOperation *imageQueryOperation = [[CKQueryOperation alloc] initWithQuery:query];
////    imageQueryOperation.desiredKeys = @[@"image"];
////    [database addOperation:imageQueryOperation];
//    
//    dataQueryOperation.recordFetchedBlock = ^(CKRecord *record) {
//        
//    };
//    
//    dataQueryOperation.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error) {
//        
//        if (error) {
//            // Handle the error
//        } else {
//            CKQueryOperation *cursorQueryOperation = [[CKQueryOperation alloc] initWithCursor:cursor];
//        }
//    };
//    
//}

+(void)getNumberOfLinesFromProfile:(NSString *)profileName ofLevel:(NSString *)level withCompletionHandler:(CloudKitCompletionHandler)handler {
    
    CKDatabase *database = [self publicCloudDatabase];
    NSMutableArray *tempResults = [[NSMutableArray alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name == %@) AND (level == %@)", profileName, level];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"uLine" predicate:predicate];
    
    CKQueryOperation *queryOp = [[CKQueryOperation alloc] initWithQuery:query];

    queryOp.desiredKeys = @[@"name"];
    queryOp.resultsLimit = CKQueryOperationMaximumResults;
    queryOp.database = database;
    
    queryOp.recordFetchedBlock = ^(CKRecord *record) {
        
        //NSLog(@"%@ fetched", record.recordID);
        
        [tempResults addObject:record];
        
    };
    
    queryOp.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error) {
        
        //NSLog(@"queryOp completion block called");
        
        if (!handler) return;
        
        NSArray *results = [[NSArray alloc] initWithArray:tempResults];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            handler (results, error);
        });
        
    };
    
    [database addOperation:queryOp];

}

+(void)fetchLine:(NSString *)lineName withCompletionHandler:(CloudKitRecordCompletionHandler)handler{
    
    CKDatabase *database = [self publicCloudDatabase];
    //CKReference *recordToMatch = [[CKReference alloc] initWithRecordID:profileID
    //                                                               action:CKReferenceActionDeleteSelf];
    
    CKRecordID *lineID = [[CKRecordID alloc] initWithRecordName:lineName];
    
    [database fetchRecordWithID:lineID
              completionHandler:^(CKRecord *record, NSError *error) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      handler ([self mapLine:record], error);
                  });
              }];
}



+(NSArray *)mapProfiles:(NSArray *)profiles {
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    [profiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Profile *profile = [[Profile alloc] initWithInputData:obj];
        [temp addObject:profile];
    }];
    
    return [NSArray arrayWithArray:temp];
}

+(uLine *)mapLine:(CKRecord *)lineToMap {
    
    uLine *line = [[uLine alloc] initWithInputData:lineToMap];
    
    return line;
}

@end
