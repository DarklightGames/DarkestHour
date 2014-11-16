//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ROTankCannon extends ROTankCannon
    abstract;
     //  config(xGunsightDebugging)


#exec OBJ LOAD FILE=..\sounds\DH_Vehicle_Reloads.uax

//=============================================================================
// Variables
//=============================================================================

// Variables for up to three ammo types
var     int MainAmmoChargeExtra[3];
var()   int InitialTertiaryAmmo;
var()   class<Projectile>   TertiaryProjectileClass;

// Shot dispersion can be customized by round type
var()   float SecondarySpread;
var()   bool  bUsesSecondarySpread;
var()   float TertiarySpread;
var()   bool  bUsesTertiarySpread;

//Manual turret stuff
var     float   ManualRotationsPerSecond;
var     float   PoweredRotationsPerSecond;

// Stuff for fire effects - Ch!cKeN
var()   name                                    FireAttachBone;
var()   vector                                  FireEffectOffset;
var     class<VehicleDamagedEffect>             FireEffectClass;
var     VehicleDamagedEffect                    TurretHatchFireEffect;
var     bool                                    bOnFire;   // Set by Treadcraft base to notify when to start fire effects
var     float                                   BurnTime;

// Armor Penetration stuff
var     bool    bIsAssaultGun; //used to defeat the Stug/JP bug
var     bool    bWasHEATRound;
var     bool    bHasAddedSideArmor;
var     bool    bProjectilePenetrated;
var     bool    bWasShatterProne;
var     bool    bRoundShattered;

var     float   FrontArmorFactor;
var     float   RightArmorFactor;
var     float   LeftArmorFactor;
var     float   RearArmorFactor;

var     float   FrontArmorSlope;
var     float   RightArmorSlope;
var     float   LeftArmorSlope;
var     float   RearArmorSlope;

var     float   DHArmorSlopeTable[16];

var     bool    bManualTurret;

var() float FrontLeftAngle, FrontRightAngle, RearRightAngle, RearLeftAngle;

//Debugging help
var bool    bDrawPenetration;
var bool    bDebuggingText;
var bool    bPenetrationText;
var bool    bLogPenetration;
var bool    bDriverDebugging;

// Debugging and calibration stuff
var   config    bool        bGunFireDebug;
var() config    bool        bGunsightSettingMode;

//==============================================================================
replication
{
     reliable if (bNetDirty && bNetOwner && Role == ROLE_Authority)
       MainAmmoChargeExtra;

     reliable if (bNetDirty && Role==ROLE_Authority)
       bOnFire;

     reliable if (Role==ROLE_Authority)
       bProjectilePenetrated, bRoundShattered; //bManualTurret moved from bNetDirty (in 5.0)

     reliable if ((bNetInitial || bNetDirty) && Role == ROLE_Authority)
        bManualTurret;
}


simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

    if (bOnFire && TurretHatchFireEffect == none)
    {
        // Lets randomise the fire start times to desync them with the driver and engine ones
        if (Level.TimeSeconds - BurnTime > 0.2)
        {
            if (FRand() < 0.1)
            {
                TurretHatchFireEffect = Spawn(FireEffectClass);
                AttachToBone(TurretHatchFireEffect, FireAttachBone);
                TurretHatchFireEffect.SetRelativeLocation(FireEffectOffset);
                TurretHatchFireEffect.UpdateDamagedEffect(true, 0, false, false);
            }
            BurnTime = Level.TimeSeconds;
        }
    }

    if (DH_ROTankCannonPawn(Owner) != none)
    {
        if (bManualTurret)
        {
            RotationsPerSecond = ManualRotationsPerSecond;
            DH_ROTankCannonPawn(Owner).RotateSound = DH_ROTankCannonPawn(Owner).ManualRotateSound;
            DH_ROTankCannonPawn(Owner).PitchSound = DH_ROTankCannonPawn(Owner).ManualPitchSound;
            DH_ROTankCannonPawn(Owner).RotateAndPitchSound = DH_ROTankCannonPawn(Owner).ManualRotateAndPitchSound;
            DH_ROTankCannonPawn(Owner).MinRotateThreshold = DH_ROTankCannonPawn(Owner).ManualMinRotateThreshold;
            DH_ROTankCannonPawn(Owner).MaxRotateThreshold = DH_ROTankCannonPawn(Owner).ManualMaxRotateThreshold;
        }
        else
        {
            RotationsPerSecond = PoweredRotationsPerSecond;
            DH_ROTankCannonPawn(Owner).RotateSound = DH_ROTankCannonPawn(Owner).PoweredRotateSound;
            DH_ROTankCannonPawn(Owner).PitchSound = DH_ROTankCannonPawn(Owner).PoweredPitchSound;
            DH_ROTankCannonPawn(Owner).RotateAndPitchSound = DH_ROTankCannonPawn(Owner).PoweredRotateAndPitchSound;
            DH_ROTankCannonPawn(Owner).MinRotateThreshold = DH_ROTankCannonPawn(Owner).PoweredMinRotateThreshold;
            DH_ROTankCannonPawn(Owner).MaxRotateThreshold = DH_ROTankCannonPawn(Owner).PoweredMaxRotateThreshold;
        }
    }
}

//DH CODE: Return the compound hit angle
simulated function float GetCompoundAngle(float AOI, float ArmorSlopeDegrees)
{
    local float CompoundAngle;

    // convert the angle degrees to radians
    AOI = abs(AOI * 0.01745329252);
    ArmorSlopeDegrees = abs(ArmorSlopeDegrees * 0.01745329252);

    CompoundAngle = Acos(Cos(ArmorSlopeDegrees)*Cos(AOI));

    return CompoundAngle;
}

//DH CODE: Returns (T/d) for APC/APCBC shells
simulated function float GetOverMatch(float ArmorFactor, float ShellDiameter)
{
    local float OverMatchFactor;

    OverMatchFactor = (ArmorFactor / ShellDiameter);

    return OverMatchFactor;

}

