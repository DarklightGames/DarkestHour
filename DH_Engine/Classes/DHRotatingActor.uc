//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHRotatingActor extends Actor;

event PostBeginPlay()
{
    SetTimer(1.0, true);
}

event Timer()
{

}

defaultproperties
{
    Physics=PHYS_Rotating
    bRotateToDesired=true
    RotationRate=(Pitch=4096,Yaw=4096,Roll=4096)
    RemoteRole=ROLE_SimulatedProxy
    bReplicateMovement=true
}

