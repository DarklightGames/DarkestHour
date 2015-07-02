//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMortarProjectile extends ROBallisticProjectile
    abstract;

const UU2M = 0.01904762;
const UU2FT = 0.0625;

// Sounds
var sound   DescendingSound;

var bool    bDud;
var float   DudChance;

var class<Emitter> HitDirtEmitterClass;
var class<Emitter> HitSnowEmitterClass;
var class<Emitter> HitWoodEmitterClass;
var class<Emitter> HitRockEmitterClass;
var class<Emitter> HitWaterEmitterClass;
var sound HitDirtSound;
var sound HitRockSound;
var sound HitWaterSound;
var sound HitWoodSound;

var vector DebugForward;
var vector DebugRight;
var vector DebugLocation;
var bool   bDebug;

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        bDud;
}

simulated function Timer()
{
    super.Timer();

    if (bDebug)
    {
        if (Level.NetMode != NM_DedicatedServer)
        {
            DrawStayingDebugLine(DebugLocation, Location, 255, 0, 0);
        }

        DebugLocation = Location;
    }
}

// Adjusts the pitch of the round descent sound - rounds far away will seem to drone, while being close to the descent will make the sounds scream
simulated function GetDescendingSoundPitch(out float Pitch, vector SoundLocation)
{
    local Pawn   P;
    local vector CameraLocation;
    local float  ClampedDistance;

    Pitch = 0.75;
    P = Level.GetLocalPlayerController().Pawn;

    if (P != none)
    {
        CameraLocation = P.Location + (P.BaseEyeHeight * vect(0.0, 0.0, 1.0));
        ClampedDistance = Clamp(VSize(SoundLocation - CameraLocation), 0.0, 5249.0);
        Pitch += (((5249.0 - ClampedDistance) / 5249.0) * 0.5);
    }
}

simulated function GetHitSurfaceType(out ESurfaceTypes SurfaceType)
{
    local vector   HitLocation, HitNormal;
    local Material M;

    Trace(HitLocation, HitNormal, Location + vect(0.0, 0.0, -16.0), Location + vect(0.0, 0.0, 16.0), false,, M);

    if (M == none)
    {
        SurfaceType = EST_Default;
    }
    else
    {
        SurfaceType = ESurfaceTypes(M.SurfaceType);
    }
}

simulated function PostBeginPlay()
{
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (Location != vect(0.0, 0.0, 0.0))
        {
            Spawn(class'DH_Effects.DH_MortarFireEffect',,, Location, Rotation);
        }

        Enable('Tick');
    }

    // Chance to dud
    if (Role == ROLE_Authority && FRand() < DudChance)
    {
        bDud = true;
    }

    if (bDebug)
    {
        DebugLocation = Location;
        SetTimer(0.25, true);
    }

    OrigLoc = Location;

    super.PostBeginPlay();
}

// Modified to set InstigatorController (used to attribute radius damage kills correctly)
simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if (Instigator != none)
    {
        InstigatorController = Instigator.Controller;
    }
}

simulated function Tick(float DeltaTime)
{
    local vector HitLocation;
    local float  Pitch;

    if (Level.NetMode != NM_DedicatedServer && Velocity.Z < 0.0 && ShouldPlayDescendingSound(HitLocation))
    {
        GetDescendingSoundPitch(Pitch, HitLocation);
        PlaySound(DescendingSound, SLOT_None, 8.0, false, 512.0, Pitch, true);
        Disable('Tick');
    }
}

