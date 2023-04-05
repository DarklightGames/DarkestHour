//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_HetzerMountedMG extends DH_StuH42MountedMG;

defaultproperties
{
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Hetzer_stc.Collision.Hetzer_MG_collision')
    FireAttachBone="Gun_placement"
    FireEffectOffset=(X=-30.000000,Y=5.000000,Z=0.000000)
    AmbientEffectEmitterClass=Class'DH_Vehicles.DH_HetzerVehicleMGEmitter'
    CustomPitchUpLimit=2100
    CustomPitchDownLimit=63100
    BeginningIdleAnim="MG_idle_close"
    Mesh=SkeletalMesh'DH_Hetzer_anm.Hetzer_MG'
}
