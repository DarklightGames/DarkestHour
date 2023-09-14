//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
    HUDAmmoIcon=Texture'DH_InterfaceArt_tex.Tank_Hud.2InchSmokeBomb_PLACEHOLDER' // TODO: get ammo & reload icons made to replace these placeholders
    HUDAmmoReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.2InchSmokeBomb_reload_PLACEHOLDER'
}
