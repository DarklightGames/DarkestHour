//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHIncendiarySubProjectile extends DHProjectile;

var     class<Actor>    FlameEffect;
var private Actor       FlameInstance;

//==============================================================================
// Variables from deprecated ROThrowableExplosiveProjectile:

var     byte            ThrowerTeam;      // the team number of the person that threw this projectile
var     AvoidMarker     Fear;             // scares the bots away from this

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        SetTimer(1.0, true);
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        FlameInstance = Spawn(FlameEffect);//,,, Location, rotator(vect(0,0,1)));
        FlameInstance.SetBase(self);
        FlameInstance.SetRelativeLocation(vect(0, 0, 0));

        bDynamicLight = true;
    }
    else
    {
        bDynamicLight = false;
    }

    if (InstigatorController != none)
    {
        ThrowerTeam = InstigatorController.GetTeamNum();
    }
}

simulated function Destroyed()
{
    if (Fear != none) Fear.Destroy();
    if (FlameInstance != none) FlameInstance.Destroy();

    super.Destroyed();
}

// Modified to handle new collision mesh actor - if we hit a col mesh, we switch hit actor to col mesh's owner & proceed as if we'd hit that actor
// Also to call CheckVehicleOccupantsRadiusDamage() instead of DriverRadiusDamage() on a hit vehicle, to properly handle blast damage to any exposed vehicle occupants
// And to fix problem affecting many vehicles with hull mesh modelled with origin on the ground, where even a slight ground bump could block all blast damage
// Also to update Instigator, so HurtRadius attributes damage to the player's current pawn
function HurtRadius(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
    local Actor         Victim, TraceActor;
    local DHVehicle     VictimVehicle;
    local ROVehicle     lastTouchedVehicle;
    local ROPawn        VictimPawn;
    local array<ROPawn> checkedROPawns;
    local bool          bAlreadyChecked;
    local vector        VictimLocation, Direction, TraceHitLocation, TraceHitNormal;
    local float         DamageScale, Distance, DamageExposure;
    local int           i;

    // Make sure nothing else runs HurtRadius while we are in the middle of the function
    if (bHurtEntry)
    {
        return;
    }

    UpdateInstigator();

    // Just return if the player switches teams after throwing the explosive - this prevent people TK exploiting by switching teams
    if (InstigatorController == none || InstigatorController.GetTeamNum() != ThrowerTeam || ThrowerTeam == 255)
    {
        return;
    }

    bHurtEntry = true;

    // Find all colliding actors within blast radius, which the blast should damage
    // No longer use VisibleCollidingActors as much slower (FastTrace on every actor found), but we can filter actors & then we do our own, more accurate trace anyway
    foreach CollidingActors(class'Actor', Victim, DamageRadius, HitLocation)
    {
        if (!Victim.bBlockActors || Victim.IsA(class'Projectile'.Name)) // ignore other projectiles
        {
            continue;
        }

        // If hit a collision mesh actor, switch to its owner
        if (Victim.IsA(class'DHCollisionMeshActor'.Name))
        {
            if (DHCollisionMeshActor(Victim).bWontStopBlastDamage)
            {
                continue; // ignore col mesh actor if it is set not to stop blast damage
            }

            Victim = Victim.Owner;
        }

        // Don't damage this projectile, an actor already damaged by projectile impact (HurtWall), cannon actors, non-authority actors, or fluids
        // We skip damage on cannons because the blast will hit the vehicle base so we don't want to double up on damage to the same vehicle
        if (Victim == none ||
            Victim == self ||
            Victim == HurtWall ||
            Victim.IsA(class'DHVehicleCannon'.Name) ||
            Victim.Role < ROLE_Authority ||
            Victim.IsA(class'FluidSurfaceInfo'.Name))
        {
            continue;
        }

        // Now we need to check whether there's something in the way that could shield this actor from the blast
        // Usually we trace to actor's location, but for a vehicle with a cannon we adjust Z location to give a more consistent, realistic tracing height
        // This is because many vehicles are modelled with their origin on the ground, so even a slight bump in the ground could block all blast damage!
        VictimLocation = Victim.Location;
        VictimVehicle = DHVehicle(Victim);

        if (VictimVehicle != none &&
            VictimVehicle.Cannon != none &&
            VictimVehicle.Cannon.AttachmentBone != '')
        {
            VictimLocation.Z = VictimVehicle.GetBoneCoords(VictimVehicle.Cannon.AttachmentBone).Origin.Z;
        }

        // Trace from explosion point to the actor to check whether anything is in the way that could shield it from the blast
        TraceActor = Trace(/*out*/ TraceHitLocation,
                           /*out*/ TraceHitNormal,
                           VictimLocation,
                           HitLocation);

        if (DHCollisionMeshActor(TraceActor) != none)
        {
            if (DHCollisionMeshActor(TraceActor).bWontStopBlastDamage)
            {
                continue;
            }

            TraceActor = TraceActor.Owner; // as normal, if hit a collision mesh actor then switch to its owner
        }

        // Ignore the actor if the blast is blocked by world geometry, a vehicle, or a turret (but don't let a turret block damage to its own vehicle)
        if (TraceActor != none &&
            TraceActor != Victim &&
            (TraceActor.bWorldGeometry ||
             TraceActor.IsA(class'ROVehicle'.Name) ||
             (TraceActor.IsA(class'DHVehicleCannon'.Name) && Victim != TraceActor.Base)))
        {
            continue;
        }

        // Check for hit on player pawn
        VictimPawn = ROPawn(Victim);

        if (VictimPawn != none)
        {
            // If we hit a player pawn, make sure we haven't already registered the hit & add pawn to array of already hit/checked pawns
            for(i = 0; i < checkedROPawns.Length; ++i)
            {
                if (VictimPawn == checkedROPawns[i])
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

            checkedROPawns[checkedROPawns.Length] = VictimPawn;

            // If player is partially shielded from the blast, calculate damage reduction scale
            DamageExposure = VictimPawn.GetExposureTo(HitLocation + 15.0 * -Normal(PhysicsVolume.Gravity));

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

        if (VictimPawn != none)
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
        // Log("DamageAmount: "@ DamageScale @", DamageAmount: "@ DamageAmount @", final: "@ (DamageScale*DamageAmount));

        Victim.TakeDamage(DamageScale * DamageAmount,
                          Instigator,
                          VictimLocation - 0.5 * (Victim.CollisionHeight + Victim.CollisionRadius) * Direction,
                          DamageScale * Momentum * Direction,
                          DamageType);

        if (VictimVehicle != none && VictimVehicle.Health > 0)
        {
            CheckVehicleOccupantsRadiusDamage(VictimVehicle,
                                              DamageAmount,
                                              DamageRadius,
                                              DamageType,
                                              Momentum,
                                              HitLocation);
        }
    }

    // Same (or very similar) process for the last actor this projectile hit (Touched), but only happens if actor wasn't found by the check for CollidingActors
    if (LastTouched != none &&
        LastTouched != self &&
        LastTouched.Role == ROLE_Authority &&
        !LastTouched.IsA(class'FluidSurfaceInfo'.Name))
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

        LastTouched.TakeDamage(DamageScale * DamageAmount,
                               Instigator,
                               LastTouched.Location - 0.5 * (LastTouched.CollisionHeight + LastTouched.CollisionRadius) * Direction,
                               DamageScale * Momentum * Direction,
                               DamageType);

        lastTouchedVehicle = ROVehicle(LastTouched);

        if (lastTouchedVehicle != none && lastTouchedVehicle.Health > 0)
        {
            CheckVehicleOccupantsRadiusDamage(lastTouchedVehicle,
                                              DamageAmount,
                                              DamageRadius,
                                              DamageType,
                                              Momentum,
                                              HitLocation);
        }

        LastTouched = none;
    }

    bHurtEntry = false;
}

// New function to check for possible blast damage to all vehicle occupants that don't have collision of their own & so won't be 'caught' by HurtRadius
function CheckVehicleOccupantsRadiusDamage(ROVehicle Vehicle, float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
    local ROVehicleWeaponPawn WeaponPawn;
    local int i, NumWeapons;

    if (Vehicle.Driver != none &&
        Vehicle.DriverPositions[Vehicle.DriverPositionIndex].bExposed &&
        !Vehicle.Driver.bCollideActors &&
        !Vehicle.bRemoteControlled)
    {
        VehicleOccupantBlastDamage(Vehicle.Driver, DamageAmount, DamageRadius, DamageType, Momentum, HitLocation);
    }

    NumWeapons = Vehicle.WeaponPawns.Length;

    for(i = 0; i < NumWeapons; ++i)
    {
        WeaponPawn = ROVehicleWeaponPawn(Vehicle.WeaponPawns[i]);
        if (WeaponPawn != none &&
            WeaponPawn.Driver != none &&
            ((WeaponPawn.bMultiPosition && WeaponPawn.DriverPositions[WeaponPawn.DriverPositionIndex].bExposed) ||
             WeaponPawn.bSinglePositionExposed) &&
            !WeaponPawn.bCollideActors &&
            !WeaponPawn.bRemoteControlled)
        {
            VehicleOccupantBlastDamage(WeaponPawn.Driver, DamageAmount, DamageRadius, DamageType, Momentum, HitLocation);
        }
    }
}

function VehicleOccupantBlastDamage(Pawn Pawn, float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
    local Actor  TraceHitActor;
    local coords HeadBoneCoords;
    local vector HeadLocation, TraceHitLocation, TraceHitNormal, Direction;
    local float  Dist, DamageScale;

    if (Pawn != none)
    {
        HeadBoneCoords = Pawn.GetBoneCoords(Pawn.HeadBone);
        HeadLocation = HeadBoneCoords.Origin + ((Pawn.HeadHeight + (0.5 * Pawn.HeadRadius)) * Pawn.HeadScale * HeadBoneCoords.XAxis);

        // Trace from the explosion to the top of player pawn's head & if there's a blocking actor in between (probably the vehicle), exit without damaging pawn
        foreach TraceActors(class'Actor', TraceHitActor, TraceHitLocation, TraceHitNormal, HeadLocation, HitLocation)
        {
            if (TraceHitActor.bBlockActors)
                return;
        }

        // Calculate damage based on distance from explosion
        Direction = Pawn.Location - HitLocation;
        Dist = FMax(1.0, VSize(Direction));
        Direction = Direction / Dist;
        DamageScale = 1.0 - FMax(0.0, (Dist - Pawn.CollisionRadius) / DamageRadius);

        // Damage the vehicle occupant
        if (DamageScale > 0.0)
        {
            Pawn.SetDelayedDamageInstigatorController(InstigatorController);
            Pawn.TakeDamage(DamageScale * DamageAmount,
                            InstigatorController.Pawn,
                            Pawn.Location - (0.5 * (Pawn.CollisionHeight + Pawn.CollisionRadius)) * Direction,
                            DamageScale * Momentum * Direction,
                            DamageType);
        }
    }
}

// New function updating Instigator reference to ensure damage is attributed to correct player, as may have switched to different pawn since throwing, e.g. entered vehicle
simulated function UpdateInstigator()
{
    if (InstigatorController != none && InstigatorController.Pawn != none)
    {
        Instigator = InstigatorController.Pawn;
    }
}

simulated function Landed(vector HitNormal)
{
    local Actor         Victim;
    local DHVehicle     VictimVehicle;

    UpdateInstigator();

    // Just return if the player switches teams after throwing the explosive - this prevent people TK exploiting by switching teams
    if (InstigatorController == none || InstigatorController.GetTeamNum() != ThrowerTeam || ThrowerTeam == 255)
    {
        return;
    }

    // Set vehicles on fire!
    foreach CollidingActors(class'Actor', Victim, DamageRadius, Location)
    {
        // If hit a collision mesh actor, switch to its owner
        if (Victim.IsA(class'DHCollisionMeshActor'.Name))
        {
            if (DHCollisionMeshActor(Victim).bWontStopBlastDamage)
            {
                continue; // ignore col mesh actor if it is set not to stop blast damage
            }

            Victim = Victim.Owner;
        }

        VictimVehicle = DHVehicle(Victim);

        if (VictimVehicle != none && VictimVehicle.Health > 0)
        {
            VictimVehicle.TakeIncendiaryDamage(Instigator, Location, MyDamageType);
        }
    }
}

simulated function HitWall(vector HitNormal, Actor Wall)
{
    local RODestroyableStaticMesh DestroyMesh;
    local Class<DamageType> NextDamageType;
    local int i, DamageTypesAmount;
    local float ImpactSpeed, ImpactObliquityAngle, ObliquityDotProduct;

    DestroyMesh = RODestroyableStaticMesh(Wall);
    ImpactSpeed = VSize(Velocity);
    ObliquityDotProduct = Normal(-Velocity) dot HitNormal;
    ImpactObliquityAngle = Acos(ObliquityDotProduct) * 180.0 / Pi;

    // We hit a destroyable mesh that is so weak it doesn't stop bullets (e.g. glass), so we'll probably break it instead of bouncing off it
    if (DestroyMesh != none && DestroyMesh.bWontStopBullets)
    {
        // On a server (single player), we'll simply cause enough damage to break the mesh
        if (Role == ROLE_Authority)
        {
            DestroyMesh.TakeDamage(DestroyMesh.Health + 1,
                                  Instigator,
                                  Location,
                                  MomentumTransfer * Normal(Velocity),
                                  class'DHWeaponBashDamageType');

            // But it will only take damage if it's vulnerable to a weapon bash - so check if it's been reduced to zero Health & if so then we'll exit without deflecting
            if (DestroyMesh.Health < 0)
            {
                return;
            }
        }
        // Problem is that a client needs to know right now whether or not the mesh will break, so it can decide whether or not to bounce off
        // So as a workaround we'll loop through the meshes TypesCanDamage array & check if the server's weapon bash DamageType will have broken the mesh
        else
        {
            DamageTypesAmount = DestroyMesh.TypesCanDamage.Length;
            for(i = 0; i < DamageTypesAmount; ++i)
            {
                // The destroyable mesh will be damaged by a weapon bash, so we'll exit without deflecting
                NextDamageType = DestroyMesh.TypesCanDamage[i];
                if (NextDamageType == class'DHWeaponBashDamageType' ||
                    ClassIsChildOf(class'DHWeaponBashDamageType', NextDamageType))
                {
                    return;
                }
            }
        }
    }
}

// Modified to handle new collision mesh actor - if we hit a CM we switch hit actor to CM's owner & proceed as if we'd hit that actor
simulated singular function Touch(Actor Other)
{
    local vector hitLocation, hitNormal;

    // Added splash if projectile hits a fluid surface
    if (FluidSurfaceInfo(Other) != none)
    {
        self.Destroy();
    }

    if (Other == none || (!Other.bProjTarget && !Other.bBlockActors))
    {
        return;
    }

    // We use TraceThisActor do a simple line check against the actor we've hit, to get an accurate HitLocation to pass to ProcessTouch()
    // It's more accurate than using our current location as projectile has often travelled further by the time this event gets called
    // But if that trace returns true then it somehow didn't hit the actor, so we fall back to using our current location as the HitLocation
    // Also skip trace & use our location if velocity is zero (touching actor when projectile spawns) or hit a Mover actor (legacy, don't know why)
    if (VSizeSquared(Velocity) == 0 ||
        Other.IsA(class'Mover'.Name) ||
        Other.TraceThisActor(/*out*/ hitLocation,
                             /*out*/ hitNormal,
                             Location,
                             Location - (2.0 * Velocity),
                             GetCollisionExtent()))
    {
        hitLocation = Location;
    }

    // Special handling for hit on a collision mesh actor - switch hit actor to CM's owner & proceed as if we'd hit that actor
    if (Other.IsA(class'DHCollisionMeshActor'.Name))
    {
        if (DHCollisionMeshActor(Other).bWontStopThrownProjectile)
        {
            return; // exit, doing nothing, if col mesh actor is set not to stop a thrown projectile, e.g. grenade or satchel
        }

        Other = Other.Owner;
    }

    // Now call ProcessTouch(), which is the where the class-specific Touch functionality gets handled
    // Record LastTouched to make sure that if HurtRadius gets called to give blast damage, it will always 'find' the hit actor
    LastTouched = Other;
    ProcessTouch(Other, hitLocation);
    LastTouched = none;
}

simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    local vector tempHitLocation, hitNormal;

    if (Other == Instigator ||
        Other.Base == Instigator ||
        ROBulletWhipAttachment(Other) != none)
    {
        return;
    }

    Trace(/*out*/ tempHitLocation,
          /*out*/ hitNormal,
          HitLocation + Normal(Velocity) * 50.0,
          HitLocation - Normal(Velocity) * 50.0,
          true); // get a reliable HitNormal for a deflection

    // call HitWall for all hit actors, so grenades etc bounce off things like turrets or other players
    HitWall(hitNormal, Other);
}

