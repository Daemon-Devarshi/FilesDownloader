//
//  DKDownloadOperation.h
//  FilesDownloader
//
//  Created by Support on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKDownloadOperation : NSOperation
@property (readwrite, strong) NSURL *downloadURL;
@property (readwrite, strong) NSString *downloadPath;

// designated initializer
- (instancetype)initWithURL:(NSURL *)url downloadPath:(NSString *)path NS_DESIGNATED_INITIALIZER;
@end
