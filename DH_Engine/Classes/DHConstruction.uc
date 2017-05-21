//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction extends Actor
    abstract
    placeable;

enum EConstructionError
{
    ERROR_None,
    ERROR_Fatal,                // Some fatal error occurred, usually a case of unexpected values
    ERROR_NoGround,             // No solid ground was able to be found
    ERROR_TooSteep,             // The ground slope exceeded the allowable maximum
    ERROR_InWater,              // The construction is in water and the construction type disallows this
    ERROR_Restricted,           // Construction overlaps a restriction volume
    ERROR_NoRoom,               // No room to place this construction
    ERROR_NotOnTerrain,         // Construction is not on terrain
    ERROR_TooClose,             // Too close to an identical construction
    ERROR_InMinefield,          // Cannot be in a minefield!
    ERROR_NearSpawnPoint,       // Cannot be so close to a spawn point (or location hint)
    ERROR_Indoors,              // Cannot be placed indoors
    ERROR_InObjective,          // Cannot be placed inside an objective area
    ERROR_TeamLimit,            // Limit reached for this type of construction
    ERROR_NoSupplies,           // Not within range of any supply caches
    ERROR_InsufficientSupply,   // Not enough supplies to build this construction
    ERROR_RestrictedType,       // Restricted construction type (can't build on this map!)
    ERROR_Other
};

enum ETeamOwner
{
    TEAM_Axis,
    TEAM_Allies,
    TEAM_Neutral
};

// Client state management
var name StateName, OldStateName;

var() ETeamOwner TeamOwner;     // This enum is for the levelers' convenience only.
var private int TeamIndex;
var int TeamLimit;              // The amount of this type of construction that is allowed, per team.

// Manager
var     DHConstructionManager   Manager;

// Placement
var     float   ProxyDistanceInMeters;          // The distance at which the proxy object will be away from the player when
var     bool    bShouldAlignToGround;
var     bool    bCanPlaceInWater;
var     bool    bCanPlaceIndoors;
var     float   IndoorsCeilingHeightInMeters;
var     bool    bCanOnlyPlaceOnTerrain;
var     float   GroundSlopeMaxInDegrees;
var     rotator StartRotationMin;
var     rotator StartRotationMax;
var     int     LocalRotationRate;
var     bool    bCanPlaceInObjective;

var     vector          PlacementOffset;        // 3D offset in the proxy's local-space during placement
var     sound           PlacementSound;         // Sound to play when construction is first placed down
var     float           PlacementSoundRadius;
var     float           PlacementSoundVolume;
var     class<Emitter>  PlacementEmitterClass;  // Emitter to spawn when the construction is first placed down

var     float   FloatToleranceInMeters;         // The distance the construction is allowed to "float" off of the ground at any given point along it's circumfrence
var     float   DuplicateDistanceInMeters;      // The distance required between identical constructions of the same type

// Construction
var     int     SupplyCost;                     // The amount of supply points this construction costs
var     bool    bDestroyOnConstruction;         // If true, this actor will be destroyed after being fully constructed
var     int     Progress;                       // The current count of progress
var     int     ProgressMax;                    // The amount of construction points required to be built

// Tear-down
var     bool    bCanBeTornDown;                 // Whether or not players can
var     int     TearDownProgress;
var     int     TearDownProgressMax;

// Broken
var     int             BrokenLifespan;             // How long does the actor stay around after it's been killed?
var     StaticMesh      BrokenStaticMesh;           // Static mesh to use when the construction is broken
var     sound           BrokenSound;                // Sound to play when the construction is broken
var     float           BrokenSoundRadius;
var     float           BrokenSoundVolume;
var     class<Emitter>  BrokenEmitterClass;         // Emitter to spawn when the construction is broken

// Damage
struct DamageTypeScale
{
    var class<DamageType>   DamageType;
    var float               Scale;
};

var int                         MinDamagetoHurt;    // The minimum amount of damage required to actually harm the construction
var array<DamageTypeScale>      DamageTypeScales;
var array<class<DamageType> >   HarmfulDamageTypes;

// Tattered
var int                         TatteredHealthThreshold;    // The health below which the construction is considered "tattered". -1 for no tattering

// Health
var private int     Health;
var     int         HealthMax;

// Menu
var     localized string    MenuName;
var     localized Material  MenuIcon;

// Level Info
var DH_LevelInfo LevelInfo;

