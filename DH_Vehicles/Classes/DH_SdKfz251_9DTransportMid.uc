//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================
// Mid variant

class DH_SdKfz251_9DTransportMid extends DH_SdKfz251_9DTransportLate;

defaultproperties
{
    VehicleNameString="Sd.Kfz.251/9 Ausf.C Stummel"

    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_SdKfz251_9DCannonPawnMid',WeaponBone="mg_base")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_StummelMMountedMGPawn',WeaponBone="mg_base")
    Skins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.Halftrack_body_camo1'
}