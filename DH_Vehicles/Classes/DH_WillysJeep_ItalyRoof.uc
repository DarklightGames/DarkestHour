//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WillysJeep_ItalyRoof extends DH_WillysJeep_Roof;

defaultproperties
{
    // Skins
    Skins(0)=Texture'DH_Jeep_tex.body.Willys_Body_Italy'
    Skins(1)=Texture'DH_Jeep_tex.body.Willys_Wheels_Desert'
    Skins(2)=Texture'DH_Jeep_tex.body.Willys_Gear_Desert'
    DestroyedMeshSkins(0)=Combiner'DH_Jeep_tex.body.Willys_Body_Italy_Destroyed'
    VehicleAttachments(0)=(Skins=(Texture'DH_Jeep_tex.body.Willys_Body_Italy',Texture'DH_Jeep_tex.body.Willys_Gear_Desert'))
}

