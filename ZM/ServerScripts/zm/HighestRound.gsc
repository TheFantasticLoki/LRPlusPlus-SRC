�GSC
     �  �  8  �  >  �  �  �    @ \ 	         C:/Users/astey/Documents/Black Ops 2 - GSC Studio/GSC Fast Compiler/ServerScripts/zm/HighestRound.gsc init HRTracker  isdvarallowed high_round_tracker onplayerconnect player connecting high_round_info gamemode map path file text highroundinfo players i _k1 _a1 high_round_info_giver ui_gametype gamemodename script mapname zm_transit zsurvival ui_zm_mapstartlocation startlocationname fs_basepath / fs_basegame basepath /logs/ HighRound.txt r fopen fread fclose ; strtok int highround highroundplayers end_game round_number get_players name , New Record: ^1 tell Set by: ^1 log_highround_record newrecord w fputs location cornfield Cornfield diner Diner farm Farm power Power town Town transit BusDepot tunnel Tunnel zm_buried Buried zm_highrise DieRise zm_prison MOTD zm_nuked Nuketown zm_tomb Origins Tranzit CUSTOM_MAP 1 MOTDBridge 2 MOTDRooftop Nacht legacy LegacyNacht DinerSurvival 3 BusRide 4 BurningForest 5 Lab NA zstandard Standard zclassic Classic Survival zgrief Grief zcleansed Turned roundmultiplier start_of_round High Round Record for this map: ^1 Record set by: ^1 maps/mp/zombies/_zm_score maps/mp/zombies/_zm_unitrigger maps/mp/zombies/_zm_spawner maps/mp/zombies/_zm_weap_cymbal_monkey maps/mp/zombies/_zm_laststand maps/mp/zombies/_zm_magicbox maps/mp/zombies/_zm_game_module maps/mp/zombies/_zm_audio maps/mp/zombies/_zm_sidequests maps/mp/zombies/_zm_powerups maps/mp/zombies/_zm_perks maps/mp/zombies/_zm maps/mp/zombies/_zm_stats maps/mp/zombies/_zm_weapons maps/mp/zombies/_zm_utility maps/mp/gametypes_zm/_damagefeedback maps/mp/gametypes_zm/_gv_actions maps/mp/gametypes_zm/_hostmigration maps/mp/gametypes_zm/_spawnlogic maps/mp/gametypes_zm/_weapons maps/mp/gametypes_zm/_hud_message maps/mp/gametypes_zm/_hud_util maps/mp/animscripts/shared maps/mp/animscripts/utility maps/mp/animscripts/zm_utility maps/mp/animscripts/zm_combat maps/mp/_utility scripts/zm/zm_bo2_bots common_scripts/utility z  �  �  �  �    1  Q  k  �  �  �  �  �    '  L  m  �  �  �  �    ,  H  g  �  �  �      &-
   .     9> 
   hF;  -2       6-4        6         
   U$ %- 4       6?��                              -2      6-
   h.        '
(-   .       '	(    
   F=	 
   h
  F; -
  h.      '	(
  h
  N
  hN
   N!   (    
   N	N
N
  N'(-
  .       '(-.     '(-.     6-
   .       '(-.       !  (!  (
  U%       I;� 
   !  (-.       '('(SH;>    
   F; 7    !  (?    
   N7   N!   ('A? ��   ' ( p'(_; :  '(-
     N0      6-
      N0      6 q'(?��-    
   N    N.      6?#�                  -
  h.      '(-   .       '(    
   F=	 
   h
  F; -
  h.      '(
  h
  N
  hN
   N!   (    
   NNN
  N'(-
  .       ' (- .       6- .       6          
   F; 
   ?i  
   F; 
   ?W  
   F; 
   ?E  
   F; 
   ?3  
   F; 
   ?!  
   F; 
   ?  
   F; 
           
   F; 
   ?S 
   F; 
   ?A 
   F; 
   ?/ 
   F; 
   ? 
   F; 
   ? 
   F; 
   ?�  
   F=	 
   h
  F; 
   ?�  
   F=	 
   h
  F; 
   ?�  
   F=	 
   h
  F; 
   ?�  
   F=	 
   h
  F=	 
   h
  F; 
   ?u  
   F=	 
   h
  F; 
   ?W  
   F=	 
   h
  F; 
   ?9  
   F=	 
   h
  F; 
   ?  
   F=	 
   h
  F; 
   
            
   F; 
   ?E  
   F; 
   ?3  
   F; 
   ?!  
   F; 
   ?  
   F; 
   
                 '('(
   W; n 
   U%    PF; T 'A    ' ( p'(_; <  '(-
     N0        6-
      N0      6 q'(?��? ��        &+-
     N0     6-
      N0       6     <  �       t  �       �  �       l
  ~        �     �  {       g     |  E        �   � �  B  � �   X  � �   c  � �   �  E�   �  g�  �  }
  {�  �  �
  ��  �  �
  ��  8	  �
  �  F	  �  R	    �  `	  �  p	  L�   �	  n�  !
  5
  �  �  "  4  ~�  Y
  ��    �  @  N  � v  �  �  �  z  	�  p
    �  r
  �  �  t
  �  v
   �  %�  ~  3�  �	  �  ;�  =�  �  A�  �  [ �  �  z
  �
  t�  �  �
  �
  �	 �  �
    T  r  �  �  �  �  � �  �
  D  � �  �
  � 	  �
  � 	  	  �
  �
  � 	  �
  �	  	  �
  �
  � "	  �
  � ,	  �
  � 4	   \	  P
  z	  �	  �    %
�	  �	  �	  �	  �	  �	  0
  V
  �  0  6 �	  �  ?�	  
  L
  �  �  �	  �	  X�	  �	  ] �	  _ 
  s ,
  �n
  � �
  �"  � (  � 0  � :  � B  � L  � T  � ^  � f  � p  � x  � �  � �  � �   �   �   �   �  * �  2 �    6  < �  A �  J �  S �  [ �  c   k    >  \  z  �  �  �  �  v $  `  ~  �  x ,  � B  �  � J  � h  � �  � �  � �  � �  � �  � �  � �  �   � 
  �   t  �    � (  � 2  � :  � L   V   ^   h   p  &�  6 �  E �    h �  ,  