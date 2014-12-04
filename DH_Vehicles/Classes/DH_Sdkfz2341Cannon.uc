//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Sdkfz2341Cannon extends DH_ROTankCannon; // Matt: originally extended ROTankCannon

var int  NumMags;
var int  NumSecMags;
var int  NumTertMags;     // Matt: added
var bool bMixedMagFireAP; // Matt: added to flag that mixed AP/HE mag is due to fire an AP round

replication
{
    reliable if (bNetDirty && bNetOwner && Role == ROLE_Authority)
        NumMags, NumSecMags, NumTertMags; // Matt: added NumTertMags

    // Functions the server calls on the client side.
//  reliable if (Role==ROLE_Authority)
//      ClientDoCannonReload; // Matt: replaced by existing ClientSetReloadState
}

// Matt: modified to add tertiary & significantly simplified/optimised
event bool AttemptFire(Controller C, bool bAltFire)
{
    local int   FireMode;
    local float FireSpread;

    if (Role != ROLE_Authority || bForceCenterAim)
    {
        return false;
    }

//  if ((!bAltFire && CannonReloadState == CR_ReadyToFire && FireCountdown <= 0) || (bAltFire && FireCountdown <= 0))
    if (FireCountdown <= 0 && ((CannonReloadState == CR_ReadyToFire && bClientCanFireCannon) || bAltFire)) // Matt: simplified but added bClientCanFireCannon for consistency
    {
        CalcWeaponFire(bAltFire);

        if (bCorrectAim)
        {
            WeaponFireRotation = AdjustAim(bAltFire);
        }

        if (bAltFire)
        {
            if (AltFireSpread > 0)
            {
                WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand() * FRand() * AltFireSpread);
            }
        }
        else
        {
            if (ProjectileClass == PrimaryProjectileClass || !bMultipleRoundTypes)
            {
                FireMode = 0;
                FireSpread = Spread;
            }
            else if (ProjectileClass == SecondaryProjectileClass) // Matt: added back from DHROTC, but optimised
            {
                FireMode = 1;
                
                if (bUsesSecondarySpread && SecondarySpread > 0)
                {
                    FireSpread = SecondarySpread;
                }
            }
            else if (ProjectileClass == TertiaryProjectileClass) // Matt: added back from DHROTC, but optimised
            {
                FireMode = 2;

                if (bUsesTertiarySpread && TertiarySpread > 0)
                {
                    FireSpread = TertiarySpread;
                }
            }
            
            if (FireSpread > 0)
            {
                WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand() * FRand() * FireSpread);
                WeaponFireRotation += rot(1,6,0); // correction to the aim point and to center the spread pattern // Matt: added back from DHROTC
            }
        }

        DualFireOffset *= -1;

        Instigator.MakeNoise(1.0);

        if (bAltFire)
        {
            if (!ConsumeAmmo(3)) // Matt: changed from 2 (MG mode)
            {
                VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);
                HandleReload();

                return false;
            }

            FireCountdown = AltFireInterval;
            AltFire(C);

            if (!HasAmmo(3))
            {
                HandleReload();
            }
        }
        else
        {
            if (!ConsumeAmmo(FireMode)) // Matt: means the cannon is already empty so we can't fire
            {
                VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);
                HandleCannonReload();

                return false;
            }

            Fire(C);
            FireCountdown = FireInterval;

            if (!HasAmmo(FireMode)) // Matt: means the cannon is now empty, after firing our last primary round
            {
                HandleCannonReload();
            }
        }

        AimLockReleaseTime = Level.TimeSeconds + FireCountdown * FireIntervalAimLock;

        return true;
    }

    return false;
}

// Matt: modified to alternate between AP & HE rounds if firing a mixed mag (the tertiary ammo type)
state ProjectileFireMode
{
    function Fire(Controller C)
    {
        if (ProjectileClass == PrimaryProjectileClass)
        {
            if (bMixedMagFireAP)
            {
                SpawnProjectile(SecondaryProjectileClass, false);
            }
            else
            {
                SpawnProjectile(TertiaryProjectileClass, false);
            }

            bMixedMagFireAP = !bMixedMagFireAP;
        }
        else
        {
            SpawnProjectile(ProjectileClass, false);
        }
    }
}

