//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// Sets the draw scale of a bone and its children

class DHAnimNotify_WeaponComponentAnimationOperation extends AnimNotify_Scripted;

var() DHProjectileWeapon.EWeaponComponentAnimationDriverType DriverType;
var() enum EOperation
{
    OP_Set,     // Set the animation driver to the specified value.
    OP_Update,  // Update the animation driver using the natural theta value.
    OP_Mute,    // Mute the animation driver, allowing it to be controlled by the primary animation channel.
    OP_Unmute,  // Unmute the animation driver.
} Operation;
var() float Theta;  // The theta value to use when using the OP_Set operation.

event Notify(Actor Owner)
{
    local DHProjectileWeapon Weapon;

    Weapon = DHProjectileWeapon(Owner);

    if (Weapon == none)
    {
        return;
    }

    switch (Operation)
    {
        case OP_Set:
            Weapon.UpdateWeaponComponentAnimationsWithDriverType(DriverType, Theta);
            break;
        case OP_Update:
            // TODO: get natural theta value.
            Weapon.UpdateWeaponComponentAnimationsWithDriverType(DriverType, Theta);
            break;
        case OP_Mute:
            Weapon.MuteWeaponComponentAnimationChannelsWithDriverType(DriverType);
            break;
        case OP_Unmute:
            Weapon.UnmuteWeaponComponentAnimationChannelsWithDriverType(DriverType);
            break;
    }
}
