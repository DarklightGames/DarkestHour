 //==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHMG151CannonWeapon extends DHAirplaneCannonWeapon;

defaultproperties
{
    RoundsPerMinute=680
    SpreadMax=(Pitch=400,Yaw=210)
    ProjectileClass=class'DHMG151Bullet'
    WeaponType=WEAPON_AutoCannon

    TargetTypes(0)=TARGET_Infantry
    TargetTypes(1)=TARGET_Vehicle
    TargetTypes(2)=TARGET_Gun
}
