///==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHSC250BombWeapon extends DHAirplaneMissileWeapon;

defaultproperties
{
    StaticMesh=StaticMesh'DH_Airplanes_stc.Bombs.sc250'
    ProjectileClass=class'DHAirplaneBomb_SC250'
    WeaponType=WEAPON_Bomb

    TargetTypes(0)=TARGET_Infantry
    TargetTypes(1)=TARGET_Vehicle
    TargetTypes(2)=TARGET_ArmoredVehicle
    TargetTypes(3)=TARGET_Gun
    TargetTypes(4)=TARGET_Construction
}
