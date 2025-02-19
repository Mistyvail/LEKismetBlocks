A collection of custom Kismet Blocks for sequences in Mass Effect Legendary Edition.

## Adding blocks to Sequence Editor
With ![Legendary Explorer](https://github.com/ME3Tweaks/LegendaryExplorer), open the *Sequence Editor*. On the top left of the editor, open the *Experiments* tab, select *Load Custom Sequence Objects from Package*, and find the downloaded KismetBlocks.pcc's. They can then be found in the *Sequence Object Toolbox*.

This needs to be repeated every new Legendary Explorer session.

## LE1 Blocks
- **SFXSeqCond_GetPlayerClass**
    - Checks Player Pawns Class (Adept, Vanguard, etc), and activates the corresponding output.
- **SFXSeqCond_IsDLCInstalled**
    - Checks if a DLC is installed by finding its tlk.
- **SFXSeqAct_SetPawnAppearance**
    - Changes a BioPawns Meshes, Materials, and Material Parameters.
    - Material Parameters will be applied to all skeletal components; it's not limited to new meshes.
- **SFXSeqAct_SetPawnMesh**
    - Targets a BioPawns Component and changes its Mesh and associated materials.
	- The *m_eBioPawnComponent* variable determines which component.
- **SFXSeqAct_SetPawnMaterials**
    - Targets a BioPawns Component and changes its Materials.
	- The *m_eBioPawnComponent* variable determines which component.
- **SFXSeqAct_SetPawnMaterialParameters**
    - Targets a BioPawns Component and changes its Vector, Scalar, and Texture Parameters.
	- The *m_eBioPawnComponent* variable determines which component; if None, applies to all.
- **SFXSeqAct_UpdateActorAppr**
    - Changes a Pawns default appearance when spawned through its ActorType.
	- Determines where the assets needed to spawn the pawn are loaded from.
    - The *m_eAppearance* variable determines which appearance to update.
	- *m_eArmorType* is 0-4 (NKD, CTH, LGT, MED, HVY)
	- Contains a check when updating the body or headgear if *m_sMeshPackage* and *m_sMaterialPackage* can be loaded before updating.
	    - Requires the packages to be setup with the correct path and exportflags.
		    - `m_sMeshPackage.[ArmorType][Variant].[Prefix]_[ArmorType][Variant]_(MDL/MAT_1a)]`
		- It will attempt to load the path 3 times with different variants a-b-c.
	    - The check can be skipped by setting *m_bVerifyPackage* to false.
- **SFXSeqAct_UpdateActorApprSettings**
    - Changes a Pawns default appearance settings when spawned through its ActorType.
	- Determines which specific assets need to load when the pawn is spawned.
    - The *m_eSetting* variable determines which setting to update.
	- *m_eArmorType* is 0-4 (NKD, CTH, LGT, MED, HVY); m_nModel and m_nMaterial are translated to letters (0=a,1=b,etc).
- **SFXSeqAct_GiveWeapon**
    - Spawns a new weapon for a Pawn.
	- A weapon can be spawned using the *m_eWeapon* variable, or a specific weapon using *m_sLabel*.
	    - Labels are in `Engine.BIOG_2DA_Equipment_X.Items_Items`
    - *m_eWeapon* is 0-3 (Pistol, Shotgun, Assault Rifle, Sniper Rifle)
    - *m_nManufacturer* and *m_nLevel* sets weapon stats and level.
	    - Valid Manufacturer IDs are found in the *StatsClassBindings* array in the *BioWeaponRanged* Class.
- **SFXSeqAct_SetWeaponVariant**
    - Changes the appearance of a Pawns or SkeletalMeshActor weapon.
	- Variants are the meshes and materials that weapons have for different manufacturers.
	    - They can be found at `BIOC_Materials.BIOG_WPN_ALL_MASTER_L.Appearance` in the weapon types *m_variants* array.
	- *m_eWeapon* is 0-3 (Pistol, Shotgun, Assault Rifle, Sniper Rifle)
	- *m_Override* can overwrite any or all properties after the variant is applied.
	
	
## LE2 Blocks
- **SFXSeqCond_GetPlayerClass**
    - Checks Player Pawns Class (Adept, Vanguard, etc), and activates the corresponding output.
- **SFXSeqAct_SetPawnAppearance**
    - Changes a BioPawns Meshes, Materials, and Material Parameters.
    - Material Parameters will be applied to all skeletal components; it's not limited to new meshes.
- **SFXSeqAct_SetPawnMesh**
    - Targets a BioPawns Component and changes its Mesh and associated materials.
    - The *m_eBioPawnComponent* variable determines which component.
- **SFXSeqAct_SetPawnMaterials**
    - Targets a BioPawns Component and changes its Materials.
    - The *m_eBioPawnComponent* variable determines which component.
- **SFXSeqAct_SetPawnMaterialParameters**
    - Changes a BioPawns Vector, Scalar, and Texture Parameters.
    - The *m_eBioPawnComponent* variable determines which component; if None, applies to all.
- **SFXSeqAct_SetActorAppearance**
    - Changes a SkeletalMeshActors Meshes, Materials, and Material Parameters.
    - Material Parameters will be applied to all skeletal components; it's not limited to new meshes.
	- Works on SFXSkeletalMeshActors, SFXSkeletalMeshActorMATs, and SkeletalMeshActors.
- **SFXSeqAct_SetActorMesh**
    - Targets a SkeletalMeshActors Component and changes its Mesh and associated materials.
    - The *m_eBioPawnComponent* variable determines which component.
	- Works on SFXSkeletalMeshActors, SFXSkeletalMeshActorMATs, and SkeletalMeshActors.
- **SFXSeqAct_SetActorMaterials**
    - Targets a SkeletalMeshActors Component and changes its Materials.
    - The *m_eBioPawnComponent* variable determines which component.
	- Works on SFXSkeletalMeshActors, SFXSkeletalMeshActorMATs, and SkeletalMeshActors.
- **SFXSeqAct_SetActorMaterialParameters**
    - Changes a SkeletalMeshActors Vector, Scalar, and Texture Parameters.
    - Can either target a SkeletalMeshActors Component or if the enum is "None", applies to all.
	- Works on SFXSkeletalMeshActors, SFXSkeletalMeshActorMATs, and SkeletalMeshActors.
- **SFXSeqAct_FindWeaponClass**
    - Finds Weapon Classes with a SeekFree path rather than requiring it in the package.
- **SFXSeqAct_FindImage**
    - Finds Textures with a SeekFree path rather than requiring it in the package.
    - Optimally for menu sequences.
    
## LE3 Blocks
- **SFXSeqCond_GetPlayerClass**
    - Checks Player Pawns Class (Adept, Vanguard, etc), and activates the corresponding output.
- **SFXSeqAct_SetActorAppearance**
    - Changes a SkeletalMeshActors Meshes, Materials, and Material Parameters.
    - Material Parameters will be applied to all skeletal components; it's not limited to new meshes.
	- Works on SFXStuntActors, SFXSkeletalMeshActors, SFXSkeletalMeshActorMATs, SkeletalMeshActors, and SkeletalMeshActorMATs.
- **SFXSeqAct_SetActorMesh**
    - Targets a SkeletalMeshActors Component and changes its Mesh and associated materials.
    - The *m_eBioPawnComponent* variable determines which component.
	- Works on SFXStuntActors, SFXSkeletalMeshActors, SFXSkeletalMeshActorMATs, SkeletalMeshActors, and SkeletalMeshActorMATs.
- **SFXSeqAct_SetActorMaterials**
    - Targets a SkeletalMeshActors Component and changes its Materials.
    - The *m_eBioPawnComponent* variable determines which component.
	- Works on SFXStuntActors, SFXSkeletalMeshActors, SFXSkeletalMeshActorMATs, SkeletalMeshActors, and SkeletalMeshActorMATs.
- **SFXSeqAct_SetActorMaterialParameters**
    - Changes a SkeletalMeshActors Vector, Scalar, and Texture Parameters.
    - The *m_eBioPawnComponent* variable determines which component; if None, applies to all.
	- Works on SFXStuntActors, SFXSkeletalMeshActors, SFXSkeletalMeshActorMATs, SkeletalMeshActors, and SkeletalMeshActorMATs.

  
