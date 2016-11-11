
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

CGEventRef flip(CGEventRef event) {

  CGKeyCode keycode = (CGKeyCode)CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode);
  if ( keycode == kVK_ANSI_K ) {
    CGEventSetIntegerValueField(event, kCGKeyboardEventKeycode, (int64_t)kVK_ANSI_D);
  }

  return event;
}


CGEventRef eventTapFunction(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
  printf("eventTap triggered\n");

  if ( isSpacePressed(type,event)  ) {
    isSpaceDown = YES;
    nonSpaceTyped = NO;
    return event;
  } else if ( isSpaceReleased(type,event) ) {
    isSpaceDown = NO;
    if ( nonSpaceTyped ) {
      // We used space a flip modifier, so we don't type a space.
      return NULL;
    } else {
      return event;
    }
  } else if ( isSpaceDown ) {
    if ( type == kCGEventKeyUp ) {
      nonSpaceTyped = YES;
    }
    return flip(event);
  } else {
    return event;
  }
}

int main(int argc, char** argv) {
  printf("starting\n");

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

