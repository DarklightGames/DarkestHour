//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHCommandMenu_FireSupport extends DHCommandMenu
    dependson(DHFireSupport)
    dependson(DHGameReplicationInfo);

// TODO: this should belong in the marker class, not here
var color DisabledColor;
var color EnabledColor;

var localized string UnavailableText;
var localized string InvalidTargetText;
var localized string OffMapSupportExhaustedText;
var localized string AvailableArtilleryText;
var localized string AvailableParadropsText;
var localized string AvailableAirstrikesText;

var struct SFireSupportState
{
    var DHFireSupport.EFireSupportError Error;
    var vector HitLocation;
} FireSupportState;

var array<DHGameReplicationInfo.SAvailableArtilleryInfoEntry> AvailableOffMapSupportArray; // cached available artillery support info

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

    if (PC.IsArtilleryTargetValid(Location))
    {
        PC.AddFireSupportRequest(MapLocation, Location, class<DHMapMarker>(Options[Index].OptionalObject));
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

function class<DHMapMarker> GetSelectedMapMarkerClass()
{
    if (Interaction.SelectedIndex == -1)
    {
        return none;
    }

    return class<DHMapMarker>(Options[Interaction.SelectedIndex].OptionalObject);
}

function DHFireSupport.EFireSupportError GetFireSupportError(DHPlayer PC, class<DHMapMarker> FireSupportRequestClass)
{
    local int SquadMembersCount;
    local DHGameReplicationInfo GRI;
    local DHSquadReplicationInfo SRI;

    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    SRI = PC.SquadReplicationInfo;

    if (GRI == none || SRI == none || FireSupportRequestClass == none
      || !(FireSupportRequestClass.default.Type == MT_OffMapArtilleryRequest
        || FireSupportRequestClass.default.Type == MT_OnMapArtilleryRequest))
    {
        return FSE_Fatal;
    }

    if (!PC.IsArtillerySpotter())
    {
        return FSE_InsufficientPrivileges;
    }

    switch (FireSupportRequestClass.default.Type)
    {
        case MT_OffMapArtilleryRequest:
            if (GRI.bOffMapArtilleryEnabled[PC.GetTeamNum()] == 0)
            {
                return FSE_Disabled;
            }
            AvailableOffMapSupportArray = GRI.GetTeamOffMapFireSupportCountRemaining(PC.GetTeamNum());
            if(AvailableOffMapSupportArray.Length == 0)
            {
                return FSE_Exhausted;
            }
            break;
        case MT_OnMapArtilleryRequest:
            if (GRI.bOnMapArtilleryEnabled[PC.GetTeamNum()] == 0)
            {
                return FSE_Disabled;
            }
            break;
        default:
            Warn("Unknown artillery type class passed to GetFireSupportError");
            return FSE_Fatal;
    }

    SquadMembersCount = SRI.GetMemberCount(PC.GetTeamNum(), PC.GetSquadIndex());

    if (PC.Level.NetMode != NM_Standalone && SquadMembersCount < FireSupportRequestClass.default.RequiredSquadMembers)
    {
        return FSE_NotEnoughSquadmates;
    }

    return FSE_None;
}

function DHFireSupport.EFireSupportError GetFireSupportErrorWithLocation(DHPlayer PC, class<DHMapMarker> FireSupportRequestClass, vector WorldLocation)
{
    local DHFireSupport.EFireSupportError Error;

    Error = GetFireSupportError(PC, FireSupportRequestClass);

    if (Error != FSE_None)
    {
        return Error;
    }

    if (!PC.IsArtilleryTargetValid(WorldLocation))
    {
        return FSE_InvalidLocation;
    }

    return FSE_None;
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

    FireSupportState.Error = GetFireSupportErrorWithLocation(PC, GetSelectedMapMarkerClass(), HitLocation);
    FireSupportState.HitLocation = HitLocation;

    if (FireSupportState.Error == FSE_None)
    {
        C = default.EnabledColor;
    }
    else
    {
        C = default.DisabledColor;
    }

    PC.SpottingMarker.SetColor(C);
    PC.SpottingMarker.SetLocation(HitLocation);
    PC.SpottingMarker.SetRotation(QuatToRotator(QuatFindBetween(HitNormal, vect(0, 0, 1))));
}

function GetOptionRenderInfo(int OptionIndex, out OptionRenderInfo ORI)
{
    local class<DHMapMarker>                                        FireSupportRequestClass;
    local DHSquadReplicationInfo                                    SRI;
    local DHPlayer                                                  PC;
    local int                                                       i, SquadMembersCount;
    local int                                                       AvailableBarrages, AvailableParadrops, AvailableAirstrikes;
    local DHGameReplicationInfo                                     GRI;

    FireSupportRequestClass = class<DHMapMarker>(Options[OptionIndex].OptionalObject);
    PC = GetPlayerController();
    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    SRI = PC.SquadReplicationInfo;

    if (OptionIndex < 0 || OptionIndex >= Options.Length || SRI == none || PC == none || GRI == none || FireSupportRequestClass == none)
    {
        return;
    }

    if(!(FireSupportRequestClass.default.Type == MT_OffMapArtilleryRequest
      || FireSupportRequestClass.default.Type == MT_OnMapArtilleryRequest))
    {
        Warn("Unknown marker type passed to DHCommandMenu_FireSupport.GetOptionRenderInfo():" @ FireSupportRequestClass);
        return;
    }

    ORI.OptionName = FireSupportRequestClass.default.MarkerName;

    switch (FireSupportState.Error)
    {
        case FSE_None:
            if (FireSupportRequestClass.default.Type == MT_OffMapArtilleryRequest)
            {
                ORI.InfoColor = class'UColor'.default.White;
                for(i = 0; i < AvailableOffMapSupportArray.Length; ++i)
                {
                    switch(AvailableOffMapSupportArray[i].Type)
                    {
                        case ArtyType_Barrage:
                          AvailableBarrages = AvailableOffMapSupportArray[i].Count;
                          break;
                        case ArtyType_Paradrop:
                          AvailableParadrops = AvailableOffMapSupportArray[i].Count;
                          break;
                        case ArtyType_Airstrikes:
                          AvailableAirstrikes = AvailableOffMapSupportArray[i].Count;
                          break;
                    }
                }
                i = 0;
                if (AvailableBarrages > 0)
                {
                    ORI.InfoText[i++] = Repl(default.AvailableArtilleryText, "{0}", AvailableBarrages);
                }
                if (AvailableParadrops > 0)
                {
                    ORI.InfoText[i++] = Repl(default.AvailableParadropsText, "{0}", AvailableParadrops);
                }
                if (AvailableAirstrikes > 0)
                {
                    ORI.InfoText[i++] = Repl(default.AvailableAirstrikesText, "{0}", AvailableAirstrikes);
                }
            }
            else if (FireSupportRequestClass.default.Type == MT_OnMapArtilleryRequest)
            {
                ORI.InfoColor = class'UColor'.default.White;
                ORI.InfoText[0] = Options[OptionIndex].SubjectText;
            }
            break;
        case FSE_Exhausted:
            ORI.InfoColor = class'UColor'.default.Red;
            ORI.InfoText[0] = default.OffMapSupportExhaustedText;
            break;
        case FSE_NotEnoughSquadmates:
            SquadMembersCount = SRI.GetMemberCount(PC.GetTeamNum(), PC.GetSquadIndex());
            ORI.InfoColor = class'UColor'.default.Red;
            ORI.InfoIcon = Texture'DH_InterfaceArt2_tex.Icons.squad';
            ORI.InfoText[0] = string(SquadMembersCount) @ "/" @ FireSupportRequestClass.default.RequiredSquadMembers;
            break;
        case FSE_InvalidLocation:
            ORI.InfoColor = class'UColor'.default.Red;
            ORI.InfoIcon = Texture'DH_GUI_tex.DeployMenu.spawn_point_disabled';
            ORI.InfoText[0] = default.InvalidTargetText;
            break;
        case FSE_InsufficientPrivileges:
        case FSE_Disabled:
        case FSE_Fatal:
        default:
            ORI.InfoColor = class'UColor'.default.Red;
            ORI.InfoIcon = Texture'DH_GUI_tex.DeployMenu.spawn_point_disabled';
            ORI.InfoText[0] = default.UnavailableText;
            break;
    }
}

function bool IsOptionDisabled(int OptionIndex)
{
    local class<DHMapMarker>  FireSupportRequestClass;
    local DHPlayer            PC;

    if (OptionIndex < 0 || OptionIndex >= Options.Length || Options[OptionIndex].OptionalObject == none)
    {
        return true;
    }

    FireSupportRequestClass = class<DHMapMarker>(Options[OptionIndex].OptionalObject);
    PC = GetPlayerController();

    return PC == none || GetFireSupportError(PC, FireSupportRequestClass) != FSE_None;
}

defaultproperties
{
    Options(0)=(OptionalObject=class'DHMapMarker_FireSupport_OffMap',Material=Texture'DH_InterfaceArt2_tex.Icons.Artillery')
    Options(1)=(OptionalObject=class'DHMapMarker_FireSupport_Smoke',Material=Texture'DH_InterfaceArt2_tex.Icons.fire')
    Options(2)=(OptionalObject=class'DHMapMarker_FireSupport_HE',Material=Texture'DH_InterfaceArt2_tex.Icons.fire')

    UnavailableText="Unavailable"
    InvalidTargetText="Invalid target"
    OffMapSupportExhaustedText="Exhausted"
    AvailableArtilleryText="Artillery: {0}"
    AvailableParadropsText="Paradrops: {0}"
    AvailableAirstrikesText="Airstrikes: {0}"

    bShouldTick=true

    DisabledColor=(B=0,G=0,R=255,A=255)
    EnabledColor=(B=0,G=255,R=0,A=255)
}
