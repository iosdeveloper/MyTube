//
//  UIDownloadBar.h
//  Old Radio
//
//  Created by Yuliya Sosnenko on 7/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UIProgressView;
@protocol UIDownloadBarDelegate;

@interface UIDownloadBar : UIProgressView {
	NSURLRequest		*DownloadRequest;
	NSURLConnection		*DownloadConnection;
	NSMutableData		*receivedData;
	NSString			*localFilename;
	NSURL				*downloadUrl;
	id<UIDownloadBarDelegate> delegate;
	float				bytesReceived;
	long long			expectedBytes;
	
	BOOL				operationFinished, operationFailed, operationBreaked;
	BOOL				operationIsOK;	
	BOOL				appendIfExist;
	FILE				*downFile;
	//NSString			*fileUrlPath;
	NSString			*possibleFilename;
	
	
	float percentComplete;
}

- (UIDownloadBar *)initWithURL:(NSURL *)fileURL progressBarFrame:(CGRect)frame timeout:(NSInteger)timeout delegate:(id<UIDownloadBarDelegate>)theDelegate;

@property (assign) BOOL operationIsOK;
@property (assign) BOOL appendIfExist;
//@property (nonatomic, copy) NSString *fileUrlPath;

@property (nonatomic, readonly) NSMutableData* receivedData;
@property (nonatomic, readonly, retain) NSURLRequest* DownloadRequest;
@property (nonatomic, readonly, retain) NSURLConnection* DownloadConnection;
@property (nonatomic, assign) id<UIDownloadBarDelegate> delegate;

@property (nonatomic, readonly) float percentComplete;
@property (nonatomic, retain) NSString *possibleFilename;

- (void) forceStop;

- (void) forceContinue;

@end


@protocol UIDownloadBarDelegate<NSObject>

@optional
- (void)downloadBar:(UIDownloadBar *)downloadBar didFinishWithData:(NSData *)fileData suggestedFilename:(NSString *)filename;
- (void)downloadBar:(UIDownloadBar *)downloadBar didFailWithError:(NSError *)error;
- (void)downloadBarUpdated:(UIDownloadBar *)downloadBar;

@end
