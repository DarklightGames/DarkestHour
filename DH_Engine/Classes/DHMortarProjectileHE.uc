//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMortarProjectileHE extends DHMortarProjectile
    abstract;

// Explosion effect emitters & sounds
var     class<DHHitEffect>      ImpactEffect; // effect to spawn when round hits something other than a vehicle (handles sound & visual effect)

// View shake
var     float           BlurTime;         // how long blur effect should last for this shell
var     float           BlurEffectScalar; // how much to scale blur & shake effect
var     Vector          ShakeRotMag;      // how far to rot view
var     Vector          ShakeRotRate;     // how fast to rot view
var     float           ShakeRotTime;     // how much time to rot the instigator's view
var     Vector          ShakeOffsetMag;   // max view offset vertically
var     Vector          ShakeOffsetRate;  // how fast to offset view vertically
var     float           ShakeOffsetTime;  // how much time to offset view

// Modified to stop shell from blowing up if it's in a no arty volume (just make the shell a dud if it is)
simulated function Explode(Vector HitLocation, Vector HitNormal)
{
    local DHVolumeTest VT;

    if (Role == ROLE_Authority && !bDud)
    {
        VT = Spawn(Class'DHVolumeTest',,, HitLocation);

        if (VT != none)
        {
            bDud = VT.DHIsInNoArtyVolume(DHGameReplicationInfo(Level.Game.GameReplicationInfo));

            VT.Destroy();
        }
    }

    super.Explode(HitLocation, HitNormal);
}

// Modified to cause blast damage
function BlowUp(Vector HitLocation)
{
    super.BlowUp(HitLocation);

    if (Role == ROLE_Authority)
    {
        DelayedHurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
    }
}

// Modified to only play impact effects for a dud HE shell, as if it does explode the explosion effects will 'drown out' the smaller impact effects
simulated function SpawnImpactEffects(Vector HitLocation, Vector HitNormal)
{
    if (bDud)
    {
        super.SpawnImpactEffects(HitLocation, HitNormal);
    }
}

// Implemented for HE shell explosion
// TODO: Need to add throwing ragdoll bodies around, same as other HE shells exploding
// But also need to add a mechanism to stop server destroying projectile before client has time to trigger this locally & play explosion effects (there are several solutions)
simulated function SpawnExplosionEffects(Vector HitLocation, Vector HitNormal)
{
    // Note no EffectIsRelevant() check as explosion is big & not instantaneous, so player may hear sound & turn towards explosion & must be able to see it)
    if (Level.NetMode != NM_DedicatedServer)
    {
        Spawn(ImpactEffect, self,, Location, Rotator(-HitNormal));

        DoShakeEffect();
    }
}

// New function to do screen shake & blur based on player's proximity to explosion
simulated function DoShakeEffect()
{
    local PlayerController PC;
    local float            Distance, MaxShakeDistance, Scale;

    PC = Level.GetLocalPlayerController();

    if (PC != none && PC.ViewTarget != none)
    {
        Distance = VSize(Location - PC.ViewTarget.Location);
        MaxShakeDistance = DamageRadius * 2.0;

        if (Distance < MaxShakeDistance)
        {
            // Screen shake
            Scale = (MaxShakeDistance - Distance) / MaxShakeDistance * BlurEffectScalar;
            PC.ShakeView(ShakeRotMag * Scale, ShakeRotRate, ShakeRotTime, ShakeOffsetMag * Scale, ShakeOffsetRate, ShakeOffsetTime);

            // Screen blur
            if (PC.IsA('ROPlayer'))
            {
                ROPlayer(PC).AddBlur(BlurTime * Scale, FMin(1.0, Scale));
            }
        }
    }
}

defaultproperties
{
    MyDamageType=Class'DHMortarDamageType'
    MomentumTransfer=75000.0
    
    ImpactEffect=Class'DHMortarHitEffect' //default for 60mm HE projectile

    HitMapMarkerClass=Class'DHMapMarker_ArtilleryHit_HE'

    ShakeRotMag=(Z=100.0)
    ShakeRotRate=(Z=2500.0)
    ShakeRotTime=3.0
    ShakeOffsetMag=(Z=5.0)
    ShakeOffsetRate=(Z=200.0)
    ShakeOffsetTime=5.0
}
