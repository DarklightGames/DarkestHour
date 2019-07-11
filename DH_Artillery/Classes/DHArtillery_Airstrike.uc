//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHArtillery_Airstrike extends DHArtillery
    abstract;

var bool bShouldRandomizeApproachVector;

var array<name> FlybyAnimationNames;

var class<DHAirplane> AirplaneClass;
var DHAirplane Airplane;
var name AirplaneBoneName;

var int PassCount;

var float PlaneInitialHeight;

function PostBeginPlay()
{
    local vector PlaneStartLocation;

    super.PostBeginPlay();

    PlaneStartLocation.Z = class'DHUnits'.static.MetersToUnreal(PlaneInitialHeight);    // TODO: magic number
    PlaneStartLocation += Location;


    Airplane = Spawn(AirplaneClass, self);

    Airplane.SetLocation(PlaneStartLocation);
    Airplane.CruisingHeight = PlaneStartLocation.Z;

    Log(PlaneStartLocation.Z);

    if (Airplane == none)
    {
        Warn("Failed to spawn airplane!");
        Destroy();
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

defaultproperties
{
    MenuName="Airstrike"
    DrawType=DT_Mesh
    Mesh=Mesh'DH_Airplanes_anm.flybys'
    FlybyAnimationNames(0)="flyby_default"
    PlaneInitialHeight=200;
    AirplaneBoneName="airplane"
    RemoteRole=ROLE_SimulatedProxy
    PassCount=2
    bAlwaysRelevant=true
    bForceSkelUpdate=true
    Skins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha'
}

