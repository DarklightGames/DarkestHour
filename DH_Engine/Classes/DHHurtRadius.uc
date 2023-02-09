//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHHurtRadius extends Actor
    notplaceable;

var float DamageTimerRate;
var int DamageAmount;
var float DamageRadius;
var class<DamageType> DamageType;

function Timer()
{
    if (DamageType == none)
    {
        return;
    }

    HurtRadius(DamageAmount, DamageRadius, DamageType, 0, Location);
}

function SetDamageTimerRate(int DamageTimerRate)
{
    SetTimer(DamageTimerRate, true);
}

defaultproperties
{
    RemoteRole=ROLE_None
    bHidden=true
    DamageTimerRate=2.0
    DamageRadius=1024.0
}