function Timer ()
{
    HurtRadius(Damage,
               DamageRadius,
               MyDamageType,
               0,
               Location);
}

// Modified to fix UT2004 bug affecting non-owning net players in any vehicle with bPCRelativeFPRotation (nearly all), often causing effects to be skipped
// Vehicle's rotation was not being factored into calcs using the PlayerController's rotation, which effectively randomised the result of this function
simulated function bool EffectIsRelevant(vector SpawnLocation, bool bForceDedicated)
{
    local PlayerController PlayerController;

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
        if ((Level.TimeSeconds-LastRenderTime) >= 3.0)
        {
            return false;
        }
    }

    PlayerController = Level.GetLocalPlayerController();

    if (PlayerController == none || PlayerController.ViewTarget == none)
    {
        return false;
    }

    // Check to see whether effect would spawn off to the side or behind where player is facing, & if so then only spawn if within quite close distance
    // Using PC's CalcViewRotation, which is the last recorded camera rotation, so a simple way of getting player's non-relative view rotation, even in vehicles
    // (doesn't apply to the player that fired the projectile)
    if (PlayerController.Pawn != Instigator &&
        vector(PlayerController.CalcViewRotation) dot (SpawnLocation-PlayerController.ViewTarget.Location) < 0.0)
    {
        return VSizeSquared(PlayerController.ViewTarget.Location-SpawnLocation) < (1600*1600); // 1600 UU or 26.5m (changed to VSizeSquared as more efficient)
    }

    // Effect relevance is based on normal distance check
    return CheckMaxEffectDistance(PlayerController, SpawnLocation);
}

