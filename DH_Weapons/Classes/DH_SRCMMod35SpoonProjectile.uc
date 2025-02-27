//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Client-side only "spoon" projectile for the SRCM. Spawned on the client when
// a real SRCM projectile is created, inheriting the a portion of the velocity
// and direction of the real projectile.
//==============================================================================

class DH_SRCMMod35SpoonProjectile extends Projectile;

simulated event Landed(Vector HitNormal)
{
    super.Landed(HitNormal);

    SetPhysics(PHYS_None);
}

defaultproperties
{
    Physics=PHYS_Falling
    DrawType=DT_StaticMesh
    bFixedRotationDir=true
    StaticMesh=StaticMesh'DH_SRCMMod35_stc.world.srcm_spoon'
    RemoteRole=ROLE_None
    LifeSpan=10.0
    bBlockProjectiles=false
    bBlockZeroExtentTraces=false
    bCollideActors=false
    bCollideWorld=true
}