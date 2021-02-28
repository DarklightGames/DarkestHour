//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHRocketWeapon extends DHSemiAutoWeapon
    abstract;

struct RangeSetting
{
    var int  FirePitch;
    var name IronIdleAnim;
    var name FireIronAnim;
};

var     array<RangeSetting>     RangeSettings;                // array of different range settings, with firing pitch angle & idle animation
var     int                     RangeIndex;                   // current range setting
var     bool                    bCanHaveAsssistedReload;      // another friendly player can provide an assisted reload, which is much quicker //COMPAREPIAT added
var     name                    AssistedMagEmptyReloadAnim;   // 1st person animation for assisted empty reload
var     name                    AssistedMagPartialReloadAnim; // 1st person animation for assisted partial reload
var     class<ROFPAmmoRound>    RocketAttachmentClass;
var     ROFPAmmoRound           RocketAttachment;             // the attached first person ammo round
var     class<LocalMessage>     WarningMessageClass;

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerSetFirePitch;

    // Functions the server can call on the client that owns this actor
    reliable if (Role == ROLE_Authority)
        ClientDoAssistedReload;
}

// Overridden to cycle the weapon aiming range
simulated exec function Deploy()
{
    if (bUsingSights && !IsBusy())
    {
        RangeIndex = ++RangeIndex % RangeSettings.Length; // loops back to 0 when exceeds last range setting

        if (InstigatorIsLocallyControlled())
        {
            PlayIdle();
        }
    }
}

// Modified to play the weapon iron animations for different ranges
simulated function PlayIdle()
{
    if (bUsingSights && HasAnim(RangeSettings[RangeIndex].IronIdleAnim))
    {
        LoopAnim(RangeSettings[RangeIndex].IronIdleAnim, IdleAnimRate, 0.2);
    }
    else if (HasAnim(IdleAnim))
    {
        LoopAnim(IdleAnim, IdleAnimRate, 0.2);
    }
}

// Modified to include assisted reload status & for different handling of CurrentMagCount
// Rocket doesn't have a loaded 'mag' or loaded rounds (AmmoCharge) - CurrentMagCount is just total mags & loaded/unloaded status is flagged by setting AmmoCharge[0] to 1 or 0
function UpdateResupplyStatus(bool bCurrentWeapon)
{
    local DHPawn P;

    P = DHPawn(Instigator);

    if (bCurrentWeapon)
    {
        CurrentMagCount = PrimaryAmmoArray.Length; // normally Length -1
    }

    if (P != none)
    {
        P.bWeaponNeedsResupply = bCanBeResupplied && bCurrentWeapon && CurrentMagCount < MaxNumPrimaryMags && (TeamIndex == 2 || TeamIndex == P.GetTeamNum());
        P.bWeaponNeedsReload = bCanHaveAsssistedReload && bCurrentWeapon && !IsLoaded() && CurrentMagCount > 0 && !IsInState('Reloading');
    }
}

// Modified to spawn or destroy any rocket attachment
simulated function BringUp(optional Weapon PrevWeapon)
{
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (IsLoaded())
        {
            if (RocketAttachmentClass != none && RocketAttachment == none)
            {
                SpawnRocketAttachment();
            }
        }
        else if (RocketAttachment != none)
        {
            RocketAttachment.Destroy();
        }
    }

    super.BringUp(PrevWeapon);
}

// Modified to unload a loaded rocket if weapon is flagged as bDoesNotRetainLoadedMag
simulated function bool PutDown()
{
    if (bDoesNotRetainLoadedMag && IsLoaded())
    {
        AmmoCharge[0] = 0; // unload rocket

        if (InstigatorIsLocalHuman())
        {
            Instigator.ReceiveLocalizedMessage(class'DHATLoadMessage', 2); // rocket unloaded
        }
    }

    return super.PutDown();
}

// Modified so if player has entered vehicle, we unload a loaded rocket if weapon is flagged as bDoesNotRetainLoadedMag (pawn's StartDriving event calls this function)
simulated function NotifyOwnerJumped()
{
    if (Instigator != none && Instigator.DrivenVehicle != none && bDoesNotRetainLoadedMag && IsLoaded())
    {
        AmmoCharge[0] = 0; // unload rocket

        // Clumsy, but different mode timings mean on net client the player will be controlling the vehicle, while in single player he will be controlling the player pawn
        if (Instigator.DrivenVehicle.IsLocallyControlled() && Instigator.DrivenVehicle.IsHumanControlled())
        {
            Instigator.DrivenVehicle.ReceiveLocalizedMessage(class'DHATLoadMessage', 2); // rocket unloaded
        }
        else if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            Instigator.ReceiveLocalizedMessage(class'DHATLoadMessage', 2);
        }
    }

    super.NotifyOwnerJumped();
}

