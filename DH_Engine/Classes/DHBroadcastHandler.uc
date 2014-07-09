//=============================================================================
// DHBroadcastHandler
//=============================================================================
// Handles mortar targetting broadcasts.
//=============================================================================
// Darkest Hour Source
// Copyright (C) 2010-2011 Colin Basnett
//=============================================================================

class DHBroadcastHandler extends ROBroadcastHandler;

//=============================================================================
// Functions
//=============================================================================

event AllowBroadcastLocalized(actor Sender, class<LocalMessage> Message,
	optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	local Controller C;
	local PlayerController P;
	local DH_RoleInfo RI;

	for ( C=Level.ControllerList; C!=None; C=C.NextController )
	{
		P = PlayerController(C);

		// Only broadcast rally point messages to your same team, and only to other players
		if((class<RORallyMsg>(Message) != none) && switch == 1 )
		{
			if ( P != None && Controller(Sender) != none && P != Sender && P.PlayerReplicationInfo.Team == Controller(Sender).PlayerReplicationInfo.Team )
				BroadcastLocalized(Sender, P, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
		}

		// Send correct last-objective message depending on who's winning and on the reciever's team
		else if (class<ROLastObjectiveMsg>(Message) != none && P != None && P.PlayerReplicationInfo != none
            && P.PlayerReplicationInfo.Team != none)
		{
		    // If P.PRI.Team == switch, then that team is about to win. Broadcast an about-to-win
		    // msg to that team. Else broadast an about-to-lost msg.
		    if (P.PlayerReplicationInfo.Team.TeamIndex == switch)
		        BroadcastLocalized(Sender, P, Message, 0 + switch * 2, RelatedPRI_1, RelatedPRI_2, OptionalObject);
		    else
		        BroadcastLocalized(Sender, P, Message, 1 + switch * 2, RelatedPRI_1, RelatedPRI_2, OptionalObject);
		}

		// Only send demo charge placed msg to teammates
		else if (class<RODemolitionChargePlacedMsg>(Message) != none && P != None && P.PlayerReplicationInfo != none
            && P.PlayerReplicationInfo.Team != none)
		{
		    if (P.PlayerReplicationInfo.Team.TeamIndex == switch)
		        BroadcastLocalized(Sender, P, Message, switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
		}

		// If this message is a static mesh destroyed msg, figure who it should go to
		else if (class<RODestroyableSMDestroyedMsg>(Message) != none && ROPlayer(P) != none && P.PlayerReplicationInfo != none && P.PlayerReplicationInfo.Team != none)
		{
	        switch (switch)
	        {
	            case 0:   // send to nobody? wtf this should never be called
	                break;

	            case 1:   // send to everyone
	                BroadcastLocalized(Sender, P, Message, switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                    break;

                case 2:   // send to teammates only
                    if (RelatedPRI_1 != none && RelatedPRI_1.Team != none &&
                        P.PlayerReplicationInfo.Team.TeamIndex == RelatedPRI_1.Team.TeamIndex)
                    {
                        BroadcastLocalized(Sender, P, Message, switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                    }
                    break;

                case 3:   // send to enemies only (not sure when this would be useful)
                    if (RelatedPRI_1 != none && RelatedPRI_1.Team != none &&
                    	P.PlayerReplicationInfo.Team.TeamIndex != RelatedPRI_1.Team.TeamIndex)
                    {
                        BroadcastLocalized(Sender, P, Message, switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                    }
                    break;

                case 4:   // send to instigator only
                    if (RelatedPRI_1 == P.PlayerReplicationInfo)
                        BroadcastLocalized(Sender, P, Message, switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                    break;

                default:
                    warn("Unknown broadcast type found for message class RODemolitionChargePlacedMsg: " $ switch);
	        }
		}

		else if(class<DH_MortarTargetMessage>(Message) != none)
		{
			if( P.Pawn == none ||
				P.Pawn.PlayerReplicationInfo == none ||
				DHPlayerReplicationInfo(P.Pawn.PlayerReplicationInfo) == none ||
				DHPlayerReplicationInfo(P.Pawn.PlayerReplicationInfo).RoleInfo == none )
				continue;

			RI = DH_RoleInfo(DHPlayerReplicationInfo(P.Pawn.PlayerReplicationInfo).RoleInfo);

			//------------------------------------------------------------------
			//Only show these messages to people involved with the mortars.
			if( P.GetTeamNum() == RelatedPRI_1.Team.TeamIndex && RI != none && (RI.bIsMortarObserver || RI.bCanUseMortars) )
			{
				switch(Switch)
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
        else if ( P != None )
		{
			BroadcastLocalized(Sender, P, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
		}
	}
}

defaultproperties
{
}
