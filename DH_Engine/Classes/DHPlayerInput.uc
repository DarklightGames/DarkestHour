//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHPlayerInput extends ROPlayerInput within DHPlayer
    config(User);

event PlayerInput(float DeltaTime)
{
    local float FOVScale;

    // Ignore input if we're playing back a client-side demo.
    if (Outer.bDemoOwner && !Outer.default.bDemoOwner)
    {
        return;
    }

    // Check for Double click move
    // flag transitions
    bEdgeForward = bWasForward ^^ (aBaseY > 0);
    bEdgeBack = bWasBack ^^ (aBaseY < 0);
    bEdgeLeft = bWasLeft ^^ (aStrafe < 0);
    bEdgeRight = bWasRight ^^ (aStrafe > 0);
    bWasForward = aBaseY > 0;
    bWasBack = aBaseY < 0;
    bWasLeft = aStrafe < 0;
    bWasRight = aStrafe > 0;

    // Calculate FOVScale
    if (Outer.GetMouseModifier() < 0)
    {
        FOVScale = DesiredFOV * 0.01111; // 0.01111 = 1/90
    }
    else
    {
        FOVScale = Outer.GetMouseModifier() * 0.01111; // 0.01111 = 1/90
    }

    // Handle mouse movement based on sensitivity
    aMouseX = SmoothMouse(aMouseX * MouseSensitivity, DeltaTime, bXAxis, 0);
    aMouseY = SmoothMouse(aMouseY * MouseSensitivity, DeltaTime, bYAxis, 1);

    aMouseX = AccelerateMouse(aMouseX);
    aMouseY = AccelerateMouse(aMouseY);

    // adjust keyboard and joystick movements
    aLookUp *= FOVScale;
    aTurn *= FOVScale;

    // Remap raw x-axis movement.
    if (bStrafe != 0) // strafe
    {
        aStrafe += aBaseX * 7.5 + aMouseX;
    }
    else // forward
    {
        aTurn  += aBaseX * FOVScale + aMouseX;
    }

    aBaseX = 0;

    // Remap mouse y-axis movement.
    if (bStrafe == 0 && (bAlwaysMouseLook || bLook != 0))
    {
        // Look up/down.
        if (bInvertMouse)
        {
            aLookUp -= aMouseY;
        }
        else
        {
            aLookUp += aMouseY;
        }
    }
    else // Move forward/backward.
    {
        aForward += aMouseY;
    }

    if (bSnapLevel != 0)
    {
        bCenterView = true;
        bKeyboardLook = false;
    }
    else if (aLookUp != 0)
    {
        bCenterView = false;
        bKeyboardLook = true;
    }
    else if (bSnapToLevel && !bAlwaysMouseLook)
    {
        bCenterView = true;
        bKeyboardLook = false;
    }

    // Remap other y-axis movement.
    if (bFreeLook != 0)
    {
        bKeyboardLook = true;
        aLookUp += 0.5 * aBaseY * FOVScale;
    }
    else
    {
        aForward += aBaseY;
    }

    aBaseY = 0;

    // Handle walking.
    HandleWalking();
}

defaultproperties
{
    bAdjustSampling=true
    MouseSamplingTime=+0.008333
    MouseSmoothingStrength=+0.0
    MouseSmoothingMode=0
    MouseSensitivity=3.0
    MouseAccelThreshold=0.0
    DoubleClickTime=0.25
    bEnableDodging=true
}
