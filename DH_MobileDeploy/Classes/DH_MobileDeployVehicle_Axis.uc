//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_MobileDeployVehicle_Axis extends DH_Sdkfz251Transport;

//load texture file for MDV skins
#exec OBJ LOAD FILE="..\Textures\DH_MDV_Tex.utx"

var     bool        bMustBeSL;

//function TryToDrive overridden from DH_ROTransportCraft
//Overridden to allow leader only as driver
function bool TryToDrive(Pawn P)
{
    local int x;

    //Don't allow vehicle to be stolen when somebody is in a turret
    if (!bTeamLocked && P.GetTeamNum() != VehicleTeam)
    {
        for (x = 0; x < WeaponPawns.length; x++)
            if (WeaponPawns[x].Driver != none)
            {
                DenyEntry(P, 2);
                return false;
            }
    }

    //Override crouching requirement to enter
    if (P.bIsCrouched || bNonHumanControl || (P.Controller == none) || !P.Controller.bIsPlayer || P.IsA('Vehicle') || Health <= 0 || !Level.Game.CanEnterVehicle(self, P))
        return false;

    if (!Level.Game.CanEnterVehicle(self, P))
        return false;

    //Check vehicle Locking....
    if (bTeamLocked && (P.GetTeamNum() != VehicleTeam))
    {
        DenyEntry(P, 1);
        return false;
    }

    //Is ran when bMustBeSL && is not the leader
    else if (bMustBeSL && !DH_Pawn(P).GetRoleInfo().bIsSquadLeader)
    {
        //Cycle through the available passenger positions.  Check the class type to see if it is ROPassengerPawn
        for (x = 0; x < WeaponPawns.length; x++)
        {
            //If riders are allowed, the WeaponPawn is free and it is a passenger pawn class then climb aboard.
            if (WeaponPawns[x].Driver == none && WeaponPawns[x].IsA('ROPassengerPawn'))
            {
                WeaponPawns[x].KDriverEnter(P);
                return true;
            }
        }
        P.ReceiveLocalizedMessage(class'DH_MobileDeployMessage', 0); //Full message
        return false;
    }

    //Is ran when driver is present for when 1 SL tries to enter a MDV with a SL already driving
    else if ((Driver != none) || (P.DrivenVehicle != none))
    {
        //Cycle through the available passenger positions.  Check the class type to see if it is ROPassengerPawn
        for (x = 0; x < WeaponPawns.length; x++)
        {
            //If riders are allowed, the WeaponPawn is free and it is a passenger pawn class then climb aboard.
            if (WeaponPawns[x].Driver == none && WeaponPawns[x].IsA('ROPassengerPawn'))
            {
                WeaponPawns[x].KDriverEnter(P);
                return true;
            }
        }
        P.ReceiveLocalizedMessage(class'DH_MobileDeployMessage', 0); //Full message
        return false;
    }
    //Is ran when no driver is present (basically just for the leader)
    else
    {
        if (bEnterringUnlocks && bTeamLocked)
            bTeamLocked = false;

        KDriverEnter(P);
        return true;
    }
}

simulated function ClientKDriverEnter(PlayerController PC)
{
    super.ClientKDriverEnter(PC);

    if (DHPlayer(PC) == none)
        return;

    DHPlayer(PC).QueueHint(14, true);
    DHPlayer(PC).QueueHint(15, true);
}

simulated function ClientKDriverLeave(PlayerController PC)
{
    super.ClientKDriverLeave(PC);

    DHPlayer(PC).QueueHint(17, true);
}

defaultproperties
{
    bMustBeSL=true
    PointValue=3.0
    bNeverReset=true
    Skins(0)=texture'DH_MDV_Tex.AlliedMDV.Halftrack_body_MDV_camo2'
}
