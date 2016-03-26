//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHAntiVehicleProjectile extends ROAntiVehicleProjectile
    config
    abstract;

enum ERoundType
{
    RT_APC,   // either APC (with just armor-piercing cap) or APCBC (with both armor-piercing cap & ballistic cap)
    RT_HE,
    RT_HVAP,  // HVAP in US parlance, known elsewhere as APCR (same thing)
    RT_APDS,
    RT_HEAT,  // includes infantry AT HEAT weapons (e.g. rockets & PIAT)
    RT_Smoke,
    RT_AP,    // basic armor-piercing round, without any cap
    RT_APBC,  // with ballistic cap but not armor-piercing cap (used by Soviets)
};

// Projectile characteristics
var     ERoundType      RoundType;               // makes it easier to write more generic functionality & avoid code repetition
var     float           DHPenetrationTable[11];  // array of projectile's penetration capability (in centimetres) at different ranges
var     float           ShellDiameter;           // used in penetration calculations
var     bool            bExplodesOnArmor;        // shell explodes on vehicle armor if it fails to penetrate
var     bool            bExplodesOnHittingBody;  // shell explodes on hitting a human body (otherwise punches through & continues in flight)
var     bool            bExplodesOnHittingWater; // shell explodes on hitting a WaterVolume
var     bool            bBotNotifyIneffective;   // notify bot of an ineffective attack on target
var     bool            bIsAlliedShell;          // only used in debugging, so info is shown in metric or imperial

var     array<sound>    ExplosionSound;       // sound of the round exploding (array for random selection)
var     float           ExplosionSoundVolume; // volume scale factor for the ExplosionSound (allows variance between shells, while keeping other sounds at same volume)
var     bool            bAlwaysDoShakeEffect; // this shell will always DoShakeEffect when it explodes, not just if hit vehicle armor

// Shatter
var     bool            bShatterProne;           // projectile may shatter on vehicle armor
var     bool            bRoundShattered;         // projectile has shattered
var     class<Emitter>  ShellShatterEffectClass; // effect for this shell shattering against a vehicle
var     sound           ShatterVehicleHitSound;  // sound of this shell shattering on the vehicle
var     sound           ShatterSound[4];         // sound of the round shattering

// Effects
var     bool            bHasTracer;              // will be disabled for HE shells, and any others with no tracers
var     class<Effects>  CoronaClass;             // tracer effect class
var     Effects         Corona;                  // shell tracer

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
var globalconfig bool   bDebugROBallistics;      // sets bDebugBallistics to true for getting the arrow pointers (added from DHBullet so bDebugBallistics can be set in a config file)

