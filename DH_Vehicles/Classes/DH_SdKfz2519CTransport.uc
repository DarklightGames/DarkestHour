//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================
// Mid variant

class DH_SdKfz2519CTransport extends DH_SdKfz2519DTransport;

defaultproperties
{
    VehicleNameString="Sd.Kfz.251/9 Ausf.C Stummel"

    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_SdKfz2519CCannonPawn',WeaponBone="mg_base")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_StummelMMountedMGPawn',WeaponBone="mg_base")
    Skins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.Halftrack_body_camo1'
}