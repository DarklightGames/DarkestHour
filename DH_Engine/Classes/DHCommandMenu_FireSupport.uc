//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHCommandMenu_FireSupport extends DHCommandMenu;

var color DisabledColor;
var color EnabledColor;

enum EArtilleryStatus
{
    AS_DisabledGlobally,
    AS_DisabledNotEnoughMembers,
    AS_DisabledNoArtilleryVolume,
    AS_Enabled
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

    if (PC.IsArtillerySpotter()
        && PC.IsArtilleryTargetValid(Location)
        && GRI.IsArtilleryEnabled(PC.GetTeamNum()))
    {
        switch (Index)
        {
            case 0: // Artillery barrage
                AddNewArtilleryRequest(PC, MapLocation, Location, class'DH_Engine.DHMapMarker_FireSupport_ArtilleryBarrage');
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
        // "Not a Valid Artillery Target!"
        PC.ReceiveLocalizedMessage(class'ROArtilleryMsg', 5);
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
    local DHGameReplicationInfo   GRI;
    local bool                    bIsArtillerySpotter;
    local bool                    bIsArtilleryTargetValid;
    local bool                    bIsArtilleryEnabled;

    PC = GetPlayerController();

    if (PC == none || PC.SpottingMarker == none)
    {
        return;
    }

    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

    if (GRI == none)
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

    bIsArtillerySpotter = PC.IsArtillerySpotter();
    bIsArtilleryTargetValid = PC.IsArtilleryTargetValid(HitLocation);
    bIsArtilleryEnabled = false;
    switch (PC.GetTeamNum())
    {
        case AXIS_TEAM_INDEX:
            bIsArtilleryEnabled =  GRI.bOnMapArtilleryEnabledAxis || GRI.bOffMapArtilleryEnabledAxis;
            break;
        case ALLIES_TEAM_INDEX:
            bIsArtilleryEnabled =  GRI.bOnMapArtilleryEnabledAllies || GRI.bOffMapArtilleryEnabledAllies;
            break;
    }

    Log("bIsArtillerySpotter" @ bIsArtillerySpotter);
    Log("bIsArtilleryTargetValid" @ bIsArtilleryTargetValid);
    Log("bIsArtilleryEnabled" @ bIsArtilleryEnabled);
    Log("");

    if (bIsArtillerySpotter && bIsArtilleryTargetValid && bIsArtilleryEnabled)
    {
        PC.SpottingMarker.bIsDisabled = false;
        C = default.EnabledColor;
    }
    else
    {
        PC.SpottingMarker.bIsDisabled = true;
        C = default.DisabledColor;
    }

    PC.SpottingMarker.SetColor(C);
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

        if (MapMarkerClass.default.ArtilleryRange == AR_OffMap)
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

    switch (Status)
    {
        case EArtilleryStatus.AS_DisabledGlobally:
            ORI.InfoColor = class'UColor'.default.Red;
            ORI.InfoText = "Unavailable";
            break;
        case EArtilleryStatus.AS_DisabledNotEnoughMembers:
            ORI.InfoColor = class'UColor'.default.Red;
            ORI.InfoText = "Squad members:" @ SquadMembersCount @ "/" @ FireSupportRequestClass.default.RequiredSquadMembers;
            break;
        case EArtilleryStatus.AS_DisabledNoArtilleryVolume:
            ORI.InfoColor = class'UColor'.default.Red;
            ORI.InfoText = "No-artillery volume";
            break;
        case EArtilleryStatus.AS_Enabled:
            if(FireSupportRequestClass.default.ArtilleryRange == AR_OffMap)
            {
                ORI.InfoColor = class'UColor'.default.White;
                switch (PC.GetTeamNum())
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
            Warn("Unhandled artillery status:" @ Status);
            ORI.InfoColor = class'UColor'.default.Red;
            ORI.InfoText = "Unavailable";
            break;
    }
}

// This function should be merged with IsOptionDisabled
// IsOptionDisabled should be refactored to return an enum of values instead of bool...
function EArtilleryStatus GetArtilleryStatus(class<DHMapMarker_FireSupport> FireSupportRequestClass, DHPlayer PC, DHGameReplicationinfo GRI, DHSquadReplicationInfo SRI)
{
    local int SquadMembersCount;

    SquadMembersCount = SRI.GetMemberCount(PC.GetTeamNum(), PC.GetSquadIndex());

    if(SquadMembersCount < FireSupportRequestClass.default.RequiredSquadMembers)
    {
        return EArtilleryStatus.AS_DisabledNotEnoughMembers;
    }
    if (PC.SpottingMarker != none && PC.SpottingMarker.bIsDisabled)
    {
        return EArtilleryStatus.AS_DisabledNoArtilleryVolume;
    }

    switch (PC.GetTeamNum())
    {
        case AXIS_TEAM_INDEX:
            switch(FireSupportRequestClass.default.ArtilleryRange)
            {
                case AR_OffMap:
                    if(GRI.bOffMapArtilleryEnabledAxis)
                    {
                        return EArtilleryStatus.AS_Enabled;
                    }
                    else
                    {
                        return EArtilleryStatus.AS_DisabledGlobally;
                    }
                case AR_OnMap:
                    if(GRI.bOnMapArtilleryEnabledAxis)
                    {
                        return EArtilleryStatus.AS_Enabled;
                    }
                    else
                    {
                        return EArtilleryStatus.AS_DisabledGlobally;
                    }
            }
        case ALLIES_TEAM_INDEX:
            switch(FireSupportRequestClass.default.ArtilleryRange)
            {
                case AR_OffMap:
                    if(GRI.bOffMapArtilleryEnabledAllies)
                    {
                        return EArtilleryStatus.AS_Enabled;
                    }
                    else
                    {
                        return EArtilleryStatus.AS_DisabledGlobally;
                    }
                case AR_OnMap:
                    if(GRI.bOnMapArtilleryEnabledAllies)
                    {
                        return EArtilleryStatus.AS_Enabled;
                    }
                    else
                    {
                        return EArtilleryStatus.AS_DisabledGlobally;
                    }
            }
    }

    Warn("ArtilleryStatus(): Something went really bad. This code should not be reached." @ self @ "will not work.");
}

function bool IsOptionDisabled(int OptionIndex)
{
    local class<DHMapMarker_FireSupport>  FireSupportRequestClass;
    local DHSquadReplicationInfo          SRI;
    local DHPlayer                        PC;
    local DHGameReplicationInfo           GRI;

    if (OptionIndex < 0 || OptionIndex >= Options.Length || Options[OptionIndex].OptionalObject == none)
    {
        return true;
    }

    FireSupportRequestClass = class<DHMapMarker_FireSupport>(Options[OptionIndex].OptionalObject);
    PC = GetPlayerController();
    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    SRI = PC.SquadReplicationInfo;

    if (PC != none && FireSupportRequestClass != none && GRI != none && SRI != none)
    {
        return GetArtilleryStatus(FireSupportRequestClass, PC, GRI, SRI) != EArtilleryStatus.AS_Enabled;
    }

    return true;
}

defaultproperties
{
    Options(0)=(OptionalObject=class'DHMapMarker_FireSupport_ArtilleryBarrage',Material=Texture'DH_InterfaceArt2_tex.Icons.Artillery')
    Options(1)=(OptionalObject=class'DHMapMarker_FireSupport_Smoke',Material=Texture'DH_InterfaceArt2_tex.Icons.fire')
    Options(2)=(OptionalObject=class'DHMapMarker_FireSupport_HE',Material=Texture'DH_InterfaceArt2_tex.Icons.fire')

    bShouldTick=true

    DisabledColor=(B=0,G=0,R=255,A=255)
    EnabledColor=(B=0,G=255,R=0,A=255)
}
