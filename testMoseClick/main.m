//
//  main.m
//  testMoseClick
//
//  Created by Rahul Malik on 23/10/14.
//  Copyright (c) 2014 Rahul Malik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import <Foundation/Foundation.h>


void clickMouse(CGEventType mouseDown, CGEventType mouseUp, CGMouseButton mouseButton, UInt32 clickCount, CGEventFlags modifiers) {
    
    // current mouse position
    CGPoint mousePosition = CGEventGetLocation(CGEventCreate(NULL));
    
    // because?
    CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStateHIDSystemState);
    CGEventRef eventDown = CGEventCreateMouseEvent(source, mouseDown, mousePosition, mouseButton);
    CGEventRef eventUp   = CGEventCreateMouseEvent(source, mouseUp,   mousePosition, mouseButton);
    
    // necessary?
    CGEventSetType(eventDown, mouseDown);
    CGEventSetType(eventUp,   mouseUp);
    
    CGEventSetFlags(eventDown, kCGEventFlagMaskShift);
    
    CGEventSetIntegerValueField(eventDown, kCGMouseEventClickState, clickCount);
    CGEventSetIntegerValueField(eventUp,   kCGMouseEventClickState, 0);
    
    CGEventPost(kCGHIDEventTap, eventDown);
    CGEventPost(kCGHIDEventTap, eventUp); // error here?
    
}
CGEventTapLocation tapLocation;
CGEventSourceRef sourceRef;
void moveMouseToPoint(float x, float y) {
	CGEventRef moveMouse = CGEventCreateMouseEvent(sourceRef, kCGEventMouseMoved, CGPointMake(x, y), 0);
	CGEventPost(tapLocation, moveMouse);
	CFRelease(moveMouse);
}
void performLeftClick(CGEventFlags modKeys) {
    // get the current mouse location
    CGEventRef mouseEvent = CGEventCreate(NULL);
    CGPoint mouseLoc = CGEventGetLocation(mouseEvent);
    CFRelease(mouseEvent);
    
    // click mouse
    CGEventRef clickMouse = CGEventCreateMouseEvent(sourceRef, kCGEventLeftMouseDown, mouseLoc, 0);
    if (!modKeys == 0) CGEventSetFlags(clickMouse, modKeys);
    CGEventPost(tapLocation, clickMouse);
    CFRelease(clickMouse);
    
    // release mouse
    CGEventRef releaseMouse = CGEventCreateMouseEvent(sourceRef, kCGEventLeftMouseUp, mouseLoc, 0);
    CGEventPost(tapLocation, releaseMouse);
    CFRelease(releaseMouse);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        tapLocation = kCGHIDEventTap;
        sourceRef = CGEventSourceCreate(kCGEventSourceStatePrivate);
        moveMouseToPoint(1409,43);
        sleep(1);
        //clickMouse(kCGEventLeftMouseDown, kCGEventLeftMouseUp, kCGMouseButtonLeft, 1, 0);
        performLeftClick(kCGEventFlagMaskShift);
        // insert code here...
    }
    return 0;
}
