//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// M4A3E8/M4A3(76)W HVSS (Easy Eight) - Upgraded with widetrack Horizontal
// Volute Spring Suspension (HVSS), fitted with the 76mm M1 cannon.
//==============================================================================

class DH_ShermanTank_M4A3E8_Snow extends DH_ShermanTank_M4A3E8;

defaultproperties
{
    bIsWinterVariant=true
    Skins(0)=Texture'DH_ShermanM4A3E8_tex.body_ext_snow'
    CannonSkins(0)=Texture'DH_ShermanM4A3E8_tex.turret_ext_snow'
    DestroyedMeshSkins(0)=Combiner'DH_ShermanM4A3E8_tex.body_ext_snow_destroyed'
    DestroyedMeshSkins(3)=Combiner'DH_ShermanM4A3E8_tex.turret_ext_snow_destroyed'
}

