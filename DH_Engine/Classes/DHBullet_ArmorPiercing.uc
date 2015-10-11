//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHBullet_ArmorPiercing extends DHBullet
    abstract;

var     float   DHPenetrationTable[11]; // from DHAntiVehicleProjectile
var     float   BulletDiameter;         // from DHAntiVehicleProjectile (but called ShellDiameter), used in penetration calcs

// From DHAntiVehicleProjectile
simulated function float GetPenetration(vector Distance)
{
    local float MeterDistance, PenetrationNumber;

    MeterDistance = VSize(Distance) / 60.352;

    if      (MeterDistance < 100)   PenetrationNumber = (DHPenetrationTable[0] +  (100.0  - MeterDistance) * (DHPenetrationTable[0] - DHPenetrationTable[1])  / 100.0);
    else if (MeterDistance < 250)   PenetrationNumber = (DHPenetrationTable[1] +  (250.0  - MeterDistance) * (DHPenetrationTable[0] - DHPenetrationTable[1])  / 150.0);
    else if (MeterDistance < 500)   PenetrationNumber = (DHPenetrationTable[2] +  (500.0  - MeterDistance) * (DHPenetrationTable[1] - DHPenetrationTable[2])  / 250.0);
    else if (MeterDistance < 750)   PenetrationNumber = (DHPenetrationTable[3] +  (750.0  - MeterDistance) * (DHPenetrationTable[2] - DHPenetrationTable[3])  / 250.0);
    else if (MeterDistance < 1000)  PenetrationNumber = (DHPenetrationTable[4] +  (1000.0 - MeterDistance) * (DHPenetrationTable[3] - DHPenetrationTable[4])  / 250.0);
    else if (MeterDistance < 1250)  PenetrationNumber = (DHPenetrationTable[5] +  (1250.0 - MeterDistance) * (DHPenetrationTable[4] - DHPenetrationTable[5])  / 250.0);
    else if (MeterDistance < 1500)  PenetrationNumber = (DHPenetrationTable[6] +  (1500.0 - MeterDistance) * (DHPenetrationTable[5] - DHPenetrationTable[6])  / 250.0);
    else if (MeterDistance < 1750)  PenetrationNumber = (DHPenetrationTable[7] +  (1750.0 - MeterDistance) * (DHPenetrationTable[6] - DHPenetrationTable[7])  / 250.0);
    else if (MeterDistance < 2000)  PenetrationNumber = (DHPenetrationTable[8] +  (2000.0 - MeterDistance) * (DHPenetrationTable[7] - DHPenetrationTable[8])  / 250.0);
    else if (MeterDistance < 2500)  PenetrationNumber = (DHPenetrationTable[9] +  (2500.0 - MeterDistance) * (DHPenetrationTable[8] - DHPenetrationTable[9])  / 500.0);
    else if (MeterDistance < 3000)  PenetrationNumber = (DHPenetrationTable[10] + (3000.0 - MeterDistance) * (DHPenetrationTable[9] - DHPenetrationTable[10]) / 500.0);
    else                            PenetrationNumber =  DHPenetrationTable[10];

//  if (NumDeflections > 0) // removed as won't deflect like a shell
//  {
//      PenetrationNumber = PenetrationNumber * 0.04;
//  }

    return PenetrationNumber;
}

// Run penetration calculations on a vehicle cannon (e.g. turret), but damage any other vehicle weapon automatically
simulated function bool PenetrateVehicleWeapon(VehicleWeapon VW)
{
    return super.PenetrateVehicleWeapon(VW); // TEMP as the DHShouldPenetrate() function below runs into a class inheritance problem, which needs some changes

//  return !DHVehicleCannon(VW).DHShouldPenetrate(self, HitLocation, Normal(Velocity), GetPenetration(LaunchLocation - HitLocation)))
}

// Run penetration calculations on an armored vehicle, but damage any other vehicle automatically
simulated function bool PenetrateVehicle(ROVehicle V)
{
    return super.PenetrateVehicle(V); // TEMP as the DHShouldPenetrate() function below runs into a class inheritance problem, which needs some changes

//  return DHArmoredVehicle(V).DHShouldPenetrate(self, Location, Normal(Velocity), GetPenetration(LaunchLocation - Location)))
}

defaultproperties
{
    VehiclePenetrateEffectClass=class'DH_Effects.DHBulletPenetrateArmorEffect' // custom class with much smaller penetration effects than shell (PTRD uses 'TankAPHitPenetrateSmall')
    VehiclePenetrateSound=sound'ProjectileSounds.PTRD_penetrate'
    VehiclePenetrateSoundVolume=5.5
//  VehicleDeflectEffectClass=class'TankAPHitDeflect' // this effect is too much for multiple hits from an MG, so we'll use the standard bullet deflect effect
    VehicleDeflectSound=sound'PTRD_deflect'
    VehicleDeflectSoundVolume=5.5
}
