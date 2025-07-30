//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PanzerIIILTank_CamoThree extends DH_PanzerIIILTank;

defaultproperties
{
    Skins(0)=Texture'BDJ_vehicles_tex.panzer3_ext_camo' // note texture package is distributed with RO, as its vehicles are included in ROCustom.u code package
    CannonSkins(0)=Texture'BDJ_vehicles_tex.panzer3_ext_camo'
    DestroyedMeshSkins(0)=Combiner'DH_VehiclesGE_tex2.panzer3_body_camo3_dest'
}
