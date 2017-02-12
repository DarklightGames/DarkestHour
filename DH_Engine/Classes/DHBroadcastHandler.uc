//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHBroadcastHandler extends ROBroadcastHandler;

event AllowBroadcastLocalized(
    Actor Sender,
    class<LocalMessage> Message,
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject)
{
    local Controller    C;
    local DHPlayer      P;
    local DHRoleInfo    RI;

    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        P = DHPlayer(C);

        // Only broadcast rally point messages to your same team, and only to other players
        if (class<RORallyMsg>(Message) != none && Switch == 1)
        {
            if (P != none && Controller(Sender) != none && P != Sender && P.PlayerReplicationInfo.Team == Controller(Sender).PlayerReplicationInfo.Team)
            {
                BroadcastLocalized(Sender, P, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
            }
        }
        // Send correct last-objective message depending on who's winning and on the reciever's team
        else if (class<ROLastObjectiveMsg>(Message) != none && P != none && P.PlayerReplicationInfo != none && P.PlayerReplicationInfo.Team != none)
        {
            // If P.PRI.Team == Switch, then that team is about to win. Broadcast an about-to-win msg to that team. Else broadast an about-to-lost msg.
            if (P.PlayerReplicationInfo.Team.TeamIndex == Switch)
            {
                BroadcastLocalized(Sender, P, Message, 0 + Switch * 2, RelatedPRI_1, RelatedPRI_2, OptionalObject);
            }
            else
            {
                BroadcastLocalized(Sender, P, Message, 1 + Switch * 2, RelatedPRI_1, RelatedPRI_2, OptionalObject);
            }
        }
        // Only send demo charge placed msg to teammates
        else if (class<RODemolitionChargePlacedMsg>(Message) != none && P != none && P.PlayerReplicationInfo != none && P.PlayerReplicationInfo.Team != none)
        {
            if (P.PlayerReplicationInfo.Team.TeamIndex == Switch)
            {
                BroadcastLocalized(Sender, P, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
            }
        }
        // If this message is a static mesh destroyed msg, figure who it should go to
        else if (class<RODestroyableSMDestroyedMsg>(Message) != none && P != none && P.PlayerReplicationInfo != none && P.PlayerReplicationInfo.Team != none)
        {
            switch (Switch)
            {
                case 0:   // send to nobody? wtf this should never be called
                    break;

                case 1:   // send to everyone
                    BroadcastLocalized(Sender, P, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                    break;

                case 2:   // send to teammates only
                    if (RelatedPRI_1 != none && RelatedPRI_1.Team != none && P.PlayerReplicationInfo.Team.TeamIndex == RelatedPRI_1.Team.TeamIndex)
                    {
                        BroadcastLocalized(Sender, P, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                    }
                    break;

                case 3:   // send to enemies only (not sure when this would be useful)
                    if (RelatedPRI_1 != none && RelatedPRI_1.Team != none && P.PlayerReplicationInfo.Team.TeamIndex != RelatedPRI_1.Team.TeamIndex)
                    {
                        BroadcastLocalized(Sender, P, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                    }
                    break;

                case 4:   // send to instigator only
                    if (RelatedPRI_1 == P.PlayerReplicationInfo)
                    {
                        BroadcastLocalized(Sender, P, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                    }
                    break;

                default:
                    Warn("Unknown broadcast type found for message class RODemolitionChargePlacedMsg: " $ Switch);
            }
        }

        else if (class<DHArtilleryTargetMessage>(Message) != none)
        {
            if (P.Pawn == none || P.Pawn.PlayerReplicationInfo == none || DHPlayerReplicationInfo(P.Pawn.PlayerReplicationInfo) == none ||
                DHPlayerReplicationInfo(P.Pawn.PlayerReplicationInfo).RoleInfo == none)
            {
                continue;
            }

            RI = DHRoleInfo(DHPlayerReplicationInfo(P.Pawn.PlayerReplicationInfo).RoleInfo);

            // Only show these messages to people involved with the mortars
            if (P.GetTeamNum() == RelatedPRI_1.Team.TeamIndex && RI != none && (RI.bIsMortarObserver || RI.bCanUseMortars || P.IsInArtilleryVehicle()))
            {
                switch (Switch)
                {
                    case 2:
                        BroadcastLocalized(Sender, P, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                        break;
                    case 3:
                        BroadcastLocalized(Sender, P, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                        break;
                }
            }
        }
        else if (P != none)
        {
            BroadcastLocalized(Sender, P, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
        }
    }
}

// Modified to prevent any possibility of this actor being registered as the next in the BroadcastHandler chain, which would create a feedback loop
// Similarly we also stop this function being passed on to the NextBroadcastHandler if that is the same actor that we are supposed to be registering
function RegisterBroadcastHandler(BroadcastHandler NewBH)
{
    if (NextBroadcastHandler == none)
    {
        if (NewBH != self)
        {
            NextBroadcastHandler = NewBH;
            default.NextBroadcastHandlerClass = NewBH.Class;
        }
        else
        {
            Warn(Tag @ "RegisterBroadcastHandler: TRIED TO REGISTER SELF as NextBroadcastHandler !!!");
        }
    }
    else
    {
        if (NextBroadcastHandler == NewBH)
        {
            Warn(Tag @ "RegisterBroadcastHandler: TRIED TO REGISTER" @ NewBH.Tag @ "as NextBroadcastHandler, when it's already recorded as NextBroadcastHandler !!!");
        }

        NextBroadcastHandler.RegisterBroadcastHandler(NewBH);
    }
}

// Modified to allow players to team chat when dead to rest of team
// Also removed some spectator team chat stuff, that is never needed
function BroadcastTeam(Controller Sender, coerce string Msg, optional name Type)
{
    local Controller C;
    local PlayerController P;

    if (!AllowsBroadcast(Sender, Len(Msg)) || Sender == none || PlayerController(Sender) == none || PlayerController(Sender).IsSpectating())
    {
        return;
    }

    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        P = PlayerController(C);

        if (P != none && P.PlayerReplicationInfo.Team == Sender.PlayerReplicationInfo.Team)
        {
            BroadcastText(Sender.PlayerReplicationInfo, P, Msg, Type);
        }
    }
}

// Modified to allow dead players to chat to everyone (aka remove the SayDead type)
function Broadcast(Actor Sender, coerce string Msg, optional name Type)
{
    local Controller C;
    local PlayerController P;
    local PlayerReplicationInfo PRI;

    if (!AllowsBroadcast(Sender, Len(Msg)))
    {
        return;
    }

    if (Pawn(Sender) != none)
    {
        PRI = Pawn(Sender).PlayerReplicationInfo;
    }
    else if (Controller(Sender) != none)
    {
        PRI = Controller(Sender).PlayerReplicationInfo;
    }

    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        P = PlayerController(C);

        if (P != none)
        {
            BroadcastText(PRI, P, Msg, Type);
        }
    }
}

defaultproperties
{
}
