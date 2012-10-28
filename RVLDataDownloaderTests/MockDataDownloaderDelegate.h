//
//  MockDataDownloaderDelegate.h
//  RVLDataDownloader
//
//  Created by Joel Bell on 10/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RVLDataDownloader.h"

@interface MockDataDownloaderDelegate : NSObject <RVLDataDownloaderDelegate>

@property (nonatomic, strong) NSError *failedError;
@property (nonatomic, strong) NSData *downloadedData;

@end
