//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHBoatVehicle extends DHVehicle
    abstract;

var     Sound               WashSound;
var     name                WashSoundBoneName;
var     float               WashSoundRadius;
var     ROSoundAttachment   WashSoundAttachment;

var     name                DestroyedAnimName;

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
        WashSoundAttachment = ROSoundAttachment(VehicleAttachments[0].Actor);
        WashSoundAttachment.AmbientSound = WashSound;
        WashSoundAttachment.SoundVolume = 255;
        WashSoundAttachment.SoundRadius = WashSoundRadius;
    }
}

simulated function SetWashSoundActive(bool bActive)
{
    if (WashSoundAttachment != none)
    {
        if (bActive)
        {
            WashSoundAttachment.SoundVolume = 255;
        }
        else
        {
            WashSoundAttachment.SoundVolume = 0;
        }
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
    VehicleAttachments(0)=(AttachClass=Class'ROSoundAttachment') // wash sound attachment - add attachment bone name in subclass
    WashSoundRadius=300.0

    // Vehicle properties
    CollisionRadius=300.0
    CollisionHeight=60.0
    MaxDesireability=0.1

    // Damage
    EngineHealth=100
    DestructionEffectClass=Class'ROVehicleDestroyedEmitter'
    DestructionEffectLowClass=Class'ROVehicleDestroyedEmitter_simple'
    DisintegrationEffectClass=Class'ROVehicleObliteratedEmitter'
    DisintegrationEffectLowClass=Class'ROVehicleObliteratedEmitter_simple'
    ImpactDamageThreshold=5000.0

    // View
    ViewShakeRadius=600.0
    ViewShakeOffsetMag=(X=0.5,Y=0.0,Z=2.0)
    ViewShakeOffsetFreq=7.0

    WaterMovementState=PlayerDriving

    bEngineOff=false
    bSavedEngineOff=false
}
