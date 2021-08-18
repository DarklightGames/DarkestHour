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

    PC.ServerIsArtilleryTargetValid(Location);
    if (PC.IsArtillerySpotter() && PC.bIsArtilleryTargetValid)
    {
        switch (Index)
        {
            case 0: // Artillery barrage
                AddNewArtilleryRequest(PC, MapLocation, Location, class'DH_Engine.DHMapMarker_FireSupport_OffMap');
                break;
            case 1: // Fire request (Smoke)
                AddNewArtilleryRequest(PC, MapLocation, Location, class'DH_Engine.DHMapMarker_FireSupport_Smoke');
                break;
            case 2: // Fire request (HE)
                AddNewArtilleryRequest(PC, MapLocation, Location, class'DH_Engine.DHMapMarker_FireSupport_HE');
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
    PC.ServerIsArtilleryTargetValid(HitLocation);
    if (PC.bIsArtilleryTargetValid)
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

function AddNewArtilleryRequest(DHPlayer PC, vector MapLocation, vector WorldLocation, class<DHMapMarker_FireSupport> MapMarkerClass)
{
    if (PC.IsArtilleryRequestingLocked())
    {
        PC.Pawn.ReceiveLocalizedMessage(class'DHFireSupportMessage', 1,,, PC);
    }
    else
    {
        PC.LockArtilleryRequests(PC.ArtilleryLockingPeriod);
        PC.AddMarker(MapMarkerClass, MapLocation.X, MapLocation.Y, WorldLocation);

        if (class<DHMapMarker_FireSupport_OffMap>(MapMarkerClass) != none)
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

function GetOptionRenderInfo(int OptionIndex, out OptionRenderInfo ORI)
{
    local class<DHMapMarker_FireSupport>  FireSupportRequestClass;
    local DHSquadReplicationInfo          SRI;
    local DHPlayer                        PC;
    local int                             SquadMembersCount;
    if (OptionIndex < 0 || OptionIndex >= Options.Length)
    {
        return;
    }

    FireSupportRequestClass = class<DHMapMarker_FireSupport>(Options[OptionIndex].OptionalObject);

    PC = GetPlayerController();

    if (FireSupportRequestClass != none)
    {
        PC = GetPlayerController();
        SRI = PC.SquadReplicationInfo;
        SquadMembersCount = SRI.GetMemberCount(PC.GetTeamNum(), PC.GetSquadIndex());
    }

    ORI.OptionName = Options[OptionIndex].ActionText;
    ORI.DescriptionText = Options[OptionIndex].DescriptionText;
    if(IsOptionDisabled(OptionIndex))
    {
        ORI.InfoColor = class'UColor'.default.Red;
        ORI.InfoText = SquadMembersCount @ "/" @ FireSupportRequestClass.default.RequiredSquadMembers;
    }
    else
    {
        ORI.InfoColor = class'UColor'.default.White;
        ORI.InfoText = Options[OptionIndex].SubjectText;
    }
}

function bool IsOptionDisabled(int OptionIndex)
{
    local class<DHMapMarker_FireSupport>  FireSupportRequestClass;
    local DHSquadReplicationInfo          SRI;
    local DHPlayer                        PC;
    local int                             SquadMembersCount;
    local DHGameReplicationInfo           GRI;

    if (Options[OptionIndex].OptionalObject == none)
    {
        return true;
    }

    FireSupportRequestClass = class<DHMapMarker_FireSupport>(Options[OptionIndex].OptionalObject);
    PC = GetPlayerController();
    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    SRI = PC.SquadReplicationInfo;

    if(PC != none && FireSupportRequestClass != none && GRI != none && SRI != none)
    {
        SquadMembersCount = SRI.GetMemberCount(PC.GetTeamNum(), PC.GetSquadIndex());
        if(SquadMembersCount < FireSupportRequestClass.default.RequiredSquadMembers)
        {
            return false;
        }
        switch(PC.GetTeamNum())
        {
            case AXIS_TEAM_INDEX:
                if(ClassIsChildOf(FireSupportRequestClass, class'DHMapMarker_FireSupport_OffMap'))
                {
                    return GRI.bOffMapArtilleryEnabledAxis;
                }
                else if(ClassIsChildOf(FireSupportRequestClass, class'DHMapMarker_FireSupport_OnMap'))
                {
                    return GRI.bOnMapArtilleryEnabledAxis;
                }
            case ALLIES_TEAM_INDEX:
                if(ClassIsChildOf(FireSupportRequestClass, class'DHMapMarker_FireSupport_OffMap'))
                {
                    return GRI.bOffMapArtilleryEnabledAllies;
                }
                else if(ClassIsChildOf(FireSupportRequestClass, class'DHMapMarker_FireSupport_OnMap'))
                {
                    return GRI.bOnMapArtilleryEnabledAllies;
                }
        }
    }

    return false;
}

defaultproperties
{
    // TODO: Icons
    Options(0)=(ActionText="Off-map support",Material=Texture'DH_InterfaceArt2_tex.Icons.fire',OptionalObject=class'DHMapMarker_FireSupport_OffMap')
    Options(1)=(ActionText="Fire Request (Smoke)",Material=Texture'DH_InterfaceArt2_tex.Icons.fire',OptionalObject=class'DHMapMarker_FireSupport_Smoke')
    Options(2)=(ActionText="Fire Request (HE)",Material=Texture'DH_InterfaceArt2_tex.Icons.fire',OptionalObject=class'DHMapMarker_FireSupport_HE')
 
    bShouldTick=true
}
