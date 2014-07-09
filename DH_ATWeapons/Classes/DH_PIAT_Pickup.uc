//===================================================================
// DH_PIAT_Pickup
//===================================================================

class DH_PIAT_Pickup extends ROPlaceableAmmoPickup;

var() class<Inventory> WeaponType;

static function StaticPrecache(LevelInfo L)
{
/*	L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.Panzerfaust');
	L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Ammo.Warhead3rd');
	L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Ammo.Warhead1st');
	L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.Panzerfaust_world');
	L.AddPrecacheMaterial(Material'Weapons1st_tex.Grenades.Panzerfaust_S'); */
}

auto state Pickup
{
	function bool ReadyToPickup(float MaxWait)
	{
		return true;
	}

	function bool ValidTouch( actor Other )
	{
		// make sure its a live player
		if ( (Pawn(Other) == None) || !Pawn(Other).bCanPickupInventory || (Pawn(Other).Health <= 0) || (Pawn(Other).DrivenVehicle == None && Pawn(Other).Controller == None))
			return false;

		if( ROPawn(Other) != none && ROPawn(Other).AutoTraceActor != none && ROPawn(Other).AutoTraceActor == self )
		{
			// do nothing
		}
		// make sure not touching through wall
		else if ( !FastTrace(Other.Location, Location) )
			return false;

		// make sure game will let player pick me up
		if( Level.Game.PickupQuery(Pawn(Other), self) )
		{
			TriggerEvent(Event, self, Pawn(Other));
			return true;
		}
		return false;
	}

	// When touched by an actor.
	function Touch( actor Other )
	{
	}

	function CheckTouching()
	{
	}

	function UsedBy( Pawn user )
	{
    	local Inventory Copy;
    	local inventory Inv;
    	local bool bHasWeapon;

		if( user == none )
			return;

	   	// check if Other has a primary weapon
		if( user != none && user.Inventory != none )
		{
			for ( Inv=user.Inventory; Inv!=None; Inv=Inv.Inventory )
			{
				if ( Inv != none && Weapon(Inv) != None )
				{
					if( Inv.class == WeaponType)
					{
						if( Weapon(Inv).AmmoMaxed(0) )
							return;
						else
							bHasWeapon = true;
					}
				}
			}
		}

		// valid touch will pickup the object
		if( ValidTouch( user ) )
		{
			if( bHasWeapon )
				Copy = SpawnCopy(user);
			else
				Copy = SpawnWeaponCopy(user);

			AnnouncePickup(user);
            if ( Copy != None )
				Copy.PickupFunction(user);

			SetRespawn();
		}
	}

	function Timer()
	{
		if ( bDropped )
			GotoState('FadeOut');
	}

	function BeginState()
	{
		UntriggerEvent(Event, self, None);
		if ( bDropped )
        {
			AddToNavigation();
		    SetTimer(DropLifeTime, false);
        }
	}

	function EndState()
	{
		if ( bDropped )
			RemoveFromNavigation();
	}

Begin:
	CheckTouching();
}

//
// Set up respawn waiting if desired.
//
function SetRespawn()
{
	StartSleeping();
}

function inventory SpawnWeaponCopy( pawn Other )
{
	local inventory Copy;

	if ( Inventory != None )
	{
		Copy = Inventory;
		Inventory = None;
	}
	else
		Copy = Other.spawn(WeaponType,Other,,,rot(0,0,0));

	Copy.GiveTo( Other, self );

	return Copy;
}

defaultproperties
{
     WeaponType=Class'DH_ATWeapons.DH_PIATWeapon'
     TouchMessage="Pick Up: PIAT"
     bAmmoPickupIsWeapon=True
     AmmoAmount=1
     MaxDesireability=0.780000
     InventoryType=Class'DH_ATWeapons.DH_PIATAmmo'
     PickupMessage="You got the PIAT."
     PickupSound=Sound'Inf_Weapons_Foley.Misc.WeaponPickup'
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.PIAT'
     PrePivot=(Z=3.000000)
     AmbientGlow=10
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
