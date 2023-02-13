//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_Vehicle extends DHConstruction
    abstract
    notplaceable;

var class<DHVehicle>    VehicleClass;
var DHVehicle           Vehicle;

function Destroyed()
{
    super.Destroyed();

    if (Vehicle != none)
    {
        Vehicle.Destroy();
    }
}

simulated function OnTeamIndexChanged()
{
    super.OnTeamIndexChanged();

    VehicleClass = GetVehicleClass(GetContext());
}

simulated function OnConstructed()
{
    if (Role == ROLE_Authority)
    {
        if (VehicleClass != none)
        {
            Vehicle = Spawn(VehicleClass,,, Location, Rotation);

            GotoState('Dummy');
        }
    }
}

simulated state Dummy
{
    function BeginState()
    {
        SetTimer(1.0, true);
    }

    function Timer()
    {
        if (Vehicle == none)
        {
            Destroy();
        }
    }
}

// TODO: do we put this in the vehicle itself???
function static UpdateProxy(DHActorProxy AP)
{
    local int i, j;
    local DHActorProxyAttachment APA;
    local class<DHVehicle> VehicleClass;

    VehicleClass = GetVehicleClass(AP.GetContext());

    AP.SetDrawType(DT_Mesh);
    AP.LinkMesh(VehicleClass.default.Mesh);

    for (j = 0; j < VehicleClass.default.Skins.Length; ++j)
    {
        if (VehicleClass.default.Skins[j] != none)
        {
            AP.Skins[j] = AP.CreateProxyMaterial(VehicleClass.default.Skins[j]);
        }
    }

    for (i = 0; i < VehicleClass.default.PassengerWeapons.Length; ++i)
    {
        APA = AP.Spawn(class'DHActorProxyAttachment', AP);

        if (APA != none)
        {
            AP.AttachToBone(APA, VehicleClass.default.PassengerWeapons[i].WeaponBone);

            APA.SetDrawType(DT_Mesh);
            APA.LinkMesh(VehicleClass.default.PassengerWeapons[i].WeaponPawnClass.default.GunClass.default.Mesh);

            for (j = 0; j < VehicleClass.default.PassengerWeapons[i].WeaponPawnClass.default.GunClass.default.Skins.Length; ++j)
            {
                if (VehicleClass.default.PassengerWeapons[i].WeaponPawnClass.default.GunClass.default.Skins[j] != none)
                {
                    APA.Skins[j] = AP.CreateProxyMaterial(VehicleClass.default.PassengerWeapons[i].WeaponPawnClass.default.GunClass.default.Skins[j]);
                }
            }

            AP.Attachments[AP.Attachments.Length] = APA;
        }
    }
}

function static string GetMenuName(DHActorProxy.Context Context)
{
    local class<DHVehicle> VC;

    VC = GetVehicleClass(Context);

    if (VC == none)
    {
        return "";
    }

    return VC.default.VehicleNameString;
}

function UpdateAppearance()
{
    SetDrawType(DT_Mesh);

    if (VehicleClass.default.ConstructionBaseMesh != none)
    {
        LinkMesh(VehicleClass.default.ConstructionBaseMesh);
    }
    else
    {
        LinkMesh(VehicleClass.default.Mesh);
    }

    SetCollisionSize(VehicleClass.default.CollisionRadius, VehicleClass.default.CollisionHeight);
}

function static GetCollisionSize(DHActorProxy.Context Context, out float NewRadius, out float NewHeight)
{
    local class<DHVehicle> VehicleClass;

    VehicleClass = GetVehicleClass(Context);

    if (VehicleClass != none)
    {
        NewRadius = VehicleClass.default.CollisionRadius;
        NewHeight = VehicleClass.default.CollisionHeight;
        return;
    }

    // If we couldn't get the vehicle class, just fall back on to the original method.
    super.GetCollisionSize(Context, NewRadius, NewHeight);
}

// Override to get a different vehicle class based on scenario (eg. snow camo etc.)
function static class<DHVehicle> GetVehicleClass(DHActorProxy.Context Context)
{
    return default.VehicleClass;
}

function static DHConstruction.ConstructionError GetPlayerError(DHActorProxy.Context Context)
{
    local DHConstruction.ConstructionError E;

    if (GetVehicleClass(Context) == none)
    {
        E.Type = ERROR_Fatal;
        return E;
    }

    return super.GetPlayerError(Context);
}

simulated static function int GetSupplyCost(DHActorProxy.Context Context)
{
    return GetVehicleClass(Context).default.SupplyCost;
}

static function bool ShouldShowOnMenu(DHActorProxy.Context Context)
{
    if (GetVehicleClass(Context) != none)
    {
        return super.ShouldShowOnMenu(Context);
    }
    else
    {
        return false;
    }
}

static function vector GetPlacementOffset(DHActorProxy.Context Context)
{
    local class<DHVehicle> VehicleClass;

    VehicleClass = GetVehicleClass(Context);

    return VehicleClass.default.ConstructionPlacementOffset;
}

defaultproperties
{
    StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.barricade_wire_02'
    bDestroyOnConstruction=false
    BrokenLifespan=0.0
    ConstructionVerb="emplace"
    GroupClass=class'DHConstructionGroup_Guns'
    bCanBeDamaged=false
    DuplicateFriendlyDistanceInMeters=15.0
    CompletionPointValue=100
    bCanOnlyPlaceOnTerrain=true
}
