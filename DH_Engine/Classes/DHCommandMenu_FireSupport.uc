//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHCommandMenu_FireSupport extends DHCommandMenu;

function OnSelect(int Index, vector Location)
{
    local DHPlayer PC;
    local DHPlayerReplicationInfo PRI;
    local DHGameReplicationInfo GRI;
    local vector MapLocation;

    PC = GetPlayerController();

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

    GRI.GetMapCoords(Location, MapLocation.X, MapLocation.Y);

    if (PC == none || Index < 0 || Index >= Options.Length)
    {
        return;
    }

    if(PC.CheckIfTargetIsValid(Location))
    {
        switch (Index)
        {
            case 0: // Artillery barrage
                Log("trying to add barrage request in " $ MapLocation.X $ " and " $ MapLocation.Y $ " - >" $ Location $ "<");
                self.AddNewRequest(PC, MapLocation, class'DH_Engine.DHMapMarker_FireSupport_BarrageRequest');
//              self.NotifyRadioman();
                break;
            case 1: // Fire request (Smoke)
                self.AddNewRequest(PC, MapLocation, class'DH_Engine.DHMapMarker_FireSupport_Smoke');
                break;
            case 2: // Fire request (HE)
                self.AddNewRequest(PC, MapLocation, class'DH_Engine.DHMapMarker_FireSupport_HE');
                break;
        }
    }
    Interaction.Hide();
}

function OnPush()
{
    local DHPlayer PC;

    PC = GetPlayerController();

    if (PC == none)
    {
        return;
    }

    if (PC.SpottingMarker != none)
    {
        PC.SpottingMarker.Destroy();
    }

    PC.SpottingMarker = PC.Spawn(class'DHSpottingMarker', PC);
}

function OnPop()
{
    local DHPlayer PC;

    PC = GetPlayerController();

    if (PC == none || PC.SpottingMarker == none)
    {
        return;
    }

    PC.SpottingMarker.Destroy();
}

function Tick()
{
    local DHPlayer PC;
    local vector HitLocation, HitNormal;
    local Color C;

    C.R = 0;
    C.G = 0;
    C.B = 0;
    C.A = 0;

    PC = GetPlayerController();

    if (PC == none || PC.SpottingMarker == none)
    {
        return;
    }

    PC.GetEyeTraceLocation(HitLocation, HitNormal);
    if(PC.CheckIfArtilleryIsAllowed(HitLocation))
    {
        C.G = 255;
        PC.SpottingMarker.SetColor(C);
    }
    else
    {
        C.R = 255;
        PC.SpottingMarker.SetColor(C);
    }
    PC.SpottingMarker.SetLocation(HitLocation);
    PC.SpottingMarker.SetRotation(QuatToRotator(QuatFindBetween(HitNormal, vect(0, 0, 1))));
}

function AddNewRequest(DHPlayer PC, vector MapLocation, class<DHMapMarker> MapMarkerClass)
{
    if(PC.IsArtilleryRequestingLocked())
    {
        PC.Pawn.ReceiveLocalizedMessage(class'DHFireSupportMessage', 1,,, PC);
    }
    else
    {
        PC.LockArtilleryRequests(PC.ArtilleryLockingPeriod);
        PC.AddMarker(MapMarkerClass, MapLocation.X, MapLocation.Y);
        PC.Pawn.ReceiveLocalizedMessage(class'DHFireSupportMessage', 0,,, MapMarkerClass);
        PC.ConsoleCommand("SPEECH SUPPORT 8");
    }
}

function NotifyRadioman(DHPlayer PC)
{
    local int                   TeamIndex;
    local Controller            C;
    local DHPlayer              OtherPlayerController;
    local DHRoleInfo            DRI;

    TeamIndex = PC.GetTeamNum();
    for (C = PC.Level.ControllerList; C != none; C = C.NextController)
    {
        OtherPlayerController = DHPlayer(C);
        if(OtherPlayerController != none)
        {
            DRI = DHRoleInfo(OtherPlayerController.GetRoleInfo());
            if(DRI != none && DRI.bCarriesRadio && OtherPlayerController.GetTeamNum() == TeamIndex)
            {
                
            }
        }
    }
}

defaultproperties
{
    // TODO: Icons
    Options(0)=(ActionText="Artillery Barrage",Material=Texture'DH_InterfaceArt2_tex.Icons.fire')
    Options(1)=(ActionText="Fire Request (Smoke)",Material=Texture'DH_InterfaceArt2_tex.Icons.fire')
    Options(2)=(ActionText="Fire Request (HE)",Material=Texture'DH_InterfaceArt2_tex.Icons.fire')

    bShouldTick=true
}
