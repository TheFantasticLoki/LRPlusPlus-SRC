�GSC
     �  �    �  �  �  $  $  �  @ �  0        C:/Users/astey/Documents/Black Ops 2 - GSC Studio/GSC Fast Compiler/Custom Maps 1/remix/src/scripts/zm - compiled/zm_prison/bsm_prison_weapons.gsc main extmapcheck xmapcheck CUSTOM_MAP 0 1 2 3 4 5  init_spawnable_weapon_upgrade maps/mp/zombies/_zm_weapons replacefunc precacheeffectsforweapons maps/zombie/fx_zmb_wall_buy_olympia loadfx olympia_effect _effect maps/zombie/fx_zmb_wall_buy_m16 m16_effect maps/zombie/fx_zmb_wall_buy_taseknuck galvaknuckles_effect maps/zombie/fx_zmb_wall_buy_mp5k mp5k_effect maps/zombie/fx_zmb_wall_buy_bowie bowie_knife_effect maps/zombie/fx_zmb_wall_buy_m14 m14_effect maps/zombie/fx_zmb_wall_buy_ak74u ak74u_effect maps/zombie/fx_zmb_wall_buy_berreta93r b23r_effect maps/zombie/fx_zmb_wall_buy_claymore claymore_effect maps/zombie/fx_zmb_wall_buy_thompson thompson_effect maps/zombie/fx_zmb_wall_buy_870mcs 870mcs_effect spawn_list spawnable_weapon_spawns match_string location match_string_plus_space i spawnable_weapon matches j tempmodel clientfieldname numbits target_struct bits unitrigger_stub mins maxs absmins absmaxs bounds targetname weapon_upgrade getstructarray bowie_upgrade arraycombine sickle_upgrade tazer_upgrade buildable_wallbuy headshots_only is_true claymore_purchase scr_zm_map_start_location default default_start_location scr_zm_ui_gametype _   zombie_weapon_upgrade sticky_grenade_zm script_noteworthy , strtok script_model spawn origin custom_map docks 870mcs_zm angles playchalkfx m14_zm rottweil72_zm rooftop thompson_zm mp5k_zm _wallbuy_override_num_bits int world registerclientfield target getstruct buildable_wallbuy_weapons getminbitcountfornum _idx model precachemodel spawnstruct setmodel useweaponhidetags getmins getmaxs getabsmins getabsmaxs script_length script_width script_height HINT_NOICON cursor_hint get_weapon_cost cost monolingustic_prompt_format get_weapon_hint hint_string hint_parm1 get_weapon_display_name none missing weapon name  hint_parm2 ZOMBIE_WEAPONCOSTONLY unitrigger_box_use script_unitrigger_type require_look_at require_look_from maps/mp/zombies/_zm_unitrigger unitrigger_force_per_player_triggers is_melee_weapon tazer_knuckles_zm taser_trig_adjustment weapon_spawn_think register_static_unitrigger claymore_zm claymore_unitrigger_update_prompt prompt_and_visibility_func buy_claymores wall_weapon_update_prompt trigger_stub _spawned_wallbuys delete customwallbuy weapon displayname ammocost fx trig player end_game trigger_radius setcursorhint weapon_no_ammo Hold ^3&&1^7 to buy   [Cost:  ] sethintstring  Ammo:   Upg: 4500] trigger usebuttonpressed can_buy_weapon has_weapon_or_upgrade score maps/mp/zombies/_zm_score minus_to_player_score zmb_cha_ching playsound one_inch_punch_zm oneinchpunchgivefunc weapon_give has_upgrade get_upgrade_weapon ammo_give effect spawnfx triggerfx connected maps/mp/zombies/_zm_weap_ballistic_knife maps/mp/zombies/_zm_weap_claymore common_scripts/utility maps/mp/_utility maps/mp/zombies/_zm_utility maps/mp/zombies/_zm_magicbox maps/mp/gametypes_zm/_weaponobjects maps/mp/gametypes_zm/_weapons maps/mp/zombies/_zm_audio maps/mp/zombies/_zm_melee_weapon maps/mp/zombies/_zm_pers_upgrades_functions maps/mp/zombies/_zm_equipment maps/mp/zombies/_zm_stats maps/mp/zombies/_zm_weap_cymbal_monkey '  P  r  �  �  �  �  �    +  /  P  `
  |  �  $  �           
   h'(Y   8   ' (?l ' (?d ' (?\ ' (?T ' (?L ' (?D ? @ Z         ����   ����   ����   ����   ����   ����    ���� ;   -              .       6-.     6       &-
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
('(SH;7    
   N7   N'	('(    _=	    
   F;Z7    
   F= 7      @D �F `�DF;Y      �� ��E  .B7!   (       A    7!   (-         >C    7    
   2     67   
   F;W   @�C @�E ��C7!   (      ��    7!   (-         ��    7    
   2     67   
   F;W   @1� ȲE  ��7!   (      ��  �A7!   (-         ��  �A7    
   2     6?�   _=	    
   F;�7    
   F;W   EE FF ��D7!   (      �B    7!   (-         �B    7    
   2     67   
   F;W   x@E 8F ��D7!   (      �B    7!   (-         �B    7    
   2     67   
   F;?   �E JF ��D7!   (^ 7!  (-^ 7    
   2       67   
   F;W   �:E �F ��D7!   (      4C    7!   (-         4C    7    
   2     6    _;    '(-
   	
   .       6-
   7    .       '(7   
   F;T '(    _; -    SN.       '(-
    �.	
   N
  .       6	7!  ('A? #�-7    .       6-.     '(7   7!  (7   7!  (7   
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
  U$ %-0       6?��     $  �       �  L      �          l	     8  �	     P  �   �  $  �  @ �  L  �  � �  �    "  6  J  ^  r  �  �  �  � �    0  P  p  �  �   :  Z  z  �  � �  >  � �  � �  � �    j  �  R  �  
  �  9 0  �  T H  x |  � �  �  �  � ,  � B  �  L  �  Z  �  f  �  r  4   e B  � j  J+ 6  o D  �  �  z  �  �+ �  �  �  �  �  	  �  ,	  �  e	  �  �  � V  �	 f  �	 �  �	 �  �  $
  �  5
    D
   z
`
 ;  �    �
 L  �    �
 y  �
 �  �
 �  �
 �  �   s   �  � &  � (  �  ,  �  z  �  �  �  �  �  �   �   �  f �  � �  h  P  ��      .  B  V  j  ~  �  �  �  p  � �  �   �   �       / *    ; 4  ] >  p H  � R     �  � \  � f  � p  � z  � �  " �  2 �  W �  �  g �  � �  �  ��  ��  ��  ��  ��  ��  ��  ��  �  �  �  �  .   �  (�  6�  ;�  K�  P�  U�  ]�  e�  l �  
  *  J  j  �  <  w �    �   � .  � N  � n  ^  ��  <  � �   �  �  �  b  �  �  " �  *�  �  A�  T �  �  V   X$  .  �  "  �    �  �  `  �  >    @  h  �  �    $  B  T  �  n 2  �R  ^  �  � z  � �  ��  4  `  �  �  �  0  d  �  �    L  �  �  �    �  �  �     �  �  j  v    T  �    v  ~  �   � &  �x  �  H  �  0  �  �  �  �  
    �    V  � �  �  �   �  � �    d   �      / $  �  3 .  �  MF  �  �  lZ  �  �    ^l  v  � �  ��  (  ��  �  �  �   �  b  (�  D$  T  �    I*  2  uL  �  �Z  t  |  �  �  �  � �  � �  ��  � �  w�  � �  ��  	�  �       X  �`  n  � �  	�  �  F	�  S	�  z	
  :  �	  �	  �	  X  �	  �	  Z  �	   �	 T  �	 �  �  �	 �  �  �	 �  
 �  
 �  
 �  Z
,  �  �  �
 H  �    �
 X  @  �
`  l  R   �  