function Projectile SpawnProjectile(class<Projectile> ProjClass, bool bAltFire)
{
    local Projectile        P;
    local VehicleWeaponPawn WeaponPawn;
    local vector            StartLocation, HitLocation, HitNormal, Extent;
    local rotator           FireRot;

    FireRot = WeaponFireRotation;

    // Used only for Human players - lets cannons with non-centered aim points have a different aiming location
    if (Instigator != none && Instigator.IsHumanControlled())
    {
        FireRot.Pitch += AddedPitch;
    }

    if (!bAltFire)
    {
        FireRot.Pitch += ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);
    }

    if (bCannonShellDebugging)
    {
        Log("GetPitchForRange for" @ CurrentRangeIndex @ "=" @ ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]));
    }

    if (bDoOffsetTrace)
    {
        Extent = ProjClass.default.CollisionRadius * vect(1.0,1.0,0.0);
        Extent.Z = ProjClass.default.CollisionHeight;
        WeaponPawn = VehicleWeaponPawn(Owner);

        if (WeaponPawn != none && WeaponPawn.VehicleBase != none)
        {
            if (!WeaponPawn.VehicleBase.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation, 
                WeaponFireLocation + vector(WeaponFireRotation) * (WeaponPawn.VehicleBase.CollisionRadius * 1.5), Extent))
            {
                StartLocation = HitLocation;
            }
            else
            {
                StartLocation = WeaponFireLocation + vector(WeaponFireRotation) * (ProjClass.default.CollisionRadius * 1.1);
            }
        }
        else
        {
            if (!Owner.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation, WeaponFireLocation + vector(WeaponFireRotation) * (Owner.CollisionRadius * 1.5), Extent))
            {
                StartLocation = HitLocation;
            }
            else
            {
                StartLocation = WeaponFireLocation + vector(WeaponFireRotation) * (ProjClass.default.CollisionRadius * 1.1);
            }
        }
    }
    else
    {
        StartLocation = WeaponFireLocation;
    }

    if (bCannonShellDebugging)
    {
        Trace(TraceHitLocation, HitNormal, WeaponFireLocation + 65355.0 * vector(WeaponFireRotation), WeaponFireLocation, false);
    }

    P = Spawn(ProjClass, none, , StartLocation, FireRot);

    // Swap to the next round type after firing // Matt: no change from me; this is just noting what the original removed from the Super (the only change in this function)
//  if (PendingProjectileClass != none && ProjClass == ProjectileClass && ProjectileClass != PendingProjectileClass)
//  {
//      ProjectileClass = PendingProjectileClass;
//  }

    if (P != none)
    {
        if (bInheritVelocity)
        {
            P.Velocity = Instigator.Velocity;
        }

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
            {
                PlayOwnedSound(AltFireSoundClass, SLOT_None, FireSoundVolume/255.0, , AltFireSoundRadius,, false);
            }
        }
        else
        {
            if (bAmbientFireSound)
            {
                AmbientSound = FireSoundClass;
            }
            else
            {
                PlayOwnedSound(CannonFireSound[Rand(3)], SLOT_None, FireSoundVolume/255.0, , FireSoundRadius,, false);
            }
        }
    }

    return P;
}

// Matt: modified slightly for consistency & simplification
simulated function ClientStartFire(Controller C, bool bAltFire)
{
    bIsAltFire = bAltFire;

//  if ((!bIsAltFire && CannonReloadState == CR_ReadyToFire && FireCountDown <= 0) || (bIsAltFire && FireCountdown <= 0))
    if (FireCountDown <= 0 && ((CannonReloadState == CR_ReadyToFire && bClientCanFireCannon) || bIsAltFire)) // Matt: simplified but added bClientCanFireCannon for consistency
    {
        if (bIsRepeatingFF)
        {
            if (bIsAltFire)
            {
                ClientPlayForceFeedback(AltFireForce);
            }
            else
            {
                ClientPlayForceFeedback(FireForce);
            }
        }

        OwnerEffects();
    }
}

