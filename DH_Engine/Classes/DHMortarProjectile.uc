//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMortarProjectile extends DHBallisticProjectile
    abstract;

var     Vector  HitLocation;
var     Vector  HitNormal;

// Chance each shell is a dud & does not explode
var     bool    bDud;
var     float   DudChance;

// Effects for firing mortar & for shell descending just before it lands
var     class<Emitter>  FireEmitterClass;
var     sound   DescendingSound;

// Impact effects & sounds for a dud round
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
var     Vector  DebugForward;
var     Vector  DebugRight;
var     Vector  DebugLocation;
var     bool    bDebug;

var     Texture HudTexture;

var     class<DHMapMarker_ArtilleryHit> HitMapMarkerClass;

var     bool   bHitWater;

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
    Velocity = Vector(Rotation) * Speed;

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
    if (Other == none || (!Other.bProjTarget && !Other.bBlockActors) && !Other.IsA('FluidSurfaceInfo'))
    {
        return;
    }

    if (Other.IsA('FluidSurfaceInfo'))
    {
        bHitWater = true;
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
simulated function ProcessTouch(Actor Other, Vector HitLocation)
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

    MortarExplode();
}

simulated function MortarExplode()
{
    if (Velocity.Z < 0)
    {
        // If the mortar is descending, go to the whistle state.
        GotoState('Whistle');
    }
    else
    {
        // Otherwise, explode immediately.
        Explode(Location, HitNormal);
    }
}

// Modified to go into 'Whistle' state upon hitting something, so players always hear the DescendingSound before shell explodes & actor is destroyed
simulated function HitWall(Vector HitNormal, Actor Wall)
{
    self.HitNormal = HitNormal;

    MortarExplode();
}

// New state that is entered when shell lands - it just plays the DescendingSound & sets a timer to make the shell explode at the end of the sound
// Purpose is to make sure players hear DescendingSound before this actor is destroyed, so it delays the explosion slightly after impact to achieve that
simulated state Whistle
{
    simulated function BeginState()
    {
        local float Pitch, Volume;

        SetPhysics(PHYS_None);
        Velocity = vect(0.0, 0.0, 0.0);

        SetTimer(FMax(0.1, GetSoundDuration(DescendingSound)), false); // FMax is just a fail-safe in case GetSoundDuration somehow returns zero

        if (Level.NetMode != NM_DedicatedServer)
        {
            GetDescendingSoundPitchAndVolume(Pitch, Volume);
            PlaySound(DescendingSound, SLOT_None, Volume, false, 512.0, Pitch, true);
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
simulated function Explode(Vector HitLocation, Vector HitNormal)
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
function BlowUp(Vector HitLocation)
{
    // TODO: add the calibration code back in here.
    super.BlowUp(HitLocation);
}

// New function to spawn impact effects when the shell lands
simulated function SpawnImpactEffects(Vector HitLocation, Vector HitNormal)
{
    local ESurfaceTypes  HitSurfaceType;
    local class<Emitter> HitEmitterClass;
    local sound          HitSound;

    if (Level.NetMode != NM_DedicatedServer)
    {
        GetHitSurfaceType(HitSurfaceType, HitNormal);

        GetHitSound(HitSound, HitSurfaceType);
        GetHitEmitterClass(HitEmitterClass, HitSurfaceType);

        PlaySound(HitSound, SLOT_None, 4.0 * TransientSoundVolume);
        Spawn(HitEmitterClass,,, HitLocation, Rotator(HitNormal));
    }
}

// New function to spawn explosion effects - implement is subclasses as required
simulated function SpawnExplosionEffects(Vector HitLocation, Vector HitNormal)
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
function HurtRadius(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HitLocation)
{
    local Actor         Victim, TraceActor;
    local DHVehicle     V;
    local DHConstruction C;
    local ROPawn        P;
    local array<ROPawn> CheckedROPawns;
    local bool          bAlreadyChecked, bAlreadyDead;
    local Vector        VictimLocation, Direction, TraceHitLocation, TraceHitNormal;
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

        // Before tracing the victim, we must adjust its location for certain types of actors
        // Tracing to origin can be unreliable as it's usually located at the bottom and can sink under the terrain, blocking the blast damage
        C = DHConstruction(Victim);

        if (C != none)
        {
            VictimLocation = C.GetExplosiveDamageTraceLocation();
        }
        else
        {
            VictimLocation = Victim.Location;

            V = DHVehicle(Victim);

            if (V != none && V.Cannon != none && V.Cannon.AttachmentBone != '')
            {
                // Raise the trace location to the cannon bone height
                VictimLocation.Z = V.GetBoneCoords(V.Cannon.AttachmentBone).Origin.Z;
            }
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
function CheckVehicleOccupantsRadiusDamage(ROVehicle V, float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HitLocation)
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
function VehicleOccupantRadiusDamage(Pawn P, float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HitLocation)
{
    local Actor  TraceHitActor;
    local Coords HeadBoneCoords;
    local Vector HeadLocation, TraceHitLocation, TraceHitNormal, Direction;
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
        bHitWater = true;
        MortarExplode();
    }
}

// New function to get the surface type the projectile has hit
simulated function GetHitSurfaceType(out ESurfaceTypes HitSurfaceType, Vector HitNormal)
{
    local Material M;

    if (bHitWater)
    {
        HitSurfaceType = EST_Water;
        return;
    }

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

// Gets the pitch and volume of shell's descent sound.
// Rounds far away will seem to drone, while being close to the descent will make the sounds scream.
// When you're immediately under the shell, there is actually no sound at all, so fade out the sound the closer we are.
simulated function GetDescendingSoundPitchAndVolume(out float Pitch, out float Volume)
{
    local float Distance;

    const PITCH_DISTANCE_METERS_MIN = 10;
    const PITCH_DISTANCE_METERS_MAX = 50;
    const PITCH_MIN = 0.875;
    const PITCH_MAX = 1.125;
    const VOLUME_DISTANCE_METERS_MIN = 10;
    const VOLUME_DISTANCE_METERS_MAX = 20;
    const VOLUME_MIN = 0.0;
    const VOLUME_MAX = 1.0;

    Distance = class'DHUnits'.static.UnrealToMeters(VSize(Location - Level.GetLocalPlayerController().CalcViewLocation));
    
    Pitch = class'UInterp'.static.MapRangeClamped(
        Distance,
        PITCH_DISTANCE_METERS_MIN,
        PITCH_DISTANCE_METERS_MAX,
        PITCH_MAX,
        PITCH_MIN
    );
    Volume = class'UInterp'.static.MapRangeClamped(
        Distance,
        VOLUME_DISTANCE_METERS_MIN,
        VOLUME_DISTANCE_METERS_MAX,
        VOLUME_MIN,
        VOLUME_MAX
    );
}

// New function updating Instigator reference to ensure damage is attributed to correct player, as may have switched to different pawn since firing, e.g. undeployed mortar
simulated function UpdateInstigator()
{
    if (InstigatorController != none && InstigatorController.Pawn != none)
    {
        Instigator = InstigatorController.Pawn;
    }
}

simulated function bool EffectIsRelevant(Vector SpawnLocation, bool bForceDedicated)
{
    // More effects should always be relevant as they are large and long-lasting.
    return true;
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
    DescendingSound=SoundGroup'DH_MortarSounds.81mm_mortar_whistle'

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
