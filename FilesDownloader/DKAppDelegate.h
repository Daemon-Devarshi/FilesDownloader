//
//  DKAppDelegate.h
//  FilesDownloader
//
//  Created by Support on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define USE_NSURLConnection_AND_Request 1

@interface DKAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (readwrite, retain) NSMutableArray *urlsArray;
@property (assign) NSInteger operationsProcessedCount;
@property (assign, getter = isProgressIndicatorVisible) BOOL progressIndicatorVisible; 


- (void)downloadFiles:(id)sender;

/*
 Shows open panel, to select download folder
 */
- (void)selectDownloadFolder;

@end
