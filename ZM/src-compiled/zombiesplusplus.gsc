�GSC
       <5    <5  �.  �/  �B  �B  �  @  X        C:/Users/astey/Documents/Black Ops 2 - GSC Studio/Loki's Ragnarok/ZM/src-compiled/zombiesplusplus.gsc zpp_startinit  setplayerstospectator zpp_initserverdvars LRZ2_soloLaststandWeapon default_solo_laststandpistol LRZ2_coopLaststandWeapon default_laststandpistol LRZ2_startWeaponZm start_weapon LRZ2_roundNumber getdvarintdefault round_number LRZ5_customMysteryBoxPriceEnabled custommysteryboxpriceenabled customMysteryBoxPriceEnabled zombie_vars LRZ5_customMysteryBoxPrice custommysteryboxprice customMysteryBoxPrice LRZ5_disableAllCustomPerks disableallcustomperks disableAllCustomPerks LRZ5_enablePHDFlopper enablephdflopper enablePHDFlopper LRZ5_enableStaminUp enablestaminup enableStaminUp LRZ5_enableDeadshot enabledeadshot enableDeadshot LRZ5_enableMuleKick enablemulekick enableMuleKick zpp_checks setmysteryboxprice m1911_zm script zm_tomb c96_zm m1911_upgraded_zm c96_upgraded_zm i chests zombie_cost old_cost dophddive explosionfx disconnect end_game divetoprone isonground hasphd zm_buried divetonuke_groundhit _effect explosions/fx_default_explosion loadfx zmb_phdflop_explo playsound origin playfx kill damagezombiesinrange range what amount enemy zombie _k1 _a1 zombie_team getaiarray distance health dodamage phd_flopper_dmg_check einflictor eattacker idamage idflags smeansofdeath sweapon vpoint vdir shitloc timeoffset boneindex MOD_SUICIDE MOD_FALLING MOD_PROJECTILE MOD_PROJECTILE_SPLASH MOD_GRENADE MOD_GRENADE_SPLASH MOD_EXPLOSIVE playerdamagestub customperkmachine bottle model perkname cost perk angles collision rperks trig player customperknum script_model spawn collision_geo_cylinder_32x128_standard setmodel rotateto Hold ^3F ^7for   [Cost:  ] Custom Perks lowermessage trigger_radius HINT_NOICON setcursorhint setlowermessage trigger usebuttonpressed score PHD_FLOPPER hasperk zmb_cha_ching hide zpp_giveperk show You Already Have  ! iprintln zpp_startcustomperkmachines mapname zm_prison CUSTOM_MAP 0 PHD Flopper p6_zm_al_vending_nuke_on zombie_perk_bottle_deadshot specialty_longersprint Stamin-Up p6_zm_al_vending_doubletap2_on zm_highrise zombie_vending_nuke_on_lo zombie_perk_bottle_whoswho specialty_deadshot Deadshot Daiquiri zombie_vending_revive zombie_vending_doubletap2 zombie_perk_bottle_revive zombie_vending_jugg zombie_perk_bottle_marathon zm_nuked zombie_perk_bottle_jugg specialty_additionalprimaryweapon Mule Kick zombie_vending_sleight zm_transit solo_tombstone_removal tombstone_on turn_tombstone_on machine machine_triggers players _a1718 _k1718 targetname vending_tombstone getentarray target tombstone machine_assets off_model do_initial_power_off_callback set_power_on array_thread on_model vibrate zmb_perks_power_on tombstone_light perk_fx play_loop_on_machine specialty_scavenger_power_on power_on_callback tombstone_off power_off_callback turn_perk_off get_players hasperkspecialtytombstone perk_machine_spawn_init match_string location pos structs _a3578 _k3578 struct tokens _a3583 _k3583 token use_trigger perk_machine bump_trigger scr_zm_map_start_location default default_start_location scr_zm_ui_gametype _perks_ override_perk_targetname getstructarray zm_perk_machine script_string   strtok zm_collision_perks1 precachemodel script_noteworthy trigger_radius_use zombie_vending triggerignoreteam _no_vending_machine_bump_trigs script_activated zmb_perks_bump_bottle script_sound audio_bump_trigger specialty_weapupgrade thread_bump_trigger clip disconnectpaths bump blocker_model script_int turn_on_notify specialty_scavenger specialty_scavenger_upgrade mus_perks_tombstone_jingle tombstone_perk mus_perks_tombstone_sting script_label _custom_perks perk_machine_set_kvps istown zombiemode_using_tombstone_perk give_afterlife_loadout loadout primaries weapon perk_array curgrenadecount takeallweapons getweaponslistprimaries weapons takeweapon name none maps/mp/zombies/_zm_weapons weapondata_give current_weapon setspawnweapon switchtoweaponimmediate get_player_melee_weapon giveweapon equipment maps/mp/zombies/_zm_equipment equipment_give hasclaymore claymore_zm hasweapon set_player_placeable_mine setactionslot claymoreclip setweaponammoclip hasemp emp_grenade_zm empclip hastomahawk current_tomahawk_weapon set_player_tactical_grenade tomahawk_in_use setclientfieldtoplayer maps/mp/zombies/_zm_perks get_perk_array unsetperk set_perk_clientfield keep_perks is_true hadphd specialty_doubletap_zombies drawcustomperkhud perks specialty_quickrevive solo_game flag solo_game_free_player_quickrevive setperk hasstaminup specialty_juggernaut_zombies arrayremovevalue hasmulekick specialty_fastreload_zombies specialty_finalstand give_perk lethal_grenade set_player_lethal_grenade grenade get_player_lethal_grenade getweaponammoclip save_afterlife_loadout currentweapon index getcurrentweapon spawnstruct get_player_weapondata alt_name get_player_equipment equipment_take bouncing_tomahawk_zm upgraded_tomahawk_zm afterlife_save_perks ent zpp_onplayerrevived al_t do_revive_ended_normally fake_revive player_revived whos_who_self_revive waittill_any zpp_onplayerdowned entering_last_stand fake_death player_downed hasdeadshot icon1 destroy icon2 icon3 icon4 gscrestart map_restart no_end_game_check settospectator spawnallplayers spectator sessionstate is_playing spectator_respawn spawnplayer is_classic maps/mp/zombies/_zm refresh_player_navcard_hud �  �  �  (         &-2     6       &
  h!   (
  h!   (
  h!   (-
   .     !  (-
  .     !  (    
   !  (-�
   .       !  (    
   !  (-
   .     !  (    
   !  (-
  .     !  (    
   !  (-
  .     !  (    
   !  (-
  .     !  (    
   !  (-
  .     !  (    
   !  (-.      6       &    F;	 -4     6    
   F>	    
   F; 
   !  (    
   F;	 
   !  (    
   F>	    
   F; 
   !  (    
   F;	 
   !  (    
   F>	    
   F; 
   !  (    
   F;	 
   !  (         ' (    SH; *        7!   (        7!   (' A? ��        
   W
   W   _=    ; � -0     =     _;q    
   F>	    
   F; 
      ' (?  -
  .       ' (-
   0      6-    .       6-
   60        6	  ���>+	  
ף=+?`�                      -    .     '(' ( p'(_;l  '(-7    7   .     H;? 
   F;  -7   7   P0        6? -7   0       6 q'(?��                              
   F> 
   F> 
   F> 
   F> 
   F> 
   F> 
   F;	    _;  - 	
   /6                             
   W   _<
 !  (?    N!   (-
   .       '(-
   0     6-	 ���=0       6-
   .       '(-	0       6-	 ���=0       6-
   N
  NN
   N
  4      6-
   .     '(-
   0     6-
   0     6
  U$ %- 0      = 	  7   K;� 	     �>+- 0       ; � 
   G= - 0        9> 
   F=  7   _9; R -
   0       6 7    O 7!   (-   0       6-
 4     6+-    0     6? -
  N
  N 0      6	  
ף=+?!�        &    F; M
   h
  F=	 
   h
  F;�    F;/ -^ 
     3�E�F)�D �
   
   
   4      6    F;= -        �C    
      -ҩ�q�tŅ�� �
   
   
   4      6?�
   h
  F=	 
   h
  F;�    F;/ -^ 
     ���D�+E�w>E �
   
   
   4      6    F;= -    p�        
      ��fE���D ��D �
   
   
   4      6    F;= -        ��    
        �D  �)�D �
   
   
   4      6?�
   h
  F=	 
   h
  F;�    F;; -  �@        
      �{$E�C  pC �
   
   
   4      6    F;= -    @@  �C    
      ��D���  IC �
   
   
   4      6?%
   h
  F=	 
   h
  F;    F;; -  �@  zC    
       �*D �5D  `� �
   
   
   4      6    F;= -        �C    
       �:D  �C  �B �
   
   
   4      6    F;= -        %C    
       ��  �C  X� �
   
   
   4      6    F;= -        �B    
       @n� �2D  �B �
   
   
   4      6?� 
   h
  F=	 
   h
  F;�    F;; -      �B    
        �� ��E  \� �
   
   
   4      6    F;= -        �B    
       @�� ���     �
   
   
   4      6    F;= -        4C    
       ��D  W�  �� �
   
   
   4      6       &X
   V                      ; �-
  
   .     '(-
   
   .       '('(SH;$ -
     7    0        6'A? ��-
  4        6-    .     6
  U%'(SH;x -
     7    0        6-d^`0       6-
   0        6-
   4        6-4        6'A? �X
  V-      .     6
     7    _; -
     7    .     6
  U%
     7    _; -
     7    .       6-     .     6-.     '('(p'(_; ' ( 7"  q'(? ��? >�                                        
   '(    '(
  G= 
   F=    _;    '(    
   NN'('(    _; -
     .     '(? -
  
   .     '('(p'(_;t '
(
7   _;N -
  
7   .       '	(	'(p'(_;$ '(F;	 
S'(q'(?��? 	 
S'(q'(?��_9>  SF;  -
   .     6'(SH;n7    '(_=  7    _;E-F(7    ^`N
   .     '(
  7!  (7!   (-0     6-7    
   .       '(7   7!  (-7    0       6    _=    ;  '(? O -@#7    
   .     '(7!   (
  7!  (
  7!  (
  G; -4      6-7    
   .     ' (7    7!  (-
    0     6
   7!  (- 0     6 7!   (7!   (7!   (7   _; 7    7!  (7   _; 7    7!  (7   _; 7    7!  (
  F> 
   F;O 
   7!  (
  7!  (
  7!  (
  7!  (
  7!  (
  7!  (_;  
   7!  (    _=     7    _; -     7    /6'A? ��        &    _=    ;  -4       6-2     6-2     6       	                  -0     6    '(-0        '(7    SI>  SI; 0 '(p'(_;  '(-0     6q'(?��'(7   SH; J 7   _<  'A?��
   7   
   F; 'A?��-7    0     6'A? ��-7    7   0       6-7   7   0       6-0        _; --0        0      6-   7   0        67    _= 7   =  -
  0        9;E -
  0      6-
   0        6-
   
   0      6-7   
   0      67    _= 7   ; # -
  0        6-7   
   0      67    _= 7   ; / -    0      6-   0        6-
   0      67    !  (-.       '('(SH;( '(-0       6-0     6'A? ��-    .     ; 9 -    .     ; ) !  ("   -    �?  �>  �?
  4      6    _=    =  7   _=	 7   SI;0'(7   SH; -7    0     ;  'A?��7   
  F=
 -
  .     ;  !  (7    
  F;< -
  0      6!   (-^(
  4      6-
   7   .       6?d�7   
  F;H -
  0      6!   (-     333?    
  4      6-
   7   .       6?�7   
  F; 'A?��-7    .      6'A	   ��L=+?��"  -    7   0        67    I; c ' (--0      0      ;  --0        0      6? --0        0      6-7    N-0      0      6                     -0     '(-0      '(-.       !  (   7!  (   7!  (       7!  (    7!  ('('(p'(_;X '(-.          7!  (F> 
      7   F;    7!  ('Aq'(? ��-0        7!  (    7   _; -    7   0      6-
   0        ; !    7!  (-
   0         7!  (-
   0        ; !    7!  (-
   0         7!  (-
   0        >  -
  0      ;     7!  (-
  0      6-.           7!  (-0        ' (- 0        ;  - 0          7!  (?     7!  (     7!  (-0     6                 -0      '(' ( p'(_;   '(-0      6 q'(?��     &
  W
   W-
  
   
   
   
   0      6+-    .     ; 8 -
  0      6!   ("   -  �?  �>  �?
  4      6?  ?��        &
  W
   W-
  
   
   0      6-
   0        6-
   0        6-
   0        6"   "  "  "  -    0       6"   -    0       6"   -    0       6"   -    0       6"   	 
ף=+?P�        &
  U%+-.       6           !  (+-.      '(' ( SH;   F;  ' A- 0      6' A? ��+-.       6       &
  !  (    _; !   (           -.        '(' ( SH;d  7    
   F=  7    _;= -    1 6    
   G>	    
   G> -.        9;	 -2      6' A? ��!   (       �       (  �       L  Z        e      T  �        �     �       <  �       �      |  �	      �  �	      d!  `       %  r      T%  �      �)  �      ,  K     h,  d      �,  �      �-  ?      �-  �       $.  h      D.  w  � �     w�  N  ^  �  �  �  �    "  Z�   =  e�   Z  �   v  f�  �  �  �  �  o   ��  �  ��  �  ��  "  ��  R  ��  {  �  n�  �  �  #  ��  �  �  �  ?   D#  �#  ��  �  �  ��  �  n�    �"  z#  ��    �  .  #�   A  d  F�    Z(  \�   �  a�  �  n�   �  ��    ��  q  �    U  �  �  E  �  �  5  }  �  %  m  
�  �  �  S
�  �  q
�      �   ~
�     �   �
�  \   �
�  �   �
�   �   ~
�  �   !  !  ,�   !  :�   &!  �-  K.  ]�  �!  �!  ��  ("  ��  �"  ��   #  w�   �#  n�  �#  ��   �#  `�   4%  �	�   >%  �	�   F%  ��   j%  ��   {%  *  �  �%  D( &  c�  <&  r�  T&  ��   _&  o&  ��  y&  �&  '  U'  �)  �� �&  ��  �&  �)  +  7+  k+  }+  �+  �  �&   �  �&  ;�  �&  1'  �)  ��  c'  ��  u'  �+  �� �'  ��  �'  M,  -  -  /-  �  �'  %�  �'  �'  �,  P�  (  �(  )  �,  ��  ~(  ��  �(  �(  �,  ��  �(  ()  /� U)  H�  {)  ,  j�   �)  �)  �)  �)  �+  ��  �)  !+  U+  �+  ��   *  ��   $*  �( �*  ��   �*  � �*  K�  �+  ��  %,  ��  �,  ��  -  %�   P-  d-  x-  �-  J�  �-  h�   .  w�   .  ��   �.  ��  �.  �  *  � 0  �  �  �     4  .:  �  �  �  �  F >  YD  d  p  �  �  f L  �V  � \  �f  l  P  � p  �t  �  �  �  �    8  � ~  �  �  &  8  / �  E �  `�  �     v �  � �  ��  �  B  �  �  j  �  � �  � �  ��  �  |  `  �  � �  �    

        �  �     (    <*  0  @  0  K 4  �  h  �  �  �!  �!  x t  |  �  �  ��  �  �  �  �  �.  �.  � �  �  �  �  �.  � �  �  � �  �  �   �  �  |!  `%  �-  H.  �  ,  >  �2  �D  �V  � Z  j,  �,  � `  V  p,  �,  �-  f  n  �    �  �'  �,  <-   �  �  ) �  >�  F �  m �  �
�  J  P  n  �  F  �"  #  t#  �#  � �  b  �  �  �  �  �  �  \%  *  ,  �  ^%  *  ,  �   �t  �  )�  3�  ;�  C�  Q�  Y�  `�  e�  m�  x�  � �  � �  � �  � �  � �  � �  �   �0  >  @  �"  @#  B  %D  *H  ~!  d%  ,  /J  .#  4#  �#  �#  6L  �!  @N  GP  �  �  LR  �  8*  S\  f  n  v  a ~  �  #  �#  t �  � �  � �  � �  � �  (  �   x#  �    6  4P  �  �  �'  �'  H*  P*  : t  �  N  �  �  �  �  �,  N �  s �  � �  � *  �  �  R  �  � .  �.  � 6  �  �  ^  �  � :  �  �  b  �  � f    �  �  �  � j  � n  �   �  z    �(  �(  �(  -  # �  �  *  - �  L �  X   r 
  R  � 2  "  �    ,-  � J  :  �    � N  >  �    � �  .  � �  �  2  �  � �  �  �  	 �  B  ,	 V  5	 �  z  "  j  M	 Z  J  �(  �(   )  -  o	 r  b  y	 v  f  �	 �  �	 �     �	�  $  �	�  �	�  �-  F.  �	�  �	�   
 �  �!  �!  
 �  �  �$  �$  )
 �  0
 �  �  .   �   �   �   �   :
�  2   �   �   �   !  I
�  �
8   �
 h   �
 |   �
 �   �
�   �    �   �   !  FL!  xf!  �h!  �j!  �l!  �n!  �p!  �r!  �t!  �v!  �x!  �z!  ��!  ��!  ��!  ��!  
 �!  �!  �!  )�!  < �!  D�!  �!  l �!  |"  &"  �$  �$  �$  �  "  � �"  �#  ��"   #  �#  � �"  � �"   
�"  �#  �$  �P#  X#  �#  + �#  A�#  �$  N �#  a �#  � �#  �$  �$  �&$  4$  :$  �D$  R$  X$  �b$  p$  v$  � |$  � �$  � �$   �$  �$  �$  ' �$  A�$  )
�$  N�$  �$  %  \�$  %  y$%  ,%  �V%  t%  �&  t)  .*  4*  >*  L*  X*  �*  �*  �*  �*  �*  �*  +  *+  H+  ^+  �+  �+  �+  �+  �+  �X%  �)  �Z%  *  �b%  ,  �f%  
�%  �%  �%   &  &  8&  P&  B*  �*  �*   �%  # &  T2&  J&  \*  �*  ��&  �*  �*  �*  ��&  �&  +  � �&  �&  �&  �&  �&   +  +  � �&  .�&  .+  M'  '  L+  T '  .'  4+  R+  c*'  b+  k>'  H'  �+  wR'  `'  � r'  �+  �'  (   (  n)  -�'  �'  �,  �,  4 
(  �,  b*(  4(  F(  V(  p(  �(  �(  �(  &)  :)  R)  �+  h t(  ~ |(  ��(  ��(  D-  � �(  ��(  @-  � )   >)  9x)  
*   ,  b�)  �)  �+  �+  � *  �*  � �*  ! h+  6 z+  `,  x v,  } z,  � ~,  � �,  � �,  � �,  � �,   �,  H-  N-  \-  -b-  p-  3v-  �-  9�-  �-  V�-  �.  � &.  p.  �*.  l.  �0.  :.  �~.  ��.  