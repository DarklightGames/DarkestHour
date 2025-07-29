//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PanzerIIILTank_SnowTwo extends DH_PanzerIIILTank;

defaultproperties
{
    Skins(0)=Texture'GUP_vehicles_tex.WELT_panzer3_extco' // note texture package is distributed with RO, as its vehicles are included in ROCustom.u code package
    Skins(2)=Texture'axis_vehicles_tex.Panzer4F2_treadsnow'
    Skins(3)=Texture'axis_vehicles_tex.Panzer4F2_treadsnow'
    CannonSkins(0)=Texture'GUP_vehicles_tex.WELT_panzer3_extco'
    DestroyedMeshSkins(0)=Combiner'DH_VehiclesGE_tex5.WELT_panzer3_body_winter_dest'
}
