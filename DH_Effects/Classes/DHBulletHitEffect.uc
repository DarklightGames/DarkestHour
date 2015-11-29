//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHBulletHitEffect extends ROBulletHitEffect;

simulated function PostNetBeginPlay()
{
    local ESurfaceTypes ST;
    local vector        HitLoc, HitNormal;
    local Material      HitMat;

    if (Level.NetMode == NM_DedicatedServer)
    {
        return;
    }

    Trace(HitLoc, HitNormal, Location + vector(Rotation) * 16.0, Location, true,, HitMat);

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
        PlaySound(HitEffects[ST].HitSound, SLOT_None, RandRange(10.0, 32.0), false, 32.0,, true);
    }

    if (Owner == none || Owner.EffectIsRelevant(Owner.Location, false)) // added effect relevance check, using owning bullet actor to call the function
    {
        if (HitEffects[ST].HitDecal != none)
        {
            Spawn(HitEffects[ST].HitDecal, self,, Location, Rotation);
        }

        if (HitEffects[ST].HitEffect != none)
        {
            Spawn(HitEffects[ST].HitEffect,,, HitLoc, rotator(HitNormal));
        }
    }
}

defaultproperties
{
}
