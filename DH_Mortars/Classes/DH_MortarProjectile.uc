//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_MortarProjectile extends ROBallisticProjectile
abstract;

const UU2M = 0.01904762;
const UU2FT = 0.0625;

//Sounds
var sound   DescendingSound;

var bool    bDud;
var float   DudChance;

//So we can track who fired this round.
var PlayerController DamageInstigator;

const TargetHitDistanceThreshold = 5250;    //100 meters

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

var bool bDebug;

var vector DebugLocation;

replication
{
    reliable if (Role == ROLE_Authority)
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

//------------------------------------------------------------------------------
// Adjusts the pitch of the round descent sound.  Rounds far away will seem to
// drone, while being close to the descent will make the sounds scream.
simulated function GetDescendingSoundPitch(out float Pitch, vector SoundLocation)
{
    local Pawn P;
    local vector CameraLocation;
    local float ClampedDistance;

    Pitch = 0.75;
    P = Level.GetLocalPlayerController().Pawn;

    if (P != none)
    {
        CameraLocation = P.Location + (P.BaseEyeHeight * vect(0, 0, 1));
        ClampedDistance = Clamp(VSize(SoundLocation - CameraLocation), 0, 5249.0);
        Pitch += (((5249.0 - ClampedDistance) / 5249.0) * 0.5);
    }
}

simulated function GetHitSurfaceType(out ESurfaceTypes SurfaceType)
{
    local vector HitLocation, HitNormal;
    local Material M;

    Trace(HitLocation, HitNormal, Location + vect(0, 0, -16), Location + vect(0, 0, 16), false,, M);

    if (M == none)
        SurfaceType = EST_Default;
    else
        SurfaceType = ESurfaceTypes(M.SurfaceType);
}

simulated function PostBeginPlay()
{
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (Location != vect(0, 0, 0))
            Spawn(class'DH_Effects.DH_MortarFireEffect',, , Location, Rotation);

        Enable('Tick');
    }

    // Chance to dud.
    if (Role == ROLE_Authority && FRand() < DudChance)
        bDud = true;

    if (bDebug)
    {
        DebugLocation = Location;
        SetTimer(0.25, true);
    }

    OrigLoc = Location;

    super.PostBeginPlay();
}

simulated function Tick(float DeltaTime)
{
    local vector HitLocation;
    local float Pitch;

    if (Level.NetMode != NM_DedicatedServer && Velocity.Z < 0 && ShouldPlayDescendingSound(HitLocation))
    {
        GetDescendingSoundPitch(Pitch, HitLocation);
        PlaySound(DescendingSound, SLOT_None, 8.0, false, 512, Pitch, true);
        Disable('Tick');
    }

}

