//
//  AppDelegate.h
//  Magic Melody
//
//  Created by zixin cheng on 2016-11-24.
//  Copyright © 2016 zixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


//share between views
//songs components
@property ( strong, nonatomic) NSDictionary *MusicNote;
@property ( strong, nonatomic) NSMutableArray *MusicArray;

//selected file & record URL
@property ( strong, nonatomic) NSURL *RecordFileURL;
@property ( strong, nonatomic) NSURL *TrimmedRecordFileURL;


@property ( strong, nonatomic) NSURL *SelectedFileURL;



- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

