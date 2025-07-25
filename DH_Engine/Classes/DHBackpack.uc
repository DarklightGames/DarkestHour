//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHBackpack extends RODummyAttachment
    abstract;

var name BaseBone;

simulated function PostBeginPlay()
{
    local DHPawn P;

    super.PostBeginPlay();

    P = DHPawn(Owner);

    if (P != none && BaseBone != '')
    {
        SetBoneLocation(BaseBone, P.BackpackLocationOffset);
        SetBoneRotation(BaseBone, P.BackpackRotationOffset);
    }
}

defaultproperties
{
    AttachmentBone=Bip01_Spine1

    // Make headgear have the same lighting properties as the pawn
    // even after they are detached
    MaxLights=8
    ScaleGlow=1.0
    AmbientGlow=5
    bDramaticLighting = true
    BaseBone=radio
}
