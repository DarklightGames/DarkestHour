//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHWeaponRegistry extends Object
    abstract;

struct SWeaponRecord
{
    var array<string> WeaponNames;
    var string ClassName;
    var bool bShouldExcludeFromGiveAll;
};

var array<SWeaponRecord> Records;

static function string GetClassNameFromWeaponName(string WeaponName)
{
    local int i, j;

    WeaponName = Caps(WeaponName);

    for (i = 0; i < default.Records.Length; ++i)
    {
        for (j = 0; j < default.Records[i].WeaponNames.Length; ++j)
        {
            if (StrCmp(WeaponName, default.Records[i].WeaponNames[j]) == 0)
            {
                return default.Records[i].ClassName;
            }
        }
    }

    return "";
}

static function DumpToLog(PlayerController PC)
{
    local int i;

    if (PC == none)
    {
        return;
    }

    PC.Level.Game.Broadcast(PC, "A list of weapons has been written to the log");

    for (i = 0; i < default.Records.Length; ++i)
    {
        PC.Log(class'UString'.static.Join(",", default.Records[i].WeaponNames) @ " - " @ default.Records[i].ClassName);
    }
}

defaultproperties
{
    // NOTE: Feel free to insert new records anywhere in this list, the order
    // is not important

    Records(0)=(ClassName="DH_Weapons.DH_30CalWeapon",WeaponNames=("30cal","m1919"))
    Records(1)=(ClassName="DH_Weapons.DH_AVT40Weapon",WeaponNames=("avt", "avt40"))
    Records(2)=(ClassName="DH_Weapons.DH_BARWeapon",WeaponNames=("bar"))
    Records(3)=(ClassName="DH_Weapons.DH_BazookaWeapon",WeaponNames=("bazooka"))
    Records(4)=(ClassName="DH_Weapons.DH_BHPWeapon",WeaponNames=("bhp"))
    Records(5)=(ClassName="DH_Weapons.DH_BrenWeapon",WeaponNames=("bren"))
    Records(6)=(ClassName="DH_Weapons.DH_C96Weapon",WeaponNames=("c96"))
    Records(7)=(ClassName="DH_Weapons.DH_ColtM1911Weapon",WeaponNames=("colt", "1911"))
    Records(8)=(ClassName="DH_Weapons.DH_DP27Weapon",WeaponNames=("dp27"))
    Records(9)=(ClassName="DH_Weapons.DH_EnfieldNo2Weapon",WeaponNames=("enfield2", "webley"))
    Records(10)=(ClassName="DH_Weapons.DH_EnfieldNo4Weapon",WeaponNames=("enfield", "enfield4"))
    Records(11)=(ClassName="DH_Weapons.DH_EnfieldNo4ScopedWeapon",WeaponNames=("enfieldscoped", "enfield4scoped"))
    Records(12)=(ClassName="DH_Weapons.DH_F1GrenadeWeapon",WeaponNames=("f1"))
    Records(13)=(ClassName="DH_Weapons.DH_FG42Weapon",WeaponNames=("fg42"))
    Records(14)=(ClassName="DH_Weapons.DH_G41Weapon",WeaponNames=("g41"))
    Records(15)=(ClassName="DH_Weapons.DH_G43Weapon",WeaponNames=("g43"))
    Records(16)=(ClassName="DH_Weapons.DH_G43ScopedWeapon",WeaponNames=("g43scoped"))
    Records(17)=(ClassName="DH_Weapons.DH_GLWeapon",WeaponNames=("gl"))
    Records(18)=(ClassName="DH_Weapons.DH_GreaseGunWeapon",WeaponNames=("greasegun"))
    Records(19)=(ClassName="DH_Weapons.DH_Kar98Weapon",WeaponNames=("k98", "kar98"))
    Records(20)=(ClassName="DH_Weapons.DH_Kar98NoCoverWeapon",WeaponNames=("k98nohood"))
    Records(21)=(ClassName="DH_Weapons.DH_Kar98ScopedWeapon",WeaponNames=("k98scoped", "kar98scoped"))
    Records(22)=(ClassName="DH_Weapons.DH_KorovinWeapon",WeaponNames=("korovin"))
    Records(23)=(ClassName="DH_Weapons.DH_Kz8cmGrW42Weapon",bShouldExcludeFromGiveAll=true,WeaponNames=("grw42"))
    Records(24)=(ClassName="DH_Weapons.DH_M1928_20rndWeapon",WeaponNames=("m1928-20"))
    Records(25)=(ClassName="DH_Weapons.DH_M1928_30rndWeapon",WeaponNames=("m1928-30"))
    Records(26)=(ClassName="DH_Weapons.DH_M1928_50rndWeapon",WeaponNames=("m1928-50", "m1928"))
    Records(27)=(ClassName="DH_Weapons.DH_M1CarbineWeapon",WeaponNames=("carbine"))
    Records(28)=(ClassName="DH_Weapons.DH_M1GarandWeapon",WeaponNames=("garand"))
    Records(29)=(ClassName="DH_Weapons.DH_M1GrenadeWeapon",WeaponNames=("frag"))
    Records(30)=(ClassName="DH_Weapons.DH_M2MortarWeapon",bShouldExcludeFromGiveAll=true,WeaponNames=("m2mortar"))
    Records(31)=(ClassName="DH_Weapons.DH_M34GrenadeWeapon",WeaponNames=("m34"))
    Records(32)=(ClassName="DH_Weapons.DH_M38Weapon",WeaponNames=("m38"))
    Records(33)=(ClassName="DH_Weapons.DH_M44Weapon",WeaponNames=("m44"))
    Records(34)=(ClassName="DH_Weapons.DH_M712Weapon",WeaponNames=("m712", "schnellfeuer"))
    Records(35)=(ClassName="DH_Weapons.DH_MAB38Weapon",WeaponNames=("mab", "mab38"))
    Records(36)=(ClassName="DH_Weapons.DH_MG34Weapon",WeaponNames=("mg34"))
    Records(37)=(ClassName="DH_Weapons.DH_MG42Weapon",WeaponNames=("mg42"))
    Records(38)=(ClassName="DH_Weapons.DH_MillsBombWeapon",WeaponNames=("mills"))
    Records(39)=(ClassName="DH_Weapons.DH_MN9130Weapon",WeaponNames=("mosin"))
    Records(40)=(ClassName="DH_Weapons.DH_MP38Weapon",WeaponNames=("mp38"))
    Records(41)=(ClassName="DH_Weapons.DH_MP40Weapon",WeaponNames=("mp40"))
    Records(42)=(ClassName="DH_Weapons.DH_MP41Weapon",WeaponNames=("mp41"))
    Records(43)=(ClassName="DH_Weapons.DH_MP41RWeapon",WeaponNames=("mp41r"))
    Records(44)=(ClassName="DH_Weapons.DH_Nagant1895Weapon",WeaponNames=("n1895", "sovrevolver", "m1895"))
    Records(45)=(ClassName="DH_Weapons.DH_P08LugerWeapon",WeaponNames=("p08", "luger"))
    Records(46)=(ClassName="DH_Weapons.DH_P38Weapon",WeaponNames=("p38"))
    Records(47)=(ClassName="DH_Weapons.DH_PanzerfaustWeapon",WeaponNames=("pfaust", "panzerfaust"))
    Records(48)=(ClassName="DH_Weapons.DH_PanzerschreckWeapon",WeaponNames=("pschreck", "panzerschreck"))
    Records(49)=(ClassName="DH_Weapons.DH_PIATWeapon",WeaponNames=("piat"))
    Records(50)=(ClassName="DH_Weapons.DH_PPD40Weapon",WeaponNames=("ppd40", "ppd"))
    Records(51)=(ClassName="DH_Weapons.DH_PPS43Weapon",WeaponNames=("pps43", "pps"))
    Records(52)=(ClassName="DH_Weapons.DH_PPSH41Weapon",WeaponNames=("ppsh41", "ppsh"))
    Records(53)=(ClassName="DH_Weapons.DH_PPSH41_StickWeapon",WeaponNames=("ppsh41stick", "ppshstick"))
    Records(54)=(ClassName="DH_Weapons.DH_PTRDWeapon",WeaponNames=("ptrd"))
    Records(55)=(ClassName="DH_Weapons.DH_RPG43GrenadeWeapon",WeaponNames=("rpg43", "rpg"))
    Records(56)=(ClassName="DH_Weapons.DH_SatchelCharge10lb10sWeapon",WeaponNames=("satchel"))
    Records(57)=(ClassName="DH_Weapons.DH_SpringfieldA1Weapon",WeaponNames=("springfield"))
    Records(58)=(ClassName="DH_Weapons.DH_SpringfieldScopedWeapon",WeaponNames=("springfieldscoped"))
    Records(59)=(ClassName="DH_Weapons.DH_StenMkIIWeapon",WeaponNames=("sten", "sten2", "stenmk2"))
    Records(60)=(ClassName="DH_Weapons.DH_STG44Weapon",WeaponNames=("stg", "stg44", "mp44"))
    Records(61)=(ClassName="DH_Weapons.DH_StielGranateWeapon",WeaponNames=("stiel"))
    Records(62)=(ClassName="DH_Weapons.DH_SVT38Weapon",WeaponNames=("svt38"))
    Records(63)=(ClassName="DH_Weapons.DH_SVT40Weapon",WeaponNames=("svt40"))
    Records(64)=(ClassName="DH_Weapons.DH_SVT40ScopedWeapon",WeaponNames=("svt40scoped"))
    Records(65)=(ClassName="DH_Weapons.DH_ThompsonWeapon",WeaponNames=("thompson", "tommy"))
    Records(66)=(ClassName="DH_Weapons.DH_TT33Weapon",WeaponNames=("tt33", "tt"))
    Records(67)=(ClassName="DH_Weapons.DH_ViSWeapon",WeaponNames=("vis"))
    Records(68)=(ClassName="DH_Weapons.DH_VK98Weapon",WeaponNames=("vk98", "vkar98"))
    Records(69)=(ClassName="DH_Weapons.DH_Winchester1897Weapon",WeaponNames=("shotgun", "1897", "winchester"))
    Records(70)=(ClassName="DH_Equipment.DHBinocularsItemAllied",WeaponNames=("binocs", "binocs_us"))
    Records(71)=(ClassName="DH_Equipment.DHBinocularsItemGerman",WeaponNames=("binocs_ger"))
    Records(72)=(ClassName="DH_Equipment.DHBinocularsItemSoviet",WeaponNames=("binocs_sov"))
    Records(73)=(ClassName="DH_Equipment.DHRadioItem",WeaponNames=("radio"))
    Records(74)=(ClassName="DH_Equipment.DHShovelItem_US",WeaponNames=("shovel", "shovel_us"))
    Records(75)=(ClassName="DH_Equipment.DHShovelItem_German",WeaponNames=("shovel_ger"))
    Records(76)=(ClassName="DH_Equipment.DHShovelItem_Russian",WeaponNames=("shovel_sov"))
    Records(77)=(ClassName="DH_Equipment.DHWireCuttersItem",WeaponNames=("wirecutters", "snips"))
    Records(78)=(ClassName="DH_Equipment.DH_NebelGranate39Weapon",WeaponNames=("gersmoke", "nb38", "nb", "nebel"))
    Records(79)=(ClassName="DH_Equipment.DH_OrangeSmokeWeapon",WeaponNames=("orangesmoke"))
    Records(80)=(ClassName="DH_Equipment.DH_ParachuteItem",bShouldExcludeFromGiveAll=true,WeaponNames=("parachute"))
    Records(81)=(ClassName="DH_Equipment.DH_RDG1SmokeGrenadeItem",WeaponNames=("rdg", "rdg1", "sovsmoke"))
    Records(82)=(ClassName="DH_Equipment.DH_RedSmokeWeapon",WeaponNames=("redsmoke"))
    Records(83)=(ClassName="DH_Equipment.DH_USSmokeGrenadeWeapon",WeaponNames=("smoke", "ussmoke"))
    Records(84)=(ClassName="DH_Weapons.DH_M1A1CarbineWeapon",WeaponNames=("m1a1", "carbinepara"))
    Records(85)=(ClassName="DH_Weapons.DH_M1T17CarbineWeapon",WeaponNames=("m1t17", "t17"))
    Records(86)=(ClassName="DH_Weapons.DH_VG15Weapon",WeaponNames=("vg15"))
    Records(87)=(ClassName="DH_Weapons.DH_BARNoBipodWeapon",WeaponNames=("barnobipod"))
    Records(88)=(ClassName="DH_Weapons.DH_StenMkIIIWeapon",WeaponNames=("stenmk3", "sten3"))
    Records(89)=(ClassName="DH_Weapons.DH_StenMkIICWeapon",WeaponNames=("stenmk2c", "sten2c", "stenc"))
    Records(90)=(ClassName="DH_Weapons.DH_StenMkVWeapon",WeaponNames=("stenmk5", "sten5"))
    Records(91)=(ClassName="DH_Weapons.DH_BazookaM9Weapon",WeaponNames=("bazookam9", "m9", "m9bazooka"))
    Records(92)=(ClassName="DH_Weapons.DH_ZB30Weapon",WeaponNames=("zb30", "zb"))
    Records(93)=(ClassName="DH_Weapons.DH_MP3008Weapon",WeaponNames=("mp3008"))
    Records(94)=(ClassName="DH_Weapons.DH_GeratPWeapon",WeaponNames=("geratp"))
    Records(95)=(ClassName="DH_Weapons.DH_Stg44ScopedWeapon",WeaponNames=("stg44scoped", "mp44scoped"))
    Records(96)=(ClassName="DH_Weapons.DH_MN9130ScopedPEWeapon",WeaponNames=("mosinscopedpe","scopedmosinpe","scopedmosinearly"))
    Records(97)=(ClassName="DH_Weapons.DH_Nagant1895BramitWeapon",WeaponNames=("bramit"))
    Records(98)=(ClassName="DH_Equipment.DHTrenchMaceItem",WeaponNames=("trenchmace"))
    Records(99)=(ClassName="DH_Equipment.DHTrenchMaceItem_Bone",WeaponNames=("bonemace"))
    Records(100)=(ClassName="DH_Equipment.DHTrenchMaceItem_Grenade",WeaponNames=("grenademace"))
    Records(101)=(ClassName="DH_Weapons.DH_GeratPIIWeapon",WeaponNames=("wunderwaffe","geratp2"))
}
