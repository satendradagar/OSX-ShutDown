//
//  Registration.m
//  MacOptimizer
//
//  Created by ahmed lotfy on 2/14/13.
//
//

#import "MCRegistrationViewController.h"
#import "ChimpKitV3.h"

#define ACCEPT_ICON @"Accept_Icon.png"
#define REJECT_ICON @"RejectIcon.png"

typedef BOOL(^KeyValidationBlock)(NSString *inputKey);

typedef void(^REgistrationCompletion)(NSDictionary *info);

@interface MCRegistrationViewController ()
{
    IBOutlet NSTextField * firstNameText;
    IBOutlet NSImageView * firstNameIcon;
    IBOutlet NSTextField * lastNameText;
    IBOutlet NSImageView * lastNameIcon;
    IBOutlet NSTextField * emailText;
    IBOutlet NSImageView * emailIcon;
    IBOutlet NSTextField * verifyEmailText;
    IBOutlet NSImageView * verifyIcon;
    IBOutlet NSTextField * serialLabel;
    IBOutlet NSTextField * serialText;
    IBOutlet NSImageView * serialIcon;
    IBOutlet NSWindow * registrationWindow;
    IBOutlet NSButton * cancelButton;
    IBOutlet NSTextField *topicTitle;
    IBOutlet NSTextField *bodyText;
    IBOutlet NSButton *optinEmailButton;

}

@property (nonatomic, copy) KeyValidationBlock registrationValidateBlock;

@property (nonatomic, copy) REgistrationCompletion registrationSuccessBlock;

@property (retain, nonatomic) IBOutlet NSTextField * firstNameText;
@property (retain, nonatomic) IBOutlet NSImageView * firstNameIcon;
@property (retain, nonatomic) IBOutlet NSTextField * lastNameText;
@property (retain, nonatomic) IBOutlet NSImageView * lastNameIcon;
@property (retain, nonatomic) IBOutlet NSTextField * emailText;
@property (retain, nonatomic) IBOutlet NSImageView * emailIcon;
@property (retain, nonatomic) IBOutlet NSTextField * verifyEmailText;
@property (retain, nonatomic) IBOutlet NSImageView * verifyIcon;
@property (retain, nonatomic) IBOutlet NSTextField * serialLabel;
@property (retain, nonatomic) IBOutlet NSTextField * serialText;
@property (retain, nonatomic) IBOutlet NSImageView * serialIcon;
@property (retain, nonatomic) IBOutlet NSWindow * registrationWindow;

@property (retain, nonatomic) IBOutlet NSButton * cancelButton;
@property (retain, nonatomic) IBOutlet NSTextField *topicTitle;
@property (retain, nonatomic) IBOutlet NSTextField *bodyText;
@property (retain, nonatomic) IBOutlet NSProgressIndicator *spinner;

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;
@end

@implementation MCRegistrationViewController

@synthesize firstNameText;
@synthesize firstNameIcon;
@synthesize lastNameText;
@synthesize lastNameIcon;
@synthesize emailText;
@synthesize emailIcon;
@synthesize verifyEmailText;
@synthesize verifyIcon;
@synthesize serialLabel;
@synthesize serialText;
@synthesize serialIcon;
@synthesize registrationWindow;
@synthesize ListID;
@synthesize cancelButton;
@synthesize topicTitle;
@synthesize bodyText;
@synthesize defaultKey;

-(instancetype)init{
    self = [super init];
    if (self) {
        _mergeDateKey = @"MOPTBUYDT";
    }
    return self;
}
- (void) setKeyValidationBlock:(BOOL(^)(NSString *inputKey)) validationBlock{
    
    self.registrationValidateBlock = validationBlock;
    
}

- (void) setSuccessRegistrationBlock:(void(^)(NSDictionary *regInfo)) regSuccess{
    
    self.registrationSuccessBlock = regSuccess;
}

