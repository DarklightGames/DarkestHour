//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Kar98ScopedZF41Fire extends DH_Kar98Fire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_Kar98ScopedZF41Bullet'
    AmmoClass=class'DH_Weapons.DH_Kar98Ammo'
    Spread=20.0
    AddedPitch=15
    PctRestDeployRecoil=0.25
    FireIronAnim="iron_shoot_zf41"
    ShakeRotMag=(X=50.0,Y=50.0,Z=400.0)
    ShakeRotTime=5.0
    AimError=500.0
    
}
