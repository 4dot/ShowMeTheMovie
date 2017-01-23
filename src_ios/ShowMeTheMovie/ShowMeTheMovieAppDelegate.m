//
//  ShowMeTheMovieAppDelegate.m
//  ShowMeTheMovie
//
//  Created by charlie park on 11/9/15.
//  Copyright © 2015 ForDot. All rights reserved.
//

#import "ShowMeTheMovieAppDelegate.h"
#import "ItemListViewController.h"
#import "FakeServer.h"
#import "RealServer.h"
#import "DataAccessManager.h"



//
// ShowMeTheMovieAppDelegate
//
@implementation ShowMeTheMovieAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Change Server Type
    // FakeServer is using with local json file for test.
    // RealServer is using real data from server.
    
    FakeServer* server = [[FakeServer alloc] init];
    //RealServer* server = [[RealServer alloc] init];
    
    [DataAccessManager manager].server = server;
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    
    // Set Navigation style
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:ItemListViewController.new];
    NSDictionary *naviAttributes = @{
                                     NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                     NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:18.0]
                                     };
    
    // Create back button on navigation bar
    [navigationController.navigationBar setTitleTextAttributes:naviAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor lightGrayColor]];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"back"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    
    // add back button
    [backButton setTitleTextAttributes:naviAttributes forState:UIControlStateNormal];
    navigationController.navigationBar.topItem.backBarButtonItem = backButton;
    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
