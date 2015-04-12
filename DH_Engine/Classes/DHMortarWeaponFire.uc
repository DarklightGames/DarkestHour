//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMortarWeaponFire extends ROWeaponFire;

simulated function EjectShell() { return; }
simulated function bool AllowFire() { return true; }
simulated function InitEffects() { return; }
simulated function HandleRecoil() { return; }
function PlayFireEnd() { return; }
function PlayFiring() { return; }
function ServerPlayFiring() { return; }

defaultproperties
{
    AmmoClass=class'ROEngine.Ammo_Dummy'
    AmmoPerFire=0
}
