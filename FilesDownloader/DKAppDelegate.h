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

@property (unsafe_unretained) IBOutlet NSWindow *window;
@property (readwrite, strong) NSMutableArray *urlsArray;

@property (assign, getter = isProgressIndicatorVisible) BOOL progressIndicatorVisible; 


- (void)downloadFiles:(id)sender;

/*
 Shows open panel, to select download folder
 */
- (void)selectDownloadFolder;

@end
