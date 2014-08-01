//=============================================================================
// DHAmmoResupplyVolume
//=============================================================================
// Author: Justin Harvey

class DHAmmoResupplyVolume extends Volume;

enum EOwningTeam
{
	OWNER_Axis,
	OWNER_Allies,
	OWNER_Neutral,
};

var() 	EOwningTeam		Team;			//Team this volume resupplies
var() 	float			UpdateTime;		//How often this thing needs to do it's business
var() 	bool			bUsesSpawnAreas;// Activated/Deactivated based on a spawn area associated with a tag

var 	bool			bActive;		// Whether this ammo resupply volume is active

enum EResupplyType
{
	RT_Players,
	RT_Vehicles,
	RT_All,
	RT_Mortars
};

var() 	EResupplyType		ResupplyType; //Who this volume will resupply

function PostBeginPlay()
{
	Super.PostBeginPlay();

    if (!bUsesSpawnAreas)
    	Activate();

	SetTimer(1.0, true);
}


function Timer()
{
	local Pawn recvr;
	local inventory recvr_inv;
	local ROWeapon recvr_weapon;
	local bool bEnemyGrenadeFound, bEnemySmokeFound, bResupplied;
	local DH_Pawn P;
	local Vehicle V;
	local DH_RoleInfo DHRI;

    if (Role < ROLE_Authority || !bActive)
    	return;

	foreach TouchingActors(class'Pawn', recvr)
	{
		if (Team==OWNER_Neutral || recvr.GetTeamNum()==Team)
		{
            bResupplied=false;

			if (Level.TimeSeconds - recvr.LastResupplyTime >= UpdateTime)
			{
				P = DH_Pawn(recvr);
				V = Vehicle(recvr);

				if (P != none)
					DHRI = P.GetRoleInfo();

				if (P != none && (ResupplyType == RT_Players || ResupplyType == RT_All))
				{
					//Resupply weapons
					for (recvr_inv = P.Inventory; recvr_inv != none; recvr_inv = recvr_inv.Inventory)
					{
						recvr_weapon = ROWeapon(recvr_inv);

						//Don't allow resupplying of enemy weapons
						if (recvr_weapon.IsGrenade() == true && recvr_weapon.Class != Level.Game.BaseMutator.GetInventoryClass(DHPlayer(P.Controller).GetGrenadeWeapon())
                           && recvr_weapon.Class != Level.Game.BaseMutator.GetInventoryClass(DHPlayer(P.Controller).GetSecGrenadeWeapon()))
                        {
						   if (recvr_weapon.Name == 'DH_RedSmokeGrenadeWeapon' || recvr_weapon.Name == 'DH_OrangeSmokeGrenadeWeapon')
						       bEnemySmokeFound = true;
						   else
                               bEnemyGrenadeFound = true;
			   			}
						else if (recvr_weapon != none && recvr_weapon.FillAmmo())
								bResupplied=true;
					}

					if (DHRI != none)
					{
						if (!P.bHasATAmmo && DHRI.bCarriesATAmmo)
						{
							P.bHasATAmmo = true;
							bResupplied = true;
						}

						if (!P.bHasMGAmmo && DHRI.bCarriesMGAmmo)
						{
							P.bHasMGAmmo =true;
							bResupplied=true;
						}
					}

					// Resupply explosive weapons
					if (P.DHResupplyExplosiveWeapons(bEnemyGrenadeFound,bEnemySmokeFound))
						bResupplied=true;
				}

				if (V != none && (ResupplyType == RT_Vehicles || ResupplyType == RT_All))
				{
					// Resupply vehicles
					if (V.ResupplyAmmo())
						bResupplied=true;
				}

				//Mortar specific resupplying.
				if (P != none && (ResupplyType == RT_Mortars || ResupplyType == RT_All) && DHRI != none)
				{
					if (DHRI.bCanUseMortars)
					{
						P.FillMortarAmmunition();
						bResupplied = true;
					}

					if (!P.bHasMortarAmmo && DHRI.bCarriesMortarAmmo)
					{
						P.bHasMortarAmmo = true;
						bResupplied = true;
					}
				}

				//Play sound if applicable
				if (bResupplied)
				{
					recvr.LastResupplyTime = Level.TimeSeconds;
					recvr.ClientResupplied();
				}
			}
		}
	}
}

event Touch(Actor Other)
{
	local ROPawn ROP;
	local Vehicle V;

    if (!bActive)
    	return;

	ROP=ROPawn(Other);
	V = Vehicle(Other);

	if (ROP != none)
	{
	    if (Team == OWNER_Neutral ||
	       (ROP.PlayerReplicationInfo != none && ROP.PlayerReplicationInfo.Team != none
	       && ((ROP.PlayerReplicationInfo.Team.TeamIndex == AXIS_TEAM_INDEX && Team == OWNER_Axis) ||
	           (ROP.PlayerReplicationInfo.Team.TeamIndex == ALLIES_TEAM_INDEX && Team == OWNER_Allies))))
	    {
		    ROP.bTouchingResupply = true;
		}
	}

	if (V != none)
	{
	    if (Team == OWNER_Neutral ||
	       ((V.GetTeamNum() == AXIS_TEAM_INDEX && Team == OWNER_Axis) ||
	        (V.GetTeamNum() == ALLIES_TEAM_INDEX && Team == OWNER_Allies)))
	    {
		    V.EnteredResupply();
		}
	}
}

event UnTouch(Actor Other)
{
	local ROPawn ROP;
	local Vehicle V;

	ROP=ROPawn(Other);
	V = Vehicle(Other);

	if (ROP != none)
	{
		ROP.bTouchingResupply = false;
	}

	if (V != none)
	{
		V.LeftResupply();
	}
}

function Activate()
{
    bActive = true;
}

function Deactivate()
{
    bActive = false;
}

function Reset()
{
    if (!bUsesSpawnAreas)
    	Activate();
}

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     Team=OWNER_Neutral
     UpdateTime=30.000000
     ResupplyType=RT_All
     bStatic=false
}
