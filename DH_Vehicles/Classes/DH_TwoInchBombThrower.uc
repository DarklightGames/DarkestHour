//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_TwoInchBombThrower extends DHVehicleSmokeLauncher; // British 2 inch bomb thrower, mounted in vehicles as a smoke launcher

defaultproperties
{
    ProjectileClass=class'DH_Vehicles.DH_TwoInchSmokeBomb'
    InitialAmmo=20
    FireRotation(0)=(Pitch=8192) // assumed 45 degrees as can't find any references
    FireSound=SoundGroup'DH_WeaponSounds.Mortars.6cmFireSG'
    RangeSettingSpeedModifier(0)=0.55; // lowest setting of gas regulator - reduces range to approx 35 yards
    RangeSettingSpeedModifier(1)=0.82; // mid setting - reduces to approx 75 yards
    RangeSettingSpeedModifier(2)=1.0;  // max range (approx 110 yards)
    HUDAmmoIcon=texture'DH_Mortars_tex.60mmMortarM2.M302-WP' // TODO: get ammo & reload icons made to replace these placeholders
    HUDAmmoReloadTexture=texture'DH_Mortars_tex.60mmMortarM2.M302-WP'
}
