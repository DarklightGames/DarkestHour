//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ROTankCannonShellSmoke extends DH_ROTankCannonShellHE;

// Matt: removed as this stuff isn't necessary
// var()  float            DestroyTimer;
// var    bool             bCalledDestroy;

var    Emitter          SmokeEmitter;
var()  class<Emitter>   SmokeEffectClass;
var    sound            SmokeSound; // Matt: added, similar to smoke grenade, & set AmbientSound to SmokeSound in Explode


// Modified to add smoke effects
simulated function Explode(vector HitLocation, vector HitNormal)
{
    if (!bCollided)
    {
        super.Explode(HitLocation, HitNormal);

        if (Level.NetMode != NM_DedicatedServer)
        {
            SmokeEmitter = Spawn(SmokeEffectClass, self, , HitLocation, rotator(-HitNormal));
        }

        if (Role == ROLE_Authority)
        {
            AmbientSound = SmokeSound; // start playing the smoke emission sound
        }
    }
}

// Matt: instead of destroying shell, we have to keep it so it can destroy SmokeEmitter on net client if Reset is called (but we'll turn off all collision & minimise net load)
simulated function HandleDestruction()
{
    SetCollision(false, false);
    bCollideWorld = false;
    LifeSpan = SmokeEffectClass.default.LifeSpan; // so this actor will remain as long as the SmokeEmitter (much simpler than using Tick and a DestroyTime)
    NetUpdateFrequency = 1.0;
    NetPriority = 0.5;
}

// Matt: modified to destroy the SmokeEmitter on the client when the shell gets destroyed
// Necessary to prevent the SmokeEmitter from persisting if game is reset - Reset is only called serverside, but it destroys the shell on both server & client
simulated function Destroyed()
{
    super.Destroyed();

    if (SmokeEmitter != none)
    {
        SmokeEmitter.Destroy();
    }
}

/* // Matt: removed these functions as this stuff isn't necessary & didn't work to prevent the SmokeEmitter from persisting on clients if the game was reset
simulated function KillSmoke()
{
    if (SmokeEmitter != none)
    {
        SmokeEmitter.Kill();
    }
}

function Reset()
{
    if (SmokeEmitter != none)
    {
        SmokeEmitter.Destroyed();
    }

    super.Reset();
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

    DestroyTimer -= DeltaTime;

    if (DestroyTimer <= 0.0 && !bCalledDestroy)
    {
        bCalledDestroy = true;
        KillSmoke();
    }
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

    if (bCollided && Level.NetMode == NM_DedicatedServer)
    {
        if (DestroyTime <= 0.0)
        {
            Destroy();
        }
        else
        {
            DestroyTime -= DeltaTime;
        }
    }
}
*/

defaultproperties
{
    RoundType=RT_Smoke
//  DestroyTimer=20.000000
    SmokeEffectClass=class'DH_Effects.DH_SmokeShellEffect'
    bMechanicalAiming=true
    bOpticalAiming=true
    ImpactDamage=20
    SmokeSound=Sound'Inf_WeaponsTwo.smokegrenade.smoke_loop'
    BallisticCoefficient=0.6
    SpeedFudgeScale=0.75
    MaxSpeed=500.0
    Damage=75.0
    DamageRadius=50.0
    LifeSpan=12.0
    AmbientGlow=50
    SoundVolume=175
    SoundRadius=500.000000
    TransientSoundVolume=0.750000
    TransientSoundRadius=750.000000
}
