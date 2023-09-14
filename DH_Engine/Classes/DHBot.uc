//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBot extends ROBot;

// Modified to avoid "accessed none" log spam errors on Weapon
function ChooseAttackMode()
{
    local float EnemyStrength, RetreatThreshold, WeaponRating;

    GoalString = " ChooseAttackMode last seen" @ Level.TimeSeconds - LastSeenTime;

    // Should I run away?
    if (Squad == none || Enemy == none || Pawn == none)
    {
        Log("HERE 1 Squad" @ Squad @ "Enemy" @ Enemy @ "Pawn" @ Pawn);
    }

    EnemyStrength = RelativeStrength(Enemy);

    if (Vehicle(Pawn) != none)
    {
        VehicleFightEnemy(true, EnemyStrength);

        return;
    }

    if (!bFrustrated && !Squad.MustKeepEnemy(Enemy))
    {
        RetreatThreshold = Aggressiveness;

        if (Pawn != none && Pawn.Weapon != none && Pawn.Weapon.CurrentRating > 0.5)
        {
            RetreatThreshold = RetreatThreshold + 0.35 - (Skill * 0.05);
        }

        if (EnemyStrength > RetreatThreshold)
        {
            GoalString = "Retreat";

            if (PlayerReplicationInfo != none && PlayerReplicationInfo.Team != none && FRand() < 0.05)
            {
                SendMessage(none, 'Other', GetMessageIndex('INJURED'), 15, 'TEAM');
            }

            DoRetreat();

            return;
        }
    }

    if (Squad != none && Squad.PriorityObjective(self) == 0 && (Skill + Tactics) > 2.0 && (EnemyStrength > -0.3 || (Pawn != none && Pawn.Weapon != none && Pawn.Weapon.AIRating < 0.5)))
    {
        if (Pawn == none || Pawn.Weapon == none)
        {
            WeaponRating = 0.0;
        }
        else if (Pawn.Weapon.AIRating < 0.5)
        {
            if (EnemyStrength > 0.3)
            {
                WeaponRating = 0.0;
            }
            else
            {
                WeaponRating = Pawn.Weapon.CurrentRating / 2000.0;
            }
        }
        else if (EnemyStrength > 0.3)
        {
            WeaponRating = Pawn.Weapon.CurrentRating / 2000.0;
        }
        else
        {
            WeaponRating = Pawn.Weapon.CurrentRating / 1000.0;
        }

        // Fall back to better pickup?
        if (FindInventoryGoal(WeaponRating))
        {
            if (InventorySpot(RouteGoal) == none)
            {
                GoalString = "fallback - inventory goal is not pickup but" @ RouteGoal;
            }
            else
            {
                GoalString = "Fallback to better pickup" @ InventorySpot(RouteGoal).MarkedItem @ "hidden" @ InventorySpot(RouteGoal).MarkedItem.bHidden;
            }

            GotoState('FallBack');

            return;
        }
    }

    GoalString = "ChooseAttackMode FightEnemy";
    FightEnemy(true, EnemyStrength);
}

