//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHAntiVehicleProjectile extends DHBallisticProjectile
    config
    abstract;

enum ERoundType
{
    RT_APC,   // either APC (with just armor-piercing cap) or APCBC (with both armor-piercing cap & ballistic cap)
    RT_HE,
    RT_HVAP,  // HVAP in US parlance - full caliber APCR round
    RT_APDS,  // Sub-caliber tungsten round, discarding sabot; also APCR (sabot'd round that does not discard - Used by Sovs and Germans)
    RT_HEAT,  // includes infantry AT HEAT weapons (e.g. rockets & PIAT)
    RT_Smoke,
    RT_AP,    // basic armor-piercing round, without any cap
    RT_APBC,  // with ballistic cap but not armor-piercing cap (used by Soviets)
    RT_APBULLET // armor-piercing bullet, like PTRD or .50 cal
};

// Projectile characteristics
var     ERoundType      RoundType;               // makes it easier to write more generic functionality & avoid code repetition
var     float           DHPenetrationTable[11];  // array of projectile's penetration capability (in centimetres) at different ranges
var     float           ShellDiameter;           // used in penetration calculations
var     bool            bExplodesOnArmor;        // shell explodes on vehicle armor if it fails to penetrate
var     bool            bExplodesOnHittingBody;  // shell explodes on hitting a human body (otherwise punches through & continues in flight)
var     bool            bExplodesOnHittingWater; // shell explodes on hitting a WaterVolume
var     bool            bBotNotifyIneffective;   // notify bot of an ineffective attack on target

var     array<sound>    ExplosionSound;          // sound of the round exploding (array for random selection)
var     float           ExplosionSoundVolume;    // volume scale factor for the ExplosionSound (allows variance between shells, while keeping other sounds at same volume)
var     bool            bAlwaysDoShakeEffect;    // this shell will always DoShakeEffect when it explodes, not just if hit vehicle armor

// Shatter
var     bool            bShatterProne;           // projectile may shatter on vehicle armor
var     bool            bRoundShattered;         // projectile has shattered
var     class<Emitter>  ShellShatterEffectClass; // effect for this shell shattering against a vehicle
var     sound           ShatterVehicleHitSound;  // sound of this shell shattering on the vehicle
var     sound           ShatterSound[4];         // sound of the round shattering

// Shell Tracer Effects
var     bool            bHasTracer;
var     class<Effects>  CoronaClass;             // shell base tracer effect class
var     Effects         Corona;                  // shell base tracer
var     bool            bHasShellTrail;
var     class<Emitter>  ShellTrailClass;     // shell "streak" emitter effect
var     Emitter         ShellTrail;
var     int             TracerHue;               // allows custom control of ambient light hue
var     int             TracerSaturation;        // allows custom control of ambient light saturation

// AP Bullet Tracer Effects
var     class<Emitter>      TracerEffectClass;
var     Emitter             TracerEffect;
var     StaticMesh          DeflectedMesh;
var     float               TracerPullback;

// Camera shakes
var     vector          ShakeRotMag;             // how far to rot view
var     vector          ShakeRotRate;            // how fast to rot view
var     float           ShakeRotTime;            // how much time to rot the instigator's view
var     vector          ShakeOffsetMag;          // max view offset vertically
var     vector          ShakeOffsetRate;         // how fast to offset view vertically
var     float           ShakeOffsetTime;         // how much time to offset view
var     float           BlurTime;                // how long blur effect should last for this shell
var     float           BlurEffectScalar;        // scales the shake effect
var     float           PenetrationMag;          // different for AP and HE shells and can be set by caliber too

// Debugging
var     bool            bDebuggingText;          // show screen debugging text
var     bool            bDebugInImperial;        // debugging distance/speed is shown in yards/feet instead of metres
var globalconfig bool   bDebugROBallistics;      // sets bDebugBallistics to true for getting the arrow pointers (added from DHBullet so bDebugBallistics can be set in a config file)

// Variables from deprecated ROAntiVehicleProjectile class:
var     Actor           SavedTouchActor;
var     Pawn            SavedHitActor;
var     vector          LaunchLocation;
var     bool            bCollided;
var     float           DestroyTime;                // how long for the server to wait to destroy the actor after it has collided
var     bool            bDidExplosionFX;            // already did the explosion effects

// Impact damage
var class<DamageType>   ShellImpactDamage;
var     int             ImpactDamage;

// Fire variables (new)
var float   HullFireChance;
var float   EngineFireChance;

// Deflection
var     int             NumDeflections;             // so it won't infinitely deflect, getting stuck in a loop
var     float           DampenFactor;               // the smaller the number, the less the projectile will move after deflection
var     float           DampenFactorParallel;
var     bool            bDeflectAOI;                // when true, round can be deflected if AOI is too steep (see DeflectAOI)
var     float           DeflectAOI;                 // if the round impacts armor with >= this angle of incidence, it will deflect
var     bool            bRoundDeflected;            // set to true when the round deflects

// Impact sounds
var     sound           VehicleHitSound;            // sound of this shell penetrating a vehicle
var     sound           VehicleDeflectSound;        // sound of this shell deflecting off a vehicle
var     sound           DirtHitSound;               // sound of this shell hitting dirt
var     sound           RockHitSound;               // sound of this shell hitting rock
var     sound           WaterHitSound;              // sound of this shell hitting water
var     sound           WoodHitSound;               // sound of this shell hitting wood

// Impact effects
var     class<Emitter>  ShellHitVehicleEffectClass; // effect for this shell hitting a vehicle
var     class<Emitter>  ShellDeflectEffectClass;    // effect for this shell deflecting off a vehicle
var     class<Emitter>  ShellHitDirtEffectClass;    // effect for this shell hitting dirt
var     class<Emitter>  ShellHitSnowEffectClass;    // effect for this shell hitting snow
var     class<Emitter>  ShellHitWoodEffectClass;    // effect for this shell hitting wood
var     class<Emitter>  ShellHitRockEffectClass;    // effect for this shell hitting rock
var     class<Emitter>  ShellHitWaterEffectClass;   // effect for this shell hitting water

// Debug
var     bool            bDrawDebugLines;
var     bool            bFirstHit;

