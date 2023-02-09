//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHHintManager extends Info
    config(User);

struct HintInfo
{
    var localized string    Title; // hint title, displayed on screen
    var localized string    Text;  // hint display text
};

const                   HINT_COUNT = 64;

var     HintInfo        Hints[HINT_COUNT];        // array of hints in default properties
var     array<byte>     QueuedHintIndices;        // queue of hints waiting to be displayed in turn
var     config byte     bUsedUpHints[HINT_COUNT]; // 0 = hint unused, 1 = hint used before (saved in player's local DarkestHouseUser.ini config file)
var     int             CurrentHintIndex;         // index number of the current or most recently displayed hint
var     float           PostHintDisplayDelay;     // how long to wait before displaying any other hint (value higher than 0 needed)

function PostBeginPlay()
{
    super.PostBeginPlay();

    StartCheckingForHints();
}

// Clears any hint queue and starts a repeating hint check timer
function StartCheckingForHints()
{
    QueuedHintIndices.Length = 0;
    QueueHint(0, true); // toss in the initial "welcome to DH" hint, in case that hasn't been shown (ignored if has been)
    SetTimer(1.0, true);
}

// Non-state repeating hint check timer goes to DisplayingHint state if it finds any queued hint(s)
simulated function Timer()
{
    if (QueuedHintIndices.Length > 0)
    {
        GotoState('DisplayingHint');
    }
}

// State while HUD is actively displaying a hint (the one at the front of the queue - index 0)
state DisplayingHint
{
    function BeginState()
    {
        local DHPlayer Player;

        Player = DHPlayer(Owner);

        // Make the HUD display the hint at the front of the queue
        if (Player != none && DHHud(Player.myHud) != none && !DHHud(Player.myHud).bHideHud)
        {
            CurrentHintIndex = QueuedHintIndices[0];
            DHHud(Player.myHud).ShowHint(Hints[CurrentHintIndex].Title, Hints[CurrentHintIndex].Text);
        }
        // But exit & resume repeating hint check timer if player doesn't have an active HUD
        else
        {
            SetTimer(1.0, true);
            GotoState('');
        }
    }

    // Receives notification from HUD that hint has finished displaying, so now we go to PostDisplay state
    function NotifyHintRenderingDone()
    {
        GotoState('PostDisplay');
    }
}

// State for a set period after a hint has finished displaying
state PostDisplay
{
    // Set a timer to exit this state after a set period
    function BeginState()
    {
        SetTimer(PostHintDisplayDelay, false);
    }

    // Delete the recently displayed hint, mark it as used, exit state & resume the repeating hint check timer
    function Timer()
    {
        bUsedUpHints[CurrentHintIndex] = 1;
        SaveConfig();
        QueuedHintIndices.Remove(0, 1);
        SetTimer(1.0, true);
        GotoState('');
    }
}

// Tries to add a new hint to the hint queue (valid if not previously used/displayed & same hint not already in the queue)
function QueueHint(byte HintIndex, bool bForceNext)
{
    local int i;

    if (bUsedUpHints[HintIndex] == 1) // exit as we're trying to display a hint that's already been used/shown
    {
        return;
    }

    for (i = 0; i < QueuedHintIndices.Length; ++i)
    {
        if (QueuedHintIndices[i] == HintIndex) // exit as we've found our new hint is already in the queue
        {
            return;
        }
    }

    // bForceNext means our new hint needs to go to the front of the queue
    if (bForceNext)
    {
        // If already displaying a hint, or in the PostHintDisplayDelay period immediately after, then insert our new hint as next one due after current/recent hint (index 1)
        if (IsInState('DisplayingHint') || IsInState('PostDisplay'))
        {
            QueuedHintIndices.Insert(1, 1);
            QueuedHintIndices[1] = HintIndex;
        }
        // Otherwise insert our new hint at the front of the queue (index 0)
        else
        {
            QueuedHintIndices.Insert(0, 1);
            QueuedHintIndices[0] = HintIndex;
        }
    }
    // Otherwise add new hint at the back of the queue
    else
    {
        QueuedHintIndices[QueuedHintIndices.Length] = HintIndex;
    }
}