state RangedAttack
{
ignores HearNoise, Bump;

    // Modified to fix logic flaw in the Super when making a bot switch to an empty vehicle weapon MG to engage enemy
    // Problem was it always called KDriverLeave() on the vehicle base, even if the bot was in another vehicle weapon position
    // Also removed requirement for bot's vehicle to be an APC to allow him to switch to an MG to engage enemy infantry (type of vehicle is irrelevant)
    // And now calling a switch function instead of KDriverLeave & KDriverEnter, to work properly with DH's modified vehicle switching system
    function BeginState()
    {
        local VehicleWeaponPawn CurrentWP, WP;
        local ROVehicle         V;
        local int               i;

        StopStartTime = Level.TimeSeconds;
        bHasFired = false;

        if (Pawn != none && (Pawn.Physics != PHYS_Flying || Pawn.MinFlySpeed == 0.0))
        {
            Pawn.Acceleration = vect(0.0, 0.0, 0.0); // stop
        }

        if (Pawn != none && Pawn.Weapon != none && Pawn.Weapon.FocusOnLeader(false))
        {
            Target = Focus;
        }
        else if (Target == none)
        {
            Target = Enemy;
        }

        if (Target == none)
        {
            Log(GetHumanReadableName() @ "no target in ranged attack");
        }

        // Check whether bot should try to move to empty vehicle weapon position to engage enemy - either a cannon or an MG if target is infantry
        V = ROVehicle(Pawn);

        if (V == none)
        {
            CurrentWP = VehicleWeaponPawn(Pawn);

            // If bot is already in a vehicle weapon position, only consider switching if current position isn't a suitable weapon
            if (CurrentWP != none && !CurrentWP.IsA('DHVehicleCannonPawn') && !(CurrentWP.IsA('DHVehicleMGPawn') && DHPawn(Target) != none))
            {
                V = CurrentWP.VehicleBase;
            }
        }

        // Bot isn't in a suitable weapon position, so check whether there is a suitable weapon that's empty
        if (V != none)
        {
            for (i = 0; i < V.WeaponPawns.Length; ++i)
            {
                WP = V.WeaponPawns[i];

                // Removed requirement for bot's vehicle to be an APC to be able to use an MG, as MG will be effective against infantry regardless of vehicle it's mounted on
                if (WP != none && WP.Driver == none && (WP.IsA('DHVehicleCannonPawn') || (WP.IsA('DHVehicleMGPawn') && DHPawn(Target) != none/* && V.bIsApc*/)))
                {
                    // Fixed to call this on bot's current vehicle pawn (not always the vehicle base)
                    // And also now calling a switch function instead of KDriverLeave & KDriverEnter, to work properly with DH's modified vehicle switching system
                    if (CurrentWP != none)
                    {
                        CurrentWP.ServerChangeDriverPosition(i + 2); // +2 because function accepts 1 as driver, 2 as WeaponPawns[0], etc
                    }
                    else
                    {
                        V.ServerChangeDriverPosition(i + 2);
                    }

                    if (!V.IsHumanControlled()) // make the vehicle stop unless it has a human driver (moved this down here & added the human check)
                    {
                        V.Steering = 0.0;
                        V.Throttle = 0.0;
                        V.Rise = 0.0;
                    }

                    break;
                }
            }
        }

        // Cause bots to use their ironsights when they do this
        if (Pawn != none && DHProjectileWeapon(Pawn.Weapon) != none)
        {
            DHProjectileWeapon(Pawn.Weapon).ZoomIn(false);
        }
    }

    // Modified to call a switch function instead of KDriverLeave & KDriverEnter, to work properly with DH's modified vehicle switching system
    function EndState()
    {
        local VehicleWeaponPawn WP;

        WP = VehicleWeaponPawn(Pawn);

        if (WP != none && WP.VehicleBase != none && WP.VehicleBase.Driver == none)
        {
            WP.ServerChangeDriverPosition(1);
        }
    }
}

// Modified to avoid calling the Super in XBot, as that duplicates the call the pawn's Setup()
function Possess(Pawn aPawn)
{
    super(Bot).Possess(aPawn);

    if (ROPawn(aPawn) != none)
    {
        ROPawn(aPawn).Setup(PawnSetupRecord);
    }
}

// Overridden to allow for setting the correct DH-specific pawn class
function SetPawnClass(string inClass, string inCharacter)
{
    local class<DHPawn> pClass;

    pClass = class<DHPawn>(DynamicLoadObject(inClass, class'class'));

    if (pClass != none)
    {
        PawnClass = pClass;
    }

    PawnSetupRecord = class'xUtil'.static.FindPlayerRecord(inCharacter);
    PlayerReplicationInfo.SetCharacterName(PawnSetupRecord.DefaultName);
}

