//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHShovelItem_Russian extends DHShovelItem;

defaultproperties
{
    AttachmentClass=class'DHShovelAttachment_Russian'
    Mesh=SkeletalMesh'DH_Shovel_1st.Shovel_sov'
    Skins(0)=Texture'DH_Equipment_tex.Shovels.Sov_shovel_diff'
    HighDetailOverlay=Shader'DH_Equipment_tex.Shovels.Sov_shovel_shader'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=0
    HandNum=1
    SleeveNum=2
}
