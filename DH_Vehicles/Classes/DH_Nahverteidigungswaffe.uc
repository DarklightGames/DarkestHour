//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Nahverteidigungswaffe extends DHVehicleSmokeLauncher; // German 'close defence weapon', mounted in vehicles primarily as a smoke launcher

defaultproperties
{
    ProjectileClass=class'DH_Vehicles.DH_GermanSmokeCandleProjectile'
    InitialAmmo=12
    FireRotation(0)=(Pitch=9284) // 51 degrees from horizontal
    FireSound=SoundGroup'DH_WeaponSounds.SmokeLaunchers.8cmFireSG'
    NumRotationSettings=36
    HUDAmmoIcon=Texture'DH_InterfaceArt_tex.Tank_Hud.SmokeCandle_PLACEHOLDER' // TODO: get ammo & reload icons made to replace these placeholders
    HUDAmmoReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.SmokeCandle_reload_PLACEHOLDER'
}