//DH CODE: Calculate APC/APCBC penetration
simulated function bool PenetrationAPC(float ArmorFactor, float CompoundAngle, float PenetrationNumber, float OverMatchFactor, bool bShatterProne)
{
    local float EffectiveArmor;
    local float CompoundAngleDegrees;
    local float SlopeMultiplier;
    local float PenetrationRatio;

    //convert angle back to degrees
    CompoundAngleDegrees = CompoundAngle * 57.2957795131;

    //fix
    if (CompoundAngleDegrees > 90)
    {
        CompoundAngleDegrees = 180 - CompoundAngleDegrees;

    }

    if (bDebuggingText)
    {
        Level.Game.Broadcast(self, "CompoundAngle: "$CompoundAngleDegrees);
    }

    //After Bird & Livingston
    DHArmorSlopeTable[0]= 1.01 * (OverMatchFactor**0.0225);  //10
    DHArmorSlopeTable[1]= 1.03 * (OverMatchFactor**0.0327);  //15
    DHArmorSlopeTable[2]= 1.10 * (OverMatchFactor**0.0454);  //20
    DHArmorSlopeTable[3]= 1.17 * (OverMatchFactor**0.0549);  //25
    DHArmorSlopeTable[4]= 1.27 * (OverMatchFactor**0.0655);  //30
    DHArmorSlopeTable[5]= 1.39 * (OverMatchFactor**0.0993);  //35
    DHArmorSlopeTable[6]= 1.54 * (OverMatchFactor**0.1388);  //40
    DHArmorSlopeTable[7]= 1.72 * (OverMatchFactor**0.1655);  //45
    DHArmorSlopeTable[8]= 1.94 * (OverMatchFactor**0.2035);  //50
    DHArmorSlopeTable[9]= 2.12 * (OverMatchFactor**0.2427);  //55
    DHArmorSlopeTable[10]= 2.56 * (OverMatchFactor**0.2450); //60
    DHArmorSlopeTable[11]= 3.20 * (OverMatchFactor**0.3354); //65
    DHArmorSlopeTable[12]= 3.98 * (OverMatchFactor**0.3478); //70
    DHArmorSlopeTable[13]= 5.17 * (OverMatchFactor**0.3831); //75
    DHArmorSlopeTable[14]= 8.09 * (OverMatchFactor**0.4131); //80
    DHArmorSlopeTable[15]= 11.32 * (OverMatchFactor**0.4550); //85

    //SlopeMultiplier calcs - using linear interpolation
    if      (CompoundAngleDegrees < 10)  SlopeMultiplier = (DHArmorSlopeTable[0] + (10 - CompoundAngleDegrees) * (DHArmorSlopeTable[0]-DHArmorSlopeTable[1]) / 10);
    else if (CompoundAngleDegrees < 15)  SlopeMultiplier = (DHArmorSlopeTable[1] + (15 - CompoundAngleDegrees) * (DHArmorSlopeTable[0]-DHArmorSlopeTable[1]) / 5);
    else if (CompoundAngleDegrees < 20)  SlopeMultiplier = (DHArmorSlopeTable[2] + (20 - CompoundAngleDegrees) * (DHArmorSlopeTable[1]-DHArmorSlopeTable[2]) / 5);
    else if (CompoundAngleDegrees < 25)  SlopeMultiplier = (DHArmorSlopeTable[3] + (25 - CompoundAngleDegrees) * (DHArmorSlopeTable[2]-DHArmorSlopeTable[3]) / 5);
    else if (CompoundAngleDegrees < 30)  SlopeMultiplier = (DHArmorSlopeTable[4] + (30 - CompoundAngleDegrees) * (DHArmorSlopeTable[3]-DHArmorSlopeTable[4]) / 5);
    else if (CompoundAngleDegrees < 35)  SlopeMultiplier = (DHArmorSlopeTable[5] + (35 - CompoundAngleDegrees) * (DHArmorSlopeTable[4]-DHArmorSlopeTable[5]) / 5);
    else if (CompoundAngleDegrees < 40)  SlopeMultiplier = (DHArmorSlopeTable[6] + (40 - CompoundAngleDegrees) * (DHArmorSlopeTable[5]-DHArmorSlopeTable[6]) / 5);
    else if (CompoundAngleDegrees < 45)  SlopeMultiplier = (DHArmorSlopeTable[7] + (45 - CompoundAngleDegrees) * (DHArmorSlopeTable[6]-DHArmorSlopeTable[7]) / 5);
    else if (CompoundAngleDegrees < 50)  SlopeMultiplier = (DHArmorSlopeTable[8] + (50 - CompoundAngleDegrees) * (DHArmorSlopeTable[7]-DHArmorSlopeTable[8]) / 5);
    else if (CompoundAngleDegrees < 55)  SlopeMultiplier = (DHArmorSlopeTable[9] + (55 - CompoundAngleDegrees) * (DHArmorSlopeTable[8]-DHArmorSlopeTable[9]) / 5);
    else if (CompoundAngleDegrees < 60)  SlopeMultiplier = (DHArmorSlopeTable[10] + (60 - CompoundAngleDegrees) * (DHArmorSlopeTable[9]-DHArmorSlopeTable[10]) / 5);
    else if (CompoundAngleDegrees < 65)  SlopeMultiplier = (DHArmorSlopeTable[11] + (65 - CompoundAngleDegrees) * (DHArmorSlopeTable[10]-DHArmorSlopeTable[11]) / 5);
    else if (CompoundAngleDegrees < 70)  SlopeMultiplier = (DHArmorSlopeTable[12] + (70 - CompoundAngleDegrees) * (DHArmorSlopeTable[11]-DHArmorSlopeTable[12]) / 5);
    else if (CompoundAngleDegrees < 75)  SlopeMultiplier = (DHArmorSlopeTable[13] + (75 - CompoundAngleDegrees) * (DHArmorSlopeTable[12]-DHArmorSlopeTable[13]) / 5);
    else if (CompoundAngleDegrees < 80)  SlopeMultiplier = (DHArmorSlopeTable[14] + (80 - CompoundAngleDegrees) * (DHArmorSlopeTable[13]-DHArmorSlopeTable[14]) / 5);
    else if (CompoundAngleDegrees < 85)  SlopeMultiplier = (DHArmorSlopeTable[15] + (85 - CompoundAngleDegrees) * (DHArmorSlopeTable[14]-DHArmorSlopeTable[15]) / 5);
    else SlopeMultiplier = DHArmorSlopeTable[15];

    if (bDebuggingText)
    {
        Level.Game.Broadcast(self, "SlopeMultiplier: "$SlopeMultiplier);
    }

    EffectiveArmor = ArmorFactor * SlopeMultiplier;
    PenetrationRatio = PenetrationNumber / EffectiveArmor;

    if (bPenetrationText && Role == ROLE_Authority)
    {
        Level.Game.Broadcast(self, "Effective Armor: "$EffectiveArmor*10$"mm");
        Level.Game.Broadcast(self, "Shot penetration: "$PenetrationNumber*10$"mm");
    }

    if (bShatterProne)
        bWasShatterProne = true;

    //test for shatter gap
    if (bWasShatterProne && OverMatchFactor > 0.8)
    {
        if ((PenetrationRatio >= 1.0 && PenetrationRatio < 1.06) || PenetrationRatio > 1.19)
        {

            DH_ROTreadCraft(Base).bProjectilePenetrated=true;
            DH_ROTreadCraft(Base).bWasTurretHit=true;
            bProjectilePenetrated = true; //to determine if interior damage is done
            return true;
        }
        else if (PenetrationRatio >= 1.06 && PenetrationRatio <= 1.19) //shatter gap
        {
            bRoundShattered=true;
            DH_ROTreadCraft(Base).bProjectilePenetrated=false;
            DH_ROTreadCraft(Base).bWasTurretHit=false;
            bProjectilePenetrated = false;
            return false;
        }
        else if (PenetrationRatio < 1.0)
        {

            DH_ROTreadCraft(Base).bProjectilePenetrated=false;
            DH_ROTreadCraft(Base).bWasTurretHit=false;
            bProjectilePenetrated = false;
            return false;
        }
    }
    else
    {
        if (PenetrationRatio >= 1.0)
        {
            DH_ROTreadCraft(Base).bProjectilePenetrated=true;
            DH_ROTreadCraft(Base).bWasTurretHit=true;
            bProjectilePenetrated = true; //to determine if interior damage is done
            return true;
        }
        else
        {
            DH_ROTreadCraft(Base).bProjectilePenetrated=false;
            DH_ROTreadCraft(Base).bWasTurretHit=false;
            bProjectilePenetrated = false;
            return false;
        }
    }
}

//DH CODE: Calculate HVAP penetration
simulated function bool PenetrationHVAP(float ArmorFactor, float CompoundAngle, float PenetrationNumber, bool bShatterProne)
{
    local float EffectiveArmor;
    local float CompoundAngleDegrees;
    local float CompoundExp;
    local float PenetrationRatio;

    //convert angle back to degrees
    CompoundAngleDegrees = CompoundAngle * 57.2957795131;

    //fix
    if (CompoundAngleDegrees > 90)
    {
        CompoundAngleDegrees = 180 - CompoundAngleDegrees;

    }

    if (bDebuggingText)
    {
        Level.Game.Broadcast(self, "CompoundAngle: "$CompoundAngleDegrees);
    }

    //New EffectiveArmor calcs
    if (CompoundAngleDegrees <= 25)
    {
       CompoundExp = CompoundAngleDegrees**2.2;
       EffectiveArmor = (ArmorFactor * (2.71828 ** (CompoundExp * 0.0001727)));
    }
    else
    {
       CompoundExp = CompoundAngleDegrees**1.5;
       EffectiveArmor = (ArmorFactor * 0.7277 * (2.71828 ** (CompoundExp * 0.003787)));
    }

    PenetrationRatio = PenetrationNumber / EffectiveArmor;

    if (bPenetrationText && Role == ROLE_Authority)
    {
        Level.Game.Broadcast(self, "Effective Armor: "$EffectiveArmor*10$"mm");
        Level.Game.Broadcast(self, "Shot penetration: "$PenetrationNumber*10$"mm");
    }

    if (bShatterProne)
        bWasShatterProne = true;

    //test for shatter gap
    if (bWasShatterProne)
    {
        if ((PenetrationRatio >= 1.0 && PenetrationRatio < 1.10) || PenetrationRatio > 1.34)
        {

            DH_ROTreadCraft(Base).bProjectilePenetrated=true;
            DH_ROTreadCraft(Base).bWasTurretHit=true;
            bProjectilePenetrated = true; //to determine if interior damage is done
            return true;
        }
        else if (PenetrationRatio >= 1.10 && PenetrationRatio <= 1.34)
        {
            bRoundShattered=true;
            DH_ROTreadCraft(Base).bProjectilePenetrated=false;
            DH_ROTreadCraft(Base).bWasTurretHit=false;
            bProjectilePenetrated = false;
            return false;
        }
        else if (PenetrationRatio < 1.0)
        {

            DH_ROTreadCraft(Base).bProjectilePenetrated=false;
            DH_ROTreadCraft(Base).bWasTurretHit=false;
            bProjectilePenetrated = false;
            return false;
        }
    }
    else
    {
        if (PenetrationRatio >= 1.0)
        {
            DH_ROTreadCraft(Base).bProjectilePenetrated=true;
            DH_ROTreadCraft(Base).bWasTurretHit=true;
            bProjectilePenetrated = true; //to determine if interior damage is done
            return true;
        }
        else
        {
            DH_ROTreadCraft(Base).bProjectilePenetrated=false;
            DH_ROTreadCraft(Base).bWasTurretHit=false;
            bProjectilePenetrated = false;
            return false;
        }
    }
}

//DH CODE: Calculate HVAP penetration - 90mm
simulated function bool PenetrationHVAPLarge(float ArmorFactor, float CompoundAngle, float PenetrationNumber, bool bShatterProne)
{

    local float EffectiveArmor;
    local float CompoundAngleDegrees;
    local float CompoundExp;
    local float PenetrationRatio;

    //convert angle back to degrees
    CompoundAngleDegrees = CompoundAngle * 57.2957795131;

    //fix
    if (CompoundAngleDegrees > 90)
    {
        CompoundAngleDegrees = 180 - CompoundAngleDegrees;

    }

    if (bDebuggingText)
    {
        Level.Game.Broadcast(self, "CompoundAngle: "$CompoundAngleDegrees);
    }

    //New EffectiveArmor calcs
    if (CompoundAngleDegrees <= 30)
    {
       CompoundExp = CompoundAngleDegrees**1.75;
       EffectiveArmor = (ArmorFactor * (2.71828 ** (CompoundExp * 0.000662)));
    }
    else
    {
       CompoundExp = CompoundAngleDegrees**2.2;
       EffectiveArmor = (ArmorFactor * 0.9043 * (2.71828 ** (CompoundExp * 0.0001987)));
    }

    PenetrationRatio = PenetrationNumber / EffectiveArmor;

    if (bPenetrationText && Role == ROLE_Authority)
    {
        Level.Game.Broadcast(self, "Effective Armor: "$EffectiveArmor*10$"mm");
        Level.Game.Broadcast(self, "Shot penetration: "$PenetrationNumber*10$"mm");
    }

    if (bShatterProne)
        bWasShatterProne = true;

    //test for shatter gap
    if (bWasShatterProne)
    {
        if ((PenetrationRatio >= 1.0 && PenetrationRatio < 1.10) || PenetrationRatio > 1.27)
        {

            DH_ROTreadCraft(Base).bProjectilePenetrated=true;
            DH_ROTreadCraft(Base).bWasTurretHit=true;
            bProjectilePenetrated = true; //to determine if interior damage is done
            return true;
        }
        else if (PenetrationRatio >= 1.10 && PenetrationRatio <= 1.27)
        {
            bRoundShattered=true;
            DH_ROTreadCraft(Base).bProjectilePenetrated=false;
            DH_ROTreadCraft(Base).bWasTurretHit=false;
            bProjectilePenetrated = false;
            return false;
        }
        else if (PenetrationRatio < 1.0)
        {

            DH_ROTreadCraft(Base).bProjectilePenetrated=false;
            DH_ROTreadCraft(Base).bWasTurretHit=false;
            bProjectilePenetrated = false;
            return false;
        }
    }
    else
    {
        if (PenetrationRatio >= 1.0)
        {
            DH_ROTreadCraft(Base).bProjectilePenetrated=true;
            DH_ROTreadCraft(Base).bWasTurretHit=true;
            bProjectilePenetrated = true; //to determine if interior damage is done
            return true;
        }
        else
        {
            DH_ROTreadCraft(Base).bProjectilePenetrated=false;
            DH_ROTreadCraft(Base).bWasTurretHit=false;
            bProjectilePenetrated = false;
            return false;
        }
    }
}

