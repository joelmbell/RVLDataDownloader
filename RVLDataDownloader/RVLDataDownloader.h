//
//  RVLDataDownloader.h
//  RVLDataDownloader
//
//  Created by Joel Bell on 10/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RVLDataDownloaderStatusRunning = 1,
    RVLDataDownloaderStatusStopped,
    RVLDataDownloaderStatusFailed,
    RVLDataDownloaderStatusCancelled
} RVLDataDownloaderStatus;


@protocol RVLDataDownloaderDelegate;

@interface RVLDataDownloader : NSObject <NSURLConnectionDataDelegate> {
@protected
    NSMutableData *receivedData;
    NSURLConnection *connection;
}

- (id)initWithURL:(NSURL *)url;

@property (nonatomic, readonly, strong) NSURL *url;
@property (nonatomic, readonly, assign) RVLDataDownloaderStatus status;
@property (nonatomic, weak) id <RVLDataDownloaderDelegate> delegate;

- (void)start;
- (void)cancel;

@end

@protocol RVLDataDownloaderDelegate <NSObject>
@optional
- (void)dataDownloader:(RVLDataDownloader *)downloader didFailWithError:(NSError *)error;
- (void)dataDownloader:(RVLDataDownloader *)downloader didFinishWithDownloadedData:(NSData *)data;

@end
