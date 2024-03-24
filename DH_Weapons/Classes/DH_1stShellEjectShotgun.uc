//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_1stShellEjectShotgun extends DH1stShellEject;

defaultproperties
{
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.Winchester1897ShellCase'
    //MinStartSpeed=50.0 // default is 125
    //MaxStartSpeed=80.0 // default is 175

    Speed=250
    MinStartSpeed=200
    MaxStartSpeed=250

    RandomYawRange=0//2000
    RandomPitchRange=0//2500
    RandomRollRange=0//500
}
