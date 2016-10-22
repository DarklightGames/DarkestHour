//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_SatchelCharge10lb10sProjectile extends DHThrowableExplosiveProjectile; // incorporating SatchelCharge10lb10sProjectile & ROSatchelChargeProjectile

// Modified to record SavedInstigator & SavedPRI
simulated function PostBeginPlay()
{
    if (Role == ROLE_Authority)
    {
        Velocity = Speed * vector(Rotation);

        if (Instigator != none && Instigator.HeadVolume.bWaterVolume)
        {
            Velocity = 0.25 * Velocity;
        }
    }

    Acceleration = 0.5 * PhysicsVolume.Gravity;

    if (Instigator != none)
    {
        InstigatorController = Instigator.Controller;
        SavedInstigator = Instigator;
        SavedPRI = Instigator.PlayerReplicationInfo;

        if (InstigatorController != none && InstigatorController.PlayerReplicationInfo != none && InstigatorController.PlayerReplicationInfo.Team != none)
        {
            ThrowerTeam = InstigatorController.PlayerReplicationInfo.Team.TeamIndex;
        }
    }
}

// Modified to check whether satchel blew up in a special Volume that needs to be triggered
function BlowUp(vector HitLocation)
{
    local ROObjSatchel SatchelObjActor;
    local Volume       V;

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

    foreach TouchingActors(class'Volume', V)
    {
        if (ROObjSatchel(V.AssociatedActor) != none)
        {
            SatchelObjActor = ROObjSatchel(V.AssociatedActor);

            if (SatchelObjActor.WithinArea(self))
            {
                SatchelObjActor.Trigger(self, SavedInstigator);
            }
        }

        if (V.IsA('RODemolitionVolume'))
        {
            RODemolitionVolume(V).Trigger(self, SavedInstigator);
        }
    }
}

// Implemented here to go to dynamic lighting for a split second, when satchel blows up
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
    bAlwaysRelevant=true
    StaticMesh=StaticMesh'WeaponPickupSM.Projectile.Satchel_throw'
    CollisionRadius=4.0
    CollisionHeight=4.0

    FuzeLengthTimer=15.0
    Speed=300.0
    Damage=550.0 // was 600 in 5.1
    DamageRadius=500.0 // was 725.0 in 5.1
    MyDamageType=class'DH_Weapons.DH_SatchelDamType'

    ExplosionSoundRadius=4000.0
    ExplosionSound(0)=sound'Inf_Weapons.satchel.satchel_explode01'
    ExplosionSound(1)=sound'Inf_Weapons.satchel.satchel_explode02'
    ExplosionSound(2)=sound'Inf_Weapons.satchel.satchel_explode03'
    ExplodeDirtEffectClass=class'ROEffects.ROSatchelExplosion'
    ExplodeSnowEffectClass=class'ROEffects.ROSatchelExplosion'
    ExplodeMidAirEffectClass=class'ROEffects.ROSatchelExplosion'

    BlurTime=6.0
    BlurEffectScalar=1.75
    ShakeRotMag=(X=0.0,Y=0.0,Z=300.0)
    ShakeRotRate=(Z=2500.0)
    ShakeRotTime=3.0
    ShakeOffsetMag=(Z=10.0)
    ShakeOffsetRate=(Z=200.0)
    ShakeOffsetTime=5.0
    ShakeScale=2.5
}
