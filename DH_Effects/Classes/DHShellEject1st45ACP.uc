//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHShellEject1st45ACP extends DH1stShellEject;

defaultproperties
{
	StaticMesh=StaticMesh'WeaponPickupSM.S9mm_SMG_Pistol'

    RotationRate=(Pitch=50000)
    //DesiredRotation=(Pitch=50000)

    DrawScale3D=(X=0.9,Y=1.27,Z=1.27)
    
    Speed=140
    MinStartSpeed=100
    MaxStartSpeed=140
    
    //trajectory
    RandomYawRange=2000//2000
    RandomPitchRange=4000//2500
    RandomRollRange=500//500
}
