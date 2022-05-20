//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_LWPTunicLightPawn extends DH_LWPPawn;

defaultproperties
{
    Mesh=SkeletalMesh'DHCharactersSOV_anm.LWP_tunic_late'
    Skins(1)=Texture'DHSovietCharactersTex.RussianTunics.DH_LWP_wz43_tunic_light'
    Skins(0)=Texture'Characters_tex.rus_heads.rus_face05'
    Skins(2)=TexRotator'DHSovietCharactersTex.soviet_gear.Puttees_alt'

    bReversedSkinsSlots=true
}
