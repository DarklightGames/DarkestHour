//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

// Original models, skins & animation by William "Teufelhund" Miller of the AHZ Red Orchestra mod team

class DH_45mmM1942Gun extends DH_45mmM1937Gun;

defaultproperties
{
    VehicleNameString="45mm M-42 AT gun"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_45mmM1942GunCannonPawn')
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.45mmGun.45mmGunM1942_destroyed'
    SupplyCost=800
    // Haven't made 'turret' HUD icons for M1942 gun as there's no room on existing icon texture to extend the barrel
    // So making a new, re-scaled 'turret' icon would also mean making a new, re-scaled base icon
    // On balance, it's not worth it & using the M1937 HUD icons is reasonable in game, for what it is
}
