//
//  MyTubeViewController.m
//  Copyright 2011 Max Bäumle
//  http://github.com/iosdeveloper
//
//  This file is part of MyTube.
//
//  MyTube is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  MyTube is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with MyTube.  If not, see <http://www.gnu.org/licenses/>.
//

#import "DownloadsViewController.h"
#import "MyTubeViewController.h"

@implementation MyTubeViewController

#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [webView setBackgroundColor:[UIColor clearColor]];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (!webView.request.URL) {
		[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.youtube.com"]]];
	}
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if (bar) {
        [bar forceStop];
        [bar removeFromSuperview];
        [bar release];
        bar = nil;
    }
    
    if (videoTitle) {
        [videoTitle release];
        videoTitle = nil;
    }
	
	[downloadButton setEnabled:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.youtube.com"]]];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)download {
	[downloadButton setEnabled:NO];
	
	[webView setUserInteractionEnabled:NO];
    
    UIUserInterfaceIdiom userInterfaceIdiom = [UIDevice currentDevice].userInterfaceIdiom;
    
    NSString *getURL = @"";
    
    if (userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        getURL = [webView stringByEvaluatingJavaScriptFromString:@"function getURL() {var player = document.getElementById('player'); var video = player.getElementsByTagName('video')[0]; return video.getAttribute('src');} getURL();"];
    } else {
        getURL = [webView stringByEvaluatingJavaScriptFromString:@"function getURL() {var bh = document.getElementsByClassName('bh'); if (bh.length) {return bh[0].getAttribute('src');} else {var zq = document.getElementsByClassName('zq')[0]; return zq.getAttribute('src');}} getURL();"];
    }
    
    NSString *getTitle = [webView stringByEvaluatingJavaScriptFromString:@"function getTitle() {var jm = document.getElementsByClassName('jm'); if (jm.length) {return jm[0].innerHTML;} else {var lp = document.getElementsByClassName('lp')[0]; return lp.childNodes[0].innerHTML;}} getTitle();"];
    
	NSString *getTitleFromChannel = [webView stringByEvaluatingJavaScriptFromString:@"function getTitleFromChannel() {var video_title = document.getElementById('video_title'); return video_title.childNodes[0].innerHTML;} getTitleFromChannel();"];
    
    //NSLog(@"%@, %@, %@", getURL, getTitle, getTitleFromChannel);
    
	[webView setUserInteractionEnabled:YES];
	
	NSArray *components = [getTitle componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]];
	getTitle = [components componentsJoinedByString:@" "];
	
	if ([getURL length] > 0) {
		if ([getTitle length] > 0) {
			videoTitle = [getTitle retain];
			
			bar = [[UIDownloadBar alloc] initWithURL:[NSURL URLWithString:getURL]
									progressBarFrame:CGRectMake(85.0, 17.0, 150.0, 11.0)
											 timeout:15
											delegate:self];
			
			[bar setProgressViewStyle:UIProgressViewStyleBar];
			
			[toolbar addSubview:bar];
		} else {
			NSArray *components = [getTitleFromChannel componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]];
			getTitleFromChannel = [components componentsJoinedByString:@" "];
			
			if ([getTitleFromChannel length] > 0) {
				videoTitle = [getTitleFromChannel retain];
				
				bar = [[UIDownloadBar alloc] initWithURL:[NSURL URLWithString:getURL]
										progressBarFrame:CGRectMake(85.0, 17.0, 150.0, 11.0)
												 timeout:15
												delegate:self];
				
				[bar setProgressViewStyle:UIProgressViewStyleBar];
				
				[toolbar addSubview:bar];
			} else {
                //NSLog(@"%@", [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].innerHTML;"]);
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"MyTube" message:@"Couldn't get video title." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alertView show];
                [alertView release];
                
				[downloadButton setEnabled:YES];
			}
		}
	} else {
        //NSLog(@"%@", [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].innerHTML;"]);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"MyTube" message:@"Couldn't get MP4 URL." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        [alertView release];
        
		[downloadButton setEnabled:YES];
	}
}

- (IBAction)presentDownloads {
	DownloadsViewController *viewController = [[DownloadsViewController alloc] initWithNibName:@"Downloads" bundle:nil];
	
	[self presentModalViewController:viewController animated:YES];
	
	[viewController release];
}

#pragma mark -
#pragma mark Delegates

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)downloadBar:(UIDownloadBar *)downloadBar didFinishWithData:(NSData *)fileData suggestedFilename:(NSString *)filename {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	[fileManager createFileAtPath:[NSString stringWithFormat:@"%@.mp4", [[paths objectAtIndex:0] stringByAppendingPathComponent:videoTitle]] contents:fileData attributes:nil];
	
	NSString *imagePath = [NSString stringWithFormat:@"%@.png", [[paths objectAtIndex:0] stringByAppendingPathComponent:videoTitle]];
	
	AVAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@.mp4", [[paths objectAtIndex:0] stringByAppendingPathComponent:videoTitle]]] options:nil];
	
	AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
	
	Float64 durationSeconds = CMTimeGetSeconds(asset.duration);
	
	CMTime midpoint = CMTimeMakeWithSeconds(durationSeconds / 2.0, 600);
	CMTime actualTime;

	CGImageRef preImage = [imageGenerator copyCGImageAtTime:midpoint actualTime:&actualTime error:NULL];
	
	if (preImage != NULL) {
		CGRect rect = CGRectMake(0.0, 0.0, CGImageGetWidth(preImage) * 0.5, CGImageGetHeight(preImage) * 0.5);
		
		UIImage *image = [UIImage imageWithCGImage:preImage];
		
		UIGraphicsBeginImageContext(rect.size);
		
		[image drawInRect:rect];
		
		NSData *data = UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext());
		
		[fileManager createFileAtPath:imagePath contents:data attributes:nil];
		
		UIGraphicsEndImageContext();
	}
	
	CGImageRelease(preImage);
	[imageGenerator release];
	[asset release];
	
	[videoTitle release];
    videoTitle = nil;
	
	[downloadBar removeFromSuperview];
    [bar release];
    bar = nil;
	
	[downloadButton setEnabled:YES];
}

- (void)downloadBar:(UIDownloadBar *)downloadBar didFailWithError:(NSError *)error {
	[videoTitle release];
    videoTitle = nil;
	
	[downloadBar removeFromSuperview];
    [bar release];
    bar = nil;
	
	[downloadButton setEnabled:YES];
}

- (void)downloadBarUpdated:(UIDownloadBar *)downloadBar {}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	
    [super dealloc];
}

@end