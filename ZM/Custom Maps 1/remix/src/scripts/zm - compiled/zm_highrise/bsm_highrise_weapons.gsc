�GSC
     �  u.    u.  M*  �*  i:  i:  G  @  5        C:/Users/astey/Documents/Black Ops 2 - GSC Studio/GSC Fast Compiler/Custom Maps 1/remix/src/scripts/zm - compiled/zm_highrise/bsm_highrise_weapons.gsc main extmapcheck xmapcheck CUSTOM_MAP 0 1 2 3 4 5  init_spawnable_weapon_upgrade maps/mp/zombies/_zm_weapons replacefunc init_weapons precacheeffectsforweapons custom_add_weapons _zombie_custom_add_weapons zombie_teddybear precachemodel ZOMBIE_WEAPON_M1911 m1911_upgraded_zm m1911_zm add_zombie_weapon wpck_python ZOMBIE_WEAPON_PYTHON python_upgraded_zm python_zm wpck_judge ZOMBIE_WEAPON_JUDGE judge_upgraded_zm judge_zm wpck_kap ZOMBIE_WEAPON_KARD kard_upgraded_zm kard_zm wpck_57 ZOMBIE_WEAPON_FIVESEVEN fiveseven_upgraded_zm fiveseven_zm ZOMBIE_WEAPON_BERETTA93r beretta93r_upgraded_zm beretta93r_zm wpck_duel57 ZOMBIE_WEAPON_FIVESEVENDW fivesevendw_upgraded_zm fivesevendw_zm smg ZOMBIE_WEAPON_AK74U ak74u_upgraded_zm ak74u_zm ZOMBIE_WEAPON_MP5K mp5k_upgraded_zm mp5k_zm wpck_chicom ZOMBIE_WEAPON_QCW05 qcw05_upgraded_zm qcw05_zm ZOMBIE_WEAPON_PDW57 pdw57_upgraded_zm pdw57_zm shotgun ZOMBIE_WEAPON_870MCS 870mcs_upgraded_zm 870mcs_zm ZOMBIE_WEAPON_ROTTWEIL72 rottweil72_upgraded_zm rottweil72_zm wpck_saiga12 ZOMBIE_WEAPON_SAIGA12 saiga12_upgraded_zm saiga12_zm wpck_m1216 ZOMBIE_WEAPON_SRM1216 srm1216_upgraded_zm srm1216_zm rifle ZOMBIE_WEAPON_M14 m14_upgraded_zm m14_zm wpck_sidr ZOMBIE_WEAPON_SARITCH saritch_upgraded_zm saritch_zm burstrifle ZOMBIE_WEAPON_M16 m16_gl_upgraded_zm m16_zm wpck_m8a1 ZOMBIE_WEAPON_XM8 xm8_upgraded_zm xm8_zm wpck_type25 ZOMBIE_WEAPON_TYPE95 type95_upgraded_zm type95_zm wpck_x95l ZOMBIE_WEAPON_TAR21 tar21_upgraded_zm tar21_zm wpck_galil ZOMBIE_WEAPON_GALIL galil_upgraded_zm galil_zm wpck_fal ZOMBIE_WEAPON_FNFAL fnfal_upgraded_zm fnfal_zm wpck_dsr50 ZOMBIE_WEAPON_DR50 dsr50_upgraded_zm dsr50_zm wpck_m82a1 ZOMBIE_WEAPON_BARRETM82 barretm82_upgraded_zm barretm82_zm wpck_svuas ZOMBIE_WEAPON_SVU svu_upgraded_zm svu_zm wpck_rpd ZOMBIE_WEAPON_RPD rpd_upgraded_zm rpd_zm wpck_hamr ZOMBIE_WEAPON_HAMR hamr_upgraded_zm hamr_zm grenade ZOMBIE_WEAPON_FRAG_GRENADE frag_grenade_zm ZOMBIE_WEAPON_STICKY_GRENADE sticky_grenade_zm ZOMBIE_WEAPON_CLAYMORE claymore_zm wpck_rpg ZOMBIE_WEAPON_USRPG usrpg_upgraded_zm usrpg_zm wpck_m32 ZOMBIE_WEAPON_M32 m32_upgraded_zm m32_zm ZOMBIE_WEAPON_AN94 an94_upgraded_zm an94_zm wpck_monkey ZOMBIE_WEAPON_SATCHEL_2000 cymbal_monkey_zm wpck_ray ZOMBIE_WEAPON_RAYGUN ray_gun_upgraded_zm ray_gun_zm wpck_knife ZOMBIE_WEAPON_KNIFE_BALLISTIC knife_ballistic_upgraded_zm knife_ballistic_zm sickle knife_ballistic_bowie_upgraded_zm knife_ballistic_bowie_zm knife_ballistic_no_melee_upgraded_zm knife_ballistic_no_melee_zm tazerknuckles ZOMBIE_WEAPON_TAZER_KNUCKLES tazer_knuckles_zm slip ZOMBIE_WEAPON_SLIPGUN slipgun_upgraded_zm slipgun_zm raygun2_included is_true raygun_mark2 ZOMBIE_WEAPON_RAYGUN_MARK2 raygun_mark2_upgraded_zm raygun_mark2_zm maps/zombie/fx_zmb_wall_buy_olympia loadfx olympia_effect _effect maps/zombie/fx_zmb_wall_buy_m16 m16_effect maps/zombie/fx_zmb_wall_buy_taseknuck galvaknuckles_effect maps/zombie/fx_zmb_wall_buy_mp5k mp5k_effect maps/zombie/fx_zmb_wall_buy_bowie bowie_knife_effect maps/zombie/fx_zmb_wall_buy_m14 m14_effect maps/zombie/fx_zmb_wall_buy_ak74u ak74u_effect maps/zombie/fx_zmb_wall_buy_berreta93r b23r_effect maps/zombie/fx_zmb_wall_buy_claymore claymore_effect maps/zombie/fx_zmb_wall_buy_870mcs 870mcs_effect maps/zombie/fx_zmb_wall_buy_an94 an94_effect maps/zombie/fx_zmb_wall_buy_pdw57 pdw57_effect maps/zombie/fx_zmb_wall_buy_svuas svu_effect spawn_list spawnable_weapon_spawns match_string location match_string_plus_space i spawnable_weapon matches j tempmodel clientfieldname numbits target_struct bits unitrigger_stub mins maxs absmins absmaxs bounds targetname weapon_upgrade getstructarray bowie_upgrade arraycombine sickle_upgrade tazer_upgrade buildable_wallbuy headshots_only claymore_purchase scr_zm_map_start_location default default_start_location scr_zm_ui_gametype _   zombie_weapon_upgrade script_noteworthy , strtok script_model spawn origin custom_map building1top angles playchalkfx redroom _wallbuy_override_num_bits int world registerclientfield target getstruct buildable_wallbuy_weapons getminbitcountfornum _idx model spawnstruct setmodel useweaponhidetags getmins getmaxs getabsmins getabsmaxs script_length script_width script_height HINT_NOICON cursor_hint get_weapon_cost cost monolingustic_prompt_format get_weapon_hint hint_string hint_parm1 get_weapon_display_name none missing weapon name  hint_parm2 ZOMBIE_WEAPONCOSTONLY unitrigger_box_use script_unitrigger_type require_look_at require_look_from maps/mp/zombies/_zm_unitrigger unitrigger_force_per_player_triggers is_melee_weapon taser_trig_adjustment weapon_spawn_think register_static_unitrigger claymore_unitrigger_update_prompt prompt_and_visibility_func buy_claymores wall_weapon_update_prompt trigger_stub _spawned_wallbuys delete customwallbuy weapon displayname ammocost fx trig player end_game trigger_radius setcursorhint weapon_no_ammo Hold ^3&&1^7 to buy   [Cost:  ] sethintstring  Ammo:   Upg: 4500] trigger usebuttonpressed can_buy_weapon has_weapon_or_upgrade score maps/mp/zombies/_zm_score minus_to_player_score zmb_cha_ching playsound one_inch_punch_zm oneinchpunchgivefunc weapon_give has_upgrade get_upgrade_weapon ammo_give effect spawnfx triggerfx connected maps/mp/zombies/_zm_weap_ballistic_knife maps/mp/zombies/_zm_weap_claymore common_scripts/utility maps/mp/_utility maps/mp/zombies/_zm_utility maps/mp/zombies/_zm_magicbox maps/mp/gametypes_zm/_weaponobjects maps/mp/gametypes_zm/_weapons maps/mp/zombies/_zm_audio maps/mp/zombies/_zm_melee_weapon maps/mp/zombies/_zm_pers_upgrades_functions maps/mp/zombies/_zm_equipment maps/mp/zombies/_zm_stats maps/mp/zombies/_zm_weap_cymbal_monkey   7  Y  p  �  �  �  �  �  0    7  G  c  �  (  �            
   h'(Y   8   ' (?l ' (?d ' (?\ ' (?T ' (?L ' (?D ? @ Z         ����   ����   ����   ����   ����   ����    ���� ;   -              .       6-            .       6-.     6       &      !  (    _;	 -    / 6-
   .       6       &-
  
   2   
   
   .       6-
  
   2   
   
   .     6-
  
   2   
   
   .     6-
  
   2   
   
   .     6-
  
   2   
   
   .     6-
  
    �   
   
   .     6-
  
   2   
   
   .     6-
  
    �   
   
   .     6-
  
    �   
   
   .     6-
  
   2   
   
   .     6-
  
    �   
   
   .     6-
  
    �   
   
   .     6-
  
    �   
   
   .     6-
  
   2   
   
   .     6-
  
   2   
   
   .     6-
  
    �   
   
   .     6-
  
   2   
   
   .     6-
  
    �   
   
   .     6-
  
   2   
   
   .     6-
  
   2   
   
   .     6-
  
   2   
   
   .     6-
  
   2   
   
   .     6-
  
   2   
   
   .     6-
  
   2   
   
   .     6-
  
   2   
   
   .     6-
  
    �   
   
   .     6-
  
   2   
   
   .     6-
  
   2   
   
   .     6-�
   
   �   
  .     6-�
   
   �   
  .     6-
  
    �   
  .     6-
  
   2   
   
   .     6-
  
   2   
   
   .     6-
  
    �   
   
   .     6-
  
    �   
  .       6-
  
    '   
   
   .       6-
  
   
   
   
   .     6-
  
   
   
   
   .     6-
  
   
   
   
   .       6-
  
   d   
  .       6-
  
   
   
   
   .       6-   .     ; ! -
   
    '   
   
   .     6       &-
   .     
   !  (-
  .     
   !  (-
  .     
   !  (-
  .     
   !  (-
  .     
   !  (-
  .     
   !  (-
  .     
   !  (-
  .     
   !  (-
  .     
   !  (-
  .     
   !  (-
  .     
   !  (-
  .     
   !  (-
  .     
   !  (                                              '(-
  
   .     '(--
   
   .       .     '(--
   
   .       .     '(--
   
   .       .     '(--
   
   .       .     '(-   .       <  --
  
   .       .     '(
  '(    '(
  F> 
   F=    _;    '(    '(
  G; 
   NN'(
  N'('(SH; � '(7   _= 7   
   F= -    .     ;  'A?��7   _9>  7   
   F; S'('A? ��-
  7   .     '('(SH;( F>  F; 	 S'('A? ��'A?H�-^ 
  .       '
('(SH;7    
   N7   N'	('(    _=	    
   F;� 7    
   F;l    {��D� E �AE     `�        N7!  (      �C    7!   (-         �C    7    
   2     6?y 7    
   F;g  {��DqM�D �BE     `�        N7!  (      �C    7!   (-         �C    7    
   2     6?   _=	    
   F;�7    
   F;j   pKE��D ��D     `�        N7!  (      �C    7!   (-         �C    7    
   2     6?q7    
   F;j   `oE ��D ��D     `A        N7!  (      �B    7!   (-         �B    7    
   2     6?� 7    
   F;j   �HE ��D @�D         `A    N7!  (      4C    7!   (-     HA  4C    7    
   2     6?y 7    
   F;g  �eE���D�9�D         `A    N7!  (      4C    7!   (-     HA  4C    7    
   2     6    _;    '(-
   	
   .       6-
   7    .       '(7   
   F;T '(    _; -    SN.       '(-
    �.	
   N
  .       6	7!  ('A? �-7    .       6-.     '(7   7!  (7   7!  (7   
7!  (7   
7!  ('('('('(-7   
0       6-7    
0     6-
0       '(-
0     '(-
0     '(-
0     '(O' ( 	  �>P7!   ( 7!  ( 7!  (7    7   b7    	 ���>PPO7!   (7   7!  (7   7!  (
  7!  (7   
   F;� -7   .       7!  (    _=    9;( -7   .     7!  (7    7!  (?o -7   .     7!  (7    _9>  7   
   F> 7   
   F; 
   7    N7!   (7    7!  (  7!  (7   7!  (
  7!  (7!   (7   _=
 7    ; 	 7!  (7   7!  (	7!   (-.     6-7   .       ; < 7   
   F=    _; 7      N7!   (-     .     6?Q 7   
   F;"      7!  (-       .     6?!        7!  (-       .     67!  ('A? ��!  (-
0     6       	                  
   W_9>  _9>  _9;   _<   �'(-22
   .     '(-
   0     6-           \BN2        6-.       >  -.        ;   -
  N
  NN
   N0      6?% -
  N
  NN
   NN
   N0      6
  U$ %- 0      =  - 0        ; - 0      9=	  7   K;T - 0        6-
    0       6
  F=    _; -     5 6? - 0      6+? � - 0      =   7    �K;> --.      0     ; $ -� 0       6-
    0       6+? @  7   K;4 - 0      ; $ - 0        6-
    0       6+	   ���=+?��           
   F;                _<  -ac   .        '(-.     6
  U$ %-0       6?��       �       �  P        w      `  ]      l  
      �'  S     �)  �     �)   
	  �  
(  �  D	 �  �  P	  �  P(  �  ]	  �  w	  �  �	   l$  �	 ,  �    .  n  �  �    N  N  �  �  �  B  �        R  �	 N  n  �  �  �  N  �  �  .  n  �  �  �  �    .  n  �    "  `  �  �  �  	 .  0  �  �	 f  z  �  �  �  �  �  �      .  B  V  �	 �  �  �  �    H  �	 �  �    "  R  �	 *   �	 t   	 6!  �!  B"  �"  :#  �#  /(  L	 �#  H$  g	 �#  �	 ($  �	  v$  �	 �$  �	 �$  �	  �$  �	  %  �	  %  �	  %  9	 �%  j	 �%  �	 &  O0 �&  t	 �&  <(  �	  &'  x'  �0 .'  ^'  �'  �	  F'  	  T'  	  h'  L	  �'  @*  �	 (  �	 (  �	 K(  �	 m(  �(  	  �(  	  �(  +	 �(  aG �(  p)  �)  �	 �(  �)  �)  �	 %)  �	 9)  �	 V)  �	 ^)  �)  �	 *  �	 .*  �   �   �    �  b  �  j   r   z   �   �  ��  �  �  �   	2     :  Z  z  �  �  �  �  �    :  X  x  �  �  �  �    8  Z  z  �  �  �  �    8  Z  z  �  �  �  �    ,  0  N  n  �  �  �  �    <  \  v  �  
   8&  � "  � &  � *   >   D  & H  9 L  C ^  N d  b h  t l  } ~  � �  � �  � �  � �  � �  � �  � �  � �   �  % �  3 �  ? �  Y �  q �  � �    \  �   �   �   � $  � (  � ,  � >  � D  � H   L   d  . h  @ l  I |  �  Q �  f �  y �  � �  � �  � �  P#  � �  � �  � �  � �   �   �  $ �  8 �  C �  I   [   k   �"  r   | $  � (  � ,  � <  � D  � H  � L  � ^  � d   h   l   ~  ' �  < �  O �  Y �  c �  w �  � �  � �  � �  � �  � �  � �  � �  � �  � �   �     "   4   =   H $  ` (  v ,  � <  � D  � H  � L  � ^  � d  � h  � l  � ~  � �   �   �   �  �  �  ' �  B �  R �  o �  �  � �  � �  @'  � �  � �  � �  �    �   �   �   	    	 8  !	 <  2	 @  L!  X"  :	 R  F	 Z  a	 ^  r	 r  {	 z  �	 ~  �	 �  �	 �  �  �	 �  �  �  �	 �  �	 �  
 �  
 �  0
 �  I
 �  n
 �  �
 �  �
 �  �
 �  �   �!  '  �
   �
   �
   �
   ,   @  ' H  B L  [ P  k d  � n  �#  �r  �  �  �  �  �  �  �    &  :  N  b  *  � x  � �  � �  � �  4!  @"   �  4 �  @ �  b �  u �  � �  8#  � �  � �  � �  � �     '   7   Z "  h ,  � 6  �!  �"  � @  � J  � T  � ^  �n  �p  r  !t  *v  Bx  Dz  U|  ]~  _�  i�  Z$  �&  y�  ��  ��  ��  ��  ��  ��  ��  ��  � �  �  �  �    B  �#  � �  �%  � �  	 �   �  &   
$  8.  �  G F  Yd  s l  {~  �  ��  � �  �   � �  ��  �  �   �   H!  �!  T"  �"  L#  �$  �%  �%  &  X&  �&  �&  �&  �&   '  <'  ��     (   � "   � r   ��   �   0!  x!  �!  "  <"  �"  �"   #  4#  |#  �#  �$  �$  �$  �$  ^%  |%  '  "'  �'   *  ��   �   �!  �!  � �   !  �!   "  �"  #  �#  �$  �$  �$  �$  d%  �'  *   �!  '�#  �#  B �#  6$  F �#  F$  `�#  �%  �%  �$  �%  �%  �%  q$  "$  � B$  �j$  �$  �>%  l%  J%  V%  ! �%  (  -�%  I�%   &  h&  �'  N�%  �%  z�%  x&  �&   &  (&  4&  B&  `&  � F&  � N&  �n&  � r&  ��&  � �&  ��&  �&  �&  �&  �&  �'  '  �P'  t'  -�'  :�'  a�'  �)  h�'  t�'  }�'  *  ��'  ��'  *  � �'  �  (  � Z(  z(  � `(  �(  � h(  � �(  � �(   �(  A�(  H)  �)  w �(  |)  �)  � )  �)  �)  )  ��)   6*  