//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHHighROFWeaponAttachment extends DHWeaponAttachment
    abstract;

// Struct that holds the info we need to launch our client side hit effect
struct ShotInfo
{
    var vector  ShotLocation;
    var int     ShotRotation;
};

// This struct is used to pack two shot info's for replication
struct DualShotInfo
{
    var ShotInfo FirstShot;
    var ShotInfo Secondshot;
};

// Internal shot replication and tracking vars
var     DualShotInfo    SavedDualShot;         // last dualshot info recieved on the client
var     ShotInfo        LastShot;              // last single shotinfo saved server side
var     bool            bFirstShot;            // flags whether this is the first or second shot
var     bool            bUnReplicatedShot;     // we have a shot we haven't replicated the info for yet
var     byte            DualShotCount;         // when this byte is incremented the DualShotInfo will be replicated.
var     byte            SavedDualShotCount;    // the last DualShot Count

var() class<Projectile> ClientProjectileClass; // class for the netclient only projectile for this weapon // was class ROClientBullet
var() class<Projectile> ClientTracerClass;     // class for the netclient only tracer for this weapon     // was class ROClientBullet

// Tracer stuff
var()   bool            bUsesTracers;          // true if the weapon uses tracers in it's ammo loadout
var()   int             TracerFrequency;       // how often a tracer is loaded in.  Assume to be 1 in valueof(TracerFrequency)
var     byte            NextTracerCounter;     // when this equals TracerFrequency, spawn a tracer

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        SavedDualShot, DualShotCount;
}

simulated function Int2Rot(int N, out rotator R)
{
    // Unpack rotation integer:
    // 0x0 - Pitch (16-bit signed integer)
    // 0xF - Yaw (16-bit signed integer)
    R.Pitch = (N >> 16) & 0xFFFF;
    R.Yaw = N & 0xFFFF;
}

simulated function Rot2Int(rotator R, out int N)
{
    // Pack pitch and yaw components into a 32-bit integer:
    // 0x0 - Pitch (16-bit signed integer)
    // 0xF - Yaw (16-bit signed integer)
    N = ((R.Pitch << 16) & 0XFFFF0000) | (R.Yaw & 0xFFFF);
}

// Here we spawn our client side effect rounds if the shot count has changed
simulated function PostNetReceive()
{
    super.PostNetReceive();

    if (DualShotCount != SavedDualShotCount)
    {
        if (Level.NetMode == NM_Client)
        {
            if (DualShotCount < 254)
            {
                SpawnClientRounds(false);
            }
            else
            {
                SpawnClientRounds(true);
            }
        }

        SavedDualShotCount = DualShotCount;
    }
}

// Check the tracer count and determine if we should spawn a tracer round
simulated function bool ShouldSpawnTracer()
{
    ++NextTracerCounter;

    if (!bUsesTracers || ClientTracerClass == none || NextTracerCounter != TracerFrequency)
    {
        return false;
    }

    NextTracerCounter = 0; // reset for next tracer spawn

    return true;
}

// Handles unpacking and spawning the correct client side hit effect rounds
// Modified (from deprecated ROHighROFWeaponAttachment) to correctly handle adjustment of the tracer direction (in 3rd person view) for a sky shot or similar
// Without this any sky shots in a burst are seen by other players to come from player's head & travel in a significantly different direction to shots that hit something
// All we do differently is if the trace hits nothing, we just use its end location for the direction adjustment & spawn tracer from 3rd person muzzle bone as usual
// Also some re-factoring to optimise & make clearer, by removing repetition & redundancy
simulated function SpawnClientRounds(bool bFirstRoundOnly)
{
    local vector  ProjectileLoc, HitLocation, TestHitLocation, HitNormal, TraceEnd, MuzzleLocation;
    local rotator ProjectileDir;

    // First shot, or single shot
    // Get replicated start location & direction for this shot
    ProjectileLoc = SavedDualShot.FirstShot.ShotLocation;
    Int2Rot(SavedDualShot.FirstShot.ShotRotation, ProjectileDir);

    if (ShouldSpawnTracer())
    {
        // If looking at someone else firing (or firing in behind view), spawn the tracer from the tip of the third person weapon attachment
        if (Instigator == none || !Instigator.IsFirstPerson()) // removed !IsLocallyControlled() check as !IsFirstPerson() covers that
        {
            MuzzleLocation = GetBoneCoords(MuzzleBoneName).Origin;

            // As we're adjusting tracer's start location, we also adjust its direction a little so it hits approx the same place it would have
            // We trace to get location it would hit in a straight line along its original replicated direction
            TraceEnd = ProjectileLoc + (65525.0 * vector(ProjectileDir));

            // If trace didn't hit anything, e.g. it's a sky shot, we'll just use trace's end location for tracer direction adjustment
            // Added this to fix bug where sky shots were seen to come from player's head, because they weren't adjusted to spawn from the muzzle
            if (Trace(HitLocation, HitNormal, TraceEnd, ProjectileLoc, true) == none)
            {
                HitLocation = TraceEnd;
            }

            // Switch the spawn location to the muzzle location & adjust tracer direction based on our hit location
            // But first just make sure the tracer wouldn't spawn inside something if we spawn it from the 3rd person weapon's muzzle
            // So do another very short trace forwards from our hit location to make sure there's nothing right in front of it
            if (Trace(TestHitLocation, HitNormal, MuzzleLocation + (vector(ProjectileDir) * 15.0), MuzzleLocation, true) == none)
            {
                ProjectileDir = rotator(Normal(HitLocation - ProjectileLoc));
                ProjectileLoc = MuzzleLocation;
            }
        }

        Spawn(ClientTracerClass,,, ProjectileLoc, ProjectileDir);
    }
    else
    {
        Spawn(ClientProjectileClass,,, ProjectileLoc, ProjectileDir);
    }

    // Second shot
    if (!bFirstRoundOnly)
    {
        // Get replicated start location & direction for this shot
        ProjectileLoc = SavedDualShot.Secondshot.ShotLocation;
        Int2Rot(SavedDualShot.Secondshot.ShotRotation, ProjectileDir);

        if (ShouldSpawnTracer())
        {
            // If looking at someone else firing (or firing in behind view), spawn the tracer from the tip of the third person weapon attachment
            if (Instigator == none || !Instigator.IsFirstPerson())
            {
                MuzzleLocation = GetBoneCoords(MuzzleBoneName).Origin;
                TraceEnd = ProjectileLoc + (65525.0 * vector(ProjectileDir));

                if (Trace(HitLocation, HitNormal, TraceEnd, ProjectileLoc, true) == none)
                {
                    HitLocation = TraceEnd;
                }

                if (Trace(TestHitLocation, HitNormal, MuzzleLocation + (vector(ProjectileDir) * 15.0), MuzzleLocation, true) == none)
                {
                    ProjectileDir = rotator(Normal(HitLocation - ProjectileLoc));
                    ProjectileLoc = MuzzleLocation;
                }
            }

            Spawn(ClientTracerClass,,, ProjectileLoc, ProjectileDir);
        }
        else
        {
            Spawn(ClientProjectileClass,,, ProjectileLoc, ProjectileDir);
        }
    }
}

// This function will take the information about a shot and turn it into a shotinfo struct
function ShotInfo MakeShotInfo(vector NewLocation, rotator SetRotation)
{
    local ShotInfo SI;

    SI.ShotLocation = NewLocation;

    Rot2Int(SetRotation, SI.ShotRotation);

    return SI;
}

defaultproperties
{
    bNetNotify=true
}
