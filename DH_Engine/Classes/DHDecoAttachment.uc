//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHDecoAttachment extends RODummyAttachment;

// Emptied out to remove auto-attachment to bone
simulated function PostBeginPlay()
{
}

defaultproperties
{
    DrawType=DT_StaticMesh
    CullDistance=80000.0
    bDramaticLighting=true
}
