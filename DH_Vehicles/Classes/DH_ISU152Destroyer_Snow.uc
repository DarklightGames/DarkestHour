//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ISU152Destroyer_Snow extends DH_ISU152Destroyer;

defaultproperties
{
    Skins(0)=Texture'DH_VehiclesSOV_tex.isu152_body_snow'
    Skins(1)=Texture'DH_VehiclesSOV_tex.isu152_treadsnow' // TODO: these tracks are not very snowy (more brown), so a new snow tread skin would be good
    Skins(2)=Texture'DH_VehiclesSOV_tex.isu152_treadsnow'
    CannonSkins(0)=Texture'DH_VehiclesSOV_tex.isu152_body_snow'
    DestroyedMeshSkins(0)=Combiner'DH_VehiclesSOV_tex.isu152_body_snow_dest'
}
