//
//  DKDownloadOperation.h
//  FilesDownloader
//
//  Created by Support on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKDownloadOperation : NSOperation
@property (readwrite, retain) NSURL *downloadURL;
@property (readwrite, retain) NSString *downloadPath;

// designated initializer
- (id)initWithURL:(NSURL *)url downloadPath:(NSString *)path;
@end
