//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Sdkfz105CannonPawn extends DH_Flak38CannonPawn;

defaultproperties
{
    GunClass=class'DH_Guns.DH_Sdkfz105Cannon'
    PositionInArray=1 // because front seat passenger is passenger pawn zero in this vehicle
}
