//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_SatchelCharge10lb10sProjectile extends DH_ThrowableExplosiveProjectile; // incorporating SatchelCharge10lb10sProjectile & ROSatchelChargeProjectile

// from ROSatchelChargeProjectile (used in other classes):
var PlayerReplicationInfo SavedPRI;
var Pawn SavedInstigator;

simulated function PostBeginPlay()
{
    if (Role == ROLE_Authority)
    {
        Velocity = Speed * vector(Rotation);

        if (Instigator.HeadVolume.bWaterVolume)
        {
            Velocity = 0.25 * Velocity;
        }
    }

    if (Instigator != none)
    {
        InstigatorController = Instigator.Controller;
        SavedInstigator = Instigator;
        SavedPRI = Instigator.PlayerReplicationInfo;
    }

    Acceleration = 0.5 * PhysicsVolume.Gravity;

    if (InstigatorController != none)
    {
        ThrowerTeam = InstigatorController.PlayerReplicationInfo.Team.TeamIndex;
    }
}

function BlowUp(vector HitLocation)
{
    local ROObjSatchel SatchelObjActor;
    local Volume       DemoVolume;

    if (Instigator != none)
    {
        SavedInstigator = Instigator;
        SavedPRI = Instigator.PlayerReplicationInfo;
    }

    DelayedHurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);

    if (Role == ROLE_Authority)
    {
        MakeNoise(1.0);
    }

    foreach TouchingActors(class'Volume', DemoVolume)
    {
        if (ROObjSatchel(DemoVolume.AssociatedActor) != none)
        {
            SatchelObjActor = ROObjSatchel(DemoVolume.AssociatedActor);

            if (SatchelObjActor.WithinArea(self))
            {
                SatchelObjActor.Trigger(self, SavedInstigator);
            }
        }

        if (RODemolitionVolume(DemoVolume) != none)
        {
            RODemolitionVolume(DemoVolume).Trigger(self, SavedInstigator);
        }
    }
}

simulated function WeaponLight()
{
    if (!Level.bDropDetail)
    {
        bDynamicLight = true;
        SetTimer(0.15, false);
    }
}

simulated function Timer()
{
    bDynamicLight = false;
}

defaultproperties
{
    FuzeLengthTimer=15.0
    Speed=300.0
    Damage=550.000000 //was 600 in 5.1
    DamageRadius=500.000000 //was 725.0 in 5.1
    MyDamageType=class'DH_Weapons.DH_SatchelDamType'
    ExplosionSound(0)=sound'Inf_Weapons.satchel.satchel_explode01'
    ExplosionSound(1)=sound'Inf_Weapons.satchel.satchel_explode02'
    ExplosionSound(2)=sound'Inf_Weapons.satchel.satchel_explode03'
    ExplosionSoundRadius=4000.0
    ExplodeDirtEffectClass=class'ROSatchelExplosion'
    ExplodeSnowEffectClass=class'ROSatchelExplosion'
    ExplodeMidAirEffectClass=class'ROSatchelExplosion'
    CollisionRadius=4.000000
    CollisionHeight=4.000000
    StaticMesh=StaticMesh'WeaponPickupSM.Projectile.Satchel_throw'
    ShakeRotMag=(X=0.0,Y=0.0,Z=300.0)
    ShakeRotRate=(Z=2500.0)
    ShakeRotTime=3.0
    ShakeOffsetMag=(Z=10.0)
    ShakeOffsetRate=(Z=200.0)
    ShakeOffsetTime=5.0
    ShakeScale=2.5
    BlurTime=6.0
    BlurEffectScalar=1.75
}
