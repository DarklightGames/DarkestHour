//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHResupplyStrategy extends Object;

enum EResupplyType
{
    RT_Players,
    RT_Vehicles,
    RT_All,
    RT_Mortars
};

var float   UpdateTime;
var bool    bGivesExtraAmmo;

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

    if (default.UpdateTime > TimeSeconds - recvr.LastResupplyTime)
    {
        return false;
    }

    bResupplied = false;

    P = DHPawn(recvr);
    V = Vehicle(recvr);

    if (P != none)
    {
        if (CanResupplyType(SourceType, RT_Players))
        { 
            // Resupply weapons
            for (recvr_inv = P.Inventory; recvr_inv != none; recvr_inv = recvr_inv.Inventory)
            {
                recvr_weapon = ROWeapon(recvr_inv);

                if (recvr_weapon == none || recvr_weapon.IsGrenade() || recvr_weapon.IsA('DHMortarWeapon'))
                {
                    continue;
                }

                bResupplied = bResupplied || recvr_weapon.FillAmmo();
            }

            if (bGivesExtraAmmo && P.bUsedCarriedMGAmmo && P.bCarriesExtraAmmo)
            {
                P.bUsedCarriedMGAmmo = false;
                bResupplied = true;
            }
        }

        // Resupply player carrying a mortar
        if (CanResupplyType(SourceType, RT_Mortars) && P != none)
        {
            RI = P.GetRoleInfo();
            bResupplied = bResupplied || RI != none && RI.bCanUseMortars && P.ResupplyMortarAmmunition();
        }
    }
    else if (V != none)
    {
        // Resupply vehicles
        if (CanResupplyType(SourceType, RT_Vehicles) && !V.IsA('DHMortarVehicle'))
        {
            bResupplied = bResupplied || V.ResupplyAmmo();
        }
        else if (CanResupplyType(SourceType, RT_Mortars) && V.IsA('DHMortarVehicle'))
        {
            // Resupply deployed mortar
            bResupplied = bResupplied || V.ResupplyAmmo();
        }
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
    bGivesExtraAmmo=true
}
