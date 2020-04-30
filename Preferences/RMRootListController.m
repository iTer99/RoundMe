#include "RMRootListController.h"

@implementation RMRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"RoundMe" target:self] retain];
	}

	return _specifiers;
}

-(void)Facebook {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/nguyenthienhoann"] options:@{} completionHandler:nil];
}

-(void)Twitter {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.twitter.com/ngthienhoan"] options:@{} completionHandler:nil];
}

-(void)Code {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/nguyenthienhoan/RoundMe"] options:@{} completionHandler:nil];
}

- (void)respring {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.iter99.roundme.respring"), NULL, NULL, YES);
}

@end
