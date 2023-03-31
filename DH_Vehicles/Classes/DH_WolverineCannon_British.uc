//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WolverineCannon_British extends DH_WolverineCannon_Early; // British Wolverine won't have HVAP

#exec OBJ LOAD FILE=..\StaticMeshes\DH_allies_vehicles_stc.usx

var     RODummyAttachment   StowageAttachment;

// Modified to attach a static mesh decorative attachment, to cover blackened areas resulting from applying Achilles skin to Wolverine mesh
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        StowageAttachment = Spawn(class'DHDecoAttachment');

        if (StowageAttachment != none)
        {
            StowageAttachment.SetStaticMesh(StaticMesh'DH_allies_vehicles_stc.M10.Brit_M10_StowageAttachment');
            AttachToBone(StowageAttachment, 'Turret');
        }
    }
}

// Modified to include StowageAttachment
simulated function DestroyEffects()
{
    super.DestroyEffects();

    if (StowageAttachment != none)
    {
        StowageAttachment.Destroy();
    }
}

defaultproperties
{
    Skins(0)=Texture'DH_VehiclesUK_tex.ext_vehicles.Achilles_turret_ext'
}
