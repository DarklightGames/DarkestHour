//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMeleeFire extends DHWeaponFire
    abstract;

const SOUND_RADIUS = 32.0;

var   protected float   VulnerableDamageFactor; // damage factor when instigator hits victim from behind or if victim is crawling
var   protected float   RearAngleArc;       // angle in Unreal rotational units for a player's rear (used to calculate rear melee hits)

// From ROMeleeFire
var   class<ROWeaponDamageType> DamageType;        // bash damage type
var   class<ROWeaponDamageType> BayonetDamageType; // bayonet stab damage type
var     int             DamageMin;          // min damage from a bash
var     int             DamageMax;          // max damage from a bash
var     int             BayonetDamageMin;   // min damage from a bayonet stab
var     int             BayonetDamageMax;   // max damage from a bayonet stab
var     float           TraceRange;         // how far to trace for a bash attack
var     float           BayonetTraceRange;  // how far to trace for a bayonet stab
var     float           MomentumTransfer;   // how much momentum to pass onto whatever we hit (was 100 in RO)
var     float           MinHoldTime;        // held for this time or less will do minimum damage/force
var     float           FullHeldTime;       // held for this long will do max damage
var     float           MeleeAttackSpread;  // how "large" the impact area of the bayonet strike is - the larger this is, the easier it is to hit, but the less precise the strike is
var     sound           GroundStabSound;    // sound of stabbing the ground with the bayonet
var     sound           GroundBashSound;    // sound of bashing the ground with the rifle butt
var     sound           PlayerStabSound;    // sound of stabbing the player with the bayonet
var     sound           PlayerBashSound;    // sound of bashing the player with the rifle butt

var         name        BayoBackEmptyAnim;
var         name        BayoStabEmptyAnim;
var         name        BayoFinishEmptyAnim;

