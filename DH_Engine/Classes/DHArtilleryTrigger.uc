//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHArtilleryTrigger extends ROArtilleryTrigger;

var()   bool        bShouldShowOnSituationMap;    // whether HUD overhead map should show an icon to mark this arty trigger's position
var()   float       TriggerDelay;                 // time in seconds between repeat use of this trigger

var     float       TriggerTime;                  // last time this trigger was used
var     DHPawn      Carrier;                      // a radioman player pawn that is carrying this arty trigger

var     SoundGroup  AlliedNationRequestSounds[4]; // voice sounds for different allies nations (USA = 0, Britain = 1, Canada = 2, Soviet Union = 3)
var     SoundGroup  AlliedNationConfirmSounds[4];
var     SoundGroup  AlliedNationDenySounds[4];

// Modified so only arty officer roles can call in arty, & to use request sounds for different allies nations
// Also to stop a player calling arty if they are on fire or if their weapons have been locked (for spawn killing)
function UsedBy(Pawn User)
{
    local DHRoleInfo   RI;
    local DHPlayer     PC;
    local DHVolumeTest VolumeTest;
    local sound        RequestSound;

    if (!bAvailable || User == none)
    {
       return;
    }

    SavedUser = none;

    if (DHPawn(User) != none)
    {
        RI = DHPawn(User).GetRoleInfo();
    }

    // Only allow arty officer roles to call in arty
    if (RI == none || !RI.bIsArtilleryOfficer)
    {
        return;
    }

    PC = DHPlayer(User.Controller);

    // Bots can't call arty
    if (PC == none)
    {
        return;
    }

    // Don't let player call arty if his weapons have been locked due to spawn killing
    // Unlike weapon fire, we have no way of stopping this on the player's client, so we rely on the server to prevent arty use
    if (PC.AreWeaponsLocked())
    {
        return;
    }

    // Exit if no arty co-ordinates selected (with message)
    if (PC.SavedArtilleryCoords == vect(0.0, 0.0, 0.0))
    {
        PC.ReceiveLocalizedMessage(class'ROArtilleryMsg', 4); // no co-ords selected

        return;
    }

    // Don't let the player call in an arty strike on a location that has become an active NoArtyVolume after they marked the location.
    VolumeTest = Spawn(class'DHVolumeTest', self,, PC.SavedArtilleryCoords);

    if (VolumeTest != none)
    {
        if (VolumeTest.IsInNoArtyVolume())
        {
            VolumeTest.Destroy();
            PC.ReceiveLocalizedMessage(class'ROArtilleryMsg', 5); // not a valid target

            return;
        }

        VolumeTest.Destroy();
    }

    // If player is of a team that can use this trigger, call in an arty strike
    if (ApprovePlayerTeam(PC.GetTeamNum())) // TODO: move this simple check up above the no arty volume test, so quick check is done before spawning & destroying a volume test actor
    {
        bAvailable = false;
        SavedUser = User;
        PC.ReceiveLocalizedMessage(class'ROArtilleryMsg', 1); // request strike
        RequestSound = GetRequestSound(PC.GetTeamNum());
        User.PlaySound(RequestSound, SLOT_None, 3.0, false, 100.0, 1.0, true);
        SetTimer(GetSoundDuration(RequestSound), false);
    }
}

function sound GetRequestSound(int TeamIndex)
{
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI != none)
    {
        switch (TeamIndex)
        {
            case AXIS_TEAM_INDEX:
                return GermanRequestSound;
            case ALLIES_TEAM_INDEX:
                return AlliedNationRequestSounds[GRI.AlliedNationID];
        }
    }

    return none;
}

function sound GetConfirmSound(int TeamIndex)
{
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI != none)
    {
        switch (TeamIndex)
        {
            case AXIS_TEAM_INDEX:
                return GermanConfirmSound;
            case ALLIES_TEAM_INDEX:
                return AlliedNationConfirmSounds[GRI.AlliedNationID];
        }
    }

    return none;
}

function sound GetDenySound(int TeamIndex)
{
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI != none)
    {
        switch (TeamIndex)
        {
            case AXIS_TEAM_INDEX:
                return GermanDenySound;
            case ALLIES_TEAM_INDEX:
                return AlliedNationDenySounds[GRI.AlliedNationID];
        }
    }

    return none;
}

// Modified so only arty officer roles can call in arty, & to add a TriggerDelay time before this trigger can be used again
function Touch(Actor Other)
{
    local Pawn P;
    local DHPlayerReplicationInfo PRI;

    P = Pawn(Other);

    if (P == none)
    {
        return;
    }

    PRI = DHPlayerReplicationInfo(P.PlayerReplicationInfo);

    // Check touching player is an artillery officer of a team that can use this trigger
    if (PRI != none && DHRoleInfo(PRI.RoleInfo) != none && DHRoleInfo(PRI.RoleInfo).bIsArtilleryOfficer && ApprovePlayerTeam(P.GetTeamNum()))
    {
        if (TriggerDelay > 0.0)
        {
            if ((Level.TimeSeconds - TriggerTime) < TriggerDelay)
            {
                return; // can't be used again yet
            }

            TriggerTime = Level.TimeSeconds;
        }

        if (!P.IsHumanControlled())
        {
            UsedBy(P); // bot uses the arty trigger immediately
        }
        else if (Message != "")
        {
            P.ClientMessage(Message); // display a 'use' string message to the touching player
        }
    }
}

defaultproperties
{
    bShouldShowOnSituationMap=true
    TriggerDelay=5.0
    Message="Request artillery support from HQ"

    // USA
    AlliedNationRequestSounds(0)=SoundGroup'DH_ArtillerySounds.requests.USrequest'
    AlliedNationConfirmSounds(0)=SoundGroup'DH_US_Voice_Infantry.Artillery.confirm'
    AlliedNationDenySounds(0)=SoundGroup'DH_US_Voice_Infantry.Artillery.Deny'

    // Britain
    AlliedNationRequestSounds(1)=SoundGroup'DH_ArtillerySounds.requests.britrequest'
    AlliedNationConfirmSounds(1)=SoundGroup'DH_Brit_Voice_Infantry.Artillery.confirm'
    AlliedNationDenySounds(1)=SoundGroup'DH_Brit_Voice_Infantry.Artillery.Deny'

    // Canada
    AlliedNationRequestSounds(2)=SoundGroup'DH_ArtillerySounds.requests.USrequest'
    AlliedNationConfirmSounds(2)=SoundGroup'DH_US_Voice_Infantry.Artillery.confirm'
    AlliedNationDenySounds(2)=SoundGroup'DH_US_Voice_Infantry.Artillery.Deny'

    // USSR
    AlliedNationRequestSounds(3)=SoundGroup'Artillery.Request.RusRequest'
    AlliedNationConfirmSounds(3)=SoundGroup'voice_sov_infantry.artillery.confirm'
    AlliedNationDenySounds(3)=SoundGroup'voice_sov_infantry.artillery.Deny'
}