// Matt: modified to handle new VehicleWeapon collision mesh actor
// If we hit a collision mesh actor (probably a turret, maybe an exposed vehicle MG), we switch the hit actor to be the real vehicle weapon & proceed as if we'd hit that actor instead
simulated singular function Touch(Actor Other)
{
    local vector HitLocation, HitNormal;

    if (DH_VehicleWeaponCollisionMeshActor(Other) != none)
    {
        Other = Other.Owner;
    }

//  super.Touch(Other); // doesn't work as this function & Super are singular functions, so have to re-state Super from Projectile here

    if (Other != none && (Other.bProjTarget || Other.bBlockActors))
    {
        LastTouched = Other;

        if (Velocity == vect(0.0,0.0,0.0) || Other.IsA('Mover'))
        {
            ProcessTouch(Other,Location);
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
    // This is to prevent jerks from walking in front of the mortar and blowing us up
    if (DH_Pawn(Other) != none && VSizeSquared(OrigLoc - HitLocation) < 16384.0)
    {
        return;
    }

    // Matt TEST - we are doubling up calls to Explode here, as the super also calls it - talk with Basnett & confirm we need the Explode version below, in which case presumably ditch the Super
    super.ProcessTouch(Other, HitLocation); // Super from Projectile just does: if (Other != Instigator) Explode(HitLocation, Normal(HitLocation - Other.Location));

    Explode(HitLocation, Normal(Other.Location - Location));
}

simulated function HitWall(vector HitNormal, actor Wall)
{
    super.HitWall(HitNormal, Wall);

    Explode(Location, HitNormal);
}

simulated function bool ShouldPlayDescendingSound(out vector OutHitLocation)
{
    local vector HitLocation, HitNormal, TraceEnd, Halfvector;

    Halfvector = Normal(Normal(Velocity) + vect(0, 0, -1));
    TraceEnd = Location + (Halfvector * (VSize(Velocity) * (GetSoundDuration(DescendingSound) + 0.50)));

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
        SetHitLocation(HitLocation);

    if (bDebug)
    {
        if (Level.NetMode != NM_DedicatedServer)
        {
            DrawStayingDebugLine(DebugLocation, DebugLocation, 255, 0, 255);
        }

        log((DebugForward dot (Location - OrigLoc) * UU2M) @ (DebugRight dot (Location - OrigLoc) * UU2M));
    }
}

function SetHitLocation(vector HitLocation)
{
    local int i;
    local DHGameReplicationInfo GRI;
    local DHPlayerReplicationInfo PRI;
    local DHPlayer C;
    local byte TeamIndex;
    local byte ClosestMortarTargetIndex;
    local float ClosestMortarTargetDistance;
    local float MortarTargetDistance;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI == none || DamageInstigator == none || DamageInstigator.PlayerReplicationInfo == none)
        return;

    PRI = DHPlayerReplicationInfo(DamageInstigator.PlayerReplicationInfo);

    if (PRI == none || PRI.RoleInfo == none)
        return;

    if (DamageInstigator.Pawn == none)
        return;

    C = DHPlayer(DamageInstigator);

    TeamIndex = DamageInstigator.GetTeamNum();

    //--------------------------------------------------------------------------
    // Zero out the z coordinate for 2D distance checking from targets.
    HitLocation.Z = 0;

    //--------------------------------------------------------------------------
    // Index of 255 means we didn't find a nearby target.
    ClosestMortarTargetIndex = 255;
    ClosestMortarTargetDistance = TargetHitDistanceThreshold;

    if (TeamIndex == 0)
    {
        //----------------------------------------------------------------------
        // Find the closest mortar target.
        for(i = 0; i < arraycount(GRI.GermanMortarTargets); i++)
        {
            if (GRI.GermanMortarTargets[i].Location == vect(0, 0, 0))
                continue;

            MortarTargetDistance = VSize(GRI.GermanMortarTargets[i].Location - HitLocation);

            if (MortarTargetDistance < ClosestMortarTargetDistance)
            {
                ClosestMortarTargetDistance = MortarTargetDistance;
                ClosestMortarTargetIndex = i;
            }
        }

        //----------------------------------------------------------------------
        // If we still have a mortar target index of 255, it means none of the
        // targets were close enough.
        if (ClosestMortarTargetIndex == 255)
        {
            C.MortarHitLocation = vect(0, 0, 0);
            return;
        }

        GRI.GermanMortarTargets[ClosestMortarTargetIndex].HitLocation = HitLocation;
    }
    else
    {
        //----------------------------------------------------------------------
        // Find the closest mortar target.
        for(i = 0; i < arraycount(GRI.AlliedMortarTargets); I++)
        {
            if (GRI.AlliedMortarTargets[i].Location == vect(0, 0, 0))
                continue;

            MortarTargetDistance = VSize(GRI.AlliedMortarTargets[i].Location - HitLocation);

            if (MortarTargetDistance < ClosestMortarTargetDistance)
            {
                ClosestMortarTargetDistance = MortarTargetDistance;
                ClosestMortarTargetIndex = i;
            }
        }

        //----------------------------------------------------------------------
        // If we still have a mortar target index of 255, it means none of the
        // targets were close enough.
        if (ClosestMortarTargetIndex == 255)
        {
            C.MortarHitLocation = vect(0, 0, 0);
            return;
        }

        GRI.AlliedMortarTargets[ClosestMortarTargetIndex].HitLocation = HitLocation;
    }

    C.MortarHitLocation = HitLocation;
}

simulated function DoHitEffects(vector HitLocation, vector HitNormal)
{
    local ESurfaceTypes HitSurfaceType;
    local class<Emitter> HitEmitterClass;
    local sound HitSound;

    GetHitSurfaceType(HitSurfaceType);
    GetHitEmitterClass(HitEmitterClass, HitSurfaceType);
    GetHitSound(HitSound, HitSurfaceType);

    Spawn(HitEmitterClass,, , HitLocation, rotator(HitNormal));
    PlaySound(HitSound, SLOT_None, 4.0 * TransientSoundVolume);
}

simulated function GetHitEmitterClass(out class<Emitter> HitEmitterClass, ESurfaceTypes SurfaceType)
{
    switch(SurfaceType)
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
    switch(SurfaceType)
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
    DescendingSound=Sound'DH_WeaponSounds.Mortars.Descent01'
    DudChance=0.010000
    HitDirtEmitterClass=class'ROEffects.TankAPHitDirtEffect'
    HitSnowEmitterClass=class'ROEffects.TankAPHitSnowEffect'
    HitWoodEmitterClass=class'ROEffects.TankAPHitWoodEffect'
    HitRockEmitterClass=class'ROEffects.TankAPHitRockEffect'
    HitWaterEmitterClass=class'ROEffects.TankAPHitWaterEffect'
    HitDirtSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Dirt'
    HitRockSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Rock'
    HitWaterSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Water'
    HitWoodSound=SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Wood'
    DrawType=DT_none
    LifeSpan=60.000000
    bBlockHitPointTraces=false
}
