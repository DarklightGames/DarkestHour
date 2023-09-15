//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHShellEject1st762x54mm extends DH1stShellEject;

defaultproperties
{
	StaticMesh=StaticMesh'WeaponPickupSM.S762_Rifle_MG'
    
    Speed=250
    MinStartSpeed=200
    MaxStartSpeed=250
    
    //trajectory
    RandomYawRange=0//2000
    RandomPitchRange=0//2500
    RandomRollRange=0//500
}
