//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_SatchelCharge10lb10sProjectile extends DHThrowableExplosiveProjectile; // incorporating SatchelCharge10lb10sProjectile & ROSatchelChargeProjectile

// Modified to record SavedInstigator & SavedPRI
// RODemolitionChargePlacedMsg from ROSatchelChargeProjectile is omitted
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Instigator != none)
    {
        SavedInstigator = Instigator;
        SavedPRI = Instigator.PlayerReplicationInfo;
    }
}

// Modified to check whether satchel blew up in a special Volume that needs to be triggered
simulated function BlowUp(vector HitLocation)
{
    local DH_ObjSatchel SatchelObjActor;
    local Volume        V;

    if (Instigator != none)
    {
        SavedInstigator = Instigator;
        SavedPRI = Instigator.PlayerReplicationInfo;
    }

    super.BlowUp(HitLocation);

    // TODO: triggering these special actors appears only appears to do stuff on an authority role, so suspect this can be made authority only
    // Then we can probably remove bAlwaysRelevant from this actor, as doing this on a net client is the only reason I can guess caused bAlwaysRelevant to be set for satchel?
    foreach TouchingActors(class'Volume', V)
    {
        if (DH_ObjSatchel(V.AssociatedActor) != none)
        {
            SatchelObjActor = DH_ObjSatchel(V.AssociatedActor);

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

// Implemented here to go to dynamic lighting for a split second, when satchel blows up // TODO: doesn't appear to do anything noticeable?
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
