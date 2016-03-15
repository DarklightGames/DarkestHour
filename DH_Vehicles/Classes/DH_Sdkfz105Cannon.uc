//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Sdkfz105Cannon extends DH_Flak38Cannon;

// Modified to automatically match the cannon mesh to the vehicle's camo variant
simulated function InitializeVehicleBase()
{
    Skins[0] = Base.Skins[2]; // the texture of the FlaK 38 gun mount on the hull

    super.InitializeVehicleBase();
}

// Matt: temporary hack fix to stop small arms fire hitting the mounted FlaK 38 from passed damage on to the small arms vulnerable vehicle base
// Problem is in DHProjectileFire's pre-launch trace functionality, which requires some more work to make it match a spawned bullet's richer functionality
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    if (DamageType != none && (ClassIsChildOf(DamageType, class'DHWeaponProjectileDamageType') || ClassIsChildOf(DamageType, class'DHVehicleDamageType')))
    {
        return;
    }

    super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitIndex);
}

defaultproperties
{
}
