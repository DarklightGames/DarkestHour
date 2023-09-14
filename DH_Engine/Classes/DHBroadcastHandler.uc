//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
            if (P == none ||
                P.Pawn == none ||
                DHPlayerReplicationInfo(P.Pawn.PlayerReplicationInfo) == none ||
                DHPlayerReplicationInfo(P.Pawn.PlayerReplicationInfo).RoleInfo == none)
            {
                continue;
            }

            RI = DHRoleInfo(DHPlayerReplicationInfo(P.Pawn.PlayerReplicationInfo).RoleInfo);

            // Only show these messages to people involved with the mortars
            if (P.GetTeamNum() == RelatedPRI_1.Team.TeamIndex && RI != none && (RI.bCanUseMortars || P.IsInArtilleryVehicle()))
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

    if (!AllowsBroadcast(Sender, Len(Msg)) || Sender == none || PlayerController(Sender) == none || PlayerController(Sender).PlayerReplicationInfo == none || PlayerController(Sender).PlayerReplicationInfo.bOnlySpectator)
    {
        return;
    }

    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        P = PlayerController(C);

        if (P != none && P.PlayerReplicationInfo != none && P.PlayerReplicationInfo.Team == Sender.PlayerReplicationInfo.Team)
        {
            BroadcastText(Sender.PlayerReplicationInfo, P, Msg, Type);
        }
    }

    LogMessage(PlayerController(Sender), Msg, Type);
}

function BroadcastVehicle(Controller Sender, coerce string Msg, optional name Type)
{
    local int i;
    local DHPlayer PC, Receiver;
    local array<PlayerController> VehicleOccupants;

    PC = DHPlayer(Sender);

    if (PC == none)
    {
        return;
    }

    VehicleOccupants = PC.GetVehicleOccupants(Sender);

    for (i = 0; i < VehicleOccupants.length; ++i)
    {
        Receiver =  DHPlayer(VehicleOccupants[i]);

        if (Receiver != none)
        {
            BroadcastText(Sender.PlayerReplicationInfo, Receiver, Msg, Type);
        }
    }

    LogMessage(PlayerController(Sender), Msg, Type);
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

    LogMessage(PlayerController(Sender), Msg, Type);
}

function BroadcastSquad(Controller Sender, coerce string Msg, optional name Type)
{
    local DarkestHourGame G;
    local DHPlayerReplicationInfo PRI;
    local DHPlayer PC;
    local int i;
    local array<DHPlayerReplicationInfo> SquadMembers;

    if (!AllowsBroadcast(Sender, Len(Msg)))
    {
        return;
    }

    PC  = DHPlayer(Sender);

    if (PC == none)
    {
        return;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    if (PRI == none)
    {
        return;
    }

    G = DarkestHourGame(Level.Game);

    if (G != none && G.SquadReplicationInfo != none)
    {
        G.SquadReplicationInfo.GetMembers(PC.GetTeamNum(), PRI.SquadIndex, SquadMembers);
    }

    for (i = 0; i < SquadMembers.Length; ++i)
    {
        PC = DHPlayer(SquadMembers[i].Owner);

        if (PC != none)
        {
            BroadcastText(Sender.PlayerReplicationInfo, PC, Msg, Type);
        }
    }

    LogMessage(PlayerController(Sender), Msg, Type);
}

function BroadcastCommand(Controller Sender, coerce string Msg, optional name Type)
{
    local Controller C;
    local DHPlayer DHSender, PC;

    if (!AllowsBroadcast(Sender, Len(Msg)))
    {
        return;
    }

    DHSender  = DHPlayer(Sender);

    // Important check here to rule out non SLs and non ASLs
    if (DHSender == none || !DHSender.IsSLorASL())
    {
        return;
    }

    // We only need to check for team, because above check rules out non SLorASL
    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        PC = DHPlayer(C);

        if (PC != none && PC.GetTeamNum() == DHSender.GetTeamNum()) // only send to same team as sender
        {
            BroadcastText(DHSender.PlayerReplicationInfo, PC, Msg, Type);
        }
    }

    LogMessage(PlayerController(Sender), Msg, Type);
}

function LogMessage(PlayerController Sender, string Msg, coerce string Type)
{
    local DarkestHourGame G;

    G = DarkestHourGame(Level.Game);

    if (G != none && G.Metrics != none)
    {
        G.Metrics.OnTextMessage(Sender, Type, Msg);
    }
}