// Modified to stop trying to make the weapon attachment play visual hit effects - they don't play & we don't want them anyway; it just creates pointless replication to all clients
// Also to increase damage if striking a player from behind, & to generally optimised
function DoTrace(vector Start, rotator Dir)
{
    local ROPawn            HitPawn;
    local Actor             Other;
    local class<DamageType> ThisDamageType;
    local vector            End, HitLocation, HitNormal, TempVec, X, Y, Z;
    local rotator           RotationDifference;
    local float             Damage, Scale;
    local array<int>        HitPoints;
    local array<int>        DamageHitPoint;
    local int               i;
    local Material          HitMaterial;

    if (Instigator == none || Weapon == none)
    {
        return;
    }

    GetAxes(Dir, X, Y, Z);

    // HitPointTraces don't really like very short traces, so we have to do a long trace first, then see if the player we hit was within range
    End = Start + (10000.0 * X);

    // Do precision hit point trace to see if we hit a player or something else
    Other = Instigator.HitPointTrace(HitLocation, HitNormal, End, HitPoints, Start,,, HitMaterial);

    // If we hit nothing or it was out of trace range, try tracing to the 4 extremes of our melee attack spread
    if (Other == none || VSizeSquared(Start - HitLocation) > GetTraceRangeSquared())
    {
        for (i = 0; i < 4; ++i)
        {
            switch (i)
            {
                // Lower left
                case 0:
                    TempVec = Start - (MeleeAttackSpread * Y) - (MeleeAttackSpread * Z);
                    break;
                // Upper right
                case 1:
                    TempVec = Start + (MeleeAttackSpread * Y) + (MeleeAttackSpread * Z);
                    break;
                // Upper left
                case 2:
                    TempVec = Start - (MeleeAttackSpread * Y) + (MeleeAttackSpread * Z);
                    break;
                // Lower right
                case 3:
                    TempVec = Start + (MeleeAttackSpread * Y) - (MeleeAttackSpread * Z);
                    break;
            }

            End = TempVec + (10000.0 * X);

            Other = Instigator.HitPointTrace(HitLocation, HitNormal, End, HitPoints, TempVec,,, HitMaterial);

            if (Other != none)
            {
                // Valid hit, within range
                if (VSizeSquared(Start - HitLocation) < GetTraceRangeSquared())
                {
                    break;
                }

                Other = none;
            }
        }
    }

    // Still hit nothing within trace range, so try a normal trace
    if (Other == none)
    {
        Other = Instigator.Trace(HitLocation, HitNormal, End, Start, true,, HitMaterial);

        if (Other != none && VSizeSquared(Start - HitLocation) > GetTraceRangeSquared())
        {
            Other = none; // out of trace range, invalid
        }
    }

    // Didn't hit anything valid so exit
    if (Other == none || Other == Instigator || Other.Base == Instigator)
    {
        return;
    }

    // Calculate damage if it's something we could hurt (no damage to world geometry unless it's a destroyable mesh)
    if (!Other.bWorldGeometry || Other.IsA('RODestroyableStaticMesh') || Other.IsA('DHConstruction'))
    {
        Scale = (FClamp(HoldTime, MinHoldTime, FullHeldTime) - MinHoldTime) / (FullHeldTime - MinHoldTime);

        if (Weapon.bBayonetMounted)
        {
            Damage = BayonetDamageMin + (Scale * (BayonetDamageMax - BayonetDamageMin));
            ThisDamageType = BayonetDamageType;
        }
        else
        {
            Damage = DamageMin + (Scale * (DamageMax - DamageMin));
            ThisDamageType = DamageType;
        }
    }

    HitPawn = ROPawn(Other);

    // Hit another player (note we don't make weapon attachment play hit effects, as blood effects etc get handled in ProcessLocationalDamage/TakeDamage)
    if (HitPawn != none)
    {
         if (!HitPawn.bDeleteMe)
         {
            // Calculate the rotational difference to determine if the instigator is behind the victim
            RotationDifference = Normalize(Other.Rotation) - Normalize(Instigator.Rotation);

            // If the victim is crawling or is being attacked from behind, apply larger damage factor
            if (HitPawn.bIsCrawling || Abs(RotationDifference.Yaw) <= RearAngleArc)
            {
                Damage *= VulnerableDamageFactor;
            }

            if (HitPoints.Length > 0)
            {
                DamageHitPoint[0] = HitPoints[HitPawn.GetHighestDamageHitIndex(HitPoints)];
            }
            else
            {
                DamageHitPoint[0] = 0;
            }

            // Apply hit point multiplier (this can reduce damage on areas such as limbs, hands, etc.)
            HitPawn.ProcessLocationalDamage(int(Damage), Instigator, HitLocation, MomentumTransfer * X, ThisDamageType, DamageHitPoint);

            if (Weapon.bBayonetMounted)
            {
                Weapon.PlaySound(PlayerStabSound, SLOT_None, FireVolume,, SOUND_RADIUS,, true);
            }
            else
            {
                Weapon.PlaySound(PlayerBashSound, SLOT_None, 1.0,, SOUND_RADIUS,, true);
            }
         }
    }
    // Hit something other than a player
    else
    {
        if (!Other.bWorldGeometry || Other.IsA('RODestroyableStaticMesh') || Other.IsA('DHConstruction')) // no damage to world geometry unless it's a destroyable mesh
        {
            Other.TakeDamage(int(Damage), Instigator, HitLocation, MomentumTransfer * X, ThisDamageType);
        }

        if (Weapon.bBayonetMounted)
        {
            Weapon.PlaySound(GetGroundStabSound(Other, HitMaterial), SLOT_None, FireVolume,, SOUND_RADIUS,, true);
        }
        else
        {
            Weapon.PlaySound(GetGroundBashSound(Other, HitMaterial), SLOT_None, FireVolume,, SOUND_RADIUS,, true);
        }
    }
}

function Sound GetGroundStabSound(Actor HitActor, Material HitMaterial)
{
    return default.GroundStabSound;
}

