//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Granatwerfer34ProjectileHE extends DHMortarProjectileHE;

defaultproperties
{
    Speed=6500
    MaxSpeed=6500
    Damage=350.0
    DamageRadius=965.0 // 16 meters
    Tag="HE"
    BlurTime=6.0
    BlurEffectScalar=4.0

    ImpactEffect=class'DH_Effects.DHMortarHitEffect81mm'

    StaticMesh=StaticMesh'DH_Model35Mortar_stc.projectiles.DE_HE_WGR38'
}
