//
//  DKAppDelegate.m
//  FilesDownloader
//
//  Created by Support on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKAppDelegate.h"
#import "DKDownloadOperation.h"


@interface DKAppDelegate ()
@property (readwrite, retain) NSOperationQueue *operationQueue;
@end

@implementation DKAppDelegate

@synthesize window = _window;
@synthesize urlsArray = _urlsArray;
@synthesize operationQueue = _operationQueue;
@synthesize operationsProcessedCount = _operationsProcessedCount;
@synthesize progressIndicatorVisible = _progressIndicatorVisible;

- (void)dealloc
{
    [_urlsArray release];
    [super dealloc];
}
	
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    _urlsArray = [[NSMutableArray alloc] initWithCapacity:2];
    
}

- (void)downloadFiles:(id)sender {
    // initializing operation queue
    if (!self.operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
        [self.operationQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    }
    [self.operationQueue cancelAllOperations];
    
    NSArray *filePaths = [[NSArray alloc] initWithArray:[self.urlsArray valueForKeyPath:@"fileURL"]];
    
    // initializing properties on which state of progress indicator depends
    self.operationsProcessedCount = 0; // for current value
    self.progressIndicatorVisible = YES; // to show indicator
    // max value is obtained from urlsArray count
    
    for (NSString *filePath in filePaths)
    {
        NSURL *fileURL = [[NSURL alloc] initWithString:filePath];
        DKDownloadOperation *aDownloadOperation = [[DKDownloadOperation alloc] initWithURL:fileURL downloadPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"downloadFolderPath"]];
        
        // Adding observer for operation
        [aDownloadOperation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:nil];
        
        [self.operationQueue addOperation:aDownloadOperation];
    }
   
}

- (void)selectDownloadFolder
{
    // initializing and configuring open panel
    NSOpenPanel *downloadFolderSelectOpenPanel = [NSOpenPanel openPanel];
    [downloadFolderSelectOpenPanel setCanChooseFiles:NO];
    [downloadFolderSelectOpenPanel setCanChooseDirectories:YES];
    [downloadFolderSelectOpenPanel setCanCreateDirectories:YES];
    
    [downloadFolderSelectOpenPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
            
        if (result == NSFileHandlingPanelOKButton) 
        {
            // ok button selected
            // save path in standard user default
            [[NSUserDefaults standardUserDefaults] setValue:[[[downloadFolderSelectOpenPanel URLs] lastObject] path] forKey:@"downloadFolderPath"];
        }
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isFinished"]) {
        // an operation is finished
        // so increase operationsProcessedCount by 1
        self.operationsProcessedCount = self.operationsProcessedCount + 1;
        
        if (self.operationsProcessedCount == [self.urlsArray count]) {
            // all operations completed
            self.progressIndicatorVisible = NO;
        }
    }
}
@end
