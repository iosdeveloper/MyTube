//
//  DownloadsViewController.h
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

#import <AVFoundation/AVFoundation.h>

@interface DownloadsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UINavigationItem *navItem;
	IBOutlet UITableView *table;
	
	NSArray *_DownloadsContents;
	NSString *_DownloadsPath;
}

@property (retain, readwrite) NSArray *contents;
@property (retain, readwrite) NSString *path;

@end