simulated function PhysicsVolumeChange(PhysicsVolume NewVolume)
{
    // if thrown projectile hits water
    if (NewVolume != none && NewVolume.bWaterVolume)
    {
        // fire is out!
        self.Destroy();
    }
}

defaultproperties
{
    bNetTemporary=false
    bBlockHitPointTraces=false
    LifeSpan=30.0

    // damage
    Damage=80.0
    DamageRadius=150.0
    MyDamageType=class'DHBurningDamageType'

    // physics
    Physics=PHYS_Falling
    bCollideWorld=true
    bCollideActors=true
    bBlockActors=false
    CollisionRadius=5.0
    CollisionHeight=0.0
    bBounce=false
    MaxSpeed=1500.0

    // fx
    FlameEffect=class'DH_Effects.DHMolotovCoctailProjectile'

    // sound
    SoundVolume=80;
    SoundRadius=500
    AmbientSound=Sound'DH_MolotovCocktail.burning-loop'//Sound'Amb_Destruction.Fire.Krasnyi_Fire_House02'//Sound'Amb_Destruction.Fire.Kessel_Fire_Small_Barrel'

    // give light
    // LightType=LT_Pulse
    // LightBrightness=3.0
    // LightRadius=70.0
    // LightHue=10
    // LightSaturation=255
}