//DH CODE: Calculate APDS penetration
simulated function bool PenetrationAPDS(float ArmorFactor, float CompoundAngle, float PenetrationNumber, bool bShatterProne)
{
    local float EffectiveArmor;
    local float CompoundAngleDegrees;
    local float CompoundExp;
    local float PenetrationRatio;

    //convert angle back to degrees
    CompoundAngleDegrees = CompoundAngle * 57.2957795131;

    //fix
    if (CompoundAngleDegrees > 90)
    {
        CompoundAngleDegrees = 180 - CompoundAngleDegrees;

    }

    if (bDebuggingText)
    {
        Level.Game.Broadcast(self, "CompoundAngle: "$CompoundAngleDegrees);
    }

    CompoundExp = CompoundAngleDegrees ** 2.6;

    //New EffectiveArmor calcs
    EffectiveArmor = (ArmorFactor * (2.71828 ** (CompoundExp * 0.00003011)));

    PenetrationRatio = PenetrationNumber / EffectiveArmor;

    if (bPenetrationText && Role == ROLE_Authority)
    {
        Level.Game.Broadcast(self, "Effective Armor: "$EffectiveArmor*10$"mm");
        Level.Game.Broadcast(self, "Shot penetration: "$PenetrationNumber*10$"mm");
    }

    if (bShatterProne)
        bWasShatterProne = true;

    //test for shatter gap
    if (bWasShatterProne)
    {
        if ((PenetrationRatio >= 1.0 && PenetrationRatio < 1.06) || PenetrationRatio > 1.20)
        {

            DH_ROTreadCraft(Base).bProjectilePenetrated=true;
            DH_ROTreadCraft(Base).bWasTurretHit=true;
            bProjectilePenetrated = true; //to determine if interior damage is done
            return true;
        }
        else if (PenetrationRatio >= 1.06 && PenetrationRatio <= 1.20)
        {
            bRoundShattered=true;
            DH_ROTreadCraft(Base).bProjectilePenetrated=false;
            DH_ROTreadCraft(Base).bWasTurretHit=false;
            bProjectilePenetrated = false;
            return false;
        }
        else if (PenetrationRatio < 1.0)
        {

            DH_ROTreadCraft(Base).bProjectilePenetrated=false;
            DH_ROTreadCraft(Base).bWasTurretHit=false;
            bProjectilePenetrated = false;
            return false;
        }
    }
    else
    {
        if (PenetrationRatio >= 1.0)
        {
            DH_ROTreadCraft(Base).bProjectilePenetrated=true;
            DH_ROTreadCraft(Base).bWasTurretHit=true;
            bProjectilePenetrated = true; //to determine if interior damage is done
            return true;
        }
        else
        {
            DH_ROTreadCraft(Base).bProjectilePenetrated=false;
            DH_ROTreadCraft(Base).bWasTurretHit=false;
            bProjectilePenetrated = false;
            return false;
        }
    }
}

//DH CODE: Calculate HEAT penetration
simulated function bool PenetrationHEAT(float ArmorFactor, float CompoundAngle, float PenetrationNumber, bool bIsHEATRound)
{

    local float EffectiveArmor;
    local float CompoundAngleDegrees;
    local float CompoundAngleFixed;
    local float SlopeMultiplier;
    local float PenetrationRatio;

    //convert angle back to degrees
    CompoundAngleDegrees = CompoundAngle * 57.2957795131;

    //fix
    if (CompoundAngleDegrees > 90)
    {
        CompoundAngleDegrees = 180 - CompoundAngleDegrees;

    }

    if (bDebuggingText)
    {
        Level.Game.Broadcast(self, "CompoundAngle: "$CompoundAngleDegrees);
    }

    //convert angle back to radians
    CompoundAngleFixed = abs(CompoundAngleDegrees * 0.01745329252);

    //calculate the slope
    SlopeMultiplier = 1 / Cos(CompoundAngleFixed);

    if (bDebuggingText)
    {
        Level.Game.Broadcast(self, "SlopeMultiplier: "$SlopeMultiplier);
    }

    EffectiveArmor = ArmorFactor * SlopeMultiplier;

    PenetrationRatio = PenetrationNumber / EffectiveArmor;

    if (bPenetrationText && Role == ROLE_Authority)
    {
        Level.Game.Broadcast(self, "Effective Armor: "$EffectiveArmor*10$"mm");
        Level.Game.Broadcast(self, "Shot penetration: "$PenetrationNumber*10$"mm");
    }

    if (bIsHEATRound)
        bWasHEATRound = true;

    if (PenetrationRatio >= 1.0)
    {
        DH_ROTreadCraft(Base).bProjectilePenetrated=true;
        DH_ROTreadCraft(Base).bWasTurretHit=true;
        DH_ROTreadCraft(Base).bWasHEATRound=true;
        bProjectilePenetrated = true; //to determine if interior damage is done
        return true;
    }
    else
    {
        DH_ROTreadCraft(Base).bProjectilePenetrated=false;
        DH_ROTreadCraft(Base).bWasTurretHit=false;
        bProjectilePenetrated = false;
        return false;
    }
}

