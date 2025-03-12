//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHPawnFootstepSounds extends Object
    abstract;

var array<Sound> FootstepSounds; // Indexed by ESurfaceTypes.

static function Sound GetSound(optional int SurfaceTypeIndex)
{
    if (SurfaceTypeIndex < 0 || SurfaceTypeIndex >= default.FootstepSounds.Length)
    {
        return None;
    }
    else
    {
        return default.FootstepSounds[SurfaceTypeIndex];
    }
}

defaultproperties
{
    //Footstepping - add additional slots in the array for our new material surface types
    FootstepSounds(0)=Sound'Inf_Player.FootStepDirt'
    FootstepSounds(1)=Sound'Inf_Player.FootstepGravel' // Rock
    FootstepSounds(2)=Sound'Inf_Player.FootStepDirt'
    FootstepSounds(3)=Sound'Inf_Player.FootstepMetal' // Metal
    FootstepSounds(4)=Sound'Inf_Player.FootstepWoodenfloor' // Wood
    FootstepSounds(5)=Sound'Inf_Player.FootstepGrass' // Plant
    FootstepSounds(6)=Sound'Inf_Player.FootStepDirt' // Flesh
    FootstepSounds(7)=Sound'Inf_Player.FootstepSnowRough' // Ice
    FootstepSounds(8)=Sound'Inf_Player.FootstepSnowHard'
    FootstepSounds(9)=Sound'Inf_Player.FootstepWaterShallow'
    FootstepSounds(10)=Sound'Inf_Player.FootstepGravel' // Glass- Replaceme
    FootstepSounds(11)=Sound'Inf_Player.FootstepGravel' // Gravel
    FootstepSounds(12)=Sound'Inf_Player.FootstepAsphalt' // Concrete
    FootstepSounds(13)=Sound'Inf_Player.FootstepWoodenfloor' // HollowWood
    FootstepSounds(14)=Sound'Inf_Player.FootstepMud' // Mud
    FootstepSounds(15)=Sound'Inf_Player.FootstepMetal' // MetalArmor
    FootstepSounds(16)=Sound'Inf_Player.FootstepAsphalt_P' // Paper
    FootstepSounds(17)=Sound'Inf_Player.FootStepDirt' // Cloth
    FootstepSounds(18)=Sound'Inf_Player.FootStepDirt' // Rubber
    FootstepSounds(19)=Sound'Inf_Player.FootStepDirt' // Crap
    FootstepSounds(20)=none // this is a test material
    FootstepSounds(21)=Sound'Inf_Player.FootstepSnowRough' // Sand
    FootstepSounds(22)=Sound'Inf_Player.FootStepDirt' //Sand Bags
    FootstepSounds(23)=Sound'Inf_Player.FootstepAsphalt' // Brick
    FootstepSounds(24)=Sound'Inf_Player.FootstepGrass' // Hedgerow
}