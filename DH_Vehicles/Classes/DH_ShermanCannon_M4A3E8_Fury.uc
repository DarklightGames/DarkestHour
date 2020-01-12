//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_ShermanCannon_M4A3E8_Fury extends DH_ShermanCannonA_76mm;

simulated function PostBeginPlay()
{
    local StaticMeshActor StowageAttachment;

    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        StowageAttachment = Spawn(class'StaticMeshActor', self);

        if (StowageAttachment != none)
        {
            //StowageAttachment.StaticMesh = StaticMesh'';
            StowageAttachment.AttachToBone(StowageAttachment, 'turret');
        }
    }
}

defaultproperties
{
    Mesh=SkeletalMesh'DH_ShermanM4A3E8_anm.turret_ext'
    Skins(0)=Texture'DH_ShermanM4A3E8_tex.turret_ext'
    CollisionStaticMesh=StaticMesh'DH_ShermanM4A3E8_stc.Turret.turret_collision'

    WeaponFireAttachmentBone="muzzle"

    // Coaxial MG
    AltFireAttachmentBone="coax"
    AltFireOffset=(X=-8,Y=0,Z=0)
    AltFireSpawnOffsetX=0.0
}

