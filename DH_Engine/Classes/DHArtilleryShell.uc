//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHArtilleryShell extends DHProjectile;

// All variables from deprecated ROArtilleryShell:
// (less those deprecated or unused)
var     byte                CloseSoundIndex;            // replaces SavedCloseSound as now only the server selects random CloseSound & replicates it to net clients
var     bool                bAlreadyDroppedProjectile;  // renamed from bDroppedProjectileFirst
var     bool                bAlreadyPlayedCloseSound;   // renamed from bAlreadyPlayedFarSound (was incorrect name)
var     AvoidMarker         Fear;                       // scare the bots away from this

// Sounds & explosion effects
var     sound               DistantSound;               // sound of the artillery distant overhead (no longer an array as there's only 1 sound)
var     sound               CloseSound[3];              // sound of the artillery whooshing in close (array size reduced from 4 as there are only 3 sounds)
var     sound               ExplosionSound[4];          // sound of the artillery exploding
var     class<Emitter>      ShellHitDirtEffectClass;    // artillery hitting dirt emitter
var     class<Emitter>      ShellHitSnowEffectClass;    // artillery hitting snow emitter
var     class<Emitter>      ShellHitDirtEffectLowClass; // artillery hitting dirt emitter low settings
var     class<Emitter>      ShellHitSnowEffectLowClass; // artillery hitting snow emitter low settings

// Camera shake & blur
var     vector              ShakeRotMag;                // how far to rot view
var     vector              ShakeRotRate;               // how fast to rot view
var     float               ShakeRotTime;               // how much time to rotate the player's view
var     vector              ShakeOffsetMag;             // max view offset vertically
var     vector              ShakeOffsetRate;            // how fast to offset view vertically
var     float               ShakeOffsetTime;            // how much time to offset view
var     float               BlurTime;                   // how long blur effect should last for this shell
var     float               BlurEffectScalar;

replication
{
    // Variables the server will replicate to clients when this actor is 1st replicated
    reliable if (bNetInitial && bNetDirty && Role == ROLE_Authority)
        CloseSoundIndex;
}

// Modified from deprecated ROArtilleryShell class so server selects a random CloseSound & replicates the index no. to net clients so their timing is in sync
// Also omits selection of random distant sound as there's only 1 sound
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        CloseSoundIndex = Rand(arraycount(CloseSound));
    }

    PlaySound(DistantSound,, 2.0,, 50000.0); // volume reduced to 2 as that's the biggest multiplier on any transient sound (same with other sounds)
    SetTimer(GetSoundDuration(DistantSound) * 0.95, false);
}

// From deprecated ROArtilleryShell class
simulated function Destroyed()
{
    super.Destroyed();

    if (Fear != none)
    {
        Fear.Destroy();
    }
}

// Based on deprecated ROArtilleryShell class, but with functionality moved into called functions
simulated function Timer()
{
    // On 1st Timer call, set up the timing of the strike so the shell will land just as the close sound finishes playing
    if (!bAlreadyPlayedCloseSound && !bAlreadyDroppedProjectile)
    {
        SetUpStrike();
    }
    // Or if we've already played the CloseSound, now drop the projectile
    else if (bAlreadyPlayedCloseSound)
    {
        DropProjectile();
    }
    // Or if we've already dropped the projectile, now play the CloseSound
    else if (bAlreadyDroppedProjectile)
    {
        PlayCloseSound();
    }
}

