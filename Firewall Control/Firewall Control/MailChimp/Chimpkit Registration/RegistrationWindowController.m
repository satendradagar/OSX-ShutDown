//
//  Registration.m
//  MacOptimizer
//
//  Created by ahmed lotfy on 2/14/13.
//
//

#import "RegistrationWindowController.h"

#define ACCEPTICON @"AcceptIcon.png"
#define REJECTICON @"RejectIcon.png"
//Used below in free font
//#define LISTID @"6db5305b7b" //Store and non Store are th same
//#define App_Store_Serial @"MAS-FF45-6UP9-33E4-T2RX"

//Hallowen Font changed
#define LISTID @"198b8a5e00" //Store and non Store are th same
#define App_Store_Serial @"CAP-LITE-823J-K3CX-9UT5"

//Free Fonts nonAppStore
@implementation RegistrationWindowController
@synthesize firstNameText;
@synthesize LastNameText;
@synthesize emailText;
@synthesize confirmEmailText;
@synthesize serialText;
@synthesize emailIcon;
@synthesize confirmIcon;
@synthesize serialIcon;
@synthesize registrationWindow;
@synthesize firstNameIcon;
@synthesize lastNameIcon;
@synthesize serialLabel;
@synthesize bodyLabel;
@synthesize cancelButton;

-(void)awakeFromNib{
//#ifdef FreeFonts
//    [self.serialText setStringValue:App_Store_Serial];
//    [self.window setTitle:@"Register Candy Apple"];
//    [self.cancelButton setTitle:@"Skip Registration"];
//#else
//    [self.bodyLabel setStringValue:@"Please take the time to register this application. Registration allows us to provide better support and to inform you of new updates and upgrades we are about to release. Your information will not be shared with any third parties and you can unsubscribe from our registration list at any time. If you do not want to register simply select the Skip Registration button to open the application."];
//    [self.serialLabel setHidden:NO];
//    [self.serialText setHidden:NO];
//    [self.serialIcon setHidden:NO];
//#endif
}

-(void)windowDidLoad
{
    [self.serialText setStringValue:App_Store_Serial];
 //   [self.window setTitle:@"Register Candy Apple"];
    [self.cancelButton setTitle:@"Skip Registration"];

//    [self.bodyLabel setStringValue:@"Please take the time to register this application. Registration allows us to provide better support and to inform you of new updates and upgrades we are about to release. Your information will not be shared with any third parties and you can unsubscribe from our registration list at any time. If you do not want to register simply select the Skip Registration button to open the application."];
    [self.serialLabel setHidden:YES];
    [self.serialText setHidden:YES];
    [self.serialIcon setHidden:YES];
}

-(BOOL) isValidEmail:(NSString *)checkedString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkedString];
}

-(BOOL) isValidSerial:(NSString *)checkedString{
    return YES;//Manualy added no need to validated
    if ([[checkedString substringToIndex:3] isEqualToString:@"MDB"]) {
        if(checkedString.length ==23){
            if(([[checkedString componentsSeparatedByString:@"-"] count]-1)==4){
                return YES;
            };
        }
    }
    return NO;
}

-(BOOL)testData{
    if(!self.firstNameText.stringValue.length){
        [self.firstNameIcon setImage:[NSImage imageNamed:REJECTICON]];
        return NO;
    }else{
        [self.firstNameIcon setImage:[NSImage imageNamed:ACCEPTICON]];
    }
    if (!self.LastNameText.stringValue.length) {
        [self.lastNameIcon setImage:[NSImage imageNamed:REJECTICON]];
        return NO;
    }else{
        [self.lastNameIcon setImage:[NSImage imageNamed:ACCEPTICON]];
    }
    if (![self isValidEmail:self.emailText.stringValue]) {
        [self.emailIcon setImage:[NSImage imageNamed:REJECTICON]];
        return NO;
    }else{
        [self.emailIcon setImage:[NSImage imageNamed:ACCEPTICON]];
    }
    if (![self.emailText.stringValue isEqualToString:self.confirmEmailText.stringValue]) {
        [self.confirmIcon setImage:[NSImage imageNamed:REJECTICON]];
        return NO;
    }else{
        [self.confirmIcon setImage:[NSImage imageNamed:ACCEPTICON]];
    }
    if (!self.serialText.stringValue.length)                                                                                                                                                            {
        [self.serialIcon setImage:[NSImage imageNamed:REJECTICON]];
        return NO;
    }else{
        [self.serialIcon setImage:[NSImage imageNamed:ACCEPTICON]];
    }
#ifdef VALIDATE_SERIAL
    if (![self isValidSerial:self.serialText.stringValue])                                                                                                                                                            {
        [self.serialIcon setImage:[NSImage imageNamed:REJECTICON]];
        return NO;
    }else{
        [self.serialIcon setImage:[NSImage imageNamed:ACCEPTICON]];
    }
#endif
    return YES;
}

