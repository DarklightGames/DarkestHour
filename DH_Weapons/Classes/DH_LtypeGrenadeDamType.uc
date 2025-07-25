//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LTypeGrenadeDamType extends DHThrowableExplosiveDamageType
    abstract;

defaultproperties
{
    WeaponClass=Class'DH_LTypeGrenadeWeapon'
    HUDIcon=Texture'DH_InterfaceArt_tex.rpg43kill'

    VehicleDamageModifier=1.0
    APCDamageModifier=0.75
    TankDamageModifier=0.5
    TreadDamageModifier=1.0 //This is 1.5kg worth of explosives, and also not a heat shell,
                            // if it is dropped near a track it should ALWAYS blow them off
                            //as well as this it is one of the only functional Anti Tank methods for the itallians
}
