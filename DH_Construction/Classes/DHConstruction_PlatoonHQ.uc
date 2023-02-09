//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_PlatoonHQ extends DHConstruction
    notplaceable;

var DHSpawnPoint_PlatoonHQ          SpawnPoint;
var int                             FlagSkinIndex;
var class<DHSpawnPoint_PlatoonHQ>   SpawnPointClass;

var localized string                CustomErrorString;
var float                           EnemySecuredObjectiveDistanceMinMeters;     // The minimum distance, in meters, that this construction must be placed away from inactive enemy objectives. Can be overriden by PermittedFriendlyControlledDistanceMeters.
var float                           PermittedFriendlyControlledDistanceMeters;  // The distance, in meters, that will allow this construction to be placed closer to inactive enemy objectives, if a friendly duplicate exists in

// Radio attachment
var DHRadioHQAttachment        Radio;
var class<DHRadioHQAttachment> RadioClass;
var vector                     RadioLocationOffset;
var rotator                    RadioRotationOffset;

simulated state Dummy
{
    simulated function BeginState()
    {
        super.BeginState();

        DestroyAttachments();
    }
}

auto simulated state Constructing
{
    simulated function BeginState()
    {
        super.BeginState();

        if (Radio != none)
        {
            Radio.MakeInvisible();
        }
    }
}

simulated state Constructed
{
    simulated function bool CanTakeTearDownDamageFromPawn(Pawn P, optional bool bShouldSendErrorMessage)
    {
        if (!super.CanTakeTearDownDamageFromPawn(P, bShouldSendErrorMessage))
        {
            return false;
        }

        if (SpawnPoint != none && SpawnPoint.CapturingEnemiesCount >= SpawnPoint.EnemiesNeededToDeconstruct)
        {
            return true;
        }

        // "You must have another teammate nearby to deconstruct an enemy Platoon HQ!"
        if (Role == ROLE_Authority && bShouldSendErrorMessage)
        {
            P.ReceiveLocalizedMessage(class'DHGameMessage', 22);
        }

        return false;
    }
}

simulated function OnConstructed()
{
    local vector HitLocation, HitNormal, TraceEnd, TraceStart;

    super.OnConstructed();

    if (Role == ROLE_Authority)
    {
        if (SpawnPoint == none)
        {
            SpawnPoint = Spawn(SpawnPointClass, self);
        }

        if (SpawnPoint != none)
        {
            // "A Platoon HQ has been constructed and will be established in N seconds."
            class'DarkestHourGame'.static.BroadcastTeamLocalizedMessage(Level, GetTeamIndex(), class'DHPlatoonHQMessage', 4);

            TraceStart = Location + vect(0, 0, 32);
            TraceEnd = Location - vect(0, 0, 32);
            HitLocation = Location;

            if (Trace(HitLocation, HitNormal, TraceEnd, TraceStart) == none)
            {
                Warn("Hey yo something done fucked up, bad spawn locations afoot");
                Destroy();
            }

            HitLocation.Z += class'DHPawn'.default.CollisionHeight / 2;

            SpawnPoint.Construction = self; // TODO: could this be eliminated? The spawn point already has this construction set as the owner!
            SpawnPoint.SetLocation(HitLocation);
            SpawnPoint.SetTeamIndex(GetTeamIndex());
            SpawnPoint.SetIsActive(true);
            SpawnPoint.ResetEstablishmentTimer();
        }

        if (Radio == none)
        {
            Radio = Spawn(RadioClass, self);
        }

        if (Radio != none)
        {
            Radio.TeamIndex = GetTeamIndex();
            Radio.SetBase(self);
            Radio.SetRelativeLocation(RadioLocationOffset);
            Radio.SetRelativeRotation(RadioRotationOffset);
            Radio.Setup();
        }
        else
        {
            Warn("Failed to spawn a radio attachment!");
        }

        // TODO: Find any nearby friendly "Build Platoon HQ" icons within 50m and remove them.
    }

    if (Radio != none)
    {
        Radio.MakeVisible();
    }
}

simulated function DestroyAttachments()
{
    if (SpawnPoint != none)
    {
        SpawnPoint.Destroy();
    }

    if (Radio != none)
    {
        Radio.Destroy();
    }
}

simulated function Destroyed()
{
    DestroyAttachments();
}

