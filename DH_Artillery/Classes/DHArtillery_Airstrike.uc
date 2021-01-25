//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHArtillery_Airstrike extends DHArtillery
    abstract;

var bool bShouldRandomizeApproachVector;

var array<name> FlybyAnimationNames;

var class<DHAirplane> AirplaneClass;
var DHAirplane Airplane;
var name AirplaneBoneName;

var int PassCount;

function PostBeginPlay()
{
    local vector FlybyOffset;

    super.PostBeginPlay();

    FlybyOffset.Z += class'DHUnits'.static.MetersToUnreal(25.0);    // TODO: magic number

    Airplane = Spawn(AirplaneClass, self);

    SetLocation(Location + FlybyOffset);

    if (Airplane == none)
    {
        Warn("Failed to spawn airplane!");
        Destroy();
    }

    // Attach the plane to our airplane bone in the flyby rig.
    AttachToBone(Airplane, AirplaneBoneName);

    // TODO: the radio's position could be used to determine an approach vector
    // to have a pretty good
    if (bShouldRandomizeApproachVector)
    {
        //Rotation = rot(0, Rand(65536), 0);
    }
}

// The animation rate is determined by the plane's airspeed vs how much ground
// it has to cover. The flyby animations have a distance of 4km to cover as the
// crow flies (to accomodate the largest maps).
simulated function float GetFlybyAnimationRate(name FlybyAnimationName)
{
    return GetAnimDuration(FlybyAnimationName, 1.0) / (4000.0 / AirplaneClass.default.Airspeed);
}

auto state Flyby
{
    function BeginState()
    {
        DoFlyby();
    }

    function DoFlyby()
    {
        local name FlybyAnimationName;
        local float FlybyAnimationRate;

        LOG("STARTING FLYBY");

        //FlybyAnimationName = FlybyAnimationNames[Rand(FlybyAnimationNames.Length)];
        FlybyAnimationName = 'flyby_default';
        FlybyAnimationRate = GetFlybyAnimationRate(FlybyAnimationName);

        SetTimer(GetAnimDuration(FlybyAnimationName, FlybyAnimationRate), false);
        PlayAnim(FlybyAnimationName, FlybyAnimationRate);
    }

    function Timer()
    {
        local rotator R;

        Log("COMPLETED FLYBY!");

        // Fly animation has completed, now determine if we should do another flyby.
        PassCount -= 1;

        if (PassCount == 0)
        {
            Destroy();
        }

        // We are doing another pass. Rotate us 180 degrees and reset the animation.
        R = Rotation;
        R.Yaw += 32768;
        SetRotation(R);

        // TODO: add a small variance to this
        DoFlyby();
    }
}

simulated function Destroyed()
{
    if (Airplane != none)
    {
        Airplane.Destroy();
    }

    super.Destroyed();
}

// These are functions that get called by the animations.
simulated event DropBomb()
{
    Log("DROP BOMB CALLED!");
}

exec function StartFireCannon();
exec function StopFireCannon();

defaultproperties
{
    MenuName="Airstrike"
    DrawType=DT_Mesh
    Mesh=Mesh'DH_Airplanes_anm.flybys'
    FlybyAnimationNames(0)="flyby_default"
    AirplaneBoneName="airplane"
    RemoteRole=ROLE_SimulatedProxy
    PassCount=2
    bAlwaysRelevant=true
    bForceSkelUpdate=true
    Skins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha'
}