-(void)registerData{
    //<YOUR_API_KEY>
    ChimpKit *chimpkits = [[ChimpKit alloc] initWithDelegate:self andApiKey:@"da779503246c9f44aa569845d0b00c40-us4"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //YOUR_LIST_ID
    [params setValue:LISTID forKey:@"id"];
    [params setValue:self.emailText.stringValue forKey:@"email_address"];
    //@"MAS-U3ZQ-72P4-G5QT-VHWV"
    NSMutableDictionary *mergeVars = [[NSMutableDictionary alloc]init];
    [mergeVars setValue:self.firstNameText.stringValue forKey:@"FNAME"];
    [mergeVars setValue:self.LastNameText.stringValue forKey:@"LNAME"];
    [mergeVars setValue:self.serialText.stringValue forKey:@"Serial"];
    [params setValue:mergeVars forKey:@"merge_vars"];
    [chimpkits callApiMethod:@"listSubscribe" withParams:params];
}

- (void)ckRequestSucceeded:(ChimpKit *)ckRequest {
    NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:kREGISTRATIONCOMPLETED];
    [defaults synchronize];
    
    //SS TODO:
//    GCDrawKitAppDelegate *appDelegate = (GCDrawKitAppDelegate *)[[NSApplication sharedApplication] delegate];
//    appDelegate.shouldEnableRegistrationButton = NO;
}

- (void)ckRequestFailed:(NSError *)error {
    //NSLog(@"Response Error: %@", error);

}

- (IBAction)registerInMailChimp:(id)sender {
    if (![self testData]) {
        return;
    }
    //SS TODO:
//    GCDrawKitAppDelegate *appDelegate = (GCDrawKitAppDelegate *)[[NSApplication sharedApplication] delegate];
//    appDelegate.shouldEnableRegistrationButton = YES;
    
    [self registerData];
    
    NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:kPRESENTED_REGISTRATION];
    [defaults synchronize];
    [[NSApplication sharedApplication] endSheet: self.window returnCode: NSOKButton];
    [self.window orderOut:sender];
}

- (IBAction)cancelAction:(id)sender {
    //SS TODO:

//
//    GCDrawKitAppDelegate *appDelegate = (GCDrawKitAppDelegate *)[[NSApplication sharedApplication] delegate];
//    appDelegate.shouldEnableRegistrationButton = YES;
    NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:kPRESENTED_REGISTRATION];
    [defaults synchronize];
    
    [[NSApplication sharedApplication] endSheet: self.window returnCode: NSCancelButton];
    [self.window orderOut:sender];
}

- (void)beginregistrationPanel:(NSWindow*) parent
{
    //SS TODO:

//    GCDrawKitAppDelegate *appDelegate = (GCDrawKitAppDelegate *)[[NSApplication sharedApplication] delegate];
//    appDelegate.shouldEnableRegistrationButton = NO;
//
	[NSApp	beginSheet:[self window]
       modalForWindow:parent
        modalDelegate:self
       didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
          contextInfo:nil];
}

- (void)sheetDidEnd:(NSWindow *)sheet  returnCode:(NSUInteger)code contextInfo:(void *) context
{

}

@end
