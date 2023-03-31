//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
    var sound               HitSound;
};

//overwritten from ROHitEffect to expand array to 50 from 20
var()   DHHitEffectData       HitEffects[50];

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
        PlaySound(HitEffects[ST].HitSound, SLOT_None, 1.0, false, RandRange(200.0, 300.0),, true);
    }

    if (Owner == none || Owner.EffectIsRelevant(HitLoc, false)) // added effect relevance check, using owning bullet actor to call the function
    {
        if (HitEffects[ST].HitDecal != none)
        {
            Spawn(HitEffects[ST].HitDecal, self,, Location, Rotation);
        }

        if (HitEffects[ST].HitEffect != none)
        {
            Spawn(HitEffects[ST].HitEffect,,, HitLoc, rotator(HitNormal));
        }

        if (HitEffects[ST].FlashEffect != none)
        {
            Spawn(HitEffects[ST].FlashEffect,,, HitLoc, rotator(HitNormal));
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
}
