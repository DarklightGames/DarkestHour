//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMortarProjectile extends DHBallisticProjectile
    abstract;

var     vector  HitLocation;
var     vector  HitNormal;

// Chance each shell is a dud & does not explode
var     bool    bDud;
var     float   DudChance;

// Effects for firing mortar & for shell descending just before it lands
var     class<Emitter>  FireEmitterClass;
var     sound   DescendingSound;

// Impact effects & sounds
var     class<Emitter>  HitDirtEmitterClass;
var     class<Emitter>  HitSnowEmitterClass;
var     class<Emitter>  HitWoodEmitterClass;
var     class<Emitter>  HitRockEmitterClass;
var     class<Emitter>  HitWaterEmitterClass;

var     sound   HitDirtSound;
var     sound   HitRockSound;
var     sound   HitWaterSound;
var     sound   HitWoodSound;

// Debug
var     vector  DebugForward;
var     vector  DebugRight;
var     vector  DebugLocation;
var     bool    bDebug;

var     Texture HudTexture;

var     class<DHMapMarker_ArtilleryHit> HitMapMarkerClass;

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        bDud;
}

// Modified to add random chance of shell being a dud, & add a custom debug option
// Not including RO bDebugBallistics stuff from Super as not relevant to mortar (would have to be moved to PostNetBeginPlay anyway as net client won't yet have Instigator)
simulated function PostBeginPlay()
{
    // Relevant stuff from the Super
    OrigLoc = Location;
    BCInverse = 1.0 / BallisticCoefficient;
    Velocity = vector(Rotation) * Speed;

    if (Role == ROLE_Authority)
    {
        if (Instigator != none && Instigator.HeadVolume != none && Instigator.HeadVolume.bWaterVolume)
        {
            Velocity *= 0.5;
        }

        // Random chance of shell being a dud
        if (FRand() < DudChance)
        {
            bDud = true;
        }
    }

    // Mortar shell debug option
    if (bDebug)
    {
        DebugLocation = Location;
        SetTimer(0.25, true);
    }
}

// Modified to play a firing effect, & to set InstigatorController (used to attribute radius damage kills correctly)
simulated function PostNetBeginPlay()
{
    if (Instigator != none)
    {
        InstigatorController = Instigator.Controller;

        if (Level.NetMode != NM_DedicatedServer && FireEmitterClass != none && Location != vect(0.0, 0.0, 0.0))
        {
            SpawnFiringEffect(); // note - can't do an EffectIsRelevant check here, as shell won't yet have been drawn, so will always fail
        }
    }
}

// New function allowing subclasses to handle destruction differently, e.g. smoke shells
simulated function HandleDestruction()
{
    Destroy();
}

// Just a debug option
simulated function Timer()
{
    if (bDebug)
    {
        if (Level.NetMode != NM_DedicatedServer)
        {
            DrawStayingDebugLine(DebugLocation, Location, 255, 0, 0);
        }

        DebugLocation = Location;
    }
}

// Modified to handle new collision mesh actor - if we hit a CM we switch hit actor to CM's owner & proceed as if we'd hit that actor
// Also to do splash effects if projectile hits a fluid surface, which wasn't previously handled
// Also re-factored generally to optimise, but original functionality unchanged
simulated singular function Touch(Actor Other)
{
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
            return; // exit, doing nothing, if col mesh actor is set not to stop a shell (includes mortar shell)
        }

        Other = Other.Owner;
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

// Modified to go into 'Whistle' state upon hitting something, so players always hear the DescendingSound before shell explodes & actor is destroyed
// Also to ignore collision with a player right in front of the mortar
simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    if (Other == Instigator || Other.Base == Instigator || ROBulletWhipAttachment(Other) != none)
    {
        return;
    }

    // This is to prevent jerks from walking in front of the mortar (within approx 2 metres) & blowing us up
    if (DHPawn(Other) != none && VSizeSquared(OrigLoc - HitLocation) < 16384.0)
    {
        return;
    }

    self.HitNormal = Normal(HitLocation - Other.Location);

    GotoState('Whistle');
}

// Modified to go into 'Whistle' state upon hitting something, so players always hear the DescendingSound before shell explodes & actor is destroyed
simulated function HitWall(vector HitNormal, Actor Wall)
{
    self.HitNormal = HitNormal;

    GotoState('Whistle');
}