// Modified to remove setting vehicle's bDisableThrottle, now deprecated
state WaitForCrew
{
    function BeginState()
    {
        CachedMoveTimer = MoveTimer;
    }

Begin:
    Sleep(0.2);

    if ((ROWheeledVehicle(Pawn) != none && ROWheeledVehicle(Pawn).CheckForCrew()) || (ROSquadAI(Squad) != none && !ROSquadAI(Squad).ShouldWaitForCrew(self)))
    {
        MoveTimer = CachedMoveTimer;
        WhatToDoNext(53); // go back to the function that got us here
    }

    GoTo('Begin');
}

// Modified to avoid "accessed none" errors on Pawn.Weapon
function FightEnemy(bool bCanCharge, float EnemyStrength)
{
    local float  EnemyDistance, AdjustedCombatStyle;
    local bool   bOldForcedCharge, bFarAway;
    local vector X, Y, Z;

    if (Squad == none || Enemy == none || Pawn == none)
    {
        Log("HERE 3 Squad" @ Squad @ "Enemy" @ Enemy @ "Pawn" @ Pawn);
    }

    if (Vehicle(Pawn) != none)
    {
        VehicleFightEnemy(bCanCharge, EnemyStrength);

        return;
    }

    if (Enemy == FailedHuntEnemy && Level.TimeSeconds == FailedHuntTime)
    {
        GoalString = "FAILED HUNT - HANG OUT";

        if (EnemyVisible())
        {
            bCanCharge = false;
        }
        else if (FindInventoryGoal(0.0))
        {
            SetAttractionState();

            return;
        }
        else
        {
            WanderOrCamp(true);

            return;
        }
    }

    bOldForcedCharge = bMustCharge;
    bMustCharge = false;
    EnemyDistance = VSize(Pawn.Location - Enemy.Location);

    if (Pawn.Weapon != none)
    {
        AdjustedCombatStyle = CombatStyle + Pawn.Weapon.SuggestAttackStyle();
    }

    Aggression = (1.5 * FRand()) - 0.8 + (2.0 * AdjustedCombatStyle) - (0.5 * EnemyStrength) + (FRand() * (Normal(Enemy.Velocity - Pawn.Velocity) dot Normal(Enemy.Location - Pawn.Location)));

    if (Enemy.Weapon != none)
    {
        Aggression += 2.0 * Enemy.Weapon.SuggestDefenseStyle();
    }

    if (EnemyDistance > MAXSTAKEOUTDIST)
    {
        Aggression += 0.5;
    }

    if (Pawn.Physics == PHYS_Walking || Pawn.Physics == PHYS_Falling)
    {
        if (Pawn.Location.Z > Enemy.Location.Z + TACTICALHEIGHTADVANTAGE)
        {
            Aggression = FMax(0.0, Aggression - 1.0 + AdjustedCombatStyle);
        }
        else if (Skill < 4.0 && EnemyDistance > (0.65 * MAXSTAKEOUTDIST))
        {
            bFarAway = true;
            Aggression += 0.5;
        }
        else if (Pawn.Location.Z < Enemy.Location.Z - Pawn.CollisionHeight) // below enemy
        {
            Aggression += CombatStyle;
        }
    }

    if (!EnemyVisible())
    {
        if (Squad.MustKeepEnemy(Enemy))
        {
            GoalString = "Hunt priority enemy";
            GotoState('Hunting');

            return;
        }

        GoalString = "Enemy not visible";

        if (!bCanCharge)
        {
            GoalString = "Stake Out - no charge";
            DoStakeOut();
        }
        else if (Squad.IsDefending(self) && LostContact(4.0) && ClearShot(LastSeenPos, false))
        {
            GoalString = "Stake Out " $ LastSeenPos;
            DoStakeOut();
        }
        else if (((Aggression < 1.0 && !LostContact(3.0 + (2.0 * FRand()))) || IsSniping()) && CanStakeOut())
        {
            GoalString = "Stake Out2";
            DoStakeOut();
        }
        else
        {
            GoalString = "Hunt";
            GotoState('Hunting');
        }

        return;
    }

    // See enemy - decide whether to charge it or strafe around/stand & fire
    BlockedPath = none;
    Target = Enemy;

    if ((Pawn.Weapon != none && Pawn.Weapon.bMeleeWeapon) || (bCanCharge && bOldForcedCharge))
    {
        GoalString = "Charge";
        DoCharge();

        return;
    }

    if (Pawn.RecommendLongRangedAttack())
    {
        GoalString = "Long Ranged Attack";
        DoRangedAttackOn(Enemy);

        return;
    }

    if (bCanCharge && Skill < 5.0 && bFarAway && Aggression > 1.0 && FRand() < 0.5)
    {
        GoalString = "Charge closer";
        DoCharge();

        return;
    }

    if ((Pawn.Weapon != none && Pawn.Weapon.RecommendRangedAttack()) || IsSniping() || ((FRand() > 0.17 * (Skill + Tactics - 1.0)) && !DefendMelee(EnemyDistance)))
    {
        GoalString = "Ranged Attack";
        DoRangedAttackOn(Enemy);

        return;
    }

    if (bCanCharge && Aggression > 1.0)
    {
        GoalString = "Charge 2";
        DoCharge();

        return;
    }

    GoalString = "Do tactical move";

    if (Pawn.Weapon != none && !Pawn.Weapon.RecommendSplashDamage() && FRand() < 0.7 && ((3.0 * Jumpiness) + (FRand() * Skill)) > 3.0)
    {
        GetAxes(Pawn.Rotation, X, Y, Z);
        GoalString = "Try to Duck ";

        if (FRand() < 0.5)
        {
            Y *= -1.0;
            TryToDuck(Y, true);
        }
        else
        {
            TryToDuck(Y, false);
        }
    }

    DoTacticalMove();
}

