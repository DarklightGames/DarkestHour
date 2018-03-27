//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHShellImpactDamageType extends DHVehicleWeaponDamageType
    abstract;

defaultproperties
{
    DeathString="%o was killed by %k's cannon shell."
    MaleSuicide="%o was killed by his own cannon shell."
    FemaleSuicide="%o was killed by her own cannon shell."

    HUDIcon=Texture'InterfaceArt_tex.deathicons.Strike'

    GibModifier=4.0

    bDetonatesGoop=true
    VehicleMomentumScaling=1.3
    bThrowRagdoll=true
    GibPerterbation=0.15
    bFlaming=true
    bDelayedDamage=true
    bLocationalHit=false

    KDamageImpulse=5000
    KDeathVel=250.0
    KDeathUpKick=50.0
    bArmorStops=false

    TankDamageModifier=1.0
    APCDamageModifier=0.75
    VehicleDamageModifier=1.5
    TreadDamageModifier=1.0

    HumanObliterationThreshhold=150

    DeathOverlayMaterial=Material'Effects_Tex.PlayerDeathOverlay'
    DeathOverlayTime=999
}

