//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHCommandMenu_FireSupport extends DHCommandMenu;

enum EArtilleryStatus
{
    DisabledGlobally,
    DisabledNotEnoughMembers,
    Enabled
};

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
    local DHPlayer                PC;
    local vector                  HitLocation, HitNormal;
    local Color                   C;
    local bool                    bArtillerySupportEnabled;
    local DHGameReplicationInfo   GRI;

    bArtillerySupportEnabled = false;

    C.R = 0;
    C.G = 0;
    C.B = 0;
    C.A = 0;

    PC = GetPlayerController();
    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

    if (PC == none || PC.SpottingMarker == none || GRI == none)
    {
        return;
    }

    // Hide the interaction if the player somehow stops using the binoculars
    // (eg. proning, getting their weapon shot out of their hands etc.)
    if (PC.Pawn != none && PC.Pawn.Weapon != none && !PC.Pawn.Weapon.bUsingSights)
    {
        Interaction.Hide();
        return;
    }

    PC.GetEyeTraceLocation(HitLocation, HitNormal);
    PC.ServerIsArtilleryTargetValid(HitLocation);
    switch(PC.GetTeamNum())
    {
        case AXIS_TEAM_INDEX:
            bArtillerySupportEnabled = GRI.bOnMapArtilleryEnabledAxis || GRI.bOffMapArtilleryEnabledAxis;
            break;
        case ALLIES_TEAM_INDEX:
            bArtillerySupportEnabled = GRI.bOnMapArtilleryEnabledAllies || GRI.bOffMapArtilleryEnabledAllies;
            break;
    }
    if (PC.bIsArtilleryTargetValid && bArtillerySupportEnabled)
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
    local int                             SquadMembersCount, AvailableCount;
    local DHGameReplicationInfo           GRI;
    local EArtilleryStatus                Status;

    FireSupportRequestClass = class<DHMapMarker_FireSupport>(Options[OptionIndex].OptionalObject);
    PC = GetPlayerController();
    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    SRI = PC.SquadReplicationInfo;

    if (OptionIndex < 0 || OptionIndex >= Options.Length || SRI == none || PC == none || GRI == none || FireSupportRequestClass == none)
    {
        return;
    }
    
    SquadMembersCount = SRI.GetMemberCount(PC.GetTeamNum(), PC.GetSquadIndex());

    ORI.OptionName = FireSupportRequestClass.default.MarkerName;
    ORI.DescriptionText = "";

    Status = GetArtilleryStatus(FireSupportRequestClass, PC, GRI, SRI);

    switch(Status)
    {
        case EArtilleryStatus.DisabledGlobally:
            ORI.InfoColor = class'UColor'.default.Red;
            ORI.InfoText = "Option disabled";
            break;
        case EArtilleryStatus.DisabledNotEnoughMembers:
            ORI.InfoColor = class'UColor'.default.Red;
            ORI.InfoText = "Squad members:" @ SquadMembersCount @ "/" @ FireSupportRequestClass.default.RequiredSquadMembers;
            break;
        case EArtilleryStatus.Enabled:
            if(ClassIsChildOf(FireSupportRequestClass, class'DHMapMarker_FireSupport_OffMap'))
            {
                ORI.InfoColor = class'UColor'.default.White;
                switch(PC.GetTeamNum())
                {
                    case AXIS_TEAM_INDEX:
                        AvailableCount = GRI.ArtilleryTypeInfos[AXIS_TEAM_INDEX].Limit - GRI.ArtilleryTypeInfos[AXIS_TEAM_INDEX].UsedCount;
                    case ALLIES_TEAM_INDEX:
                        AvailableCount = GRI.ArtilleryTypeInfos[ALLIES_TEAM_INDEX].Limit - GRI.ArtilleryTypeInfos[ALLIES_TEAM_INDEX].UsedCount;
                }
                ORI.InfoText = "Available count: " $ AvailableCount;
            }
            else
            {
                ORI.InfoColor = class'UColor'.default.White;
                ORI.InfoText = Options[OptionIndex].SubjectText;
            }
            break;
        default:
            ORI.InfoColor = class'UColor'.default.Red;
            ORI.InfoText = "Something went really wrong";
            break;
    }
}