// New state that is entered when shell lands - it just plays the DescendingSound & sets a timer to make the shell explode at the end of the sound
// Purpose is to make sure players hear DescendingSound before this actor is destroyed, so it delays the explosion slightly after impact to achieve that
simulated state Whistle
{
    simulated function BeginState()
    {
        local float Pitch;

        SetPhysics(PHYS_None);
        Velocity = vect(0.0, 0.0, 0.0);
        SetTimer(FMax(0.1, GetSoundDuration(DescendingSound)), false); // FMax is just a fail-safe in case GetSoundDuration somehow returns zero

        if (Level.NetMode != NM_DedicatedServer)
        {
            GetDescendingSoundPitch(Pitch, Location);
            PlaySound(DescendingSound, SLOT_None, 8.0, false, 512.0, Pitch, true);
        }
    }

    simulated function Timer()
    {
        Explode(Location, HitNormal);
    }
}

// Modified to handle various effects when mortar hits something, & to set hit
// location in team's artillery targets so it's marked on the map for artillery
// crew. Also includes a debug option.
simulated function Explode(vector HitLocation, vector HitNormal)
{
    if (Role == ROLE_Authority)
    {
        MakeNoise(1.0); // shell landing makes noise, even if a dud & doesn't detonate
    }

    SpawnImpactEffects(HitLocation, HitNormal);

    if (!bDud)
    {
        if (Role == ROLE_Authority && HitMapMarkerClass != none)
        {
            SaveHitPosition(HitLocation, HitNormal, HitMapMarkerClass);
        }

        SpawnExplosionEffects(HitLocation, HitNormal);
        BlowUp(HitLocation);
    }

    if (bDebug)
    {
        if (Level.NetMode != NM_DedicatedServer)
        {
            DrawStayingDebugLine(DebugLocation, DebugLocation, 255, 0, 255);
        }

        Log(class'DHUnits'.static.UnrealToMeters(DebugForward dot (HitLocation - OrigLoc)) @ class'DHUnits'.static.UnrealToMeters(DebugRight dot (HitLocation - OrigLoc)));
    }

    HandleDestruction(); // allows subclasses to handle destruction differently rather than always Destroy()
}

// Emptied out so we don't cause blast damage by default (add in subclass if required) & because we call MakeNoise() when shell lands, even if doesn't blow up
function BlowUp(vector HitLocation)
{
}

// New function to spawn impact effects when the shell lands
simulated function SpawnImpactEffects(vector HitLocation, vector HitNormal)
{
    local ESurfaceTypes  HitSurfaceType;
    local class<Emitter> HitEmitterClass;
    local sound          HitSound;

    if (Level.NetMode != NM_DedicatedServer && !(PhysicsVolume != none && PhysicsVolume.bWaterVolume))
    {
        GetHitSurfaceType(HitSurfaceType, HitNormal);
        GetHitSound(HitSound, HitSurfaceType);
        GetHitEmitterClass(HitEmitterClass, HitSurfaceType);

        PlaySound(HitSound, SLOT_None, 4.0 * TransientSoundVolume);
        Spawn(HitEmitterClass,,, HitLocation, rotator(HitNormal));
    }
}

// New function to spawn explosion effects - implement is subclasses as required
simulated function SpawnExplosionEffects(vector HitLocation, vector HitNormal)
{
}

// New function to spawn a firing effect, allowing a net client to calculate correct location for effect, rather than just use projectile's location
// This is because (1) client & server locations of weapon differ, & (2) projectile will have travelled upwards some distance before replicating to client
// Probably not too significant for mortar, but very relevant to smoke launcher subclass as it suffers from server/client location differences, being mobile
simulated function SpawnFiringEffect()
{
    local VehicleWeaponPawn WP;

    WP = VehicleWeaponPawn(Instigator);

    if (WP != none && WP.Gun != none)
    {
        if (Role < ROLE_Authority)
        {
            WP.Gun.CalcWeaponFire(false); // net client calculates & records WeaponFireLocation, as will only have been done on the server (no FlashMuzzleFlash() for mortars)
        }

        Spawn(FireEmitterClass,,, WP.Gun.WeaponFireLocation, Rotation);
    }
}

// Modified to give additional points to the observer & the mortarman for working together for a kill
// Also to handle new collision mesh actor - if we hit a col mesh, we switch hit actor to col mesh's owner & proceed as if we'd hit that actor
// Also to call CheckVehicleOccupantsRadiusDamage() instead of DriverRadiusDamage() on a hit vehicle, to properly handle blast damage to any exposed vehicle occupants
// And to fix problem affecting many vehicles with hull mesh modelled with origin on the ground, where even a slight ground bump could block all blast damage
// Also to update Instigator, so HurtRadius attributes damage to the player's current pawn
function HurtRadius(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
    local Actor         Victim, TraceActor;
    local DHVehicle     V;
    local ROPawn        P;
    local array<ROPawn> CheckedROPawns;
    local bool          bAlreadyChecked, bAlreadyDead;
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

            bAlreadyDead = P.Health <= 0; // added so we don't score points for a artillery observer unless it's a live kill
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
            P.TakeDamage(DamageScale * DamageAmount, InstigatorController.Pawn,
                         P.Location - (0.5 * (P.CollisionHeight + P.CollisionRadius)) * Direction,
                         DamageScale * Momentum * Direction, DamageType);
        }
    }
}