// Matt: modified to handle new VehicleWeapon collision mesh actor
// If we hit collision mesh actor (probably turret, maybe an exposed vehicle MG), we switch the hit actor to be the real VehicleWeapon & proceed as if we'd hit that actor
simulated singular function Touch(Actor Other)
{
    local vector HitLocation, HitNormal;

    if (DHVehicleWeaponCollisionMeshActor(Other) != none)
    {
        Other = Other.Owner;
    }

//  super.Touch(Other); // doesn't work as this function & Super are singular functions, so have to re-state Super from Projectile here

    if (Other != none && (Other.bProjTarget || Other.bBlockActors))
    {
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

simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    if (Other == Instigator || Other.Base == Instigator || ROBulletWhipAttachment(Other) != none)
    {
        return;
    }

    // This is to prevent jerks from walking in front of the mortar and blowing us up
    if (DHPawn(Other) != none && VSizeSquared(OrigLoc - HitLocation) < 16384.0) // within approx 2 metres
    {
        return;
    }

    Explode(HitLocation, Normal(HitLocation - Other.Location));
}

simulated function HitWall(vector HitNormal, Actor Wall)
{
    Explode(Location, HitNormal);
}

simulated function bool ShouldPlayDescendingSound(out vector OutHitLocation)
{
    local vector HitLocation, HitNormal, TraceEnd, HalfVector;

    Halfvector = Normal(Normal(Velocity) + vect(0.0, 0.0, -1.0));
    TraceEnd = Location + (HalfVector * (VSize(Velocity) * (GetSoundDuration(DescendingSound) + 0.5)));

    if (Trace(HitLocation, HitNormal, TraceEnd, Location, true) != none)
    {
        OutHitLocation = HitLocation;

        return true;
    }

    return false;
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    if (Role == ROLE_Authority)
    {
        SetHitLocation(HitLocation);
    }

    BlowUp(HitLocation);

    if (bDebug)
    {
        if (Level.NetMode != NM_DedicatedServer)
        {
            DrawStayingDebugLine(DebugLocation, DebugLocation, 255, 0, 255);
        }

        Log((DebugForward dot (HitLocation - OrigLoc) * UU2M) @ (DebugRight dot (HitLocation - OrigLoc) * UU2M));
    }
}

function BlowUp(vector HitLocation)
{
    if (Role == ROLE_Authority)
    {
        MakeNoise(1.0);
    }
}

function SetHitLocation(vector HitLocation)
{
    local DHGameReplicationInfo   GRI;
    local DHPlayerReplicationInfo PRI;
    local DHPlayer C;
    local byte     TeamIndex, ClosestMortarTargetIndex;
    local float    ClosestMortarTargetDistance, MortarTargetDistance;
    local int      i;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI == none || InstigatorController == none || InstigatorController.PlayerReplicationInfo == none)
    {
        return;
    }

    PRI = DHPlayerReplicationInfo(InstigatorController.PlayerReplicationInfo);

    if (PRI == none || PRI.RoleInfo == none || InstigatorController.Pawn == none)
    {
        return;
    }

    C = DHPlayer(InstigatorController);

    TeamIndex = InstigatorController.GetTeamNum();

    // Zero out the z coordinate for 2D distance checking from targets
    HitLocation.Z = 0.0;

    // Index of 255 means we didn't find a nearby target
    ClosestMortarTargetIndex = 255;
    ClosestMortarTargetDistance = class'DHGameReplicationInfo'.default.MortarTargetDistanceThreshold;

    Log("HitLocation" @ HitLocation);

    // Set the X/Y component of our players' mortar hit location
    C.MortarHitLocation.X = HitLocation.X;
    C.MortarHitLocation.Y = HitLocation.Y;
    C.MortarHitLocation.Z = 0.0;

    if (TeamIndex == AXIS_TEAM_INDEX)
    {
        // Find the closest mortar target
        for (i = 0; i < arraycount(GRI.GermanMortarTargets); ++i)
        {
            if (GRI.GermanMortarTargets[i].Location == vect(0.0, 0.0, 0.0))
            {
                continue;
            }

            MortarTargetDistance = VSize(GRI.GermanMortarTargets[i].Location - HitLocation);

            if (MortarTargetDistance < ClosestMortarTargetDistance)
            {
                ClosestMortarTargetDistance = MortarTargetDistance;
                ClosestMortarTargetIndex = i;
            }
        }

        // If we still have a mortar target index of 255, it means none of the targets were close enough
        if (ClosestMortarTargetIndex != 255)
        {
            GRI.GermanMortarTargets[ClosestMortarTargetIndex].HitLocation = HitLocation;

            // A 1.0 in the Z-component indicates to display the hit on the map
            C.MortarHitLocation.Z = 1.0;
        }
    }
    else if (TeamIndex == ALLIES_TEAM_INDEX)
    {
        // Find the closest mortar target
        for (i = 0; i < arraycount(GRI.AlliedMortarTargets); ++i)
        {
            if (GRI.AlliedMortarTargets[i].Location == vect(0.0, 0.0, 0.0))
            {
                continue;
            }

            MortarTargetDistance = VSize(GRI.AlliedMortarTargets[i].Location - HitLocation);

            if (MortarTargetDistance < ClosestMortarTargetDistance)
            {
                ClosestMortarTargetDistance = MortarTargetDistance;
                ClosestMortarTargetIndex = i;
            }
        }

        // If we still have a mortar target index of 255, it means none of the targets were close enough
        if (ClosestMortarTargetIndex != 255)
        {
            GRI.AlliedMortarTargets[ClosestMortarTargetIndex].HitLocation = HitLocation;

            // A 1.0 in the Z-component indicates to display the hit on the map
            C.MortarHitLocation.Z = 1.0;
        }
    }

    Log("C.PlayerReplicationInfo.PlayerName" @ C.PlayerReplicationInfo.PlayerName);
    Log("C.MortarHitLocation" @ C.MortarHitLocation);
}

