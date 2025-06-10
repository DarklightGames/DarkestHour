//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHShovelItem_US extends DHShovelItem;

defaultproperties
{
    AttachmentClass=Class'DHShovelAttachment_US'
    Mesh=SkeletalMesh'DH_Shovel_1st.Shovel_US'
    Skins(2)=Texture'DH_Equipment_tex.Shovels.US_shovel'
    HighDetailOverlay=Shader'DH_Equipment_tex.Shovels.US_shovel_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