simulated state Broken
{
    simulated function BeginState()
    {
        super.BeginState();

        if (SpawnPoint != none)
        {
            // "A Platoon HQ has been destroyed."
            class'DarkestHourGame'.static.BroadcastTeamLocalizedMessage(Level, GetTeamIndex(), class'DHPlatoonHQMessage', 3);
        }

        DestroyAttachments();
    }
}

static function StaticMesh GetConstructedStaticMesh(DHActorProxy.Context Context)
{
    local class<DHNation> NationClass;

    NationClass = Context.LevelInfo.GetTeamNationClass(Context.TeamIndex);

    return NationClass.default.PlatoonHQConstructedStaticMesh;
}

function StaticMesh GetBrokenStaticMesh()
{
    local class<DHNation> NationClass;

    NationClass = LevelInfo.GetTeamNationClass(GetTeamIndex());

    return NationClass.default.PlatoonHQBrokenStaticMesh;
}

function StaticMesh GetStageStaticMesh(int StageIndex)
{
    local class<DHNation> NationClass;

    NationClass = LevelInfo.GetTeamNationClass(GetTeamIndex());

    return NationClass.default.PlatoonHQUnpackedStaticMesh;
}

function StaticMesh GetTatteredStaticMesh()
{
    local class<DHNation> NationClass;

    NationClass = LevelInfo.GetTeamNationClass(GetTeamIndex());

    return NationClass.default.PlatoonHQTatteredStaticMesh;
}

simulated function OnTeamIndexChanged()
{
    local Material FlagMaterial;

    super.OnTeamIndexChanged();

    if (FlagSkinIndex != -1)
    {
        FlagMaterial = GetFlagMaterial();

        if (FlagMaterial != none)
        {
            Skins[FlagSkinIndex] = FlagMaterial;
        }
    }
}

simulated function Material GetFlagMaterial()
{
    return LevelInfo.GetTeamNationClass(GetTeamIndex()).default.PlatoonHQFlagTexture;
}

static function DHConstruction.ConstructionError GetCustomProxyError(DHConstructionProxy P)
{
    local Actor A;
    local DHSpawnPoint SP;
    local DHConstruction C;
    local DHConstruction.ConstructionError E;
    local bool bFoundFriendlyDuplicate, bWithinFriendlyObjectiveDistance;
    local float ControlledObjDistanceMin, DistanceMin, Distance;
    local int i, TeamIndex, ObjectiveIndex;
    local DHGameReplicationInfo GRI;

    TeamIndex = P.GetContext().TeamIndex;
    GRI = DHGameReplicationInfo(P.GetContext().PlayerController.GameReplicationInfo);

    // Do we have a friendly duplicate within PermittedFriendlyControlledDistanceMeters distance?
    foreach P.RadiusActors(default.Class, A, class'DHUnits'.static.MetersToUnreal(default.PermittedFriendlyControlledDistanceMeters))
    {
        C = DHConstruction(A);

        if (C != none && !C.IsInState('Dummy') && (C.GetTeamIndex() == NEUTRAL_TEAM_INDEX || C.GetTeamIndex() == TeamIndex))
        {
            bFoundFriendlyDuplicate = true;
            break;
        }
    }

    // If we have not found a friendly HQ, then lets check if we are near main spawn
    if (!bFoundFriendlyDuplicate)
    {
        foreach P.RadiusActors(class'DHSpawnPoint', SP, class'DHUnits'.static.MetersToUnreal(default.PermittedFriendlyControlledDistanceMeters))
        {
            if (SP != none && SP.bMainSpawn && (SP.GetTeamIndex() == NEUTRAL_TEAM_INDEX || SP.GetTeamIndex() == TeamIndex))
            {
                bFoundFriendlyDuplicate = true;
                break;
            }
        }
    }

    // If we have not found a friendly duplicate, then check if we are trying to place too close to an inactive enemy objective
    if (!bFoundFriendlyDuplicate)
    {
        ControlledObjDistanceMin = class'DHUnits'.static.MetersToUnreal(default.PermittedFriendlyControlledDistanceMeters);
        DistanceMin = class'DHUnits'.static.MetersToUnreal(default.EnemySecuredObjectiveDistanceMinMeters);
        ObjectiveIndex = -1;

        for (i = 0; i < arraycount(GRI.DHObjectives); ++i)
        {
            if (GRI.DHObjectives[i] == none)
            {
                continue;
            }

            // Do the check on secured enemy objectives and set index if within range (prioritizes the closest one)
            if (!GRI.DHObjectives[i].bActive && TeamIndex != int(GRI.DHObjectives[i].ObjState))
            {
                Distance = VSize(P.Location - GRI.DHObjectives[i].Location);

                if (Distance < DistanceMin)
                {
                    DistanceMin = Distance;
                    ObjectiveIndex = i;
                }
            }

            // Find out if there is a friendly owned objective with the same range as PermittedFriendlyControlledDistanceMeters
            // An objective can act as a duplicate, this is basically needed or else it is very hard to place an HQ if you don't have one already
            if (TeamIndex == int(GRI.DHObjectives[i].ObjState))
            {
                Distance = VSize(P.Location - GRI.DHObjectives[i].Location);

                if (Distance < ControlledObjDistanceMin)
                {
                    bWithinFriendlyObjectiveDistance = true;
                }
            }
        }

        // If we found a secured enemy objective within range AND we are not within range of a friendly control objective, then restrict
        if (ObjectiveIndex != -1 && !bWithinFriendlyObjectiveDistance)
        {
            E.Type = ERROR_Custom;
            E.CustomErrorString = default.CustomErrorString;
            E.OptionalString = GRI.DHObjectives[ObjectiveIndex].ObjName;
            E.OptionalInteger = default.PermittedFriendlyControlledDistanceMeters;
            return E;
        }
    }

    return E;
}

