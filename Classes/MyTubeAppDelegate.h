//
//  MyTubeAppDelegate.h
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

@class MyTubeViewController;

@interface MyTubeAppDelegate : NSObject <UIApplicationDelegate> {
    MyTubeViewController *viewController;
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet MyTubeViewController *viewController;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