// Matt: modified slightly but no significant changes
simulated event OwnerEffects()
{
    // Stop the firing effects it we shouldn't be able to fire
    if (Role < ROLE_Authority && !ReadyToFire(bIsAltFire))
    {
        VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bIsAltFire);
        return; // Matt: original 234/1 removes return, suggesting fire effects would happen if weapon can't fire - doesn't seem to matter either way but have reinstated as seems more logical
    }

    if (!bIsRepeatingFF)
    {
        if (bIsAltFire)
        {
            ClientPlayForceFeedback(AltFireForce);
        }
        else
        {
            ClientPlayForceFeedback(FireForce);
        }
    }

    ShakeView(bIsAltFire);

    if (bIsAltFire && Level.NetMode == NM_Standalone && AmbientEffectEmitter != none)
    {
        AmbientEffectEmitter.SetEmitterStatus(true);
    }

    if (Role < ROLE_Authority)
    {
        if (bIsAltFire)
        {
            FireCountdown = AltFireInterval;
        }
        else // Matt: note original adds back this commented else, as it uses FireCountDown for auto fire interval
        {
            FireCountdown = FireInterval;
        }
/*
        if (!bIsAltFire) // Matt: note original removes this 'if'
        {
            if (Instigator != none && ROPlayer(Instigator.Controller) != none && ROPlayer(Instigator.Controller).bManualTankShellReloading)
            {
                CannonReloadState = CR_Waiting;
            }
            else
            {
                CannonReloadState = CR_Empty;
                SetTimer(0.01, false);
            }

            bClientCanFireCannon = false;
        }
*/
        AimLockReleaseTime = Level.TimeSeconds + FireCountdown * FireIntervalAimLock;

        FlashMuzzleFlash(bIsAltFire);

//      if (AmbientEffectEmitter != none && bIsAltFire) // Matt: moved under 'if' below to optimise
//      {
//         AmbientEffectEmitter.SetEmitterStatus(true);
//      }

        if (bIsAltFire)
        {
            if (AmbientEffectEmitter != none)
            {
                AmbientEffectEmitter.SetEmitterStatus(true);
            }

            if (!bAmbientAltFireSound)
            {
                PlaySound(AltFireSoundClass, SLOT_None, FireSoundVolume / 255.0, , AltFireSoundRadius, , false);
            }
            else
            {
                SoundVolume = AltFireSoundVolume;
                SoundRadius = AltFireSoundRadius;
                AmbientSoundScaling = AltFireSoundScaling;
            }
        }
        else if (!bAmbientFireSound)
        {
            PlaySound(CannonFireSound[Rand(3)], SLOT_None, FireSoundVolume / 255.0, , FireSoundRadius, , false);
        }
    }
}

/*
simulated event FlashMuzzleFlash(bool bWasAltFire) // Matt: removed as only change was to remove spawning CannonDustEmitter, but can be achieved simply by setting CannonDustEmitterClass=none
{
    local ROVehicleWeaponPawn OwningPawn;

    if (Role == ROLE_Authority)
    {
        if (bWasAltFire)
            FiringMode = 1;
        else
            FiringMode = 0;
        FlashCount++;
        NetUpdateTime = Level.TimeSeconds - 1;
    }
    else
        CalcWeaponFire(bWasAltFire);

    if (bUsesTracers && (!bWasAltFire && !bAltFireTracersOnly || bWasAltFire))
        UpdateTracer();

    if (bWasAltFire)
        return;

    if (FlashEmitter != none)
        FlashEmitter.Trigger(Self, Instigator);

    if ((EffectEmitterClass != none) && EffectIsRelevant(Location, false))
        EffectEmitter = spawn(EffectEmitterClass, self,, WeaponFireLocation, WeaponFireRotation);

//  if ( (CannonDustEmitterClass != None) && EffectIsRelevant(Location,false) ) // Matt: note removing this was the only change, but can be achieved by simply setting CannonDustEmitterClass=none
//      CannonDustEmitter = spawn(CannonDustEmitterClass, self,, Base.Location, Base.Rotation);

    OwningPawn = ROVehicleWeaponPawn(Instigator);

    if (OwningPawn != none && OwningPawn.DriverPositions[OwningPawn.DriverPositionIndex].bExposed)
    {
        if (HasAnim(TankShootOpenAnim))
            PlayAnim(TankShootOpenAnim);
    }
    else if (HasAnim(TankShootClosedAnim))
    {
        PlayAnim(TankShootClosedAnim);
    }
}
*/

