//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_CSAZTunicRSidorPawn extends DH_CSAZPawn;

defaultproperties
{
    Mesh=SkeletalMesh'DHCharactersSOV_anm.CSAZ_tunic_backpackS'
    Skins(1)=Texture'DHSovietCharactersTex.RussianTunics.DH_CSAZ_tunic'
    Skins(0)=Texture'Characters_tex.rus_heads.rus_face05'
    Skins(2)=Texture'Characters_tex.rus_uniforms.rus_snowcamo'
    Skins(3)=TexRotator'DHSovietCharactersTex.soviet_gear.Puttees_alt'

    bReversedSkinsSlots=true
}
