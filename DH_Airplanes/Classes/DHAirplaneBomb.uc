//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHAirplaneBomb extends DHArtilleryShell;

simulated function PostBeginPlay()
{
    if (Owner == none)
    {
        return;
    }

    Velocity = Owner.Owner.Velocity;
    Speed = VSize(Velocity);
    Acceleration = PhysicsVolume.Gravity;
}

// Overridden to ignore the irrelevant artillery stuff
simulated function Timer();

defaultproperties
{
    DrawType=DT_StaticMesh
    Physics=PHYS_Flying
}
