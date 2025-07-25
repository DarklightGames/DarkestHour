//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ShermanTank_M4A3105_Snow extends DH_ShermanTank_M4A3105_Howitzer;

defaultproperties
{
    Skins(0)=Texture'DH_VehiclesUS_tex2.ShermanM4A3_ext_snow'
    Skins(1)=Texture'DH_VehiclesUS_tex2.ShermanM4A3E2_wheels_snow'
    Skins(4)=Texture'DH_VehiclesUS_tex2.Sherman_treadsnow'
    Skins(5)=Texture'DH_VehiclesUS_tex2.Sherman_treadsnow'
    CannonSkins(0)=Texture'DH_VehiclesUS_tex2.Sherman_105_ext_snow_dest' // TODO: make whitewash texture for 105mm turret - this is using an old blackened destroyed texture!
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc3.M4A3_105dest_snow'
}
