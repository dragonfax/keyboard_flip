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
NSDictionary *unflipMap;

void initializeFlipMap() {
  unflipMap = @{
    [NSNumber numberWithInt:kVK_ANSI_H]: [NSNumber numberWithInt:kVK_ANSI_G],
    [NSNumber numberWithInt:kVK_ANSI_G]: [NSNumber numberWithInt:kVK_ANSI_F],
    [NSNumber numberWithInt:kVK_ANSI_F]: [NSNumber numberWithInt:kVK_ANSI_D],
    [NSNumber numberWithInt:kVK_ANSI_D]: [NSNumber numberWithInt:kVK_ANSI_S],
    [NSNumber numberWithInt:kVK_ANSI_S]: [NSNumber numberWithInt:kVK_ANSI_A],
    [NSNumber numberWithInt:kVK_ANSI_A]: [NSNumber numberWithInt:kVK_CapsLock],

    [NSNumber numberWithInt:kVK_ANSI_Y]: [NSNumber numberWithInt:kVK_ANSI_T],
    [NSNumber numberWithInt:kVK_ANSI_T]: [NSNumber numberWithInt:kVK_ANSI_R],
    [NSNumber numberWithInt:kVK_ANSI_R]: [NSNumber numberWithInt:kVK_ANSI_E],
    [NSNumber numberWithInt:kVK_ANSI_E]: [NSNumber numberWithInt:kVK_ANSI_W],
    [NSNumber numberWithInt:kVK_ANSI_W]: [NSNumber numberWithInt:kVK_ANSI_Q],
    [NSNumber numberWithInt:kVK_ANSI_Q]: [NSNumber numberWithInt:kVK_Tab],

    [NSNumber numberWithInt:kVK_ANSI_7]: [NSNumber numberWithInt:kVK_ANSI_6],
    [NSNumber numberWithInt:kVK_ANSI_6]: [NSNumber numberWithInt:kVK_ANSI_5],
    [NSNumber numberWithInt:kVK_ANSI_5]: [NSNumber numberWithInt:kVK_ANSI_4],
    [NSNumber numberWithInt:kVK_ANSI_4]: [NSNumber numberWithInt:kVK_ANSI_3],
    [NSNumber numberWithInt:kVK_ANSI_3]: [NSNumber numberWithInt:kVK_ANSI_2],
    [NSNumber numberWithInt:kVK_ANSI_2]: [NSNumber numberWithInt:kVK_ANSI_1],
    [NSNumber numberWithInt:kVK_ANSI_1]: [NSNumber numberWithInt:kVK_ANSI_Grave],

    [NSNumber numberWithInt:kVK_ANSI_B]: [NSNumber numberWithInt:kVK_ANSI_V],
    [NSNumber numberWithInt:kVK_ANSI_V]: [NSNumber numberWithInt:kVK_ANSI_C],
    [NSNumber numberWithInt:kVK_ANSI_C]: [NSNumber numberWithInt:kVK_ANSI_X],
    [NSNumber numberWithInt:kVK_ANSI_X]: [NSNumber numberWithInt:kVK_ANSI_Z],
    [NSNumber numberWithInt:kVK_ANSI_Z]: [NSNumber numberWithInt:kVK_Shift],
  };

  flipMap = @{
    [NSNumber numberWithInt:kVK_ANSI_G]: [NSNumber numberWithInt:kVK_ANSI_J],
    [NSNumber numberWithInt:kVK_ANSI_F]: [NSNumber numberWithInt:kVK_ANSI_K],
    [NSNumber numberWithInt:kVK_ANSI_D]: [NSNumber numberWithInt:kVK_ANSI_L],
    [NSNumber numberWithInt:kVK_ANSI_S]: [NSNumber numberWithInt:kVK_ANSI_Semicolon],
    [NSNumber numberWithInt:kVK_ANSI_A]: [NSNumber numberWithInt:kVK_ANSI_Quote],
    [NSNumber numberWithInt:kVK_CapsLock]: [NSNumber numberWithInt:kVK_Return],

    [NSNumber numberWithInt:kVK_ANSI_T]: [NSNumber numberWithInt:kVK_ANSI_U],
    [NSNumber numberWithInt:kVK_ANSI_R]: [NSNumber numberWithInt:kVK_ANSI_I],
    [NSNumber numberWithInt:kVK_ANSI_E]: [NSNumber numberWithInt:kVK_ANSI_O],
    [NSNumber numberWithInt:kVK_ANSI_W]: [NSNumber numberWithInt:kVK_ANSI_P],
    [NSNumber numberWithInt:kVK_ANSI_Q]: [NSNumber numberWithInt:kVK_ANSI_LeftBracket],
    [NSNumber numberWithInt:kVK_Tab]: [NSNumber numberWithInt:kVK_ANSI_RightBracket],

    [NSNumber numberWithInt:kVK_ANSI_6]: [NSNumber numberWithInt:kVK_ANSI_7],
    [NSNumber numberWithInt:kVK_ANSI_5]: [NSNumber numberWithInt:kVK_ANSI_8],
    [NSNumber numberWithInt:kVK_ANSI_4]: [NSNumber numberWithInt:kVK_ANSI_9],
    [NSNumber numberWithInt:kVK_ANSI_3]: [NSNumber numberWithInt:kVK_ANSI_0],
    [NSNumber numberWithInt:kVK_ANSI_2]: [NSNumber numberWithInt:kVK_ANSI_Minus],
    [NSNumber numberWithInt:kVK_ANSI_1]: [NSNumber numberWithInt:kVK_ANSI_Equal],
    [NSNumber numberWithInt:kVK_ANSI_Grave]: [NSNumber numberWithInt:kVK_Delete],

    [NSNumber numberWithInt:kVK_ANSI_B]: [NSNumber numberWithInt:kVK_ANSI_N],
    [NSNumber numberWithInt:kVK_ANSI_V]: [NSNumber numberWithInt:kVK_ANSI_M],
    [NSNumber numberWithInt:kVK_ANSI_C]: [NSNumber numberWithInt:kVK_ANSI_Comma],
    [NSNumber numberWithInt:kVK_ANSI_X]: [NSNumber numberWithInt:kVK_ANSI_Period],
    [NSNumber numberWithInt:kVK_ANSI_Z]: [NSNumber numberWithInt:kVK_ANSI_Slash],
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

CGEventSourceRef src;

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

int main(int argc, char** argv) {

  initializeFlipMap();

  src = CGEventSourceCreate(kCGEventSourceStateHIDSystemState);

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
        CFRunLoopRef runLoop =  CFRunLoopGetCurrent(); //GetCFRunLoopFromEventLoop(GetMainEventLoop ()); 

        // Get the CFRunLoop primitive for the Carbon Main Event Loop, and add the new event souce
        CFRunLoopAddSource(runLoop, eventSrc, kCFRunLoopDefaultMode);

      }
  }

  CFRunLoopRun();
}
