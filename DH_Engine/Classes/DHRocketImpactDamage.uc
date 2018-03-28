//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHRocketImpactDamage extends DHProjectileWeaponDamageType
    abstract;

defaultproperties
{
    DeathString="%o was killed by %k's %w."
    MaleSuicide="%o was killed by his own %w."
    FemaleSuicide="%o was killed by her own %w."

    GibModifier=10.0

    PawnDamageEmitter=class'ROEffects.ROBloodPuff'

    bDetonatesGoop=true
    bDelayedDamage=true
    bLocationalHit=true
    bKUseOwnDeathVel=true
    KDamageImpulse=4000
    KDeathVel=225
    KDeathUpKick=100

    HUDIcon=Texture'InterfaceArt_tex.deathicons.Generic'

    TankDamageModifier=1.0
    APCDamageModifier=1.0
    VehicleDamageModifier=1.0
    TreadDamageModifier=1.0

    DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
    DeathOverlayTime=999.0
}
