//
//  MockRVLDataDownloader.h
//  RVLDataDownloader
//
//  Created by Joel Bell on 10/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RVLDataDownloader.h"

@interface MockRVLDataDownloader : RVLDataDownloader

@property (nonatomic, copy) NSData *receivedData;
@property (nonatomic, copy) NSURLConnection *connection;

@end
