//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DHVehicleRegistry extends Object
    abstract;

struct SVehicleRecordVariant
{
    var string VariantName;
    var string ClassName;
};

struct SVehicleRecord
{
    var array<string> VehicleNames;
    var array<SVehicleRecordVariant> Variants;
};

var array<SVehicleRecord> Records;

static function string GetClassNameFromVehicleName(string VehicleName, optional string VariantName)
{
    local int i, j, k;

    VehicleName = Caps(VehicleName);

    for (i = 0; i < default.Records.Length; ++i)
    {
        for (j = 0; j < default.Records[i].VehicleNames.Length; ++j)
        {
            if (StrCmp(VehicleName, default.Records[i].VehicleNames[j]) == 0)
            {
                for (k = 0; k < default.Records[i].Variants.Length; ++k)
                {
                    if (StrCmp(default.Records[i].Variants[k].VariantName, VariantName) == 0)
                    {
                        return default.Records[i].Variants[k].ClassName;
                    }
                }

                return "";
            }
        }
    }

    return "";
}

static function DumpToLog(PlayerController PC)
{
    local int i, j;
    local array<string> VariantNames;
    local string LogLine;

    if (PC == none)
    {
        return;
    }

    for (i = 0; i < default.Records.Length; ++i)
    {
        VariantNames.Length = 0;
        LogLine = "";

        for (j = 0; j < default.Records[i].Variants.Length; ++j)
        {
            if (default.Records[i].Variants[j].VariantName == "")
            {
                continue;
            }

            VariantNames[VariantNames.Length] = default.Records[i].Variants[j].VariantName;
        }

        LogLine = class'UString'.static.Join(", ", default.Records[i].VehicleNames);

        if (VariantNames.Length > 0)
        {
            LogLine @= "-" @ "(" $ class'UString'.static.Join(", ", VariantNames) $ ")";
        }

        PC.Log(LogLine);
    }
}

