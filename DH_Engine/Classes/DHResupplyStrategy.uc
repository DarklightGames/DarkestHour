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

var int UpdateTime;

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

static function bool HandleResupply(Pawn recvr, EResupplyType SourceType, int TimeSeconds)
{
    local inventory recvr_inv;
    local ROWeapon recvr_weapon;
    local bool bResupplied;
    local DHPawn P;
    local Vehicle V;
    local DHWeapon DHW;
    local DHVehicle DHV;
    local DHRoleInfo RI;

    // Log("entered HandleResupply");

    bResupplied = false;
    P = DHPawn(recvr);

    if (P != none)
    {
        RI = P.GetRoleInfo();
    }

    if (P != none && CanResupplyType(SourceType, RT_Players))
    {
        //Resupply weapons
        for (recvr_inv = P.Inventory; recvr_inv != none; recvr_inv = recvr_inv.Inventory)
        {
            recvr_weapon = ROWeapon(recvr_inv);
            DHW = DHWeapon(recvr_inv);

            if (recvr_weapon == none || recvr_weapon.IsGrenade() || recvr_weapon.IsA('DHMortarWeapon'))
            {
                continue;
            }

            // DHWeapon
            if(DHW != none && (TimeSeconds - recvr.LastResupplyTime >= DHW.ResupplyInterval) && recvr_weapon.FillAmmo())
            {
                // Log("DHWeapon");
                bResupplied = true;
            }
            // ROWeapon
            else if ((TimeSeconds - recvr.LastResupplyTime >= default.UpdateTime) && recvr_weapon.FillAmmo())
            {
                // Log("ROWeapon");
                bResupplied = true;
            }
        }

        if ((TimeSeconds - recvr.LastResupplyTime >= default.UpdateTime) 
          && RI != none && P.bUsedCarriedMGAmmo && P.bCarriesExtraAmmo)
        {
            // Log("weapon carries ammo");
            P.bUsedCarriedMGAmmo = false;
            bResupplied = true;
        }
    }

    V = Vehicle(recvr);

    if (V != none && CanResupplyType(SourceType, RT_Vehicles) && !V.IsA('DHMortarVehicle'))
    {
        // Resupply vehicles
        
        DHV = DHVehicle(V);

        if(DHV != none && (TimeSeconds - recvr.LastResupplyTime >= DHV.ResupplyInterval) && V.ResupplyAmmo())
        {
            // Log("DHVehicle");
            bResupplied = true;
        }
        else if ((TimeSeconds - recvr.LastResupplyTime >= default.UpdateTime) && V.ResupplyAmmo())
        {
            // Log("ROVehicle");
            bResupplied = true;
        }
    }

    //Mortar specific resupplying.
    if (CanResupplyType(SourceType, RT_Mortars))
    {
        // Resupply player carrying a mortar
        if (P != none)
        {
            if ((TimeSeconds - recvr.LastResupplyTime >= default.UpdateTime) 
              && RI != none && RI.bCanUseMortars && P.ResupplyMortarAmmunition())
            {
                // Log("Mortar");
                bResupplied = true;
            }

            if ((TimeSeconds - recvr.LastResupplyTime >= default.UpdateTime)
              && CanResupplyType(SourceType, RT_Players) && P.bUsedCarriedMGAmmo && P.bCarriesExtraAmmo)
            {
                // Log("mortar ammo");
                P.bUsedCarriedMGAmmo = false;
                bResupplied = true;
            }
        }
        // Resupply deployed mortar
        else if ((TimeSeconds - recvr.LastResupplyTime >= default.UpdateTime)
          && DHMortarVehicle(V) != none && V.ResupplyAmmo())
        {
            // Log("deployed mortar");
            bResupplied = true;
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
