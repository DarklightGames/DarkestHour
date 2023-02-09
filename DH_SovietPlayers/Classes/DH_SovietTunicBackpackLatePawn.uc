//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SovietTunicBackpackLatePawn extends DH_SovietPawn;

defaultproperties
{
    Mesh=SkeletalMesh'DHCharactersSOV_anm.sov_tunic_backpack_late'
    Skins(1)=Texture'DHSovietCharactersTex.RussianTunics.DH_rus_rifleman_tunic'
    Skins(0)=Texture'Characters_tex.rus_heads.rus_face01'
	Skins(2)=Texture'Characters_tex.rus_uniforms.rus_snowcamo'
    Skins(3)=TexRotator'DHSovietCharactersTex.soviet_gear.Puttees_alt'

    bReversedSkinsSlots=true
}
