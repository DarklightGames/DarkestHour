//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_LWPTunicSLLatePawnC extends DH_LWPPawn;

defaultproperties
{
    Mesh=SkeletalMesh'DHCharactersSOV_anm.sov_tunic_nocoat_late' //LWP texture on "soviet late" mesh will give wz43 tunic but with alternative rank/insignia
    Skins(1)=Texture'DHSovietCharactersTex.RussianTunics.DH_LWP_wz43_tunic'
    Skins(0)=Texture'Characters_tex.rus_heads.rus_face05'

    bReversedSkinsSlots=true
}
