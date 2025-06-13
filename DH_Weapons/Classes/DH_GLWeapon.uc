//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_GLWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="StG 24 x7 Geballte Ladung"
    FireModeClass(0)=Class'DH_GLFire'
    AttachmentClass=Class'DH_GLAttachment'
    PickupClass=Class'DH_GLPickup'
    FuzeLengthRange=(Min=6.0,Max=6.0)

    InventoryGroup=7
    GroupOffset=1
    Priority=2

    Mesh=SkeletalMesh'DH_GL_1st.GL_mesh'

    HighDetailOverlay=Shader'Weapons1st_tex.stiel_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
    DisplayFOV=80.0
    PlayerViewOffset=(X=10.0,Y=5.0,Z=0.0)
}
