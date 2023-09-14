//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_LWPPawn extends DH_PolishPawn;

defaultproperties
{

    Mesh=SkeletalMesh'DHCharactersSOV_anm.DH_rus_rifleman_tunic'
    Skins(0)=Texture'DHSovietCharactersTex.RussianTunics.DH_LWP_wz43_tunic'
    Skins(1)=Texture'Characters_tex.rus_heads.rus_face04'

    ShovelClass=class'DH_Equipment.DHShovelItem_Russian'
    BinocsClass=class'DH_Equipment.DHBinocularsItemSoviet'
}
