class DH_Flakvierling38Gun extends DH_ATGun;

#exec OBJ LOAD FILE=..\StaticMeshes\DH_Flakvierling38_stc.usx
#exec OBJ LOAD FILE=..\Animations\DH_Flakvierling38_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_Flakvierling38_tex.utx

var	int	PrimaryMagazineCount;
var	int	SecondaryMagazineCount;

simulated function Destroyed()
{
	super(ROVehicle).Destroyed();
}

// Overridden due to the Onslaught team lock not working in RO
function bool TryToDrive(Pawn P)
{
	local int x;

	if(DH_Pawn(P).bOnFire)
		return false;

    //don't allow vehicle to be stolen when somebody is in a turret
	if (!bTeamLocked && P.GetTeamNum() != VehicleTeam)
	{
		for (x = 0; x < WeaponPawns.length; x++)
			if (WeaponPawns[x].Driver != None)
			{
				DenyEntry( P, 2 );
				return false;
			}
	}

    //Removed "P.bIsCrouched" to allow players to connect while crouched.
	if ( bNonHumanControl || (P.Controller == None) || (Driver != None) || (P.DrivenVehicle != None) || !P.Controller.bIsPlayer
	     || P.IsA('Vehicle') || Health <= 0 )
		return false;

	if ( bHasBeenSabotaged )
        return false;

	if ( !Level.Game.CanEnterVehicle(self, P) )
		return false;

	// Check vehicle Locking....
	if ( bTeamLocked && ( P.GetTeamNum() != VehicleTeam ))
	{

        DenyEntry( P, 1 );
		return false;
	}
	else
	{
        //Check for sabotage...
        if( DHParentFactory != none && DHParentFactory.bEnableSabotageRandomizer && ( P.GetTeamNum() != VehicleTeam ) )
        {
            if ( FRand() < SabotageProbability && Health > 0 && !bHasBeenSabotaged )
            {
                bHasBeenSabotaged=true;
                P.ReceiveLocalizedMessage(class'DH_VehicleMessage', 6); //Give sabotage message
                GotoState('VehicleDestroyed');
            }
            else
            {
                bTeamLocked = false;
            }
        }

        //At this point we know the pawn is not a tanker, so let's see if they can use the gun
    	if ( bEnterringUnlocks && bTeamLocked )
			bTeamLocked = false;

        //The gun is manned and it is a human - deny entry
        if ( WeaponPawns[0].Driver != none && WeaponPawns[0].IsHumanControlled() )
		{
            DenyEntry( P, 3 );
			return false;
		}
        //The gun is manned by a bot and the requesting pawn is human controlled - kick the bot off the gun
        else if ( WeaponPawns[0].Driver != none && !WeaponPawns[0].IsHumanControlled() && p.IsHumanControlled() )
        {
            WeaponPawns[0].KDriverLeave(true);

            KDriverEnter( P );
		    return true;
        }
        //The gun is manned by a bot and a bot is trying to use it, deny entry.
        else if ( WeaponPawns[0].Driver != none && !WeaponPawns[0].IsHumanControlled() && !p.IsHumanControlled() )
        {
            DenyEntry( P, 3 );
			return false;
		}
		//The gun is unmanned, so let who ever is there first can use it.
        else
		{
            KDriverEnter( P );
		    return true;
        }
	}
}

function DenyEntry(Pawn P, int MessageNum)
{
	P.ReceiveLocalizedMessage(class'DH_AAGunMessage', MessageNum);
}

defaultproperties
{
     VehicleHudTurret=TexRotator'DH_Flakvierling38_tex.flak.flakv38_turret_rot'
     VehicleHudTurretLook=TexRotator'DH_Flakvierling38_tex.flak.flakv38_turret_look'
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Guns.DH_Flakvierling38CannonPawn',WeaponBone="Turret_placement")
     DestroyedVehicleMesh=StaticMesh'DH_Flakvierling38_stc.flakv38.flakv38_destroyed'
     DestructionEffectClass=Class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
     DisintegrationEffectClass=Class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
     DamagedEffectClass=None
     DamagedEffectHealthSmokeFactor=0.000000
     DamagedEffectHealthMediumSmokeFactor=0.000000
     DamagedEffectHealthHeavySmokeFactor=0.000000
     VehicleHudImage=Texture'DH_Flakvierling38_tex.flak.flakv38_base'
     VehicleHudOccupantsX(0)=0.000000
     VehicleHudOccupantsX(1)=0.000000
     VehiclePositionString="using a Flakvierling 38"
     VehicleNameString="Flakvierling 38"
     Mesh=SkeletalMesh'DH_Flakvierling38_anm.flak_base'
}
