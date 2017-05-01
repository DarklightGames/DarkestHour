//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstruction_Vehicle extends DHConstruction
    abstract;

var class<ROVehicle> VehicleClass;

function OnTeamIndexChanged()
{
    super.OnTeamIndexChanged();

    VehicleClass = GetVehicleClass(GetTeamIndex(), LevelInfo);
}

function OnConstructed()
{
    if (VehicleClass != none)
    {
        Spawn(VehicleClass,,, Location, Rotation);
    }
}

function static UpdateProxy(DHConstructionProxy CP)
{
    local int i, j;
    local DHConstructionProxyAttachment CPA;
    local class<ROVehicle> VehicleClass;

    VehicleClass = GetVehicleClass(CP.PlayerOwner.GetTeamNum(), CP.PlayerOwner.ClientLevelInfo);

    CP.SetDrawType(DT_Mesh);
    CP.LinkMesh(VehicleClass.default.Mesh);

    for (j = 0; j < VehicleClass.default.Skins.Length; ++j)
    {
        if (VehicleClass.default.Skins[j] != none)
        {
            CP.Skins[j] = CP.CreateProxyMaterial(VehicleClass.default.Skins[j]);
        }
    }

    for (i = 0; i < VehicleClass.default.PassengerWeapons.Length; ++i)
    {
        CPA = CP.Spawn(class'DHConstructionProxyAttachment', CP);

        if (CPA != none)
        {
            CP.AttachToBone(CPA, VehicleClass.default.PassengerWeapons[i].WeaponBone);

            CPA.SetDrawType(DT_Mesh);
            CPA.LinkMesh(VehicleClass.default.PassengerWeapons[i].WeaponPawnClass.default.GunClass.default.Mesh);

            j = 0;

            for (j = 0; j < VehicleClass.default.PassengerWeapons[i].WeaponPawnClass.default.GunClass.default.Skins.Length; ++j)
            {
                if (VehicleClass.default.PassengerWeapons[i].WeaponPawnClass.default.GunClass.default.Skins[j] != none)
                {
                    CPA.Skins[j] = CP.CreateProxyMaterial(VehicleClass.default.PassengerWeapons[i].WeaponPawnClass.default.GunClass.default.Skins[j]);
                }
            }

            CP.Attachments[CP.Attachments.Length] = CPA;
        }
    }
}

function static string GetMenuName(DHPlayer PC)
{
    return GetVehicleClass(PC.GetTeamNum(), PC.GetLevelInfo()).default.VehicleNameString;
}

function UpdateAppearance()
{
    // TODO: set the appearance to whatever the base of the vehicle is
    SetDrawType(DT_Mesh);
    LinkMesh(VehicleClass.default.Mesh);
}

function static GetCollisionSize(int TeamIndex, DH_LevelInfo LI, out float NewRadius, out float NewHeight)
{
    local class<ROVehicle> VehicleClass;

    VehicleClass = GetVehicleClass(TeamIndex, LI);

    if (VehicleClass != none)
    {
        NewRadius = VehicleClass.default.CollisionRadius;
        NewHeight = VehicleClass.default.CollisionHeight;
        return;
    }

    // If we couldn't get the vehicle class, just fall back on to the original method.
    super.GetCollisionSize(TeamIndex, LI, NewRadius, NewHeight);
}

// Override to get a different vehicle class based on scenario (eg. snow camo etc.)
function static class<ROVehicle> GetVehicleClass(int TeamIndex, DH_LevelInfo LI)
{
    return default.VehicleClass;
}

defaultproperties
{
    StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.barricade_wire_02'
    bDestroyOnConstruction=true
    bShouldAlignToGround=true
    BrokenLifespan=0.0
}
