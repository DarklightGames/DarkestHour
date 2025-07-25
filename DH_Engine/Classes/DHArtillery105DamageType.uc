//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHArtillery105DamageType extends DHArtilleryDamageType
    abstract;

defaultproperties
{

    GibModifier=10.0

    bDetonatesGoop=true
    bDelayedDamage=true
    bLocationalHit=false
    bKUseOwnDeathVel=true
    KDamageImpulse=7000.000000
    KDeathVel=350
    KDeathUpKick=600
    KDeadLinZVelScale=0.00025
    KDeadAngVelScale=0.002

    HUDIcon=Texture'InterfaceArt_tex.artkill'
    VehicleMomentumScaling=1.3
    bThrowRagdoll=true
    GibPerterbation=0.15
    bFlaming=true
    bExtraMomentumZ=true
    bArmorStops=false

    TankDamageModifier=1.0
    APCDamageModifier=5.0
    VehicleDamageModifier=8.0
    TreadDamageModifier=0.0

    HumanObliterationThreshhold=300

    DeathOverlayMaterial=Material'Effects_Tex.PlayerDeathOverlay'
    DeathOverlayTime=999
}
