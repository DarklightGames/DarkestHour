//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Sdkfz105Cannon extends DH_Flak38Cannon;

// Modified to automatically match the cannon mesh to the vehicle's camo variant
simulated function InitializeVehicleBase()
{
    if (DHVehicle(Base) != none)
    {
        DHVehicle(Base).CannonSkins[0] = Base.Skins[2]; // match to the texture of the FlaK 38 gun mount on the hull
    }

    super.InitializeVehicleBase();
}

// Modified to hack damage passed to vehicle base, as it ought to use APCDamageModifier for hit on an AT gun, but instead will use VehicleDamageModifier
// Adjust damage so when vehicle base applies VehicleDamageModifier, result is the same as if it had applied APCDamageModifier to original damage
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    if (class<ROWeaponDamageType>(DamageType) != none)
    {
        Damage = Round(float(Damage) * class<ROWeaponDamageType>(DamageType).default.APCDamageModifier / class<ROWeaponDamageType>(DamageType).default.VehicleDamageModifier);
    }

    super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitIndex);
}