simulated function bool DHShouldPenetrateAPC(vector HitLocation, vector HitRotation, float PenetrationNumber, out float InAngle, float ShellDiameter, optional class<DamageType> DamageType, optional bool bShatterProne)
{

    local vector  LocDir, HitDir;
    local float   HitAngle,Side;//InAngle;
    local vector  X,Y,Z;
    local float   InAngleDegrees;
    local rotator AimRot;
    local float   WeaponRotationDegrees;

    WeaponRotationDegrees = (CurrentAim.Yaw / 65536.0 * 360);

    if (bIsAssaultGun)
    {
       DH_ROTreadCraft(Base).bAssaultWeaponHit=true;
       return false;
    }

    // Figure out which side we hit
    LocDir = vector(Rotation);
    LocDir.Z = 0;
    HitDir =  Hitlocation - Location;
    HitDir.Z = 0;
    HitAngle = Acos(Normal(LocDir) dot Normal(HitDir));

    //  Penetration Debugging
    if (bLogPenetration)
    {
        log("Raw hitangle = "$HitAngle$" Converted hitangle = "$(57.2957795131 * HitAngle));
    }

    // Convert the angle into degrees from radians
    HitAngle*=57.2957795131;
    GetAxes(Rotation,X,Y,Z);
    Side = Y dot HitDir;

    //  Penetration Debugging
    if (bDrawPenetration)
    {
        ClearStayingDebugLines();
        AimRot = Rotation;
        AimRot.Yaw += (FrontLeftAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 255, 0);
        AimRot = Rotation;
        AimRot.Yaw += (FrontRightAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),255, 255, 0);
        AimRot = Rotation;
        AimRot.Yaw += (RearRightAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 0, 255);
        AimRot = Rotation;
        AimRot.Yaw += (RearLeftAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 0, 0);
    }

    if (side < 0)
    {
       HitAngle = 360 + (HitAngle* -1);
    }

    HitAngle = HitAngle - WeaponRotationDegrees;

    if (HitAngle < 0)
    {
       HitAngle = HitAngle + 360;
       X = X >> CurrentAim;
       Y = Y >> CurrentAim;
    }

    if (bDebuggingText && Role == ROLE_Authority)
    Level.Game.Broadcast(self, "HitAngle: "$HitAngle$"degrees");

    if (HitAngle >= FrontLeftAngle || Hitangle < FrontRightAngle)  //Frontal hit
    {

       InAngle= Acos(Normal(-HitRotation) dot Normal(X));
       InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(X),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the front of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from front to rear");
                Level.Game.Broadcast(self, "Rear turret hit, base armor = "$RearArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (RearArmorFactor > PenetrationNumber)
                return false;

            return PenetrationAPC(RearArmorFactor, GetCompoundAngle(InAngleDegrees, RearArmorSlope), PenetrationNumber, GetOverMatch(RearArmorFactor, ShellDiameter), bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Front turret hit, base armor = "$FrontArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (FrontArmorFactor > PenetrationNumber)
            return false;

        return PenetrationAPC(FrontArmorFactor, GetCompoundAngle(InAngleDegrees, FrontArmorSlope), PenetrationNumber, GetOverMatch(FrontArmorFactor, ShellDiameter), bShatterProne);

    }
    else if (HitAngle >= FrontRightAngle && Hitangle < RearRightAngle)     //Right side hit
    {
        // Don't penetrate with HEAT if there is added side armor, unless passes chance test
        if (bHasAddedSideArmor && DamageType != none && DamageType.default.bArmorStops)
        {
           return false;
        }

        InAngle= Acos(Normal(-HitRotation) dot Normal(Y));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-Y),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the right side of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from right to left");
                Level.Game.Broadcast(self, "Left turret hit, base armor = "$LeftArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (LeftArmorFactor > PenetrationNumber)
                return false;

            return PenetrationAPC(LeftArmorFactor, GetCompoundAngle(InAngleDegrees, LeftArmorSlope), PenetrationNumber, GetOverMatch(LeftArmorFactor, ShellDiameter), bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Right turret hit, base armor "$RightArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (RightArmorFactor > PenetrationNumber)
            return false;

        return PenetrationAPC(RightArmorFactor, GetCompoundAngle(InAngleDegrees, RightArmorSlope), PenetrationNumber, GetOverMatch(RightArmorFactor, ShellDiameter), bShatterProne);

    }
    else if (HitAngle >= RearRightAngle && Hitangle < RearLeftAngle)  //Rear hit
    {

        InAngle= Acos(Normal(-HitRotation) dot Normal(-X));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-X),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the back of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from rear to front");
                Level.Game.Broadcast(self, "Front turret hit, base armor = "$FrontArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (FrontArmorFactor > PenetrationNumber)
                return false;

            return PenetrationAPC(FrontArmorFactor, GetCompoundAngle(InAngleDegrees, FrontArmorSlope), PenetrationNumber, GetOverMatch(FrontArmorFactor, ShellDiameter), bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Rear turret hit, base armor = "$RearArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (RearArmorFactor > PenetrationNumber)
            return false;

        return PenetrationAPC(RearArmorFactor, GetCompoundAngle(InAngleDegrees, RearArmorSlope), PenetrationNumber, GetOverMatch(RearArmorFactor, ShellDiameter), bShatterProne);
    }
    else if (HitAngle >= RearLeftAngle && Hitangle < FrontLeftAngle)  //Left
    {
        // Don't penetrate with HEAT if there is added side armor, unless passes chance test
        if (bHasAddedSideArmor && DamageType != none && DamageType.default.bArmorStops)
        {
            return false;
        }

        InAngle= Acos(Normal(-HitRotation) dot Normal(-Y));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(Y),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the right side of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from left to right");
                Level.Game.Broadcast(self, "Right turret hit, base armor = "$RightArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (RightArmorFactor > PenetrationNumber)
                return false;

            return PenetrationAPC(RightArmorFactor, GetCompoundAngle(InAngleDegrees, RightArmorSlope), PenetrationNumber, GetOverMatch(RightArmorFactor, ShellDiameter), bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Left turret hit, base armor = "$LeftArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (LeftArmorFactor > PenetrationNumber)
            return false;

        return PenetrationAPC(LeftArmorFactor, GetCompoundAngle(InAngleDegrees, LeftArmorSlope), PenetrationNumber, GetOverMatch(LeftArmorFactor, ShellDiameter), bShatterProne);
    }
    else
    {
       log ("We shoulda hit something!!!!");
       Level.Game.Broadcast(self, " ?!? We shoulda hit something!!!!");
       return false;
    }
}

simulated function bool DHShouldPenetrateHVAP(vector HitLocation, vector HitRotation, float PenetrationNumber, out float InAngle, optional class<DamageType> DamageType, optional bool bShatterProne)
{

    local vector  LocDir, HitDir;
    local float   HitAngle,Side;//InAngle;
    local vector  X,Y,Z;
    local float   InAngleDegrees;
    local rotator AimRot;
    local float   WeaponRotationDegrees;

    WeaponRotationDegrees = (CurrentAim.Yaw / 65536.0 * 360);

    if (bIsAssaultGun)
    {
        DH_ROTreadCraft(Base).bAssaultWeaponHit=true;
            return false;
    }

    // Figure out which side we hit
    LocDir = vector(Rotation);
    LocDir.Z = 0;
    HitDir =  Hitlocation - Location;
    HitDir.Z = 0;
    HitAngle = Acos(Normal(LocDir) dot Normal(HitDir));

    //  Penetration Debugging
    if (bLogPenetration)
    {
        log("Raw hitangle = "$HitAngle$" Converted hitangle = "$(57.2957795131 * HitAngle));
    }

    // Convert the angle into degrees from radians
    HitAngle*=57.2957795131;
    GetAxes(Rotation,X,Y,Z);
    Side = Y dot HitDir;

    //  Penetration Debugging
    if (bDrawPenetration)
    {
        ClearStayingDebugLines();
        AimRot = Rotation;
        AimRot.Yaw += (FrontLeftAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 255, 0);
        AimRot = Rotation;
        AimRot.Yaw += (FrontRightAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),255, 255, 0);
        AimRot = Rotation;
        AimRot.Yaw += (RearRightAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 0, 255);
        AimRot = Rotation;
        AimRot.Yaw += (RearLeftAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 0, 0);
    }

    if (side < 0)
    {
       HitAngle = 360 + (HitAngle* -1);
    }

    HitAngle = HitAngle - WeaponRotationDegrees;

    if (HitAngle < 0)
    {
       HitAngle = HitAngle + 360;
       X = X >> CurrentAim;
       Y = Y >> CurrentAim;
    }

    if (bDebuggingText && Role == ROLE_Authority)
    Level.Game.Broadcast(self, "HitAngle: "$HitAngle$"degrees");

    if (HitAngle >= FrontLeftAngle || Hitangle < FrontRightAngle)  //Frontal hit
    {

       InAngle= Acos(Normal(-HitRotation) dot Normal(X));
       InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(X),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the front of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from front to rear");
                Level.Game.Broadcast(self, "Rear turret hit, base armor = "$RearArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (RearArmorFactor > PenetrationNumber)
                return false;

            return PenetrationHVAP(RearArmorFactor, GetCompoundAngle(InAngleDegrees, RearArmorSlope), PenetrationNumber, bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Front turret hit, base armor = "$FrontArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (FrontArmorFactor > PenetrationNumber)
            return false;

        return PenetrationHVAP(FrontArmorFactor, GetCompoundAngle(InAngleDegrees, FrontArmorSlope), PenetrationNumber, bShatterProne);
    }
    else if (HitAngle >= FrontRightAngle && Hitangle < RearRightAngle)  //Right side hit
    {
        // Don't penetrate with HEAT if there is added side armor, unless passes chance test
        if (bHasAddedSideArmor && DamageType != none && DamageType.default.bArmorStops)
        {
           return false;
        }

        InAngle= Acos(Normal(-HitRotation) dot Normal(Y));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-Y),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the right side of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from right to left");
                Level.Game.Broadcast(self, "Left turret hit, base armor = "$LeftArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (LeftArmorFactor > PenetrationNumber)
                return false;

            return PenetrationHVAP(LeftArmorFactor, GetCompoundAngle(InAngleDegrees, LeftArmorSlope), PenetrationNumber, bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Right turret hull hit, base armor "$RightArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (RightArmorFactor > PenetrationNumber)
            return false;

        return PenetrationHVAP(RightArmorFactor, GetCompoundAngle(InAngleDegrees, RightArmorSlope), PenetrationNumber, bShatterProne);

    }
    else if (HitAngle >= RearRightAngle && Hitangle < RearLeftAngle)  //Rear hit
    {

        InAngle= Acos(Normal(-HitRotation) dot Normal(-X));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-X),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the back of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from rear to front");
                Level.Game.Broadcast(self, "Front turret hit, base armor = "$FrontArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (FrontArmorFactor > PenetrationNumber)
                return false;

            return PenetrationHVAP(FrontArmorFactor, GetCompoundAngle(InAngleDegrees, FrontArmorSlope), PenetrationNumber, bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Rear turret hit, base armor = "$RearArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (RearArmorFactor > PenetrationNumber)
            return false;

        return PenetrationHVAP(RearArmorFactor, GetCompoundAngle(InAngleDegrees, RearArmorSlope), PenetrationNumber, bShatterProne);
    }
    else if (HitAngle >= RearLeftAngle && Hitangle < FrontLeftAngle)  //Left
    {
        // Don't penetrate with HEAT if there is added side armor, unless passes chance test
        if (bHasAddedSideArmor && DamageType != none && DamageType.default.bArmorStops)
        {
            return false;
        }

        InAngle= Acos(Normal(-HitRotation) dot Normal(-Y));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(Y),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the right side of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from left to right");
                Level.Game.Broadcast(self, "Right turret hit, base armor = "$RightArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (RightArmorFactor > PenetrationNumber)
                return false;

            return PenetrationHVAP(RightArmorFactor, GetCompoundAngle(InAngleDegrees, RightArmorSlope), PenetrationNumber, bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Left turret hit, base armor = "$LeftArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (LeftArmorFactor > PenetrationNumber)
            return false;

        return PenetrationHVAP(LeftArmorFactor, GetCompoundAngle(InAngleDegrees, LeftArmorSlope), PenetrationNumber, bShatterProne);

    }
    else
    {
       log ("We shoulda hit something!!!!");
       Level.Game.Broadcast(self, " ?!? We shoulda hit something!!!!");
       return false;
    }
}

simulated function bool DHShouldPenetrateHVAPLarge(vector HitLocation, vector HitRotation, float PenetrationNumber, out float InAngle, optional class<DamageType> DamageType, optional bool bShatterProne)
{

    local vector  LocDir, HitDir;
    local float   HitAngle,Side;//InAngle;
    local vector  X,Y,Z;
    local float   InAngleDegrees;
    local rotator AimRot;
    local float   WeaponRotationDegrees;

    WeaponRotationDegrees = (CurrentAim.Yaw / 65536.0 * 360);

    if (bIsAssaultGun)
    {
        DH_ROTreadCraft(Base).bAssaultWeaponHit=true;
            return false;
    }

    // Figure out which side we hit
    LocDir = vector(Rotation);
    LocDir.Z = 0;
    HitDir =  Hitlocation - Location;
    HitDir.Z = 0;
    HitAngle = Acos(Normal(LocDir) dot Normal(HitDir));

    //  Penetration Debugging
    if (bLogPenetration)
    {
        log("Raw hitangle = "$HitAngle$" Converted hitangle = "$(57.2957795131 * HitAngle));
    }

    // Convert the angle into degrees from radians
    HitAngle*=57.2957795131;
    GetAxes(Rotation,X,Y,Z);
    Side = Y dot HitDir;

    //  Penetration Debugging
    if (bDrawPenetration)
    {
        ClearStayingDebugLines();
        AimRot = Rotation;
        AimRot.Yaw += (FrontLeftAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 255, 0);
        AimRot = Rotation;
        AimRot.Yaw += (FrontRightAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),255, 255, 0);
        AimRot = Rotation;
        AimRot.Yaw += (RearRightAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 0, 255);
        AimRot = Rotation;
        AimRot.Yaw += (RearLeftAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 0, 0);
    }

    if (side < 0)
    {
       HitAngle = 360 + (HitAngle* -1);
    }

    HitAngle = HitAngle - WeaponRotationDegrees;

    if (HitAngle < 0)
    {
       HitAngle = HitAngle + 360;
       X = X >> CurrentAim;
       Y = Y >> CurrentAim;
    }

    if (bDebuggingText && Role == ROLE_Authority)
    Level.Game.Broadcast(self, "HitAngle: "$HitAngle$"degrees");

    if (HitAngle >= FrontLeftAngle || Hitangle < FrontRightAngle)  //Frontal hit
    {

       InAngle= Acos(Normal(-HitRotation) dot Normal(X));
       InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(X),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the front of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from front to rear");
                Level.Game.Broadcast(self, "Rear turret hit, base armor = "$RearArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (RearArmorFactor > PenetrationNumber)
                return false;

            return PenetrationHVAPLarge(RearArmorFactor, GetCompoundAngle(InAngleDegrees, RearArmorSlope), PenetrationNumber, bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Front turret hit, base armor = "$FrontArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (FrontArmorFactor > PenetrationNumber)
            return false;

        return PenetrationHVAPLarge(FrontArmorFactor, GetCompoundAngle(InAngleDegrees, FrontArmorSlope), PenetrationNumber, bShatterProne);
    }
    else if (HitAngle >= FrontRightAngle && Hitangle < RearRightAngle)  //Right side hit
    {
        // Don't penetrate with HEAT if there is added side armor, unless passes chance test
        if (bHasAddedSideArmor && DamageType != none && DamageType.default.bArmorStops)
        {
           return false;
        }

        InAngle= Acos(Normal(-HitRotation) dot Normal(Y));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-Y),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the right side of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from right to left");
                Level.Game.Broadcast(self, "Left turret hit, base armor = "$LeftArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (LeftArmorFactor > PenetrationNumber)
                return false;

            return PenetrationHVAPLarge(LeftArmorFactor, GetCompoundAngle(InAngleDegrees, LeftArmorSlope), PenetrationNumber, bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Right turret hull hit, base armor "$RightArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (RightArmorFactor > PenetrationNumber)
            return false;

        return PenetrationHVAPLarge(RightArmorFactor, GetCompoundAngle(InAngleDegrees, RightArmorSlope), PenetrationNumber, bShatterProne);

    }
    else if (HitAngle >= RearRightAngle && Hitangle < RearLeftAngle)  //Rear hit
    {

        InAngle= Acos(Normal(-HitRotation) dot Normal(-X));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-X),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the back of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from rear to front");
                Level.Game.Broadcast(self, "Front turret hit, base armor = "$FrontArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (FrontArmorFactor > PenetrationNumber)
                return false;

            return PenetrationHVAPLarge(FrontArmorFactor, GetCompoundAngle(InAngleDegrees, FrontArmorSlope), PenetrationNumber, bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Rear turret hit, base armor = "$RearArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (RearArmorFactor > PenetrationNumber)
            return false;

        return PenetrationHVAPLarge(RearArmorFactor, GetCompoundAngle(InAngleDegrees, RearArmorSlope), PenetrationNumber, bShatterProne);
    }
    else if (HitAngle >= RearLeftAngle && Hitangle < FrontLeftAngle)  //Left
    {
        // Don't penetrate with HEAT if there is added side armor, unless passes chance test
        if (bHasAddedSideArmor && DamageType != none && DamageType.default.bArmorStops)
        {
            return false;
        }

        InAngle= Acos(Normal(-HitRotation) dot Normal(-Y));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(Y),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the right side of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from left to right");
                Level.Game.Broadcast(self, "Right turret hit, base armor = "$RightArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (RightArmorFactor > PenetrationNumber)
                return false;

            return PenetrationHVAPLarge(RightArmorFactor, GetCompoundAngle(InAngleDegrees, RightArmorSlope), PenetrationNumber, bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Left turret hit, base armor = "$LeftArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (LeftArmorFactor > PenetrationNumber)
            return false;

        return PenetrationHVAPLarge(LeftArmorFactor, GetCompoundAngle(InAngleDegrees, LeftArmorSlope), PenetrationNumber, bShatterProne);

    }
    else
    {
       log ("We shoulda hit something!!!!");
       Level.Game.Broadcast(self, " ?!? We shoulda hit something!!!!");
       return false;
    }
}


simulated function bool DHShouldPenetrateAPDS(vector HitLocation, vector HitRotation, float PenetrationNumber, out float InAngle, optional class<DamageType> DamageType, optional bool bShatterProne)
{

    local vector  LocDir, HitDir;
    local float   HitAngle,Side;//InAngle;
    local vector  X,Y,Z;
    local float   InAngleDegrees;
    local rotator AimRot;
    local float   WeaponRotationDegrees;

    WeaponRotationDegrees = (CurrentAim.Yaw / 65536.0 * 360);

    if (bIsAssaultGun)
    {
       DH_ROTreadCraft(Base).bAssaultWeaponHit=true;
       return false;
    }

    // Figure out which side we hit
    LocDir = vector(Rotation);
    LocDir.Z = 0;
    HitDir =  Hitlocation - Location;
    HitDir.Z = 0;
    HitAngle = Acos(Normal(LocDir) dot Normal(HitDir));

    //  Penetration Debugging
    if (bLogPenetration)
    {
        log("Raw hitangle = "$HitAngle$" Converted hitangle = "$(57.2957795131 * HitAngle));
    }

    // Convert the angle into degrees from radians
    HitAngle*=57.2957795131;
    GetAxes(Rotation,X,Y,Z);
    Side = Y dot HitDir;

    //  Penetration Debugging
    if (bDrawPenetration)
    {
        ClearStayingDebugLines();
        AimRot = Rotation;
        AimRot.Yaw += (FrontLeftAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 255, 0);
        AimRot = Rotation;
        AimRot.Yaw += (FrontRightAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),255, 255, 0);
        AimRot = Rotation;
        AimRot.Yaw += (RearRightAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 0, 255);
        AimRot = Rotation;
        AimRot.Yaw += (RearLeftAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 0, 0);
    }

    if (side < 0)
    {
       HitAngle = 360 + (HitAngle* -1);
    }

    HitAngle = HitAngle - WeaponRotationDegrees;

    if (HitAngle < 0)
    {
       HitAngle = HitAngle + 360;
       X = X >> CurrentAim;
       Y = Y >> CurrentAim;
    }

    if (bDebuggingText && Role == ROLE_Authority)
    Level.Game.Broadcast(self, "HitAngle: "$HitAngle$"degrees");

    if (HitAngle >= FrontLeftAngle || Hitangle < FrontRightAngle)  //Frontal hit
    {

       InAngle= Acos(Normal(-HitRotation) dot Normal(X));
       InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(X),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the front of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from front to rear");
                Level.Game.Broadcast(self, "Rear turret hit, base armor = "$RearArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (RearArmorFactor > PenetrationNumber)
                return false;

            return PenetrationAPDS(RearArmorFactor, GetCompoundAngle(InAngleDegrees, RearArmorSlope), PenetrationNumber, bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Front turret hit, base armor = "$FrontArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (FrontArmorFactor > PenetrationNumber)
            return false;

        return PenetrationAPDS(FrontArmorFactor, GetCompoundAngle(InAngleDegrees, FrontArmorSlope), PenetrationNumber, bShatterProne);
    }
    else if (HitAngle >= FrontRightAngle && Hitangle < RearRightAngle) //Right side
    {
        // Don't penetrate with HEAT if there is added side armor, unless passes chance test
        if (bHasAddedSideArmor && DamageType != none && DamageType.default.bArmorStops)
        {
           return false;
        }

        InAngle= Acos(Normal(-HitRotation) dot Normal(Y));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-Y),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the right side of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from right to left");
                Level.Game.Broadcast(self, "Left turret hit, base armor = "$LeftArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (LeftArmorFactor > PenetrationNumber)
                return false;

            return PenetrationAPDS(LeftArmorFactor, GetCompoundAngle(InAngleDegrees, LeftArmorSlope), PenetrationNumber, bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Right turret hit, base armor "$RightArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (RightArmorFactor > PenetrationNumber)
            return false;

        return PenetrationAPDS(RightArmorFactor, GetCompoundAngle(InAngleDegrees, RightArmorSlope), PenetrationNumber, bShatterProne);

    }
    else if (HitAngle >= RearRightAngle && Hitangle < RearLeftAngle)  //Rear hit
    {

        InAngle= Acos(Normal(-HitRotation) dot Normal(-X));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-X),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the back of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from rear to front");
                Level.Game.Broadcast(self, "Front turret hit, base armor = "$FrontArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (FrontArmorFactor > PenetrationNumber)
                return false;

            return PenetrationAPDS(FrontArmorFactor, GetCompoundAngle(InAngleDegrees, FrontArmorSlope), PenetrationNumber, bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Rear turret hit, base armor = "$RearArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (RearArmorFactor > PenetrationNumber)
            return false;

        return PenetrationAPDS(RearArmorFactor, GetCompoundAngle(InAngleDegrees, RearArmorSlope), PenetrationNumber, bShatterProne);

    }
    else if (HitAngle >= RearLeftAngle && Hitangle < FrontLeftAngle)  //Left
    {
        // Don't penetrate with HEAT if there is added side armor, unless passes chance test
        if (bHasAddedSideArmor && DamageType != none && DamageType.default.bArmorStops)
        {
            return false;
        }

        InAngle= Acos(Normal(-HitRotation) dot Normal(-Y));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(Y),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the left side of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from left to right");
                Level.Game.Broadcast(self, "Right turret hit, base armor = "$RightArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (RightArmorFactor > PenetrationNumber)
                return false;

            return PenetrationAPDS(RightArmorFactor, GetCompoundAngle(InAngleDegrees, RightArmorSlope), PenetrationNumber, bShatterProne);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Left turret hit, base armor = "$leftArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (LeftArmorFactor > PenetrationNumber)
            return false;

        return PenetrationAPDS(LeftArmorFactor, GetCompoundAngle(InAngleDegrees, LeftArmorSlope), PenetrationNumber, bShatterProne);

    }
    else
    {
       log ("We shoulda hit something!!!!");
       Level.Game.Broadcast(self, " ?!? We shoulda hit something!!!!");
       return false;
    }
}

simulated function bool DHShouldPenetrateHEAT(vector HitLocation, vector HitRotation, float PenetrationNumber, out float InAngle, optional class<DamageType> DamageType, optional bool bIsHEATRound)
{

    local vector  LocDir, HitDir;
    local float   HitAngle,Side;//InAngle;
    local vector  X,Y,Z;
    local float   InAngleDegrees;
    local rotator AimRot;
    local float   WeaponRotationDegrees;

    WeaponRotationDegrees = (CurrentAim.Yaw / 65536.0 * 360);

    if (bIsAssaultGun)
    {
       DH_ROTreadCraft(Base).bAssaultWeaponHit=true;
       return false;
    }

    // Figure out which side we hit
    LocDir = vector(Rotation);
    LocDir.Z = 0;
    HitDir =  Hitlocation - Location;
    HitDir.Z = 0;
    HitAngle = Acos(Normal(LocDir) dot Normal(HitDir));

    //  Penetration Debugging
    if (bLogPenetration)
    {
        log("Raw hitangle = "$HitAngle$" Converted hitangle = "$(57.2957795131 * HitAngle));
    }

    // Convert the angle into degrees from radians
    HitAngle*=57.2957795131;
    GetAxes(Rotation,X,Y,Z);
    Side = Y dot HitDir;

    //  Penetration Debugging
    if (bDrawPenetration)
    {
        ClearStayingDebugLines();
        AimRot = Rotation;
        AimRot.Yaw += (FrontLeftAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 255, 0);
        AimRot = Rotation;
        AimRot.Yaw += (FrontRightAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),255, 255, 0);
        AimRot = Rotation;
        AimRot.Yaw += (RearRightAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 0, 255);
        AimRot = Rotation;
        AimRot.Yaw += (RearLeftAngle/360.0)*65536;
        DrawStayingDebugLine(Location, Location + 2000*vector(AimRot),0, 0, 0);
    }

    if (side < 0)
    {
       HitAngle = 360 + (HitAngle* -1);
    }

    HitAngle = HitAngle - WeaponRotationDegrees;

    if (HitAngle < 0)
    {
       HitAngle = HitAngle + 360;
       X = X >> CurrentAim;
       Y = Y >> CurrentAim;
    }

    if (bDebuggingText && Role == ROLE_Authority)
    Level.Game.Broadcast(self, "HitAngle: "$HitAngle$"degrees");

    if (HitAngle >= FrontLeftAngle || Hitangle < FrontRightAngle)  //Frontal hit
    {

       InAngle= Acos(Normal(-HitRotation) dot Normal(X));
       InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(X),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the front of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from front to rear");
                Level.Game.Broadcast(self, "Rear turret hit, base armor = "$RearArmorFactor*10$"mm");
            }

                    //Run a pre-check
            if (RearArmorFactor > PenetrationNumber)
                return false;

            return PenetrationHEAT(RearArmorFactor, GetCompoundAngle(InAngleDegrees, RearArmorSlope), PenetrationNumber, bIsHEATRound);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Front turret hit, base armor = "$FrontArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (FrontArmorFactor > PenetrationNumber)
            return false;

        return PenetrationHEAT(FrontArmorFactor, GetCompoundAngle(InAngleDegrees, FrontArmorSlope), PenetrationNumber, bIsHEATRound);
    }
    else if (HitAngle >= FrontRightAngle && Hitangle < RearRightAngle)     //Right side hit
    {
        // Don't penetrate with HEAT if there is added side armor, unless passes chance test
        if (bHasAddedSideArmor && DamageType != none && DamageType.default.bArmorStops)
        {
           return false;
        }

        InAngle= Acos(Normal(-HitRotation) dot Normal(Y));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-Y),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the right side of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from right to left");
                Level.Game.Broadcast(self, "Left turret hit, base armor = "$LeftArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (LeftArmorFactor > PenetrationNumber)
                return false;

            return PenetrationHEAT(LeftArmorFactor, GetCompoundAngle(InAngleDegrees, LeftArmorSlope), PenetrationNumber, bIsHEATRound);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Right turret hit, base armor "$RightArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (RightArmorFactor > PenetrationNumber)
            return false;

        return PenetrationHEAT(RightArmorFactor, GetCompoundAngle(InAngleDegrees, RightArmorSlope), PenetrationNumber, bIsHEATRound);

    }
    else if (HitAngle >= RearRightAngle && Hitangle < RearLeftAngle)  //Rear hit
    {

        InAngle= Acos(Normal(-HitRotation) dot Normal(-X));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-X),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the back of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {

            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from rear to front");
                Level.Game.Broadcast(self, "Front turret hit, base armor = "$FrontArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (FrontArmorFactor > PenetrationNumber)
                return false;

            return PenetrationHEAT(FrontArmorFactor, GetCompoundAngle(InAngleDegrees, FrontArmorSlope), PenetrationNumber, bIsHEATRound);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Rear turret hit, base armor = "$RearArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (RearArmorFactor > PenetrationNumber)
                return false;

        return PenetrationHEAT(RearArmorFactor, GetCompoundAngle(InAngleDegrees, RearArmorSlope), PenetrationNumber, bIsHEATRound);


    }
    else if (HitAngle >= RearLeftAngle && Hitangle < FrontLeftAngle)  //Left
    {
        // Don't penetrate with HEAT if there is added side armor, unless passes chance test
        if (bHasAddedSideArmor && DamageType != none && DamageType.default.bArmorStops)
        {
            return false;
        }

        InAngle= Acos(Normal(-HitRotation) dot Normal(-Y));
        InAngleDegrees = InAngle * 57.2957795131;

        //  Penetration Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(Y),0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000*Normal(-HitRotation),255, 255, 0);
            Spawn(class 'ROEngine.RODebugTracer',self,,HitLocation,rotator(HitRotation));
            log ("We hit the left side of the vehicle!!!!");
        }

        //Fix hit detection bug
        if (InAngleDegrees > 90)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit Bug: Switching from left to right");
                Level.Game.Broadcast(self, "Right turret hit, base armor = "$RightArmorFactor*10$"mm");
            }

            //Run a pre-check
            if (RightArmorFactor > PenetrationNumber)
                return false;

            return PenetrationHEAT(RightArmorFactor, GetCompoundAngle(InAngleDegrees, RightArmorSlope), PenetrationNumber, bIsHEATRound);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Left turret hit, base armor = "$LeftArmorFactor*10$"mm");
        }

        //Run a pre-check
        if (LeftArmorFactor > PenetrationNumber)
            return false;

        return PenetrationHEAT(LeftArmorFactor, GetCompoundAngle(InAngleDegrees, LeftArmorSlope), PenetrationNumber, bIsHEATRound);

    }
    else
    {
       log ("We shoulda hit something!!!!");
       Level.Game.Broadcast(self, " ?!? We shoulda hit something!!!!");
       return false;
    }
}

function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    // Fix for suicide death messages
    if (DamageType == class'Suicided')
    {
        DamageType = class'ROSuicided';
        ROVehicleWeaponPawn(Owner).TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, DamageType);
    }
    else if (DamageType == class'ROSuicided')
    {
        ROVehicleWeaponPawn(Owner).TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, DamageType);
    }

    // Matt: shell's ProcessTouch now calls TD on VehicleWeapon instead of VehicleBase, but for tank cannon this is counted as hit on vehicle so we call TD on that
    else if (VehicleWeaponPawn(Owner) != none && VehicleWeaponPawn(Owner).VehicleBase != none)
    {
        VehicleWeaponPawn(Owner).VehicleBase.TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, DamageType);
    }

    // Matt: removed as shell's ProcessTouch now calls TakeDamage directly on Driver if he was hit
    //  if (HitDriver(Hitlocation, Momentum))
//  {
//      ROVehicleWeaponPawn(Owner).TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, DamageType);
//  }

    // Reset everything
    bWasHEATRound = false;
    bProjectilePenetrated = false;
    bWasShatterProne = false;
    bRoundShattered = false;
}

// Returns the name of the various round types as well as a 0-based int
// specifying which type is the active one
simulated function int GetRoundsDescription(out array<string> descriptions)
{
    local int i;
    descriptions.length = 0;
    for (i = 0; i < ProjectileDescriptions.length; i++)
        descriptions[i] = ProjectileDescriptions[i];

    if (ProjectileClass == PrimaryProjectileClass)
        return 0;
    else if (ProjectileClass == SecondaryProjectileClass)
        return 1;
    else if (ProjectileClass == TertiaryProjectileClass)
        return 2;
    else
        return 3;
}

// Returns a 0-based int specifying which round type is the pending round
simulated function int GetPendingRoundIndex()
{
    if (PendingProjectileClass != none)
    {
        if (PendingProjectileClass == PrimaryProjectileClass)
            return 0;
        else if (PendingProjectileClass == SecondaryProjectileClass)
            return 1;
        else if (PendingProjectileClass == TertiaryProjectileClass)
            return 2;
        else
            return 3;
    }
    else
    {
        if (ProjectileClass == PrimaryProjectileClass)
            return 0;
        else if (ProjectileClass == SecondaryProjectileClass)
            return 1;
        else if (ProjectileClass == TertiaryProjectileClass)
            return 2;
        else
            return 3;
    }

}

function ToggleRoundType()
{
    if (PendingProjectileClass == PrimaryProjectileClass || PendingProjectileClass == none)
    {
        if (!HasAmmo(1) && !HasAmmo(2))
            return;

        if (HasAmmo(1))
            PendingProjectileClass = SecondaryProjectileClass;
        else if (HasAmmo(2))
            PendingProjectileClass = TertiaryProjectileClass;

    }
    else if (PendingProjectileClass == SecondaryProjectileClass)
    {
        if (!HasAmmo(0) && !HasAmmo(2))
            return;

        if (HasAmmo(2))
            PendingProjectileClass = TertiaryProjectileClass;
        else if (HasAmmo(0))
            PendingProjectileClass = PrimaryProjectileClass;
    }
    else if (PendingProjectileClass == TertiaryProjectileClass)
    {
        if (!HasAmmo(0) && !HasAmmo(1))
            return;

        if (HasAmmo(0))
            PendingProjectileClass = PrimaryProjectileClass;
        else if (HasAmmo(1))
            PendingProjectileClass = SecondaryProjectileClass;
    }
}

event bool AttemptFire(Controller C, bool bAltFire)
{

        local float s;

        if (Role != ROLE_Authority || bForceCenterAim)
                return false;

        s = FRand();

        if ((!bAltFire && CannonReloadState == CR_ReadyToFire && bClientCanFireCannon) || (bAltFire && FireCountdown <= 0))
        {
                CalcWeaponFire(bAltFire);
                if (bCorrectAim)
                        WeaponFireRotation = AdjustAim(bAltFire);
                if (bAltFire)
                {
                      if (AltFireSpread > 0)
                            WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand()*FRand()*AltFireSpread);
                }
                else if (SecondarySpread > 0 && bUsesSecondarySpread && ProjectileClass == SecondaryProjectileClass)
                {
                      if (s < 0.60)
                      {
                           WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand()*FRand()*SecondarySpread);
                           WeaponFireRotation += rot(1,6,0);        //correction to the aim point and to center the spread pattern
                      }
                      else
                      {
                           WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand()*FRand()*0.0015);
                           WeaponFireRotation += rot(1,6,0);        //correction to the aim point and to center the spread pattern
                      }
                }
                else if (TertiarySpread > 0 && bUsesTertiarySpread && ProjectileClass == TertiaryProjectileClass)
                {
                      WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand()*FRand()*TertiarySpread);
                      WeaponFireRotation += rot(1,6,0);        //correction to the aim point and to center the spread pattern
                }
                else if (Spread > 0)
                {
                      WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand()*FRand()*Spread);
                      WeaponFireRotation += rot(1,6,0);        //correction to the aim point and to center the spread pattern
                }

        DualFireOffset *= -1;

        Instigator.MakeNoise(1.0);
        if (bAltFire)
        {
            if (!ConsumeAmmo(3))
            {
                VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);
                HandleReload();
                return false;
            }

            FireCountdown = AltFireInterval;
            AltFire(C);


            if (AltAmmoCharge < 1)
                HandleReload();
        }
        else
        {
            //FireCountdown = FireInterval;
            if (bMultipleRoundTypes)
            {
                if (ProjectileClass == PrimaryProjectileClass)
                {
                    if (!ConsumeAmmo(0))
                    {
                        VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);
                        return false;
                    }
                    else if (!HasAmmo(0))
                    {
                        if (HasAmmo(1))
                            PendingProjectileClass = SecondaryProjectileClass;
                        else if (HasAmmo(2))
                            PendingProjectileClass = TertiaryProjectileClass;
                    }
                }
                else if (ProjectileClass == SecondaryProjectileClass)
                {
                    if (!ConsumeAmmo(1))
                    {
                        VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);
                        return false;
                    }
                    else if (!HasAmmo(1))
                    {
                        if (HasAmmo(0))
                            PendingProjectileClass = PrimaryProjectileClass;
                        else if (HasAmmo(2))
                            PendingProjectileClass = TertiaryProjectileClass;
                    }
                }
                else if (ProjectileClass == TertiaryProjectileClass)
                {
                    if (!ConsumeAmmo(2))
                    {
                        VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);
                        return false;
                    }
                    else if (!HasAmmo(2))
                    {
                        if (HasAmmo(0))
                            PendingProjectileClass = PrimaryProjectileClass;
                        else if (HasAmmo(1))
                            PendingProjectileClass = SecondaryProjectileClass;
                    }
                }
            }
            else if (!ConsumeAmmo(0))
            {
                VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);
                return false;
            }

            if (Instigator != none && Instigator.Controller != none && ROPlayer(Instigator.Controller) != none &&
                ROPlayer(Instigator.Controller).bManualTankShellReloading == true)
            {
                CannonReloadState = CR_Waiting;
            }
            else
            {
                CannonReloadState = CR_Empty;
                SetTimer(0.01, false);
            }

            bClientCanFireCannon = false;
            Fire(C);
        }
        AimLockReleaseTime = Level.TimeSeconds + FireCountdown * FireIntervalAimLock;

        return true;
    }

    return false;
}

function Projectile SpawnProjectile(class<Projectile> ProjClass, bool bAltFire)
{
    local Projectile P;
    local VehicleWeaponPawn WeaponPawn;
    local vector StartLocation, HitLocation, HitNormal, Extent;
    local rotator FireRot;

    FireRot = WeaponFireRotation;

    // used only for Human players. Lets cannons with non centered aim points have a different aiming location
    if (Instigator != none && Instigator.IsHumanControlled())
    {
        FireRot.Pitch += AddedPitch;
    }

    if (!bAltFire)
        FireRot.Pitch += ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);

    if (bCannonShellDebugging)
        log("GetPitchForRange for "$CurrentRangeIndex$" = "$ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]));

    if (bDoOffsetTrace)
    {
        Extent = ProjClass.default.CollisionRadius * vect(1,1,0);
        Extent.Z = ProjClass.default.CollisionHeight;
        WeaponPawn = VehicleWeaponPawn(Owner);
        if (WeaponPawn != none && WeaponPawn.VehicleBase != none)
        {
            if (!WeaponPawn.VehicleBase.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation, WeaponFireLocation + vector(WeaponFireRotation) * (WeaponPawn.VehicleBase.CollisionRadius * 1.5), Extent))
            StartLocation = HitLocation;
        else
            StartLocation = WeaponFireLocation + vector(WeaponFireRotation) * (ProjClass.default.CollisionRadius * 1.1);
    }
    else
    {
        if (!Owner.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation, WeaponFireLocation + vector(WeaponFireRotation) * (Owner.CollisionRadius * 1.5), Extent))
            StartLocation = HitLocation;
        else
            StartLocation = WeaponFireLocation + vector(WeaponFireRotation) * (ProjClass.default.CollisionRadius * 1.1);
    }
    }
    else
        StartLocation = WeaponFireLocation;

    if (bCannonShellDebugging)
        Trace(TraceHitLocation, HitNormal, WeaponFireLocation + 65355 * vector(WeaponFireRotation), WeaponFireLocation, false);

    P = spawn(ProjClass, none, , StartLocation, FireRot); //self

   //swap to the next round type after firing
    if (PendingProjectileClass != none && ProjClass == ProjectileClass && ProjectileClass != PendingProjectileClass)
    {
        ProjectileClass = PendingProjectileClass;
    }
    //log("WeaponFireRotation = "$WeaponFireRotation);

    if (P != none)
    {
        if (bInheritVelocity)
            P.Velocity = Instigator.Velocity;

        FlashMuzzleFlash(bAltFire);

        // Play firing noise
        if (bAltFire)
        {
            if (bAmbientAltFireSound)
            {
                AmbientSound = AltFireSoundClass;
                SoundVolume = AltFireSoundVolume;
                SoundRadius = AltFireSoundRadius;
                AmbientSoundScaling = AltFireSoundScaling;
            }
            else
                PlayOwnedSound(AltFireSoundClass, SLOT_None, FireSoundVolume/255.0,, AltFireSoundRadius,, false);
        }
        else
        {
            if (bAmbientFireSound)
                AmbientSound = FireSoundClass;
            else
            {
                PlayOwnedSound(CannonFireSound[Rand(3)], SLOT_None, FireSoundVolume/255.0,, FireSoundRadius,, false);
            }
        }
    }

    return P;
}


