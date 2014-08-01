//=============================================================================
// DH_RoleInfo.
//=============================================================================


class DH_RoleInfo extends RORoleInfo
	placeable
	abstract;

var		bool	bIsATGunner;			// Enable player to request AT resupply.
var		bool	bCanUseMortars;			// Enable player to use mortars.
var		bool	bCanBeReconCrew;		// Enable player to drive reconnaissance vehicles.
var		bool	bCanBeReconOfficer;		// Enable player to command reconnaissance vehicles.
var		bool	bIsSquadLeader;
var		bool	bIsMortarObserver;
var		bool	bIsArtilleryOfficer;

var()	bool	bCarriesATAmmo;			// Enable player to carry rocket anti-tank ammunition.
var()	bool	bCarriesMortarAmmo;		// Enable player to carry mortar ammunition.

//-----------------------------------------------------------------------------
// PostBeginPlay - Add this role to the list
//-----------------------------------------------------------------------------

function PostBeginPlay()
{
	if (DarkestHourGame(Level.Game) != none)
		DarkestHourGame(Level.Game).AddRole(self);

	HandlePrecache();
}

defaultproperties
{
     bCarriesATAmmo=true
     bCarriesMortarAmmo=true
     bCarriesMGAmmo=true
}
