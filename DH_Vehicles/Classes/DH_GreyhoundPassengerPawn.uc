//===================================================================
// DH_M3A1HalftrackPassengerOne
//===================================================================
class DH_GreyhoundPassengerPawn extends DH_ROPassengerPawn;


var     bool    bMustBeReconCrew;

/*
var     int             UnbuttonedPositionIndex; // Lowest pos number where player is unbuttoned
var     int             InitialPositionIndex; // Initial Gunner Position

replication
{
	reliable if (Role<ROLE_Authority)
        ServerChangeDriverPos;
}

simulated state EnteringVehicle
{
	simulated function HandleEnter()
	{
    		//if (DriverPositions[0].PositionMesh != none)
         	//	LinkMesh(DriverPositions[0].PositionMesh);
		if (Role == ROLE_AutonomousProxy || Level.Netmode == NM_Standalone ||  Level.Netmode == NM_ListenServer)
		{
 			if (DriverPositions[InitialPositionIndex].PositionMesh != none && Gun != none)
 			{
				Gun.LinkMesh(DriverPositions[InitialPositionIndex].PositionMesh);
			}
		}

		if (Gun.HasAnim(Gun.BeginningIdleAnim))
		{
		    Gun.PlayAnim(Gun.BeginningIdleAnim);
	    }

		WeaponFOV = DriverPositions[InitialPositionIndex].ViewFOV;
		PlayerController(Controller).SetFOV(WeaponFOV);

		FPCamPos = DriverPositions[InitialPositionIndex].ViewLocation;
	}

Begin:
	HandleEnter();
	Sleep(0.2);
	GotoState('');
}

// Overriden to handle mesh swapping when entering the vehicle
simulated function ClientKDriverEnter(PlayerController PC)
{
	super.ClientKDriverEnter(PC);

//    log("clientK DriverPos "$DriverPositionIndex);
//	log("clientK PendingPos "$PendingPositionIndex);

	PendingPositionIndex = InitialPositionIndex;
	ServerChangeDriverPos();
}

// Overridden to set exit rotation to be the same as when they were in the vehicle - looks a bit silly otherwise
simulated function ClientKDriverLeave(PlayerController PC)
{
    local rotator NewRot;

    NewRot = GetVehicleBase().Rotation;
    NewRot.Pitch = LimitPitch(NewRot.Pitch);
    SetRotation(NewRot);

	Super.ClientKDriverLeave(PC);
}

function ServerChangeDriverPos()
{
	DriverPositionIndex = InitialPositionIndex;
}

function bool KDriverLeave(bool bForceLeave)
{
    local bool bSuperDriverLeave;

	if (!bForceLeave && (DriverPositionIndex < UnbuttonedPositionIndex || Instigator.IsInState('ViewTransition')))
	{
	    Instigator.ReceiveLocalizedMessage(class'DH_VehicleMessage', 4);
        return false;
 	}
    else
    {
	    DriverPositionIndex=InitialPositionIndex;
	    bSuperDriverLeave = super(VehicleWeaponPawn).KDriverLeave(bForceLeave);

	    DH_ROTreadCraft(GetVehicleBase()).MaybeDestroyVehicle();
	    return bSuperDriverLeave;
	}
}

function DriverDied()
{
	DriverPositionIndex=InitialPositionIndex;
	super.DriverDied();
	DH_ROTreadCraft(GetVehicleBase()).MaybeDestroyVehicle();

	// Kill the rotation sound if the driver dies but the vehicle doesnt
    if (GetVehicleBase().Health > 0)
		SetRotatingStatus(0);
}

// Overridden here to force the server to go to state "ViewTransition", used to prevent players exiting before the unbutton anim has finished
function ServerChangeViewPoint(bool bForward)
{
    if (bForward)
	{
		if (DriverPositionIndex < (DriverPositions.Length - 1))
		{
			LastPositionIndex = DriverPositionIndex;
			DriverPositionIndex++;

			if (Level.Netmode == NM_Standalone  || Level.NetMode == NM_ListenServer)
			{
				NextViewPoint();
			}

            if (Level.NetMode == NM_DedicatedServer)
			{
                // Run the state on the server whenever we're unbuttoning in order to prevent early exit
				if (DriverPositionIndex == UnbuttonedPositionIndex)
				    GoToState('ViewTransition');
   			}
		}
     }
     else
     {
		if (DriverPositionIndex > 0)
		{
			LastPositionIndex = DriverPositionIndex;
			DriverPositionIndex--;

			if (Level.Netmode == NM_Standalone || Level.Netmode == NM_ListenServer)
			{
				NextViewPoint();
			}
		}
     }
}

simulated state ViewTransition
{
	simulated function HandleTransition()
	{
	    StoredVehicleRotation = VehicleBase.Rotation;

		if (Role == ROLE_AutonomousProxy || Level.Netmode == NM_Standalone  || Level.NetMode == NM_ListenServer)
		{
 			if (DriverPositions[DriverPositionIndex].PositionMesh != none && Gun != none)
				Gun.LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
		}

         // bDrawDriverinTP=true;//Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);

		if (Driver != none && Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim)
			&& Driver.HasAnim(DriverPositions[LastPositionIndex].DriverTransitionAnim))
		{
			Driver.PlayAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);
		}

        WeaponFOV = DriverPositions[DriverPositionIndex].ViewFOV;

		FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;
		//FPCamViewOffset = DriverPositions[DriverPositionIndex].ViewOffset; // depractated

		if (DriverPositionIndex != 0)
		{
			if (DriverPositions[DriverPositionIndex].bDrawOverlays)
				PlayerController(Controller).SetFOV(WeaponFOV);
			else
				PlayerController(Controller).DesiredFOV = WeaponFOV;
		}

		if (LastPositionIndex < DriverPositionIndex)
		{
			if (Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionUpAnim))
			{
//           	    if (IsLocallyControlled())
                    Gun.PlayAnim(DriverPositions[LastPositionIndex].TransitionUpAnim);
				SetTimer(Gun.GetAnimDuration(DriverPositions[LastPositionIndex].TransitionUpAnim, 1.0),false);
			}
			else
				GotoState('');
		}
		else if (Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionDownAnim))
		{
//           	if (IsLocallyControlled())
			    Gun.PlayAnim(DriverPositions[LastPositionIndex].TransitionDownAnim);
			SetTimer(Gun.GetAnimDuration(DriverPositions[LastPositionIndex].TransitionDownAnim, 1.0),false);
		}
		else
		{
			GotoState('');
		}
	}

	simulated function Timer()
	{
		GotoState('');
	}

	simulated function AnimEnd(int channel)
	{
		if (IsLocallyControlled())
            GotoState('');
	}

   	simulated function EndState()
	{
		if (PlayerController(Controller) != none)
		{
			PlayerController(Controller).SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);
			//PlayerController(Controller).SetRotation(Gun.GetBoneRotation('Camera_com'));
		}
	}

Begin:
	HandleTransition();
	Sleep(0.2);
}
*/

function bool TryToDrive(Pawn P)
{
	if (VehicleBase != none)
	{
		if (VehicleBase.NeedsFlip())
		{
			VehicleBase.Flip(vector(P.Rotation), 1);
			return false;
		}

		if (P.GetTeamNum() != Team)
		{
			if (VehicleBase.Driver == none)
				return VehicleBase.TryToDrive(P);

			VehicleLocked(P);
			return false;
		}
	}

	if (bMustBeReconCrew && DHPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).DHRoleInfo != none && !DHPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).DHRoleInfo.bCanBeReconCrew && P.IsHumanControlled())
	{
	   DenyEntry(P, 0);
	   return false;
	}

	return Super.TryToDrive(P);
}

defaultproperties
{
     bMustBeReconCrew=true
     PositionInArray=1
     CameraBone="Passenger_attachement"
     DrivePos=(X=5.000000,Y=-2.000000,Z=5.000000)
     DriveAnim="VBA64_driver_idle_close"
     FPCamViewOffset=(X=2.000000,Z=-2.000000)
     VehiclePositionString="in a M8 Armored Car"
     VehicleNameString="M8 Armored Car passenger"
     bKeepDriverAuxCollision=false
}