// Staging
struct Stage
{
    var int Progress;           // The progress level at which this stage is used.
    var StaticMesh StaticMesh;  // This can be overridden in GetStaticMesh
    var sound Sound;
    var Emitter Emitter;
};

var int StageIndex;
var array<Stage> Stages;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        TeamIndex, StateName;

    reliable if (Role < ROLE_Authority)
        ServerIncrementProgress;
}

function OnConstructed();
function OnStageIndexChanged(int OldIndex);
function OnTeamIndexChanged();
function OnProgressChanged();
function OnHealthChanged();

simulated function bool IsBroken() { return false; }
simulated function bool IsConstructed() { return false; }
simulated function bool IsTattered() { return false; }
simulated function bool CanBeBuilt() { return false; }

final simulated function int GetTeamIndex()
{
    return TeamIndex;
}

final function SetTeamIndex(int TeamIndex)
{
    self.TeamIndex = TeamIndex;
    OnTeamIndexChanged();
}

function ServerIncrementProgress()
{
    Progress += 1;
    OnProgressChanged();
}

simulated function PostBeginPlay()
{
    local DH_LevelInfo LI;

    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        SetTeamIndex(int(TeamOwner));
        Health = HealthMax;

        foreach AllActors(class'DH_LevelInfo', LI)
        {
            LevelInfo = LI;
            break;
        }
    }

    Manager = FindConstructionManager(Level);

    if (Manager != none)
    {
        Manager.Register(self);
    }
    else
    {
        Warn("Unable to locate manager!");
    }
}

simulated static function DHConstructionManager FindConstructionManager(LevelInfo Level)
{
    local DarkestHourGame G;
    local DHPlayer PC;

    if (Level == none)
    {
        return none;
    }

    if (Level.Role == ROLE_Authority)
    {
        G = DarkestHourGame(Level.Game);

        if (G != none)
        {
            return G.ConstructionManager;
        }
    }
    else
    {
        PC = DHPlayer(Level.GetLocalPlayerController());

        if (PC != none)
        {
            return PC.ConstructionManager;
        }
    }

    return none;
}

// A dummy state, use this when you want this actor to stay around but be
// completely uninteractive with the world. Useful if you want another actor to
// govern the lifetime of this actor, for example.
simulated state Dummy
{
    // Take no damage.
    function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex);

Begin:
    if (Role == ROLE_Authority)
    {
        StateName = GetStateName();
        SetCollision(false, false, false);
        SetDrawType(DT_None);
        NetUpdateTime = Level.TimeSeconds - 1.0;
    }
}

simulated event Destroyed()
{
    super.Destroyed();

    if (Manager != none)
    {
        Manager.Unregister(self);
    }
}

auto simulated state Constructing
{
    simulated function bool CanBeBuilt()
    {
        return true;
    }

    function TakeTearDownDamage()
    {
        Progress -= 1;

        OnProgressChanged();
    }

    function OnProgressChanged()
    {
        local int i;
        local int OldStageIndex;

        if (Progress < 0)
        {
            // TODO: possibly refund supplies to nearby supply cache/vehicle?
            Destroy();
        }
        else if (Progress >= ProgressMax)
        {
            GotoState('Constructed');
        }
        else
        {
            for (i = Stages.Length - 1; i >= 0; --i)
            {
                if (Progress >= Stages[i].Progress)
                {
                    if (StageIndex != i)
                    {
                        OldStageIndex = StageIndex;
                        StageIndex = i;
                        OnStageIndexChanged(OldStageIndex);
                        UpdateAppearance();
                        NetUpdateTime = Level.TimeSeconds - 1.0;
                    }

                    break;
                }
            }
        }
    }

Begin:
    if (Role == ROLE_Authority)
    {
        StateName = GetStateName();

        if (default.Stages.Length == 0)
        {
            // There are no intermediate stages, so put the construction immediately
            // into the fully constructed state.
            Progress = ProgressMax;
        }

        OnProgressChanged();
    }

    // Client-side effects
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (PlacementEmitterClass != none)
        {
            Spawn(PlacementEmitterClass);
        }

        if (PlacementSound != none)
        {
            PlaySound(PlacementSound, SLOT_Misc, PlacementSoundVolume,, PlacementSoundRadius,, true);
        }
    }
}