// Modified to put the correct nation flag on the flag skin.
function static UpdateProxy(DHActorProxy CP)
{
    local class<DHNation> NationClass;

    super.UpdateProxy(CP);

    NationClass = CP.GetContext().LevelInfo.GetTeamNationClass(CP.GetContext().TeamIndex);

    if (NationClass != none)
    {
        CP.Skins[default.FlagSkinIndex] = CP.CreateProxyMaterial(NationClass.default.PlatoonHQFlagTexture);
    }
}

defaultproperties
{
    MenuName="Platoon HQ"
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.platoon_hq'
    MenuDescription="Provides a team-wide spawn point."
    Stages(0)=()
    ProgressMax=9
    SupplyCost=750
    MinDamagetoHurt=50

    // Placement
    bCanPlaceIndoors=false
    bCanPlaceInObjective=false
    DuplicateFriendlyDistanceInMeters=200
    DuplicateEnemyDistanceInMeters=50
    ProxyTraceDepthMeters=10.0
    bCanOnlyPlaceOnTerrain=true
    bCanPlaceInWater=false
    GroundSlopeMaxInDegrees=10
    SquadMemberCountMinimum=3
    ArcLengthTraceIntervalInMeters=0.5
    CustomErrorString="Cannot {verb} a {name} close to {string} unless within {integer}m of controlled territory."
    bCanBePlacedInDangerZone=false

    StartRotationMin=(Yaw=32768)
    StartRotationMax=(Yaw=32768)

    // Collision
    CollisionHeight=120
    CollisionRadius=250

    // Health
    HealthMax=500
    TatteredHealthThreshold=250

    // Damage
    DamageTypeScales(0)=(DamageType=class'DHShellAPImpactDamageType',Scale=0.33)            // AP Impact
    DamageTypeScales(1)=(DamageType=class'DHRocketImpactDamage',Scale=0.33)                 // AT Rocket Impact
    DamageTypeScales(2)=(DamageType=class'DHThrowableExplosiveDamageType',Scale=1.25)       // Satchel/Grenades
    DamageTypeScales(3)=(DamageType=class'DHShellHEImpactDamageType',Scale=1.5)             // HE Impact
    DamageTypeScales(4)=(DamageType=class'ROTankShellExplosionDamage',Scale=1.33)           // HE Splash

    FlagSkinIndex=1
    SpawnPointClass=class'DHSpawnPoint_PlatoonHQ'
    bCanBeTornDownByFriendlies=false
    FriendlyFireDamageScale=0.0
    ObjectiveDistanceMinMeters=100
    EnemyObjectiveDistanceMinMeters=150.0
    EnemySecuredObjectiveDistanceMinMeters=800.0
    PermittedFriendlyControlledDistanceMeters=300.0 // This should be higher than both ObjectiveDistanceMinMeters and DuplicateFriendlyDistanceInMeters
    GroupClass=class'DHConstructionGroup_Logistics'

    CompletionPointValue=1000

    BrokenLifespan=30.0

    // Radio attachment
    RadioClass=class'DHRadioHQAttachment'
    RadioLocationOffset=(X=65,Y=-115,Z=2)
    RadioRotationOffset=(Roll=0,Pitch=0,Yaw=16384)
}
