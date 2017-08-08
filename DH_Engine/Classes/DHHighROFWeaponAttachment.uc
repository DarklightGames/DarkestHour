//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
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
    R.Yaw = (N & 0xFFFF);
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
simulated function SpawnClientRounds(bool bFirstRoundOnly)
{
    local vector  Start, HitLocation, TestHitLocation, HitNormal;
    local rotator ProjectileDir, R;
    local Actor   Other;

    // First shot, or single shot
    if (ShouldSpawnTracer())
    {
        Start = SavedDualShot.FirstShot.ShotLocation;

        Int2Rot(SavedDualShot.FirstShot.ShotRotation, ProjectileDir);

        if (Instigator != none && Instigator.IsFirstPerson()) // removed IsLocallyControlled() check as IsFirstPerson() covers that (same below)
        {
            // do nothing
        }
        // Spawn the tracer from the tip of the third person weapon
        else
        {
            Other = Trace(HitLocation, HitNormal, Start + vector(ProjectileDir) * 65525.0, Start, true);

            if (Other != none)
            {
                Other = none;

                // Make sure tracer wouldn't spawn inside of something
                Other = Trace(TestHitLocation, HitNormal, GetBoneCoords(MuzzleBoneName).Origin + vector(ProjectileDir) * 15.0, GetBoneCoords(MuzzleBoneName).Origin, true);

                if (Other == none)
                {
                    Start = GetBoneCoords(MuzzleBoneName).Origin;
                    ProjectileDir = rotator(Normal(HitLocation - Start));
                }
                else
                {
                    Other = none;
                }
            }
        }

        Spawn(ClientTracerClass,,, Start, ProjectileDir);
    }
    else
    {
        Int2Rot(SavedDualShot.FirstShot.ShotRotation, R);

        Spawn(ClientProjectileClass,,, SavedDualShot.FirstShot.ShotLocation, R);
    }

    // Second shot
    if (!bFirstRoundOnly)
    {
        if (ShouldSpawnTracer())
        {
            Start = SavedDualShot.Secondshot.ShotLocation;
            Int2Rot(SavedDualShot.Secondshot.ShotRotation, ProjectileDir);

            if (Instigator != none && Instigator.IsFirstPerson())
            {
                // do nothing
            }
            // Spawn the tracer from the tip of the third person weapon
            else
            {
                Other = Trace(HitLocation, HitNormal, Start + vector(ProjectileDir) * 65525.0, Start, true);

                if (Other != none)
                {
                    Other = none;

                    // Make sure tracer wouldn't spawn inside of something
                    Other = Trace(TestHitLocation, HitNormal, GetBoneCoords(MuzzleBoneName).Origin + vector(ProjectileDir) * 15.0, GetBoneCoords(MuzzleBoneName).Origin, true);

                    if (Other == none)
                    {
                        Start = GetBoneCoords(MuzzleBoneName).Origin;
                        ProjectileDir = rotator(Normal(HitLocation - Start));
                    }
                    else
                    {
                        Other = none;
                    }
                }
            }

            Spawn(ClientTracerClass,,, Start, ProjectileDir);
        }
        else
        {
            Int2Rot(SavedDualShot.Secondshot.ShotRotation, R);

            Spawn(ClientProjectileClass,,, SavedDualShot.Secondshot.ShotLocation, R);
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
