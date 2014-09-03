//=============================================================================
//  DH_ArtilleryTrigger - Arty radio that can be carried by a player or vehicle
//=============================================================================

class DHArtilleryTriggerUSMap extends DHArtilleryTrigger;

var() float ReTriggerDelay; //minimum time before trigger can be triggered again
var   float TriggerTime;

var DH_Pawn Carrier; // Player carrying the radio

function UsedBy(Pawn user)
{
    local DHPlayer DHP;
    local ROVolumeTest RVT;
    local DHPlayerReplicationInfo PRI;
    local DH_RoleInfo RI;

    if (!bAvailable)
       return;

    SavedUser = none;

    if (user.Controller != none)
        DHP = DHPlayer(user.Controller);

    // Bots can't call arty yet
    if (DHP == none)
        return;

    PRI = DHPlayerReplicationInfo(DHP.PlayerReplicationInfo);

    if (DH_Pawn(user) == none)
        return;

    RI = DH_Pawn(user).GetRoleInfo();

    // Don't let non-commanders call in arty
    if (PRI == none || RI == none || !RI.bIsArtilleryOfficer)
        return;

    if (DHP != none && DHP.SavedArtilleryCoords == vect(0,0,0))
    {
       DHP.ReceiveLocalizedMessage(class'ROArtilleryMsg', 4);
       return;
    }

    // Don't let the player call in an arty strike on a location that has become an active
    // NoArtyVolume after they marked the location.
    if (DHP != none)
    {
        RVT = Spawn(class'ROVolumeTest',self,,DHP.SavedArtilleryCoords);

        if ((RVT != none && RVT.IsInNoArtyVolume()))
        {
            DHP.ReceiveLocalizedMessage(class'ROArtilleryMsg', 5);
            RVT.Destroy();
            return;
        }

        RVT.Destroy();
    }

    if (ApprovePlayerTeam(user.GetTeamNum()))
    {
         SavedUser = user;
         bAvailable = false;

         if (SavedUser.Controller != none)
            DHP = DHPlayer(SavedUser.Controller);

         if (DHP != none)
             DHPlayer(SavedUser.Controller).ReceiveLocalizedMessage(class'ROArtilleryMsg', 1);

         if (user.GetTeamNum() == AXIS_TEAM_INDEX)
         {
              user.PlaySound(GermanRequestSound, Slot_none, 3.0, false, 100, 1.0,true);
              SetTimer(GetSoundDuration(GermanRequestSound), false);
         }
         else
         {
              user.PlaySound(RussianRequestSound,Slot_none, 3.0, false, 100, 1.0,true);
              SetTimer(GetSoundDuration(RussianRequestSound), false);
         }

         DarkestHourGame(Level.Game).ScoreRadioUsed(Carrier.Controller);
    }
}

function Touch(Actor Other)
{
    local DHPlayerReplicationInfo PRI;
    local Pawn P;
    local DH_RoleInfo RI;

    P = Pawn(Other);

    if (P != none)
        PRI = DHPlayerReplicationInfo(P.PlayerReplicationInfo);

    if (PRI == none || PRI.RoleInfo == none)
        return;

    RI = DH_RoleInfo(PRI.RoleInfo);

    if (RI.bIsArtilleryOfficer && ApprovePlayerTeam(Pawn(Other).GetTeamNum()))
    {
        if (ReTriggerDelay > 0)
        {
            if (Level.TimeSeconds - TriggerTime < ReTriggerDelay)
                return;
            TriggerTime = Level.TimeSeconds;
        }

        // Send a string message to the toucher.
        if (Message != "")
            Pawn(Other).ClientMessage(Message);

        if (AIController(Pawn(Other).Controller) != none)
            UsedBy(Pawn(Other));
    }
}

defaultproperties
{
     ReTriggerDelay=5.000000
     RussianRequestSound=SoundGroup'DH_ArtillerySounds.requests.USrequest'
     RussianConfirmSound=SoundGroup'DH_US_Voice_Infantry.Artillery.confirm'
     RussianDenySound=SoundGroup'DH_US_Voice_Infantry.Artillery.Deny'
     Message="Request artillery support from HQ"
}
