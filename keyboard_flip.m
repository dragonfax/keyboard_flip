
#import <Foundation/Foundation.h>

#include <Carbon/Carbon.h>



CFMachPortRef machPortRef;
CFRunLoopSourceRef  eventSrc;
 
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

void initializeFlipMap() {
  flipMap = @{
    [NSNumber numberWithInt:kVK_ANSI_K]: [NSNumber numberWithInt:kVK_ANSI_D],
    [NSNumber numberWithInt:kVK_ANSI_D]: [NSNumber numberWithInt:kVK_ANSI_K]
  };
}

CGEventRef flip(CGEventRef event) {

  CGKeyCode keycode = (CGKeyCode)CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode);
  NSNumber *keynum = [NSNumber numberWithInt:keycode];
  if ( [flipMap objectForKey:keynum] ) {
    NSNumber *flippedKeynum = flipMap[keynum];
    CGKeyCode flippedKeycode = [flippedKeynum intValue];
    CGEventSetIntegerValueField(event, kCGKeyboardEventKeycode, (int64_t)flippedKeycode);
  }

  return event;
}

CGEventRef eventTapFunction(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
  printf("eventTap triggered\n");

  if ( isSpacePressed(type,event)  ) {
    isSpaceDown = YES;
    nonSpaceTyped = NO;
    // TODO We dont send space until its released.
    return event;
  } else if ( isSpaceReleased(type,event) ) {
    isSpaceDown = NO;
    if ( nonSpaceTyped ) {
      // We used space a flip modifier, so we don't type a space.
      // TODO we should squelch this
      return event; 
    } else {

      // TODO press and release space
      return event;
    }
  } else if ( isSpaceDown ) {
    if ( type == kCGEventKeyDown ) {
      nonSpaceTyped = YES;
    }
    return flip(event);
  } else {
    return event;
  }
}

int main(int argc, char** argv) {
  printf("starting\n");

  initializeFlipMap();

  machPortRef =  CGEventTapCreate(kCGSessionEventTap,
    kCGTailAppendEventTap,
    kCGEventTapOptionDefault,
    CGEventMaskBit(kCGEventKeyDown) | CGEventMaskBit(kCGEventKeyUp),
    (CGEventTapCallBack)eventTapFunction,
    NULL
  );

  if (machPortRef == NULL) {
      printf("CGEventTapCreate failed!\n");
  } else {
      eventSrc = CFMachPortCreateRunLoopSource(NULL, machPortRef, 0);
      if ( eventSrc == NULL ) {
          printf( "No event run loop src?\n" );
      }else {
        printf("adding loop\n");
        CFRunLoopRef runLoop =  CFRunLoopGetCurrent(); //GetCFRunLoopFromEventLoop(GetMainEventLoop ()); 

        // Get the CFRunLoop primitive for the Carbon Main Event Loop, and add the new event souce
        CFRunLoopAddSource(runLoop, eventSrc, kCFRunLoopDefaultMode);

        printf("loop added\n");
      }
  }

  printf("sleeping\n");

  // [NSThread sleepForTimeInterval:60.0f];   

  CFRunLoopRun();


  printf("existing\n");
}