// New function to spawn any RocketAttachment actor (note this may get called by a reload animation notify, so the timing is spot on, e.g. PIAT)
simulated function SpawnRocketAttachment()
{
    local vector ProjectileLocation;

    if (Level.NetMode != NM_DedicatedServer)
    {
        ProjectileLocation = GetBoneCoords(MuzzleBone).Origin;
        RocketAttachment = Spawn(RocketAttachmentClass, self,, ProjectileLocation);
        AttachToBone(RocketAttachment, MuzzleBone);
    }
}

// New function to check if weapon can fire
// Default is to prevent firing (with message) if player is prone or not ironsighted, but allows easy subclassing for different weapon requirements
simulated function bool CanFire(optional bool bShowFailureMessage)
{
    if (InstigatorIsLocallyControlled() && !bUsingSights)
    {
        if (bShowFailureMessage && InstigatorIsHumanControlled())
        {
            Instigator.ReceiveLocalizedMessage(WarningMessageClass, 1,,, self); // can't fire from hip
        }

        return false;
    }

    if (VSize(Instigator.Velocity) > 0 || (Instigator.Base != none && VSize(Instigator.Base.Velocity) > 0))
    {
        if (bShowFailureMessage && InstigatorIsHumanControlled())
        {
            Instigator.ReceiveLocalizedMessage(WarningMessageClass, 7,,, self); // must be stationary to fire
        }

        return false;
    }

    return true;
}

// Modified to check CanFire() & to set firing pitch based on current range setting
simulated function Fire(float F)
{
    if (CanFire(true)) // true flags to show a screen message if can't fire
    {
        if (IsLoaded() && DHProjectileFire(FireMode[0]) != none)
        {
            if (bUsingSights)
            {
                ServerSetFirePitch(RangeSettings[RangeIndex].FirePitch);
            }
            else
            {
                ServerSetFirePitch(DHProjectileFire(FireMode[0]).default.AddedPitch); // use default AddedPitch if not ironsighted
            }
        }

        super.Fire(F);
    }
}

// Switch the weapon aiming range on the server
function ServerSetFirePitch(int AddedPitch)
{
    if (DHProjectileFire(FireMode[0]) != none)
    {
        DHProjectileFire(FireMode[0]).AddedPitch = AddedPitch;
    }
}

// Modified to update the player's reload & resupply status, & to destroy any RocketAttachment
simulated function PostFire()
{
    if (Role == ROLE_Authority)
    {
        if (PrimaryAmmoArray.Length > 0)
        {
            PrimaryAmmoArray.Remove(0, 1); // remove mag 0, which is the 'mag' from which we just fired off its only round
        }

        UpdateResupplyStatus(true);
    }

    if (RocketAttachment != none)
    {
        RocketAttachment.Destroy();
    }
}

// Modified so bots don't go straight to the reloading state if weapon not loaded
simulated function OutOfAmmo()
{
    super(ROWeapon).OutOfAmmo();
}

// Modified to prevent reloading if player is prone (with message) or if weapon is not empty
simulated function bool AllowReload()
{
    if (Instigator != none && Instigator.bIsCrawling)
    {
        if (Instigator.IsHumanControlled())
        {
            Instigator.ReceiveLocalizedMessage(WarningMessageClass, 4,,, self); // can't reload prone
        }

        return false;
    }

    if (!IsLoaded())
    {
        return super.AllowReload();
    }
}

// Modified to prevent proning while reloading & to make 3rd person WeaponAttachment switch back to normal mesh if was the EmptyMesh
simulated state Reloading
{
    simulated function BeginState()
    {
        super.BeginState();

        if (Role == ROLE_Authority)
        {
            UpdateResupplyStatus(true);
        }
    }

    simulated function bool WeaponAllowProneChange()
    {
        return false;
    }

    simulated function EndState()
    {
        local DHRocketWeaponAttachment WA;

        super.EndState();

        if (Level.NetMode != NM_DedicatedServer)
        {
            WA = DHRocketWeaponAttachment(ThirdPersonActor);

            if (WA != none && WA.Mesh == WA.EmptyMesh)
            {
                WA.LinkMesh(WA.default.Mesh);
            }
        }
    }
}

// Server-to-client function to send client into state AssistedReloading
simulated function ClientDoAssistedReload(optional int NumRounds)
{
    GotoState('AssistedReloading');
}

// New state for assisted reloading
simulated state AssistedReloading extends Reloading
{
    simulated function BeginState()
    {
        if (Role == ROLE_Authority)
        {
            if (DHPawn(Instigator) != none)
            {
                DHPawn(Instigator).HandleAssistedReload();
            }

            // Let other players know we don't need to be reloaded anymore
            UpdateResupplyStatus(true);
        }

        if (IsLoaded())
        {
            PlayAnimAndSetTimer(AssistedMagPartialReloadAnim, 1.0, 0.1);
        }
        else
        {
            PlayAnimAndSetTimer(AssistedMagEmptyReloadAnim, 1.0, 0.1);
        }
    }

// Emptied to avoid taking player out of ironsights when someone else is loading them
Begin:
}

