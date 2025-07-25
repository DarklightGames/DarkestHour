//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHShovelItem_German extends DHShovelItem;

defaultproperties
{
    AttachmentClass=Class'DHShovelAttachment_German'
    Mesh=SkeletalMesh'DH_Shovel_1st.Shovel_German'
    Skins(2)=Texture'DH_Equipment_tex.German_shovel'
    HighDetailOverlay=Shader'DH_Equipment_tex.German_shovel_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
    
    NativeItemName="Feldspaten"
}