function CeaseFire(Controller C, bool bWasAltFire)
{
    super(ROVehicleWeapon).CeaseFire(C, bWasAltFire);

    if (bWasAltFire && !HasAmmo(3))
        HandleReload();
}

simulated function bool HasAmmo(int Mode)
{
    switch(Mode)
    {
        case 0:
            return (MainAmmoChargeExtra[0] > 0);
            break;
        case 1:
            return (MainAmmoChargeExtra[1] > 0);
            break;
        case 2:
            return (MainAmmoChargeExtra[2] > 0);
            break;
        case 3:
            return (AltAmmoCharge > 0);
            break;
        default:
            return false;
    }

    return false;
}

simulated function bool ReadyToFire(bool bAltFire)
{
    local int Mode;

    if (    bAltFire)
        Mode = 3;
    else if (ProjectileClass == PrimaryProjectileClass)
        Mode = 0;
    else if (ProjectileClass == SecondaryProjectileClass)
        Mode = 1;
    else if (ProjectileClass == TertiaryProjectileClass)
        Mode = 2;

    if (HasAmmo(Mode))
        return true;

    return false;
}

simulated function int PrimaryAmmoCount()
{
    if (bMultipleRoundTypes)
    {
        if (ProjectileClass == PrimaryProjectileClass)
            return MainAmmoChargeExtra[0];
        else if (ProjectileClass == SecondaryProjectileClass)
            return MainAmmoChargeExtra[1];
        else if (ProjectileClass == TertiaryProjectileClass)
            return MainAmmoChargeExtra[2];
    }
    else
    {
        return MainAmmoChargeExtra[0];
    }
}

