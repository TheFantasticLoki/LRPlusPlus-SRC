// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

max_round()
{
    self thread zombiekill();
    level.round_number = 250;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 2;
}

round10()
{
    self thread zombiekill();
    level.round_number = 10;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 2;
}

round25()
{
    self thread zombiekill();
    level.round_number = 25;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 2;
}

round50()
{
    self thread zombiekill();
    level.round_number = 50;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 2;
}

round75()
{
    self thread zombiekill();
    level.round_number = 75;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 2;
}

round100()
{
    self thread zombiekill();
    level.round_number = 100;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 2;
}

round125()
{
    self thread zombiekill();
    level.round_number = 125;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 2;
}

round150()
{
    self thread zombiekill();
    level.round_number = 150;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 2;
}

round175()
{
    self thread zombiekill();
    level.round_number = 175;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 2;
}

round200()
{
    self thread zombiekill();
    level.round_number = 200;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 2;
}

round225()
{
    self thread zombiekill();
    level.round_number = 225;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 2;
}

round_up()
{
    self thread zombiekill();
    level.round_number += 1;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 0.5;
}

round_down()
{
    self thread zombiekill();
    level.round_number -= 1;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 0.5;
}
