�GSC
     H  )  �  )  %  e%  �3  �3  u  @ �  8        C:/Users/astey/Documents/Black Ops 2 - GSC Studio/GSC Fast Compiler/Custom Maps 1/remix/src/scripts/zm - compiled/zm_tomb/bsm_tomb_weapons.gsc main extmapcheck xmapcheck CUSTOM_MAP 0 1 2 3 4 5  init_spawnable_weapon_upgrade maps/mp/zombies/_zm_weapons replacefunc init_weapons precacheeffectsforweapons custom_add_weapons _zombie_custom_add_weapons zombie_teddybear precachemodel c96_zm laststandpistol default_laststandpistol c96_upgraded_zm default_solo_laststandpistol start_weapon wpck_mg ZOMBIE_WEAPON_MG08 mg08_upgraded_zm mg08_zm add_zombie_weapon ZOMBIE_WEAPON_HAMR hamr_upgraded_zm hamr_zm wpck_rifle ZOMBIE_WEAPON_TYPE95 type95_upgraded_zm type95_zm ZOMBIE_WEAPON_GALIL galil_upgraded_zm galil_zm ZOMBIE_WEAPON_FNFAL fnfal_upgraded_zm fnfal_zm ZOMBIE_WEAPON_M14 m14_upgraded_zm m14_zm ZMWEAPON_MP44_WALLBUY mp44_upgraded_zm mp44_zm ZOMBIE_WEAPON_SCAR scar_upgraded_zm scar_zm wpck_shotgun ZOMBIE_WEAPON_870MCS 870mcs_upgraded_zm 870mcs_zm ZOMBIE_WEAPON_SRM1216 srm1216_upgraded_zm srm1216_zm ZOMBIE_WEAPON_KSG ksg_upgraded_zm ksg_zm wpck_smg ZOMBIE_WEAPON_AK74U ak74u_upgraded_zm ak74u_zm ak74u_extclip_upgraded_zm ak74u_extclip_zm ZOMBIE_WEAPON_PDW57 pdw57_upgraded_zm pdw57_zm ZMWEAPON_THOMPSON_WALLBUY thompson_upgraded_zm thompson_zm ZOMBIE_WEAPON_QCW05 qcw05_upgraded_zm qcw05_zm ZOMBIE_WEAPON_MP40 mp40_upgraded_zm mp40_zm mp40_stalker_upgraded_zm mp40_stalker_zm ZOMBIE_WEAPON_EVOSKORPION evoskorpion_upgraded_zm evoskorpion_zm wpck_snipe ZMWEAPON_BALLISTA_WALLBUY ballista_upgraded_zm ballista_zm ZOMBIE_WEAPON_DR50 dsr50_upgraded_zm dsr50_zm wpck_pistol ZOMBIE_WEAPON_BERETTA93r beretta93r_upgraded_zm beretta93r_zm beretta93r_extclip_upgraded_zm beretta93r_extclip_zm ZOMBIE_WEAPON_KARD kard_upgraded_zm kard_zm ZOMBIE_WEAPON_FIVESEVEN fiveseven_upgraded_zm fiveseven_zm ZOMBIE_WEAPON_PYTHON python_upgraded_zm python_zm ZOMBIE_WEAPON_C96 wpck_duel ZOMBIE_WEAPON_FIVESEVENDW fivesevendw_upgraded_zm fivesevendw_zm wpck_crappy ZOMBIE_WEAPON_M32 m32_upgraded_zm m32_zm wpck_explo ZOMBIE_WEAPON_BEACON beacon_zm ZOMBIE_WEAPON_CLAYMORE claymore_zm wpck_monkey ZOMBIE_WEAPON_SATCHEL_2000 cymbal_monkey_zm ZOMBIE_WEAPON_FRAG_GRENADE frag_grenade_zm wpck_ray ZOMBIE_WEAPON_RAYGUN ray_gun_upgraded_zm ray_gun_zm raygun2_included wpck_raymk2 ZOMBIE_WEAPON_RAYGUN_MARK2 raygun_mark2_upgraded_zm raygun_mark2_zm ZOMBIE_WEAPON_STICKY_GRENADE sticky_grenade_zm wpck_rpg AIR_STAFF staff_air_upgraded_zm staff_air_zm FIRE_STAFF staff_fire_upgraded_zm staff_fire_zm LIGHTNING_STAFF staff_lightning_upgraded_zm staff_lightning_zm WATER_STAFF staff_water_upgraded_zm staff_water_zm staff_water_zm_cheap ZM_TOMB_WEAP_STAFF_REVIVE staff_revive_zm change_weapon_cost weapons_using_ammo_sharing add_shared_ammo_weapon maps/zombie_tomb/fx_tomb_perk_one_inch_punch loadfx oneinchpunch_effect _effect spawn_list spawnable_weapon_spawns match_string location match_string_plus_space i spawnable_weapon matches j tempmodel clientfieldname numbits target_struct bits unitrigger_stub mins maxs absmins absmaxs bounds targetname weapon_upgrade getstructarray bowie_upgrade arraycombine sickle_upgrade tazer_upgrade buildable_wallbuy headshots_only is_true claymore_purchase scr_zm_map_start_location default default_start_location scr_zm_ui_gametype _   zombie_weapon_upgrade script_noteworthy , strtok custom_map trenches staff_soul One Inch Punch one_inch_punch_zm customwallbuy crazyplace script_model spawn origin _wallbuy_override_num_bits int world registerclientfield target getstruct buildable_wallbuy_weapons getminbitcountfornum _idx model spawnstruct angles setmodel useweaponhidetags getmins getmaxs getabsmins getabsmaxs script_length script_width script_height HINT_NOICON cursor_hint get_weapon_cost cost monolingustic_prompt_format get_weapon_hint hint_string hint_parm1 get_weapon_display_name none missing weapon name  hint_parm2 ZOMBIE_WEAPONCOSTONLY unitrigger_box_use script_unitrigger_type require_look_at require_look_from maps/mp/zombies/_zm_unitrigger unitrigger_force_per_player_triggers is_melee_weapon tazer_knuckles_zm taser_trig_adjustment weapon_spawn_think register_static_unitrigger claymore_unitrigger_update_prompt prompt_and_visibility_func buy_claymores wall_weapon_update_prompt trigger_stub _spawned_wallbuys delete weapon displayname ammocost fx trig player end_game trigger_radius setcursorhint playchalkfx weapon_no_ammo Hold ^3&&1^7 to buy   [Cost:  ] sethintstring  Ammo:   Upg: 4500] trigger usebuttonpressed can_buy_weapon has_weapon_or_upgrade score maps/mp/zombies/_zm_score minus_to_player_score zmb_cha_ching playsound oneinchpunchgivefunc weapon_give has_upgrade get_upgrade_weapon ammo_give effect spawnfx triggerfx connected maps/mp/zm_tomb_utility maps/mp/zombies/_zm_weap_ballistic_knife maps/mp/zombies/_zm_weap_claymore common_scripts/utility maps/mp/_utility maps/mp/zombies/_zm_utility maps/mp/zombies/_zm_magicbox maps/mp/gametypes_zm/_weaponobjects maps/mp/gametypes_zm/_weapons maps/mp/zombies/_zm_audio maps/mp/zombies/_zm_melee_weapon maps/mp/zombies/_zm_pers_upgrades_functions maps/mp/zombies/_zm_equipment maps/mp/zombies/_zm_stats maps/mp/zombies/_zm_weap_cymbal_monkey |  �  �  �  �    #  @  d  �  �  �  �  �  �       !          
   h'(Y   8   ' (?l ' (?d ' (?\ ' (?T ' (?L ' (?D ? @ Z         ����   ����   ����   ����   ����   ����    ���� ;   -              .       6-            .       6-.     6       &      !  (    _;	 -    / 6-
   .       6       &
  !  (
  !  (
  !  (
  !  (-
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
    �   
   
   .       6-
  
    x   
   
   .       6-
  
   2   
   
   .     6-
  
    �   
   
   .       6-
  
   2   
   
   .     6-
  
    L   
   
   .       6-
  
    �   
   
   .       6-
  
    �   
   
   .       6-
  
    �   
   
   .       6-  
   
    �   
   
   .       6-
  
   2   
   
   .     6-
  
       
   
   .       6-
  
       
   
   .       6-
  
   2   
   
   .     6-
  
    �   
   
   .       6-
  
   2   
   
   .     6-
  
    �   
   
   .       6-
  
    �   
   
   .       6-
  
   2   
   
   .     6-
  
    L   
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
   .     6-
  
    �   
  .       6-
  
    �   
  .       6-
  
    �   
  .       6-�
   
   �   
  .     6-
  
    '   
   
   .       6    _=    ; # -
   
    '   
   
   .       6-�
   
   �   
  .     6-
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
   2   
  .     6-
  
   2   
  .     6- 
   .     6!   (-
   
   .     6-
   
   .     6-
   
   .     6       &-
   .     
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
  7   .     '('(SH;( F>  F; 	 S'('A? ��'A?H�   _=	    
   F;2 -
  ^    +.�R�E ��� � p
   
   2       6?A    _=	    
   F;- -
  ^   �!F �� ��� � p
   
   2       6-^ 
   .       '
('(SH; 7    
   N7   N'	('(    _;    '(-
   	
   .       6-
   7    .       '(7   
   F;T '(    _; -    SN.       '(-
    �.	
   N
  .       6	7!  ('A? /�-7    .       6-.     '(7   7!  (7   7!  (7   
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
  U$ %-0       6?��     �  �       h  H      �  o      �  U      �        l"  ]     �$  2     �$  &   (     0  < 8  P  H  B  H   H  U  Z  o  i  � �  $  Y' �  �    6  V  x  �  �  �    $  H  l  �  �  �  �     B  d  �  �  �  �    2  R  r  �  �  �  �  0  �  �  �      :  Y   d  �  �
 J  �
 b  r  �  	 �   �  �    8  X  �  7   "  B  b  �  � p  &   j  ] �  ,  � <  � �     � �  � �    .  ' �  0 �  B  �  J  �  R  �  ]  �  � |   � �    �   �� �!  � �!  �"    �!  0"  /� �!  "  :"  J  �!  �  "  �   "  �  ^"  �$  � �"   �"  & �"  2 #  a %#  M#  �  a#  �  o#  � �#  �� �#  ($  k$   �#  8$  |$  $ �#  0 �#  < $  O $  Y$  ` �$  h �$  � �  � �  �  �  �  �  �  �  �  �  �    �  
  �    �r  x  �  � �  � �  �  �  P  ��  ��  � �  L  ��  �  / �  �    "  B  b  �  �  �  �    2  V  z  �  �  �  
  .  N  r  �  �  �  �    >  ^  ~  �  �  �  �    N  r  �  �  �  �    *  �  �  �  J  �   % �  �  - �  @ �  Q �  k �  ~ �  � �  �   &  F  f  �  �  �   �   �   � ,  � 0  � 4   L   P  ) T  2 n  D r  T v  [ �  q �  � �  � �  � �  � �  � �  �    � �  � �  � �  � �   �      *   <   L "  S 6  Z  ~  �  �  �    2  \ >  b  p B  � F  \  � f  � j  `  � �  � �  � �  � �  � �   �    �  4 �  F �  O �    b �  s �  H  l  {   �   p  � 8  � <  � @  � R  v  � Z  
 ^   b  + |  > �  P �  Y �  �  �  �  "  B  e �  �  ~ �  � �  |  � �  � �  �  � �  � �  � �      
  2   ? (  T ,  g 0  q H  � b  � h  � l  � p  � �  � �  � �  � �   �  �    v   �  # �  - �  D �  �!  P �  \ �  w �  �   �   �   � &  � *  � .  �<  D  	 R  	 Z  (	 ^  A	 b  Q	 |  n	 �    �	 �  �  �  �    .  �	 �  �	 �  �	 �  �	 �  �	 �  �	 �  �	 �  �	 �  
 �  %
 �    1
 �  I
    X
   m
 4  �
 8  �
V  �
 �   �  $�  �$  ,�  7�  O�  \�  e�  }�  �  ��  ��  ��  ��    �!  ��  ��  ��  ��  ��  ��  ��  ��  ��    �  �    2  R  �  �   �  l   ) �  D   S 6  a V  �  sn  $  � �  ��  � �  ��  �  ��  � �  `  � �  �    \  �  z   �   �   !  :!  �!  �!  �!  �!  �!  :  F  h   b  �  �  �  �  ( �  1 �  
  < �  &  K �  *  �#  �$  k   v :  �j  >  D  ^  d     4   �!  �!  v"  �$  �x  �  � �  �  � �  �  ��  >   D    �  N   T   h   ��  �  	 �  "  �   N  T  n  t     x"  �$  h�  $   v   �   � X   �"  �^   ��   �    !  r"  ��   �   ��   0!  ��   �   �   �   �   !   �    !  3&!  > *!  @!  T D!  gJ!  ~T!  �^!  l!  x!  � �!  �!  �!  l"  ,"  �J"  �X"  �n"  �$  �p"  �t"  �z"  �$  �|"  �~"  �$    �"  	 �"  A #  2#  V #  8#  _  #  o @#  w H#  � V#  ��#   $  L$  � �#  4$  x$  �#  �#  Y�$  r �$  