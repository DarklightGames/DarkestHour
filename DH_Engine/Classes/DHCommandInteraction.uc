//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHCommandInteraction extends DHInteraction;

const FADE_DURATION = 0.25;
const INNER_RADIUS = 16.0;
const OUTER_RADIUS = 32.0;
const Tau = 6.28318530718;

var Stack_Object        Menus;

var float               MenuAlpha;
var vector              Cursor;
var int                 SelectedIndex;

// Colin: This is necessary because trying to DrawTile on idential TexRotators
// and other procedural materials in the same frame ends up only drawing one
// of them.
var TexRotator          MaterialQuarters[4];

event Initialized()
{
    super.Initialized();

    Menus = new class'Stack_Object';

    GotoState('FadeIn');
}

function Hide()
{
    GotoState('FadeOut');
}

function DHCommandMenu PushMenu(string ClassName)
{
    local DHCommandMenu Menu;
    local class<DHCommandMenu> MenuClass;

    MenuClass = class<DHCommandMenu>(DynamicLoadObject(ClassName, class'class'));

    Menu = new MenuClass;

    if (Menu == none)
    {
        Warn("Failed to load menu class" @ ClassName);

        return none;
    }

    Menus.Push(Menu);

    return Menu;
}

function PopMenu()
{
    Menus.Pop();
}

auto state FadeIn
{
    function Tick(float DeltaTime)
    {
        global.Tick(DeltaTime);

        MenuAlpha = FMin(1.0, MenuAlpha + (DeltaTime / FADE_DURATION));

        if (MenuAlpha == 1.0)
        {
            GotoState('Active');
        }
    }

    event BeginState()
    {
        MenuAlpha = 0.0;
    }
}

state Active
{
    event BeginState()
    {
        MenuAlpha = 1.0;
    }
}

state FadeOut
{
    function Tick(float DeltaTime)
    {
        super.Tick(DeltaTime);

        MenuAlpha = FMax(0.0, MenuAlpha - (DeltaTime / FADE_DURATION));

        if (MenuAlpha == 0.0)
        {
            ViewportOwner.InteractionMaster.RemoveInteraction(self);
        }
    }

    function bool KeyEvent(out EInputKey Key, out EInputAction Action, float Delta)
    {
        return false;
    }
}

function Tick(float DeltaTime)
{
    local float ArcLength, Theta;
    local DHCommandMenu Menu;
    local DHPlayer PC;

    PC = DHPlayer(ViewportOwner.Actor);

    if (PC == none || PC.Pawn == none || PC.IsDead())
    {
        Hide();
        return;
    }

    Menu = DHCommandMenu(Menus.Peek());

    // Clamp cursor
    Cursor = class'UCore'.static.VClampSize(Cursor, 0.0, OUTER_RADIUS);

    if (Menu != none &&
        Menu.Options.Length > 0 &&
        Cursor != vect(0, 0, 0))
    {
        // TODO: extract this to a function to be reused, may be useful in
        // other areas.

        // Calculated the selected index
        ArcLength = Tau / Menu.Options.Length;
        Theta = Atan(Cursor.Y, Cursor.X) + (ArcLength / 2);
        Theta += class'UUnits'.static.DegreesToRadians(90);

        if (Theta < 0)
        {
            Theta = Tau + Theta;
        }

        if (VSize(Cursor) < INNER_RADIUS)
        {
            // No selection
            SelectedIndex = -1;
        }
        else
        {
            SelectedIndex = (Menu.Options.Length * (Theta / Tau));
        }
    }
    else
    {
        SelectedIndex = -1;
    }
}

