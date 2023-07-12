//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHExplosiveWeapon extends DHWeapon
    abstract;

var     name    PreFireHoldAnim;     // animation for holding the arm back ready to throw

var     bool    bPrimed;             // the nade is primed
var     bool    bHasReleaseLever;    // this explosive has a lever that must be released to arm the weapon
var     bool    bAlreadyExploded;    // the nade already blew up in your hands
var     float   FuzeLength;          // how long this grenade will take to go off
var     float   CurrentFuzeTime;     // how much fuse time is left

var     sound   LeverReleaseSound;   // sound of the lever being released on this weapon
var     float   LeverReleaseVolume;  // volume of the lever being released
var     float   LeverReleaseRadius;  // radius of the lever being released

var     int     StartFireAmmoAmount; // little hack so we don't decrement ammo count client side if we've already received a net update from server after firing

replication
{
    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
        bPrimed;

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerArmExplosive, ServerCheckPawnCanFire;

    // Functions the server can call on the client that owns this actor
    reliable if (Role == ROLE_Authority)
        ClientForcePawnCanFire;
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    CurrentFuzeTime = default.FuzeLength;
}

function ServerCheckPawnCanFire()
{
    if (ROPawn(Instigator) != none && !ROPawn(Instigator).bPreventWeaponFire)
    {
        ClientForcePawnCanFire();
    }
}

simulated function ClientForcePawnCanFire()
{
    if (ROPawn(Instigator) != none)
    {
        ROPawn(Instigator).bPreventWeaponFire = false;
    }
}

simulated function Fire(float F)
{
    if (bHasReleaseLever && FireMode[1].bIsFiring)
    {
        ArmExplosive();
    }
}

simulated function AltFire(float F)
{
    if (bHasReleaseLever && FireMode[0].bIsFiring)
    {
        ArmExplosive();
    }
}

// Called on the client to arm the explosive & play the lever release sounds
simulated function ArmExplosive()
{
    if (Role == ROLE_Authority)
    {
        if (!bPrimed)
        {
            bPrimed = true;

            if (bHasReleaseLever)
            {
                PlayOwnedSound(LeverReleaseSound, SLOT_None, LeverReleaseVolume,, LeverReleaseRadius,, false);
            }
        }
    }
    else
    {
        if (!bPrimed)
        {
            if (bHasReleaseLever)
            {
                PlayOwnedSound(LeverReleaseSound, SLOT_None, LeverReleaseVolume,, LeverReleaseRadius,, false);
            }

            ServerArmExplosive();
        }
    }
}

// Called on the server to arm the explosive, and play the lever release sound
function ServerArmExplosive()
{
    if (!bPrimed)
    {
        bPrimed = true;

        if (bHasReleaseLever)
        {
            PlayOwnedSound(LeverReleaseSound, SLOT_None, LeverReleaseVolume,, LeverReleaseRadius,, true);
        }
    }
}

// Used for when you throw a nade with a release lever, but you didn't release the lever
simulated function InstantPrime()
{
    if (!bPrimed)
    {
        bPrimed = true;

        if (bHasReleaseLever)
        {
            if (InstigatorIsLocallyControlled())
            {
                PlayOwnedSound(LeverReleaseSound, SLOT_None, LeverReleaseVolume,, LeverReleaseRadius,, false);
            }
            else
            {
                PlayOwnedSound(LeverReleaseSound, SLOT_None, LeverReleaseVolume,, LeverReleaseRadius,, true);
            }
        }
    }
}

// Modified to prevent another nade from being thrown instantly after the previous nade by pressing alternating fire/altfire buttons
// Also to set StartFireAmmoAmount so when net client's FireMode fires, it can tell whether weapon has received replicated reduced ammo count - if not it consumes ammo immediately on client
simulated function bool StartFire(int Mode)
{
    local int OtherMode;
    local class<DHWeaponFire> WF;
    local DHPlayer PC;

    WF = class<DHWeaponFire>(FireModeClass[Mode]);

    if (Instigator != none && (WF == none || !WF.default.bIgnoresWeaponLock))
    {
        PC = DHPlayer(Instigator.Controller);

        if (PC != none && PC.AreWeaponsLocked())
        {
            return false;
        }
    }

    if (!ReadyToFire(Mode))
    {
        return false;
    }

    if (Mode == 0)
    {
        OtherMode = 1;
    }
    else
    {
        OtherMode = 0;
    }

    if (Role < ROLE_Authority && InstigatorIsLocallyControlled()) // added here
    {
        StartFireAmmoAmount = AmmoAmount(Mode);
    }

    FireMode[Mode].bIsFiring = true;
    FireMode[Mode].NextFireTime = Level.TimeSeconds + FireMode[Mode].PreFireTime;

    if (FireMode[OtherMode].bModeExclusive)
    {
        // Prevents rapidly alternating fire modes
        FireMode[Mode].NextFireTime = FMax(FireMode[Mode].NextFireTime, FireMode[OtherMode].NextFireTime);

        // Prevent firing/alt firing nades right after each other - added here
        FireMode[OtherMode].NextFireTime = Level.TimeSeconds + FireMode[Mode].FireRate;
    }

    if (InstigatorIsLocallyControlled())
    {
        if (FireMode[Mode].PreFireTime > 0.0 || FireMode[Mode].bFireOnRelease)
        {
            FireMode[Mode].PlayPreFire();
        }

        FireMode[Mode].FireCount = 0;
    }

    return true;
}

