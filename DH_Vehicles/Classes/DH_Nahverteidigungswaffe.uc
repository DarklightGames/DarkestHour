//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Nahverteidigungswaffe extends DHVehicleSmokeLauncher; // German 'close defence weapon', mounted in vehicles primarily as a smoke launcher

defaultproperties
{
    ProjectileClass=Class'DH_GermanSmokeCandleProjectile'
    InitialAmmo=12
    FireRotation(0)=(Pitch=9284) // 51 degrees from horizontal
    FireSound=SoundGroup'DH_WeaponSounds.8cmFireSG'
    NumRotationSettings=36
    HUDAmmoIcon=Texture'DH_InterfaceArt_tex.SmokeCandle_PLACEHOLDER' // TODO: get ammo & reload icons made to replace these placeholders
    HUDAmmoReloadTexture=Texture'DH_InterfaceArt_tex.SmokeCandle_reload_PLACEHOLDER'
}