// Modified from deprecated ROArtilleryShell class (renamed from SetupStrikeFX) so we no longer select a random CloseSound here
// That is crucial as now only the server selects a random CloseSound & replicates it to net clients as CloseSoundIndex, so their timing is in sync with the server
// And the server has to do that earlier so it replicates the index to net clients when this actor is replicated to them, so it now happens in PostBeginPlay()
// Also moved some functionality from Timer() here so we don't need to save DistanceToTarget as an instance variable
simulated function SetUpStrike()
{
    local vector ImpactLocation, HitNormal;
    local float  FlightTimeToTarget, CloseSoundDuration, NextTimerDuration;

    // First do a trace downwards to get the expected impact location
    if (Trace(ImpactLocation, HitNormal, Location + (50000.0 * Normal(PhysicsVolume.Gravity)), Location, true) != none)
    {
        // We need to time things so the shell lands just as the close sound finishes playing
        // So calculate how long the shell will be in flight to reach the impact location & get duration of selected close sound
        FlightTimeToTarget = VSize(Location - ImpactLocation) / Speed;
        CloseSoundDuration = GetSoundDuration(CloseSound[CloseSoundIndex]);

        // So the timing depends on which is longer: the shell's flight time or the duration of the randomly selected close sound
        // If CloseSound is longer than flight time, play CloseSound now & set a timer to delay dropping the projectile (while part of CloseSound plays)
        if (CloseSoundDuration > FlightTimeToTarget)
        {
            PlayCloseSound();
            NextTimerDuration = CloseSoundDuration - FlightTimeToTarget;
        }
        // Or if flight time is longer than CloseSound, drop the projectile now & set a timer to delay playing CloseSound
        else
        {
            DropProjectile();
            NextTimerDuration = FlightTimeToTarget - CloseSoundDuration;
        }

        SetTimer(NextTimerDuration, false);

        // Scare bots away from the impact location
        if (Role == ROLE_Authority)
        {
            Fear = Spawn(class'AvoidMarker',,, ImpactLocation);
            Fear.SetCollisionSize(DamageRadius, 200.0);
            Fear.StartleBots();
        }
    }
    else
    {
        Log("Artillery shell set up error - downward trace failed to hit anything so we have no impact location - destroying shell actor!!!");
        Destroy();
    }
}

// New function to make the projectile visible & start it falling
simulated function DropProjectile()
{
    if (Level.NetMode != NM_DedicatedServer)
    {
        SetDrawType(DT_StaticMesh);
    }

    Velocity = Normal(PhysicsVolume.Gravity) * Speed;
    bAlreadyDroppedProjectile = true;
}

// Based on DoTraceFX() function from deprecated ROArtilleryShell, but also deprecating use of spawned SoundActor (& FinalHitLocation) to play close sound
// Think the problem was close sound was playing with bNoOverride option, which was often stopping the slightly overlapping explosion sound from playing
simulated function PlayCloseSound()
{
    PlaySound(CloseSound[CloseSoundIndex],, 10.0,, 5248.0);
    bAlreadyPlayedCloseSound = true;
}

// Modified to handle new collision mesh actor - if we hit a CM we switch hit actor to CM's owner & proceed as if we'd hit that actor
// Also re-factored generally to optimise, but original functionality unchanged
simulated singular function Touch(Actor Other)
{
    local vector HitLocation, HitNormal;

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

// Modified from deprecated ROArtilleryShell class to remove check that hit actor is not our Instigator
// That is irrelevant as Instigator is the pawn of player who called the arty & if we hit him then we should explode same as anything else
simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
    Explode(HitLocation, -Normal(Velocity));
}

// From deprecated ROArtilleryShell class, but calling Explode() directly instead of calling Landed(), which just calls Explode() anyway
simulated function HitWall(vector HitNormal, Actor Wall)
{
    Explode(Location, HitNormal);
}

// From deprecated ROArtilleryShell class
simulated function Landed(vector HitNormal)
{
    Explode(Location, HitNormal);
}

// Modified to to call SpawnExplosionEffects() from a single, logical place, but with explosion radius damage moved to BlowUp()
simulated function Explode(vector HitLocation, vector HitNormal)
{
    BlowUp(HitLocation);
    SpawnExplosionEffects(Location, HitNormal);
    Destroy();
}

// Containing explosion radius damage from deprecated ROArtilleryShell class (moved here from Explode)
function BlowUp(vector HitLocation)
{
    if (Role == ROLE_Authority)
    {
        DelayedHurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
    }
}

