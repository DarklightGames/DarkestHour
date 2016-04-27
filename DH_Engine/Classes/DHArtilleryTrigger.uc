//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHArtilleryTrigger extends ROArtilleryTrigger;

var()   bool        bShouldShowOnSituationMap;
var()   float       TriggerDelay;

var     float       TriggerTime;
var     DHPawn      Carrier;
var     SoundGroup  CommonwealthRequestSound;
var     SoundGroup  CommonwealthConfirmSound;
var     SoundGroup  CommonwealthDenySound;

function UsedBy(Pawn User)
{
    local DHRoleInfo   RI;
    local DHPlayer     DHPC;
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

    // Don't let non-commanders call in arty
    if (RI == none || !RI.bIsArtilleryOfficer)
    {
        return;
    }

    DHPC = DHPlayer(User.Controller);

    // Bots can't call arty yet
    if (DHPC == none)
    {
        return;
    }

    // Exit if no co-ordinates selected (with message)
    if (DHPC.SavedArtilleryCoords == vect(0.0, 0.0, 0.0))
    {
        DHPC.ReceiveLocalizedMessage(class'ROArtilleryMsg', 4); // no co-ords selected

        return;
    }

    // Don't let the player call in an arty strike on a location that has become an active NoArtyVolume after they marked the location.
    VolumeTest = Spawn(class'DHVolumeTest', self,, DHPC.SavedArtilleryCoords);

    if (VolumeTest != none)
    {
        if (VolumeTest.IsInNoArtyVolume())
        {
            VolumeTest.Destroy();
            DHPC.ReceiveLocalizedMessage(class'ROArtilleryMsg', 5); // not a valid target

            return;
        }

        VolumeTest.Destroy();
    }

    // If player is of a team that can use this trigger, call in an arty strike
    if (ApprovePlayerTeam(DHPC.GetTeamNum()))
    {
        bAvailable = false;
        SavedUser = User;
        DHPC.ReceiveLocalizedMessage(class'ROArtilleryMsg', 1); // request strike

        if (DHPC.GetTeamNum() == AXIS_TEAM_INDEX)
        {
            RequestSound = GermanRequestSound;
        }
        else if (DarkestHourGame(Level.Game) != none && DarkestHourGame(Level.Game).DHLevelInfo != none)
        {
            switch (DarkestHourGame(Level.Game).DHLevelInfo.AlliedNation)
            {
                case NATION_USA:
                case NATION_Canada:
                    RequestSound = RussianRequestSound;
                    break;

                case NATION_Britain:
                    RequestSound = CommonwealthRequestSound;
                    break;
            }
        }

        User.PlaySound(RequestSound, SLOT_None, 3.0, false, 100.0, 1.0, true);
        SetTimer(GetSoundDuration(RequestSound), false);
    }
}

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
    RussianRequestSound=SoundGroup'DH_ArtillerySounds.requests.USrequest'
    RussianConfirmSound=SoundGroup'DH_US_Voice_Infantry.Artillery.confirm'
    RussianDenySound=SoundGroup'DH_US_Voice_Infantry.Artillery.Deny'
    CommonwealthRequestSound=SoundGroup'DH_ArtillerySounds.requests.britrequest'
    CommonwealthConfirmSound=SoundGroup'DH_Brit_Voice_Infantry.Artillery.confirm'
    CommonwealthDenySound=SoundGroup'DH_Brit_Voice_Infantry.Artillery.Deny'
}
