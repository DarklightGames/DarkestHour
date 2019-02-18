//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHRotatingActor extends Actor;

var byte RotationDirection;

simulated function Tick(float DeltaTime)
{
    UpdateRotation(DeltaTime);
}

// TODO: Fix rotation values for multiplayer
function UpdateRotation(float DeltaTime)
{
    local rotator CurrentRotation;

    if (RotationDirection == 0)
    {
        bRotateToDesired = false;
        return;
    }

    CurrentRotation = Rotation;
    DesiredRotation = CurrentRotation;

    if (RotationDirection == 1)
    {
        DesiredRotation.Yaw += RotationRate.Yaw;
    }
    else if (RotationDirection == 255)
    {
        DesiredRotation.Yaw -= RotationRate.Yaw;
    }

    Log(":: RotateInDirection > DesiredRotation.Yaw:" @ string(DesiredRotation.Yaw));

    bRotateToDesired = true;
}

defaultproperties
{
    Physics=PHYS_Rotating
    RotationRate=(Pitch=4096,Yaw=4096,Roll=4096)
    RemoteRole=ROLE_SimulatedProxy
    bReplicateMovement=true
}