// Matt: modified to handle new VehicleWeapon collision mesh actor
// If we hit collision mesh actor (probably turret, maybe an exposed vehicle MG), we switch the hit actor to be the real VehicleWeapon & proceed as if we'd hit that actor
// Also to call CheckVehicleOccupantsRadiusDamage() instead of DriverRadiusDamage() on a hit vehicle, to properly handle blast damage to any exposed vehicle occupants
// Also to update Instigator, so HurtRadius attributes damage to the player's current pawn
function HurtRadius(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
    local Actor         Victims, TraceHitActor;
    local ROPawn        P;
    local array<ROPawn> CheckedROPawns;
    local Controller    C;
    local bool          bAlreadyChecked, bAlreadyDead;
    local vector        Direction, TraceHitLocation, TraceHitNormal;
    local float         DamageScale, Distance, DamageExposure;
    local int           i;

    // Make sure nothing else runs HurtRadius() while we are in the middle of the function
    if (bHurtEntry)
    {
        return;
    }

    bHurtEntry = true;

    // Find all colliding actors within blast radius, which the blast should damage
    foreach VisibleCollidingActors(class'Actor', Victims, DamageRadius, HitLocation)
    {
        // If hit collision mesh actor then switch to actual VehicleWeapon
        if (DHVehicleWeaponCollisionMeshActor(Victims) != none)
        {
            Victims = Victims.Owner;
        }

        // Don't damage this projectile, an actor already damaged by projectile impact (HurtWall), non-authority actors, or fluids
        if (Victims != self && HurtWall != Victims && Victims.Role == ROLE_Authority && !Victims.IsA('FluidSurfaceInfo'))
        {
            // Do a trace to the actor & if there's a vehicle between the player and explosion, don't apply damage
            TraceHitActor = Trace(TraceHitLocation, TraceHitNormal, Victims.Location, HitLocation);

            if (Vehicle(TraceHitActor) != none && TraceHitActor != Victims)
            {
                continue;
            }

            // Check for hit on player pawn
            P = ROPawn(Victims);

            if (P == none)
            {
                P = ROPawn(Victims.Base);
            }

            // If we hit a player pawn, make sure we haven't already registered the hit & add pawn to array of already hit/checked pawns
            if (P != none)
            {
                for (i = 0; i < CheckedROPawns.Length; ++i)
                {
                    if (CheckedROPawns[i] == P)
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

                Victims = P;
                bAlreadyDead = P.Health <= 0; // so we don't score points for a mortar observer unless it's a live kill
            }

            // Calculate damage based on distance from explosion
            Direction = Victims.Location - HitLocation;
            Distance = FMax(1.0, VSize(Direction));
            Direction = Direction / Distance;
            DamageScale = 1.0 - FMax(0.0, (Distance - Victims.CollisionRadius) / DamageRadius);

            if (P != none)
            {
                DamageScale *= DamageExposure;
            }

            // Record player responsible for damage caused, & if we're damaging LastTouched actor, reset that to avoid damaging it again at end of function
            if (Instigator == none || Instigator.Controller == none)
            {
                Victims.SetDelayedDamageInstigatorController(InstigatorController);
            }

            if (Victims == LastTouched)
            {
                LastTouched = none;
            }

            // Damage the actor hit by the blast - if it's a vehicle, check for damage to any exposed occupants
            Victims.TakeDamage(DamageScale * DamageAmount, Instigator, Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * Direction,
                DamageScale * Momentum * Direction, DamageType);

            if (ROVehicle(Victims) != none && ROVehicle(Victims).Health > 0)
            {
                CheckVehicleOccupantsRadiusDamage(ROVehicle(Victims), DamageAmount, DamageRadius, DamageType, Momentum, HitLocation);
            }

            // Give additional points to the observer and the mortarman for working together for a kill!
            if (!bAlreadyDead && Pawn(Victims) != none && Pawn(Victims).Health <= 0 && InstigatorController.GetTeamNum() != Pawn(Victims).GetTeamNum())
            {
                C = GetClosestMortarTargetController();

                if (C != none)
                {
                    DarkestHourGame(Level.Game).ScoreMortarSpotAssist(C, InstigatorController);
                }
            }
        }
    }

    // Same (or very similar) process for the last actor this projectile hit (Touched), but only happens if actor wasn't found by the check for VisibleCollidingActors
    if (LastTouched != none && LastTouched != self && LastTouched.Role == ROLE_Authority && !LastTouched.IsA('FluidSurfaceInfo'))
    {
        Victims = LastTouched;
        LastTouched = none;

        if (DHVehicleWeaponCollisionMeshActor(Victims) != none)
        {
            Victims = Victims.Owner;
        }

        Direction = Victims.Location - HitLocation;
        Distance = FMax(1.0, VSize(Direction));
        Direction = Direction / Distance;
        DamageScale = FMax(Victims.CollisionRadius / (Victims.CollisionRadius + Victims.CollisionHeight), 1.0 - FMax(0.0, (Distance - Victims.CollisionRadius) / DamageRadius));

        if (Instigator == none || Instigator.Controller == none)
        {
            Victims.SetDelayedDamageInstigatorController(InstigatorController);
        }

        Victims.TakeDamage(DamageScale * DamageAmount, Instigator, Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * Direction,
            DamageScale * Momentum * Direction, DamageType);

        if (ROVehicle(Victims) != none && ROVehicle(Victims).Health > 0)
        {
            CheckVehicleOccupantsRadiusDamage(ROVehicle(Victims), DamageAmount, DamageRadius, DamageType, Momentum, HitLocation);
        }
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

// New function updating Instigator reference to ensure damage is attributed to correct player, as may have switched to different pawn since firing, e.g. undeployed mortar
simulated function UpdateInstigator()
{
    if (InstigatorController != none && InstigatorController.Pawn != none)
    {
        Instigator = InstigatorController.Pawn;
    }
}

function Controller GetClosestMortarTargetController()
{
    local DHGameReplicationInfo GRI;
    local float  Distance, ClosestDistance;
    local int i, ClosestIndex;

    ClosestIndex = 255;
    ClosestDistance = class'DHGameReplicationInfo'.default.MortarTargetDistanceThreshold;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI == none)
    {
        return none;
    }

    switch (InstigatorController.GetTeamNum())
    {
        case AXIS_TEAM_INDEX:
            for (i = 0; i < arraycount(GRI.GermanMortarTargets); ++i)
            {
                if (GRI.GermanMortarTargets[i].Controller == none)
                {
                    continue;
                }

                Distance = VSize(Location - GRI.GermanMortarTargets[i].Location);

                if (Distance <= ClosestDistance)
                {
                    ClosestDistance = Distance;
                    ClosestIndex = i;
                }
            }

            if (ClosestIndex == 255)
            {
                return none;
            }

            return GRI.GermanMortarTargets[ClosestIndex].Controller;

        case ALLIES_TEAM_INDEX:
            for (i = 0; i < arraycount(GRI.AlliedMortarTargets); ++i)
            {
                if (GRI.AlliedMortarTargets[i].Controller == none)
                {
                    continue;
                }

                Distance = VSize(Location - GRI.AlliedMortarTargets[i].Location);

                if (Distance <= ClosestDistance)
                {
                    ClosestDistance = Distance;
                    ClosestIndex = i;
                }
            }

            if (ClosestIndex == 255)
            {
                return none;
            }

            return GRI.AlliedMortarTargets[ClosestIndex].Controller;

        default:
            break;
    }

    return none;
}

simulated function DoHitEffects(vector HitLocation, vector HitNormal)
{
    local ESurfaceTypes  HitSurfaceType;
    local class<Emitter> HitEmitterClass;
    local sound          HitSound;

    GetHitSurfaceType(HitSurfaceType);
    GetHitEmitterClass(HitEmitterClass, HitSurfaceType);
    GetHitSound(HitSound, HitSurfaceType);

    Spawn(HitEmitterClass,,, HitLocation, rotator(HitNormal));
    PlaySound(HitSound, SLOT_None, 4.0 * TransientSoundVolume);
}

simulated function GetHitEmitterClass(out class<Emitter> HitEmitterClass, ESurfaceTypes SurfaceType)
{
    switch (SurfaceType)
    {
        case EST_Ice:
            HitEmitterClass = HitSnowEmitterClass;
            return;

        case EST_Snow:
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

defaultproperties
{
    DescendingSound=sound'DH_WeaponSounds.Mortars.Descent01'
    DudChance=0.01
    HitDirtEmitterClass=class'ROEffects.TankAPHitDirtEffect'
    HitSnowEmitterClass=class'ROEffects.TankAPHitSnowEffect'
    HitWoodEmitterClass=class'ROEffects.TankAPHitWoodEffect'
    HitRockEmitterClass=class'ROEffects.TankAPHitRockEffect'
    HitWaterEmitterClass=class'ROEffects.TankAPHitWaterEffect'
    HitDirtSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Dirt'
    HitRockSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Rock'
    HitWaterSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Water'
    HitWoodSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Wood'
    DrawType=DT_None
    LifeSpan=60.0
    bBlockHitPointTraces=false
}