// Modified to move bDebugBallistics stuff to PostNetBeginPlay, as net client won't yet have Instigator here
simulated function PostBeginPlay()
{
    LaunchLocation = Location;
    BCInverse = 1.0 / BallisticCoefficient;
    Velocity = vector(Rotation) * Speed;

    if (Role == ROLE_Authority && Instigator != none && Instigator.HeadVolume != none && Instigator.HeadVolume.bWaterVolume)
    {
        Velocity *= 0.5;
    }

    if (Level.NetMode != NM_DedicatedServer && bHasTracer)
    {
        Corona = Spawn(CoronaClass, self);
    }

    if (Level.NetMode != NM_DedicatedServer && bHasShellTrail)
    {
        ShellTrail = Spawn(ShellTrailClass, self);
        ShellTrail.SetBase(self);
    }
}

// Modified to set InstigatorController (used to attribute radius damage kills correctly) & to move bDebugBallistics stuff here from PostBeginPlay (with bDebugROBallistics option)
simulated function PostNetBeginPlay()
{
    local Actor  TraceHitActor;
    local vector HitNormal;
    local float  TraceRadius;

    if (Instigator != none)
    {
        InstigatorController = Instigator.Controller;
    }

    if (bDebugROBallistics)
    {
        bDebugBallistics = true;
    }

    if (Level.NetMode != NM_DedicatedServer && bHasTracer)
    {
        SetDrawType(DT_StaticMesh);
        bOrientToVelocity = true;

        if (RoundType == RT_APBULLET)
        {
            TracerEffect = Spawn(TracerEffectClass, self,, (Location + Normal(Velocity) * TracerPullback));
        }

        if (Level.bDropDetail)
        {
            bDynamicLight = false;
            LightType = LT_None;
        }
        else
        {
            bDynamicLight = true;
            LightType = LT_Steady;
        }

        LightBrightness = 90.0;
        LightRadius = 10.0;
        LightHue = TracerHue;
        LightSaturation = TracerSaturation;
        AmbientGlow = 254;
        LightCone = 16;
    }

    if (bDebugBallistics)
    {
        TraceRadius = 5.0;

        if (Instigator != none)
        {
            TraceRadius += Instigator.CollisionRadius;
        }

        TraceHitActor = Trace(TraceHitLoc, HitNormal, Location + 65355.0 * vector(Rotation), Location + TraceRadius * vector(Rotation), true);

        if (ROBulletWhipAttachment(TraceHitActor) != none)
        {
            TraceHitActor = Trace(TraceHitLoc, HitNormal, Location + 65355.0 * vector(Rotation), TraceHitLoc + 5.0 * vector(Rotation), true);
        }

        Log("Shell debug tracing: TraceHitActor =" @ TraceHitActor);
    }
}

// Disabled no longer use delayed destruction stuff from the Super in ROAntiVehicleProjectile - it's far cleaner just to set a short LifeSpan on a server
simulated function Tick(float DeltaTime)
{
    Disable('Tick');
}

// Borrowed from AB: just using a standard linear interpolation equation here
simulated function float GetMaxPenetration(vector LaunchLocation, vector HitLocation)
{
    local float DistanceMeters, MaxPenetration;

    DistanceMeters = class'DHUnits'.static.UnrealToMeters(VSize(LaunchLocation - Location));

    if      (DistanceMeters < 100.0)   MaxPenetration = DHPenetrationTable[0]  + (100.0  - DistanceMeters) * (DHPenetrationTable[0] - DHPenetrationTable[1])  / 100.0;
    else if (DistanceMeters < 250.0)   MaxPenetration = DHPenetrationTable[1]  + (250.0  - DistanceMeters) * (DHPenetrationTable[0] - DHPenetrationTable[1])  / 150.0;
    else if (DistanceMeters < 500.0)   MaxPenetration = DHPenetrationTable[2]  + (500.0  - DistanceMeters) * (DHPenetrationTable[1] - DHPenetrationTable[2])  / 250.0;
    else if (DistanceMeters < 750.0)   MaxPenetration = DHPenetrationTable[3]  + (750.0  - DistanceMeters) * (DHPenetrationTable[2] - DHPenetrationTable[3])  / 250.0;
    else if (DistanceMeters < 1000.0)  MaxPenetration = DHPenetrationTable[4]  + (1000.0 - DistanceMeters) * (DHPenetrationTable[3] - DHPenetrationTable[4])  / 250.0;
    else if (DistanceMeters < 1250.0)  MaxPenetration = DHPenetrationTable[5]  + (1250.0 - DistanceMeters) * (DHPenetrationTable[4] - DHPenetrationTable[5])  / 250.0;
    else if (DistanceMeters < 1500.0)  MaxPenetration = DHPenetrationTable[6]  + (1500.0 - DistanceMeters) * (DHPenetrationTable[5] - DHPenetrationTable[6])  / 250.0;
    else if (DistanceMeters < 1750.0)  MaxPenetration = DHPenetrationTable[7]  + (1750.0 - DistanceMeters) * (DHPenetrationTable[6] - DHPenetrationTable[7])  / 250.0;
    else if (DistanceMeters < 2000.0)  MaxPenetration = DHPenetrationTable[8]  + (2000.0 - DistanceMeters) * (DHPenetrationTable[7] - DHPenetrationTable[8])  / 250.0;
    else if (DistanceMeters < 2500.0)  MaxPenetration = DHPenetrationTable[9]  + (2500.0 - DistanceMeters) * (DHPenetrationTable[8] - DHPenetrationTable[9])  / 500.0;
    else if (DistanceMeters < 3000.0)  MaxPenetration = DHPenetrationTable[10] + (3000.0 - DistanceMeters) * (DHPenetrationTable[9] - DHPenetrationTable[10]) / 500.0;
    else                               MaxPenetration =  DHPenetrationTable[10];

    if (NumDeflections > 0)
    {
        MaxPenetration = MaxPenetration * 0.04;
    }

    return MaxPenetration;
}

