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

    if (PC.IsArtillerySpotter() && PC.CheckIfTargetIsValid(Location))
    {
        switch (Index)
        {
            case 0: // Artillery barrage
                self.AddNewArtilleryRequest(PC, MapLocation, class'DH_Engine.DHMapMarker_FireSupport_BarrageRequest');
                break;
            case 1: // Fire request (Smoke)
                self.AddNewArtilleryRequest(PC, MapLocation, class'DH_Engine.DHMapMarker_FireSupport_Smoke');
                break;
            case 2: // Fire request (HE)
                self.AddNewArtilleryRequest(PC, MapLocation, class'DH_Engine.DHMapMarker_FireSupport_HE');
                break;
        }
    }
    else
    {
        PC.ReceiveLocalizedMessage(class'ROArtilleryMsg', 5); // "Not a Valid Artillery Target!"
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
    if (PC.CheckIfTargetIsValid(HitLocation))
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

function AddNewArtilleryRequest(DHPlayer PC, vector MapLocation, class<DHMapMarker_FireSupport> MapMarkerClass)
{
    if (PC.IsArtilleryRequestingLocked())
    {
        PC.Pawn.ReceiveLocalizedMessage(class'DHFireSupportMessage', 1,,, PC);
    }
    else
    {
        PC.LockArtilleryRequests(PC.ArtilleryLockingPeriod);
        PC.AddMarker(MapMarkerClass, MapLocation.X, MapLocation.Y);
        if (class<DHMapMarker_FireSupport_BarrageRequest>(MapMarkerClass) != none)
        {
            PC.ServerNotifyRadioman();
        }
        else
        {
            PC.ServerNotifyArtilleryOperators(MapMarkerClass);
        }
        PC.Pawn.ReceiveLocalizedMessage(class'DHFireSupportMessage', 0,,, MapMarkerClass);
        PC.ConsoleCommand("SPEECH SUPPORT 8");
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