// This function should be merged with IsOptionDisabled
// IsOptionDisabled should be refactored to return an enum of values instead of bool... 
function EArtilleryStatus GetArtilleryStatus(class<DHMapMarker_FireSupport> FireSupportRequestClass, DHPlayer PC, DHGameReplicationinfo GRI, DHSquadReplicationInfo SRI)
{
    local int                             SquadMembersCount;

    SquadMembersCount = SRI.GetMemberCount(PC.GetTeamNum(), PC.GetSquadIndex());
    switch(PC.GetTeamNum())
    {
        case AXIS_TEAM_INDEX:
            if(ClassIsChildOf(FireSupportRequestClass, class'DHMapMarker_FireSupport_OffMap')
              && GRI.bOffMapArtilleryEnabledAxis
              && SquadMembersCount >= FireSupportRequestClass.default.RequiredSquadMembers)
            {
                return EArtilleryStatus.Enabled;
            }
            else if(ClassIsChildOf(FireSupportRequestClass, class'DHMapMarker_FireSupport_OffMap')
              && !GRI.bOffMapArtilleryEnabledAxis)
            {
                return EArtilleryStatus.DisabledGlobally;
            }
            else if(ClassIsChildOf(FireSupportRequestClass, class'DHMapMarker_FireSupport_OnMap')
              && GRI.bOnMapArtilleryEnabledAxis
              && SquadMembersCount >= FireSupportRequestClass.default.RequiredSquadMembers)
            {
                return EArtilleryStatus.Enabled;
            }
            else if(ClassIsChildOf(FireSupportRequestClass, class'DHMapMarker_FireSupport_OnMap')
              && !GRI.bOnMapArtilleryEnabledAxis)
            {
                return EArtilleryStatus.DisabledGlobally;
            }
        case ALLIES_TEAM_INDEX:
            if(ClassIsChildOf(FireSupportRequestClass, class'DHMapMarker_FireSupport_OffMap')
              && GRI.bOffMapArtilleryEnabledAllies
              && SquadMembersCount >= FireSupportRequestClass.default.RequiredSquadMembers)
            {
                return EArtilleryStatus.Enabled;
            }
            else if(ClassIsChildOf(FireSupportRequestClass, class'DHMapMarker_FireSupport_OffMap')
              && !GRI.bOffMapArtilleryEnabledAllies)
            {
                return EArtilleryStatus.DisabledGlobally;
            }
            else if(ClassIsChildOf(FireSupportRequestClass, class'DHMapMarker_FireSupport_OnMap')
              && GRI.bOnMapArtilleryEnabledAllies
              && SquadMembersCount >= FireSupportRequestClass.default.RequiredSquadMembers)
            {
                return EArtilleryStatus.Enabled;
            }
            else if(ClassIsChildOf(FireSupportRequestClass, class'DHMapMarker_FireSupport_OnMap')
              && !GRI.bOnMapArtilleryEnabledAllies)
            {
                return EArtilleryStatus.DisabledGlobally;
            }
    }
    if(SquadMembersCount < FireSupportRequestClass.default.RequiredSquadMembers)
    {
        return EArtilleryStatus.DisabledNotEnoughMembers;
    }
    else
    {
        Warn("ArtilleryStatus(): Something went really bad." @ self @ "will not work.");
    }
}

function bool IsOptionDisabled(int OptionIndex)
{
    local class<DHMapMarker_FireSupport>  FireSupportRequestClass;
    local DHSquadReplicationInfo          SRI;
    local DHPlayer                        PC;
    local DHGameReplicationInfo           GRI;
    local EArtilleryStatus                Status;

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
        Status = GetArtilleryStatus(FireSupportRequestClass, PC, GRI, SRI);
        switch(Status)
        {
            case EArtilleryStatus.Enabled:
                return false;
            case EArtilleryStatus.DisabledGlobally:
                return true;
            case EArtilleryStatus.DisabledNotEnoughMembers:
                return true;
        }
    }

    return true;
}

defaultproperties
{
    Options(0)=(OptionalObject=class'DHMapMarker_FireSupport_OffMap')
    Options(1)=(OptionalObject=class'DHMapMarker_FireSupport_Smoke')
    Options(2)=(OptionalObject=class'DHMapMarker_FireSupport_HE')
 
    bShouldTick=true
}
