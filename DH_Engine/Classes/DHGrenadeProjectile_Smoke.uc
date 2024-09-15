//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGrenadeProjectile_Smoke extends DHGrenadeProjectile
    abstract;

var() class<DHSmokeEffectAttachment> SmokeAttachmentClass;

var enum ESmokeType
{
    ST_Hexachloroethane,
    ST_WhitePhosphorus
} SmokeType;

// Gas damage for white phosphorus grenades.
var() class<DamageType>   WhitePhosphorusGasDamageClass;
var() float               WhitePhosphorusGasDamageAmount;
var() float               WhitePhosphorusGasDamageRadius;
var() float               WhitePhosphorusGasDamageLifeSpan;

function SpawnGasHurtRadius()
{
    local DHHurtRadius HurtRadiusActor;

    if (WhitePhosphorusGasDamageClass == none)
    {
        Warn("Cannot spawn white phosphorus hurt radius because no damage type is set");
        return;
    }

    HurtRadiusActor = Spawn(class'DHHurtRadius', self,, Location);

    if (HurtRadiusActor != none)
    {
        HurtRadiusActor.DamageAmount = WhitePhosphorusGasDamageAmount;
        HurtRadiusActor.DamageRadius = WhitePhosphorusGasDamageRadius;
        HurtRadiusActor.LifeSpan = WhitePhosphorusGasDamageLifeSpan;
        HurtRadiusActor.DamageType = WhitePhosphorusGasDamageClass;
        HurtRadiusActor.SetDamageTimerRate(2.0);
    }
}

// Function emptied out to remove everything relating to explosion, as not an exploding grenade
simulated function Destroyed()
{
}

function SpawnSmokeAttachment()
{
    local DHSmokeEffectAttachment SmokeAttachment;

    SmokeAttachment = Spawn(SmokeAttachmentClass, self,, Location);
    SmokeAttachment.SetBase(self);
}

state ReleasingSmoke
{
    function BeginState()
    {
        local Sound MyExplosionSound;

        super.BeginState();

        // Do damage.
        BlowUp(Location);

        bHasExploded = true;

        // Spawn smoke effect
        SpawnSmokeAttachment();

        if (SmokeType == ST_WhitePhosphorus)
        {
            // Hide the grenade and stop it from moving.
            bHidden = true;
            SetPhysics(PHYS_None);

            SpawnGasHurtRadius();
        }

        // Play explosion sound
        MyExplosionSound = ExplosionSound[Rand(arraycount(ExplosionSound))];

        if (MyExplosionSound != none)
        {
            PlaySound(MyExplosionSound, SLOT_NONE, ExplosionSoundVolume,, ExplosionSoundRadius, 1.0, true);
        }

        // This actor will persist as long as the smoke sound, then stay inert on
        // ground for an extra 10 secs & then auto-destroy.
        LifeSpan = SmokeAttachmentClass.default.SmokeSoundDuration + 10.0;
    }

    simulated function Explode(vector HitLocation, vector HitNormal);
}

// Modified to add smoke effects & to remove actor destruction on client
// Actor is torn off & then destroyed on server, but persists for its LifeSpan on clients so grenade is still visible on ground & makes the smoke sound
simulated function Explode(vector HitLocation, vector HitNormal)
{
    if (Role == ROLE_Authority)
    {
        GotoState('ReleasingSmoke');
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

    WhitePhosphorusGasDamageAmount=5
    WhitePhosphorusGasDamageClass=class'DHShellSmokeWPGasDamageType'
    WhitePhosphorusGasDamageLifeSpan=30.0
    WhitePhosphorusGasDamageRadius=180.0    // 3 meters

    ExplosionSound(0)=None
    ExplosionSound(1)=None
    ExplosionSound(2)=None
}
