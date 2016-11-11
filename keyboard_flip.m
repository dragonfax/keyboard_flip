
#import <Foundation/Foundation.h>



CFMachPortRef machPortRef;
CFRunLoopSourceRef  eventSrc;

CGEventRef eventTapFunction(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
  printf("eventTap triggered\n");
  return event;
}

int main(int argc, char** argv) {
  printf("starting\n");

  machPortRef =  CGEventTapCreate(kCGSessionEventTap,
    kCGTailAppendEventTap,
    kCGEventTapOptionDefault,
    CGEventMaskBit(kCGEventKeyDown),
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

