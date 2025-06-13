//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_SatchelCharge10lb10sProjectile extends DHThrowableExplosiveProjectile; // incorporating SatchelCharge10lb10sProjectile & ROSatchelChargeProjectile

var float           UnderneathDamageMultiplier; // Damage Multiplier for when the satchel dets under a vehicle

var float           ConstructionDamageRadius;   // A radius that will damage Contructions
var float           ConstructionDamageMax;

var float           ObstacleDamageRadius;       // A radius that will damage Obstacles
var float           ObstacleDamageMax;

var float           EngineDamageMassThreshold;  // A mass threshold at which a vehicle will take min damage instead of setting the engine on fire
var float           EngineDamageRadius;         // A radius that will damage Vehicle Engines
var float           EngineDamageMax;

var float           TreadDamageMassThreshold;   // A mass threshold at which a vehicle will take min damage instead of destroying the tread outright
var float           TreadDamageRadius;          // A radius that will damage Vehicle Treads
var float           TreadDamageMax;

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
simulated function BlowUp(Vector HitLocation)
{
    if (Instigator != none)
    {
        SavedInstigator = Instigator;
        SavedPRI = Instigator.PlayerReplicationInfo;
    }

    if (Role == ROLE_Authority)
    {
        DelayedHurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
        HandleObjSatchels(HitLocation);
        HandleVehicles(HitLocation);
        HandleObstacles(HitLocation);
        HandleConstructions(HitLocation);
        MakeNoise(1.0);
    }
}

