//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHLargeCaliberDamageType extends DHWeaponProjectileDamageType
    abstract;

defaultproperties
{
    PawnDamageEmitter=Class'DHBloodPuffLargeCaliber'
    bAlwaysSevers=true // so limbs & head are severed by a hit from such a powerful bullet
}
