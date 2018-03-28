//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHAntiTankProjectileDamageType extends DHProjectileWeaponDamageType
    abstract;

defaultproperties
{
    DeathString="%o was blown up by %k's %w."
    MaleSuicide="%o was blown up by his own %w."
    FemaleSuicide="%o was blown up by her own %w."

    GibModifier=10.0

    HUDIcon=Texture'InterfaceArt_tex.deathicons.Strike'
    PawnDamageEmitter=class'ROEffects.ROBloodPuff'

    bDetonatesGoop=true
    bDelayedDamage=true
    bLocationalHit=false
    bKUseOwnDeathVel=true
    KDamageImpulse=3000
    KDeathVel=150.0
    KDeathUpKick=50.0
    HumanObliterationThreshhold=400

    TankDamageModifier=0.03
    APCDamageModifier=0.25
    VehicleDamageModifier=0.8
    TreadDamageModifier=0.25

    DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
    DeathOverlayTime=999.0
}