simulated function bool ConsumeAmmo(int Mode)
{
    if (!HasAmmo(Mode))
        return false;

    switch(Mode)
    {
        case 0:
            MainAmmoChargeExtra[0]--;
            return true;
        case 1:
            MainAmmoChargeExtra[1]--;
            return true;
        case 2:
            MainAmmoChargeExtra[2]--;
            return true;
        case 3:
            AltAmmoCharge--;
            return true;
        default:
            return false;
    }

    return false;
}

function bool GiveInitialAmmo()
{
    local bool bDidResupply;

    // If we don't need any ammo return false
    if (MainAmmoCharge[0] != InitialPrimaryAmmo || MainAmmoCharge[1] != InitialSecondaryAmmo || MainAmmoCharge[2] != InitialTertiaryAmmo
        || AltAmmoCharge != InitialAltAmmo || NumAltMags != default.NumAltMags)
    {
        bDidResupply = true;
    }

    MainAmmoChargeExtra[0] = InitialPrimaryAmmo;
    MainAmmoChargeExtra[1] = InitialSecondaryAmmo;
    MainAmmoChargeExtra[2] = InitialTertiaryAmmo;
    AltAmmoCharge = InitialAltAmmo;
    NumAltMags = default.NumAltMags;

    return bDidResupply;
}

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
         GetSoundDuration(ReloadSoundThree) + GetSoundDuration(ReloadSoundFour);
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
         GetSoundDuration(ReloadSoundFour);
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
              PlayOwnedSound(ReloadSoundFour, SLOT_Misc, FireSoundVolume/255.0,, 150,, false);
         }
         else
         {
              PlaySound(ReloadSoundFour, SLOT_Misc, FireSoundVolume/255.0,, 150,, false);
         }

         CannonReloadState = CR_ReloadedPart4;
         SetTimer(GetSoundDuration(ReloadSoundFour), false);
   }
   else if (CannonReloadState == CR_ReloadedPart4)
   {
        if (Role == ROLE_Authority)
        {
            bClientCanFireCannon = true;
        }
        CannonReloadState = CR_ReadyToFire;
        SetTimer(0.0, false);
   }
}

