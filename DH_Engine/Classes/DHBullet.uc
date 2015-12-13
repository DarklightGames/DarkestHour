//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHBullet extends ROBullet
    config
    abstract;

// General
var     int             WhizType;        // sent in HitPointTrace to only do snaps for supersonic rounds (0 = none, 1 = close supersonic bullet, 2 = subsonic or distant bullet)
var     Actor           SavedTouchActor; // added (same as shell) to prevent recurring ProcessTouch on same actor (e.g. was screwing up tracer ricochets from VehicleWeapons like turrets)
var     sound           WaterHitSound;   // sound of this bullet hitting water

// Tracers
var     bool            bIsTracerBullet; // just set to true in a tracer bullet subclass of a normal bullet & then the inheritance from this class will handle everything
var     bool            bHasDeflected;
var     byte            Bounces;
var     StaticMesh      DeflectedMesh;
var     class<Emitter>  TracerEffectClass;
var     Emitter         TracerEffect;
var     float           TracerPullback;
var     float           DampenFactor;
var     float           DampenFactorParallel;

// Vehicle hit effects
var     class<Emitter>  VehiclePenetrateEffectClass;
var     sound           VehiclePenetrateSound;
var     float           VehiclePenetrateSoundVolume;
var     class<Emitter>  VehicleDeflectEffectClass;
var     sound           VehicleDeflectSound;
var     float           VehicleDeflectSoundVolume;

// Debugging
var globalconfig bool   bDebugROBallistics; // if true, set bDebugBallistics to true for getting the arrow pointers

// Modified to move bDebugBallistics stuff to PostNetBeginPlay, as net client won't yet have Instigator here
simulated function PostBeginPlay()
{
    OrigLoc = Location;
    BCInverse = 1.0 / BallisticCoefficient;
    Velocity = vector(Rotation) * Speed;

    if (Role == ROLE_Authority && Instigator != none && (WaterVolume(Instigator.HeadVolume) != none || (Instigator.HeadVolume != none && Instigator.HeadVolume.bWaterVolume)))
    {
        Velocity *= 0.5;
    }
}

// Modified to set InstigatorController, to set tracer properties if this is a tracer bullet, & to move bDebugBallistics stuff here from PostBeginPlay (with bDebugROBallistics option)
simulated function PostNetBeginPlay()
{
    local Actor  TraceHitActor;
    local vector HitNormal;
    local float  TraceRadius;

    if (Instigator != none)
    {
        InstigatorController = Instigator.Controller;
    }

    if (bIsTracerBullet && Level.NetMode != NM_DedicatedServer)
    {
        SetDrawType(DT_StaticMesh);
//      SetRotation(rotator(Velocity)); // removed as simply setting bOrientToVelocity handles this natively (replacing use of Tick)
        bOrientToVelocity = true;

        if (Level.bDropDetail)
        {
            bDynamicLight = false;
//          LightType = LT_None; // is default anyway
        }
        else
        {
            bDynamicLight = true;
            LightType = LT_Steady;
        }

        LightBrightness = 90.0;
        LightRadius = 10.0;
        LightHue = 45;
        LightSaturation = 128;
        AmbientGlow = 254;
        LightCone = 16;

        TracerEffect = Spawn(TracerEffectClass, self,, (Location + Normal(Velocity) * TracerPullback));
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

        Log("Bullet debug tracing: TraceHitActor =" @ TraceHitActor);
    }
}

// Matt: new function, called by DHFastAutoFire's SpawnProjectile function to set this as a server bullet, meaning won't be replicated as a separate client bullet will be spawned on client
// RemoteRole = none was the only change in DH_ServerBullet that had any effect, so simply doing this means server bullet classes can be deprecated
function SetAsServerBullet()
{
    RemoteRole = ROLE_None;
}

// Matt: disabled as function is now emptied out, as don't want delayed destruction stuff from ROBullet - far cleaner just to set short LifeSpan on a server
// And for a tracer bullet, we don't need to keep setting its rotation to match its direction - simply setting bOrientToVelocity handles this natively
simulated function Tick(float DeltaTime)
{
    Disable('Tick');
}

