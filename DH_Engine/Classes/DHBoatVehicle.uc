//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBoatVehicle extends DHVehicle
    abstract;

var     sound   WashSound;

var     name    DestroyedAnimName;

// Modified to add wash sound attachment
simulated function SpawnVehicleAttachments()
{
    if (WashSound == none)
    {
        VehicleAttachments.Remove(0, 1); // if boat doesn't have a specified WashSound, remove the default attachment from array as it isn't valid
    }

    super.SpawnVehicleAttachments();

    if (VehicleAttachments[0].Actor != none)
    {
        VehicleAttachments[0].Actor.AmbientSound = WashSound;
        VehicleAttachments[0].Actor.SoundVolume = 255;
        VehicleAttachments[0].Actor.SoundRadius = 300.0;
    }
}

// Modified to avoid switching to static mesh DestroyedVehicleMesh, instead just re-skinning normal mesh with DestroyedMeshSkins & playing a destroyed animation
simulated event DestroyAppearance()
{
    local int i;

    bDestroyAppearance = true; // replicated, natively triggering this function on net clients
    NetPriority = 2.0;
    Disable('Tick');

    // Zero the driving controls (vehicle will come to a stop naturally)
    Throttle = 0.0;
    Steering = 0.0;
    Rise     = 0.0;

    // Destroy the vehicle weapons
    if (Role == ROLE_Authority)
    {
        for (i = 0; i < WeaponPawns.Length; ++i)
        {
            if (WeaponPawns[i] != none)
            {
                WeaponPawns[i].Destroy();
            }
        }
    }

    WeaponPawns.Length = 0;

    // Destroy the effects
    if (DamagedEffect != none)
    {
        DamagedEffect.Kill();
    }

    DestroyAttachments();

    // Switch to destroyed vehicle texture
    if (Level.NetMode != NM_DedicatedServer && DestroyedMeshSkins.Length > 0)
    {
        for (i = 0; i < DestroyedMeshSkins.Length; ++i)
        {
            if (DestroyedMeshSkins[i] != none)
            {
                Skins[i] = DestroyedMeshSkins[i];
            }
        }
    }

    // Loop any destroyed vehicle animation
    if (DestroyedAnimName != '')
    {
        LoopAnim(DestroyedAnimName);
    }
}

defaultproperties
{
    // Water stuff
    bCanSwim=true
    WaterDamage=0.0
    WaterSpeed=200.0
    GroundSpeed=200.0
    DustSlipRate=0.0
    DustSlipThresh=100000.0
    VehicleAttachments(0)=(AttachClass=class'ROSoundAttachment') // wash sound attachment - add attachment bone name in subclass

    // Vehicle properties
    CollisionRadius=300.0
    CollisionHeight=60.0
    MaxDesireability=0.1

    // Damage
    EngineHealth=100
    DestructionEffectClass=class'ROEffects.ROVehicleDestroyedEmitter'
    DestructionEffectLowClass=class'ROEffects.ROVehicleDestroyedEmitter_simple'
    DisintegrationEffectClass=class'ROEffects.ROVehicleObliteratedEmitter'
    DisintegrationEffectLowClass=class'ROEffects.ROVehicleObliteratedEmitter_simple'
    ImpactDamageThreshold=5000.0

    // View
    ViewShakeRadius=600.0
    ViewShakeOffsetMag=(X=0.5,Y=0.0,Z=2.0)
    ViewShakeOffsetFreq=7.0
}
