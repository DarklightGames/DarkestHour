//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_SatchelCharge10lb10sProjectile extends DHThrowableExplosiveProjectile; // incorporating SatchelCharge10lb10sProjectile & ROSatchelChargeProjectile

var float           VehHitPointDamageRadius;   // A radius that determines direct damage to vehicle components
var float           ComponentDamageStrength;   // If this is > the vehicle's mass, it will automatically affect the component instead of just doing damage
var float           ComponentDamageMin;        // How much to damage component if vehicle's mass > ComponentDamageStrength

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
    local DHVehicle     Veh;
    local DH_ObjSatchel SatchelObjActor;
    local Volume        V;
    local int           TrackNum;

    if (Instigator != none)
    {
        SavedInstigator = Instigator;
        SavedPRI = Instigator.PlayerReplicationInfo;
    }

    if (Role == ROLE_Authority)
    {
        if (bBounce)
        {
            // If the grenade hasn't landed, do 1/3 less damage
            // This isn't supposed to be realistic, its supposed to make airbursts less effective so players are more apt to throw grenades more authentically
            DelayedHurtRadius(Damage * 0.75, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
        }
        else
        {
            DelayedHurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
        }

        // Handle triggering DH_ObjSatchels
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

        // Handle vehicle component damage
        foreach RadiusActors(class'DHVehicle', Veh, DamageRadius)
        {
            // Handle engine damage
            if (!Veh.IsVehicleBurning() && VSize(Location - Veh.GetEngineLocation()) < VehHitPointDamageRadius)
            {
                // If enough strength, set the engine on fire
                if (ComponentDamageStrength > Veh.VehicleMass * Veh.SatchelResistance)
                {
                    Veh.StartEngineFire(SavedInstigator);
                }
                else // Otherwise do minor damage to the engine
                {
                    Veh.DamageEngine(ComponentDamageMin, SavedInstigator, vect(0,0,0), vect(0,0,0), MyDamageType);
                }
            }

            // Handle destroying the treads
            if (Veh.bHasTreads && Veh.IsTreadInRadius(Location, VehHitPointDamageRadius, TrackNum))
            {
                // If enough strength we can detrack the vehicle instantly
                if (ComponentDamageStrength > Veh.VehicleMass * Veh.SatchelResistance)
                {
                    Veh.DestroyTrack(bool(TrackNum));
                }
                else // Otherwise do minor damge to the tracks
                {
                    Veh.DamageTrack(ComponentDamageMin, bool(TrackNum));
                }
            }
        }

        MakeNoise(1.0);
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
    Damage=750.0
    DamageRadius=750.0
    VehHitPointDamageRadius=150.0
    ComponentDamageStrength=20.0
    ComponentDamageMin=55.0

    MyDamageType=class'DH_Weapons.DH_SatchelDamType'

    ExplosionSoundRadius=4000.0
    ExplosionSound(0)=Sound'Inf_Weapons.satchel.satchel_explode01'
    ExplosionSound(1)=Sound'Inf_Weapons.satchel.satchel_explode02'
    ExplosionSound(2)=Sound'Inf_Weapons.satchel.satchel_explode03'
    ExplodeDirtEffectClass=class'ROEffects.ROSatchelExplosion'
    ExplodeSnowEffectClass=class'ROEffects.ROSatchelExplosion'
    ExplodeMidAirEffectClass=class'ROEffects.ROSatchelExplosion'

    BlurTime=6.0
    BlurEffectScalar=2.1
    ShakeRotMag=(X=0.0,Y=0.0,Z=300.0)
    ShakeRotRate=(Z=2500.0)
    ShakeRotTime=3.0
    ShakeOffsetMag=(Z=10.0)
    ShakeOffsetRate=(Z=200.0)
    ShakeOffsetTime=5.0
    ShakeScale=2.5
}
