//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHHitEffect extends Effects
    abstract;

#exec OBJ LOAD FILE=..\Sounds\ProjectileSounds.uax

//Merging modifications from 'old' DHBulletHitEffect into this new parent class to
//support additional material surface types and new funtionality for a variety
//of DH projectile classes (bullets, rockets, mortars, tank shells, etc.) if we want.

struct DHHitEffectData
{
    var class<ProjectedDecal>       HitDecal;
    var class<Emitter>      HitEffect;
    var class<Emitter>      FlashEffect; //new for DH
    var Sound               HitSound;
};

//overwritten from ROHitEffect to expand array to 50 from 20
var()   DHHitEffectData     HitEffects[50];

var()   float MinSoundRadius;
var()   float MaxSoundRadius;

simulated function PostNetBeginPlay()
{
    local ESurfaceTypes ST;
    local Vector        HitLoc, HitNormal;
    local Material      HitMat;

    if (Level.NetMode == NM_DedicatedServer)
    {
        return;
    }

    Trace(HitLoc, HitNormal, Location + Vector(Rotation) * 16.0, Location, true,, HitMat);

    if (HitMat != none)
    {
        ST = ESurfaceTypes(HitMat.SurfaceType);
    }
    else
    {
        ST = EST_Default;
    }

    // Exit function (Custom00 is a material that we don't want to spawn effects on)
    if (ST == EST_Custom00)
    {
        return;
    }

    if (HitEffects[ST].HitSound != none)
    {
        PlaySound(HitEffects[ST].HitSound, SLOT_None, TransientSoundVolume, false, RandRange(MinSoundRadius, MaxSoundRadius),, true);
    }

    if (Owner == none || Owner.EffectIsRelevant(HitLoc, false)) // added effect relevance check, using owning bullet actor to call the function
    {
        if (HitEffects[ST].HitDecal != none)
        {
            Spawn(HitEffects[ST].HitDecal, self,, Location, Rotation);
        }

        if (HitEffects[ST].HitEffect != none)
        {
            Spawn(HitEffects[ST].HitEffect,,, HitLoc, Rotator(HitNormal));
        }

        if (HitEffects[ST].FlashEffect != none)
        {
            Spawn(HitEffects[ST].FlashEffect,,, HitLoc, Rotator(HitNormal));
        }
    }
}

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
    bNetTemporary=true
    LifeSpan=0.5
    DrawType=DT_None
    MinSoundRadius=200
    MaxSoundRadius=300
    SoundVolume=1.0
    TransientSoundVolume=1.0
}
