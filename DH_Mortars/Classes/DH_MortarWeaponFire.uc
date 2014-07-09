class DH_MortarWeaponFire extends ROWeaponFire;

//TODO: No flash, and don't actually fire, god damn it.

simulated function EjectShell() { return; }
simulated function bool AllowFire() { return true; }
simulated function InitEffects() { return; }
simulated function HandleRecoil() { return; }
function PlayFireEnd() { return; }
function PlayFiring() { return; }
function ServerPlayFiring() { return; }

defaultproperties
{
     AmmoClass=Class'ROEngine.Ammo_Dummy'
     AmmoPerFire=0
}
