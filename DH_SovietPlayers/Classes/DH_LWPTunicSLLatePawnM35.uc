//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_LWPTunicSLLatePawnM35 extends DH_LWPPawn; //soviet m35 tunic with polish insignia - should be rare

defaultproperties
{
    Mesh=SkeletalMesh'DHCharactersSOV_anm.LWP_tunic_SL_late' 
    Skins(1)=Texture'DHSovietCharactersTex.RussianTunics.DH_rus_rifleman_tunic'
    Skins(0)=Texture'Characters_tex.rus_heads.rus_face05'

    bReversedSkinsSlots=true
}
