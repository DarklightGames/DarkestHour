//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHAirplaneBomb extends DHArtilleryShell;

simulated function PostBeginPlay()
{
    if (Owner == none || Owner.Owner == none)
    {
        return;
    }

    Velocity = Owner.Owner.Velocity; // TODO: This isn't nice.
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