// Matt: modified to handle our modified reload process for players who manually reload
function ServerManualReload()
{
    if (Role == ROLE_Authority && CannonReloadState == CR_Waiting)
    {
        HandleCannonReload(true); // true flags that this is a manually-triggered reload
    }
}

// Matt: new function that handles all 3 round types, trying all the alternatives if we're out of some types of ammo
function HandleCannonReload(optional bool bIsManualReload)
{
    bClientCanFireCannon = false;

    // If player uses manual reloading & this isn't a manually-triggered reload, then just go to reload state waiting
    if (Instigator != none && ROPlayer(Instigator.Controller) != none && ROPlayer(Instigator.Controller).bManualTankShellReloading && !bIsManualReload)
    {
        CannonReloadState = CR_Waiting;
        ClientSetReloadState(CannonReloadState); // primarily so client's HUD can display ammo icon in red to show it needs a reload
    }
    // Otherwise check ammo & proceed with reload if we have some
    else if (CannonReloadState != CR_Empty)
    {
        // We don't have a spare mag for the pending round type
        if (!HasMagazines(GetPendingRoundIndex()))
        {
            // Try to switch to another round type if that has a spare mag (but not if player reloads manually)
            if (!bIsManualReload)
            {
                ToggleRoundType();
            }

            // Abort reload if we still don't have a spare mag (so must be completely out of cannon ammo) or if player reloads manually
            if (bIsManualReload || !HasMagazines(GetPendingRoundIndex()))
            {
                CannonReloadState = CR_Waiting;
                ClientSetReloadState(CannonReloadState);

                return;
            }
        }

        // Switch round type if pending round is different
        if (ProjectileClass != PendingProjectileClass && PendingProjectileClass != none)
        {
            ProjectileClass = PendingProjectileClass;
        }

        // Remove 1 spare mag & also 're-charge' the cannon (seems premature but it's easier to do it here & cannon won't be able to fire until reload completes)
        if (ProjectileClass == PrimaryProjectileClass)
        {
            NumMags--;
            MainAmmoChargeExtra[0] = InitialPrimaryAmmo;
            bMixedMagFireAP = default.bMixedMagFireAP;
        }
        else if (ProjectileClass == SecondaryProjectileClass)
        {
            NumSecMags--;
            MainAmmoChargeExtra[1] = InitialSecondaryAmmo;
        }
        else if (ProjectileClass == TertiaryProjectileClass)
        {
            NumTertMags--;
            MainAmmoChargeExtra[2] = InitialTertiaryAmmo;
        }

        // Start reload on both client & server
        NetUpdateTime = Level.TimeSeconds - 1.0;
        CannonReloadState = CR_Empty;
        ClientSetReloadState(CannonReloadState);
        SetTimer(0.01, false);
    }
}

/*
function HandlePrimaryCannonReload() // Matt: replaced by new, consolidated HandleCannonReload function
{
    if (NumMags > 0 && CannonReloadState != CR_Empty)
    {
        ClientDoCannonReload();
        NumMags--;
        MainAmmoCharge[0] = InitialPrimaryAmmo;
        NetUpdateTime = Level.TimeSeconds - 1;

        if (PendingProjectileClass == none)
            PendingProjectileClass = PrimaryProjectileClass;

        ProjectileClass = PendingProjectileClass;

        CannonReloadState = CR_Empty;
        SetTimer(0.01, false);
    }
}

function HandleSecondaryCannonReload() // Matt: replaced by new, consolidated HandleCannonReload function
{
    if (NumSecMags > 0 && CannonReloadState != CR_Empty)
    {
        ClientDoCannonReload();
        NumSecMags--;
        MainAmmoCharge[1] = InitialSecondaryAmmo;
        NetUpdateTime = Level.TimeSeconds - 1;

        if (PendingProjectileClass == none)
            PendingProjectileClass = SecondaryProjectileClass;

        ProjectileClass = PendingProjectileClass;

        CannonReloadState = CR_Empty;
        SetTimer(0.01, false);
    }
}

// Set the fire countdown client side
simulated function ClientDoCannonReload() // Matt: this is a new function, specific to 20mm, but removed as we can use the existing ClientSetReloadState
{
    CannonReloadState = CR_Empty;
    SetTimer(0.01, false);
}

simulated function Tick(float Delta) // Matt: removed as was having no effect originally, but now we actually want the DH_ROTankCannon turret fire effects
{
    super(ROVehicleWeapon).Tick(Delta);
}
*/

