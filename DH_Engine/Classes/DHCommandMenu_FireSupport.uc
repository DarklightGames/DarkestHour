//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHCommandMenu_FireSupport extends DHCommandMenu;

var color DisabledColor;
var color EnabledColor;

var localized string UnavailableText;
var localized string InvalidTargetText;
var localized string AvailableText;

enum EArtilleryStatus
{
    AS_DisabledGlobally,
    AS_DisabledNotEnoughMembers,
    AS_DisabledNoArtilleryVolume,
    AS_Enabled,
    AS_Fatal
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
        && GRI.IsArtilleryEnabled(PC.GetTeamNum())
        && PC.IsArtilleryTargetValid(Location))
    {
        AddNewArtilleryRequest(PC, MapLocation, Location, class<DHMapMarker_FireSupport>(Options[Index].OptionalObject));
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

    if (PC != none && PC.SpottingMarker != none)
    {
        PC.SpottingMarker.Destroy();
    }
}

function Tick()
{
    local DHPlayer                PC;
    local vector                  HitLocation, HitNormal;
    local Color                   C;
    local DHGameReplicationInfo   GRI;

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

    if (PC.IsArtillerySpotter()
        && GRI.IsArtilleryEnabled(PC.GetTeamNum())
        && PC.IsArtilleryTargetValid(HitLocation))
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
    if (PC == none || MapMarkerClass == none)
    {
        return;
    }

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
    }
}

function GetOptionRenderInfo(int OptionIndex, out OptionRenderInfo ORI)
{
    local class<DHMapMarker_FireSupport>  FireSupportRequestClass;
    local DHSquadReplicationInfo          SRI;
    local DHPlayer                        PC;
    local int                             SquadMembersCount, AvailableCount;
    local DHGameReplicationInfo           GRI;

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

    switch (GetArtilleryStatus(FireSupportRequestClass, PC, GRI, SRI))
    {
        case AS_DisabledNotEnoughMembers:
            ORI.InfoColor = class'UColor'.default.Red;
            ORI.InfoIcon = Texture'DH_InterfaceArt2_tex.Icons.squad';
            ORI.InfoText = string(SquadMembersCount) @ "/" @ FireSupportRequestClass.default.RequiredSquadMembers;
            break;
        case AS_DisabledNoArtilleryVolume:
            ORI.InfoColor = class'UColor'.default.Red;
            ORI.InfoIcon = Texture'DH_GUI_tex.DeployMenu.spawn_point_disabled';
            ORI.InfoText = default.InvalidTargetText;
            break;
        case AS_Enabled:
            if (FireSupportRequestClass.default.ArtilleryRange == AR_OffMap)
            {
                ORI.InfoColor = class'UColor'.default.White;
                AvailableCount = GRI.ArtilleryTypeInfos[PC.GetTeamNum()].Limit - GRI.ArtilleryTypeInfos[PC.GetTeamNum()].UsedCount;
                ORI.InfoText = Repl(default.AvailableText, "{0}", AvailableCount);
            }
            else
            {
                ORI.InfoColor = class'UColor'.default.White;
                ORI.InfoText = Options[OptionIndex].SubjectText;
            }
            break;
        case AS_DisabledGlobally:
        case AS_Fatal:
        default:
            ORI.InfoColor = class'UColor'.default.Red;
            ORI.InfoIcon = Texture'DH_GUI_tex.DeployMenu.spawn_point_disabled';
            ORI.InfoText = default.UnavailableText;
            break;
    }
}

// TODO: this function should live in DHPlayer and should take the candidate
// location instead of messing around with the spotting marker to indicate state.
function EArtilleryStatus GetArtilleryStatus(class<DHMapMarker_FireSupport> FireSupportRequestClass, DHPlayer PC, DHGameReplicationinfo GRI, DHSquadReplicationInfo SRI)
{
    local int SquadMembersCount;

    SquadMembersCount = SRI.GetMemberCount(PC.GetTeamNum(), PC.GetSquadIndex());

    if (SquadMembersCount < FireSupportRequestClass.default.RequiredSquadMembers)
    {
        return AS_DisabledNotEnoughMembers;
    }

    // TODO: Why on earth are we doing this here?! the spotting marker should
    // not be used as a data passthru for this.
    if (PC.SpottingMarker != none && PC.SpottingMarker.bIsDisabled)
    {
        return AS_DisabledNoArtilleryVolume;
    }

    switch (FireSupportRequestClass.default.ArtilleryRange)
    {
        case AR_OffMap:
            if (GRI.bOffMapArtilleryEnabled[PC.GetTeamNum()] == 1)
            {
                return AS_Enabled;
            }
            else
            {
                return AS_DisabledGlobally;
            }
        case AR_OnMap:
            if (GRI.bOnMapArtilleryEnabled[PC.GetTeamNum()] == 1)
            {
                return AS_Enabled;
            }
            else
            {
                return AS_DisabledGlobally;
            }
    }

    return AS_Fatal;
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
        return GetArtilleryStatus(FireSupportRequestClass, PC, GRI, SRI) != AS_Enabled;
    }

    return true;
}

defaultproperties
{
    Options(0)=(OptionalObject=class'DHMapMarker_FireSupport_ArtilleryBarrage',Material=Texture'DH_InterfaceArt2_tex.Icons.Artillery')
    Options(1)=(OptionalObject=class'DHMapMarker_FireSupport_Smoke',Material=Texture'DH_InterfaceArt2_tex.Icons.fire')
    Options(2)=(OptionalObject=class'DHMapMarker_FireSupport_HE',Material=Texture'DH_InterfaceArt2_tex.Icons.fire')

    UnavailableText="Unavailable"
    InvalidTargetText="Invalid target"
    AvailableText="{0} available"

    bShouldTick=true

    DisabledColor=(B=0,G=0,R=255,A=255)
    EnabledColor=(B=0,G=255,R=0,A=255)
}
