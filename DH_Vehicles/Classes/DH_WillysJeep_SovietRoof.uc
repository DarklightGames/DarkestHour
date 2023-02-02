//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WillysJeep_SovietRoof extends DH_WillysJeep_Roof;

defaultproperties
{
    // Skins
    Skins(0)=Texture'DH_Jeep_tex.body.Willys_Body_Soviet'
    Skins(1)=Texture'DH_Jeep_tex.body.Willys_Wheels_OD'
    Skins(2)=Texture'DH_Jeep_tex.body.Willys_Gear_OD'
    DestroyedMeshSkins(0)=Combiner'DH_Jeep_tex.body.Willys_Body_Soviet_Destroyed'

    VehicleAttachments(0)=(Skins=(Texture'DH_Jeep_tex.body.Willys_Body_Soviet'))
}

