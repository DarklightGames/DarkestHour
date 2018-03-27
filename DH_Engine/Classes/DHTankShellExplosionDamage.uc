//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHTankShellExplosionDamage extends DHVehicleWeaponDamageType
    abstract;

defaultproperties
{
    DeathString="%o was blown up by %k's cannon shell."
    MaleSuicide="%o was blown up his own cannon shell."
    FemaleSuicide="%o was blown up by her own cannon shell."

    HUDIcon=Texture'InterfaceArt_tex.deathicons.Strike'

    bIsHighExplosiveDamage=true

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
    KDeadLinZVelScale=0.002
    KDeadAngVelScale=0.003
    HumanObliterationThreshhold=265
    bExtraMomentumZ=true
    bArmorStops=false

    TankDamageModifier=0.05
    APCDamageModifier=0.25
    VehicleDamageModifier=0.5
    TreadDamageModifier=0.25

    DeathOverlayMaterial=Material'Effects_Tex.PlayerDeathOverlay'
    DeathOverlayTime=999
}