// Modified to use DHVehicleCannonPawn instead of deprecated ROTankCannonPawn
function SetAttractionState()
{
    local ROVehicle V;
    local int       i;

    if (Enemy != none)
    {
        V = ROVehicle(Pawn);

        if (V != none)
        {
            for (i = 0; i < V.WeaponPawns.Length; ++i)
            {
                if (DHVehicleCannonPawn(V.WeaponPawns[i]) != none && V.WeaponPawns[i].Driver == none)
                {
                    ChooseAttackMode();

                    return;
                }
            }
        }

        GotoState('FallBack');
    }
    else
    {
        GotoState('Roaming');
    }
}
// Modified so entering a shallow water volume doesn't send bot into swimming state (also stripped out some redundancy)
function bool NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
{
    local vector JumpDir;

    if (Pawn == none || Pawn.IsA('Vehicle'))
    {
        return false;
    }

    if (NewVolume != none && NewVolume.bWaterVolume && !(NewVolume.IsA('DHWaterVolume') && DHWaterVolume(NewVolume).bIsShallowWater))
    {
        bPlannedJump = false;

        if (Pawn.Physics != PHYS_Swimming)
        {
            Pawn.SetPhysics(PHYS_Swimming);
        }
    }
    else if (Pawn.Physics == PHYS_Swimming)
    {
        Pawn.SetPhysics(PHYS_Falling);

        if (Destination.Z >= Pawn.Location.Z && (Abs(Pawn.Acceleration.X) + Abs(Pawn.Acceleration.Y)) > 0.0 && Pawn.CheckWaterJump(JumpDir))
        {
            Pawn.JumpOutOfWater(JumpDir);
            bNotifyApex = true;
            bPendingDoubleJump = true;
        }
    }

    return false;
}

defaultproperties
{
    PlayerReplicationInfoClass=class'DH_Engine.DHPlayerReplicationInfo'
    PawnClass=class'DH_Engine.DHPawn'
}
