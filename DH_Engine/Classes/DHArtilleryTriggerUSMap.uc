//=============================================================================
//  DH_ArtilleryTrigger - Arty radio that can be carried by a player or vehicle
//=============================================================================

class DHArtilleryTriggerUSMap extends DHArtilleryTrigger;

var()   float   TriggerDelay;
var     float   TriggerTime;
var     DH_Pawn Carrier;

function UsedBy(Pawn user)
{
    local DHPlayer DHPC;
    local ROVolumeTest VolumeTest;
    local DHPlayerReplicationInfo PRI;
    local DH_RoleInfo RI;
    local bool bIsInNoArtyVolume;

    if (!bAvailable)
    {
       return;
    }

    SavedUser = none;

    if (user.Controller != none)
    {
        DHPC = DHPlayer(user.Controller);
    }

    // Bots can't call arty yet
    if (DHPC == none)
    {
        return;
    }

    PRI = DHPlayerReplicationInfo(DHPC.PlayerReplicationInfo);

    if (DH_Pawn(user) == none)
    {
        return;
    }

    RI = DH_Pawn(user).GetRoleInfo();

    // Don't let non-commanders call in arty
    if (PRI == none || RI == none || !RI.bIsArtilleryOfficer)
    {
        return;
    }

    if (DHPC != none && DHPC.SavedArtilleryCoords == vect(0, 0, 0))
    {
        DHPC.ReceiveLocalizedMessage(class'ROArtilleryMsg', 4);

        return;
    }

    // Don't let the player call in an arty strike on a location that has become an active
    // NoArtyVolume after they marked the location.
    if (DHPC != none)
    {
        VolumeTest = Spawn(class'ROVolumeTest', self,, DHPC.SavedArtilleryCoords);

        if (VolumeTest != none)
        {
            bIsInNoArtyVolume = VolumeTest.IsInNoArtyVolume();
        }

        VolumeTest.Destroy();

        if (bIsInNoArtyVolume)
        {
            DHPC.ReceiveLocalizedMessage(class'ROArtilleryMsg', 5);

            return;
        }
    }

    if (ApprovePlayerTeam(user.GetTeamNum()))
    {
        SavedUser = user;
        bAvailable = false;

        if (SavedUser.Controller != none)
        {
            DHPC = DHPlayer(SavedUser.Controller);
        }

        if (DHPC != none)
        {
            DHPC.ReceiveLocalizedMessage(class'ROArtilleryMsg', 1);
        }

        if (user.GetTeamNum() == AXIS_TEAM_INDEX)
        {
            user.PlaySound(GermanRequestSound, SLOT_None, 3.0, false, 100, 1.0,true);

            SetTimer(GetSoundDuration(GermanRequestSound), false);
        }
        else
        {
            user.PlaySound(RussianRequestSound, SLOT_None, 3.0, false, 100, 1.0,true);

            SetTimer(GetSoundDuration(RussianRequestSound), false);
        }
    }
}

function Touch(Actor Other)
{
    local DHPlayerReplicationInfo PRI;
    local Pawn P;
    local DH_RoleInfo RI;

    P = Pawn(Other);

    if (P == none)
    {
        return;
    }

    PRI = DHPlayerReplicationInfo(P.PlayerReplicationInfo);

    if (PRI == none || PRI.RoleInfo == none)
    {
        return;
    }

    RI = DH_RoleInfo(PRI.RoleInfo);

    if (RI != none && RI.bIsArtilleryOfficer && ApprovePlayerTeam(P.GetTeamNum()))
    {
        if (TriggerDelay > 0)
        {
            if (Level.TimeSeconds - TriggerTime < TriggerDelay)
            {
                return;
            }

            TriggerTime = Level.TimeSeconds;
        }

        // Send a string message to the toucher.
        if (Message != "")
        {
            P.ClientMessage(Message);
        }

        if (AIController(P.Controller) != none)
        {
            UsedBy(P);
        }
    }
}

defaultproperties
{
     TriggerDelay=5.000000
     RussianRequestSound=SoundGroup'DH_ArtillerySounds.requests.USrequest'
     RussianConfirmSound=SoundGroup'DH_US_Voice_Infantry.Artillery.confirm'
     RussianDenySound=SoundGroup'DH_US_Voice_Infantry.Artillery.Deny'
     Message="Request artillery support from HQ"
}