// Modified to handle fuze & so after firing the player either brings up another weapon (if still has another) or switches to a new weapon
simulated function PostFire()
{
    bPrimed = false;
    CurrentFuzeTime = default.FuzeLength;
    bAlreadyExploded = false;

    GotoState('PostFiring');
}

// State where the weapon has just been fired, switching to state AutoLoweringWeapon after firing animation ends
simulated state PostFiring
{
    simulated function bool IsBusy()
    {
        return true;
    }

    simulated function bool CanStartCrawlMoving()
    {
        return false;
    }

    simulated function Timer()
    {
        GotoState('AutoLoweringWeapon');
    }

    simulated function BeginState()
    {
        SetTimer(GetAnimDuration(FireMode[0].FireAnim, 1.0), false);
    }

    simulated function EndState()
    {
        if (ROWeaponAttachment(ThirdPersonActor) != none)
        {
            ROWeaponAttachment(ThirdPersonActor).AmbientSound = none;
        }

        OldWeapon = none;
    }
}

// Overridden because we manually set the fire time to right now each time an explosive weapon is drawn
// This helps prevent grenades from getting thrown instantly after another one was thrown when rapidly alternating fire/altfire buttons
simulated state RaisingWeapon
{
    simulated function bool CanStartCrawlMoving()
    {
        return false;
    }

    simulated function BeginState()
    {
       local int i;

        super.BeginState();

        for (i = 0; i < NUM_FIRE_MODES; ++i)
        {
            FireMode[i].NextFireTime = Level.TimeSeconds;
        }
    }

    simulated function EndState()
    {
        local int i;

        // Clear any prevent weapon fire flags after the weapon is completely raised
        if (Role < ROLE_Authority)
        {
            if (ROPawn(Instigator) != none)
            {
                if (AmmoAmount(0) < 1)
                {
                    ROPawn(Instigator).bPreventWeaponFire = false;
                }
                else
                {
                    ServerCheckPawnCanFire();
                }
            }
        }

        if (ClientState == WS_BringUp)
        {
            for (i = 0; i < NUM_FIRE_MODES; ++i)
            {
                FireMode[i].InitEffects();
            }
        }
    }
}

// Overridden to fix the problem where a client would start switching weapons before the server finished auto lowering the weapon
// Now delete his weapon here if AutoLoweringWeapon has been interrupted by a weapon switch
simulated state LoweringWeapon
{
    simulated function BeginState()
    {
        if (Role == ROLE_Authority && AmmoAmount(0) < 1 && !bDeleteMe)
        {
            GotoState('Idle');
            SelfDestroy();
        }

        super.BeginState();
    }

    simulated function EndState()
    {
        if (!bDeleteMe)
        {
            super.EndState();
        }
    }
}

simulated state AutoLoweringWeapon
{
    simulated function bool WeaponCanBusySwitch()
    {
        return ClientState == WS_PutDown || super.WeaponCanSwitch();
    }

    simulated function bool CanStartCrawlMoving()
    {
        return false;
    }

    simulated function BeginState()
    {
        local int i;

        if (ClientState == WS_BringUp || ClientState == WS_ReadyToFire)
        {
            if (InstigatorIsLocallyControlled())
            {
                for (i = 0; i < NUM_FIRE_MODES; ++i)
                {
                    if (FireMode[i].bIsFiring)
                    {
                        ClientStopFire(i);
                    }
                }
            }

            ClientState = WS_PutDown;
        }

        SetTimer(0.01, false);

        for (i = 0; i < NUM_FIRE_MODES; ++i)
        {
            FireMode[i].bServerDelayStartFire = false;
            FireMode[i].bServerDelayStopFire = false;
        }
    }
}

