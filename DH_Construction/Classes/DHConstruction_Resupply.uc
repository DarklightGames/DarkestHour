//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_Resupply extends DHConstruction;

#exec OBJ LOAD FILE=..\StaticMeshes\DH_Construction_stc.usx

var DHResupplyAttachment ResupplyAttachment;
var int ResupplyCount;

function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        ResupplyAttachment = Spawn(class'DHResupplyAttachment', self);

        if (ResupplyAttachment != none)
        {
            ResupplyAttachment.ResupplyType = RT_Players;
            ResupplyAttachment.SetBase(self);
            ResupplyAttachment.OnPawnResupplied = MyOnPawnResupplied;
        }
        else
        {
            Warn("Failed to spawn resupply attachment!");
        }
    }
}

function MyOnPawnResupplied(Pawn P)
{
    --ResupplyCount;

    if (ResupplyCount <= 0)
    {
        // TODO: Have a different appearance for different supply levels.
        Destroy();
    }
}

simulated function OnTeamIndexChanged()
{
    if (ResupplyAttachment != none)
    {
        ResupplyAttachment.SetTeamIndex(GetTeamIndex());
    }
}

event Destroyed()
{
    super.Destroyed();

    if (ResupplyAttachment != none)
    {
        ResupplyAttachment.Destroy();
    }
}

function UpdateAppearance()
{
    switch (GetTeamIndex())
    {
        case AXIS_TEAM_INDEX:
            SetStaticMesh(StaticMesh'DH_Construction_stc.Ammo.DH_Ger_ammo_box');
            break;
        case ALLIES_TEAM_INDEX:
            switch (LevelInfo.AlliedNation)
            {
            case NATION_USA:
                SetStaticMesh(StaticMesh'DH_Construction_stc.Ammo.DH_USA_ammo_box');
                break;
            case NATION_Britain:
            case NATION_Canada:
                SetStaticMesh(StaticMesh'DH_Construction_stc.Ammo.DH_Commonwealth_ammo_box');
                break;
            case NATION_USSR:
                SetStaticMesh(StaticMesh'DH_Construction_stc.Ammo.DH_Soviet_ammo_box');
                break;
            }
            break;
    }
}

function static StaticMesh GetProxyStaticMesh(DHConstructionProxy CP)
{
    local DH_LevelInfo LI;

    LI = class'DH_LevelInfo'.static.GetInstance(CP.Level);

    switch (CP.PlayerOwner.GetTeamNum())
    {
        case AXIS_TEAM_INDEX:
            return StaticMesh'DH_Construction_stc.Ammo.DH_Ger_ammo_box';
        case ALLIES_TEAM_INDEX:
            switch (LI.AlliedNation)
            {
            case NATION_USA:
                return StaticMesh'DH_Construction_stc.Ammo.DH_USA_ammo_box';
            case NATION_Britain:
            case NATION_Canada:
                return StaticMesh'DH_Construction_stc.Ammo.DH_Commonwealth_ammo_box';
            case NATION_USSR:
                return StaticMesh'DH_Construction_stc.Ammo.DH_Soviet_ammo_box';
            }
        default:
            break;
    }

    return super.GetProxyStaticMesh(CP);
}

defaultproperties
{
    BrokenEmitterClass=class'DHShellShatterEffect'
    bCanDieOfStagnation=false
    BrokenLifespan=0.1
    StaticMesh=StaticMesh'DH_Construction_stc.Ammo.DH_USA_ammo_box'
    bShouldAlignToGround=true
    MenuName="Resupply Box"
    MenuIcon=Texture'DH_GUI_tex.ConstructionMenu.Construction_Ammo'
    ProxyDistanceInMeters=3.0
    DuplicateFriendlyDistanceInMeters=100.0
    CollisionRadius=50.0
    CollisionHeight=30.0
    SupplyCost=300
    bCanPlaceIndoors=true
    ResupplyCount=25
    HealthMax=50
    HarmfulDamageTypes(0)=class'ROArtilleryDamType'
    HarmfulDamageTypes(1)=class'DHThrowableExplosiveDamageType'
    HarmfulDamageTypes(2)=class'DHShellExplosionDamageType'
    HarmfulDamageTypes(3)=class'DHShellImpactDamageType'
    HarmfulDamageTypes(4)=class'DHMortarDamageType'
    HarmfulDamageTypes(5)=class'DHBurningDamageType'
}
