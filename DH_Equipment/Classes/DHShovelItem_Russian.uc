//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHShovelItem_Russian extends DHShovelItem;

defaultproperties
{
    AttachmentClass=class'DHShovelAttachment_German'
    Mesh=SkeletalMesh'DH_Shovel_1st.Shovel_sov'
    Skins(0)=Texture'DH_Equipment_tex.Shovels.Sov_shovel_diff'
    HighDetailOverlay=Shader'DH_Equipment_tex.Shovels.Sov_shovel_shader'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
    HandNum=1
    SleeveNum=2
}
