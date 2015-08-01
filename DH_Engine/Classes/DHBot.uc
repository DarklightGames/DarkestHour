//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHBot extends ROBot;

// Overridden to force bots out rather than being trapped by our "must be unbuttoned" requirement
function GetOutOfVehicle()
{
    if (Vehicle(Pawn) == none)
    {
        return;
    }

    Vehicle(Pawn).PlayerStartTime = Level.TimeSeconds + 20;
    Vehicle(Pawn).KDriverLeave(true);
}

// MOdified to avoid "accessed none" log spam errors on Weapon
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

// Added code to get bots using ironsights in a rudimentary fashion
state RangedAttack
{
    ignores HearNoise, Bump;

    function NotifyIneffectiveAttack(optional Pawn Other)
    {
        if (VehicleWeaponPawn(Pawn) != none &&
            VehicleWeaponPawn(Pawn).VehicleBase != none &&
            VehicleWeaponPawn(Pawn).VehicleBase.Controller != none)
        {
            DHBot(VehicleWeaponPawn(Pawn).VehicleBase.Controller).NotifyIneffectiveAttack(Other);
            return;
        }

        Target = Enemy;
        GoalString = "Position Myself";

        GotoState('TacticalVehicleMove');
    }

    function BeginState()
    {
       local byte i;
       local ROVehicle V;
       local Pawn P;

        StopStartTime = Level.TimeSeconds;
        bHasFired = false;

        if (Pawn.Physics != PHYS_Flying || Pawn.MinFlySpeed == 0)
        {
            Pawn.Acceleration = vect(0.0, 0.0, 0.0); //stop
        }

        if (Pawn.Weapon != none && Pawn.Weapon.FocusOnLeader(false))
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

        if (ROVehicle(Pawn) != none)
        {
            Vehicle(Pawn).Steering = 0;
            Vehicle(Pawn).Throttle = 0;
            Vehicle(Pawn).Rise = 0;

            V = ROVehicle(Pawn);
            P = V.Driver;
        }
        else if (ROVehicleWeaponPawn(Pawn) != none)
        {
            V = ROVehicleWeaponPawn(Pawn).VehicleBase;
            P = ROVehicleWeaponPawn(Pawn).Driver;
        }

        if (V != none)
        {
            for (i = 0; i < V.WeaponPawns.Length; ++i)
            {
                if (V.WeaponPawns[i] == none)
                {
                    break;
                }

                if (ROVehicleWeaponPawn(V.WeaponPawns[i]).Driver == none)
                {
                    if (V.WeaponPawns[i].IsA('ROTankCannonPawn'))
                    {
                        V.KDriverLeave(true);
                        V.WeaponPawns[i].KDriverEnter(P);

                        break;
                    }

                    if (DHPawn(Enemy) != none && V.bIsApc && ROVehicleWeaponPawn(V.WeaponPawns[i]).bIsMountedTankMG)
                    {
                        V.KDriverLeave(true);
                        V.WeaponPawns[i].KDriverEnter(P);

                        break;
                    }
                }
            }
        }

        // Cause bots to use their ironsights when they do this
        if (Pawn.Weapon != none && DHProjectileWeapon(Pawn.Weapon) != none)
        {
            DHProjectileWeapon(Pawn.Weapon).ZoomIn(false);
        }
    }
}

function Possess(Pawn aPawn)
{
    super.Possess(aPawn);

    if (DHPawn(aPawn) != none)
    {
        DHPawn(aPawn).Setup(PawnSetupRecord);
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
    if (ROWheeledVehicle(Pawn).CheckForCrew() || !ROSquadAI(Squad).ShouldWaitForCrew(self))
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
        log("HERE 3 Squad" @ Squad @ "Enemy" @ Enemy @ "Pawn" @ Pawn);
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
            GoalString = "Stake Out "$LastSeenPos;
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

defaultproperties
{
    PlayerReplicationInfoClass=class'DH_Engine.DHPlayerReplicationInfo'
    PawnClass=class'DH_Engine.DHPawn'
}
