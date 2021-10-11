//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_HetzerMountedMG extends DH_StuH42MountedMG;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Hetzer_anm.Hetzer_MG'
    CollisionStaticMesh=StaticMesh'DH_Hetzer_stc.Collision.Hetzer_MG_collision'

    FireAttachBone="Gun_placement"
    FireEffectOffset=(X=-30.000000,Y=5.000000,Z=0.000000)

    CustomPitchUpLimit=2100
    CustomPitchDownLimit=63100
    BeginningIdleAnim="MG_idle_close"

    WeaponFireOffset=-6.0 //40
    AmbientEffectEmitterClass=Class'DH_Effects.DHVehicleMG34RemoteEmitter'
}
