�GSC
       #  6  #  �  m  �*  �*  �  @ �  6        C:/Users/astey/Documents/Black Ops 2 - GSC Studio/GSC Fast Compiler/Custom Maps 1/remix/src/scripts/zm - compiled/bsm_wunderfizz.gsc init extmapcheck xmapcheck CUSTOM_MAP 0 1 2 3 4 5  setupwunderfizz wunderfizzuserandomstart player wunderfizzChecksPower getdvarintdefault wunderfizzcheckspower wunderfizzCost wunderfizzcost wunderfizzUseRandomStart wunderfizz_locations currentwunderfizzlocation custom_map trenches maps/zombie_tomb/fx_tomb_dieselmagic_on loadfx wunderfizz_loop _effect p6_zm_vending_diesel_magic wunderfizzsetup connected chooselocation wunderfizzMove crazyplace house zombie_vending_jugg rooftop p6_zm_al_vending_jugg_on redroom getperkmodel perk specialty_armorvest script zm_prison specialty_nomotionsensor p6_zm_vending_vultureaid specialty_rof p6_zm_al_vending_doubletap2_on zombie_vending_doubletap2 specialty_longersprint zombie_vending_marathon specialty_fastreload p6_zm_al_vending_sleight_on zombie_vending_sleight specialty_quickrevive p6_zm_vending_electric_cherry_on zombie_vending_revive specialty_scavenger zombie_vending_tombstone specialty_finalstand p6_zm_vending_chugabud specialty_grenadepulldeath specialty_additionalprimaryweapon p6_zm_al_vending_three_gun_on zombie_vending_three_gun specialty_deadshot p6_zm_al_vending_ads_on zombie_vending_ads specialty_flakjacket p6_zm_al_vending_nuke_on zm_highrise zombie_vending_nuke_on_lo getperkbottlemodel t6_wpn_zmb_perk_bottle_jugg_world t6_wpn_zmb_perk_bottle_doubletap_world t6_wpn_zmb_perk_bottle_marathon_world t6_wpn_zmb_perk_bottle_vultureaid_world t6_wpn_zmb_perk_bottle_sleight_world t6_wpn_zmb_perk_bottle_nuke_world t6_wpn_zmb_perk_bottle_revive_world t6_wpn_zmb_perk_bottle_tombstone_world t6_wpn_zmb_perk_bottle_chugabud_world t6_wpn_zmb_perk_bottle_cherry_world t6_wpn_zmb_perk_bottle_mule_kick_world t6_wpn_zmb_perk_bottle_deadshot_world origin angles model collision wunderfizzmachine wunderfizzbottle perks cost trig script_model spawn collision_geo_cylinder_32x128_standard setmodel rotateto tag_origin bottle location uses getperks trigger_radius HINT_NOICON setcursorhint wunderfizz rtime wunderfx perkforrandom perklist j perkname fx time end_game disablebsmmagic is_true Magic is disabled sethintstring playlocfx zm_nuked Power Must Be Activated First power_on flag_wait   j_ball showpart Hold ^3&&1^7 to buy Perk-a-Cola [Cost:  ] trigger usebuttonpressed score isdrinkingperk num_perks get_player_perk_purchase_limit wunderfizzsounds zmb_cha_ching playsound spawnfx triggerfx perk_bottle_motion randomint hasperk maps/mp/zombies/_zm_perks has_perk_paused zm_tomb done_cycling randomintrange t6_wpn_zmb_perk_bottle_bear_world zombie_teddybear wunderSpinStop delete Wunderfizz is Moving array_randomize getperkname electriccherry _on tombstone_light Hold ^3&&1^7 for  distance can_buy_weapon giveperk You Have All   Perks You Can Only Hold ^3 ^7 Perks Wunderfizz Orb is at Another Location hidepart current_weapon is_drinking hacker_active isswitchingweapons getcurrentweapon is_placeable_mine is_equipment_that_blocks_purchase in_revive_trigger none lght_marker currloc loc putouttime putbacktime v_float moveto rotateyaw sound_ent script_origin stopsounds zmb_rand_perk_start zmb_rand_perk_loop playloopsound stoploopsound zmb_rand_perk_stop gun evt perk_give_bottle_begin weapon_change_complete player_downed death fake_death waittill_any_return wait_give_perk perk_give_bottle_end maps/mp/zombies/_zm_laststand player_is_in_laststand intermission burp scripts/zm/bsm_main maps/mp/_utility common_scripts/utility maps/mp/zombies/_zm_utility   
  �  �  �              
   h'(Y   8   ' (?l ' (?d ' (?\ ' (?T ' (?L ' (?D ? @ Z         ����   ����   ����   ����   ����   ����    ���� ;   -2       6           -
  .       !  (- �
   .     !  (-
  .     '(!  (;
 !   (? !  (    _=	    
   F;� -
  .       
   !  (-
        ��C        �AD E'1��.       6-
   ^    ��|� �gE ��.       6-
          �C        �9E쉧E ��.       6;& 
   U$ %+-    .       !  (X
   V? �   _=	    
   F;0 -
           xB       �� F=V�� ���.       6?L   _=	    
   F;\ -
           �B        p�E p�E  ��.       6;& 
   U$ %+-    .       !  (X
   V? �    _=	    
   F;\ -
           �B       =�HE��F  �D.       6;& 
   U$ %+-    .       !  (X
   V? l    _=	    
   F;X -
       H��̬@       �K\E{��D ��D.       6;& 
   U$ %+-    .       !  (X
   V           
   F;    
   F; 
   ? 
    
  F; 
    
  F;    
   F; 
   ? 
    
  F; 
    
  F;    
   F; 
   ? 
    
  F;    
   F; 
   ? 
    
  F; 
    
  F; 
    
  F; 
    
  F;    
   F; 
   ? 
    
  F;    
   F; 
   ? 
    
  F;-    
   F; 
   ?    
   F; 
   ? 
             
   F; 
    
  F; 
    
  F; 
    
  F; 
    
  F; 
    
  F; 
    
  F; 
    
  F; 
    
  F; 
    
  F; 
    
  F; 
    
  F; 
          	                  !  A-
   .       '(-
   0     6-	 ���=0       6-
   .       '(-0       6-	 ���=0       6-
   .       '(-
   0     67!   (7    7^`N7!  (7!   (    7!  (7!  (-.     '(    '(-22
   .       ' (-
    0     6- 4     6                                       
   W-    .     ;  -
  
0     6 -4       6    = 	    
   G=	    
   G;. -
  
0       6-
   .     6-
   
0       6? -
  
0     6       F;�-
  0        6-
   N
  N
0        6
  
U$%-0      = 	 7   K= 7   F; )7   -0      H;�7   SH; �-4       6-
   0       6!   A7    O7!   (-
   
0       6'(-ac    
      .        '(-.     6-4        6	  ���=+I;� -S.       '(-0        >  -0      < D    
   F;  --.          0       6?  ?  --.       0      6? ? ��   
   F;$ -.        6	  ��L>+	��L>O'(?  	   ���=+	���=O'(? 5�X
  V   -.        K=    I;   
   F;� -
     0     6    
   G; -
  0        6X
   V-0        6+-
     0       6-   .     !  (X
   V-0       6!  (?? � -
  0        6      ��    N!   (-0     67    N7!   (-
   
0     6+-    .     !  (X
   V!  (-0        6!  (?�? -.      '('(SH;�-0       >  -0        < �-.     '(    
   F;  --.           0       6?�    
   F;: --.        0      6-ac
      .        '(?9 --.      
   N0     6-ac
      .        '(-.     6-
   N
0        6' ( I; n -0      =  -
7    7   .     AH=
 -0      ;  -4       6?$ -.        6	  ��L>+ 	��L>O' (? ��-0       6-
      0     6-
   
0       6X
   V-0        6? 'A?1�-0      6+-
  N
  N
0      6?1 -
  SN
   N
0        6+-
  N
  N
0      6?9 -
  -0        N
  N
0        6+-
  N
  N
0      6	  ���=+?��? # -
  
0     6-
   0        6
  U%	���=+?9�             _=    I;  -0     ;  -0       ;  -0       ' (- .     >  - .        ;  -0       ;   
   F;            
   W
   U$%-   
      .        ' (       F; - .        6
  U%- 0     6?��            
   W-    N.        ' ( G;   	���=+?��              '(
'(          �B    Oc
P' (                TBN    7!  (       7!  (    7    O    7!  (-	    ?P    7    N    0       6    7               AN    7!  (-	    ?P�   0     6
  U%       7!  (-	      ?P    7    O    0       6-	      ?PZ    0     6         -    
   .     ' (- 0     6-
    0       6-	    ?
    0     6
  U%- 0       6-
    0       6- 0       6             -0       >  -0       < � !  (-0        '(-
   
   
   
   0      ' ( 
  F; -4     6-0        6!  (-0      >     _=    ;   X
   V     <  �       �  �       �  �     �  �     �  B     �  ]     X        �  �      D  \     �  �	      �  �	      0  . � �   �  >�  �      �  P  B�  �  �  �  @  �  �  d  \�  �  �    �  �  n  ��  �  �  0  �  ��  �    B  �  	  �  �  �       �    =  z  <  N  �  �     +�   �  ��  �  O�  �  ]�  �  ��  
  ��    T  p  �  �  H  ^  �  \  �  �  �  �    *  ��   $  	�  b  /	�  �  j	�   �  �  �	�   �  �  �	�     �	�     �    �	�  k  W  �  �	�  z  '  �      �	�   �  
�  �  
�  �  �  <  3

 �  �  L  ��  �    ��     3  m  X
�  o  [  �
�   �  >  o  �  2     �
�  �  �
�  �  �  �  �   �  .�    ��  7  ��   r  ��   �  ��   �  ��  �  ��  �  �   �  �	�    h�    �  o�  N  �  ��   �  ��  �  ��    �
 c  G�  �  [
 �  j
 �  �  �  � >  � @  �  D  �  �  �  �  �  �  �  �  �  �  �  �  �  !�  �  �  ( �  P�  0  f    u
  �  �   �  �  t  ~  T  �*  4  �  �  �  �      �  �  �  �  �  l  v    �
:  B  
    N  V  �  �  .  6  � F  � N   Z  d  ^  h  T  �     ' d  �  �    R �  �    t  �  k    �  $  �  �  |  B  *  z   � Z  � b  B  �  � �  � �  �  � :  ��  �  2  � �  �  ��  �    2  ~  �  �  �  8  D  �    �  �  �  "  �	 �  �    6  �  �  �  <  &  � �  &   �  1 �  
  ? �  ^ �  x �    �   �   4  �   � $  � *  P   >  p  & F  < L  ^  P T  i Z  l  ~ b  � h  z  � v  �  � �  � �  	 �  �   �  4 �  �  G �  B  \ �  u �  � �  �   �   �     .  E <  j J  � X  � f  � t  � �  ! �  H �  n�  X  d  �  `  �  �  �  �  �  �  �    ~  �  u�  P  �  8  �  �  �  �     8  ^  f  |�  �  ��  ��  ��  �  ��  �  ��  �  ��  �  � �  �  .  � �   >  �  H  n  �  �  �    L  �  �  �  �        4  L  b  z  �  �  z  �    &�  ,  h    �  4 �  C �  h�  n�  w�  ��  ��  ��  ��  �  ��  �    �  L  �  �   � H  � P  	 `  &	 l  ~  D  X  (	 �  4  8	 �  �  �    `	 �  �  �    b	 �  {	�  4  >  J  T  �	�  \  �  �	�    �	   C
 �    �  �  �  K
 b  V  g
 �  �
 �    �
 �  h  �  �
 Z  �
 P  �
 v  �
 �   �  7 �  E �  L �  a �  j &  �Z  �^  f  , �  1 �  =F  EH  I�  T�  `�  y�  � �  � �  � �  �   �4  �6   r  �  ( v  6 z  < ~  ��  �  � �  