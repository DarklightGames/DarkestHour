//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHShovelItem_US extends DHShovelItem;

defaultproperties
{
    AttachmentClass=class'DHShovelAttachment_US'
    Mesh=SkeletalMesh'DH_Shovel_1st.Shovel_US'
    Skins(2)=Texture'DH_Equipment_tex.Shovels.US_shovel'
    HighDetailOverlay=Shader'DH_Equipment_tex.Shovels.US_shovel_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
