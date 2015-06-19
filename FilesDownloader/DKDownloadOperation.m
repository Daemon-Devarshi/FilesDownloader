//
//  DKDownloadOperation.m
//  FilesDownloader
//
//  Created by Support on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKDownloadOperation.h"
#define USE_NSURLConnection_AND_Request 0

@interface DKDownloadOperation ()
@property (readwrite, strong) NSMutableData *receivedData;

/* 
 this method checks in download directory
 that file name already exists or not
 if it exists then it appends integer value at end
 in case integer value is already there then increase it by 1
 aim is to get a unique path
 */
- (void)generateUniqueDownloadPath;
@end

@implementation DKDownloadOperation
@synthesize downloadURL = _downloadURL;
@synthesize downloadPath = _downloadPath;
@synthesize receivedData = _receivedData;

- (instancetype)initWithURL:(NSURL *)url downloadPath:(NSString *)path
{
    if (self = [super init]) {
        _downloadURL = url;
        
        // path is path of folder 
        // where downloaded file will be saved
        // but we need complete path
        // which we can obtain from downloadURL
        
        //FIXME: if two files have same name then this logic will not work
        _downloadPath = [[NSString alloc] initWithFormat:@"%@/%@",path,url.lastPathComponent];
    }
    
    return self;
}

- (void)main
{
#if USE_NSURLConnection_AND_Request
    // framing NSURLRequest
    NSURLRequest *aRequest = [NSURLRequest requestWithURL:self.downloadURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    // creating connection with request
    // and initiating download
    NSURLConnection *aConnection = [[NSURLConnection alloc] initWithRequest:aRequest delegate:self];
    
    if (aConnection) {
        _receivedData = [[NSMutableData alloc] init];
        
        BOOL done = NO;
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        } while (!done);
    }
    else
    {
        // connection not established :-(
        // do something useful :-)
    }
    
#else
    [self generateUniqueDownloadPath];
    NSData *downloadedData = [NSData dataWithContentsOfURL:self.downloadURL];
    [downloadedData writeToFile:self.downloadPath atomically:YES];
#endif
}

#pragma mark utility methods

- (void)generateUniqueDownloadPath
{
    // below loop will not terminate until a unique path is not found
    while ([[NSFileManager defaultManager] fileExistsAtPath:self.downloadPath])
    {
        // chopping path
        // so that can be later merged after appending appropriate number
        // conversely by making it a unique path
        
        NSString *pathWithoutLastPathComponent = (self.downloadPath).stringByDeletingLastPathComponent;
        
        NSString *pathExtension = (self.downloadPath).pathExtension;
        
        NSString *lastPathComponent = (self.downloadPath).lastPathComponent;
        NSString *fileName = lastPathComponent.stringByDeletingPathExtension;
        
        // create a new path by appending a new number
        
        NSMutableArray *choppedFileName = [[NSMutableArray alloc] initWithArray:[fileName componentsSeparatedByString:@"_"]];
        
        NSInteger endIntegerValue = [choppedFileName.lastObject integerValue];
        
        if (endIntegerValue == 0) 
        {
            // no integer found
            // simply append 1 at end
            [choppedFileName addObject:@"1"];
        }
        else
        {
            // integer found
            // increase its count by 1
            endIntegerValue = endIntegerValue + 1;
            choppedFileName[(choppedFileName.count - 1)] = [[NSString alloc] initWithFormat:@"%ld",(long)endIntegerValue];
        }
        
        // merge all components
        self.downloadPath = [[NSString alloc] initWithFormat:@"%@/%@.%@",pathWithoutLastPathComponent,[choppedFileName componentsJoinedByString:@"_"],pathExtension];
    }
}


#pragma mark delegate methods
#if USE_NSURLConnection_AND_Request
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self generateUniqueDownloadPath];
    
    [self.receivedData writeToFile:self.downloadPath atomically:YES];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error = %@",error);
}
#endif
@end
