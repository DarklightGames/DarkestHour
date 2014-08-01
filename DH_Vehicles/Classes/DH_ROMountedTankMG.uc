//===================================================================
// DH_ROMountedTankMG
//
// Copyright (C) 2004 John "Ramm-Jaeger"  Gibson
//
// Base class for Darkest Hour mounted tank machine guns
//===================================================================
class DH_ROMountedTankMG extends ROMountedTankMG
      abstract;


// Stuff for fire effects - Ch!cKeN
var()   name                                    FireAttachBone;
var()	vector                                  FireEffectOffset;
var 	class<VehicleDamagedEffect>     		FireEffectClass;
var 	VehicleDamagedEffect            		HullMGFireEffect;
var     bool                                    bOnFire;   // Set by Treadcraft base to notify when to start fire effects
var     float                                   BurnTime;

var     class<DamageType>   VehicleBurningDamType;
var     float               PlayerFireDamagePerSec;

//==============================================================================
// replication
//==============================================================================
replication
{
     reliable if (bNetDirty && Role==ROLE_Authority)
       bOnFire;
}


simulated function Tick(float DeltaTime)
{

    Super.Tick(DeltaTime);

    if (bOnFire && HullMGFireEffect == none)
    {
        // Lets randomise the fire start times to desync them with the driver and engine ones
        if (Level.TimeSeconds - BurnTime > 0.2)
        {
            if (FRand() < 0.1)
            {
                HullMGFireEffect = Spawn(FireEffectClass);
                AttachToBone(HullMGFireEffect, FireAttachBone);
                HullMGFireEffect.SetRelativeLocation(FireEffectOffset);
                HullMGFireEffect.UpdateDamagedEffect(true, 0, false, false);
            }
            BurnTime = Level.TimeSeconds;
        }
    }
}


simulated function DestroyEffects()
{
	super.DestroyEffects();

    if (HullMGFireEffect != none)
    	HullMGFireEffect.Destroy();
}

defaultproperties
{
     FireAttachBone="mg_pitch"
     FireEffectOffset=(X=10.000000,Z=5.000000)
     FireEffectClass=Class'ROEngine.VehicleDamagedEffect'
     VehicleBurningDamType=Class'DH_Vehicles.DH_VehicleBurningDamType'
}