-(void)awakeFromNib{
    
//    [self.registrationWindow setTitle:self.mainTitle];
//    [self.topicTitle setStringValue:self.mainTitle];
//    [self.bodyText setStringValue:self.details];
//    [self.cancelButton setTitle:@"Cancel"];
//    optinEmailButton.hidden = YES;
}

-(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


- (void)closeRegistrationWindow {
    if (![MCRegistrationViewController isMacMavericksAndLater]) {
        [NSApp endSheet:self.window ];
    }else{
        [[[NSApplication sharedApplication] mainWindow] performSelector:@selector(endSheet:) withObject:self.window ];
    }
    [self.window performClose:nil];
    NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:kPRESENTED_REGISTRATION];
    [defaults synchronize];

}

- (void)beginSheetWindow:(NSWindow *)mainWindow{
    if (![MCRegistrationViewController isMacMavericksAndLater]) {
        [NSApp beginSheet:self.window modalForWindow:mainWindow modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
    }else{//For 10.9 and later
        [mainWindow performSelector:@selector(beginSheet:completionHandler:) withObject:self.window withObject:^void{}];
    }
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo{
    [sheet orderOut:self];
}


- (void)windowDidLoad {
    [super windowDidLoad];

    [self.registrationWindow setTitle:self.mainTitle];
    [self.topicTitle setStringValue:self.mainTitle];
    [self.bodyText setStringValue:self.details];
    [self.cancelButton setTitle:@"Cancel"];
    if (nil != self.defaultKey) {
        self.serialText.stringValue = self.defaultKey;
        self.serialText.hidden = YES;
        self.serialLabel.hidden = YES;
        self.serialIcon.hidden = YES;
    }
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}


#pragma mark Serial validation
- (IBAction)registerInMailChimp:(id)sender {
    if (![self validateData]) {
        return;
    }
    
//    self.serial = self.serialText.stringValue;
    [self validSerial];

}

-(BOOL)validateData{
    NSString * firstName = [self.firstNameText.stringValue stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(!firstName.length){
        [self.firstNameIcon setImage:[NSImage imageNamed:REJECT_ICON]];
        return NO;
    }else{
        [self.firstNameIcon setImage:[NSImage imageNamed:ACCEPT_ICON]];
    }
    NSString * lastName = [self.lastNameText.stringValue stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!lastName.length) {
        [self.lastNameIcon setImage:[NSImage imageNamed:REJECT_ICON]];
        return NO;
    }else{
        [self.lastNameIcon setImage:[NSImage imageNamed:ACCEPT_ICON]];
    }
    if (![self isValidEmail:self.emailText.stringValue]) {
        [self.emailIcon setImage:[NSImage imageNamed:REJECT_ICON]];
        return NO;
    }else{
        [self.emailIcon setImage:[NSImage imageNamed:ACCEPT_ICON]];
    }
    if (![self.emailText.stringValue isEqualToString:self.verifyEmailText.stringValue]) {
        [self.verifyIcon setImage:[NSImage imageNamed:REJECT_ICON]];
        return NO;
    }else{
        [self.verifyIcon setImage:[NSImage imageNamed:ACCEPT_ICON]];
    }
    return YES;
}


- (void)validSerial{
    [self.serialIcon setImage:[NSImage imageNamed:@""]];

    if(NO == self.registrationValidateBlock(self.serialText.stringValue)){
            [self.serialIcon setImage:[NSImage imageNamed:REJECT_ICON]];
    }else{
        
        [self.spinner startAnimation:self];
        [self registerData];
        
    }
}

-(void)registerData{
        //<YOUR_API_KEY>
    ChimpKitV3 *ck = [[ChimpKitV3 alloc] initWithDelegate:self andApiKey:self.apiKey];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //YOUR_LIST_ID
    [params setValue:self.ListID forKey:@"id"];
    [params setValue:self.emailText.stringValue forKey:@"email_address"];
    
    [params setValue:optinEmailButton.state?@"subscribed":@"pending" forKey:@"status"];

    NSMutableDictionary *mergeVars = [NSMutableDictionary dictionary];
    [mergeVars setValue:self.firstNameText.stringValue forKey:@"FNAME"];
    [mergeVars setValue:self.lastNameText.stringValue forKey:@"LNAME"];
    [mergeVars setValue:self.serialText.stringValue forKey:@"Serial"];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    NSString *str = [dateFormatter stringFromDate:[NSDate date]];
    [mergeVars setValue:str forKey:_mergeDateKey];
    [mergeVars setValue:optinEmailButton.state?@"YES":@"NO" forKey:@"OPTIN"];
//    if (optinEmailButton.enabled) {
//        [params setValue:@"subscribed" forKey:@"status"];
//    }
//    else
//    {
//        [params setValue:@"unsubscribed" forKey:@"status"];
//    }
//
    [params setValue:mergeVars forKey:@"merge_vars"];
    [ck callApiMethod:@"members" withParams:params];
}

#pragma -Mark MailChimp Delegate
- (void)ckRequestSucceeded:(ChimpKit *)ckRequest {
    if (ckRequest.responseString) {
        NSLog(@"%@",ckRequest.responseString);
    }
//    if ([ckRequest.responseString isEqualToString:@"true"]) {
    
        NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:kREGISTRATIONCOMPLETED];
        [defaults synchronize];
        
            //username, name, email , phone, password, additionalInfo
    
        NSMutableDictionary *mergeVars = [NSMutableDictionary dictionary];
        [mergeVars setValue:self.emailText.stringValue forKey:@"email"];
        [mergeVars setValue:self.emailText.stringValue forKey:@"username"];
        [mergeVars setValue:@"" forKey:@"phone"];
    
        [mergeVars setValue:[NSString stringWithFormat:@"%@ %@",self.firstNameText.stringValue,self.lastNameText.stringValue] forKey:@"name"];
        [mergeVars setValue:self.serialText.stringValue forKey:@"additionalInfo"];
        typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.registrationSuccessBlock(mergeVars);

            [weakSelf closeRegistrationWindow];
                //        [((MacOptimizerAppDelegate*)[NSApp delegate]) registrationDidFinish];
                //        [MOptimumAppDelegate setPropertyListValue:@(YES) forKey:REGISTER_KEY];
            
            
        });
//    }
//    else
//    {
//        NSError *error = [NSError errorWithDomain:ckRequest.responseString code:99 userInfo:nil];
//        [NSApp presentError:error];
//    }
}

