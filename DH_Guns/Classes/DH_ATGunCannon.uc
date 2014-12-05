//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ATGunCannon extends DH_ROTankCannon
      config(xGunsightDebugging)
      abstract;


simulated function Timer()
{
   if (VehicleWeaponPawn(Owner) == none || VehicleWeaponPawn(Owner).Controller == none)
   {
      //log(" Returning because there is no controller");
      SetTimer(0.05, true);
   }
   else if (CannonReloadState == CR_Empty)
   {
         if (Role == ROLE_Authority)
         {
              PlayOwnedSound(ReloadSoundOne, SLOT_Misc, FireSoundVolume/255.0,, 150,, false);
         }
         else
         {
              PlaySound(ReloadSoundOne, SLOT_Misc, FireSoundVolume/255.0,, 150,, false);
         }
         CannonReloadState = CR_ReloadedPart1;
         GetSoundDuration(ReloadSoundTwo) + GetSoundDuration(ReloadSoundThree);
         SetTimer(GetSoundDuration(ReloadSoundOne), false);
   }
   else if (CannonReloadState == CR_ReloadedPart1)
   {
         if (Role == ROLE_Authority)
         {
              PlayOwnedSound(ReloadSoundTwo, SLOT_Misc, FireSoundVolume/255.0,, 150,, false);
         }
         else
         {
              PlaySound(ReloadSoundTwo, SLOT_Misc, FireSoundVolume/255.0,, 150,, false);
         }

         CannonReloadState = CR_ReloadedPart2;
         GetSoundDuration(ReloadSoundThree);
         SetTimer(GetSoundDuration(ReloadSoundTwo), false);
   }
   else if (CannonReloadState == CR_ReloadedPart2)
   {
         if (Role == ROLE_Authority)
         {
              PlayOwnedSound(ReloadSoundThree, SLOT_Misc, FireSoundVolume/255.0,, 150,, false);
         }
         else
         {
              PlaySound(ReloadSoundThree, SLOT_Misc, FireSoundVolume/255.0,, 150,, false);
         }

         CannonReloadState = CR_ReloadedPart3;
         SetTimer(GetSoundDuration(ReloadSoundThree), false);
   }
   else if (CannonReloadState == CR_ReloadedPart3)
   {
        if (Role == ROLE_Authority)
        {
            bClientCanFireCannon = true;
        }
        CannonReloadState = CR_ReadyToFire;
        SetTimer(0.0, false);
   }
}

simulated function bool DHShouldPenetrateAPC(vector HitLocation, vector HitRotation, float PenetrationNumber, out float InAngle, float ShellDiameter, optional class<DamageType> DamageType, optional bool bShatterProne)
{
   return true;
}

simulated function bool DHShouldPenetrateHVAP(vector HitLocation, vector HitRotation, float PenetrationNumber, out float InAngle, optional class<DamageType> DamageType, optional bool bShatterProne)
{
    return true;
}

simulated function bool DHShouldPenetrateAPDS(vector HitLocation, vector HitRotation, float PenetrationNumber, out float InAngle, optional class<DamageType> DamageType, optional bool bShatterProne)
{
    return true;
}

simulated function bool DHShouldPenetrateHEAT(vector HitLocation, vector HitRotation, float PenetrationNumber, out float InAngle, optional class<DamageType> DamageType, optional bool bIsHEATRound)
{
    return true;
}

// TakeDamage - overloaded to allow nade, bayonet, and bash attacks to the driver.
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    // Fix for suicide death messages
    if (DamageType == class'Suicided')
    {
        DamageType = class'ROSuicided';
        ROVehicleWeaponPawn(Owner).TakeDamage(Damage, instigatedBy, Hitlocation, Momentum, damageType);
    }
    else if (DamageType == class'ROSuicided')
    {
        ROVehicleWeaponPawn(Owner).TakeDamage(Damage, instigatedBy, Hitlocation, Momentum, damageType);
    }
}

// There aren't any angles that are below the driver angle for the AT Gun cannon
simulated function bool BelowDriverAngle(vector loc, vector ray)
{
    return false;
}

// Limit the left and right movement of the gun
simulated function int LimitYaw(int yaw)
{
    local int NewYaw;
    local ROVehicleWeaponPawn PwningPawn;

    PwningPawn = ROVehicleWeaponPawn(Owner);

    if (!bLimitYaw)
    {
        return yaw;
    }

    NewYaw = yaw;

    if (PwningPawn != none)
    {
        if (yaw > PwningPawn.DriverPositions[PwningPawn.DriverPositionIndex].ViewPositiveYawLimit)
        {
            NewYaw = PwningPawn.DriverPositions[PwningPawn.DriverPositionIndex].ViewPositiveYawLimit;
        }
        else if (yaw < PwningPawn.DriverPositions[PwningPawn.DriverPositionIndex].ViewNegativeYawLimit)
        {
            NewYaw = PwningPawn.DriverPositions[PwningPawn.DriverPositionIndex].ViewNegativeYawLimit;
        }
    }
    else
    {
        if (yaw > MaxPositiveYaw)
        {
            NewYaw = MaxPositiveYaw;
        }
        else if (yaw < MaxNegativeYaw)
        {
            NewYaw = MaxNegativeYaw;
        }
    }

    return NewYaw;
}

defaultproperties
{
    FrontArmorFactor=1.000000
    RightArmorFactor=0.800000
    LeftArmorFactor=0.800000
    RearArmorFactor=1.000000
    FrontLeftAngle=332.000000
    FrontRightAngle=28.000000
    RearRightAngle=162.000000
    RearLeftAngle=198.000000
}
