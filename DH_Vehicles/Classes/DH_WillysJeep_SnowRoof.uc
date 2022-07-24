//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_WillysJeep_SnowRoof extends DH_WillysJeep_Roof;

defaultproperties
{
    // Skins
    Skins(0)=Texture'DH_Jeep_tex.body.Willys_Body_Winter'
    Skins(1)=Texture'DH_Jeep_tex.body.Willys_Wheels_Winter'
    Skins(2)=Texture'DH_Jeep_tex.body.Willys_Gear_Snow'
    DestroyedMeshSkins(0)=Combiner'DH_Jeep_tex.body.Willys_Body_Winter_Destroyed'
    DestroyedMeshSkins(1)=Combiner'DH_Jeep_tex.body.Willys_Wheels_Winter_Destroyed'
    DestroyedMeshSkins(2)=Combiner'DH_Jeep_tex.body.Willys_Gear_Snow_Destroyed'

    VehicleAttachments(0)=(Skins=(Texture'DH_Jeep_tex.body.Willys_Body_Winter',Texture'DH_Jeep_tex.body.Willys_Gear_Snow'))

    bIsWinterVariant=true
}