- (void)ckRequestFailed:(NSError *)error {
    NSLog(@"Response Error: %@", error);
    [NSApp presentError:error];
    [self.spinner stopAnimation:self];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
            //        [((MacOptimizerAppDelegate*)[NSApp delegate]) registrationDidFinish];
            //        [self closeRegistrationWindow];
        
    });
    
}

- (IBAction)continueAction:(id)sender {
    
//    NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
////    [defaults setBool:NO forKey:REGISTER_KEY];
//    [defaults synchronize];
//    [self closeRegistrationWindow];
//    if (nil == self.defaultKey) {
//
        [[NSApplication sharedApplication] terminate:nil];

//    }
    
}



- (void)dealloc{
    self.apiKey = nil;
}

+ (BOOL) isMacMavericksAndLater{
    SInt32 OSXversionMajor, OSXversionMinor;
    if(Gestalt(gestaltSystemVersionMajor, &OSXversionMajor) == noErr && Gestalt(gestaltSystemVersionMinor, &OSXversionMinor) == noErr)
        {
        if(OSXversionMajor == 10 && OSXversionMinor < 9)
            {
            return NO;
            }else{//For 10.9 and later
                return YES;
            }
        }else{
            return NO;
        }
    //Asper my knowledge these should endup in a single day apart from design
}

@end