//overriden: to remove shake from co-ax MG's
simulated function ShakeView(bool bWasAltFire)
{
    local PlayerController P;

    if (Instigator == none)
        return;

    P = PlayerController(Instigator.Controller);
    if (P != none)
    {
        if (bWasAltFire)
        {
            //P.WeaponShakeView(AltShakeRotMag, AltShakeRotRate, AltShakeRotTime, AltShakeOffsetMag, AltShakeOffsetRate, AltShakeOffsetTime);
        }
        else
        {
            P.WeaponShakeView(ShakeRotMag, ShakeRotRate, ShakeRotTime, ShakeOffsetMag, ShakeOffsetRate, ShakeOffsetTime);
        }
    }
}

// Returns true if the bullet hits below the angle that would hit the commander
simulated function bool BelowDriverAngle(vector loc, vector ray)
{
    local float InAngle;
    local vector X,Y,Z;
    local vector HitDir;
    local coords C;
    local vector HeadLoc;

    GetAxes(Rotation,X,Y,Z);

    C = GetBoneCoords(VehHitpoints[0].PointBone);
    HeadLoc = C.Origin + (VehHitpoints[0].PointHeight * VehHitpoints[0].PointScale * C.XAxis);
    HeadLoc = HeadLoc + (VehHitpoints[0].PointOffset >> Rotator(C.Xaxis));

    HitDir = loc - HeadLoc;

    InAngle= Acos(Normal(HitDir) dot Normal(C.ZAxis));

    if (bDriverDebugging)
    {
        log("Inangle = "$InAngle$" MaxDriverHitAngle = "$MaxDriverHitAngle);
        Level.Game.Broadcast(self, "Inangle = "$InAngle$" MaxDriverHitAngle = "$MaxDriverHitAngle);

        ClearStayingDebugLines();

        DrawStayingDebugLine(HeadLoc, (HeadLoc + (30 * Normal(C.ZAxis))), 255, 0, 0); // SLOW! Use for debugging only!
        DrawStayingDebugLine(loc, (loc + (45 * Normal(ray))), 0, 255, 0); // SLOW! Use for debugging only!
    }

    if (InAngle > MaxDriverHitAngle)
    {
        if (bDriverDebugging)
            Level.Game.Broadcast(self, "Hit angle is too low");
        return true;
    }

    return false;
}

