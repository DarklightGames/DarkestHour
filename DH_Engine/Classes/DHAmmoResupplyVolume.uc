//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHAmmoResupplyVolume extends Volume;

enum EOwningTeam
{
    OWNER_Axis,
    OWNER_Allies,
    OWNER_Neutral,
};

enum EResupplyType
{
    RT_Players,
    RT_Vehicles,
    RT_All,
    RT_Mortars
};

var()   EOwningTeam     Team;            //Team this volume resupplies
var()   bool            bUsesSpawnAreas; //Activated/Deactivated based on a spawn area associated with a tag
var()   EResupplyType   ResupplyType;    //Who this volume will resupply

var     float           UpdateTime;      //How often this thing needs to do it's business
var     bool            bActive;         // Whether this ammo resupply volume is active

function PostBeginPlay()
{
    super.PostBeginPlay();

    // Force UpdateTime to be default (no overriding it in the editor)
    UpdateTime = default.UpdateTime;

    if (!bUsesSpawnAreas)
    {
        bActive = true;
    }

    if (Role == ROLE_Authority)
    {
        SetTimer(1.0, true);
    }
}

function Timer()
{
    local Pawn P;
    local Inventory I;
    local ROWeapon W;
    local bool bResupplied;
    local DHPawn DHP;
    local Vehicle V;
    local DHRoleInfo RI;

    if (!bActive)
    {
        return;
    }

    foreach TouchingActors(class'Pawn', P)
    {
        bResupplied = false;

        if ((Team != OWNER_Neutral && P.GetTeamNum() != Team) || Level.TimeSeconds - P.LastResupplyTime < UpdateTime)
        {
            continue;
        }

        DHP = DHPawn(P);

        if (DHP != none)
        {
            RI = DHP.GetRoleInfo();
        }

        if (P != none && (ResupplyType == RT_Players || ResupplyType == RT_All))
        {
            //Resupply weapons
            for (I = P.Inventory; I != none; I = I.Inventory)
            {
                W = ROWeapon(I);

                if (W == none || W.IsGrenade() || W.IsA('DHMortarWeapon'))
                {
                    continue;
                }

                if (W.FillAmmo())
                {
                    bResupplied = true;
                }
            }

            if (RI != none && DHP != none && DHP.bUsedCarriedMGAmmo)
            {
                DHP.bUsedCarriedMGAmmo = false;

                bResupplied = true;
            }
        }

        V = Vehicle(P);

        if (V != none && (ResupplyType == RT_Vehicles || ResupplyType == RT_All) && !V.IsA('DHMortarVehicle'))
        {
            // Resupply vehicles
            if (V.ResupplyAmmo())
            {
                bResupplied = true;
            }
        }

        //Mortar specific resupplying.
        if (ResupplyType == RT_Mortars || ResupplyType == RT_All)
        {
            // Resupply player carrying a mortar
            if (DHP != none)
            {
                if (RI != none && RI.bCanUseMortars && DHP.ResupplyMortarAmmunition())
                {
                    bResupplied = true;
                }

                if (DHP.bUsedCarriedMGAmmo)
                {
                    DHP.bUsedCarriedMGAmmo = false;
                    bResupplied = true;
                }
            }
            // Resupply deployed mortar
            else if (DHMortarVehicle(V) != none && V.ResupplyAmmo())
            {
                bResupplied = true;
            }
        }

        //Play sound if applicable
        if (bResupplied)
        {
            P.LastResupplyTime = Level.TimeSeconds;
            P.ClientResupplied();
        }
    }
}

event Touch(Actor Other)
{
    local ROPawn P;
    local Vehicle V;

    if (!bActive)
    {
        return;
    }

    P = ROPawn(Other);
    V = Vehicle(Other);

    if (P != none)
    {
        if (Team == OWNER_Neutral ||
           (P.PlayerReplicationInfo != none && P.PlayerReplicationInfo.Team != none
           && ((P.PlayerReplicationInfo.Team.TeamIndex == AXIS_TEAM_INDEX && Team == OWNER_Axis) ||
               (P.PlayerReplicationInfo.Team.TeamIndex == ALLIES_TEAM_INDEX && Team == OWNER_Allies))))
        {
            P.bTouchingResupply = true;
        }
    }

    if (V != none)
    {
        if (Team == OWNER_Neutral ||
           ((V.GetTeamNum() == AXIS_TEAM_INDEX && Team == OWNER_Axis) ||
            (V.GetTeamNum() == ALLIES_TEAM_INDEX && Team == OWNER_Allies)))
        {
            V.EnteredResupply();
        }
    }
}

event UnTouch(Actor Other)
{
    local ROPawn P;
    local Vehicle V;

    P = ROPawn(Other);
    V = Vehicle(Other);

    if (P != none)
    {
        P.bTouchingResupply = false;
    }

    if (V != none)
    {
        V.LeftResupply();
    }
}

function Reset()
{
    if (!bUsesSpawnAreas)
    {
        bActive = true;
    }
}

defaultproperties
{
    Team=OWNER_Neutral
    UpdateTime=2.5
    ResupplyType=RT_All
    bStatic=false
}
