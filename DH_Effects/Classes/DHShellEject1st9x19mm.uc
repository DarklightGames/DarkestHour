//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHShellEject1st9x19mm extends DH1stShellEject;

defaultproperties
{
	StaticMesh=StaticMesh'WeaponPickupSM.S9mm_SMG_Pistol'

    //RotationRate=(Pitch=12000)
    //DesiredRotation=(Pitch=50000)

    DrawScale3D=(X=0.75,Y=1.0,Z=1.0)
    
    Speed=140
    MinStartSpeed=100
    MaxStartSpeed=140
    
    //trajectory
    RandomYawRange=1000//2000
    RandomPitchRange=4000//2500
    RandomRollRange=500//500
}