function Sound GetGroundBashSound(Actor HitActor, Material HitMaterial)
{
    return default.GroundBashSound;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  **************************  ALL REMAINING FUNCTIONS ARE RE-STATED FROM ROMELEEFIRE  *************************  //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Send the weapon to MeleeAttacking state instead of doing a regular fire
event ModeDoFire()
{
    if (AllowFire())
    {
        GotoState('MeleeAttacking');
    }
}

// This state handles the melee attack by doing the actual melee damage at the end of the strike animation, giving a more realistic feel
simulated state MeleeAttacking
{
    simulated function BeginState()
    {
        PlayFiring();
    }

    simulated function EndState()
    {
         PerformFire();

        if (Instigator != none)
        {
            if (Instigator.IsA('ROPawn'))
            {
                ROPawn(Instigator).SetMeleeHoldAnims(false);
            }

            if (Instigator.bIsSprinting && ROWeapon(Weapon) != none)
            {
                ROWeapon(Weapon).SetSprinting(true);
            }

            if (Instigator.IsLocallyControlled())
            {
                PlayFireEnd();
            }
        }
    }

    simulated function bool AllowFire()
    {
        return false;
    }

    simulated function Timer()
    {
        GotoState('');
    }

    simulated function PerformFire()
    {
        if (MaxHoldTime > 0.0)
        {
            HoldTime = FMin(HoldTime, MaxHoldTime);
        }

        if (Weapon != none)
        {
            if (Weapon.Role == ROLE_Authority)
            {
                Weapon.ConsumeAmmo(ThisModeNum, Load);
                DoFireEffect();
                HoldTime = 0.0; // if bot decides to stop firing, HoldTime must be reset first

                if (Instigator == none || Instigator.Controller == none)
                {
                    return;
                }

                if (Instigator.Controller.IsA('AIController'))
                {
                    AIController(Instigator.Controller).WeaponFireAgain(BotRefireRate, true);
                }

                Instigator.DeactivateSpawnProtection();
            }

            Weapon.IncrementFlashCount(ThisModeNum);
        }

        // Set the next firing time. must be careful here so client and server do not get out of sync
        if (bFireOnRelease)
        {
            if (bIsFiring)
            {
                NextFireTime += MaxHoldTime + FireRate;
            }
            else
            {
                NextFireTime = Level.TimeSeconds + FireRate;
            }
        }
        else
        {
            NextFireTime += FireRate;
            NextFireTime = FMax(NextFireTime, Level.TimeSeconds);
        }

        Load = AmmoPerFire;
        HoldTime = 0.0;

        if (Instigator != none && Instigator.PendingWeapon != Weapon && Instigator.PendingWeapon != none && Weapon != none)
        {
            bIsFiring = false;
            Weapon.PutDown();
        }
    }
}

function PlayPreFire()
{
    if (Weapon != none && Weapon.Mesh != none)
    {
        if (Weapon.bBayonetMounted && Weapon.HasAnim(BayoBackAnim))
        {
            if (Weapon.AmmoAmount(0) == 0 && Weapon.HasAnim(BayoBackEmptyAnim))
            {
                Weapon.PlayAnim(BayoBackEmptyAnim, 1.0, TweenTime);
            }
            else
            {
                Weapon.PlayAnim(BayoBackAnim, 1.0, TweenTime);
            }
        }
        else if (Weapon.AmmoAmount(0) < 1 && Weapon.HasAnim(BashBackEmptyAnim))
        {
            Weapon.PlayAnim(BashBackEmptyAnim, 1.0, TweenTime);
        }
        else if (Weapon.HasAnim(BashBackAnim))
        {
            Weapon.PlayAnim(BashBackAnim, 1.0, TweenTime);
        }
    }
}

function PlayFiring()
{
    local name Anim;

    if (Weapon != none && Weapon.Mesh != none)
    {
        if (Weapon.bBayonetMounted)
        {
            if (Weapon.AmmoAmount(0) == 0 && Weapon.HasAnim(BayoStabEmptyAnim))
            {
                Anim = BayoStabEmptyAnim;
            }
            else
            {
                Anim = BayoStabAnim;
            }
        }
        else if (Weapon.AmmoAmount(0) < 1 && Weapon.HasAnim(BashEmptyAnim))
        {
            Anim = BashEmptyAnim;
        }
        else
        {
            Anim = BashAnim;
        }

        if (Weapon.HasAnim(Anim))
        {
            SetTimer(Weapon.GetAnimDuration(Anim, 1.0) + TweenTime, false);

            if (Instigator != none && Instigator.IsLocallyControlled())
            {
                ShakeView();
                Weapon.PlayAnim(Anim, FireAnimRate, TweenTime);
                //Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)], SLOT_None, FireVolume,,,, false); // put this back in if/when we get a bash sound
                ClientPlayForceFeedback(FireForce);
            }
            else
            {
                //ServerPlayFiring(); // put this back in if/when we get a bash sound
            }
        }
    }
}

function DoFireEffect()
{
    local vector  StartTrace;
    local rotator Aim;

    if (Instigator != none)
    {
        Instigator.MakeNoise(1.0);

        StartTrace = Instigator.Location + Instigator.EyePosition(); // the to-hit trace starts right in front of player's eye
        Aim = AdjustAim(StartTrace, AimError);
        Aim = rotator(vector(Aim) + (VRand() * FRand() * Spread));
        DoTrace(StartTrace, Aim);
    }
}

function PlayFireEnd()
{
    local name Anim;

    if (Weapon != none && Weapon.Mesh != none)
    {
        if (Weapon.bBayonetMounted)
        {
            if (Weapon.AmmoAmount(0) == 0 && Weapon.HasAnim(BayoFinishEmptyAnim))
            {
                Anim = BayoFinishEmptyAnim;
            }
            else if (Weapon.HasAnim(BayoFinishAnim))
            {
                Anim = BayoFinishAnim;
            }
        }
        else
        {
            if (Weapon.AmmoAmount(0) == 0 && Weapon.HasAnim(BashFinishEmptyAnim))
            {
                Anim = BashFinishEmptyAnim;
            }
            else if (Weapon.HasAnim(BashFinishAnim))
            {
                Anim = BashFinishAnim;
            }
        }

        if (Anim != '')
        {
            Weapon.PlayAnim(Anim, FireEndAnimRate, TweenTime);
        }
    }
}

function float GetTraceRange()
{
    if (Weapon != none && Weapon.bBayonetMounted)
    {
        return BayonetTraceRange;
    }

    return TraceRange;
}

// Returns the trace range squared for cheaper comparisons
function float GetTraceRangeSquared()
{
    if (Weapon != none && Weapon.bBayonetMounted)
    {
        return BayonetTraceRange * BayonetTraceRange;
    }

    return TraceRange * TraceRange;
}

function float MaxRange()
{
    return TraceRange;
}

defaultproperties
{
    bMeleeMode=true
    bFireOnRelease=true
    AmmoPerFire=0

    FireRate=0.25
    MinHoldtime=0.1
    FullHeldTime=0.3
    TraceRange=85.0
    BayonetTraceRange=140.0
    MeleeAttackSpread=8.0
    RearAngleArc=16000.0

    DamageMin=30
    DamageMax=40
    BayonetDamageMin=75
    BayonetDamageMax=85
    VulnerableDamageFactor=3.0

    PlayerBashSound=SoundGroup'Inf_Weapons_Foley.melee.butt_hit'
    PlayerStabSound=SoundGroup'Inf_Weapons_Foley.melee.bayo_hit'
    GroundBashSound=SoundGroup'Inf_Weapons_Foley.melee.butt_hit_ground'
    GroundStabSound=SoundGroup'Inf_Weapons_Foley.melee.bayo_hit_ground'

    BashBackAnim="bash_pullback"
    BashHoldAnim="bash_hold"
    BashAnim="bash_attack"
    BashFinishAnim="bash_return"
    FireEndAnim=none
    FireLoopAnim=none

    // Bots
    BotRefireRate=0.25
    AimError=800.0
}
