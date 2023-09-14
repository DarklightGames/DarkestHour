//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_CSAZPawn extends DH_CzechPawn;

defaultproperties
{

    Mesh=SkeletalMesh'DHCharactersSOV_anm.CSAZ_tunic'
    Skins(1)=Texture'DHSovietCharactersTex.RussianTunics.DH_CSAZ_tunicG'
    Skins(0)=Texture'Characters_tex.rus_heads.rus_face04'

    ShovelClass=class'DH_Equipment.DHShovelItem_Russian'
    BinocsClass=class'DH_Equipment.DHBinocularsItemSoviet'
}
