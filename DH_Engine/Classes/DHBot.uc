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
        if (Pawn.Weapon != none &&  DHProjectileWeapon(Pawn.Weapon) != none)
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

defaultproperties
{
    PlayerReplicationInfoClass=class'DH_Engine.DHPlayerReplicationInfo'
    PawnClass=class'DH_Engine.DHPawn'
}