defaultproperties
{

    //Vehicle registry for abbrivaiated names, this is to enable a person to spawn a vehicle without looking up the class name
    //Much like the weapon registry
    //TEMPLATE
    //Records()=(VehicleNames=(""),Variants=((ClassName="DH_Vehicles."),(ClassName="DH_Vehicles.",VariantName="")))

    //Watch for spaces between commas when defining variant type as this will throw an error

    //wheeled vehicles (soft skin/lightly armored)
    //Soviet
    Records(0)=(VehicleNames=("ba64","clowncar"),Variants=((ClassName="DH_Vehicles.DH_BA64ArmoredCar"),(ClassName="DH_Vehicles.DH_BA64ArmoredCar_Snow",VariantName="snow")))
    Records(1)=(VehicleNames=("gaz67","gaz"),Variants=((ClassName="DH_Vehicles.DH_GAZ67Vehicle")))
    Records(2)=(VehicleNames=("zis5","ZiS5transport","zistransport"),Variants=((ClassName="DH_Vehicles.DH_ZiS5vTruckTransport")))
    Records(3)=(VehicleNames=("zislogi","zis5logi","ZiS5logi"),Variants=((ClassName="DH_Vehicles.DH_ZiS5vTruckSupport")))
    //American/British
    Records(4)=(VehicleNames=("gmc"),Variants=((ClassName="DH_Vehicles.DH_GMCTruckTransport"),(ClassName="DH_Vehicles.DH_GMCTruckTransport_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_GMCTruckTransport_LL",VariantName="LL"),(ClassName="DH_Vehicles.DH_GMCTruckTransport_LL_Snow",VariantName="LLsnow"),(ClassName="DH_Vehicles.DH_GMCTruckTransport_Halloween",VariantName="haloween"),(ClassName="DH_Vehicles.DH_GMCTruckTransport_Halloween",VariantName="spooky")))
    Records(5)=(VehicleNames=("gmclogi","gmcsupply"),Variants=((ClassName="DH_Vehicles.DH_GMCTruckSupport"),(ClassName="DH_Vehicles.DH_GMCTruckSupport_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_GMCTruckSupport_LL",VariantName="LL"),(ClassName="DH_Vehicles.DH_GMCTruckSupport_LL_Snow",VariantName="LLsnow"),(ClassName="DH_Vehicles.DH_GMCTruckSupport_Halloween",VariantName="haloween")))
    Records(6)=(VehicleNames=("jeep","willysjeep"),Variants=((ClassName="DH_Vehicles.DH_WillysJeep"),(ClassName="DH_Vehicles.DH_WillysJeep_SovietRoof",VariantName="sovietroof"),(ClassName="DH_Vehicles.DH_WillysJeep_Soviet",VariantName="soviet"),(ClassName="DH_Vehicles.DH_WillysJeep_SnowRoof",VariantName="snowroof"),(ClassName="DH_Vehicles.DH_WillysJeep_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_WillysJeep_Roof",VariantName="roof"),(ClassName="DH_Vehicles.DH_WillysJeep_ItalyRoof",VariantName="italyroof"),(ClassName="DH_Vehicles.DH_WillysJeep_Italy",VariantName="italy"),(ClassName="DH_Vehicles.DH_WillysJeep_DesertRoof",VariantName="desertroof"),(ClassName="DH_Vehicles.DH_WillysJeep_Desert",VariantName="desert"),(ClassName="DH_Vehicles.DH_WillysJeep_AirborneRoof",VariantName="airborneroof"),(ClassName="DH_Vehicles.DH_WillysJeep_Airborne",VariantName="airborne")))
    //German
    Records(7)=(VehicleNames=("kubel","kubelwagen"),Variants=((ClassName="DH_Vehicles.DH_KubelwagenCar_WH.uc"),(ClassName="DH_Vehicles.DH_KubelwagenCar_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_KubelwagenCar_SS",VariantName="SS"),(ClassName="DH_Vehicles.DH_KubelwagenCarTwo_SS",VariantName="SStwo")))
    Records(8)=(VehicleNames=("opel"),Variants=((ClassName="DH_Vehicles.DH_OpelBlitzTransport"),(ClassName="DH_Vehicles.DH_OpelBlitzTransport_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_OpelBlitzTransport_NoTarp",VariantName="notarp")))
    Records(9)=(VehicleNames=("opellogi"),Variants=((ClassName="DH_Vehicles.DH_OpelBlitzSupport"),(ClassName="DH_Vehicles.DH_OpelBlitzSupport_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_OpelBlitzSupport_NoTarp",VariantName="notarp")))
    
    //--+--

    //Armored cars, halftracks and tankettes (heavily Armored)
    //Soviet (there are none currently apart from the soviet universal carrier)
    Records(10)=(VehicleNames=("sovietcarrier","DTcarrier"),Variants=((ClassName="DH_Vehicles.DH_UniversalCarrierMG"),(ClassName="DH_Vehicles.DH_UniversalCarrierTransport_Snow",VariantName="snow")))
    //American/British
    Records(11)=(VehicleNames=("greyhound","m8"),Variants=((ClassName="DH_Vehicles.DH_GreyhoundArmoredCar"),(ClassName="DH_Vehicles.DH_GreyhoundArmoredCar_British",VariantName="british"),(ClassName="DH_Vehicles.DH_GreyhoundArmoredCar_Snow",VariantName="snow")))
    Records(12)=(VehicleNames=("m3halftrack","americanhalftrack","americanHT","m3"),Variants=((ClassName="DH_Vehicles.DH_M3A1HalftrackTransport"),(ClassName="DH_Vehicles.DH_M3A1HalftrackTransport_Soviet",VariantName="soviet"),(ClassName="DH_Vehicles.DH_M3A1HalftrackTransport_Soviet_Snow",VariantName="sovietsnow"),(ClassName="DH_Vehicles.DH_M3A1HalftrackTransport_Snow",VariantName="snow")))
    Records(13)=(VehicleNames=("m16halftrack","m16","quad50ht"),Variants=((ClassName="DH_Vehicles.DH_M16Halftrack"),(ClassName="DH_Vehicles.DH_M16Halftrack_Snow",VariantName="snow")))
    Records(14)=(VehicleNames=("brencarrier","universalcarrier"),Variants=((ClassName="DH_Vehicles.DH_BrenCarrierTransport"),(ClassName="DH_Vehicles.DH_BrenCarrierTransport_Italy",VariantName="italy"),(ClassName="DH_Vehicles.DH_BrenCarrierTransport_Africa",VariantName="africa")))
    //German
    Records(15)=(VehicleNames=("sdkfz105","sdk105","flakwagen"),Variants=((ClassName="DH_Vehicles.DH_Sdkfz105Transport"),(ClassName="DH_Vehicles.DH_Sdkfz105Transport_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_Sdkfz105Transport_Camo",VariantName="camo"),(ClassName="DH_Vehicles.DH_Sdkfz105TransportArmored",VariantName="armored"),(ClassName="DH_Vehicles.DH_Sdkfz105TransportArmored_Snow",VariantName="armoredsnow"),(ClassName="DH_Vehicles.DH_Sdkfz105TransportArmored_Camo",VariantName="armoredcamo")))
    Records(16)=(VehicleNames=("sdkfz251","germanhalftrack","germanht"),Variants=((ClassName="DH_Vehicles.DH_Sdkfz251Transport"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_Soviet",VariantName="soviet"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_SnowOne",VariantName="snow"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_SnowTwo",VariantName="snowtwo"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_SnowWhiteWash",VariantName="snowthree"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_CamoOne",VariantName="camoone"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_CamoTwo",VariantName="camotwo"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_CamoThree",VariantName="camothree"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_CamoFour",VariantName="camofour"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_Allies",VariantName="allies"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_Allies",VariantName="captured")))
    Records(17)=(VehicleNames=("sdkfz251/22","sdk251/22","sdkfz25122","pakwagen"),Variants=((ClassName="DH_Vehicles.DH_SdKfz251_22Transport")))
    Records(18)=(VehicleNames=("sdkfz251/9d","sdkfz251/9","sdkfz2519","sdk251/9","stummel"),Variants=((ClassName="DH_Vehicles.DH_SdKfz2519DTransport"),(ClassName="DH_Vehicles.DH_SdKfz2519DTransport_Snow",VariantName="snow")))
    Records(19)=(VehicleNames=("sdkfz234/1","sdk234/1","sdkfz2341","20mmpuma"),Variants=((ClassName="DH_Vehicles.DH_Sdkfz2341ArmoredCar"),(ClassName="DH_Vehicles.DH_Sdkfz2341ArmoredCar_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_Sdkfz2341ArmoredCar_CamoOne",VariantName="camoone"),(ClassName="DH_Vehicles.DH_Sdkfz2341ArmoredCar_CamoTwo",VariantName="camotwo")))
    Records(20)=(VehicleNames=("sdkfz234/2","sdk234/2","sdkfz2342","puma","50mmpuma"),Variants=((ClassName="DH_Vehicles.DH_Sdkfz2342ArmoredCar"),(ClassName="DH_Vehicles.DH_Sdkfz2342ArmoredCar_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_Sdkfz2342ArmoredCar_CamoOne",VariantName="camoone"),(ClassName="DH_Vehicles.",VariantName="DH_Sdkfz2342ArmoredCar_CamoTwo")))
    Records(21)=(VehicleNames=("germancarrier","bren731","mg34carrier"),Variants=((ClassName="DH_Vehicles.DH_GermanCarrierTransport"),(ClassName="DH_Vehicles.",VariantName="")))

    //--+--

    //light tanks
    //Soviet
    Records(22)=(VehicleNames=("t60"),Variants=((ClassName="DH_Vehicles.DH_T60Tank"),(ClassName="DH_Vehicles.DH_T60Tank_Snow",VariantName="snow")))
    Records(23)=(VehicleNames=("bt7"),Variants=((ClassName="DH_Vehicles.DH_BT7Tank"),(ClassName="DH_Vehicles.DH_BT7Tank_Snow",VariantName="snow")))
    //American/British
    Records(24)=(VehicleNames=("stuart","m5stuart"),Variants=((ClassName="DH_Vehicles.DH_StuartTank"),(ClassName="DH_Vehicles.DH_StuartTank_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_StuartTank_British",VariantName="british"),(ClassName="DH_Vehicles.DH_StuartTank_British",VariantName="mk6stuart")))
    //German(None currently)

    //--+--

    //medium tanks
    //Soviet
    Records(25)=(VehicleNames=("t34/76","t3476","t3476early","t34/76early"),Variants=((ClassName="DH_Vehicles.DH_T3476Tank"),(ClassName="DH_Vehicles.DH_T3476TankSnow",VariantName="snow"),(ClassName="DH_Vehicles.DH_T3476Tank_CamoA",VariantName="camo")))
    Records(26)=(VehicleNames=("t34/76m42","t3476m42","t34m42","m42"),Variants=((ClassName="DH_Vehicles.DH_T3476_42Tank"),(ClassName="DH_Vehicles.DH_T3476_42TankSnow",VariantName="snow")))
    Records(27)=(VehicleNames=("t34/76m43","t3476m43","t34m43","m43"),Variants=((ClassName="DH_Vehicles.DH_T3476_43Tank"),(ClassName="DH_Vehicles.DH_T3476_43TankSnow",VariantName="snow")))
    Records(28)=(VehicleNames=("t34/85","t3485"),Variants=((ClassName="DH_Vehicles.DH_T3485Tank"),(ClassName="DH_Vehicles.DH_T3485TankSnow",VariantName="snow"),(ClassName="DH_Vehicles.DH_T3485Tank_CamoA",VariantName="camo"),(ClassName="DH_Vehicles.DH_T3485Tank_Berlin",VariantName="berlin")))
    Records(29)=(VehicleNames=("sovietsherman","m4a2soviet","m4a275soviet"),Variants=((ClassName="DH_Vehicles.DH_ShermanTank_M4A275W_Soviet"),(ClassName="DH_Vehicles.DH_ShermanTank_M4A275W_Soviet_Snow",VariantName="snow")))
    Records(30)=(VehicleNames=("sovietsherman76","m4a276soviet"),Variants=((ClassName="DH_Vehicles.DH_ShermanTank_M4A276W_Soviet"),(ClassName="DH_Vehicles.DH_ShermanTank_M4A276W_Soviet_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_ShermanTank_M4A276W_Berlin",VariantName="berlin")))
    //American
    Records(31)=(VehicleNames=("m4a1","shermanearly","m4a175","m4a1/75"),Variants=((ClassName="DH_Vehicles.DH_ShermanTank"),(ClassName="DH_Vehicles.DH_ShermanTank_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_ShermanTank_Camo",VariantName="camo"),(ClassName="DH_ShermanTank_DDay",VariantName="dday"),(ClassName="DH_ShermanTank_DDay",VariantName="DD")))
    Records(32)=(VehicleNames=("m4a3","m4a375","m4a3/75"),Variants=((ClassName="DH_Vehicles.DH_ShermanTank_M4A375W"),(ClassName="DH_Vehicles.DH_ShermanTank_M4A375W_Snow",VariantName="snow")))
    Records(34)=(VehicleNames=("m4a176","m4a1/76"),Variants=((ClassName="DH_ShermanTankA_M4A176W"),(ClassName="DH_Vehicles.DH_ShermanTankA_M4A176W_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_ShermanTankA_M4A176W_Early",VariantName="early"),(ClassName="DH_Vehicles.DH_ShermanTankA_M4A176W_Early_Camo",VariantName="earlycamo"),(ClassName="DH_Vehicles.DH_ShermanTankA_M4A176W_Camo",VariantName="camo"),(ClassName="DH_Vehicles.DH_ShermanTankB_M4A176W",VariantName="B"),(ClassName="DH_Vehicles.DH_ShermanTankB_M4A176W_Snow",VariantName="snowb")))
    Records(35)=(VehicleNames=("m4a376","m4a3/76"),Variants=((ClassName="DH_Vehicles.DH_ShermanTank_M4A376W"),(ClassName="DH_Vehicles.DH_ShermanTank_M4A376W_Early",VariantName="early"),(ClassName="DH_Vehicles.DH_ShermanTank_M4A376W_Snow",VariantName="snow")))
    Records(36)=(VehicleNames=("m4a3e8","m4a3/e8","easyeight"),Variants=((ClassName="DH_Vehicles.DH_ShermanTank_M4A3E8"),(ClassName="DH_Vehicles.DH_ShermanTank_M4A3E8_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_ShermanTank_M4A3E8_Fury",VariantName="fury"),(ClassName="DH_Vehicles.DH_ShermanTank_M4A3E8_ZombieSlayer",VariantName="haloween")))
    Records(33)=(VehicleNames=("sherman105","m4a3105","m4a3/105"),Variants=((ClassName="DH_Vehicles.DH_ShermanTank_M4A3105_Howitzer"),(ClassName="DH_Vehicles.DH_ShermanTank_M4A3105_Snow",VariantName="snow")))
    









}

