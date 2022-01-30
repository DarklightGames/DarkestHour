//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHResupplyStrategy extends Object;

enum EResupplyType
{
    RT_Players,
    RT_Vehicles,
    RT_All,
    RT_Mortars
};

var float UpdateTime;

delegate OnPawnResupplied(Pawn P); // Called for every pawn that is resupplied

static function bool CanResupplyType(EResupplyType SourceType, EResupplyType TargetType)
{
    switch (TargetType)
    {
        case RT_Players:
            return SourceType == RT_Players || SourceType == RT_All;
        case RT_Vehicles:
            return SourceType == RT_Vehicles || SourceType == RT_All;
        case RT_Mortars:
            return SourceType == RT_Players || SourceType == RT_Mortars || SourceType == RT_All;
        default:
            return SourceType == RT_All;
    }
}

function bool HandleResupply(Pawn recvr, EResupplyType SourceType, int TimeSeconds)
{
    local Inventory recvr_inv;
    local bool bResupplied;
    local DHPawn P;
    local Vehicle V;
    local DHRoleInfo RI;
    local ROWeapon recvr_weapon;

    bResupplied = false;

    P = DHPawn(recvr);

    if (P != none)
    {
        RI = P.GetRoleInfo();
    }

    // Resupply weapons
    if (P != none && CanResupplyType(SourceType, RT_Players))
    {
        for (recvr_inv = P.Inventory; recvr_inv != none; recvr_inv = recvr_inv.Inventory)
        {
            recvr_weapon = ROWeapon(recvr_inv);

            if (recvr_weapon == none || recvr_weapon.IsGrenade() || recvr_weapon.IsA('DHMortarWeapon'))
            {
                continue;
            }

            bResupplied = bResupplied || recvr_weapon.FillAmmo();
        }

        if (TimeSeconds - recvr.LastResupplyTime >= default.UpdateTime &&
            RI != none &&
            P.bUsedCarriedMGAmmo &&
            P.bCarriesExtraAmmo)
        {
            P.bUsedCarriedMGAmmo = false;
            bResupplied = true;
        }
    }

    V = Vehicle(recvr);

    // Resupply vehicles
    if (V != none && CanResupplyType(SourceType, RT_Vehicles) && !V.IsA('DHMortarVehicle'))
    {
        bResupplied = bResupplied || V.ResupplyAmmo();
    }

    // Resupply deployed mortar
    if (V != none && V.IsA('DHMortarVehicle') && CanResupplyType(SourceType, RT_Mortars))
    {
        bResupplied = bResupplied || V.ResupplyAmmo();
    }

    // Resupply player carrying a mortar
    if (CanResupplyType(SourceType, RT_Mortars) &&
        P != none &&
        TimeSeconds - recvr.LastResupplyTime >= default.UpdateTime)
    {
        bResupplied = bResupplied ||
                      (CanResupplyType(SourceType, RT_Players) && P.bUsedCarriedMGAmmo && P.bCarriesExtraAmmo) ||
                      RI != none &&
                      RI.bCanUseMortars &&
                      P.ResupplyMortarAmmunition();
        P.bUsedCarriedMGAmmo = false;
    }

    // Play sound if applicable
    if (bResupplied)
    {
        recvr.LastResupplyTime = TimeSeconds;
        recvr.ClientResupplied();
    }

    return bResupplied;
}

defaultproperties
{
    UpdateTime=2.5
}
