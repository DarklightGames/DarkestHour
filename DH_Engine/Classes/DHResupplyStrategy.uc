//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DHResupplyStrategy extends Object
  abstract;

enum EResupplyType
{
    RT_Players,
    RT_Vehicles,
    RT_All,
    RT_Mortars
};

var float UpdateTime;

delegate OnPawnResupplied(Pawn P);            // Called for every pawn that is resupplied


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

static function float GetResupplyInterval(Actor Receiver)
{
    local DHWeapon            DHW;
    local DHVehicleWeapon     DHVW;
    local DHVehicle           DHV;
    local DHVehicleWeaponPawn DHVWP;

    DHW = DHWeapon(Receiver);
    if (DHW != none)
    {
        return DHW.default.ResupplyInterval;
    }
    DHV = DHVehicle(Receiver);
    if (DHW != none)
    {
        return DHV.default.ResupplyInterval;
    }
    DHVW = DHVehicleWeapon(Receiver);
    if (DHVW != none)
    {
        return DHVW.default.ResupplyInterval;
    }
    DHVWP = DHVehicleWeaponPawn(Receiver);
    if (DHVWP != none)
    {
        return DHVWP.default.ResupplyInterval;
    }

    // default fallback
    return default.UpdateTime;
}

static function bool HandleResupply(Pawn recvr, EResupplyType SourceType, int TimeSeconds)
{
    local inventory recvr_inv;
    local bool bResupplied;
    local DHPawn P;
    local Vehicle V;
    local DHRoleInfo RI;
    local ROWeapon recvr_weapon;
    local float ResupplyInterval;

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

            ResupplyInterval = GetResupplyInterval(recvr_inv);

            if (TimeSeconds - recvr.LastResupplyTime >= ResupplyInterval)
            {
                bResupplied = bResupplied || recvr_weapon.FillAmmo();
            }
        }

        ResupplyInterval = GetResupplyInterval(recvr);
        if ((TimeSeconds - recvr.LastResupplyTime >= ResupplyInterval) 
          && RI != none && P.bUsedCarriedMGAmmo && P.bCarriesExtraAmmo)
        {
            P.bUsedCarriedMGAmmo = false;
            bResupplied = true;
        }
    }

    V = Vehicle(recvr);

    // Resupply vehicles and deployed mortars
    if (V != none && CanResupplyType(SourceType, RT_Vehicles) && !V.IsA('DHMortarVehicle'))
    {
        ResupplyInterval = GetResupplyInterval(V);

        if ((TimeSeconds - recvr.LastResupplyTime >= ResupplyInterval))
        {
            bResupplied = bResupplied || V.ResupplyAmmo();
        }
    }

    // Resupply player carrying a mortar
    if (CanResupplyType(SourceType, RT_Mortars))
    {
        if (P != none)
        {
            ResupplyInterval = GetResupplyInterval(P);
            if ((TimeSeconds - recvr.LastResupplyTime >= ResupplyInterval) && RI != none && RI.bCanUseMortars)
            {
                bResupplied = bResupplied || P.ResupplyMortarAmmunition();
            }

            if (TimeSeconds - recvr.LastResupplyTime >= ResupplyInterval)
            {
                P.bUsedCarriedMGAmmo = false;
                bResupplied = bResupplied || (CanResupplyType(SourceType, RT_Players) && P.bUsedCarriedMGAmmo && P.bCarriesExtraAmmo);
            }
        }
    }

    //Play sound if applicable
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
