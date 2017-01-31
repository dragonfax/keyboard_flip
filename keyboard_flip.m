#include <IOKit/hid/IOHIDValue.h>
#include <IOKit/hid/IOHIDLib.h>
#include <IOKit/hid/IOHIDManager.h>
#include <IOKit/hidsystem/IOHIDParameter.h>
#include <IOKit/hidsystem/IOHIDLib.h>
#import <Foundation/Foundation.h>
#include <Carbon/Carbon.h>
#include <unistd.h>


 
BOOL isSpaceDown = NO;
BOOL nonSpaceTyped = NO;

BOOL isSpacePressed(CGEventType type, CGEventRef event) {

  if ( type == kCGEventKeyDown ) {

    CGKeyCode keycode = (CGKeyCode)CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode);
    if ( keycode == kVK_Space ) {
      return YES;
    } else {
      return NO;
    }
  } else  {
    return NO;
  }
}

BOOL isSpaceReleased(CGEventType type, CGEventRef event) {

  if ( type == kCGEventKeyUp ) {
    CGKeyCode keycode = (CGKeyCode)CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode);
    if ( keycode == kVK_Space ) {
      return YES;
    } else {
      return NO;
    }
  } else {
    return NO;
  }
}

NSDictionary *flipMap;
NSDictionary *unflipMap;

enum {
  SCAN_A =  0x04,
  SCAN_B =  0x05,
  SCAN_C =  0x06,
  SCAN_D =  0x07,
  SCAN_E =  0x08,
  SCAN_F =  0x09,
  SCAN_G =  0x0A,
  SCAN_H =  0x0B,
  SCAN_I =  0x0C,
  SCAN_J =  0x0D,
  SCAN_K =  0x0E,
  SCAN_L =  0x0F,
  SCAN_M =  0x10,
  SCAN_N =  0x11,
  SCAN_O =  0x12,
  SCAN_P =  0x13,
  SCAN_Q =  0x14,
  SCAN_R =  0x15,
  SCAN_S =  0x16,
  SCAN_T =  0x17,
  SCAN_U =  0x18,
  SCAN_V =  0x19,
  SCAN_W =  0x1A,
  SCAN_X =  0x1B,
  SCAN_Y =  0x1C,
  SCAN_Z =  0x1D,
  SCAN_1 = 0x1E,
  SCAN_2 = 0x1F,
  SCAN_3 = 0x20,
  SCAN_4 = 0x21,
  SCAN_5 = 0x22,
  SCAN_6 = 0x23,
  SCAN_7 = 0x24,
  SCAN_8 = 0x25,
  SCAN_9 = 0x26,
  SCAN_0 = 0x27,
  SCAN_CapsLock = 0x39,
  SCAN_Tab = 0x2B,
  SCAN_Grave = 0x35,
  SCAN_Shift = 0xE1,
  SCAN_Semicolon = 0x33,
  SCAN_Quote = 0x34,
  SCAN_Return = 0x28,
  SCAN_LeftBracket = 0x2F,
  SCAN_RightBracket = 0x30,
  SCAN_Minus = 0x2D,
  SCAN_Equal = 0x2E,
  SCAN_Delete = 0x2A,
  SCAN_Comma = 0x36,
  SCAN_Period = 0x37,
  SCAN_Slash = 0x38,
  SCAN_Space = 0x2C
};

