//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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
    
    NativeItemName="MPL-50"
}
