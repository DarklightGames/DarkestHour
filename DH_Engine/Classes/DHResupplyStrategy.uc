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

static function float GetResupplyInterval(Actor Receiver, bool PrintDebug)
{
    local DHWeapon            DHW;
    local DHVehicleWeapon     DHVW;
    local DHVehicleWeaponPawn DHVWP;
    PrintDebug=false;

    DHW = DHWeapon(Receiver);
    if (DHW != none)
    {
        // Log("DHWeapon" @ Receiver);
        return DHW.default.ResupplyInterval;
    }
    DHVW = DHVehicleWeapon(Receiver);
    if (DHVW != none)
    {
        // Log("DHVehicleWeapon" @ Receiver);
        return DHVW.default.ResupplyInterval;
    }
    DHVWP = DHVehicleWeaponPawn(Receiver);
    if (DHVWP != none)
    {
        // Log("DHVehicleWeaponPawn" @ Receiver);
        return DHVWP.default.ResupplyInterval;
    }

    // default fallback
    // Log("default" @ Receiver);
    return default.UpdateTime;
}

static function bool HandleResupply(Pawn recvr, EResupplyType SourceType, int TimeSeconds, bool PrintDebug)
{
    local inventory recvr_inv;
    local bool bResupplied;
    local DHPawn P;
    local Vehicle V;
    local DHVehicle DHV;
    local DHRoleInfo RI;
    local ROWeapon recvr_weapon;
    local float ResupplyInterval;

    // Log("entered HandleResupply");

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

            ResupplyInterval = GetResupplyInterval(recvr_inv, PrintDebug);

            if (TimeSeconds - recvr.LastResupplyTime >= ResupplyInterval)
            {
                if(PrintDebug)
                {
                    Log("weapon" @ ", ResupplyInterval:" @ ResupplyInterval);
                }
                bResupplied = bResupplied || recvr_weapon.FillAmmo();
            }
        }

        ResupplyInterval = GetResupplyInterval(recvr, PrintDebug);
        if ((TimeSeconds - recvr.LastResupplyTime >= ResupplyInterval) 
          && RI != none && P.bUsedCarriedMGAmmo && P.bCarriesExtraAmmo)
        {
            if(PrintDebug)
                Log("weapon carries ammo");
            P.bUsedCarriedMGAmmo = false;
            bResupplied = true;
        }
    }

    V = Vehicle(recvr);

    // Resupply vehicles and deployed mortars
    if (V != none && CanResupplyType(SourceType, RT_Vehicles) && !V.IsA('DHMortarVehicle'))
    {
        ResupplyInterval = GetResupplyInterval(V, PrintDebug);

        if ((TimeSeconds - recvr.LastResupplyTime >= ResupplyInterval))
        {
            if(PrintDebug)
            {
                Log("Vehicle:" @ V @ ", ResupplyInterval:" @ ResupplyInterval);
            }
            bResupplied = bResupplied || V.ResupplyAmmo();
        }
    }

    // Resupply player carrying a mortar
    if (CanResupplyType(SourceType, RT_Mortars))
    {
        if (P != none)
        {
            ResupplyInterval = GetResupplyInterval(P, PrintDebug);
            if ((TimeSeconds - recvr.LastResupplyTime >= ResupplyInterval) && RI != none && RI.bCanUseMortars)
            {
                if(PrintDebug)
                    Log("mortar");
                bResupplied = bResupplied || P.ResupplyMortarAmmunition();
            }

            if (TimeSeconds - recvr.LastResupplyTime >= ResupplyInterval)
            {
                if(PrintDebug)
                    Log("mortar ammo");
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
