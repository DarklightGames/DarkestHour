//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHShellEject1st556mm extends DH1stShellEject;

defaultproperties
{
	StaticMesh=StaticMesh'WeaponPickupSM.S556_Automatic_Rifle'

    RotationRate=(Pitch=50000)
    //DesiredRotation=(Pitch=50000)

    //DrawScale3D=(X=1.6,Y=1.0,Z=1.0)
    
    //Speed=250
    //MinStartSpeed=200
    //MaxStartSpeed=250
    
    //trajectory
    RandomYawRange=0//2000
    RandomPitchRange=0//2500
    RandomRollRange=0//500
}