void initializeFlipMap() {
  unflipMap = @{
    [NSNumber numberWithInt:SCAN_H]: [NSNumber numberWithInt:SCAN_G],
    [NSNumber numberWithInt:SCAN_G]: [NSNumber numberWithInt:SCAN_F],
    [NSNumber numberWithInt:SCAN_F]: [NSNumber numberWithInt:SCAN_D],
    [NSNumber numberWithInt:SCAN_D]: [NSNumber numberWithInt:SCAN_S],
    [NSNumber numberWithInt:SCAN_S]: [NSNumber numberWithInt:SCAN_A],
    [NSNumber numberWithInt:SCAN_A]: [NSNumber numberWithInt:SCAN_CapsLock],

    [NSNumber numberWithInt:SCAN_Y]: [NSNumber numberWithInt:SCAN_T],
    [NSNumber numberWithInt:SCAN_T]: [NSNumber numberWithInt:SCAN_R],
    [NSNumber numberWithInt:SCAN_R]: [NSNumber numberWithInt:SCAN_E],
    [NSNumber numberWithInt:SCAN_E]: [NSNumber numberWithInt:SCAN_W],
    [NSNumber numberWithInt:SCAN_W]: [NSNumber numberWithInt:SCAN_Q],
    [NSNumber numberWithInt:SCAN_Q]: [NSNumber numberWithInt:SCAN_Tab],

    [NSNumber numberWithInt:SCAN_7]: [NSNumber numberWithInt:SCAN_6],
    [NSNumber numberWithInt:SCAN_6]: [NSNumber numberWithInt:SCAN_5],
    [NSNumber numberWithInt:SCAN_5]: [NSNumber numberWithInt:SCAN_4],
    [NSNumber numberWithInt:SCAN_4]: [NSNumber numberWithInt:SCAN_3],
    [NSNumber numberWithInt:SCAN_3]: [NSNumber numberWithInt:SCAN_2],
    [NSNumber numberWithInt:SCAN_2]: [NSNumber numberWithInt:SCAN_1],
    [NSNumber numberWithInt:SCAN_1]: [NSNumber numberWithInt:SCAN_Grave],

    [NSNumber numberWithInt:SCAN_B]: [NSNumber numberWithInt:SCAN_V],
    [NSNumber numberWithInt:SCAN_V]: [NSNumber numberWithInt:SCAN_C],
    [NSNumber numberWithInt:SCAN_C]: [NSNumber numberWithInt:SCAN_X],
    [NSNumber numberWithInt:SCAN_X]: [NSNumber numberWithInt:SCAN_Z],
    [NSNumber numberWithInt:SCAN_Z]: [NSNumber numberWithInt:SCAN_Shift],
  };

  flipMap = @{
    [NSNumber numberWithInt:SCAN_G]: [NSNumber numberWithInt:SCAN_J],
    [NSNumber numberWithInt:SCAN_F]: [NSNumber numberWithInt:SCAN_K],
    [NSNumber numberWithInt:SCAN_D]: [NSNumber numberWithInt:SCAN_L],
    [NSNumber numberWithInt:SCAN_S]: [NSNumber numberWithInt:SCAN_Semicolon],
    [NSNumber numberWithInt:SCAN_A]: [NSNumber numberWithInt:SCAN_Quote],
    [NSNumber numberWithInt:SCAN_CapsLock]: [NSNumber numberWithInt:SCAN_Return],

    [NSNumber numberWithInt:SCAN_T]: [NSNumber numberWithInt:SCAN_U],
    [NSNumber numberWithInt:SCAN_R]: [NSNumber numberWithInt:SCAN_I],
    [NSNumber numberWithInt:SCAN_E]: [NSNumber numberWithInt:SCAN_O],
    [NSNumber numberWithInt:SCAN_W]: [NSNumber numberWithInt:SCAN_P],
    [NSNumber numberWithInt:SCAN_Q]: [NSNumber numberWithInt:SCAN_LeftBracket],
    [NSNumber numberWithInt:SCAN_Tab]: [NSNumber numberWithInt:SCAN_RightBracket],

    [NSNumber numberWithInt:SCAN_6]: [NSNumber numberWithInt:SCAN_7],
    [NSNumber numberWithInt:SCAN_5]: [NSNumber numberWithInt:SCAN_8],
    [NSNumber numberWithInt:SCAN_4]: [NSNumber numberWithInt:SCAN_9],
    [NSNumber numberWithInt:SCAN_3]: [NSNumber numberWithInt:SCAN_0],
    [NSNumber numberWithInt:SCAN_2]: [NSNumber numberWithInt:SCAN_Minus],
    [NSNumber numberWithInt:SCAN_1]: [NSNumber numberWithInt:SCAN_Equal],
    [NSNumber numberWithInt:SCAN_Grave]: [NSNumber numberWithInt:SCAN_Delete],

    [NSNumber numberWithInt:SCAN_B]: [NSNumber numberWithInt:SCAN_N],
    [NSNumber numberWithInt:SCAN_V]: [NSNumber numberWithInt:SCAN_M],
    [NSNumber numberWithInt:SCAN_C]: [NSNumber numberWithInt:SCAN_Comma],
    [NSNumber numberWithInt:SCAN_X]: [NSNumber numberWithInt:SCAN_Period],
    [NSNumber numberWithInt:SCAN_Z]: [NSNumber numberWithInt:SCAN_Slash],
  };
}

CGEventRef flip(BOOL flipped, CGEventRef event) {

  CGKeyCode keycode = (CGKeyCode)CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode);
  NSNumber *keynum = [NSNumber numberWithInt:keycode];
  if ( flipped ) {
    if ( [flipMap objectForKey:keynum] ) {
      NSNumber *flippedKeynum = flipMap[keynum];
      CGKeyCode flippedKeycode = [flippedKeynum intValue];
      CGEventSetIntegerValueField(event, kCGKeyboardEventKeycode, (int64_t)flippedKeycode);
    }
  } else {
    if ( [unflipMap objectForKey:keynum] ) {
      NSNumber *flippedKeynum = unflipMap[keynum];
      CGKeyCode flippedKeycode = [flippedKeynum intValue];
      CGEventSetIntegerValueField(event, kCGKeyboardEventKeycode, (int64_t)flippedKeycode);
    }
  }

  return event;
}