function PostRender(Canvas C)
{
    local int i;
    local float Theta, ArcLength;
    local float CenterX, CenterY, X, Y, XL, YL, U, V;
    local DHCommandMenu Menu;

    if (C == none)
    {
        return;
    }

    CenterX = (C.ClipX / 2);
    CenterY = (C.ClipY / 2);

    // TODO: get rid of magic numbers
    C.SetPos(CenterX - 8, CenterY - 8);

    // TODO: draw tiny crosshair
    C.DrawColor = class'UColor'.default.White;
    C.DrawTile(material'DH_InterfaceArt_tex.Communication.menu_crosshair', 16, 16, 0, 0, 16, 16);

    Menu = DHCommandMenu(Menus.Peek());

    Theta -= class'UUnits'.static.DegreesToRadians(90);

    if (Menu != none)
    {
        ArcLength = Tau / Menu.Options.Length;

        // Draw all the options.
        for (i = 0; i < Menu.Options.Length; ++i)
        {

            if (SelectedIndex == i)
            {
                C.DrawColor = class'UColor'.default.Yellow;
                C.DrawColor.A = byte(255 * (MenuAlpha * 0.9));
            }
            else
            {
                C.DrawColor = class'UColor'.default.White;
                C.DrawColor.A = byte(255 * (MenuAlpha * 0.5));
            }

            C.SetPos(CenterX - 256, CenterY - 256);
            C.DrawTileClipped(MaterialQuarters[i], 512, 512, 0, 0, 512, 512);

            U = Menu.Options[i].Material.MaterialUSize();
            V = Menu.Options[i].Material.MaterialVSize();

            X = CenterX  + (Cos(Theta) * 144) - (U / 2);
            Y = CenterY + (Sin(Theta) * 144) - (V / 2);

            C.DrawColor = class'UColor'.default.White;
            C.DrawColor.A = byte(255 * MenuAlpha);
            C.SetPos(X, Y);
            C.DrawTileClipped(Menu.Options[i].Material, U, V, 0, 0, U, V);

            Theta += ArcLength;
        }
    }

    // Display text of selection
    if (SelectedIndex >= 0)
    {
        C.TextSize(Menu.Options[SelectedIndex].Text, XL, YL);
        C.SetPos(CenterX - (XL / 2), CenterY + 32);
        C.DrawText(Menu.Options[SelectedIndex].Text);
    }

//    // debug rendering for cursor
//    C.SetPos(CenterX + Cursor.X, CenterY + Cursor.Y);
//    C.DrawColor = class'UColor'.default.Red;
//    C.DrawBox(C, 4, 4);
}

function bool KeyEvent(out EInputKey Key, out EInputAction Action, float Delta)
{
    local DHPlayer PC;
    local DHPlayerReplicationInfo PRI;
    local vector TraceStart, TraceEnd, HitLocation, HitNormal;
    local Actor A, HitActor;

    PC = DHPlayer(ViewportOwner.Actor);

    if (PC == none || PC.Pawn == none && PC.Pawn.Region.Zone != none)
    {
        return false;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    if (PRI == none)
    {
        return false;
    }

    switch (Action)
    {
        case IST_Axis:
            switch (Key)
            {
                case IK_MouseX:
                    Cursor.X += Delta;
                    return true;
                case IK_MouseY:
                    Cursor.Y -= Delta;
                    return true;
                default:
                    break;
            }
            break;
        case IST_Press:
            switch (Key)
            {
                // TODO: Left mouse might not be bound to fire, and exec functions
                // do not register in interactions. This isn't ideal, but I'm
                // guessing that %99.9 of players use left mouse as the fire
                // key, so this will do for now.
                case IK_LeftMouse:
                    TraceStart = PC.CalcViewLocation;
                    TraceEnd = TraceStart + (vector(PC.CalcViewRotation) * PC.Pawn.Region.Zone.DistanceFogEnd);

                    foreach PC.TraceActors(class'Actor', A, HitLocation, HitNormal, TraceEnd, TraceStart)
                    {
                        if (A == PC.Pawn ||
                            A.IsA('ROBulletWhipAttachment') ||
                            A.IsA('Volume'))
                        {
                            continue;
                        }

                        HitActor = A;

                        break;
                    }

                    Log(HitActor);

                    if (HitActor == none)
                    {
                        HitLocation = TraceEnd;
                    }

                    OnSelect(SelectedIndex, HitLocation);
                    return true;
                case IK_RightMouse:
                    if (Menus.Size() > 1)
                    {
                        PopMenu();
                    }
                    return true;
                default:
                    break;
            }
            return false;
        default:
            break;
    }

    return false;
}

function bool OnSelect(int Index, optional vector Location)
{
    local DHCommandMenu Menu;

    Menu = DHCommandMenu(Menus.Peek());

    if (Menu == none || Index < 0 || Index >= Menu.Options.Length)
    {
        return false;
    }

    Menu.OnSelect(self, Index, Location);
}

defaultproperties
{
    bActive=true
    bVisible=true
    bRequiresTick=true

    MaterialQuarters(0)=TexRotator'DH_InterfaceArt_tex.Communication.menu_option_quarter_1'
    MaterialQuarters(1)=TexRotator'DH_InterfaceArt_tex.Communication.menu_option_quarter_2'
    MaterialQuarters(2)=TexRotator'DH_InterfaceArt_tex.Communication.menu_option_quarter_3'
    MaterialQuarters(3)=TexRotator'DH_InterfaceArt_tex.Communication.menu_option_quarter_4'
}
