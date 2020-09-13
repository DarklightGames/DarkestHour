//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DHArtilleryGunDamageType extends ROWeaponDamageType
    abstract;


// these defaultproperties were shamefully copied from DHShellHEGunImpactDamageType
defaultproperties
{
    DeathString="%o was torn apart by an artillery shell."
    MaleSuicide="%o was careless with his own artillery shell."
    FemaleSuicide="%o was careless with her own artillery shell."

    HUDIcon=Texture'InterfaceArt_tex.deathicons.Strike'

    GibModifier=4.0

    bDetonatesGoop=true
    VehicleMomentumScaling=1.7
    bThrowRagdoll=true
    GibPerterbation=0.15
    bFlaming=true
    bDelayedDamage=true
    bLocationalHit=true
    KDamageImpulse=5000
    KDeathVel=350.000000
    KDeathUpKick=50
    bArmorStops=false

    TankDamageModifier=1.0
    APCDamageModifier=0.75
    VehicleDamageModifier=1.5
    TreadDamageModifier=1.0

    HumanObliterationThreshhold=150

    DeathOverlayMaterial=Material'Effects_Tex.PlayerDeathOverlay'
    DeathOverlayTime=999
}
