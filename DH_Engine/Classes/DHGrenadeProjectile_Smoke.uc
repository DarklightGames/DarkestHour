//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGrenadeProjectile_Smoke extends DHGrenadeProjectile
    abstract;

var() class<DHSmokeEffectAttachment> SmokeAttachmentClass;

// Function emptied out to remove everything relating to explosion, as not an exploding grenade
simulated function Destroyed()
{
}

function SpawnSmokeAttachment()
{
    local DHSmokeEffectAttachment SmokeAttachment;

    if (SmokeAttachment != none)
    {
        SmokeAttachment = Spawn(SmokeAttachmentClass, self);
        SmokeAttachment.SetBase(self);
    }
}

// Modified to add smoke effects & to remove actor destruction on client
// Actor is torn off & then destroyed on server, but persists for its LifeSpan on clients so grenade is still visible on ground & makes the smoke sound
simulated function Explode(vector HitLocation, vector HitNormal)
{
    if (Role == ROLE_Authority)
    {
        SpawnSmokeAttachment();

        // This actor will persist as long as the smoke sound, then stay inert on ground for an extra 10 secs & then auto-destroy.
        LifeSpan = 30;
    }
}

// Modified to remove everything relating to explosion & damage, as not an exploding grenade
function BlowUp(vector HitLocation)
{
    if (Role == ROLE_Authority)
    {
        MakeNoise(1.0);
    }
}

defaultproperties
{
    bAlwaysRelevant=true // has to be always relevant so that the smoke effect always gets spawned
    DudChance=0.0 // don't have smoke grenades fail
    Damage=0.0
    DamageRadius=0.0
    SoundVolume=255
    SoundRadius=200.0
    SmokeAttachmentClass=class'DH_Effects.DHSmokeEffectAttachment'
}
