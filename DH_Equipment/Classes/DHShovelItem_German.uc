//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHShovelItem_German extends DHShovelItem;

defaultproperties
{
    AttachmentClass=class'DHShovelAttachment_German'
    Mesh=SkeletalMesh'DH_Shovel_1st.Shovel_German'
    Skins(2)=Texture'DH_Equipment_tex.Shovels.German_shovel'
    HighDetailOverlay=Shader'DH_Equipment_tex.Shovels.German_shovel_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