simulated state Constructed
{
    simulated function bool IsConstructed()
    {
        return true;
    }

    function TakeTearDownDamage()
    {
        TearDownProgress += 1;

        if (TearDownProgress >= TearDownProgressMax)
        {
            if (default.Stages.Length == 0)
            {
                Destroy();
            }
            else
            {
                Progress = ProgressMax - 1;
                GotoState('Constructing');
            }
        }
    }

    function OnHealthChanged()
    {
        if (TatteredHealthThreshold != -1)
        {
            if (Health <= TatteredHealthThreshold)
            {
                SetStaticMesh(GetTatteredStaticMesh());
                NetUpdateTime = Level.TimeSeconds - 1.0;
            }
        }
    }

Begin:
    if (Role == ROLE_Authority)
    {
        OnConstructed();

        if (bDestroyOnConstruction)
        {
            Destroy();
        }
        else
        {
            StageIndex = default.StageIndex;
            TearDownProgress = 0;
            UpdateAppearance();
            StateName = GetStateName();
            NetUpdateTime = Level.TimeSeconds - 1.0;
        }
    }
}

simulated state Broken
{
    simulated function BeginState()
    {
        if (Level.NetMode != NM_DedicatedServer)
        {
            if (BrokenEmitterClass != none)
            {
                Spawn(BrokenEmitterClass, self,, Location, Rotation);
            }
        }
    }

    event TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
    {
        // Do nothing, since we're broken already!
    }

    simulated function bool IsBroken()
    {
        return true;
    }

Begin:
    if (Role == ROLE_Authority)
    {
        UpdateAppearance();
        StateName = GetStateName();
        Lifespan = BrokenLifespan;
        NetUpdateTime = Level.TimeSeconds - 1.0;
    }
}

function UpdateAppearance()
{
    if (IsConstructed())
    {
        SetStaticMesh(GetConstructedStaticMesh());
        SetCollision(true, true, true);
        KSetBlockKarma(true);
    }
    else if (IsBroken())
    {
        SetStaticMesh(GetBrokenStaticMesh());
        SetCollision(false, false, false);
        KSetBlockKarma(false);
    }
    else
    {
        SetStaticMesh(GetStageStaticMesh(StageIndex));
        SetCollision(true, true, true);
        KSetBlockKarma(true);
    }
}

function StaticMesh GetTatteredStaticMesh();

function StaticMesh GetConstructedStaticMesh()
{
    return default.StaticMesh;
}

function StaticMesh GetBrokenStaticMesh()
{
    return default.BrokenStaticMesh;
}

function StaticMesh GetStageStaticMesh(int StageIndex)
{
    if (StageIndex < 0 || StageIndex >= default.Stages.Length)
    {
        return default.StaticMesh;
    }
    else
    {
        return default.Stages[StageIndex].StaticMesh;
    }

    return none;
}

function static string GetMenuName(DHPlayer PC)
{
    return default.MenuName;
}

function static Material GetMenuIcon(DHPlayer PC)
{
    return default.MenuIcon;
}

function static GetCollisionSize(int TeamIndex, DH_LevelInfo LI, out float NewRadius, out float NewHeight)
{
    NewRadius = default.CollisionRadius;
    NewHeight = default.CollisionHeight;
}

function static bool ShouldShowOnMenu(DHPlayer PC)
{
    return true;
}

// This function is used for determining if a player is able to build this type
// of construction. You can override this if you want to have a team or
// role-specific constructions, for example.
function static EConstructionError GetPlayerError(DHPlayer PC, optional out Object OptionalObject)
{
    local DH_LevelInfo LI;
    local DHPawn P;
    local DHConstructionManager CM;

    if (PC == none)
    {
        return ERROR_Fatal;
    }

    LI = PC.GetLevelInfo();

    if (LI != none && LI.IsConstructionRestricted(default.Class))
    {
        return ERROR_RestrictedType;
    }

    P = DHPawn(PC.Pawn);

    if (P == none)
    {
        return ERROR_Fatal;
    }

    if (P.SupplyCount < default.SupplyCost)
    {
        return ERROR_InsufficientSupply;
    }

    CM = FindConstructionManager(PC.Level);

    if (CM == none)
    {
        return ERROR_Fatal;
    }

    if (default.TeamLimit > 0 && CM.CountOf(PC.GetTeamNum(), default.Class) >= default.TeamLimit)
    {
        return ERROR_TeamLimit;
    }

    return ERROR_None;
}

function Reset()
{
    Destroy();
}

