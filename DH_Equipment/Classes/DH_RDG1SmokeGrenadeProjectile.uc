//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RDG1SmokeGrenadeProjectile extends StielGranateProjectile;  // TODO: fix hierarchy

#exec OBJ LOAD File=Inf_WeaponsTwo.uax

var     float       DestroyTimer;
var     bool        bCalledDestroy;
var     Emitter     SmokeEmitter;
var     sound       SmokeSound;

simulated function Landed(vector HitNormal)
{
    if (Bounces <= 0)
    {
        SetPhysics(PHYS_None);

        if (Role == ROLE_Authority)
        {
            SetRotation(QuatToRotator(QuatProduct(QuatFromRotator(rotator(HitNormal)), QuatFromAxisAndAngle(HitNormal, Rotation.Yaw * 0.000095873))));
        }
    }
    else
    {
        HitWall(HitNormal, none);
    }
}

simulated function HitWall(vector HitNormal, Actor Wall)
{
    local ESurfaceTypes ST;
    local vector        VNorm;

    GetHitSurfaceType(ST, HitNormal);
    GetDampenAndSoundValue(ST);

    // Return here, this was causing the famous "Nade bug"
    if (ROCollisionAttachment(Wall) != none)
    {
        return;
    }

    Bounces--;

    if (Bounces <= 0)
    {
        bBounce = false;
    }
    else
    {
        // Reflect off Wall w/damping
        VNorm = (Velocity dot HitNormal) * HitNormal;
        Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;
        Speed = VSize(Velocity);
    }

    if ((Level.NetMode != NM_DedicatedServer) && (Speed > 150.0) && ImpactSound != none)
    {
        PlaySound(ImpactSound, SLOT_Misc, 1.1); // increase volume of impact
    }
}

function BlowUp(vector HitLocation)
{
    if (Role == ROLE_Authority)
    {
        MakeNoise(1.0);
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    BlowUp(HitLocation);

    if (Role == ROLE_Authority)
    {
        AmbientSound = SmokeSound;
    }

    PlaySound(ExplosionSound[Rand(3)],, 1.0,, 200.0);

    if (Level.NetMode != NM_DedicatedServer)
    {
        SmokeEmitter = Spawn(ExplodeDirtEffectClass,self,, Location, rotator(vect(0.0, 0.0, 1.0)));
        SmokeEmitter.SetBase(self);
    }
}

simulated function Destroyed()
{
    super(ROThrowableExplosiveProjectile).Destroyed();

    if (SmokeEmitter != none)
    {
        SmokeEmitter.Kill();
    }
}

function Reset()
{
    if (SmokeEmitter != none)
    {
        SmokeEmitter.Destroy();
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
        Destroy();
    }
}

defaultproperties
{
    DestroyTimer=30.0
    SmokeSound=sound'Inf_WeaponsTwo.smokegrenade.smoke_loop'
    ExplodeDirtEffectClass=class'ROEffects.GrenadeSmokeEffect'
    ExplosionSound(0)=sound'Inf_WeaponsTwo.smokegrenade.smoke_ignite'
    ExplosionSound(1)=sound'Inf_WeaponsTwo.smokegrenade.smoke_ignite'
    ExplosionSound(2)=sound'Inf_WeaponsTwo.smokegrenade.smoke_ignite'
    Damage=0.0
    DamageRadius=0.0
    MyDamageType=class'DH_Equipment.DH_RDG1SmokeGrenadeDamType'
    StaticMesh=StaticMesh'WeaponPickupSM.Projectile.RGD1_throw'
    bAlwaysRelevant=true
    LifeSpan=30.0
    SoundVolume=255
    SoundRadius=200.0
}
