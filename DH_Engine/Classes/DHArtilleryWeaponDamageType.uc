//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHArtilleryWeaponDamageType extends DHWeaponDamageType
    abstract;

defaultproperties
{
    DeathString="%o was torn apart by an artillery shell."
    MaleSuicide="%o was careless with his own artillery shell."
    FemaleSuicide="%o was careless with her own artillery shell."

    GibModifier=10.0

    bDetonatesGoop=true
    bDelayedDamage=true
    bLocationalHit=false
    bKUseOwnDeathVel=true
    KDamageImpulse=7000.0
    KDeathVel=350
    KDeathUpKick=600
    KDeadLinZVelScale=0.00025
    KDeadAngVelScale=0.002

    HUDIcon=Texture'InterfaceArt_tex.deathicons.artkill'

    VehicleMomentumScaling=1.3
    bThrowRagdoll=true
    GibPerterbation=0.15
    bFlaming=true
    bExtraMomentumZ=true
    bArmorStops=false

    TankDamageModifier=1.0
    APCDamageModifier=1.0
    VehicleDamageModifier=1.0
    TreadDamageModifier=0.0

    HumanObliterationThreshhold=300

    DeathOverlayMaterial=Material'Effects_Tex.PlayerDeathOverlay'
    DeathOverlayTime=999
}
