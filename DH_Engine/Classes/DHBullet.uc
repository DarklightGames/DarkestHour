//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBullet extends DHBallisticProjectile
    config
    abstract;

// General
var     int             WhizType;               // sent in HitPointTrace to indicate whiz or snap sound to play (0 = none, 1 = close supersonic bullet, 2 = subsonic or distant bullet)
var     Actor           SavedTouchActor;        // added (same as shell) to prevent recurring ProcessTouch on same actor (e.g. was screwing up tracer ricochets from turrets)
var     sound           WaterHitSound;          // sound of this bullet hitting water
var     bool            bHitBulletProofColMesh; // bullet has hit a collision mesh actor that is bullet proof, so we can handle vehicle hits accordingly

// Tracers
var     bool            bIsTracerBullet; // just set to true in a tracer bullet subclass of a normal bullet & then the inheritance from this class will handle everything
var     bool            bHasDeflected;
var     byte            Bounces;
var     StaticMesh      DeflectedMesh;
var     class<Emitter>  TracerEffectClass;
var     Emitter         TracerEffect;
var     float           TracerPullback;
var     int             TracerHue;
var     int             TracerSaturation;
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

// From deprecated ROBullet class:
const       MIN_PENETRATE_VELOCITY = 163;              // minimum bullet speed in Unreal units to damage anything (equivalent to 2.7 m/sec or 8.86 feet/sec)

var         class<DHHitEffect>      ImpactEffect;    // effect to spawn when bullets hits something other than a vehicle (handles sound & visual effect)
var         class<ROBulletWhiz>     WhizSoundEffect; // bullet whip sound effect class
var         class<Actor>            SplashEffect;    // water splash effect class
var         Actor                   WallHitActor;    // internal var used for storing the wall that was hit so the same wall doesn't get hit again