// Modified for special handling of rocket load status (also removing all stuff irrelevant to rocket, including cycling CurrentMagIndex)
function PerformReload(optional int Count)
{
    if (CurrentMagCount > 0)
    {
        AmmoCharge[0] = 1; // signifies rocket loaded

        if (IsLoaded() && ROWeaponAttachment(ThirdPersonActor) != none)
        {
            ROWeaponAttachment(ThirdPersonActor).bOutOfAmmo = false; // update the weapon attachment ammo status
        }

        UpdateResupplyStatus(true);
    }
}

// Modified to update the player's reload & resupply status
simulated function Destroyed()
{
    if (RocketAttachment != none)
    {
        RocketAttachment.Destroy();
    }

    super.Destroyed();
}

// When another player provides an assisted reload, which is much faster
function bool AssistedReload()
{
    if (bCanHaveAsssistedReload)
    {
        if (bUsingSights)
        {
            // Allow if weapon is shouldered (ironsighted) & is empty & player has some ammo to load
            if (!IsLoaded() && CurrentMagCount > 0)
            {
                GotoState('AssistedReloading');
                ClientDoAssistedReload();

                return true;
            }
        }
        // If weapon isn't shouldered (ironsighted), give a screen message
        else if (InstigatorIsHumanControlled())
        {
            Instigator.ReceiveLocalizedMessage(WarningMessageClass, 6,,, self); // must shoulder weapon for assisted reload
        }
    }

    return false;
}

// Modified to reduce displayed number of rounds by 1 if a rocket is loaded
simulated function int GetHudAmmoCount()
{
    if (IsLoaded())
    {
        return CurrentMagCount - 1;
    }

    return CurrentMagCount;
}

// New function just to add to readability in other functions
simulated function bool IsLoaded()
{
    return AmmoCharge[0] > 0;
}

function float GetAIRating()
{
    local Bot   B;
    local float ZDiff, Dist, Result;

    B = Bot(Instigator.Controller);

    if (B == none || B.Enemy == none)
    {
        return AIRating;
    }

    if (Vehicle(B.Enemy) == none)
    {
        return 0.0;
    }

    Result = AIRating;
    ZDiff = Instigator.Location.Z - B.Enemy.Location.Z;

    if (ZDiff > -300.0)
    {
        Result += 0.2;
    }

    Dist = VSize(B.Enemy.Location - Instigator.Location);

    if (Dist > 400.0 && Dist < 6000.0)
    {
        return FMin(2.0, Result + (6000.0 - Dist) * 0.0001);
    }

    return Result;
}

// Modified to add RocketAttachment static mesh
static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    if (default.RocketAttachmentClass != none && default.RocketAttachmentClass.default.StaticMesh != none)
    {
        L.AddPrecacheStaticMesh(default.RocketAttachmentClass.default.StaticMesh);
    }
}

// Modified to stop backblast damage from hurting the shooter (nothing else calls HurtRadius, so this hack should not be harmful)
// This is a hack, but is also a temporary solution until the backblast system is redesigned
simulated function HurtRadius(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
    local actor  Victims;
    local vector Dir;
    local float  Dist, DamageScale;

    if (bHurtEntry)
    {
        return;
    }

    bHurtEntry = true;

    foreach VisibleCollidingActors(class'Actor', Victims, DamageRadius, HitLocation)
    {
        if (Victims != self && Victims != Pawn(Owner) && Victims.Role == ROLE_Authority && !Victims.IsA('FluidSurfaceInfo'))
        {
            Dir = Victims.Location - HitLocation;
            Dist = FMax(1.0, VSize(Dir));
            Dir = Dir / Dist;
            DamageScale = 1.0 - FMax(0.0, (Dist - Victims.CollisionRadius) / DamageRadius);

            Victims.TakeDamage(DamageScale * DamageAmount, Instigator, Victims.Location - (0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * Dir),
                (DamageScale * Momentum * Dir), DamageType);

            if (Instigator != none && Vehicle(Victims) != none && Vehicle(Victims).Health > 0)
            {
                Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, Instigator.Controller, DamageType, Momentum, HitLocation);
            }
        }
    }

    bHurtEntry = false;
}

defaultproperties
{
    InventoryGroup=5
    Priority=8
    WarningMessageClass=class'DH_Engine.DHRocketWarningMessage'

    IronSightDisplayFOV=25.0
    FreeAimRotationSpeed=7.5

    MaxNumPrimaryMags=2
    InitialNumPrimaryMags=2
    FillAmmoMagCount=1
    bCanBeResupplied=true
    NumMagsToResupply=1

    MagEmptyReloadAnims(0)="Reloads"
    MagPartialReloadAnims(0)="Reloads"
    AssistedMagEmptyReloadAnim="reloadA"
    AssistedMagPartialReloadAnim="reloadA"
    PutDownAnim="putaway"
    IronIdleAnim=""

    AIRating=0.6
    CurrentRating=0.6
}
