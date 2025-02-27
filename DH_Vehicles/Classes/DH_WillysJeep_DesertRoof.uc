//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WillysJeep_DesertRoof extends DH_WillysJeep_Roof;

defaultproperties
{
    // Skins
    Skins(0)=Texture'DH_Jeep_tex.body.Willys_Body_Desert'
    Skins(1)=Texture'DH_Jeep_tex.body.Willys_Wheels_Desert'
    Skins(2)=Texture'DH_Jeep_tex.body.Willys_Gear_Desert'

    DestroyedMeshSkins(0)=Combiner'DH_Jeep_tex.body.Willys_Body_Desert_Destroyed'
    DestroyedMeshSkins(1)=Combiner'DH_Jeep_tex.body.Willys_Wheels_Desert_Destroyed'
    DestroyedMeshSkins(2)=Combiner'DH_Jeep_tex.body.Willys_Gear_Desert_Destroyed'

    VehicleAttachments(0)=(Skins=(Texture'DH_Jeep_tex.body.Willys_Body_Desert',Texture'DH_Jeep_tex.body.Willys_Gear_Desert'))

}