// Matt: had to re-state as a simulated function so can be called on net client by HitDriver/HitDriverArea, giving correct clientside effects for projectile hits
simulated function bool IsPointShot(vector Loc, vector Ray, float AdditionalScale, int Index)
{
    local  coords  C;
    local  vector  HeadLoc, B, M, Diff;
    local  float   t, DotMM, Distance;

    if (VehHitpoints[Index].PointBone == '')
    {
        return false;
    }

    C = GetBoneCoords(VehHitpoints[Index].PointBone);
    HeadLoc = C.Origin + (VehHitpoints[Index].PointHeight * VehHitpoints[Index].PointScale * AdditionalScale * C.XAxis);
    HeadLoc = HeadLoc + (VehHitpoints[Index].PointOffset >> rotator(C.Xaxis));

    // Express snipe trace line in terms of B + tM
    B = Loc;
    M = Ray * 150.0;

    // Find point-line squared distance
    Diff = HeadLoc - B;
    t = M dot Diff;

    if (t > 0.0)
    {
        DotMM = M dot M;

        if (t < DotMM)
        {
            t = t / DotMM;
            Diff = Diff - (t * M);
        }
        else
        {
            t = 1.0;
            Diff -= M;
        }
    }
    else
    {
        t = 0.0;
    }

    Distance = Sqrt(Diff Dot Diff);

    return (Distance < (VehHitpoints[Index].PointRadius * VehHitpoints[Index].PointScale * AdditionalScale));
}

simulated function UpdatePrecacheStaticMeshes()
{
    if (TertiaryProjectileClass != none)
        Level.AddPrecacheStaticMesh(TertiaryProjectileClass.default.StaticMesh);
    super.UpdatePrecacheStaticMeshes();
}

// ARMORED BEASTS CODE: Functions extended for easy tuning of gunsights in PRACTICE mode
// bGunsightSettingMode has to be enabled and gun not loaded
// then the range control buttons change sight adjustment up and down
function IncrementRange()
{
    if (bGunsightSettingMode && (CannonReloadState != CR_ReadyToFire))
    {
        IncreaseAddedPitch();
        GiveInitialAmmo();
    }
    else
    {
        super.IncrementRange();
    }
}

function DecrementRange()
{
    if (bGunsightSettingMode && (CannonReloadState != CR_ReadyToFire))
    {
        DecreaseAddedPitch();
        GiveInitialAmmo();
    }
    else
    {
        super.DecrementRange();
    }
}

// functions making AddedPitch (gunsight correction) adjustment and display:

function IncreaseAddedPitch()
{
    local int MechanicalRangesValue, Correction;

    AddedPitch += 2;    //AddedPitch ++;

    MechanicalRangesValue = ProjectileClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);
    Correction = AddedPitch-Default.AddedPitch;

    if (Instigator != none && Instigator.Controller != none && ROPlayer(Instigator.Controller) != none)
        ROPlayer(Instigator.Controller).ClientMessage("Sight old value ="$MechanicalRangesValue$"        new value = "$MechanicalRangesValue+Correction$"        correction = "$Correction);
}

function DecreaseAddedPitch()
{
    local int MechanicalRangesValue, Correction;

    AddedPitch -= 2;    //AddedPitch --;

    MechanicalRangesValue = ProjectileClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);
    Correction = AddedPitch-Default.AddedPitch;

    if (Instigator != none && Instigator.Controller != none && ROPlayer(Instigator.Controller) != none)
        ROPlayer(Instigator.Controller).ClientMessage("Sight old value ="$MechanicalRangesValue$"        new value = "$MechanicalRangesValue+Correction$"        correction = "$Correction);
}


simulated function DestroyEffects()
{
    super.DestroyEffects();

    if (TurretHatchFireEffect != none)
        TurretHatchFireEffect.Destroy();
}

simulated function int LimitYaw(int yaw)
{
    local DH_ROTankCannonPawn P;

    P = DH_ROTankCannonPawn(Owner);

    if(!bLimitYaw)
    {
        return yaw;
    }

    if(P != none)
    {
        if(P.DriverPositionIndex >= P.PeriscopePositionIndex)
        {
            return yaw;
        }

        return Clamp(yaw, P.DriverPositions[P.DriverPositionIndex].ViewNegativeYawLimit, P.DriverPositions[P.DriverPositionIndex].ViewPositiveYawLimit);
    }

    return Clamp(yaw, MaxNegativeYaw, MaxPositiveYaw);
}

function bool ResupplyAmmo()
{
    local bool bDidResupply;

    if (MainAmmoChargeExtra[0] < InitialPrimaryAmmo)
    {
        ++MainAmmoChargeExtra[0];

        bDidResupply = true;
    }

    if (MainAmmoChargeExtra[1] < InitialSecondaryAmmo)
    {
        ++MainAmmoChargeExtra[1];

        bDidResupply = true;
    }

    if (MainAmmoChargeExtra[2] < InitialTertiaryAmmo)
    {
        ++MainAmmoChargeExtra[2];

        bDidResupply = true;
    }

    if (NumAltMags < default.NumAltMags)
    {
        ++NumAltMags;

        bDidResupply = true;
    }

    return bDidResupply;
}

defaultproperties
{
     bUsesSecondarySpread=true
     bUsesTertiarySpread=true
     ManualRotationsPerSecond=0.011111
     PoweredRotationsPerSecond=0.050000
     FireAttachBone="com_player"
     FireEffectOffset=(Z=-20.000000)
     FireEffectClass=class'ROEngine.VehicleDamagedEffect'
     bManualTurret=true
     CannonReloadState=CR_Waiting
     AltFireSpread=0.002000
}