// Modified to move bDebugBallistics stuff to PostNetBeginPlay, as net client won't yet have Instigator here
simulated function PostBeginPlay()
{
    OrigLoc = Location;
    BCInverse = 1.0 / BallisticCoefficient;
    Velocity = vector(Rotation) * Speed;

    if (Role == ROLE_Authority && Instigator != none && Instigator.HeadVolume != none && Instigator.HeadVolume.bWaterVolume)
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
        LightHue = TracerHue;
        LightSaturation = TracerSaturation;
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

// New function, called by DHFastAutoFire's SpawnProjectile function to set this as a server bullet, meaning won't be replicated as a separate client bullet will be spawned on client
// RemoteRole = none was the only change in DH_ServerBullet that had any effect, so simply doing this means server bullet classes can be deprecated
function SetAsServerBullet()
{
    RemoteRole = ROLE_None;
}

// Disabled as function is now emptied out, as don't want delayed destruction stuff from ROBullet - far cleaner just to set short LifeSpan on a server
// And for a tracer bullet, we don't need to keep setting its rotation to match its direction - simply setting bOrientToVelocity handles this natively
simulated function Tick(float DeltaTime)
{
    Disable('Tick');
}

// Modified to handle new collision mesh actor - if we hit a CM we switch hit actor to CM's owner & proceed as if we'd hit that actor
// Also to do splash effects if projectile hits a fluid surface, which wasn't previously handled
// Also re-factored generally to optimise, but original functionality unchanged
simulated singular function Touch(Actor Other)
{
    local vector HitLocation, HitNormal;


    // Added bBlockHitPointTraces check here instead of doing it at the start of ProcessTouch()
    // This is so a collision static mesh gets handled properly in ProcessTouch, as it will have bBlockHitPointTraces=false
    if (Other == none || (!Other.bProjTarget && !Other.bBlockActors) || !Other.bBlockHitPointTraces)
    {
        return;
    }

    // Added splash if projectile hits a fluid surface
    if (FluidSurfaceInfo(Other) != none)
    {
        CheckForSplash(Location);
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
        if (DHCollisionMeshActor(Other).bWontStopBullet)
        {
            return; // exit, doing nothing, if col mesh actor is set not to stop a bullet
        }

        if (DHCollisionMeshActor(Other).bIsBulletProof)
        {
            bHitBulletProofColMesh = true; // if col mesh is bullet proof then set a flag so we can handle vehicle hits accordingly
        }

        Other = Other.Owner; // switch hit actor

        // If col mesh represents a vehicle, which would normally get a HitWall() event instead of Touch, then call HitWall on the vehicle & exit
        // First match projectile's location to our more accurate HitLocation, as we can't pass HitLocation to HitWall & it will use current location
        if (ROVehicle(Other) != none)
        {
            SetLocation(HitLocation);
            HitWall(HitNormal, Other);
            bHitBulletProofColMesh = false; // guarantees reset

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

    bHitBulletProofColMesh = false; // guarantees reset
}

// Modified to handle tracer bullet clientside effects, as well as normal bullet functionality, plus handling of hit on a vehicle weapon similar to a shell
simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    local DHPawn       HitPlayer, WhizzedPlayer;
    local Pawn         InstigatorPlayer;
    local Actor        A;
    local array<Actor> SavedHitActors;
    local vector       Direction, PawnHitLocation, TempHitLocation, HitNormal;
    local float        V;
    local array<int>   HitPoints;
    local int          TraceWhizType, i;

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

    Direction = Normal(Velocity);

    // Bullet never penetrates a vehicle weapon, so we just play hit effect & exit the function, destroying bullet unless it's a tracer deflection
    if (Other.IsA('VehicleWeapon'))
    {
        PlayVehicleHitEffects(false, HitLocation, -Direction);

        // Tracer deflects unless bullet speed is very low (approx 12 m/s)
        // Added the trace to get a HitNormal, so ricochet is at correct angle (from shell's DeflectWithoutNormal function)
        if (Level.NetMode != NM_DedicatedServer && bIsTracerBullet && VSizeSquared(Velocity) > 500000.0)
        {
            Trace(HitLocation, HitNormal, HitLocation + (Direction * 50.0), HitLocation - (Direction * 50.0), true);
            Deflect(HitNormal);
        }
        else
        {
            Destroy();
        }

        return;
    }

    // Get the bullet's speed
    if (!bHasDeflected)
    {
        V = VSize(Velocity);

        // If bullet collides right after launch it won't have any velocity yet, so give it the default speed & use its rotation to get a Direction
        if (V < 25.0)
        {
            V = default.Speed;
            Direction = vector(Rotation);
        }
    }

    // Hit bullet whip attachment around player, which isn't itself a valid hit actor, but now need to Trace to see if bullet actually hits one of player's various body hit points
    // We also need to handle whiz effects for the player
    if (ROBulletWhipAttachment(Other) != none)
    {
        WhizzedPlayer = DHPawn(Other.Base);

        if (WhizzedPlayer == none || WhizzedPlayer.bDeleteMe || InstigatorPlayer == none)
        {
            return;
        }

        // Player needs to be whizzed, so determine WhizType to use in HitPointTrace
        // If player doesn't need whiz & we don't set TraceWhizType here, default WhizType 0 will mean native code won't calculate WhizLocation or trigger PawnWhizzed
        if (!bHasDeflected && WhizzedPlayer.ShouldBeWhizzed())
        {
            TraceWhizType = default.WhizType; // start with default WhizType for our projectile (1 is supersonic 'snap', 2 is subsonic whiz)
            class'DHBullet'.static.GetWhizType(TraceWhizType, WhizzedPlayer, Instigator, OrigLoc);
        }

        // Trace to see if bullet path will actually hit one of the player pawn's various body hit points
        // Use the InstigatorPlayer to do the trace, as that makes HitPointTrace work better because it ignores the InstigatorPlayer & its own bullet whip attachment
        // Temporarily make InstigatorPlayer use same bUseCollisionStaticMesh setting as projectile (normally means switching to true), meaning trace uses col meshes on vehicles
        InstigatorPlayer.bUseCollisionStaticMesh = bUseCollisionStaticMesh;

        // Maximum of 3 traces - but we only ever repeat trace if hit an invalid col mesh or destro mesh, which is very rare, so nearly always only 1 trace will be done
        for (i = 0; i < 3; ++i)
        {
            // HitPointTraces don't work well with short traces, so we have to do long trace first, then if we hit player we check whether he was within the whip attachment
            A = InstigatorPlayer.HitPointTrace(TempHitLocation, HitNormal, HitLocation + (Direction * 65535.0), HitPoints, HitLocation,, TraceWhizType);

            // We're primarily interested if we hit a player, but also need to check if hit invalid col mesh or destro mesh that doesn't stop bullet (as would need to repeat trace)
            if (DHPawn(A) != none || (DHCollisionMeshActor(A) != none && DHCollisionMeshActor(A).bWontStopBullet)
                || (RODestroyableStaticMesh(A) != none && RODestroyableStaticMesh(A).bWontStopBullets))
            {
                // Only count hit if traced actor is within extent of bullet whip (we had to do an artificially long HitPointTrace, so may have traced something far away)
                if (VSizeSquared(TempHitLocation - HitLocation) <= 180000.0) // 180k is square of max distance across whip 'diagonally'
                {
                    // We hit a player, so record it - but we need to do a verification trace to make sure there's no blocking actor in front of player
                    if (DHPawn(A) != none)
                    {
                        HitPlayer = DHPawn(A);
                        PawnHitLocation = TempHitLocation;
                    }
                    // Otherwise, must have hit a special collision or destroyable mesh that doesn't stop bullets, so we temporarily disable its collision & re-run the trace
                    // Matt: this is a hack, but I can't think of another solution - the disabled collision is only for a split second & it seems harmless & effective
                    else
                    {
                        TraceWhizType = 0; // if the player needs whizzing, the 1st HitPointTrace will have done it, so set to 0 to avoid repeat whizzes
                        SavedHitActors[SavedHitActors.Length] = A; // save reference to mesh so we can re-enable its collision after tracing
                        A.SetCollision(false, A.bBlockActors);
                        continue; // re-run the trace
                    }
                }
            }

            break; // generally we're going to exit the for loop after the 1st pass, except in the rare event where we hit an invalid col mesh or destro mesh
        }

        // HitPointTrace says we hit a player, but we need to verify that as HitPointTrace is unreliable & often passes through a blocking vehicle, hitting a shielded player
        if (HitPlayer != none)
        {
            // Trace along path from where we hit player's whip attachment to where we traced a hit on player, checking if any blocking actor is in the way
            foreach InstigatorPlayer.TraceActors(class'Actor', A, TempHitLocation, HitNormal, PawnHitLocation, HitLocation)
            {
                // We hit a blocking actor, so now check if it's a valid 'stopper' (something that would trigger HitWall or ProcessTouch)
                if (A.bWorldGeometry || A.Physics == PHYS_Karma || (A.bBlockActors && A.bBlockHitPointTraces))
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
                    // If hit destro mesh that won't stop a bullet (e.g. glass), we record it for possible later damage, but ignore it & continue the trace iteration
                    else if (RODestroyableStaticMesh(A) != none && RODestroyableStaticMesh(A).bWontStopBullets)
                    {
                        SavedHitActors[SavedHitActors.Length] = A;
                        continue;
                    }

                    // A blocking actor is in the way, so we didn't really hit the player (but ignore anything ProcessTouch would normally ignore)
                    if (A != InstigatorPlayer && A.Base != InstigatorPlayer && A.Owner != InstigatorPlayer && A.Owner != Instigator
                        && !A.bDeleteMe && !(A.IsA('Projectile') && !A.bProjTarget) && A != HitPlayer)
                    {
                        HitPlayer = none;
                        break;
                    }
                }
            }
        }

        // We've finished tracing, so reset any temporarily changed collision properties on InstigatorPlayer or collision/destroyable meshes
        InstigatorPlayer.bUseCollisionStaticMesh = InstigatorPlayer.default.bUseCollisionStaticMesh;

        for (i = SavedHitActors.Length - 1; i >= 0; --i)
        {
            if (SavedHitActors[i] != none)
            {
                SavedHitActors[i].SetCollision(true, SavedHitActors[i].bBlockActors);

                if (!SavedHitActors[i].IsA('RODestroyableStaticMesh'))
                {
                    SavedHitActors.Remove(i, 1); // remove col meshes from array, so we only leave any destro mesh that we may want to damage later
                }
            }
        }

        // Bullet won't hit the player, so we'll exit now
        if (HitPlayer == none)
        {
            return;
        }
    }

    // Do any damage
    if (!bHasDeflected && Role == ROLE_Authority && V > (MIN_PENETRATE_VELOCITY * ScaleFactor))
    {
        UpdateInstigator();

        // Damage a player pawn
        if (HitPlayer != none)
        {
            if (!HitPlayer.bDeleteMe)
            {
                HitPlayer.ProcessLocationalDamage(Damage - 20.0 * (1.0 - V / default.Speed), Instigator, PawnHitLocation, MomentumTransfer * Direction, MyDamageType, HitPoints);
            }

            // If traced hit on destro mesh that won't stop bullet (e.g. glass) in front of player, need to damage it now as we're destroying bullet & it won't collide with destro mesh
            for (i = 0; i < SavedHitActors.Length; ++i)
            {
                if (RODestroyableStaticMesh(SavedHitActors[i]) != none)
                {
                    SavedHitActors[i].TakeDamage(Damage - 20.0 * (1.0 - V / default.Speed), Instigator, SavedHitActors[i].Location, MomentumTransfer * Direction, MyDamageType);
                }
            }
        }
        // Damage something else
        else
        {
            Other.TakeDamage(Damage - 20.0 * (1.0 - V / default.Speed), Instigator, HitLocation, MomentumTransfer * Direction, MyDamageType);
        }
    }

    // The only way a tracer will deflect is off a vehicle weapon, which is handled above & results in exiting function early, so we can always destroy the bullet here
    Destroy();
}

// Modified to remove delayed destruction of bullet on a server, as serves no purpose for a bullet
// Bullet is bNetTemporary, meaning it gets torn off on client as soon as it replicates, receiving no further input from server, so delaying destruction on server has no effect
// Also to handle tracer bullet clientside effects, as well as normal bullet functionality
// Note this gets called when bullet collides with an ROVehicle (not a VehicleWeapon), as well as world geometry
simulated function HitWall(vector HitNormal, Actor Wall)
{
    local ROVehicle        HitVehicle;
    local DHArmoredVehicle AV;
    local bool             bPenetratedVehicle;

    // Hit WallHitActor that we've already hit & recorded
    if (WallHitActor == Wall && WallHitActor != none)
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

    WallHitActor = Wall; // record hit actor to prevent recurring hits
    HitVehicle = ROVehicle(Wall);

    // Handle hit on a vehicle
    if (HitVehicle != none)
    {
        if (!bHasDeflected)
        {
            AV = DHArmoredVehicle(HitVehicle);
            bPenetratedVehicle = AV == none && !HitVehicle.bIsApc && !bHitBulletProofColMesh;
        }

        PlayVehicleHitEffects(bPenetratedVehicle, Location, HitNormal);
    }
    // Spawn the bullet hit effect on anything other than a vehicle
    else if (Level.NetMode != NM_DedicatedServer && ImpactEffect != none)
    {
        Spawn(ImpactEffect, self,, Location, rotator(-HitNormal)); // made bullet the owner of the effect, so effect can use bullet to do an EffectIsRelevant() check
    }

    if (!bHasDeflected)
    {
        // Do any damage
        if (Role == ROLE_Authority)
        {
            // Skip calling TakeDamage if we hit a vehicle but failed to penetrate - except check for possible hit on any exposed gunsight optics // TODO: resolve this more tidily (also AP bullet)
            if (HitVehicle != none && !bPenetratedVehicle)
            {
                // Hit exposed gunsight optics
                if (AV != none && AV.GunOpticsHitPointIndex >= 0 && AV.GunOpticsHitPointIndex < AV.NewVehHitpoints.Length
                    && AV.NewVehHitpoints[AV.GunOpticsHitPointIndex].NewHitPointType == NHP_GunOptics
                    && AV.IsNewPointShot(Location, MomentumTransfer * Normal(Velocity), AV.GunOpticsHitPointIndex)
                    && AV.Cannon != none && DHVehicleCannonPawn(AV.Cannon.WeaponPawn) != none)
                {
                    DHVehicleCannonPawn(AV.Cannon.WeaponPawn).DamageCannonOverlay();

                    if (AV.bLogDebugPenetration)
                    {
                        Log("We hit NHP_GunOptics hitpoint");
                    }

                    if (AV.bDebuggingText)
                    {
                        Level.Game.Broadcast(self, "Hit gunsight optics");
                    }
                }
                // This allows VehicleMG bullets to damage wheels of APCs
                else if (DHVehicle(HitVehicle) != none && DHVehicle(HitVehicle).bIsAPC && DHVehicle(HitVehicle).HasDamageableWheels())
                {
                    UpdateInstigator();
                    Wall.TakeDamage(Damage - (20.0 * (1.0 - (VSize(Velocity) / default.Speed))), Instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
                }
            }
            else if (Wall.bCanBeDamaged)
            {
                UpdateInstigator();
                Wall.TakeDamage(Damage - (20.0 * (1.0 - (VSize(Velocity) / default.Speed))), Instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
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

    // Removed the section that used to "Give the bullet a little time to play the hit effect client side before destroying the bullet" (see notes at top of function)

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

// New function to handle hit effects for bullet hitting vehicle or vehicle weapon, depending on whether it penetrated (saves code repetition elsewhere)
simulated function PlayVehicleHitEffects(bool bPenetrated, vector HitLocation, vector HitNormal)
{
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (bPenetrated)
        {
            PlaySound(VehiclePenetrateSound, SLOT_None, VehiclePenetrateSoundVolume, false, 100.0);

            if (EffectIsRelevant(HitLocation, false) && VehiclePenetrateEffectClass != none)
            {
                Spawn(VehiclePenetrateEffectClass,,, HitLocation, rotator(-HitNormal));
            }
        }
        else
        {
            PlaySound(VehicleDeflectSound, SLOT_None, VehicleDeflectSoundVolume, false, 100.0);

            if (EffectIsRelevant(HitLocation, false) && VehicleDeflectEffectClass != none)
            {
                Spawn(VehicleDeflectEffectClass,,, HitLocation, rotator(-HitNormal));
            }
        }
    }
}

// New helper function, just to improve readability & to avoid repeating functionality in other classes (e.g. bullet's pre-launch trace)
simulated static function GetWhizType(out int TraceWhizType, DHPawn WhizzedPlayer, Pawn Instigator, vector LaunchLocation)
{
    local bool  bFriendlyFire;
    local float BulletDistance;

    bFriendlyFire = Instigator != none && WhizzedPlayer != none && Instigator.GetTeamNum() == WhizzedPlayer.GetTeamNum()
        && WhizzedPlayer.PlayerReplicationInfo != none && !WhizzedPlayer.PlayerReplicationInfo.bBot;

    // We only need to calculate distance travelled by bullet if it's friendly fire or the passed default WhizType is a supersonic 'snap'
    if (bFriendlyFire || TraceWhizType == 1)
    {
        // If bullet collides immediately after launch, it has no location (or so it would appear, go figure) - let's check against the firer's location instead
        if (LaunchLocation == vect(0.0, 0.0, 0.0) && Instigator != none)
        {
            LaunchLocation = Instigator.Location;
        }

        BulletDistance = class'DHUnits'.static.UnrealToMeters(VSize(WhizzedPlayer.Location - LaunchLocation)); // in metres

        // If it's friendly fire at close range, we won't suppress, so send a different TraceWhizType in the HitPointTrace
        if (bFriendlyFire && BulletDistance < 10.0)
        {
            TraceWhizType = 3;
        }
        // Bullets only "snap" after a certain distance in reality, same goes here
        else if (TraceWhizType == 1 && BulletDistance < 20.0)
        {
            TraceWhizType = 2;
        }
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

// New function to handle tracer deflection off things
simulated function Deflect(vector HitNormal)
{
    local vector VNorm;

    bHasDeflected = true;

    if (TracerEffect != none && VSizeSquared(Velocity) < 750000.0) //14.4 m/s
    {
        TracerEffect.Destroy();
    }

    if (StaticMesh != DeflectedMesh) //swaps to ball mesh from streak mesh, but still has trail until below 14.4 m/s
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
        VNorm = VNorm + VRand() * FRand() * 10000.0; // add random spread 5000.0
        Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;
        Bounces--;
    }
    else
    {
        bBounce = false;
    }
}

// Implemented so if bullet hits a water volume, its speed is reduced & it does a water splash
simulated function PhysicsVolumeChange(PhysicsVolume NewVolume)
{
    if (NewVolume != none && NewVolume.bWaterVolume)
    {
        Velocity *= 0.1;
        CheckForSplash(Location);
    }
}

// Modified to add water splash sound, & to add an EffectIsRelevant check before spawning visual splash effect
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
        // Note this seems unnecessary, as we must have hit a water volume, as this is only called by PhysicsVolumeChange() when projectile enters a water volume
        // But the trace gives a more accurate location to spawn the splash effect, which makes a significant difference, so it's worth doing
        if ((PhysicsVolume(HitActor) != none && PhysicsVolume(HitActor).bWaterVolume) || FluidSurfaceInfo(HitActor) != none)
        {
            if (WaterHitSound != none)
            {
                PlaySound(WaterHitSound);
            }

            if (SplashEffect != none && EffectIsRelevant(HitLocation, false))
            {
                Spawn(SplashEffect,,, HitLocation, rot(16384, 0, 0));
            }
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
    VehiclePenetrateEffectClass=class'DH_Effects.DHBulletHitMetalArmorEffect'
    VehiclePenetrateSound=Sound'ProjectileSounds.Bullets.Impact_Metal'
    VehiclePenetrateSoundVolume=3.0
    VehicleDeflectEffectClass=class'DH_Effects.DHBulletHitMetalEffect'
    VehicleDeflectSound=Sound'ProjectileSounds.Bullets.Impact_Metal'
    VehicleDeflectSoundVolume=3.0

    // Tracer properties (won't affect ordinary bullet):
    DrawScale=2.0
    TracerPullback=150.0//150.0
    bBounce=true
    Bounces=1 //2
    TracerHue=45
    TracerSaturation=128
    DampenFactor=0.05//0.1
    DampenFactorParallel=0.10//0.05

    // From deprecated ROBullet class:
    bUseCollisionStaticMesh=true
    DrawType=DT_None
    LifeSpan=5.0
    MaxSpeed=100000.0
    MomentumTransfer=100.0
    TossZ=0.0
    SplashEffect=class'DH_Effects.DHBulletHitWaterEffect'
}