// Modified to handle new collision mesh actor - if we hit a CM we switch hit actor to CM's owner & proceed as if we'd hit that actor
// Also to do splash effects if projectile hits a fluid surface, which wasn't previously handled
// Also re-factored generally to optimise, but original functionality unchanged
simulated singular function Touch(Actor Other)
{
    local vector HitLocation, HitNormal;

    // Added splash if projectile hits a fluid surface
    if (FluidSurfaceInfo(Other) != none)
    {
        CheckForSplash(Location);
    }

    if (Other == none || (!Other.bProjTarget && !Other.bBlockActors))
    {
        return;
    }

    // We use TraceThisActor do a simple line check against the actor we've hit, to get an accurate HitLocation to pass to ProcessTouch()
    // It's more accurate than using our current location as projectile has often travelled further by the time this event gets called
    // But if that trace returns true then it somehow didn't hit the actor, so we fall back to using our current location as the HitLocation
    // Also skip trace & use our location if velocity is zero (touching actor when projectile spawns) or hit a Mover actor (legacy, don't know why)
    if (Velocity == vect(0.0, 0.0, 0.0) || Other.IsA('Mover')
        || Other.TraceThisActor(HitLocation, HitNormal, Location, Location - (2.0 * Velocity), GetCollisionExtent()))
    {
        HitLocation = Location;
    }

    // Special handling for hit on a collision mesh actor - switch hit actor to CM's owner & proceed as if we'd hit that actor
    if (Other.IsA('DHCollisionMeshActor'))
    {
        if (DHCollisionMeshActor(Other).bWontStopShell)
        {
            return; // exit, doing nothing, if col mesh actor is set not to stop a shell
        }

        Other = Other.Owner; // switch hit actor

        // If col mesh represents a vehicle, which would normally get a HitWall() event instead of Touch, then call HitWall on the vehicle & exit
        // First match projectile's location to our more accurate HitLocation, as we can't pass HitLocation to HitWall & it will use current location
        if (ROVehicle(Other) != none)
        {
            SetLocation(HitLocation);
            HitWall(HitNormal, Other);

            return;
        }
    }

    // Now call ProcessTouch(), which is the where the class-specific Touch functionality gets handled
    // Record LastTouched to make sure that if HurtRadius() gets called to give blast damage, it will always 'find' the hit actor
    LastTouched = Other;
    ProcessTouch(Other, HitLocation);
    LastTouched = none;

    // On a net client call ClientSideTouch() if we hit a pawn with an authority role on the client (in practice this can only be a ragdoll corpse)
    // TODO: probably remove this & empty out ClientSideTouch() as ProcessTouch() will get called clientside anyway & is much more class-specific & sophisticated
    if (Role < ROLE_Authority && Other.Role == ROLE_Authority && Pawn(Other) != none && Velocity != vect(0.0, 0.0, 0.0))
    {
        ClientSideTouch(Other, HitLocation);
    }
}

// Matt: re-worked, with commentary below
simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    local ROVehicle       HitVehicle;
    local ROVehicleWeapon HitVehicleWeapon;
    local vector          Direction, TempHitLocation, HitNormal;
    local array<int>      HitPoints;

    // Exit without doing anything if we hit something we don't want to count a hit on
    if (Other == none || SavedTouchActor == Other || Other.IsA('ROBulletWhipAttachment') || Other == Instigator || Other.Base == Instigator || Other.Owner == Instigator
        || Other.bDeleteMe || (Other.IsA('Projectile') && !Other.bProjTarget))
    {
        return;
    }

    SavedTouchActor = Other;
    HitVehicleWeapon = ROVehicleWeapon(Other);
    HitVehicle = ROVehicle(Other.Base);
    Direction = Normal(Velocity);

    // We hit a VehicleWeapon
    if (HitVehicleWeapon != none && HitVehicle != none)
    {
        SavedHitActor = HitVehicle;

        Trace(TempHitLocation, HitNormal, HitLocation + (Direction * 50.0), HitLocation - (Direction * 50.0), true); // get a reliable vehicle HitNormal

        if (bDebuggingText && Role == ROLE_Authority)
        {
            DebugShotDistanceAndSpeed();
        }

        if (ShouldDrawDebugLines())
        {
            DrawStayingDebugLine(HitLocation, HitLocation - (Direction * 500.0), 255, 0, 0);
        }

        // We hit a tank cannon (turret) but failed to penetrate its armor
        if (HitVehicleWeapon.IsA('DHVehicleCannon')
            && !DHVehicleCannon(HitVehicleWeapon).ShouldPenetrate(self, HitLocation, Direction, GetMaxPenetration(LaunchLocation, HitLocation)))
        {
            FailToPenetrateArmor(HitLocation, HitNormal, HitVehicleWeapon);
        }
        // Otherwise we penetrated a VehicleWeapon
        else
        {
            if (Role == ROLE_Authority)
            {
                UpdateInstigator();

                // Removed SetDelayedDamageInstigatorController() as irrelevant to VehWeapon (empty function),
                // & we'll let VehWeapon call SetDDIC on Vehicle only if it's calling TakeDamage on it

                HitVehicleWeapon.TakeDamage(ImpactDamage, Instigator, HitLocation, MomentumTransfer * Direction, ShellImpactDamage);

                if (DamageRadius > 0.0 && HitVehicle.Health > 0) // need this here as vehicle will be ignored by HurtRadius(), as it's the HurtWall actor
                {
                    CheckVehicleOccupantsRadiusDamage(HitVehicle, Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
                }

                HurtWall = HitVehicle;
            }

            Explode(HitLocation + ExploWallOut * HitNormal, HitNormal);
        }
    }
    // We hit something other than a VehicleWeapon
    else
    {
        UpdateInstigator();

        // We hit a player pawn's 'general' collision area, but now we need to run a HitPointTrace to make sure we actually hit part of his body
        if (Other.IsA('ROPawn'))
        {
            // HitPointTraces don't work well with short traces, so we have to do long trace first, then if we hit player we check whether he was within the whip attachment
            Other = HitPointTrace(TempHitLocation, HitNormal, HitLocation + (Direction * 65535.0), HitPoints, HitLocation,, 0); // WhizType 0 for no whiz

            // We hit one of the body's hit points, so register a hit on the player
            // Only count hit if traced actor is within extent of bullet whip (we had to do an artificially long HitPointTrace, so may have traced something far away)
            if (ROPawn(Other) != none && VSizeSquared(TempHitLocation - HitLocation) <= 180000.0) // 180k is square of max distance across whip 'diagonally'
            {
                if (Role == ROLE_Authority)
                {
                    ROPawn(Other).ProcessLocationalDamage(ImpactDamage, Instigator, TempHitLocation, MomentumTransfer * Direction, ShellImpactDamage, HitPoints);
                }

                // If shell doesn't explode on hitting a body, we'll slow it down a bit but exit so shell carries on
                if (!bExplodesOnHittingBody)
                {
                    Velocity *= 0.8;

                    return;
                }

                HurtWall = Other; // added to prevent Other from being damaged again by HurtRadius called by Explode/BlowUp
            }
            // We didn't actually hit the player, so exit & let shell carry on
            else
            {
                return;
            }
        }
        // We hit some other kind of pawn, destroyable mesh, or construction
        else if (Other.IsA('RODestroyableStaticMesh') || Other.IsA('Pawn'))
        {
            if (Role == ROLE_Authority)
            {
                Other.TakeDamage(ImpactDamage, Instigator, HitLocation, MomentumTransfer * Direction, ShellImpactDamage);
            }

            // We hit a destroyable mesh that is so weak it doesn't stop bullets (e.g. glass), so it won't make a shell explode
            if (Other.IsA('RODestroyableStaticMesh') && RODestroyableStaticMesh(Other).bWontStopBullets)
            {
                return;
            }

            HurtWall = Other; // added to prevent Other from being damaged again by HurtRadius called by Explode/BlowUp
        }
        else if (Other.IsA('DHConstruction') || Other.IsA('DHDestroyableStaticMesh'))
        {
            if (Role == ROLE_Authority)
            {
                Other.TakeDamage(ImpactDamage, Instigator, HitLocation, MomentumTransfer * Direction, ShellImpactDamage);
            }
        }
        // Otherwise we hit something we aren't going to damage
        else if (bBotNotifyIneffective && Role == ROLE_Authority && ROBot(InstigatorController) != none)
        {
            ROBot(InstigatorController).NotifyIneffectiveAttack();
        }

        Explode(HitLocation, vect(0.0, 0.0, 1.0));
    }
}

