//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_GrenadeProjectile_Smoke extends DH_GrenadeProjectile
    abstract;

var float   DestroyTimer;
var bool    bCalledDestroy;
var Emitter SmokeEmitter;
var sound   SmokeSound;

    
// Modified to handle destruction of actor after set time
simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

    DestroyTimer -= DeltaTime;

    if (DestroyTimer <= 0.0 && !bCalledDestroy)
    {
        bCalledDestroy = true;
        Destroy();
    }
}

// Modified to remove 'Fear' stuff, as not an exploding grenade
simulated function Landed(vector HitNormal)
{
    if (Bounces <= 0)
    {
        SetPhysics(PHYS_none);
        SetRotation(QuatToRotator(QuatProduct(QuatFromRotator(rotator(HitNormal)), QuatFromAxisAndAngle(HitNormal, Rotation.Yaw * 0.000095873))));

//      if (Role == ROLE_Authority)
//      {
//          Fear = Spawn(class'AvoidMarker');
//          Fear.SetCollisionSize(DamageRadius, 200.0);
//          Fear.StartleBots();
//      }
    }
    else
    {
        HitWall(HitNormal, none);
    }
}

// Modified to add smoke effects & remove actor destruction
simulated function Explode(vector HitLocation, vector HitNormal)
{
    BlowUp(HitLocation);

    if (Role == ROLE_Authority)
    {
        AmbientSound = SmokeSound;
    }

    PlaySound(ExplosionSound[Rand(3)], , 1.0, , 200);

    if (Level.NetMode != NM_DedicatedServer)
    {
        SmokeEmitter = Spawn(ExplodeDirtEffectClass, self, , Location, rotator(vect(0.0,0.0,1.0)));
        SmokeEmitter.SetBase(Self);
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

// Modified to destroy SmokeEmitter & also to remove everything relating to explosion, as not an exploding grenade
simulated function Destroyed()
{
    // Matt: removed as the super is mostly about blast damage & also destroying the bot Fear marker, neither of which are relevant to a smoke grenade
//  super(ROThrowableExplosiveProjectile).Destroyed();

    if (SmokeEmitter != none)
    {
        SmokeEmitter.Kill();
    }
}

// Modified to destroy SmokeEmitter
function Reset()
{
    if (SmokeEmitter != none)
    {
        SmokeEmitter.Destroy();
    }

    super.Reset();
}

defaultproperties
{
    bAlwaysRelevant=true
    LifeSpan=30.000000
    DestroyTimer=30.000000
    Damage=0.000000
    DamageRadius=0.000000
    ExplodeDirtEffectClass=Class'ROEffects.GrenadeSmokeEffect'
    ExplosionSound(0)=Sound'Inf_WeaponsTwo.smokegrenade.smoke_ignite'
    ExplosionSound(1)=Sound'Inf_WeaponsTwo.smokegrenade.smoke_ignite'
    ExplosionSound(2)=Sound'Inf_WeaponsTwo.smokegrenade.smoke_ignite'
    SmokeSound=Sound'Inf_WeaponsTwo.smokegrenade.smoke_loop'
    SoundVolume=255
    SoundRadius=200.000000
}
