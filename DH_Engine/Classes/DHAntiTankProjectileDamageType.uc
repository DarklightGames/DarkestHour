//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHAntiTankProjectileDamageType extends ROAntiTankProjectileDamType
    abstract;

defaultproperties
{
    TankDamageModifier=0.03
    APCDamageModifier=0.25
    VehicleDamageModifier=0.8
    TreadDamageModifier=0.25
    DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
    DeathOverlayTime=999.0
    KDeathVel=150.0
    KDeathUpKick=50.0
    HumanObliterationThreshhold=400
}