// Matt: modified to handle new collision mesh actor - if we hit a col mesh, we switch hit actor to col mesh's owner & proceed as if we'd hit that actor
simulated singular function Touch(Actor Other)
{
    local vector HitLocation, HitNormal;

    // Added bBlockHitPointTraces check here, so can avoid it at start of ProcessTouch(), meaning owner of col mesh gets handled properly in PT (it will have bBlockHitPointTraces=false)
    if (Other != none && (Other.bProjTarget || Other.bBlockActors) && Other.bBlockHitPointTraces)
    {
        // Collision static mesh actor handling
        if (Other.IsA('DHCollisionMeshActor'))
        {
            // If col mesh is set not to stop a bullet then we exit, doing nothing
            if (DHCollisionMeshActor(Other).bWontStopBullet)
            {
                return;
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

            // Switch hit Other to be the col mesh's owner & proceed as if we'd hit that actor
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

// Matt: modified to handle tracer bullet clientside effects, as well as normal bullet functionality, plus handling of hit on a vehicle weapon similar to a shell
simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    local DHPawn       HitPawn;
    local Actor        InstigatorPlayer, A;
    local array<Actor> SavedColMeshes;
    local vector       PawnHitLocation, TempHitLocation, HitNormal, X, Y, Z;
    local bool         bPenetratedVehicle;
    local float        BulletDistance, V;
    local array<int>   HitPoints;
    local int          i;

    if (SavedTouchActor == Other) // immediate exit to prevent recurring touches on same actor
    {
        return;
    }

    SavedTouchActor = Other;

    // Checks are normally run to make sure we haven't hit Instigator or its Base or Owner, which is mainly to stop player hitting his own bullet whip attachment
    // But the whip attachment now retains its collision if player in a vehicle is exposed, so we also need to check on a player in a VehicleWeaponPawn
    // A VehicleWeaponPawn will be the Instigator, so in that case we record InstigatorPlayer as its 'Driver' & use that in place of Instigator
    if (VehicleWeaponPawn(Instigator) != none && VehicleWeaponPawn(Instigator).Driver != none)
    {
        InstigatorPlayer = VehicleWeaponPawn(Instigator).Driver;
    }
    else
    {
        InstigatorPlayer = Instigator;
    }

    // Exit without doing anything if we hit something we don't want to count a hit on
    // Using InstigatorPlayer instead of Instigator, except for a check on "Other.Owner == Instigator", which stops a VehicleWeapon from somehow shooting itself
    // Note that bBlockHitPointTraces removed here & instead checked in Touch() event, so an actor owning a collision mesh actor gets handled properly
    if (Other == none || Other == InstigatorPlayer || Other.Base == InstigatorPlayer || Other.Owner == InstigatorPlayer || Other.Owner == Instigator
        || Other.bDeleteMe || (Other.IsA('Projectile') && !Other.bProjTarget))
    {
        return;
    }

    // Handle hit on a vehicle weapon
    if (Other.IsA('ROVehicleWeapon'))
    {
        bPenetratedVehicle = !bHasDeflected && PenetrateVehicleWeapon(ROVehicleWeapon(Other));

        PlayVehicleHitEffects(bPenetratedVehicle, HitLocation, Normal(-Velocity));

        // Exit if failed to penetrate, destroying bullet unless it's a tracer deflection
        if (!bPenetratedVehicle)
        {
            // Tracer deflects unless bullet speed is very low (approx 12 m/s)
            // Added the trace to get a HitNormal, so ricochet is at correct angle (from shell's DeflectWithoutNormal function)
            if (Level.NetMode != NM_DedicatedServer && bIsTracerBullet && VSizeSquared(Velocity) > 500000.0)
            {
                Trace(HitLocation, HitNormal, HitLocation + Normal(Velocity) * 50.0, HitLocation - Normal(Velocity) * 50.0, true);
                Deflect(HitNormal);
            }
            else
            {
                Destroy();
            }

            return;
        }
    }

    // Get the bullet's speed
    if (!bHasDeflected)
    {
        V = VSize(Velocity);
    }

    // Get the axes, based on bullet's direction
    if (V >= 25.0 || bHasDeflected)
    {
        GetAxes(rotator(Velocity), X, Y, Z);
    }
    // But if bullet collides right after launch it won't have any velocity yet, so give it the default speed & use its rotation to get axes
    else
    {
        V = default.Speed;
        GetAxes(Rotation, X, Y, Z);
    }

    // We hit the bullet whip attachment around a player pawn
    if (ROBulletWhipAttachment(Other) != none)
    {
        if ((Other.Base != none && Other.Base.bDeleteMe) || InstigatorPlayer == none)
        {
            return;
        }

        // Set WhizType for possible bullet snap sound
        if (!bHasDeflected)
        {
            // If bullet collides immediately after launch, it has no location (or so it would appear, go figure) - let's check against the firer's location instead
            if (OrigLoc == vect(0.0, 0.0, 0.0) && Instigator != none)
            {
                OrigLoc = Instigator.Location;
            }

            BulletDistance = class'DHLib'.static.UnrealToMeters(VSize(HitLocation - OrigLoc)); // calculate distance travelled by bullet in metres

            // If it's friendly fire at close range, we won't suppress, so send a different WhizType in the HitPointTrace
            if (BulletDistance < 10.0 && InstigatorController != none && DHPawn(Other.Base) != none && InstigatorController.SameTeamAs(DHPawn(Other.Base).Controller))
            {
                WhizType = 3;
            }
            // Bullets only "snap" after a certain distance in reality, same goes here
            else if (BulletDistance < 20.0 && WhizType == 1)
            {
                WhizType = 2;
            }
        }

        // Trace to see if bullet path will actually hit one of the player pawn's various body hit points
        // Use the InstigatorPlayer to do the trace, as that makes HitPointTrace work better because it ignores the InstigatorPlayer & its own bullet whip attachment
        // Temporarily make InstigatorPlayer use same bUseCollisionStaticMesh setting as projectile (normally means switching to true), meaning trace uses col meshes on vehicles
        InstigatorPlayer.bUseCollisionStaticMesh = bUseCollisionStaticMesh;

        // Maximum of 3 traces - but we only ever repeat the trace if we hit an invalid col mesh actor, which is very rare, so nearly always only 1 trace will be done
        for (i = 0; i < 3; ++i)
        {
            A = InstigatorPlayer.HitPointTrace(TempHitLocation, HitNormal, HitLocation + (65535.0 * X), HitPoints, HitLocation,, WhizType);

            // We're primarily interested if we hit a player, but also need to check if hit an invalid collision mesh that doesn't stop bullets (as would need to repeat trace)
            if (DHPawn(A) != none || (DHCollisionMeshActor(A) != none && DHCollisionMeshActor(A).bWontStopBullet))
            {
                // Make sure hit actor isn't further away than furthest possible point of bullet whip attachment (don't count as valid hit, just let bullet continue)
                if (VSizeSquared(TempHitLocation - HitLocation) <= 360000.0) // 360k is whip's diameter (600 UU) squared
                {
                    // We hit a player, so record it
                    if (DHPawn(A) != none)
                    {
                        HitPawn = DHPawn(A);
                        PawnHitLocation = TempHitLocation;
                    }
                    // Otherwise, must have hit an invalid collision mesh, so we temporarily disable its collision & re-run the trace
                    // Matt: this is a hack, but I can't think of another solution - the disabled collision is only for a split second & it seems harmless & effective
                    else
                    {
                        SavedColMeshes[SavedColMeshes.Length] = A; // save reference to col mesh so we can re-enable its collision after tracing
                        A.SetCollision(false, A.bBlockActors);
                        continue; // re-run the trace
                    }
                }
            }

            break; // generally we're going to exit the for loop after the 1st pass, except in the rare event where we hit an invalid col mesh
        }

        // Reset any temporarily disabled collision mesh collision, now we've finished tracing
        for (i = 0; i < SavedColMeshes.Length; ++i)
        {
            SavedColMeshes[i].SetCollision(true, SavedColMeshes[i].bBlockActors);
        }

        // HitPointTrace says we hit a player, but we need to verify that as HitPointTrace is unreliable & often passes through a blocking vehicle, hitting a shielded player
        if (HitPawn != none)
        {
            // Trace along path from where we hit player's whip attachment to where we traced a hit on player, checking if any blocking actor is in the way
            foreach InstigatorPlayer.TraceActors(class'Actor', A, TempHitLocation, HitNormal, PawnHitLocation, HitLocation)
            {
                // We hit a blocking actor, so now check if it's a valid 'stopper'
                if ((A.bBlockActors || A.bWorldGeometry) && A.bBlockHitPointTraces)
                {
                    // If hit collision mesh actor, we switch hit actor to col mesh's owner & proceed as if we'd hit that actor
                    if (A.IsA('DHCollisionMeshActor'))
                    {
                        // But if col mesh doesn't stop bullets, we ignore it & continue the trace iteration
                        if (DHCollisionMeshActor(A).bWontStopBullet)
                        {
                            continue;
                        }

                        A = A.Owner;
                    }

                    // A blocking actor is in the way, so we didn't really hit the player (but ignore anything ProcessTouch would normally ignore)
                    if (A != InstigatorPlayer && A.Base != InstigatorPlayer && A.Owner != InstigatorPlayer && A.Owner != Instigator
                        && !A.bDeleteMe && !(Other.IsA('Projectile') && !Other.bProjTarget) && A != HitPawn)
                    {
                        HitPawn = none;
                        break;
                    }
                }
            }
        }

        // Reset InstigatorPlayer collision properties & reset WhizType for next collision
        InstigatorPlayer.bUseCollisionStaticMesh = InstigatorPlayer.default.bUseCollisionStaticMesh;
        WhizType = default.WhizType;

        // Bullet won't hit the player, so we'll exit now
        if (HitPawn == none)
        {
            return;
        }
    }

    // Do any damage
    if (!bHasDeflected && Role == ROLE_Authority && V > (MinPenetrateVelocity * ScaleFactor))
    {
        UpdateInstigator();

        // Damage a player pawn
        if (HitPawn != none)
        {
            if (!HitPawn.bDeleteMe)
            {
                HitPawn.ProcessLocationalDamage(Damage - 20.0 * (1.0 - V / default.Speed), Instigator, PawnHitLocation, MomentumTransfer * X, MyDamageType, HitPoints);
            }
        }
        // Damage something else
        else
        {
            Other.TakeDamage(Damage - 20.0 * (1.0 - V / default.Speed), Instigator, HitLocation, MomentumTransfer * X, MyDamageType);
        }
    }

    // The only way a tracer will deflect is off a vehicle weapon, which is handled above & results in exiting function early, so we can always destroy the bullet here
    Destroy();
}

// Matt: modified to remove delayed destruction of bullet on a server, as serves no purpose for a bullet
// Bullet is bNetTemporary, meaning it gets torn off on client as soon as it replicates, receiving no further input from server, so delaying destruction on server has no effect
// Also to handle tracer bullet clientside effects, as well as normal bullet functionality
// Note this gets called when bullet collides with an ROVehicle (not a VehicleWeapon), as well as world geometry
simulated function HitWall(vector HitNormal, Actor Wall)
{
    local ROVehicle HitVehicle;
    local bool      bPenetratedVehicle;
    local vector    HitLoc;
    local Material  HitMat;

    // This stops tracers from bouncing off thin air where the hidden BSP that network cuts is.
    // It supports network cutting BSP that is textured with a material surface type of `EST_Custom00`
    if (Wall.bHiddenEd) // `LevelInfo` which is BSP is set to bHiddenEd = true
    {
        Trace(HitLoc, HitNormal, Location + vector(Rotation) * 16.0, Location, true,, HitMat);

        if (HitMat != none && HitMat.SurfaceType == EST_Custom00)
        {
            Destroy();
            return;
        }
    }

    // Hit WallHitActor that we've already hit & recorded
    if (WallHitActor != none && WallHitActor == Wall)
    {
        if (bIsTracerBullet)
        {
            // Deflect off wall unless bullet speed is very low (approx 12 m/s)
            if (Level.NetMode != NM_DedicatedServer && VSizeSquared(Velocity) > 500000.0)
            {
                Deflect(HitNormal);
            }
            // Otherwise destroy if tracer has already deflected & this 'bullet' is now just a client visual effect
            else if (bHasDeflected)
            {
                bBounce = false;
                Bounces = 0;
                Destroy();
            }
        }

        return;
    }

    WallHitActor = Wall;
    HitVehicle = ROVehicle(Wall);

    // Handle hit on a vehicle
    if (HitVehicle != none)
    {
        bPenetratedVehicle = !bHasDeflected && PenetrateVehicle(HitVehicle);

        PlayVehicleHitEffects(bPenetratedVehicle, Location, HitNormal);
    }
    // Spawn the bullet hit effect on anything other than a vehicle
    else if (Level.NetMode != NM_DedicatedServer && ImpactEffect != none)
    {
        Spawn(ImpactEffect, self,, Location, rotator(-HitNormal)); // made bullet the owner of the effect, so effect can use bullet to to an EffectIsRelevant() check
    }

    if (!bHasDeflected && (HitVehicle == none || bPenetratedVehicle))
    {
        // Do any damage
        if (Role == ROLE_Authority)
        {
            UpdateInstigator();

            // Have to use special damage for vehicles, otherwise it doesn't register for some reason
            if (ROVehicle(Wall) != none)
            {
                Wall.TakeDamage(Damage - (20.0 * (1.0 - VSize(Velocity) / default.Speed)), Instigator, Location, MomentumTransfer * Normal(Velocity), MyVehicleDamage);
            }
            else if (Mover(Wall) != none || RODestroyableStaticMesh(Wall) != none || Vehicle(Wall) != none || ROVehicleWeapon(Wall) != none)
            {
                Wall.TakeDamage(Damage - (20.0 * (1.0 - VSize(Velocity) / default.Speed)), Instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
            }

            MakeNoise(1.0);
        }

        super(ROBallisticProjectile).HitWall(HitNormal, Wall); // is debug only
    }

    // Don't want to destroy the bullet if its going through something like glass
    if (RODestroyableStaticMesh(Wall) != none && RODestroyableStaticMesh(Wall).bWontStopBullets)
    {
        return;
    }

    // Removed the section that used to "Give the bullet a little time to play the hit effect client side before destroying the bullet"

    // Finally destroy this bullet, or maybe deflect if is tracer
    if (bIsTracerBullet)
    {
        // Deflect off wall unless penetrated vehicle or bullet speed is very low (approx 12 m/s)
        if (Level.NetMode != NM_DedicatedServer && !bPenetratedVehicle && VSizeSquared(Velocity) > 500000.0)
        {
            Deflect(HitNormal);
        }
        else
        {
            bBounce = false;
            Bounces = 0;
            Destroy();
        }
    }
    else
    {
        Destroy();
    }
}

// New function to check whether we penetrated a vehicle weapon that we hit (default bullet won't penetrate damage any vehicle weapon)
simulated function bool PenetrateVehicleWeapon(VehicleWeapon VW)
{
    return false;
}

// New function to check whether we penetrated a vehicle that we hit (default bullet will only penetrate soft skin vehicle, not an armored vehicle or APC)
simulated function bool PenetrateVehicle(ROVehicle V)
{
    return !bHasDeflected && !V.IsA('DHArmoredVehicle') && !V.IsA('DHApcVehicle');
}

// New function to handle hit effects for bullet hitting vehicle or vehicle weapon, depending on whether it penetrated (saves code repetition elsewhere)
simulated function PlayVehicleHitEffects(bool bPenetrated, vector HitLocation, vector HitNormal)
{
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (bPenetrated)
        {
            PlaySound(VehiclePenetrateSound, SLOT_None, VehiclePenetrateSoundVolume, false, 100.0);

            if (EffectIsRelevant(Location, false) && VehiclePenetrateEffectClass != none)
            {
                Spawn(VehiclePenetrateEffectClass, ,, HitLocation, rotator(-HitNormal));
            }
        }
        else
        {
            PlaySound(VehicleDeflectSound, SLOT_None, VehicleDeflectSoundVolume, false, 100.0);

            if (EffectIsRelevant(Location, false) && VehicleDeflectEffectClass != none)
            {
                Spawn(VehicleDeflectEffectClass,,, HitLocation, rotator(-HitNormal));
            }
        }
    }
}

// Modified to fix UT2004 bug affecting non-owning net players in any vehicle with bPCRelativeFPRotation (nearly all), often causing vehicle impact effects to be skipped
// Vehicle's rotation was not being factored into calcs using the PlayerController's rotation, which effectively randomised the result of this function
// Also re-factored to make it a little more optimised, direct & easy to follow (without repeated use of bResult)
simulated function bool EffectIsRelevant(vector SpawnLocation, bool bForceDedicated)
{
    local PlayerController    PC;
    local Vehicle             V;
    local VehicleWeaponPawn   VWP;
    local DHVehicleCannonPawn CP;
    local rotator             PCRelativeRotation;
    local vector              PCNonRelativeRotationVector;

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

    // Check to see whether the effect would spawn off to the side or behind where the player is facing, & if so then only spawn if within quite close distance
    // (doesn't apply to the player that fired the projectile)
    if (PC.Pawn != Instigator)
    {
        V = Vehicle(PC.Pawn);

        // If player is in a vehicle using relative view rotation (nearly all of them), we need to factor in the vehicle's rotation
        if (V != none && V.bPCRelativeFPRotation)
        {
            VWP = VehicleWeaponPawn(V);

            // For vehicle weapons we must use the Gun or VehicleBase rotation (they match), not the weapon pawn's rotation
            if (VWP != none)
            {
                PCRelativeRotation = PC.Rotation;
                CP = DHVehicleCannonPawn(VWP);

                // For turrets we also need to factor in the turret's yaw
                if (CP != none && CP.Cannon != none && CP.Cannon.bHasTurret)
                {
                    PCRelativeRotation.Yaw += CP.Cannon.CurrentAim.Yaw;
                }

                PCNonRelativeRotationVector = vector(PCRelativeRotation) >> VWP.Gun.Rotation; // note Gun's rotation is effectively same as the vehicle base
            }
            // For vehicle themselves, we just use the vehicle's rotation
            else
            {
                PCNonRelativeRotationVector = vector(PC.Rotation) >> V.Rotation;
            }
        }
        // For player's that aren't in vehicles or the vehicle doesn't use relative view rotation, we simply use the PC's rotation
        else
        {
            PCNonRelativeRotationVector = vector(PC.Rotation);
        }

        // Effect would spawn off to the side or behind where the player is facing, so only spawn if within quite close distance
        if (PCNonRelativeRotationVector dot (SpawnLocation - PC.ViewTarget.Location) < 0.0)
        {
            return VSizeSquared(PC.ViewTarget.Location - SpawnLocation) < 2560000.0; // equivalent to 1600 UU or 26.5m (changed to VSizeSquared as more efficient)
        }
    }

    // Effect relevance is based on normal distance check
    // If we got here, it means the effect would spawn broadly in front of where the player is facing, or we are the player responsible for the projectile
    return CheckMaxEffectDistance(PC, SpawnLocation);
}

// New function to handle tracer deflection off things
simulated function Deflect(vector HitNormal)
{
    local vector VNorm;

    bHasDeflected = true;

    if (TracerEffect != none && VSizeSquared(Velocity) < 750000.0) // approx 14 m/s
    {
        TracerEffect.Destroy();
    }

    if (StaticMesh != DeflectedMesh)
    {
        SetStaticMesh(DeflectedMesh);
    }

    SetPhysics(PHYS_Falling);
    bTrueBallistics = false;
    Acceleration = PhysicsVolume.Gravity;

    if (Bounces > 0)
    {
        Velocity *= 0.6;

        // Reflect off Wall with damping
        VNorm = (Velocity dot HitNormal) * HitNormal;
        VNorm = VNorm + VRand() * FRand() * 5000.0; // add random spread
        Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;
        Bounces--;
    }
    else
    {
        bBounce = false;
    }
}

// Modified to check for class 'WaterVolume' (or subclass) as well as bWaterVolume=true (DH_WaterVolume has bWaterVolume=false)
simulated function PhysicsVolumeChange(PhysicsVolume NewVolume)
{
    if (NewVolume.bWaterVolume || NewVolume.IsA('WaterVolume'))
    {
        Velocity *= 0.5;

        if (Level.Netmode != NM_DedicatedServer)
        {
            CheckForSplash(Location);
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
        && !Level.bDropDetail && Level.DetailMode != DM_Low && (SplashEffect != none || WaterHitSound != none))
    {
        PlaySound(WaterHitSound);

        if (SplashEffect != none && EffectIsRelevant(Location, false))
        {
            // Passed SplashLocation is usually some way below the water surface, so the effect doesn't look quite right, especially the water ring not being seen
            // So we'll raise its location - a little hacky, but works pretty well much of the time
            // The adjustment backs up along the projectile's path & is calculated from its pitch angle
            // to give an adjustment of at least 10 units vertically, or more for higher speed projectiles
            Adjustment = FMax(12.0, VSize(Velocity) / 1400.0) / Sin(class'DHLib'.static.UnrealToRadians(-Rotation.Pitch));
            SplashLocation = SplashLocation - (Adjustment * vector(Rotation));

            Spawn(SplashEffect,,, SplashLocation, rot(16384, 0, 0));
        }
    }
}

// New function to update Instigator reference to ensure damage is attributed to correct player, as player may have switched to different pawn since firing, e.g. changed vehicle position
simulated function UpdateInstigator()
{
    if (InstigatorController != none && InstigatorController.Pawn != none)
    {
        Instigator = InstigatorController.Pawn;
    }
}

// Modified to destroy tracer when it falls to ground
simulated function Landed(vector HitNormal)
{
    if (bIsTracerBullet)
    {
        SetPhysics(PHYS_None);
        Destroy();
    }
}

// Modified to destroy any tracer effect
simulated function Destroyed()
{
    if (TracerEffect != none)
    {
        TracerEffect.Destroy();
    }
}

defaultproperties
{
    WhizType=1
    WhizSoundEffect=class'DH_Effects.DHBulletWhiz'
    ImpactEffect=class'DH_Effects.DHBulletHitEffect'
    WaterHitSound=SoundGroup'ProjectileSounds.Bullets.Impact_Water'
    VehiclePenetrateEffectClass=class'ROEffects.ROBulletHitMetalArmorEffect'
    VehiclePenetrateSound=sound'ProjectileSounds.Bullets.Impact_Metal'
    VehiclePenetrateSoundVolume=3.0
    VehicleDeflectEffectClass=class'ROEffects.ROBulletHitMetalArmorEffect'
    VehicleDeflectSound=sound'ProjectileSounds.Bullets.Impact_Metal'
    VehicleDeflectSoundVolume=3.0

    // Tracer properties (won't affect ordinary bullet):
    DrawScale=2.0
    TracerPullback=150.0
    bBounce=true
    Bounces=2
    DampenFactor=0.1
    DampenFactorParallel=0.05
}