// Overridden to support our held back anims for throwing nades
simulated function AnimEnd(int Channel)
{
    local name  Anim;
    local float Frame, Rate;

    if (ClientState == WS_ReadyToFire)
    {
        GetAnimParams(0, Anim, Frame, Rate);

        if ((Anim == FireMode[0].PreFireAnim || Anim == FireMode[1].PreFireAnim) && HasAnim(PreFireHoldAnim)) // grenade hack
        {
            LoopAnim(PreFireHoldAnim, IdleAnimRate, 0.2);
        }

        super.AnimEnd(Channel);
    }
}

// Modified to include new states PostFiring & AutoLoweringWeapon
simulated function SetSprinting(bool bNewSprintStatus)
{
    local int i;

    for (i = 0; i < NUM_FIRE_MODES; ++i)
    {
        if (FireMode[i].bIsFiring)
        {
            return;
        }
    }

    if (bNewSprintStatus)
    {
        if (ClientState != WS_PutDown && ClientState != WS_Hidden && !IsInState('WeaponSprinting') && !IsInState('RaisingWeapon')
            && !IsInState('LoweringWeapon') && !IsInState('PostFiring') && !IsInState('AutoLoweringWeapon'))
        {
            GotoState('StartSprinting');
        }
    }
    else if (IsInState('WeaponSprinting') || IsInState('StartSprinting'))
    {
        GotoState('EndSprinting');
    }
}

// Modified to allow player to fire/throw this weapon while sprinting & to handle PreFireHoldAnim
simulated state WeaponSprinting
{
    simulated event ClientStartFire(int Mode)
    {
        global.ClientStartFire(Mode);
    }

    simulated function bool ReadyToFire(int Mode)
    {
        return global.ReadyToFire(Mode);
    }

    simulated function PlayIdle()
    {
        local float LoopSpeed, Speed2d;
        local name  Anim;
        local int   i;

        if (InstigatorIsLocallyControlled())
        {
            // Make the sprinting animation match the sprinting speed
            LoopSpeed = 1.5;
            Speed2d = VSize(Instigator.Velocity);
            LoopSpeed = Speed2d / (Instigator.default.GroundSpeed * Instigator.SprintPct) * 1.5;

            Anim = SprintLoopAnim;

            for (i = 0; i < NUM_FIRE_MODES; ++i)
            {
                if (FireMode[i].bIsFiring)
                {
                    Anim = PreFireHoldAnim;
                }
            }

            if (HasAnim(Anim))
            {
                LoopAnim(Anim, LoopSpeed, 0.2);
            }
        }
    }
}

// Modified to allow same InventoryGroup items (frag grenades are on same inventory group) (satchel shares slot with shovel/wirecutters too)
function bool HandlePickupQuery(Pickup Item)
{
    local int i;

    // If no passed item, prevent pick up & stops checking rest of Inventory chain
    if (Item == none)
    {
        return true;
    }

    // Pickup weapon is same as this weapon, so see if we can carry another
    if (Class == Item.InventoryType && WeaponPickup(Item) != none)
    {
        for (i = 0; i < NUM_FIRE_MODES; ++i)
        {
            if (AmmoClass[i] != none && AmmoCharge[i] < MaxAmmo(i) && WeaponPickup(Item).AmmoAmount[i] > 0)
            {
                AddAmmo(WeaponPickup(Item).AmmoAmount[i], i);

                // Need to do this here as we're going to prevent a new weapon pick up, so the pickup won't give a screen message or destroy/respawn itself
                Item.AnnouncePickup(Pawn(Owner));
                Item.SetRespawn();

                break;
            }
        }

        return true; // prevents pick up, as already have weapon, & stops checking rest of Inventory chain
    }

    // Didn't do any pick up for this weapon, so pass this query on to the next item in the Inventory chain
    // If we've reached the last Inventory item, returning false will allow pick up of the weapon
    return Inventory != none && Inventory.HandlePickupQuery(Item);
}

function bool IsGrenade()
{
    return true;
}

function int GetNumberOfDroppedPickups()
{
    return AmmoAmount(0);
}

defaultproperties
{
    Priority=3
    PlayerViewOffset=(X=5.0,Y=5.0,Z=0.0)

    FuzeLength=5.0
    PreFireHoldAnim="pre_fire_idle"

    SelectAnim="Draw"
    PutDownAnim="Put_away"

    AIRating=0.4
    CurrentRating=0.4

    InventoryGroup=2
}
