//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Sdkfz251Gun extends Sdkfz251Gun;

var()   class<Projectile> TracerProjectileClass; // Matt: replaces DummyTracerClass as tracer is now a real bullet that damages, not just a client-only effect, so the old name was misleading
var()   int               TracerFrequency;       // how often a tracer is loaded in (as in: 1 in the value of TracerFrequency)


// Matt: modified to spawn either normal bullet OR tracer, based on proper shot count, not simply time elapsed since last shot
state ProjectileFireMode
{
	function Fire(Controller C)
	{
        // Modulo operator (%) divides rounds previously fired by tracer frequency & returns the remainder - if it divides evenly (result=0) then it's time to fire a tracer
        if (bUsesTracers && ((InitialPrimaryAmmo - MainAmmoCharge[0] - 1) % TracerFrequency == 0.0))
        {
            SpawnProjectile(TracerProjectileClass, false);
        }
        else
        {
            SpawnProjectile(ProjectileClass, false);
        }
    }
}

// Matt: modified to remove the Super in ROVehicleWeapon to remove calling UpdateTracer, now we spawn either a normal bullet OR tracer (see ProjectileFireMode)
simulated function FlashMuzzleFlash(bool bWasAltFire)
{
	super(VehicleWeapon).FlashMuzzleFlash(bWasAltFire);
}

defaultproperties
{
    TracerProjectileClass=class'DH_MG34VehicleTracerBullet'
    TracerFrequency=7
    Spread=0.002
    FireSoundClass=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
    AmbientSoundScaling=5.0
    FireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    ProjectileClass=class'DH_Vehicles.DH_MG34VehicleBullet'
    Mesh=SkeletalMesh'DH_Sdkfz251Halftrack_anm.halftrack_gun'
}
