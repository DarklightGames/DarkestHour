//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_LWPPawn extends DH_SovietPawn; 
//to do: when we redesign nation related art (like team selection screen), we should implement this as a separate nation

defaultproperties
{
    //Species=class'DH_SovietPlayers.DH_Soviet'

    Mesh=SkeletalMesh'DHCharactersSOV_anm.DH_rus_rifleman_tunic'
    Skins(0)=Texture'DHSovietCharactersTex.RussianTunics.DH_rus_rifleman_tunic'
    Skins(1)=Texture'Characters_tex.rus_heads.rus_face04'

    FaceSkins(0)=Texture'Characters_tex.rus_heads.rus_face08' //removed the non-slavic looking face

    ShovelClassName="DH_Equipment.DHShovelItem_Russian"
    BinocsClassName="DH_Equipment.DHBinocularsItemSoviet"
}