CGEventRef eventTapFunction(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {

  if ( isSpacePressed(type,event)  ) {

    if ( isSpaceDown ) {
      // Ignore repeated space-down events.
      return NULL;
    } else {
      isSpaceDown = YES;
      nonSpaceTyped = NO;
      // TODO We dont send space until its released.
      return NULL;
    }
  } else if ( isSpaceReleased(type,event) ) {
    isSpaceDown = NO;
    if ( nonSpaceTyped ) {
      // We used space a flip modifier, so we don't type a space.
      // TODO we should squelch this
      return event; 
    } else {

      // TODO press and release space
      CGEventSourceRef src;
      CGEventRef newEvent = CGEventCreateKeyboardEvent(src, kVK_Space, true);
      return newEvent;
    }
  } else if ( isSpaceDown ) {
    if ( type == kCGEventKeyDown ) {
      nonSpaceTyped = YES;
    }
    return flip(true,event);
  } else {
    return flip(false,event);
  }
}

static io_connect_t get_event_driver(void) {
  static mach_port_t sEventDrvrRef = 0;
  mach_port_t masterPort, service, iter;
  kern_return_t kr;

  if (!sEventDrvrRef) {
    // Get master device port
    kr = IOMasterPort(bootstrap_port, &masterPort);
    check(KERN_SUCCESS == kr);

    kr = IOServiceGetMatchingServices(masterPort, IOServiceMatching("IOHIDSystem"), &iter); // or "IOHIDKeyboard"
    check(KERN_SUCCESS == kr);

    service = IOIteratorNext(iter);
    check(service);

    kr = IOServiceOpen(service, mach_task_self(), kIOHIDParamConnectType, &sEventDrvrRef);
    check(KERN_SUCCESS == kr);

    IOObjectRelease(service);
    IOObjectRelease(iter);
  }
  return sEventDrvrRef;
}


void myHIDKeyboardCallback( void* context,  IOReturn result,  void* sender,  IOHIDValueRef value )
{
    IOHIDElementRef elem = IOHIDValueGetElement( value );

    if (IOHIDElementGetUsagePage(elem) != 0x07)
        return;

    uint32_t scancode = IOHIDElementGetUsage( elem );

    if (scancode < 4 || scancode > 231)
        return;

    long pressed = IOHIDValueGetIntegerValue( value );

    printf( "scancode: %d, pressed: %ld\n", scancode, pressed );



    IOGPoint loc = {0, 0};
    NXEventData event;
    bzero(&event, sizeof(NXEventData));
    event.key.repeat = FALSE;
    event.key.keyCode = scancode;
    event.key.origCharSet = event.key.charSet = NX_ASCIISET;
    event.key.origCharCode = event.key.charCode = 0; // ?!

    IOReturn kr = IOHIDPostEvent(get_event_driver(), pressed ? NX_KEYDOWN : NX_KEYUP, loc, &event, kNXEventDataVersion, 0, TRUE );
    if ( kr != kIOReturnSuccess) {
      printf("failure to post event (%x)\n", err_get_code(kr));
    }

}


CFMutableDictionaryRef myCreateDeviceMatchingDictionary( UInt32 usagePage,  UInt32 usage )
{
    CFMutableDictionaryRef dict = CFDictionaryCreateMutable(
                                                            kCFAllocatorDefault, 0
                                                        , & kCFTypeDictionaryKeyCallBacks
                                                        , & kCFTypeDictionaryValueCallBacks );
    if ( ! dict )
        return NULL;

    CFNumberRef pageNumberRef = CFNumberCreate( kCFAllocatorDefault, kCFNumberIntType, & usagePage );
    if ( ! pageNumberRef ) {
        CFRelease( dict );
        return NULL;
    }

    CFDictionarySetValue( dict, CFSTR(kIOHIDDeviceUsagePageKey), pageNumberRef );
    CFRelease( pageNumberRef );

    CFNumberRef usageNumberRef = CFNumberCreate( kCFAllocatorDefault, kCFNumberIntType, & usage );

    if ( ! usageNumberRef ) {
        CFRelease( dict );
        return NULL;
    }

    CFDictionarySetValue( dict, CFSTR(kIOHIDDeviceUsageKey), usageNumberRef );
    CFRelease( usageNumberRef );

    return dict;
}


int main(void)
{
    initializeFlipMap();

    IOHIDManagerRef hidManager = IOHIDManagerCreate( kCFAllocatorDefault, kIOHIDOptionsTypeNone );

    CFArrayRef matches;
    {
        CFMutableDictionaryRef keyboard = myCreateDeviceMatchingDictionary( 0x01, 6 );
        CFMutableDictionaryRef keypad   = myCreateDeviceMatchingDictionary( 0x01, 7 );

        CFMutableDictionaryRef matchesList[] = { keyboard, keypad };

        matches = CFArrayCreate( kCFAllocatorDefault, (const void **)matchesList, 2, NULL );
    }

    IOHIDManagerSetDeviceMatchingMultiple( hidManager, matches );

    IOHIDManagerRegisterInputValueCallback( hidManager, myHIDKeyboardCallback, NULL );

    IOHIDManagerScheduleWithRunLoop( hidManager, CFRunLoopGetMain(), kCFRunLoopDefaultMode );

    // IOReturn r = IOHIDManagerOpen( hidManager, kIOHIDOptionsTypeSeizeDevice);
    IOReturn r = IOHIDManagerOpen( hidManager, kIOHIDOptionsTypeSeizeDevice);
    if ( r != kIOReturnSuccess ) {
      printf("failure to open device in exclusive %x", err_get_code(r));
      exit(1);
    }

    seteuid(502);

    CFRunLoopRun(); // spins
}