// Override to set a new proxy appearance if you require something more
// complex than a simple static mesh.
function static UpdateProxy(DHConstructionProxy CP)
{
    local int i;
    local array<Material> StaticMeshSkins;

    CP.SetDrawType(DT_StaticMesh);
    CP.SetStaticMesh(GetProxyStaticMesh(CP));

    StaticMeshSkins = (new class'UStaticMesh').FindStaticMeshSkins(CP.StaticMesh);

    for (i = 0; i < StaticMeshSkins.Length; ++i)
    {
        CP.Skins[i] = CP.CreateProxyMaterial(StaticMeshSkins[i]);
    }
}

function static StaticMesh GetProxyStaticMesh(DHConstructionProxy CP)
{
    return default.StaticMesh;
}

function static vector GetPlacementOffset()
{
    return default.PlacementOffset;
}

//==============================================================================
// DAMAGE
//==============================================================================

function bool ShouldTakeDamageFromDamageType(class<DamageType> DamageType)
{
    local int i;

    for (i = 0; i < HarmfulDamageTypes.Length; ++i)
    {
        if (DamageType == HarmfulDamageTypes[i] || ClassIsChildOf(DamageType, HarmfulDamageTypes[i]))
        {
            return true;
        }
    }

    return false;
}

function TakeTearDownDamage();

function TakeDamage(int Damage, Pawn InstigatedBy, vector Hitlocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    local class<DamageType> TearDownDamageType;

    if (bCanBeTornDown)
    {
        TearDownDamageType = class<DamageType>(DynamicLoadObject("DH_Equipment.DHShovelBashDamageType", class'class'));

        if (DamageType == TearDownDamageType)
        {
            TakeTearDownDamage();
            return;
        }
    }

    if (!ShouldTakeDamageFromDamageType(DamageType))
    {
        return;
    }

    Damage = GetScaledDamage(DamageType, Damage);

    if (Damage >= MinDamagetoHurt)
    {
        Health -= GetScaledDamage(DamageType, Damage);
    }

    OnHealthChanged();

    if (Health <= 0)
    {
        GotoState('Broken');
    }
}

function int GetScaledDamage(class<DamageType> DamageType, int Damage)
{
    local int i;

    for (i = 0; i < DamageTypeScales.Length; ++i)
    {
        if (DamageType == DamageTypeScales[i].DamageType ||
            ClassIsChildOf(DamageType, DamageTypeScales[i].DamageType))
        {
            return Damage * DamageTypeScales[i].Scale;
        }
    }

    return Damage;
}

simulated function PostNetReceive()
{
    if (StateName != GetStateName())
    {
        GotoState(StateName);
    }
}

defaultproperties
{
    TeamIndex=NEUTRAL_TEAM_INDEX
    RemoteRole=ROLE_SimulatedProxy
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.hedgehog_01'
    HealthMax=100
    Health=1
    ProxyDistanceInMeters=5.0
    GroundSlopeMaxInDegrees=25.0

    bStatic=false
    bNoDelete=false
    bCanBeDamaged=true
    bUseCylinderCollision=false
    bCollideActors=true
    bCollideWorld=false
    bBlockActors=true
    bBlockKarma=true
    bCanPlaceInObjective=true

    CollisionHeight=30.0
    CollisionRadius=60.0

    bNetNotify=true
    NetUpdateFrequency=0.1
    bAlwaysRelevant=false
    bOnlyDirtyReplication=true

    bBlockZeroExtentTraces=true
    bBlockNonZeroExtentTraces=true
    bBlockProjectiles=true
    bProjTarget=true

    // Temp to prevent bots from bunching up at Destroyable statics
    bPathColliding=true
    bWorldGeometry=true

    // Placement
    bCanPlaceInWater=false
    bCanPlaceIndoors=false
    FloatToleranceInMeters=0.5
    PlacementSound=Sound'Inf_Player.Gibimpact.Gibimpact' // TODO: placeholder
    PlacementEmitterClass=class'DH_Effects.DHConstructionEffect'
    PlacementSoundRadius=60.0
    PlacementSoundVolume=4.0
    IndoorsCeilingHeightInMeters=10.0

    LocalRotationRate=32768

    // Death
    BrokenLifespan=15.0
    bCanBeTornDown=true

    // Progress
    StageIndex=-1
    Progress=0
    ProgressMax=8
    TearDownProgressMax=4

    // Damage
    HarmfulDamageTypes(0)=class'ROArtilleryDamType'
//    HarmfulDamageTypes(1)=class'DH_SatchelDamType'
    HarmfulDamageTypes(2)=class'ROTankShellExplosionDamage'
    TatteredHealthThreshold=-1
}
