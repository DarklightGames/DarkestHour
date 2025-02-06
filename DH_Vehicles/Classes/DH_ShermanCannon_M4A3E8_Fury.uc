//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ShermanCannon_M4A3E8_Fury extends DH_ShermanCannon_M4A3E8;

var StaticMesh StowageStaticMesh;

simulated function PostBeginPlay()
{
    local DHDecoAttachment StowageAttachment;

    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        StowageAttachment = Spawn(class'DHDecoAttachment', self);

        if (StowageAttachment != none)
        {
            StowageAttachment.SetStaticMesh(StowageStaticMesh);
            AttachToBone(StowageAttachment, 'turret');
        }
    }
}

defaultproperties
{
    Skins(0)=Texture'DH_ShermanM4A3E8_tex.turret_ext'
    StowageStaticMesh=StaticMesh'DH_ShermanM4A3E8_stc.turret.turret_stowage'
}