// Modified to move bDebugBallistics stuff to PostNetBeginPlay, as net client won't yet have Instigator here
simulated function PostBeginPlay()
{
    LaunchLocation = Location;
    BCInverse = 1.0 / BallisticCoefficient;
    Velocity = vector(Rotation) * Speed;

    if (Role == ROLE_Authority && Instigator != none && (WaterVolume(Instigator.HeadVolume) != none || (Instigator.HeadVolume != none && Instigator.HeadVolume.bWaterVolume)))
    {
        Velocity *= 0.5;
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

// Matt: disabled no longer use delayed destruction stuff from the Super in ROAntiVehicleProjectile - it's far cleaner just to set a short LifeSpan on a server
simulated function Tick(float DeltaTime)
{
    Disable('Tick');
}

// Borrowed from AB: Just using a standard linear interpolation equation here
simulated function float GetPenetration(vector Distance)
{
    local float MeterDistance, PenetrationNumber;

    MeterDistance = VSize(Distance) / 60.352;

    if      (MeterDistance < 100.0)   PenetrationNumber = (DHPenetrationTable[0] +  (100.0  - MeterDistance) * (DHPenetrationTable[0] - DHPenetrationTable[1])  / 100.0);
    else if (MeterDistance < 250.0)   PenetrationNumber = (DHPenetrationTable[1] +  (250.0  - MeterDistance) * (DHPenetrationTable[0] - DHPenetrationTable[1])  / 150.0);
    else if (MeterDistance < 500.0)   PenetrationNumber = (DHPenetrationTable[2] +  (500.0  - MeterDistance) * (DHPenetrationTable[1] - DHPenetrationTable[2])  / 250.0);
    else if (MeterDistance < 750.0)   PenetrationNumber = (DHPenetrationTable[3] +  (750.0  - MeterDistance) * (DHPenetrationTable[2] - DHPenetrationTable[3])  / 250.0);
    else if (MeterDistance < 1000.0)  PenetrationNumber = (DHPenetrationTable[4] +  (1000.0 - MeterDistance) * (DHPenetrationTable[3] - DHPenetrationTable[4])  / 250.0);
    else if (MeterDistance < 1250.0)  PenetrationNumber = (DHPenetrationTable[5] +  (1250.0 - MeterDistance) * (DHPenetrationTable[4] - DHPenetrationTable[5])  / 250.0);
    else if (MeterDistance < 1500.0)  PenetrationNumber = (DHPenetrationTable[6] +  (1500.0 - MeterDistance) * (DHPenetrationTable[5] - DHPenetrationTable[6])  / 250.0);
    else if (MeterDistance < 1750.0)  PenetrationNumber = (DHPenetrationTable[7] +  (1750.0 - MeterDistance) * (DHPenetrationTable[6] - DHPenetrationTable[7])  / 250.0);
    else if (MeterDistance < 2000.0)  PenetrationNumber = (DHPenetrationTable[8] +  (2000.0 - MeterDistance) * (DHPenetrationTable[7] - DHPenetrationTable[8])  / 250.0);
    else if (MeterDistance < 2500.0)  PenetrationNumber = (DHPenetrationTable[9] +  (2500.0 - MeterDistance) * (DHPenetrationTable[8] - DHPenetrationTable[9])  / 500.0);
    else if (MeterDistance < 3000.0)  PenetrationNumber = (DHPenetrationTable[10] + (3000.0 - MeterDistance) * (DHPenetrationTable[9] - DHPenetrationTable[10]) / 500.0);
    else                              PenetrationNumber =  DHPenetrationTable[10];

    if (NumDeflections > 0)
    {
        PenetrationNumber = PenetrationNumber * 0.04;  // just for now, until pen is based on velocity
    }

    return PenetrationNumber;
}

// Matt: modified to handle new collision mesh actor - if we hit a col mesh, we switch hit actor to col mesh's owner & proceed as if we'd hit that actor
simulated singular function Touch(Actor Other)
{
    local vector HitLocation, HitNormal;

    if (Other != none && (Other.bProjTarget || Other.bBlockActors))
    {
        if (Other.IsA('DHCollisionMeshActor'))
        {
            if (DHCollisionMeshActor(Other).bWontStopShell)
            {
                return; // exit, doing nothing, if col mesh actor is set not to stop a shell
            }

            // If col mesh represents a vehicle, which would normally get a HitWall event instead of Touch, we call HitWall on the vehicle & exit
            if (Other.Owner.IsA('ROVehicle'))
            {
                // Trace the col mesh to get an accurate HitLocation, as the projectile has often travelled further by the time this event gets called
                // A false return means we successfully traced the col mesh, so we change the projectile's location (as we can't pass HitLocation to HitWall)
                if (!Other.TraceThisActor(HitLocation, HitNormal, Location, Location - 2.0 * Velocity, GetCollisionExtent()))
                {
                    SetLocation(HitLocation);
                }

                HitWall(HitNormal, Other.Owner);

                return;
            }

            Other = Other.Owner;
        }

        LastTouched = Other;

        if (Velocity == vect(0.0, 0.0, 0.0) || Other.IsA('Mover'))
        {
            ProcessTouch(Other, Location);
            LastTouched = none;
        }
        else
        {
            if (Other.TraceThisActor(HitLocation, HitNormal, Location, Location - 2.0 * Velocity, GetCollisionExtent()))
            {
                HitLocation = Location;
            }

            ProcessTouch(Other, HitLocation);
            LastTouched = none;

            if (Role < ROLE_Authority && Other.Role == ROLE_Authority && Pawn(Other) != none)
            {
                ClientSideTouch(Other, HitLocation);
            }
        }
    }
}

// Matt: re-worked, with commentary below
simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    local ROVehicle       HitVehicle;
    local ROVehicleWeapon HitVehicleWeapon;
    local vector          DirectionNormal, TempHitLocation, HitNormal;
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
    DirectionNormal = Normal(Velocity);

    // We hit a VehicleWeapon
    if (HitVehicleWeapon != none && HitVehicle != none)
    {
        SavedHitActor = HitVehicle;

        Trace(TempHitLocation, HitNormal, HitLocation + (DirectionNormal * 50.0), HitLocation - (DirectionNormal * 50.0), true); // get a reliable vehicle HitNormal

        if (bDebuggingText && Role == ROLE_Authority)
        {
            DebugShotDistanceAndSpeed();
        }

        if (ShouldDrawDebugLines())
        {
            DrawStayingDebugLine(HitLocation, HitLocation - (DirectionNormal * 500.0), 255, 0, 0);
        }

        // We hit a tank cannon (turret) but failed to penetrate its armor
        if (HitVehicleWeapon.IsA('DHVehicleCannon')
            && !DHVehicleCannon(HitVehicleWeapon).ShouldPenetrate(self, HitLocation, DirectionNormal, GetPenetration(LaunchLocation - HitLocation)))
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

                HitVehicleWeapon.TakeDamage(ImpactDamage, Instigator, HitLocation, MomentumTransfer * DirectionNormal, ShellImpactDamage);

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
            Other = HitPointTrace(TempHitLocation, HitNormal, HitLocation + (DirectionNormal * 65535.0), HitPoints, HitLocation,, 0); // WhizType 0 for no whiz

            // We hit one of the body's hit points, so register a hit on the player
            // Only count hit if traced actor is within extent of bullet whip (we had to do an artificially long HitPointTrace, so may have traced something far away)
            if (ROPawn(Other) != none && VSizeSquared(TempHitLocation - HitLocation) <= 180000.0) // 180k is square of max distance across whip 'diagonally'
            {
                if (Role == ROLE_Authority)
                {
                    ROPawn(Other).ProcessLocationalDamage(ImpactDamage, Instigator, TempHitLocation, MomentumTransfer * DirectionNormal, ShellImpactDamage, HitPoints);
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
        // We hit some other kind of pawn or a destroyable mesh
        else if (Other.IsA('RODestroyableStaticMesh') || Other.IsA('Pawn'))
        {
            if (Role == ROLE_Authority)
            {
                Other.TakeDamage(ImpactDamage, Instigator, HitLocation, MomentumTransfer * DirectionNormal, ShellImpactDamage);
            }

            // We hit a destroyable mesh that is so weak it doesn't stop bullets (e.g. glass), so it won't make a shell explode
            if (Other.IsA('RODestroyableStaticMesh') && RODestroyableStaticMesh(Other).bWontStopBullets)
            {
                return;
            }

            HurtWall = Other; // added to prevent Other from being damaged again by HurtRadius called by Explode/BlowUp
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
    // Exit without doing anything if we hit something we don't want to count a hit on
    if ((Wall.Base != none && Wall.Base == Instigator) || SavedHitActor == Wall || Wall.bDeleteMe)
    {
        return;
    }

    SavedHitActor = Pawn(Wall);

    if (bDebuggingText && Role == ROLE_Authority)
    {
        DebugShotDistanceAndSpeed();
    }

    // We hit an armored vehicle hull but failed to penetrate
    if (Wall.IsA('DHArmoredVehicle') && !DHArmoredVehicle(Wall).ShouldPenetrate(self, Location, Normal(Velocity), GetPenetration(LaunchLocation - Location)))
    {
        FailToPenetrateArmor(Location, HitNormal, Wall);

        return;
    }

//  super(ROBallisticProjectile).HitWall(HitNormal, Wall); // removed as just duplicates shell debugging

    if (Role == ROLE_Authority)
    {
        if ((!Wall.bStatic && !Wall.bWorldGeometry) || RODestroyableStaticMesh(Wall) != none || Mover(Wall) != none)
        {
            if (SavedHitActor != none || RODestroyableStaticMesh(Wall) != none || Mover(Wall) != none)
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

                Wall.TakeDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
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
        // Save the hit info for when the shell is destroyed
        SavedHitLocation = HitLocation;
        SavedHitNormal = HitNormal;

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
}

// Matt: modified to handle new collision mesh actor - if we hit a col mesh, we switch hit actor to col mesh's owner & proceed as if we'd hit that actor
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
        if (Victim == none || Victim == self || Victim == HurtWall || Victim.IsA('ROTankCannon') || Victim.Role < ROLE_Authority || Victim.IsA('FluidSurfaceInfo'))
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
        if (TraceActor != none && TraceActor != Victim && (TraceActor.bWorldGeometry || TraceActor.IsA('ROVehicle') || (TraceActor.IsA('ROTankCannon') && Victim != TraceActor.Base)))
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

        if (Victim.IsA('ROVehicle') && ROVehicle(Victim).Health > 0)
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

        if (LastTouched.IsA('ROVehicle') && ROVehicle(LastTouched).Health > 0)
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

        if (EffectIsRelevant(Location, false))
        {
            Spawn(ShellShatterEffectClass,,, HitLocation + (HitNormal * 16.0), rotator(HitNormal));
        }

        bRoundShattered = false; // reset
        bDidExplosionFX = true;  // we've played specific shatter effects, so flag this to avoid calling SpawnExplosionEffects
        Explode(HitLocation + ExploWallOut * HitNormal, HitNormal);
    }
    // Round explodes on vehicle armor
    else if (bExplodesOnArmor)
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

        if (EffectIsRelevant(Location, false))
        {
            Spawn(ShellDeflectEffectClass,,, HitLocation + (HitNormal * 16.0), rotator(HitNormal));
        }

        bDidExplosionFX = true;  // we've played specific explosion effects, so flag this to avoid calling SpawnExplosionEffects
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

            if (EffectIsRelevant(Location, false))
            {
                Spawn(ShellDeflectEffectClass,,, HitLocation + (HitNormal * 16.0), rotator(HitNormal));
            }
        }

        DHDeflect(HitLocation, HitNormal, HitActor);
    }

    // If bot fired this round, notify it of ineffective attack on vehicle
    if (ROBot(InstigatorController) != none)
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
simulated function DHDeflect(vector HitLocation, vector HitNormal, Actor Wall)
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
        AmbientSound = none;
    }

    bTrueBallistics = false;
    Acceleration = PhysicsVolume.Gravity;
    bUpdateSimulatedPosition = false; // don't replicate the position any more, just let the client simulate movement after deflection (it's no longer critical)

    // Reflect off hit surface, with damping
    VNorm = (Velocity dot HitNormal) * HitNormal;
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
    if (NewVolume.bWaterVolume || NewVolume.IsA('WaterVolume'))
    {
        if (Level.NetMode != NM_DedicatedServer)
        {
            CheckForSplash(Location);
        }

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

// Modified to remove trace to check whether we hit water, as that ignores a DH_WaterVolume because it has bWaterVolume=false, but we know we've hit water anyway
// And to add a location adjustment to raise the effect, as the passed SplashLocation is usually below the water surface
// Also added EffectIsRelevant check before spawning splash effect
simulated function CheckForSplash(vector SplashLocation)
{
    local float Adjustment;

    if (!(Instigator != none && (WaterVolume(Instigator.PhysicsVolume) != none || (Instigator.PhysicsVolume != none && Instigator.PhysicsVolume.bWaterVolume)))
        && !Level.bDropDetail && Level.DetailMode != DM_Low && (ShellHitWaterEffectClass != none || WaterHitSound != none))
    {
        PlaySound(WaterHitSound,, 5.5 * TransientSoundVolume);

        if (ShellHitWaterEffectClass != none && EffectIsRelevant(Location, false))
        {
            // Passed SplashLocation is usually some way below the water surface, so the effect doesn't look quite right, especially the water ring not being seen
            // So we'll raise it by an arbitrary 10 units in the Z axis, which works pretty well most of the time
            // The adjustment backs up along the projectile's path & is calculated from its pitch angle to give an adjustment of 10 units vertically
            Adjustment = 10.0 / Sin(class'DHLib'.static.UnrealToRadians(-Rotation.Pitch));
            SplashLocation = SplashLocation - (Adjustment * vector(Rotation));

            Spawn(ShellHitWaterEffectClass,,, SplashLocation, rot(16384, 0, 0));
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

// New function just to consolidate long code that's repeated in more than one function
simulated function SpawnExplosionEffects(vector HitLocation, vector HitNormal, optional float ActualLocationAdjustment)
{
    local sound          HitSound;
    local class<Emitter> HitEmitterClass;
    local vector         TraceHitLocation, TraceHitNormal;
    local Material       HitMaterial;
    local ESurfaceTypes  SurfType;
    local bool           bShowDecal, bSnowDecal;

    if (Level.NetMode == NM_DedicatedServer)
    {
        return;
    }

    // Play random explosion sound if this shell has any
    if (ExplosionSound.Length > 0)
    {
        PlaySound(ExplosionSound[Rand(ExplosionSound.Length - 1)], SLOT_None, ExplosionSoundVolume * TransientSoundVolume);
    }

    // Do a shake effect if projectile always causes shake, or if we hit a vehicle
    if (bAlwaysDoShakeEffect || ROVehicle(SavedHitActor) != none)
    {
        DoShakeEffect();
    }

    // Hit a vehicle - set hit effects
    if (ROVehicle(SavedHitActor) != none)
    {
        HitSound = VehicleHitSound;
        HitEmitterClass = ShellHitVehicleEffectClass;
    }
    // Hit something else - get material type & set effects
    else if (!PhysicsVolume.bWaterVolume && WaterVolume(PhysicsVolume) == none)
    {
        Trace(TraceHitLocation, TraceHitNormal, HitLocation + vector(Rotation) * 16.0, HitLocation, false,, HitMaterial);

        if (HitMaterial == none)
        {
            SurfType = EST_Default;
        }
        else
        {
            SurfType = ESurfaceTypes(HitMaterial.SurfaceType);
        }

        switch (SurfType)
        {
            case EST_Snow:
            case EST_Ice:
                HitSound = DirtHitSound;
                HitEmitterClass = ShellHitSnowEffectClass;
                bShowDecal = true;
                bSnowDecal = true;
                break;

            case EST_Rock:
            case EST_Gravel:
            case EST_Concrete:
                HitSound = RockHitSound;
                HitEmitterClass = ShellHitRockEffectClass;
                bShowDecal = true;
                break;

            case EST_Wood:
            case EST_HollowWood:
                HitSound = WoodHitSound;
                HitEmitterClass = ShellHitWoodEffectClass;
                bShowDecal = true;
                break;

            case EST_Water:
                HitSound = WaterHitSound; // Matt: added as can't see why not (no duplication with CheckForSplash water effects as here we aren't in a WaterVolume)
                HitEmitterClass = ShellHitWaterEffectClass;
                break;

            case EST_Custom00:
                // do nothing
                break;

            default:
                HitSound = DirtHitSound;
                HitEmitterClass = ShellHitDirtEffectClass;
                bShowDecal = true;
                break;
        }
    }

    // Play impact sound & effect
    // Moved effect relevance check so only affects hit effect, as impact sound should play even if effect is skipped because it's not on player's screen
    if (HitSound != none)
    {
        PlaySound(HitSound, SLOT_Misc, 5.5 * TransientSoundVolume);
    }

    if (HitEmitterClass != none && EffectIsRelevant(Location, false))
    {
        Spawn(HitEmitterClass,,, HitLocation + HitNormal * 16.0, rotator(HitNormal));
    }

    // Spawn explosion decal
    if (bShowDecal)
    {
        // Adjust decal position to reverse any offset already applied to passed HitLocation to spawn explosion effects away from hit surface (e.g. PeneExploWall adjustment in HEAT shell)
        if (ActualLocationAdjustment != 0.0)
        {
            HitLocation -= (ActualLocationAdjustment * HitNormal);
        }

        if (bSnowDecal && ExplosionDecalSnow != none)
        {
            Spawn(ExplosionDecalSnow, self,, HitLocation, rotator(-HitNormal));
        }
        else if (ExplosionDecal != none)
        {
            Spawn(ExplosionDecal, self,, HitLocation, rotator(-HitNormal));
        }
    }
}

// Modified to fix UT2004 bug affecting non-owning net players in any vehicle with bPCRelativeFPRotation (nearly all), often causing impact/explosion effects to be skipped
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

    // Net clients
    if (Role < ROLE_Authority)
    {
        // Always relevant for the owning net player, i.e. the player that fired the projectile
        if (Instigator != none && Instigator.IsHumanControlled())
        {
            return true;
        }

        // Not relevant for other net clients if projectile has not been drawn on their screen recently
        if (SpawnLocation == Location)
        {
            if ((Level.TimeSeconds - LastRenderTime) >= 3.0)
            {
                return false;
            }
        }
        else if (Instigator == none || (Level.TimeSeconds - Instigator.LastRenderTime) >= 3.0)
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
        LifeSpan = DestroyTime; // Matt: on a server, this actor will automatically be destroyed in a split second, allowing a buffer for the client to catch up
        SetCollision(false, false);
        bCollideWorld = false;  // Matt: added to prevent continuing calls to HitWall on server, while shell persists
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
}

simulated function bool ShouldDrawDebugLines()
{
    if (DrawDebugLines && FirstHit && Level.NetMode != NM_DedicatedServer)
    {
        FirstHit = false;

        return true;
    }
}

function DebugShotDistanceAndSpeed()
{
    if (bIsAlliedShell)
    {
        Level.Game.Broadcast(self, "Shot distance:" @ (VSize(LaunchLocation - Location) / 55.186) @ "yards, impact speed:" @ VSize(Velocity) / 18.395 @ "fps");
    }
    else
    {
        Level.Game.Broadcast(self, "Shot distance:" @ (VSize(LaunchLocation - Location) / 60.352) $ "m, impact speed:" @ VSize(Velocity) / 60.352 @ "m/s");
    }
}

// Matt: based on HandleShellDebug from cannon class, but may as well do it here as we have saved TraceHitLoc in PostBeginPlay if bDebugBallistics is true
// Modified to avoid confusing "bullet drop" text and to add shell drop in both cm and inches (accurately converted)
simulated function HandleShellDebug(vector RealHitLocation)
{
    local float ShellDropUnits;

    if (NumDeflections < 1) // don't debug if it's just a deflected shell
    {
        ShellDropUnits = TraceHitLoc.Z - RealHitLocation.Z;
        Log("Shell drop =" @ ShellDropUnits / 60.352 * 100.0 @ "cm /" @ ShellDropUnits / ScaleFactor * 12.0 @ "inches" @ "TraceZ =" @ TraceHitLoc.Z @ " RealZ =" @ RealHitLocation.Z);
    }
}

defaultproperties
{
    RoundType=RT_APC
    bUseCollisionStaticMesh=true
    bBotNotifyIneffective=true
    bIsAlliedShell=true
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
}