// Matt: re-worked a little, but not as much as ProcessTouch, with which is shares some features
simulated function HitWall(vector HitNormal, Actor Wall)
{
    local DHVehicleCannon Cannon;
    local float ModifiedImpactDamage;

    // Exit without doing anything if we hit something we don't want to count a hit on
    if (Wall == none || SavedHitActor == Wall || (Wall.Base != none && Wall.Base == Instigator) || Wall.bDeleteMe)
    {
        return;
    }

    SavedHitActor = Pawn(Wall); // record hit actor to prevent recurring hits

    // Debug options
    if (DHVehicleCannonPawn(Instigator) != none)
    {
        Cannon = DHVehicleCannonPawn(Instigator).Cannon;

        if (Cannon != none && Cannon.bDebugRangeAutomatically)
        {
            Cannon.UpdateAutoDebugRange(Wall, Location);
            bDidExplosionFX = true;
            Destroy();

            return;
        }
    }

    if (bDebuggingText && Role == ROLE_Authority)
    {
        DebugShotDistanceAndSpeed();
    }

    // We hit an armored vehicle hull but failed to penetrate
    if (Wall.IsA('DHArmoredVehicle') && !DHArmoredVehicle(Wall).ShouldPenetrate(self, Location, Normal(Velocity), GetMaxPenetration(LaunchLocation, Location)))
    {
        FailToPenetrateArmor(Location, HitNormal, Wall);

        return;
    }

//  super(ROBallisticProjectile).HitWall(HitNormal, Wall); // removed as just duplicates shell debugging

    if (Role == ROLE_Authority)
    {
        if ((!Wall.bStatic && !Wall.bWorldGeometry) || Wall.bCanBeDamaged)
        {
            if (SavedHitActor != none || Wall.bCanBeDamaged)
            {
                if (ShouldDrawDebugLines())
                {
                    DrawStayingDebugLine(Location, Location - (Normal(Velocity) * 500.0), 255, 0, 0);
                }

                UpdateInstigator();

                if (ShellImpactDamage.default.bDelayedDamage && InstigatorController != none)
                {
                    Wall.SetDelayedDamageInstigatorController(InstigatorController);
                }

                ModifiedImpactDamage = ImpactDamage;

                // Deal HE bonus damage to vehicle
                if (DHVehicle(Wall) != none && RoundType == RT_HE)
                {
                    ModifiedImpactDamage *= DHVehicle(Wall).DirectHEImpactDamageMult;
                }

                Wall.TakeDamage(ModifiedImpactDamage, Instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
            }

            if (DamageRadius > 0.0 && ROVehicle(Wall) != none && ROVehicle(Wall).Health > 0) // need this here as vehicle will be ignored by HurtRadius(), as it's the HurtWall actor
            {
                CheckVehicleOccupantsRadiusDamage(ROVehicle(Wall), Damage, DamageRadius, MyDamageType, MomentumTransfer, Location);
            }

            HurtWall = Wall;
        }
        else if (bBotNotifyIneffective && ROBot(InstigatorController) != none)
        {
            ROBot(InstigatorController).NotifyIneffectiveAttack();
        }
    }

    Explode(Location + ExploWallOut * HitNormal, HitNormal);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    if (!bCollided)
    {
        BlowUp(HitLocation);
        HandleDestruction();
    }
}

// Modified to add most common explosion features into this function - removes code repetition & makes it easier to subclass Explode
// Avoided setting replicated variables on a server, as clients are going to get this anyway & this actor is about to be destroyed, so it saves unnecessary replication
simulated function BlowUp(vector HitLocation)
{
    bUpdateSimulatedPosition = false; // don't replicate the position any more

    if (Level.NetMode != NM_DedicatedServer)
    {
        AmbientSound = none;

        // Don't move or draw the projectile any more
        SetPhysics(PHYS_None);
        SetDrawType(DT_None);
    }

    if (Corona != none)
    {
        Corona.Destroy();
    }

    if (ShellTrail != none)
    {
        ShellTrail.Destroy();
    }

    super.BlowUp(HitLocation);
}

// Modified to handle new collision mesh actor - if we hit a col mesh, we switch hit actor to col mesh's owner & proceed as if we'd hit that actor
// Also to call CheckVehicleOccupantsRadiusDamage() instead of DriverRadiusDamage() on a hit vehicle, to properly handle blast damage to any exposed vehicle occupants
// And to fix problem affecting many vehicles with hull mesh modelled with origin on the ground, where even a slight ground bump could block all blast damage
// Also to update Instigator, so HurtRadius attributes damage to the player's current pawn
function HurtRadius(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
    local Actor         Victim, TraceActor;
    local DHVehicle     V;
    local ROPawn        P;
    local array<ROPawn> CheckedROPawns;
    local bool          bAlreadyChecked;
    local vector        VictimLocation, Direction, TraceHitLocation, TraceHitNormal;
    local float         DamageScale, Distance, DamageExposure;
    local int           i;

    // Make sure nothing else runs HurtRadius() while we are in the middle of the function
    if (bHurtEntry)
    {
        return;
    }

    bHurtEntry = true;

    UpdateInstigator();

    // Find all colliding actors within blast radius, which the blast should damage
    // No longer use VisibleCollidingActors as much slower (FastTrace on every actor found), but we can filter actors & then we do our own, more accurate trace anyway
    foreach CollidingActors(class'Actor', Victim, DamageRadius, HitLocation)
    {
        if (!Victim.bBlockActors)
        {
            continue;
        }

        // If hit a collision mesh actor, switch to its owner
        if (Victim.IsA('DHCollisionMeshActor'))
        {
            if (DHCollisionMeshActor(Victim).bWontStopBlastDamage)
            {
                continue; // ignore col mesh actor if it is set not to stop blast damage
            }

            Victim = Victim.Owner;
        }

        // Don't damage this projectile, an actor already damaged by projectile impact (HurtWall), cannon actors, non-authority actors, or fluids
        // We skip damage on cannons because the blast will hit the vehicle base so we don't want to double up on damage to the same vehicle
        if (Victim == none || Victim == self || Victim == HurtWall || Victim.IsA('DHVehicleCannon') || Victim.Role < ROLE_Authority || Victim.IsA('FluidSurfaceInfo'))
        {
            continue;
        }

        // Now we need to check whether there's something in the way that could shield this actor from the blast
        // Usually we trace to actor's location, but for a vehicle with a cannon we adjust Z location to give a more consistent, realistic tracing height
        // This is because many vehicles are modelled with their origin on the ground, so even a slight bump in the ground could block all blast damage!
        VictimLocation = Victim.Location;
        V = DHVehicle(Victim);

        if (V != none && V.Cannon != none && V.Cannon.AttachmentBone != '')
        {
            VictimLocation.Z = V.GetBoneCoords(V.Cannon.AttachmentBone).Origin.Z;
        }

        // Trace from explosion point to the actor to check whether anything is in the way that could shield it from the blast
        TraceActor = Trace(TraceHitLocation, TraceHitNormal, VictimLocation, HitLocation);

        if (DHCollisionMeshActor(TraceActor) != none)
        {
            if (DHCollisionMeshActor(TraceActor).bWontStopBlastDamage)
            {
                continue;
            }

            TraceActor = TraceActor.Owner; // as normal, if hit a collision mesh actor then switch to its owner
        }

        // Ignore the actor if the blast is blocked by world geometry, a vehicle, or a turret (but don't let a turret block damage to its own vehicle)
        if (TraceActor != none && TraceActor != Victim && (TraceActor.bWorldGeometry || TraceActor.IsA('ROVehicle') || (TraceActor.IsA('DHVehicleCannon') && Victim != TraceActor.Base)))
        {
            continue;
        }

        // Check for hit on player pawn
        P = ROPawn(Victim);

        if (P != none)
        {
            // If we hit a player pawn, make sure we haven't already registered the hit & add pawn to array of already hit/checked pawns
            for (i = 0; i < CheckedROPawns.Length; ++i)
            {
                if (P == CheckedROPawns[i])
                {
                    bAlreadyChecked = true;
                    break;
                }
            }

            if (bAlreadyChecked)
            {
                bAlreadyChecked = false;
                continue;
            }

            CheckedROPawns[CheckedROPawns.Length] = P;

            // If player is partially shielded from the blast, calculate damage reduction scale
            DamageExposure = P.GetExposureTo(HitLocation + 15.0 * -Normal(PhysicsVolume.Gravity));

            if (DamageExposure <= 0.0)
            {
                continue;
            }
        }

        // Calculate damage based on distance from explosion
        Direction = VictimLocation - HitLocation;
        Distance = FMax(1.0, VSize(Direction));
        Direction = Direction / Distance;
        DamageScale = 1.0 - FMax(0.0, (Distance - Victim.CollisionRadius) / DamageRadius);

        if (P != none)
        {
            DamageScale *= DamageExposure;
        }

        // Record player responsible for damage caused, & if we're damaging LastTouched actor, reset that to avoid damaging it again at end of function
        if (Instigator == none || Instigator.Controller == none)
        {
            Victim.SetDelayedDamageInstigatorController(InstigatorController);
        }

        if (Victim == LastTouched)
        {
            LastTouched = none;
        }

        // Damage the actor hit by the blast - if it's a vehicle, check for damage to any exposed occupants
        Victim.TakeDamage(DamageScale * DamageAmount, Instigator, VictimLocation - 0.5 * (Victim.CollisionHeight + Victim.CollisionRadius) * Direction,
            DamageScale * Momentum * Direction, DamageType);

        if (ROVehicle(Victim) != none && ROVehicle(Victim).Health > 0)
        {
            CheckVehicleOccupantsRadiusDamage(ROVehicle(Victim), DamageAmount, DamageRadius, DamageType, Momentum, HitLocation);
        }
    }

    // Same (or very similar) process for the last actor this projectile hit (Touched), but only happens if actor wasn't found by the check for CollidingActors
    if (LastTouched != none && LastTouched != self && LastTouched.Role == ROLE_Authority && !LastTouched.IsA('FluidSurfaceInfo'))
    {
        Direction = LastTouched.Location - HitLocation;
        Distance = FMax(1.0, VSize(Direction));
        Direction = Direction / Distance;
        DamageScale = FMax(LastTouched.CollisionRadius / (LastTouched.CollisionRadius + LastTouched.CollisionHeight),
            1.0 - FMax(0.0, (Distance - LastTouched.CollisionRadius) / DamageRadius));

        if (Instigator == none || Instigator.Controller == none)
        {
            LastTouched.SetDelayedDamageInstigatorController(InstigatorController);
        }

        LastTouched.TakeDamage(DamageScale * DamageAmount, Instigator,
            LastTouched.Location - 0.5 * (LastTouched.CollisionHeight + LastTouched.CollisionRadius) * Direction, DamageScale * Momentum * Direction, DamageType);

        if (ROVehicle(LastTouched) != none && ROVehicle(LastTouched).Health > 0)
        {
            CheckVehicleOccupantsRadiusDamage(ROVehicle(LastTouched), DamageAmount, DamageRadius, DamageType, Momentum, HitLocation);
        }

        LastTouched = none;
    }

    bHurtEntry = false;
}

// New function to check for possible blast damage to all vehicle occupants that don't have collision of their own & so won't be 'caught' by HurtRadius()
function CheckVehicleOccupantsRadiusDamage(ROVehicle V, float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
    local ROVehicleWeaponPawn WP;
    local int i;

    if (V.Driver != none && V.DriverPositions[V.DriverPositionIndex].bExposed && !V.Driver.bCollideActors && !V.bRemoteControlled)
    {
        VehicleOccupantRadiusDamage(V.Driver, DamageAmount, DamageRadius, DamageType, Momentum, HitLocation);
    }

    for (i = 0; i < V.WeaponPawns.Length; ++i)
    {
        WP = ROVehicleWeaponPawn(V.WeaponPawns[i]);

        if (WP != none && WP.Driver != none && ((WP.bMultiPosition && WP.DriverPositions[WP.DriverPositionIndex].bExposed) || WP.bSinglePositionExposed)
            && !WP.bCollideActors && !WP.bRemoteControlled)
        {
            VehicleOccupantRadiusDamage(WP.Driver, DamageAmount, DamageRadius, DamageType, Momentum, HitLocation);
        }
    }
}

// New function to handle blast damage to vehicle occupants
function VehicleOccupantRadiusDamage(Pawn P, float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
    local Actor  TraceHitActor;
    local coords HeadBoneCoords;
    local vector HeadLocation, TraceHitLocation, TraceHitNormal, Direction;
    local float  Distance, DamageScale;

    if (P != none)
    {
        HeadBoneCoords = P.GetBoneCoords(P.HeadBone);
        HeadLocation = HeadBoneCoords.Origin + ((P.HeadHeight + (0.5 * P.HeadRadius)) * P.HeadScale * HeadBoneCoords.XAxis);

        // Trace from the explosion to the top of player pawn's head & if there's a blocking actor in between (probably the vehicle), exit without damaging pawn
        foreach TraceActors(class'Actor', TraceHitActor, TraceHitLocation, TraceHitNormal, HeadLocation, HitLocation)
        {
            if (TraceHitActor.bBlockActors)
            {
                return;
            }
        }

        // Calculate damage based on distance from explosion
        Direction = P.Location - HitLocation;
        Distance = FMax(1.0, VSize(Direction));
        Direction = Direction / Distance;
        DamageScale = 1.0 - FMax(0.0, (Distance - P.CollisionRadius) / DamageRadius);

        // Damage the vehicle occupant
        if (DamageScale > 0.0)
        {
            P.SetDelayedDamageInstigatorController(InstigatorController);

            P.TakeDamage(DamageScale * DamageAmount, InstigatorController.Pawn, P.Location - (0.5 * (P.CollisionHeight + P.CollisionRadius)) * Direction,
                DamageScale * Momentum * Direction, DamageType);
        }
    }
}

// New function to consolidate code now standardised between ProcessTouch & HitWall, and allowing it to be easily sub-classed without re-stating those long functions
// Although this has actually been written as a generic function that should handle all or most situations
simulated function FailToPenetrateArmor(vector HitLocation, vector HitNormal, Actor HitActor)
{
    local vector EffectLocation;

    EffectLocation = HitLocation + (HitNormal * 16.0);

    DoShakeEffect();

    // Round shatters on vehicle armor
    if (bRoundShattered)
    {
        if (bDebuggingText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Round shattered on vehicle armor & failed to penetrate");
        }

        PlaySound(ShatterVehicleHitSound, SLOT_Misc, 5.5 * TransientSoundVolume);
        PlaySound(ShatterSound[Rand(4)], SLOT_None, 5.5 * TransientSoundVolume);

        if (EffectIsRelevant(EffectLocation, false))
        {
            Spawn(ShellShatterEffectClass,,, EffectLocation, rotator(HitNormal));
        }

        bRoundShattered = false; // reset
        bDidExplosionFX = true;  // we've played specific shatter effects, so flag this to avoid calling SpawnExplosionEffects
        Explode(HitLocation + ExploWallOut * HitNormal, HitNormal);
    }
    // Round explodes on vehicle armor
    // TODO: just a note that this does the same as calling SpawnExplosionEffects() except this plays VehicleDeflectSound/ShellDeflectEffectClass instead of VehicleHitSound/ShellHitVehicleEffectClass
    else if (bExplodesOnArmor && !bRoundDeflected)
    {
        if (bDebuggingText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Round failed to penetrate vehicle armor & exploded");
        }

        if (ExplosionSound.Length > 0)
        {
            PlaySound(ExplosionSound[Rand(ExplosionSound.Length - 1)], SLOT_None, ExplosionSoundVolume * TransientSoundVolume); // random explosion sound
        }

        PlaySound(VehicleDeflectSound, SLOT_Misc, 5.5 * TransientSoundVolume);

        if (EffectIsRelevant(EffectLocation, false))
        {
            Spawn(ShellDeflectEffectClass,,, EffectLocation, rotator(HitNormal));
        }

        bDidExplosionFX = true; // we've played specific explosion effects, so flag this to avoid calling SpawnExplosionEffects // TODO: need to fix - no visible explosion when HE hits tank
        Explode(HitLocation + ExploWallOut * HitNormal, HitNormal);
    }
    // Round deflects off vehicle armor
    else
    {
        SavedHitActor = none; // don't save hitting this vehicle as we deflected

        if (bDebuggingText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Round ricocheted off vehicle armor");
        }

        if (NumDeflections < 2) // don't play effects if has deflected several times already
        {
            PlaySound(VehicleDeflectSound, SLOT_Misc, 5.5 * TransientSoundVolume);

            if (EffectIsRelevant(EffectLocation, false))
            {
                Spawn(ShellDeflectEffectClass,,, EffectLocation, rotator(HitNormal));
            }
        }

        Deflect(HitLocation, HitNormal, HitActor);
    }

    // If bot fired this round, notify it of ineffective attack on vehicle
    if (bBotNotifyIneffective && Role == ROLE_Authority && ROBot(InstigatorController) != none)
    {
        if (Pawn(HitActor) == none && HitActor != none && Pawn(HitActor.Base) != none)
        {
            HitActor = HitActor.Base;
        }

        ROBot(InstigatorController).NotifyIneffectiveAttack(Pawn(HitActor));
    }
}

// Modified version of function to include passed HitLocation, to give correct placement of deflection effect (shell's Location has moved on by the time the effect spawns)
// Also avoided setting replicated variables on a server, as clients are going to get this anyway
simulated function Deflect(vector HitLocation, vector HitNormal, Actor Wall)
{
    local vector VNorm;

    if (bDebugBallistics)
    {
        HandleShellDebug(HitLocation);
        bDebugBallistics = false; // so we don't keep getting debug reports on subsequent deflections, only the 1st impact
    }

    // Don't let this thing constantly deflect
    if (NumDeflections > 5)
    {
        Explode(HitLocation + ExploWallOut * HitNormal, HitNormal);

        return;
    }

    NumDeflections++;

    // Once we have bounced, just fall to the ground & remove the projectile's flight sound
    if (Level.NetMode != NM_DedicatedServer)
    {
        SetPhysics(PHYS_Falling);
        AmbientSound = none; //TODO: add some ricochet 'whistle' sound here
    }

    bTrueBallistics = false;
    Acceleration = PhysicsVolume.Gravity;
    bUpdateSimulatedPosition = false; // don't replicate the position any more, just let the client simulate movement after deflection (it's no longer critical)

    // Reflect off hit surface, with damping
    VNorm = (Velocity dot HitNormal) * HitNormal;
    VNorm = VNorm + VRand() * FRand() * 10000.0; // add random spread to deflect
    Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;
    Speed = VSize(Velocity);
}

simulated function DoShakeEffect()
{
    local PlayerController PC;
    local float            Distance, Scale;

    if (Level.NetMode != NM_DedicatedServer && ShellDiameter > 2.0)
    {
        PC = Level.GetLocalPlayerController();

        if (PC != none && PC.ViewTarget != none)
        {
            Distance = VSize(Location - PC.ViewTarget.Location);

            if (Distance < PenetrationMag * 3.0)
            {

                PC.PlaySound(Sound'DH_SundrySounds.shell_shock.shellshock', SLOT_None, 1.0, true, 10.0, 1.0, true); //play shell shock on PC

                Scale = (PenetrationMag * 3.0 - Distance) / (PenetrationMag * 3.0);
                Scale *= BlurEffectScalar;

                PC.ShakeView(ShakeRotMag * Scale, ShakeRotRate, ShakeRotTime, ShakeOffsetMag * Scale, ShakeOffsetRate, ShakeOffsetTime);

                if (PC.Pawn != none && ROPawn(PC.Pawn) != none)
                {
                    Scale = Scale - (Scale * 0.35 - ((Scale * 0.35) * ROPawn(PC.Pawn).GetExposureTo(Location + 50.0 * -Normal(PhysicsVolume.Gravity))));
                }

                ROPlayer(PC).AddBlur(BlurTime * Scale, FMin(1.0, Scale));
            }
        }
    }
}

// Modified to blow up certain rounds (e.g. HE or HEAT) when they hit water
simulated function PhysicsVolumeChange(PhysicsVolume NewVolume)
{
    if (NewVolume != none && NewVolume.bWaterVolume)
    {
        CheckForSplash(Location);

        if (bExplodesOnHittingWater)
        {
            Explode(Location, vector(Rotation * -1.0));
        }
        else
        {
            Velocity *= 0.5;
        }
    }
}

// Modified to add an EffectIsRelevant check before spawning visual splash effect
simulated function CheckForSplash(vector SplashLocation)
{
    local Actor  HitActor;
    local vector HitLocation, HitNormal;

    // No splash if detail settings are low, or if projectile is already in a water volume
    if (Level.Netmode != NM_DedicatedServer && !Level.bDropDetail && Level.DetailMode != DM_Low
        && !(Instigator != none && Instigator.PhysicsVolume != none && Instigator.PhysicsVolume.bWaterVolume))
    {
        bTraceWater = true;
        HitActor = Trace(HitLocation, HitNormal, SplashLocation - (50.0 * vect(0.0, 0.0, 1.0)), SplashLocation + (15.0 * vect(0.0, 0.0, 1.0)), true);
        bTraceWater = false;

        // We hit a water volume or a fluid surface, so play splash effects
        if ((PhysicsVolume(HitActor) != none && PhysicsVolume(HitActor).bWaterVolume) || FluidSurfaceInfo(HitActor) != none)
        {
            if (WaterHitSound != none)
            {
                PlaySound(WaterHitSound,, 5.5 * TransientSoundVolume);
            }

            if (ShellHitWaterEffectClass != none && EffectIsRelevant(HitLocation, false))
            {
                Spawn(ShellHitWaterEffectClass,,, HitLocation, rot(16384, 0, 0));
            }
        }
    }
}

// New function updating Instigator reference to ensure damage is attributed to correct player, as may have switched to different pawn since firing, e.g. changed vehicle position
simulated function UpdateInstigator()
{
    if (InstigatorController != none && InstigatorController.Pawn != none)
    {
        Instigator = InstigatorController.Pawn;
    }
}

// Modified to fix UT2004 bug affecting non-owning net players in any vehicle with bPCRelativeFPRotation (nearly all), often causing effects to be skipped
// Vehicle's rotation was not being factored into calcs using the PlayerController's rotation, which effectively randomised the result of this function
// Also re-factored to make it a little more optimised, direct & easy to follow (without repeated use of bResult)
simulated function bool EffectIsRelevant(vector SpawnLocation, bool bForceDedicated)
{
    local PlayerController PC;

    // Only relevant on a dedicated server if the bForceDedicated option has been passed
    if (Level.NetMode == NM_DedicatedServer)
    {
        return bForceDedicated;
    }

    if (Role < ROLE_Authority)
    {
        // Always relevant for the owning net player, i.e. the player that fired the projectile
        if (Instigator != none && Instigator.IsHumanControlled())
        {
            return true;
        }

        // Not relevant to other net clients if the projectile has not been drawn on their screen recently (within last 3 seconds)
        if ((Level.TimeSeconds - LastRenderTime) >= 3.0)
        {
            return false;
        }
    }

    PC = Level.GetLocalPlayerController();

    if (PC == none || PC.ViewTarget == none)
    {
        return false;
    }

    // Check to see whether effect would spawn off to the side or behind where player is facing, & if so then only spawn if within quite close distance
    // Using PC's CalcViewRotation, which is the last recorded camera rotation, so a simple way of getting player's non-relative view rotation, even in vehicles
    // (doesn't apply to the player that fired the projectile)
    if (PC.Pawn != Instigator && vector(PC.CalcViewRotation) dot (SpawnLocation - PC.ViewTarget.Location) < 0.0)
    {
        return VSizeSquared(PC.ViewTarget.Location - SpawnLocation) < 2560000.0; // equivalent to 1600 UU or 26.5m (changed to VSizeSquared as more efficient)
    }

    // Effect relevance is based on normal distance check
    return CheckMaxEffectDistance(PC, SpawnLocation);
}

// New function to separate this out, allowing easier subclassing of Explode function & avoid some other code repetition
simulated function HandleDestruction()
{
    bCollided = true;

    if (Level.NetMode == NM_DedicatedServer)
    {
        LifeSpan = DestroyTime; // on a server, this actor will automatically be destroyed in a split second, allowing a buffer for the client to catch up
        SetCollision(false, false);
        bCollideWorld = false;  // added to prevent continuing calls to HitWall on server, while shell persists
    }
    else
    {
        Destroy();
    }
}

simulated function Destroyed()
{
    if (Corona != none)
    {
        Corona.Destroy();
    }

    if (ShellTrail != none)
    {
        ShellTrail.Destroy();
    }
}

simulated function bool ShouldDrawDebugLines()
{
    if (bDrawDebugLines && bFirstHit && Level.NetMode != NM_DedicatedServer)
    {
        bFirstHit = false;

        return true;
    }

    return false;
}

function DebugShotDistanceAndSpeed()
{
    if (bDebugInImperial)
    {
        Level.Game.Broadcast(self, "Shot distance:" @ (VSize(LaunchLocation - Location) / 55.18654) @ "yards, impact speed:" @ VSize(Velocity) / ScaleFactor @ "fps");
    }
    else
    {
        Level.Game.Broadcast(self, "Shot distance:" @ class'DHUnits'.static.UnrealToMeters(VSize(LaunchLocation - Location))
            $ "m, impact speed:" @ class'DHUnits'.static.UnrealToMeters(VSize(Velocity)) @ "m/s");
    }
}

// New function (in this class) based on HandleShellDebug from cannon class, but may as well do it here as we have saved TraceHitLoc in PostNetBeginPlay if bDebugBallistics is true
// Modified to avoid confusing "bullet drop" text and to add shell drop in both cm and inches (accurately converted)
simulated function HandleShellDebug(vector RealHitLocation)
{
    local float ShellDropUnits;

    if (NumDeflections < 1) // don't debug if it's just a deflected shell
    {
        ShellDropUnits = TraceHitLoc.Z - RealHitLocation.Z;
        Log("Shell drop =" @ class'DHUnits'.static.UnrealToMeters(ShellDropUnits) * 100.0 $ "cm /" @ ShellDropUnits / ScaleFactor * 12.0 @ "inches"
            @ "TraceZ =" @ TraceHitLoc.Z @ " RealZ =" @ RealHitLocation.Z @ "Distance=" @ class'DHUnits'.static.UnrealToMeters(VSize(LaunchLocation - RealHitLocation)) $ "m");
    }
}

defaultproperties
{
    RoundType=RT_APC
    bUseCollisionStaticMesh=true
    bBotNotifyIneffective=true
    bDebugInImperial=true
    SpeedFudgeScale=0.5
    InitialAccelerationTime=0.2

    ShellShatterEffectClass=class'DH_Effects.DHShellShatterEffect'
    ShatterVehicleHitSound=SoundGroup'ProjectileSounds.cannon_rounds.HE_deflect'
    ShatterSound(0)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01'
    ShatterSound(1)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode02'
    ShatterSound(2)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03'
    ShatterSound(3)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode04'

    ShakeRotMag=(Y=50.0,Z=200.0)
    ShakeRotRate=(Y=500.0,Z=1500.0)
    ShakeRotTime=3.0
    ShakeOffsetMag=(Z=10.0)
    ShakeOffsetRate=(Z=200.0)
    ShakeOffsetTime=5.0
    BlurTime=3.0
    BlurEffectScalar=1.9
    PenetrationMag=100.0

    TracerHue=45
    TracerSaturation=128

    // From deprecated ROAntiVehicleProjectile class:
    VehicleDeflectSound=Sound'ProjectileSounds.cannon_rounds.AP_deflect'
    DampenFactor=1.5 //0.5
    DampenFactorParallel=0.5 //0.2
    DestroyTime=0.2
    bFirstHit=true
}