// Matt: modified to include tertiary & also generally optimised
function ToggleRoundType()
{
    if (PendingProjectileClass == PrimaryProjectileClass)
    {
        if (HasMagazines(1))
        {
            PendingProjectileClass = SecondaryProjectileClass;
        }
        else if (HasMagazines(2))
        {
            PendingProjectileClass = TertiaryProjectileClass;
        }
    }
    else if (PendingProjectileClass == SecondaryProjectileClass)
    {
        if (HasMagazines(2))
        {
            PendingProjectileClass = TertiaryProjectileClass;
        }
        else if (HasMagazines(0))
        {
            PendingProjectileClass = PrimaryProjectileClass;
        }
    }
    else if (PendingProjectileClass == TertiaryProjectileClass)
    {
        if (HasMagazines(0))
        {
            PendingProjectileClass = PrimaryProjectileClass;
        }
        else if (HasMagazines(1))
        {
            PendingProjectileClass = SecondaryProjectileClass;
        }
    }
    else
    {
        if (HasMagazines(0))
        {
            PendingProjectileClass = PrimaryProjectileClass;
        }
        else if (HasMagazines(1))
        {
            PendingProjectileClass = SecondaryProjectileClass;
        }
        else if (HasMagazines(2))
        {
            PendingProjectileClass = TertiaryProjectileClass;
        }
    }
}

// Matt: modified to include tertiary
simulated function bool ReadyToFire(bool bAltFire)
{
    local  int  Mode;

    if (bAltFire)
    {
        Mode = 3; // Matt: was 2
    }
    else if (CannonReloadState != CR_ReadyToFire || !bClientCanFireCannon) // Matt: have moved up here to optimise
    {
        return false;
    }
    else if (ProjectileClass == PrimaryProjectileClass || !bMultipleRoundTypes) // Matt: added !bMultipleRoundTypes
    {
        Mode = 0;
    }
    else if (ProjectileClass == SecondaryProjectileClass)
    {
        Mode = 1;
    }
    else if (ProjectileClass == TertiaryProjectileClass) // Matt: added
    {
        Mode = 2;
    }

    if (HasAmmo(Mode))
    {
        return true;
    }

    return false;
}

// Matt: modified to include tertiary
simulated function bool HasMagazines(int Mode)
{
    switch (Mode)
    {
        case 0:
            return NumMags > 0;
        case 1:
            return NumSecMags > 0;
        case 2:
            return NumTertMags > 0; // Matt: added
        default:
            return false;
    }
}

// Matt: modified to include tertiary
simulated function int PrimaryAmmoCount()
{
    if (bMultipleRoundTypes)
    {
        if (ProjectileClass == PrimaryProjectileClass)
        {
            return NumMags;
        }
        else if (ProjectileClass == SecondaryProjectileClass)
        {
            return NumSecMags;
        }
        else if (ProjectileClass == TertiaryProjectileClass) // Matt: added
        {
            return NumTertMags;
        }
    }
    else
    {
        return NumMags;
    }
}

