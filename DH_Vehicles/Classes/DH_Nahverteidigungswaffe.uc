//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_Nahverteidigungswaffe extends DHVehicleSmokeLauncher; // German 'close defence weapon', mounted in vehicles primarily as a smoke launcher

defaultproperties
{
    ProjectileClass=class'DH_Vehicles.DH_GermanSmokeCandleProjectile'
    InitialAmmo=12
    FireRotation(0)=(Pitch=9284) // 51 degrees from horizontal
    FireSound=SoundGroup'DH_WeaponSounds.SmokeLaunchers.8cmFireSG' // TODO: better to have specific sound made, without mortar's 'plop' sound as round is dropped down tube
    NumRotationSettings=36
    HUDAmmoIcon=texture'DH_Mortars_tex.Kz8cmGrW42.Wgr34-Nb' // TODO: get ammo & reload icons made to replace these placeholders
    HUDAmmoReloadTexture=texture'DH_Mortars_tex.Kz8cmGrW42.Wgr34-Nb'
}