// From deprecated ROArtilleryShell class (renamed from SpawnEffects), with functionality to toss ragdolls moved here from Destroyed()
simulated function SpawnExplosionEffects(vector HitLocation, vector HitNormal)
{
    local ROPawn        Victims;
    local ESurfaceTypes ST;
    local material      HitMaterial;
    local vector        TraceHitLocation, TraceHitNormal, Direction, Start;
    local float         DamageScale, Distance;

    if (Level.NetMode == NM_DedicatedServer)
    {
        return;
    }

    PlaySound(ExplosionSound[Rand(4)],, 6.0 * TransientSoundVolume,, 25000.0);

    DoShakeEffect();

    if (EffectIsRelevant(HitLocation, false))
    {
        Trace(TraceHitLocation, TraceHitNormal, Location + (16.0 * vector(Rotation)), Location, false,, HitMaterial);

        if (HitMaterial != none)
        {
            ST = ESurfaceTypes(HitMaterial.SurfaceType);
        }
        else
        {
            ST = EST_Default;
        }

        Spawn(class'RORocketExplosion',,, HitLocation + (16.0 * HitNormal), rotator(HitNormal));

        if (ST == EST_Snow || ST == EST_Ice)
        {
            if (Level.bDropDetail || Level.DetailMode == DM_Low)
            {
                Spawn(ShellHitSnowEffectLowClass,,, HitLocation, rotator(HitNormal));
            }
            else
            {
                Spawn(ShellHitSnowEffectClass,,, HitLocation, rotator(HitNormal));
            }

            Spawn(ExplosionDecalSnow, self,, HitLocation, rotator(-HitNormal));
        }
        else
        {
            if (Level.bDropDetail || Level.DetailMode == DM_Low)
            {
                Spawn(ShellHitDirtEffectLowClass,,, HitLocation, rotator(HitNormal));
            }
            else
            {
                Spawn(ShellHitDirtEffectClass,,, HitLocation, rotator(HitNormal));
            }

            Spawn(ExplosionDecal, self,, HitLocation, rotator(-HitNormal));
        }
    }

    // Move karma ragdolls around when this explodes
    Start = Location + vect(0.0, 0.0, 32.0);

    foreach VisibleCollidingActors(class'ROPawn', Victims, DamageRadius, Start)
    {
        if (Victims != self && Victims.Physics == PHYS_KarmaRagDoll)
        {
            Direction = Victims.Location - Start;
            Distance = FMax(1.0, VSize(Direction));
            Direction = Direction / Distance;
            DamageScale = 1.0 - FMax(0.0, (Distance - Victims.CollisionRadius) / DamageRadius);
            Victims.DeadExplosionKarma(MyDamageType, DamageScale * MomentumTransfer * Direction, DamageScale);
        }
    }
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

// From deprecated ROArtilleryShell class (slightly re-factored to optimise & make clearer)
simulated function DoShakeEffect()
{
    local PlayerController PC;
    local float            Distance, MaxShakeDistance, Scale, BlastShielding;

    PC = Level.GetLocalPlayerController();

    if (PC != none && PC.ViewTarget != none)
    {
        Distance = VSize(Location - PC.ViewTarget.Location);
        MaxShakeDistance = DamageRadius * 3.0;

        if (Distance < MaxShakeDistance)
        {
            // Screen shake
            Scale = (MaxShakeDistance - Distance) / MaxShakeDistance * BlurEffectScalar;
            PC.ShakeView(ShakeRotMag * Scale, ShakeRotRate, ShakeRotTime, ShakeOffsetMag * Scale, ShakeOffsetRate, ShakeOffsetTime);

            // Screen blur (reduce scale if player is not fully exposed to the blast)
            if (ROPawn(PC.Pawn) != none && PC.IsA('ROPlayer'))
            {
                BlastShielding = 1.0 - ROPawn(PC.Pawn).GetExposureTo(Location - (50.0 * Normal(PhysicsVolume.Gravity)));
                Scale -= 0.35 * BlastShielding * Scale;
                ROPlayer(PC).AddBlur(BlurTime * Scale, FMin(1.0, Scale));
            }
        }
    }
}

// Colin: Overridden to just return true. The super function is a pointless
// micro-optimization that may have made sense in 2008 when graphics hardware
// wasn't as good, but certainly doesn't make sense now. This is an effect
// that's the size of a building & it's not instantaneous; I don't care how far
// away it is or if you're not looking at it right this instant -- it's relevant.
simulated function bool EffectIsRelevant(vector SpawnLocation, bool bForceDedicated)
{
    return true;
}

// New function to set InstigatorController as the arty officer who called the strike, passed to us by our artillery spawner actor
// Need to set this as don't natively get an Instigator pawn reference as other projectiles do, so PostBeginPlay() fails to get an InstigatorController
// Note we could get Instigator natively by setting the arty spawner's Instigator, which would automatically set Instigator for every shell it spawned
// But Instigator reference would be unreliable due to delay between calling arty & shells being spawned, as player may have died or moved into a vehicle pawn
// Also, this method differs from deprecated ROArtilleryShell, which made the InstigatorController the owner of each shell & used that to get the reference
// Old method meant shell was always net relevant to player who called arty as he was its owner & its Instigator (either makes shell always relevant)
// New method avoids that, so if player re-spawns or otherwise moves well away from arty strike, server can decide whether shells are relevant & should be replicated
// Although we have to avoid setting Instigator here, it does get set in the only place it's needed, which is HurtRadius(), that calls UpdateInstigator()
// But that only happens when the shell explodes is about to be destroyed, meaning it's too late to suddenly make shell replicate to Instigator
function SetInstigatorController(Controller ArtyOfficer)
{
    if (ArtyOfficer != none)
    {
        InstigatorController = ArtyOfficer;
    }
    else
    {
        Log("Artillery shell error: couldn't set InstigatorController (received ArtyOfficer controller =" @ ArtyOfficer $ ")");
        Destroy();
    }
}

// New function updating Instigator reference to ensure damage is attributed to correct player, as may have switched to different pawn since calling arty, e.g. entered vehicle or died
simulated function UpdateInstigator()
{
    if (InstigatorController != none && InstigatorController.Pawn != none)
    {
        Instigator = InstigatorController.Pawn;
    }
}

defaultproperties
{
    bAlwaysRelevant=true // always relevant to every net client, so they hear the sounds, etc

    Damage=500
    DamageRadius=1000.0
    MyDamageType=class'DHArtillery105DamageType'
    MomentumTransfer=75000.0

    DrawType=DT_None // was DT_StaticMesh in RO, but was then set to DT_None in PostBeginPlay - now we simply start with None & switch to SM when we drop the projectile
    StaticMesh=StaticMesh'WeaponPickupSM.shells.122mm_shell' // was a panzerfaust warhead in RO, although never visible - now a large shell
    CullDistance=50000.0
    AmbientGlow=100

    Speed=8000.0
    MaxSpeed=8000.0
    LifeSpan=12.0    // was 1500 seconds but way too long & no reason for that

    DistantSound=Sound'Artillery.fire_distant'
    CloseSound(0)=Sound'Artillery.zoomin.zoom_in01'
    CloseSound(1)=Sound'Artillery.zoomin.zoom_in02'
    CloseSound(2)=Sound'Artillery.zoomin.zoom_in03'
    ExplosionSound(0)=Sound'Artillery.explosions.explo01'
    ExplosionSound(1)=Sound'Artillery.explosions.explo02'
    ExplosionSound(2)=Sound'Artillery.explosions.explo03'
    ExplosionSound(3)=Sound'Artillery.explosions.explo04'
    TransientSoundVolume=1.0

    ShellHitDirtEffectClass=class'ROArtilleryDirtEmitter'
    ShellHitSnowEffectClass=class'ROArtillerySnowEmitter'
    ShellHitDirtEffectLowClass=class'ROArtilleryDirtEmitter_simple'
    ShellHitSnowEffectLowClass=class'ROArtillerySnowEmitter_simple'
    ExplosionDecal=class'ArtilleryMarkDirt'
    ExplosionDecalSnow=class'ArtilleryMarkSnow'

    ShakeRotMag=(X=0.0,Y=0.0,Z=200.0)
    ShakeRotRate=(X=0.0,Y=0.0,Z=2500.0)
    ShakeRotTime=3.0
    ShakeOffsetMag=(X=0.0,Y=0.0,Z=10.0)
    ShakeOffsetRate=(X=0.0,Y=0.0,Z=200.0)
    ShakeOffsetTime=5.0
    BlurTime=6.0
    BlurEffectScalar=2.1

    ForceType=FT_Constant
    ForceScale=5.0
    ForceRadius=60.0
}
