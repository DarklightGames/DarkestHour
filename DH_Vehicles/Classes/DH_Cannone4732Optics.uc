//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// There are no reliable sources for what the actual optics looked like for
// the Cannone da 47/32, made even more difficult by the fact that the vehicle
// had multiple variants with different optics.
//
// The optics we're using for it instead are from the Semovente da 75/18, which
// was a similar vehicle to the Semovente 47/32 that uses this same gun.
//==============================================================================

class DH_Cannone4732Optics extends DHGunOptics
    abstract;

defaultproperties
{
    GunsightSize=0.4
    GunsightOverlay=Texture'DH_Semovente4732_tex.Interface.semo7518_sight'
    CannonScopeCenter=None
}