// Matt: modified to add all 3 mag types
function bool GiveInitialAmmo()
{
    if (MainAmmoChargeExtra[0] != InitialPrimaryAmmo || MainAmmoChargeExtra[1] != InitialSecondaryAmmo || MainAmmoChargeExtra[2] != InitialTertiaryAmmo || 
        AltAmmoCharge != InitialAltAmmo || NumMags != default.NumMags || NumSecMags != default.NumSecMags || NumTertMags != default.NumTertMags || NumAltMags != default.NumAltMags)
    {
        MainAmmoChargeExtra[0] = InitialPrimaryAmmo;
        bMixedMagFireAP = default.bMixedMagFireAP;
        MainAmmoChargeExtra[1] = InitialSecondaryAmmo;
        MainAmmoChargeExtra[2] = InitialTertiaryAmmo;
        AltAmmoCharge = InitialAltAmmo;
        NumMags = default.NumMags;
        NumSecMags = default.NumSecMags;
        NumTertMags = default.NumTertMags;
        NumAltMags = default.NumAltMags;

        return true;
    }

    return false;
}

// Matt: modified to work all 3 mag types into new ammo resupply system
function bool ResupplyAmmo()
{
    local bool bDidResupply;

    if (MainAmmoChargeExtra[0] < InitialPrimaryAmmo)
    {
        MainAmmoChargeExtra[0] = InitialPrimaryAmmo;
        bMixedMagFireAP = default.bMixedMagFireAP;
        bDidResupply = true;
    }

    if (MainAmmoChargeExtra[1] < InitialSecondaryAmmo)
    {
        MainAmmoChargeExtra[1] = InitialSecondaryAmmo;
        bDidResupply = true;
    }

    if (MainAmmoChargeExtra[2] < InitialTertiaryAmmo)
    {
        MainAmmoChargeExtra[2] = InitialTertiaryAmmo;
        bDidResupply = true;
    }

    if (NumMags < default.NumMags)
    {
        ++NumMags;
        bDidResupply = true;
    }

    if (NumSecMags < default.NumSecMags)
    {
        ++NumSecMags;
        bDidResupply = true;
    }

    if (NumTertMags < default.NumTertMags)
    {
        ++NumTertMags;
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
     // Matt: all added, as this is now a DH_ROTankCannon:
     FrontArmorFactor=0.8
     RightArmorFactor=0.8
     LeftArmorFactor=0.8
     RearArmorFactor=0.8
     FrontArmorSlope=30.0
     RightArmorSlope=30.0
     LeftArmorSlope=30.0
     RearArmorSlope=30.0
     FrontLeftAngle=306.0
     FrontRightAngle=54.0
     RearRightAngle=130.0
     RearLeftAngle=230.0
     
     NumMags=15     // Matt: was 25
     NumSecMags=15  // Matt: was 20
     NumTertMags=15 // Matt: added
     ReloadSoundOne=Sound'Vehicle_reloads.Reloads.T60_reload_01'
     ReloadSoundTwo=Sound'DH_GerVehicleSounds2.Reloads.234_reload_02'
     ReloadSoundThree=Sound'DH_GerVehicleSounds2.Reloads.234_reload_03'
     ReloadSoundFour=Sound'Vehicle_reloads.Reloads.T60_reload_04'
     CannonFireSound(0)=SoundGroup'DH_GerVehicleSounds.20mm.DH20mmFire01G'
     CannonFireSound(1)=SoundGroup'DH_GerVehicleSounds.20mm.DH20mmFire02G'
     CannonFireSound(2)=SoundGroup'DH_GerVehicleSounds.20mm.DH20mmFire03G'
     ProjectileDescriptions(0)="Mixed" // Matt: was "AP"
     ProjectileDescriptions(1)="AP"    // Matt: was "HE-T"
     ProjectileDescriptions(2)="HE-T"  // Matt: added
     RangeSettings(1)=100
     RangeSettings(2)=200
     RangeSettings(3)=300
     RangeSettings(4)=400
     RangeSettings(5)=500
     RangeSettings(6)=600
     RangeSettings(7)=700
     RangeSettings(8)=800
     RangeSettings(9)=900
     RangeSettings(10)=1000
     RangeSettings(11)=1100
     RangeSettings(12)=1200
     ReloadSound=Sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
     NumAltMags=12
     DummyTracerClass=class'DH_Vehicles.DH_MG42VehicleClientTracer'
     mTracerInterval=0.350000
     bUsesTracers=true
     bAltFireTracersOnly=true
     MinCommanderHitHeight=21.0
     VehHitpoints(0)=(PointRadius=9.000000,PointScale=1.000000,PointBone="com_attachment",PointOffset=(X=12.000000,Y=4.000000,Z=34.000000))
     VehHitpoints(1)=(PointRadius=15.000000,PointScale=1.000000,PointBone="com_attachment",PointOffset=(X=12.000000,Y=4.000000,Z=12.000000))
     hudAltAmmoIcon=Texture'InterfaceArt_tex.HUD.mg42_ammo'
     YawBone="Turret"
     PitchBone="Gun"
     PitchUpLimit=15000
     PitchDownLimit=45000
     WeaponFireAttachmentBone="Barrel"
     GunnerAttachmentBone="com_attachment"
     WeaponFireOffset=5.000000
     AltFireOffset=(X=-54.000000,Y=-24.000000,Z=-3.000000)
     RotationsPerSecond=0.040000
     ManualRotationsPerSecond=0.04  // Matt: added
     PoweredRotationsPerSecond=0.04 // Matt: added
     bAmbientAltFireSound=true
     Spread=0.003000
     bUsesSecondarySpread=false // Matt: added so uses Spread
     bUsesTertiarySpread=false  // Matt: added so uses Spread
//   AltFireSpread=0.002000     // Matt: removed as is inherited default from DHROTC
     FireInterval=0.200000
     AltFireInterval=0.050000
     FlashEmitterClass=class'ROEffects.MuzzleFlash3rdSTG'
     AmbientEffectEmitterClass=class'ROVehicles.TankMGEmitter'
     bAmbientEmitterAltFireOnly=true
     CannonDustEmitterClass=none // Matt: avoids having to override FlashMuzzleFlash function
     FireEffectOffset=(X=20.0,Y=-5.0,Z=20.0) // Matt: added
     FireSoundVolume=512.000000
     AltFireSoundClass=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireLoop01'
     AltFireSoundScaling=3.000000
     RotateSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse2'
     AltFireEndSound=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireEnd01'
     FireForce="Explosion05"
     bIsRepeatingFF=true // Matt: added, as strongly suspect this should be true, like a tank mounted MG
     ProjectileClass=class'DH_Vehicles.DH_Sdkfz2341CannonShellMixed' // Matt: changed
     AltFireProjectileClass=class'DH_Vehicles.DH_MG42VehicleBullet'
     ShakeRotMag=(Z=5.000000)
     ShakeRotRate=(Z=100.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(Z=0.500000)
     ShakeOffsetRate=(Z=10.000000)
     ShakeOffsetTime=2.000000
     AltShakeRotMag=(X=0.010000,Y=0.010000,Z=0.010000)
     AltShakeRotRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     AltShakeRotTime=2.000000
     AltShakeOffsetMag=(X=0.010000,Y=0.010000,Z=0.010000)
     AltShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     AltShakeOffsetTime=2.000000
     AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.500000)
     AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.015000)
     CustomPitchUpLimit=12743
     CustomPitchDownLimit=64443
     BeginningIdleAnim="com_idle_close"
     InitialPrimaryAmmo=10
     InitialSecondaryAmmo=10
     InitialTertiaryAmmo=10 // Matt: added
     InitialAltAmmo=150
     PrimaryProjectileClass=class'DH_Vehicles.DH_Sdkfz2341CannonShellMixed' // Matt: added class & made primary
     SecondaryProjectileClass=class'DH_Vehicles.DH_Sdkfz2341CannonShell'    // Matt: was primary
     TertiaryProjectileClass=class'DH_Vehicles.DH_Sdkfz2341CannonShellHE'   // Matt: was secondary
     Mesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_turret_ext'
     Skins(0)=Texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_body_dunk'
     Skins(1)=Texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_extras_dunk'
     Skins(2)=Texture'Weapons1st_tex.MG.mg42_barrel'
     Skins(3)=Texture'Weapons1st_tex.MG.mg42'
     SoundVolume=100
     SoundRadius=256.000000
}
