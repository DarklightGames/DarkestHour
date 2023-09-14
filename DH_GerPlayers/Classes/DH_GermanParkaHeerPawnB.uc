//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_GermanParkaHeerPawnB extends DH_GermanParkaPawn;

defaultproperties
{
    Mesh=SkeletalMesh'DHCharactersGER_anm.Ger_Parka_mix'

    Skins(2)=Texture'DHGermanCharactersTex.Heer.HeerParkaCam4' //shirt
    Skins(0)=Texture'DHGermanCharactersTex.Heer.HeerParkaCam4' //pants

    BodySkins(0)=Texture'DHGermanCharactersTex.Heer.HeerParkaCam4'
    BodySkins(1)=Texture'DHGermanCharactersTex.Heer.HeerParkaCam1'
    BodySkins(2)=Texture'DHGermanCharactersTex.Heer.HeerSmock1' //green

    Skins(1)=Texture'Characters_tex.ger_heads.ger_face01'

    bReversedSkinsSlots=false
}