// Implemented so if hits water we play a splash effect (same as a cannon shell) & the projectile explodes
simulated function PhysicsVolumeChange(PhysicsVolume NewVolume)
{
    if (NewVolume != none && NewVolume.bWaterVolume)
    {
        CheckForSplash(Location);
        Explode(Location, vect(0.0, 0.0, 1.0));
    }
}

// Added same as cannon shell to play a water splash effect
simulated function CheckForSplash(vector SplashLocation)
{
    local Actor HitActor;

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
            if (HitWaterSound != none)
            {
                PlaySound(HitWaterSound);
            }

            if (HitWaterEmitterClass != none && EffectIsRelevant(HitLocation, false))
            {
                Spawn(HitWaterEmitterClass,,, HitLocation, rot(16384, 0, 0));
            }
        }
    }
}

// New function to get the surface type the projectile has hit
simulated function GetHitSurfaceType(out ESurfaceTypes HitSurfaceType, vector HitNormal)
{
    local material M;

    Trace(HitLocation, HitNormal, Location - (16.0 * HitNormal), Location, false,, M);

    if (M == none)
    {
        HitSurfaceType = EST_Default;
    }
    else
    {
        HitSurfaceType = ESurfaceTypes(M.SurfaceType);
    }
}

// New function to appropriate emitter class for shell hitting a given surface type
simulated function GetHitEmitterClass(out class<Emitter> HitEmitterClass, ESurfaceTypes SurfaceType)
{
    switch (SurfaceType)
    {
        case EST_Snow:
        case EST_Ice:
            HitEmitterClass = HitSnowEmitterClass;
            return;

        case EST_Water:
            HitEmitterClass = HitWaterEmitterClass;
            return;

        case EST_Wood:
            HitEmitterClass = HitWoodEmitterClass;
            return;

        case EST_Rock:
            HitEmitterClass = HitRockEmitterClass;
            return;

        default:
            HitEmitterClass = HitDirtEmitterClass;
            return;
    }
}

// New function to appropriate impact sound for shell hitting a given surface type
simulated function GetHitSound(out sound HitSound, ESurfaceTypes SurfaceType)
{
    switch (SurfaceType)
    {
        case EST_Rock:
            HitSound = HitRockSound;
            return;

        case EST_Water:
            HitSound = HitWaterSound;
            return;

        case EST_Wood:
            HitSound = HitWoodSound;
            return;

        default:
            HitSound = HitDirtSound;
            return;
    }
}

// New function to adjust pitch of shell's descent sound - rounds far away will seem to drone, while being close to the descent will make the sounds scream
simulated function GetDescendingSoundPitch(out float Pitch, vector SoundLocation)
{
    local Pawn   P;
    local vector CameraLocation;
    local float  ClampedDistance;

    Pitch = 0.875;
    P = Level.GetLocalPlayerController().Pawn;

    if (P != none)
    {
        CameraLocation = P.Location + (P.BaseEyeHeight * vect(0.0, 0.0, 1.0));
        ClampedDistance = Clamp(VSize(SoundLocation - CameraLocation), 0.0, 5249.0);
        Pitch += ((5249.0 - ClampedDistance) / 5249.0) * 0.25;
    }
}

// New function updating Instigator reference to ensure damage is attributed to correct player, as may have switched to different pawn since firing, e.g. undeployed mortar
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

defaultproperties
{
    DudChance=0.01
    bAlwaysRelevant=true // always relevant to every net client, so they hear the whistle sound, & for smoke rounds so the smoke effect always gets spawned
    DrawType=DT_None
    LifeSpan=60.0
    BallisticCoefficient=1.0
    bBlockHitPointTraces=false
    FireEmitterClass=class'DH_Effects.DHMortarFireEffect'
    DescendingSound=Sound'DH_WeaponSounds.Mortars.Descent01'

    HitDirtEmitterClass=class'ROEffects.TankAPHitDirtEffect'
    HitRockEmitterClass=class'ROEffects.TankAPHitRockEffect'
    HitWoodEmitterClass=class'ROEffects.TankAPHitWoodEffect'
    HitSnowEmitterClass=class'ROEffects.TankAPHitSnowEffect'
    HitWaterEmitterClass=class'DH_Effects.DHShellSplashEffect'
    HitDirtSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Dirt'
    HitRockSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Rock'
    HitWoodSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Wood'
    HitWaterSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Water'
}
