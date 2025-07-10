//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMortarDamageType extends DHShellImpactDamageType
    abstract;

defaultproperties
{
    bIsArtilleryImpact=true
    HUDIcon=Texture'InterfaceArt_tex.artkill'
    TankDamageModifier=0.125
    APCDamageModifier=0.5
    VehicleDamageModifier=1.0
    TreadDamageModifier=0.8
    bLocationalHit=false
    bDetonatesGoop=true
    bDelayedDamage=true
    bThrowRagdoll=true
    bExtraMomentumZ=true
    bFlaming=true
    GibModifier=4.0
    DeathOverlayMaterial=Combiner'Effects_Tex.PlayerDeathOverlay'
    DeathOverlayTime=999.0
    GibPerterbation=0.15
    KDamageImpulse=4000.000000
    KDeathVel=250.0
    KDeathUpKick=300
    KDeadLinZVelScale=0.00025
    KDeadAngVelScale=0.002
    VehicleMomentumScaling=1.3
    HumanObliterationThreshhold=400
    bKUseOwnDeathVel=true
}