function HandleObjSatchels(Vector HitLocation)
{
    local DH_ObjSatchel SatchelObjActor;
    local Volume        V;

    foreach TouchingActors(Class'Volume', V)
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

function HandleVehicles(Vector HitLocation)
{
    local Actor         A;
    local Vector        HitLoc, HitNorm;
    local DHVehicle     Veh;
    local int           TrackNum;
    local float         Distance, DistanceFactor;
    local bool          bExplodedOnVehicle, bExplodedUnderVehicle;

    // Find out if we are on a vehicle
    A = Trace(HitLoc, HitNorm, Location - vect(0.0, 0.0, 16.0), Location, true);
    bExplodedOnVehicle = DHVehicle(A) != none;

    // Find out if we are under a vehicle
    if (!bExplodedOnVehicle)
    {
        A = Trace(HitLoc, HitNorm, Location + vect(0.0, 0.0, 32.0), Location, true);
        bExplodedUnderVehicle = DHVehicle(A) != none;
    }

    // Handle vehicle component damage
    foreach RadiusActors(Class'DHVehicle', Veh, DamageRadius)
    {
        // If this is the vehicle we exploded on or under
        if (Veh == A)
        {
            // Handle engine damage
            if (bExplodedOnVehicle && !Veh.IsVehicleBurning())
            {
                Distance = VSize(Location - Veh.GetEngineLocation());

                // The chance of setting the engine on fire is based on the distance from the engine.
                // The closer the satchel is to the engine, the higher the chance of setting it on fire.
                // The chance is 100% at the engine, and 0% at the edge of the EngineDamageRadius, using
                // a smoothstep function.
                DistanceFactor = Class'UInterp'.static.SmoothStep(Distance / EngineDamageRadius, 1, 0);

                if (FRand() < DistanceFactor)
                {
                    Veh.StartEngineFire(SavedInstigator);
                }
                else // Otherwise do minor damage to the engine
                {
                    Veh.DamageEngine(EngineDamageMax * (Distance / EngineDamageRadius), SavedInstigator, vect(0,0,0), vect(0,0,0), MyDamageType);
                }
            }

            // Handle doing additional damage if exploded underneath vehicle
            if (bExplodedUnderVehicle)
            {
                Veh.TakeDamage(Damage * UnderneathDamageMultiplier, SavedInstigator, vect(0,0,0), vect(0,0,0), MyDamageType);
            }
        }

        // Set Distance to TreadDamageRadius, we don't want TreadDamageRadius to change, but want Distance to be changed in IsTreadInRadius()
        Distance = TreadDamageRadius;

        // Handle destroying the treads
        if (Veh.bHasTreads && Veh.IsTreadInRadius(Location, Distance, TrackNum))
        {
            // If enough strength we can detrack the vehicle instantly
            if (TreadDamageMassThreshold > Veh.VehicleMass * Veh.SatchelResistance)
            {
                Veh.DestroyTrack(bool(TrackNum));
            }
            else // Otherwise do minor damge to the tracks
            {
                Veh.DamageTrack(TreadDamageMax * (Distance / TreadDamageRadius), bool(TrackNum));
            }
        }
    }
}

// Allows satchels to damage obstacles when behind world geometry
function HandleObstacles(Vector HitLocation)
{
    local DHObstacleInstance O;
    local float              Distance;

    foreach RadiusActors(Class'DHObstacleInstance', O, ObstacleDamageRadius)
    {
        // If we cannot trace the obstacle (because of world geometry), then apply special radius damage
        if (O != none && !FastTrace(O.Location, Location))
        {
            Distance = VSize(Location - O.Location);
            O.TakeDamage(ObstacleDamageMax * (Distance / ObstacleDamageRadius), SavedInstigator, vect(0,0,0), vect(0,0,0), MyDamageType);
        }
    }
}

// Allows satchels to do damage to constructions when traces fail (useful if construction is on the otherside of terrain or origin under world)
function HandleConstructions(Vector HitLocation)
{
    local DHConstruction    C;
    local float             Distance;

    foreach RadiusActors(Class'DHConstruction', C, ConstructionDamageRadius)
    {
        // If we cannot trace the construction (because trace hit world geometry), then apply special radius damage
        if (C != none && !FastTrace(C.Location, Location))
        {
            Distance = VSize(Location - C.Location);
            C.TakeDamage(ConstructionDamageMax * (Distance / ConstructionDamageRadius), SavedInstigator, vect(0,0,0), vect(0,0,0), MyDamageType);
        }
    }
}

defaultproperties
{
    bAlwaysRelevant=true
    StaticMesh=StaticMesh'WeaponPickupSM.Satchel_throw'
    CollisionRadius=4.0
    CollisionHeight=4.0

    Speed=300.0
    Damage=1200.0
    DamageRadius=1200.0

    UnderneathDamageMultiplier=8.0

    ConstructionDamageRadius=375
    ConstructionDamageMax=750

    ObstacleDamageRadius=500
    ObstacleDamageMax=1400

    EngineDamageMassThreshold=200.0 //3kg TNT should penetrate any top armor or engine desk and severely damage anything under it (even if it is a Maus tank)
    EngineDamageRadius=240.0 //slightly increased because often it seemed like its not close enough even if its on the engine desk
    EngineDamageMax=5000.0

    TreadDamageMassThreshold=200.0
    TreadDamageRadius=100.0
    TreadDamageMax=200.0

    MyDamageType=Class'DH_SatchelDamType'

    ExplosionSoundRadius=4000.0
    ExplosionSound(0)=Sound'Inf_Weapons.satchel_explode01'
    ExplosionSound(1)=Sound'Inf_Weapons.satchel_explode02'
    ExplosionSound(2)=Sound'Inf_Weapons.satchel_explode03'
    ExplodeDirtEffectClass=Class'ROSatchelExplosion'
    ExplodeSnowEffectClass=Class'ROSatchelExplosion'
    ExplodeMidAirEffectClass=Class'ROSatchelExplosion'

    ImpactSound=Sound'DH_WeaponSounds.satcheldrops'
    ImpactSoundDirt=Sound'DH_WeaponSounds.satcheldrops'
    ImpactSoundWood=Sound'DH_WeaponSounds.satcheldrops'
    ImpactSoundMetal=Sound'DH_WeaponSounds.satcheldrops'
    ImpactSoundMud=Sound'DH_WeaponSounds.satcheldrops'
    ImpactSoundGrass=Sound'DH_WeaponSounds.satcheldrops'
    ImpactSoundConcrete=Sound'DH_WeaponSounds.satcheldrops'

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
