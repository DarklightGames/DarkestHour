//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHHintManager extends Info
    config(User);

struct HintInfo
{
    var() localized string      Title;
    var() localized string      Text;  // actual hint text
    var int                     Index; // set in code, do not use!
};

const                           HINT_COUNT = 64;

// Config variables
var()   float                   PostHintDisplayDelay;     // how long to wait before displaying any other hint (value higher than 0 needed)

var()   HintInfo                Hints[HINT_COUNT];
var     config byte             bUsedUpHints[HINT_COUNT]; // 0 = hint unused, 1 = hint used before

var     int                     CurrentHintIndex;         // index in the SortedHints array
var     float                   LastHintDisplayTime;

var     array<byte>             QueuedHintIndices;

function PostBeginPlay()
{
    super.PostBeginPlay();

    LoadHints();
    SetTimer(1.0, true);
}

static function StaticReset()
{
    local int i;

    for (i = 0; i < HINT_COUNT; ++i)
    {
        default.bUsedUpHints[i] = 0;
    }

    StaticSaveConfig();
}

function NonStaticReset()
{
    local int i;

    for (i = 0; i < HINT_COUNT; ++i)
    {
        bUsedUpHints[i] = 0;
    }

    SaveConfig();
    Reload();
}

function LoadHints()
{
    QueuedHintIndices.Length = 0;
    QueueHint(0, true);
}

function Reload()
{
    StopHinting();
    LoadHints();
}

function QueueHint(byte HintIndex, bool bForceNext)
{
    local int i;

    if (bUsedUpHints[HintIndex] == 1)
    {
        return;
    }

    for (i = 0; i < QueuedHintIndices.Length; ++i)
    {
        if (QueuedHintIndices[i] == HintIndex)
        {
            return;
        }
    }

    if (bForceNext)
    {
        QueuedHintIndices.Insert(0, 1);
        QueuedHintIndices[0] = HintIndex;
    }
    else
    {
        QueuedHintIndices[QueuedHintIndices.Length] = HintIndex;
    }
}

function StopHinting()
{
    GotoState('');
    SetTimer(0.0, true);
}

// Emptied as implemented in WaitHintDone state
function NotifyHintRenderingDone();

simulated function Timer()
{
    if (QueuedHintIndices.Length > 0)
    {
        GotoState('WaitHintDone');
    }
}

state WaitHintDone
{
    function BeginState()
    {
        local DHPlayer player;

        player = DHPlayer(Owner);

        if (player != none && DHHud(player.myHud) != none && !DHHud(player.myHud).bHideHud)
        {
            CurrentHintIndex = QueuedHintIndices[0];
            DHHud(player.myHud).ShowHint(Hints[CurrentHintIndex].Title, Hints[CurrentHintIndex].Text);
        }
        else
        {
            SetTimer(1.0, true);
            GotoState('');
        }
    }

    function NotifyHintRenderingDone()
    {
        GotoState('PostDisplay');
    }
}

state PostDisplay
{
    function BeginState()
    {
        LastHintDisplayTime = Level.TimeSeconds;
        SetTimer(PostHintDisplayDelay, false);
    }

    function Timer()
    {
        bUsedUpHints[CurrentHintIndex] = 1;
        SaveConfig();
        QueuedHintIndices.Remove(0, 1);
        SetTimer(1.0, true);
        GotoState('');
    }
}

function exec DebugHints()
{
}

defaultproperties
{
    PostHintDisplayDelay=10.0
    Hints(0)=(Title="Welcome to Darkest Hour!",Text="These hint messages will show up periodically in the game. Pay attention to them, your survival might depend on it! They can be disabled from the HUD tab in the configuration menu.")
    Hints(1)=(Title="Mantling",Text="You are able to mantle on to small obstacles! To mantle, stand in front of any low obstacle until the mantling icon to appears then press %JUMP% to mantle on top of the obstacle.")
    Hints(2)=(Title="Parachutes",Text="You can guide your parachute's trajectory with your movement keys!")
    Hints(3)=(Title="Coloured Smoke Grenades",Text="Coloured smoke grenades are used to communicate on the battlefield with your teammates. Be sure to tell your teammates what the coloured smoke indicates.")
    Hints(6)=(Title="Mortars",Text="While you are holding a mortar you cannot change weapons, sprint, prone or mantle. To deploy your mortar, crouch on flat ground and press %DEPLOY%.")
    Hints(7)=(Title="Mortar Operation",Text="To adjust the traverse of your mortar, hold the A or D keys. To increase the elevation, press the S key. To decrease the elevation, press the W key. To select the next round type, press the %SwitchFireMode% key. To fire a round, press the %Fire% key.")
    Hints(8)=(Title="Mortar Targets",Text="A mortar observer can mark targets that become visible on your map. When a round lands near a target marker, the location of the impact will be marked your map. Use these markers to zero in on your target.")
    Hints(9)=(Title="Mortar Leaving",Text="You may leave your mortar at any time by pressing the %Use% key. While you are off your mortar, you can retrieve ammunition at a resupply area or from your teammates.")
    Hints(10)=(Title="Mortar Undeploy",Text="To undeploy your mortar, press the %Deploy% key. Undeploying your mortar will reset your elevation and traverse settings.")
    Hints(11)=(Title="Mortar Targeting",Text="You can mark targets for your team's mortar operators while sighted with your binoculars. Pressing %FIRE% to mark a high-explosive target or press %ALTFIRE% to request a smoke target.")
    Hints(12)=(Title="Artillery Officer",Text="You are an artillery officer. You can mark artillery targets with binoculars. Call in long-range artillery with from a radio position or with the help of a radio operator.")
    Hints(13)=(Title="Radio Operator",Text="You are a radio operator! Stay close to your artillery officer so he can call in artillery strikes!")
    Hints(14)=(Title="Deployment Vehicle",Text="You are driving a deployment vehicle! When not in an objective and with no enemies nearby, your team can use it as a spawn point!")
    Hints(16)=(Title="Deployment Vehicle",Text="Deployment vehicles can be critical in the outcome of any battle! Treat them with care! If you need to leave the vehicle, be sure to leave it in a safe area!")
    Hints(20)=(Title="M1 Garand",Text="Firing the last round of an en bloc clip makes a distinctive audible ping indicating that your rifle is out of ammunition. Be careful, the enemy may take advantage of this.")
    Hints(21)=(Title="Lee Enfield No.4",Text="The Lee Enfield No.4 can load two 5-rd stripper clips. After you have fired 5 rounds, you may reload the rifle with one clip. If you fire all your rounds, you will reload with two clips.")
    Hints(22)=(Title="Gewehr 41",Text="The Gewehr 41 can load two 5-rd stripper clips. After you have fired 5 rounds, you may reload the rifle with one clip. If you fire all your rounds, you will reload with two clips.")
    Hints(40)=(Title="Vehicle Engines",Text="You have entered a vehicle. To start or stop the engine, press %FIRE%.")
    Hints(42)=(Title="Higgins Boat",Text="You are driving a Higgins boat. Lower the bow ramp by pressing %PREVWEAPON% so passengers and yourself can exit. To raise the bow ramp hit %NEXTWEAPON%.")
    Hints(43)=(Title="Resupply Trucks",Text="You are close to a resupply truck. Stand outside the back of the truck to resupply your ammunition.")
    Hints(44)=(Title="Resupply Trucks",Text="You are driving a resupply truck. This vehicle can resupply vehicles, mortars and infantry. Be sure to park it in a safe place.")
}
