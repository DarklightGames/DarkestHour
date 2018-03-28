//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHProjectileWeaponDamageType extends DHWeaponDamageType
    abstract;

defaultproperties
{
    LowDetailEmitter=ROEffects.ROBloodPuffSmall
    LowGoreDamageEmitter=ROEffects.ROBloodPuffNoGore
    KDeathVel=115.0
    KDamageImpulse=1250
    KDeathUpKick=5
    bRagdollBullet=true
    bLocationalHit=true
}
