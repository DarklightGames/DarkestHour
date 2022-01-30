//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_CSAZPawn extends DH_CzechPawn; 

defaultproperties
{

    Mesh=SkeletalMesh'DHCharactersSOV_anm.CSAZ_tunic'
    Skins(1)=Texture'DHSovietCharactersTex.RussianTunics.DH_CSAZ_tunicG'
    Skins(1)=Texture'Characters_tex.rus_heads.rus_face04'

    ShovelClassName="DH_Equipment.DHShovelItem_Russian"
    BinocsClassName="DH_Equipment.DHBinocularsItemSoviet"
}
