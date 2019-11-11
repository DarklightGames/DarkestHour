 //==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================
// https://en.wikipedia.org/wiki/Hispano-Suiza_HS.404
//==============================================================================

class DHHS404CannonWeapon extends DHAirplaneCannonWeapon;

defaultproperties
{
    RoundsPerMinute=700
    //ProjectileClass=class'DH_HS404CannonShell'
    WeaponType=WEAPON_AutoCannon

    TargetTypes(0)=TARGET_Infantry
    TargetTypes(1)=TARGET_Vehicle
    TargetTypes(2)=TARGET_Gun
}