// Resets previously used/shown hints, so they will be displayed again (called from menu, not in game)
static function StaticReset()
{
    local int i;

    for (i = 0; i < HINT_COUNT; ++i)
    {
        default.bUsedUpHints[i] = 0;
    }

    StaticSaveConfig();
}

// Resets previously used/shown hints, so they will be displayed again, then starts again (called from in game)
function NonStaticReset()
{
    local int i;

    for (i = 0; i < HINT_COUNT; ++i)
    {
        bUsedUpHints[i] = 0;
    }

    SaveConfig();

    GotoState('');
    SetTimer(0.0, false); // clear any timer
    StartCheckingForHints();
}

// Empty as implemented only in DisplayingHint state
function NotifyHintRenderingDone()
{
}

// Just used in other classes (DHPlayer) to get a member of the Hints array, avoiding "context expression: variable is too large" compiler errors
function HintInfo GetHint(int Index)
{
    return Hints[Index];
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
    Hints(8)=(Title="Artillery Targets",Text="Squad leaders can mark targets that become visible on your map. When a round lands near a target marker, the location of the impact will be marked your map. Use these markers to zero in on your target.")
    Hints(9)=(Title="Mortar Leaving",Text="You may leave your mortar at any time by pressing the %Use% key. While you are off your mortar, you can retrieve ammunition at a resupply area or from your teammates.")
    Hints(10)=(Title="Mortar Undeploy",Text="To undeploy your mortar, press the %Deploy% key. Undeploying your mortar will reset your elevation and traverse settings.")
    Hints(12)=(Title="Binoculars",Text="You can mark targets for fire support with your binoculars. Bring up your binoculars with %ROIRONSIGHTS%, then press and hold %FIRE% to bring up the fire support menu.")
    Hints(13)=(Title="Radio Operator",Text="You are a radio operator! Stay close to squad leaders so they can call in long-range fire support!")

    Hints(40)=(Title="Vehicle Engines",Text="You have entered a vehicle. To start or stop the engine, press %FIRE%.")
    Hints(42)=(Title="Higgins Boat",Text="You are driving a Higgins boat. Lower the bow ramp by pressing %PREVWEAPON% so passengers and yourself can exit. To raise the bow ramp hit %NEXTWEAPON%.")
    Hints(43)=(Title="Resupply Trucks",Text="You are close to a resupply truck. Stand outside the back of the truck to resupply your ammunition.")
    Hints(44)=(Title="Resupply Trucks",Text="You are driving a resupply truck. This vehicle can resupply vehicles, mortars and infantry. Be sure to park it in a safe place.")
    Hints(46)=(Title="Externally Mounted MG",Text="This machine gun is externally mounted and can only be fired or reloaded if you unbutton the hatch")
    Hints(47)=(Title="Remote Controlled MG",Text="This machine gun can only be fired from inside the vehicle, but it is externally mounted and you must unbutton the hatch to reload")
    Hints(48)=(Title="Externally Mounted MG Reload",Text="You need to unbutton the hatch (& not be using binoculars) to reload this externally mounted machine gun")

    Hints(49)=(Title="Spotting Scope",Text="You are operating an artillery piece equipped with a spotting scope. Press %NEXTWEAPON% to look through the spotting scope.")
    Hints(50)=(Title="Artillery Operators",Text="Open map to coordinate fire. Use RMB on a fire support request to select it as the active target or use the Ruler marker to measure distances from you to a given spot on the map.")
    Hints(51)=(Title="Map Interaction",Text="You can interact with the map by pressing %JUMP%.")
    Hints(52)=(Title="Map Navigation",Text="To zoom the map, hover the cursor over the map and use the scroll wheel. To pan the map, press and hold [LEFTMOUSE] then move the cursor.")
    Hints(53)=(Title="Map Markers",Text="To add and interact with markers on the map, hover the cursor over the area or object of interest and press [RIGHTMOUSE] to bring up the context menu.")
    Hints(54)=(Title="Find a Radio",Text="You have marked a target for long-range fire support. Find a radio so that you can call it in!")

    Hints(60)=(Title="Firing Range",Text="This weapon has an adjustable sight! Press %SWITCHFIREMODE% to change the range of the sight.")
}

