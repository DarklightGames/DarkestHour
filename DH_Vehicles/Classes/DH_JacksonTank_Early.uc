//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_JacksonTank_Early extends DH_JacksonTank; // earlier version without HVAP & without muzzle brake

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_JacksonCannonPawn_Early')
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.m36_jackson_early'
}
