//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BulletHitEffect extends ROBulletHitEffect;

//=============================================================================
// Functions
//=============================================================================

//-----------------------------------------------------------------------------
// PostNetBeginPlay
//-----------------------------------------------------------------------------
simulated function PostNetBeginPlay()
{
    local ESurfaceTypes ST;
    local vector HitLoc, HitNormal;
    local Material HitMat;

    if (Level.NetMode == NM_DedicatedServer)
        return;
    //Velocity
    Trace(HitLoc, HitNormal, Location + vector(Rotation) * 16, Location, false,, HitMat);

    //Level.Game.Broadcast(self, "HitMat = " $HitMat.SurfaceType$" Effect = "$HitEffects[ST].Effect$" Particle Effect = "$HitEffects[ST].ParticleEffect$" TempEffect = "$HitEffects[ST].TempEffect);
    //log("

    if (HitMat == none)
        ST = EST_Default;
    else
        ST = ESurfaceTypes(HitMat.SurfaceType);

//  Level.Game.Broadcast(self, "HitMat = " $HitMat.SurfaceType$" Effect = "$HitEffects[ST].Effect$" Particle Effect = "$HitEffects[ST].ParticleEffect$" TempEffect = "$HitEffects[ST].TempEffect);

    if (HitEffects[ST].HitDecal != none)
        Spawn(HitEffects[ST].HitDecal, self,, Location, Rotation);

    if (HitEffects[ST].HitSound != none)
        PlaySound(HitEffects[ST].HitSound, SLOT_None, 30.0, false, 100.0);

    if (HitEffects[ST].HitEffect != none)
        Spawn(HitEffects[ST].HitEffect,,, HitLoc, rotator(HitNormal));
}

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
}
